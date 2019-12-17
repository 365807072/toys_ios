
//
//  PostBarNewDetialV1VC.m
//  BabyShow
//
//  Created by WMY on 16/4/20.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarNewDetialV1VC.h"
#import "PostBarDetailNewUserItem.h"
#import "PostBarDetailNewDescribeItem.h"
#import "PostBarDetailNewPhotoItem.h"
#import "PostBarDetailDescribeCell.h"
#import "BBSEmojiInfo.h"
#import "Emoji.h"

#import "SDWebImageManager.h"
#import "PostBarNewDetailV1AdmireCell.h"
#import "PostBarDetailReviewUserItem.h"
#import "PostBarDetailReviewDescrible.h"
#import "PostBarDetailReviewPhoto.h"
#import "PostBarNewReviewsDescribleCell.h"

#import "MyShowImageItem.h"
#import "ShowAlertView.h"
#import "MyHomeNewVersionVC.h"
#import "PostMyGroupDetailVController.h"
#import "BBSNavigationController.h"
#import "UIButton+WebCache.h"
#import "NIAttributedLabel.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "StoreDetailNewVC.h"
#import "WebViewController.h"
#import "PostBarNewMakeSecondVC.h"
#import "PostBarListNewVC.h"
#import "PostBarGroupNewVC.h"
#import "RecommendListItem.h"
#import "RecommendCell.h"
#import "BabyShowPlayerVC.h"
#import "PostBarNewReview_ReviewUserItem.h"
#import "ReviewReviewCell.h"
#import "IsReviewItem.h"
#import "PostBarNewGroupOnlyOneVC.h"
#import "BabyShowPlayerVC.h"

static int PHOTO=3000;
@interface PostBarNewDetialV1VC (){
    UITableView *_firstTableView;
    UITableView *_secondTableView;
    RefreshControl *_refreshControl;
    NSString *_postCreateTime;
    NSMutableArray *_postDataArray;
    NSArray *facesArray;
    NSDictionary *facesDictionary;
    UIView *_headrView;
    UILabel *_titleLabel;
    UIImageView *_avatarImg;
    UILabel *_userNameLabel;
    UILabel *_postcreatTimeLable;
    UIButton *_originalTextBtn;
    NSMutableArray *_reviewDataArray;
    NSMutableArray *_PhotoArray;
    NSMutableArray *_clickPhotoArray;
    NSMutableArray *_recommendArray;//推荐的数组
    NSIndexPath *_reviewIndexPath;
    
}
@property(nonatomic,strong)UIButton *shareBtn;
@property(nonatomic,strong)NSString *titleString;//文章标题
@property(nonatomic,strong)NSString *avatarString;//用户头像
@property(nonatomic,strong)NSString *userNameString;//楼主名
@property(nonatomic,strong)NSString *timeString; //时间节点
@property(nonatomic,strong)UIButton *clickBtn;//点击头像
@property(nonatomic,strong)UIButton *addFriendBtn;//加好友
@property(nonatomic,strong)UIButton *groupBtn;
@property(nonatomic,strong)NSString *groupName;//来自哪个群群名
@property(nonatomic,assign)BOOL isAdmirePost; //对主贴是否赞啦
@property(nonatomic,assign)NSInteger mainAdmireCount; //主贴的赞数
@property(nonatomic,strong)NSString *userNewId;
@property(nonatomic,strong)NSString *is_idol;//关注状态（0没关注、1关注过、2不用关注【用户ID为-999】）
@property(nonatomic,strong)NSString *group_tag_id;//群ID（或标签ID）
@property(nonatomic,strong)NSString *is_group_tag;//群标签状态（0群和标签都没有、1群、2标签）
@property(nonatomic,strong)NSString *imgID;//图片的imgid
@property(nonatomic,strong)NSString *postUrl;//外链的地址
@property(nonatomic,strong)NSString *business_id;//商家ID
@property(nonatomic,strong)NSString *is_link;//外链状态（0没有链接、1外链出去、2商家）
@property(nonatomic,strong)NSString *linkName;//外链的名字
@property(nonatomic,strong)NSString *is_save;//收藏状态（0未收藏，1已收藏）
@property(nonatomic,strong)UIButton *editBtn;//编辑按钮，用户本人显示
@property(nonatomic,assign)BOOL isRequest;
//跳转视频相关字段
@property(nonatomic,strong)NSString *video_img_thumb;
@property(nonatomic,strong)NSString *video_img_thumb_width;
@property(nonatomic,strong)NSString *video_img_thumb_height;
@property(nonatomic,strong)NSString *video_url;
@property(nonatomic,strong)NSString *video_user_id;

//对于评论的评论
@property(nonatomic,strong)NSString *sectionIndexReviewId;

@end

@implementation PostBarNewDetialV1VC

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //网络失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    //对本帖发布用户添加关注或取消关注
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusSucceed) name:USER_FOCUS_ON_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusFail:) name:USER_FOCUS_ON_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFocusSucceed) name:USER_CANCEL_FOCUS_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFocusFail:) name:USER_CANCEL_FOCUS_FAIL object:nil];

    //收藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SaveSucceed:) name:USER_POSTBAR_ADDTOBEMYFOCUS_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SaveFail:) name:USER_POSTBAR_ADDTOBEMYFOCUS_FAIL object:nil];
    
    //取消收藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SaveSucceed:) name:USER_POSTBAR_CANCELFOCUS_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SaveFail:) name:USER_POSTBAR_CANCELFOCUS_FAIL object:nil];
    
    //赞
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PraiseSucceed:) name:USER_MYSHOWPRAISE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PraiseFail:) name:USER_MYSHOWPRAISE_FAIL object:nil];
    
    //取消赞
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PraiseSucceed:) name:USER_MYSHOWCANCELPRAISE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PraiseFail:) name:USER_MYSHOWCANCELPRAISE_FAIL object:nil];
    
    //评论
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewSucceed:) name:USER_REVIEW_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewFail:) name:USER_REVIEW_FAIL object:nil];
    
    //对主贴的评论
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeAPostSucceed:) name:USER_POST_REVIEW_MAKE_A_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeAPostFail:) name:USER_POST_REVIEW_MAKE_A_FAIL object:nil];
    
    //如果编辑了，就刷新
    if (theAppDelegate.isHaveNewEditPost == YES) {
        [self getPostData];
    }
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (!_postDataArray) {
        _postDataArray = [NSMutableArray array];
    }
    if (!facesArray) {
        facesArray = [[NSArray alloc]initWithArray:[Emoji allEmoji]];
        
    }
    if (!facesDictionary) {
        facesDictionary = [[NSDictionary alloc]initWithDictionary:[Emoji allEmojiDictionary]];
    }
    if (!_reviewDataArray) {
        _reviewDataArray = [NSMutableArray array];
    }
    if (!_PhotoArray) {
        _PhotoArray = [NSMutableArray array];
    }
    if (!_clickPhotoArray) {
        _clickPhotoArray = [NSMutableArray array];
    }
    if (!_recommendArray) {
        _recommendArray = [NSMutableArray array];
    }
    self.navigationItem.title = @"话题详情";
    theAppDelegate.isHaveNewEditPost = NO;
    
    _isRefreshInVC = NO;
    [self setHeaderView];
    [self setSecondTableView];
    [self refreshControlInit];
    [self setbackBtn];
    [self setRightBtn];
    [self setToolBar];
    [self setEditBtnFrame];
    
}
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated{
    // [self.toolBaView moveDown];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [LoadingView stopOnTheViewController:self];
    
    
    
}
-(void)setToolBar{
    _toolBaView = [[PostBarNewReplyView alloc]init];
    _toolBaView.delegate = self;
    [self.view addSubview:_toolBaView];
    
}
-(void)setEditBtnFrame{
    self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editBtn.frame = CGRectMake(267-10, SCREENHEIGHT-160, 55,55);
    [self.editBtn setBackgroundImage:[UIImage imageNamed:@"post_edit"] forState:UIControlStateNormal];
    [self.view addSubview:self.editBtn];
}
#pragma mark 头部信息
-(void)setHeaderView{
    _headrView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREENWIDTH, 0)];
    _headrView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _titleLabel = [[UILabel alloc]init];
    [_headrView addSubview:_titleLabel];
    
    _avatarImg = [[UIImageView alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+_titleLabel.frame.size.height+14, 15, 15)];
    _avatarImg.layer.masksToBounds = YES;
    _avatarImg.layer.cornerRadius = 15;
    _avatarImg.userInteractionEnabled = YES;
    [_headrView addSubview:_avatarImg];
    
    _userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(_avatarImg.frame.origin.x+_avatarImg.frame.size.width+7, _avatarImg.frame.origin.y, 200, 17)];
    [_headrView addSubview:_userNameLabel];
    
    _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_clickBtn addTarget:self action:@selector(pushHomepage) forControlEvents:UIControlEventTouchUpInside];
    [_headrView addSubview:_clickBtn];
    
    _addFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addFriendBtn addTarget:self action:@selector(addFriendAction) forControlEvents:UIControlEventTouchUpInside];
    [_headrView addSubview:_addFriendBtn];
    
    _postcreatTimeLable = [[UILabel alloc]initWithFrame:CGRectMake(_userNameLabel.frame.origin.x, _userNameLabel.frame.origin.y+_userNameLabel.frame.size.height+6.5, 150, 13)];
    [_headrView addSubview:_postcreatTimeLable];
    
    _groupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_headrView addSubview:_groupBtn];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [_headrView addGestureRecognizer:singleTap];
    
    
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [self moveDowToolBar];
    [_toolBaView changetoPostToolBar];
    
}

//布局评论的view
-(void)setSecondTableView{
    _secondTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-40)];
    _secondTableView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _secondTableView.delegate = self;
    _secondTableView.dataSource = self;
    _secondTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:_secondTableView];
    
}

-(void)setbackBtn{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
        [_backBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];

    }else{
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];

    }
    
}
-(void)setRightBtn{
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.shareBtn.frame = CGRectMake(0, 0, 19, 3);
    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"post_bar_detail_share"] forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(sharePostDetail) forControlEvents:UIControlEventTouchUpInside];
    [_headrView addSubview:self.shareBtn];
    
}

#pragma mark- refreshControl

-(void)refreshControlInit{
    _refreshControl                             = [[RefreshControl alloc] initWithScrollView:_secondTableView delegate:self];
    _refreshControl.topEnabled                  = YES;
    _refreshControl.bottomEnabled               = NO;
    [_refreshControl startRefreshingDirection:RefreshDirectionTop];
    
}
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    if (refreshControl == _refreshControl) {
        if (direction == RefreshDirectionTop) {
            _postCreateTime = NULL;
            [self getPostData];//主贴的数据
            [self getRecommendPost];
        }
        [self getReviewData];
    }
}
-(void)refreshComplete :(RefreshControl *)refreshControl{
    if (refreshControl.refreshingDirection==RefreshingDirectionTop)
    {
        [refreshControl finishRefreshingDirection:RefreshDirectionTop];
    }
    else if (refreshControl.refreshingDirection==RefreshingDirectionBottom)
    {
        [refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
    }
}
#pragma mark 主贴的数据
-(void)getPostData{
    NSDictionary *ParamDic=[NSDictionary dictionaryWithObjectsAndKeys:
                            LOGIN_USER_ID,@"login_user_id",
                            self.img_id,@"img_id",nil];
    
    SDWebImageManager *manager=[SDWebImageManager sharedManager];
    
    UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kListingDetail Method:NetMethodGet andParam:ParamDic];
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    
    __weak ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        [_postDataArray removeAllObjects];
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:@"success"]integerValue] == 1) {
            NSArray *dataArray = [dic objectForKey:@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
            for (NSDictionary *dataDic in dataArray) {
                NSDictionary *imgDic = [dataDic objectForKey:@"img"];
                //文章标题一系列信息
                self.titleString =  MBNonEmptyString(imgDic[@"img_title"]);
                self.avatarString =  MBNonEmptyString(imgDic[@"avatar"]);
                self.userNameString =  MBNonEmptyString(imgDic[@"user_name"]);
                self.timeString =  MBNonEmptyString(imgDic[@"create_time"]);
                self.userNewId =  MBNonEmptyString(imgDic[@"user_id"]);
                self.groupName =  MBNonEmptyString(imgDic[@"group_tag_name"]);
                self.isAdmirePost = [ MBNonEmptyString(imgDic[@"is_admire"])boolValue];
                self.mainAdmireCount = [MBNonEmptyString(imgDic[@"main_admire_count"])integerValue];
                self.is_idol = MBNonEmptyString(imgDic[@"is_idol"]);
                self.imgID = MBNonEmptyString(imgDic[@"img_id"]);
                self.postUrl = MBNonEmptyString(imgDic[@"post_url"]);
                self.group_tag_id = MBNonEmptyString(imgDic[@"group_tag_id"]);
                self.is_group_tag = MBNonEmptyString(imgDic[@"is_group_tag"]);
                self.is_link = MBNonEmptyString(imgDic[@"is_link"]);
                self.linkName = MBNonEmptyString(imgDic[@"link_name"]);
                self.business_id = MBNonEmptyString(imgDic[@"business_id"]);
                self.is_save = MBNonEmptyString(imgDic[@"is_save"]);
                self.video_img_thumb = MBNonEmptyString(imgDic[@"video_img_thumb"]);
                self.video_img_thumb_width = MBNonEmptyString(imgDic[@"video_img_thumb_width"]);
                self.video_img_thumb_height = MBNonEmptyString(imgDic[@"video_img_thumb_height"]);
                self.video_url =  MBNonEmptyString(imgDic[@"video_url"]);
                self.video_user_id = MBNonEmptyString(imgDic[@"video_user_id"]);
                
                //是否收藏
                if ([self.is_save isEqualToString:@"1"]) {
                    [_toolBaView savePostBtn:YES];
                }else{
                    [_toolBaView savePostBtn:NO];
                }
                NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:20],NSParagraphStyleAttributeName:paragraphStyle.copy};
                CGSize size=[self.titleString boundingRectWithSize:CGSizeMake(SCREENWIDTH-15*0.7*2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                float height=size.height;
                if (self.titleString.length > 0) {
                    if (height < 20&&height>0) {
                        height = 20;
                        _titleLabel.frame = CGRectMake(10*0.6, 27.5*0.72, SCREENWIDTH-10*0.6*2, height);
                    }else{
                        height = height;
                        _titleLabel.frame = CGRectMake(10*0.6, 27.5*0.72, SCREENWIDTH-10*0.6*2, height);
                        
                    }
                }else{
                    height = 0;
                    _titleLabel.frame = CGRectMake(10*0.6, 0, SCREENWIDTH-10*0.6*2, height);
                    
                }
                _titleLabel.font = [UIFont systemFontOfSize:20];
                _titleLabel.numberOfLines = 0;
                _titleLabel.textColor = [BBSColor hexStringToColor:@"333333"];
                [manager downloadImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",self.avatarString]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    _avatarImg.image = image;
                }];
                _titleLabel.text = self.titleString;
                _avatarImg.frame = CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+_titleLabel.frame.size.height+14*0.72, 30, 30);
                
                //用户头像
                _userNameLabel.frame = CGRectMake(_avatarImg.frame.origin.x+_avatarImg.frame.size.width+7, _avatarImg.frame.origin.y, SCREENWIDTH-95-_userNameLabel.frame.origin.x, 15);
                _userNameLabel.text = self.userNameString;
                 CGRect nameFrame = _userNameLabel.frame;
                 CGSize sizes = [self.userNameString boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:_userNameLabel.font} context:nil].size;
                _userNameLabel.font = [UIFont systemFontOfSize:13];
                _userNameLabel.textColor = [BBSColor hexStringToColor:@"666666"];
                //关注按钮的显示
                if ([self.is_idol isEqualToString:@"2"] ) {
                   //不用关注用户是-999
                    _addFriendBtn.frame = CGRectMake(6,_titleLabel.frame.origin.y+_titleLabel.frame.size.height+14*0.72+40, 61, 28);
                    [_addFriendBtn setBackgroundImage:[UIImage imageNamed:@"post_bar_cancle_friend"] forState:UIControlStateNormal];
                    _addFriendBtn.enabled = NO;
                    self.shareBtn.frame = CGRectMake(_addFriendBtn.frame.origin.x+_addFriendBtn.frame.size.width+22, _addFriendBtn.frame.origin.y, 61,28);
                }else{
                    
                if (sizes.width < 65) {
                    sizes.width = 65;
                }
                _addFriendBtn.frame = CGRectMake(6,_titleLabel.frame.origin.y+_titleLabel.frame.size.height+14*0.72+40, 61, 28);
                    if ([self.is_idol isEqualToString:@"0"]) {
                        //没关注过
                        [_addFriendBtn setBackgroundImage:[UIImage imageNamed:@"post_bar_add_friendnew"] forState:UIControlStateNormal];
                        

                    }else if([self.is_idol isEqualToString:@"1"]){
                        //已经关注过了
                    [_addFriendBtn setBackgroundImage:[UIImage imageNamed:@"post_bar_cancle_friend"] forState:UIControlStateNormal];
                    }
                    self.shareBtn.frame = CGRectMake(_addFriendBtn.frame.origin.x+_addFriendBtn.frame.size.width+22, _addFriendBtn.frame.origin.y, 61, 28);
                }
                
                
                _clickBtn.frame = CGRectMake(0, _avatarImg.frame.origin.y, 200, 20);
                //发布时间
                _postcreatTimeLable.textColor = [BBSColor hexStringToColor:@"999999"];
                _postcreatTimeLable.font = [UIFont systemFontOfSize:11];
                _postcreatTimeLable.frame = CGRectMake(_userNameLabel.frame.origin.x, _userNameLabel.frame.origin.y+_userNameLabel.frame.size.height+3, 150, 13);
                _postcreatTimeLable.text = self.timeString;
                //设置标签群
                if ([self.is_group_tag isEqualToString:@"0"]) {
                    _groupBtn.hidden = YES;
                }else{
                    NSString *groupNameTitle;
                    _groupBtn.hidden = NO;
                    _groupBtn.frame = CGRectMake(SCREENWIDTH-141-6, _addFriendBtn.frame.origin.y, 141, 28);
                    [_groupBtn setBackgroundImage:[UIImage imageNamed:@"post_bar_come_from_group"] forState:UIControlStateNormal];
                    [_groupBtn setTitle:groupNameTitle forState:UIControlStateNormal];
                    _groupBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 2, 0, 1);
                    _groupBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                    
                    [_groupBtn setTitleColor:[BBSColor hexStringToColor:@"333333"] forState:UIControlStateNormal];

                    if ([self.is_group_tag isEqualToString:@"1"]) {
                        //群
                       groupNameTitle = [NSString stringWithFormat:@"来自群-%@",self.groupName];
                        [_groupBtn addTarget:self action:@selector(pushGroupPostBar) forControlEvents:UIControlEventTouchUpInside];
                    }else if ([self.is_group_tag isEqualToString:@"2"]){
                        //标签
                        groupNameTitle = [NSString stringWithFormat:@"%@",self.groupName];
                        [_groupBtn addTarget:self action:@selector(pushTagPostList) forControlEvents:UIControlEventTouchUpInside];
                    }else if ([self.is_group_tag isEqualToString:@"3"]){
                        //帖子详情
                        groupNameTitle = [NSString stringWithFormat:@"%@",self.groupName];
                        [_groupBtn addTarget:self action:@selector(pushDetailPostBar) forControlEvents:UIControlEventTouchUpInside];
                    }else if ([self.is_group_tag isEqualToString:@"4"]){
                        groupNameTitle = [NSString stringWithFormat:@"%@",self.groupName];
                        [_groupBtn addTarget:self action:@selector(pushVideo) forControlEvents:UIControlEventTouchUpInside];

                    }
                    [_groupBtn setTitle:groupNameTitle forState:UIControlStateNormal];

                    
                }
                //编辑按钮
                if ([LOGIN_USER_ID intValue] == [self.userNewId intValue]) {
                    _editBtn.hidden = NO;
                    [_editBtn addTarget:self action:@selector(pushPostNewMakeSecondVC) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    _editBtn.hidden = YES;
                }
                _headrView.frame = CGRectMake(0, 0, SCREENWIDTH, _addFriendBtn.frame.origin.y+_addFriendBtn.frame.size.height+10);
                _secondTableView.tableHeaderView = _headrView;
                
                break;
            }
            for (NSDictionary *dataDic in dataArray) {
                NSMutableArray *singleArray = [NSMutableArray array];
                NSDictionary *imgDic = [dataDic objectForKey:@"img"];
                NSArray *imgArray = imgDic[@"img"];
                PostBarDetailNewDescribeItem *describeItem = [[PostBarDetailNewDescribeItem alloc]init];
                describeItem.describeString = [NSString stringWithFormat:@"%@",imgDic[@"description"]];
                describeItem.identify = @"DESCRIBE";
                if (describeItem.describeString.length) {
                    CGFloat height = [self getHeightByWidth:SCREENWIDTH-10*0.6*2 title:describeItem.describeString font:[UIFont systemFontOfSize:16]];
                    describeItem.height = height + 12;
                    [singleArray addObject:describeItem];
                }
                [_postDataArray removeAllObjects];
                for (NSDictionary *singleImgDic in imgArray) {
                    PostBarDetailNewPhotoItem *photoItem = [[PostBarDetailNewPhotoItem alloc]init];
                    photoItem.thumbString = [NSString stringWithFormat:@"%@",[singleImgDic objectForKey:@"img_thumb"]];
                    
                    photoItem.index = [imgArray indexOfObject:singleImgDic];
                    float width=[[singleImgDic objectForKey:@"img_thumb_width"] floatValue];
                    float height=[[singleImgDic objectForKey:@"img_thumb_height"] floatValue];
                    
                    photoItem.frame = CGRectMake(10*0.6, 5, SCREENWIDTH-10*0.6*2, height*(SCREENWIDTH-10*0.6*2)/width);
                    NSMutableArray *photosArray = [NSMutableArray array];
                    for (NSDictionary *dic in imgArray) {
                        NSString *clearString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"img"]];
                        [photosArray addObject:clearString];
                    }
                    photoItem.clearPhotosArray = photosArray;
                    photoItem.identify=@"PHOTO";
                    photoItem.height=photoItem.frame.size.height+10;
                    [singleArray addObject:photoItem];
                }
                
                [returnArray addObject:singleArray];
            }

            [_postDataArray addObjectsFromArray:returnArray];
            [_secondTableView reloadData];
            
        }else{
            
        }
        
    }];
    [request setFailedBlock:^{
        
    }];
    
}
-(void)pushVideo{
    BOOL isHV;//横竖屏
    float height = [self.video_img_thumb_height floatValue];
    float weight = [self.video_img_thumb_width floatValue];
    if (height > weight) {
        isHV = NO;//竖屏
    }else{
        isHV = YES;
    }
    [self pushBabyShowPlayer:self.video_url imgId:[NSString stringWithFormat:@"%@",self.group_tag_id] isHV:isHV];
}
#pragma mark 跳转视频帖子
-(void)pushBabyShowPlayer:(NSString *)video_url imgId:(NSString*)imgId   isHV:(BOOL)isHV{
    BabyShowPlayerVC *babyShowPlayerVC = [[BabyShowPlayerVC alloc]init];
    babyShowPlayerVC.img_id = imgId;
    babyShowPlayerVC.videoUrl = video_url;
    babyShowPlayerVC.isHV = isHV;
    [self.navigationController pushViewController:babyShowPlayerVC animated:YES];
}

-(void)getRecommendPost{
    NSDictionary *newParam = [NSDictionary dictionaryWithObjectsAndKeys:
                              LOGIN_USER_ID,@"login_user_id",self.img_id,@"img_id",nil];
    UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewV1UrlStr:@"getRecommendList" Method:NetMethodGet andParam:newParam];
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
    
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:15];
    [request startAsynchronous];
    __weak ASIHTTPRequest *blockRequest=request;
    
    [request setCompletionBlock:^{
        [_recommendArray removeAllObjects];
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:@"success"]integerValue]==1) {
            NSArray *dataArray = [dic objectForKey:@"data"];
            for (NSDictionary *dataDic in dataArray) {
                RecommendListItem *item = [[RecommendListItem alloc]init];
                item.img_id = MBNonEmptyString(dataDic[@"img_id"]);
                item.img_title =  MBNonEmptyString(dataDic[@"img_title"]);
                item.is_group =  MBNonEmptyString(dataDic[@"is_group"]);
                item.user_id = MBNonEmptyString(dataDic[@"user_id"]);
                item.img_thumb =  MBNonEmptyString(dataDic[@"img_thumb"]);
                item.img_thumb_width =  MBNonEmptyString(dataDic[@"img_thumb_width"]);
                item.img_thumb_height =  MBNonEmptyString(dataDic[@"img_thumb_height"]);
                item.video_url =  MBNonEmptyString(dataDic[@"video_url"]);
                [_recommendArray addObject:item];
                
            }
            
        }

    }];
    [request setFailedBlock:^{
        [self refreshComplete:_refreshControl];
    }];


    
}
-(void)getReviewData{
    NSDictionary *newParam = [NSDictionary dictionaryWithObjectsAndKeys:
                              LOGIN_USER_ID,@"login_user_id",self.img_id,@"img_id",_postCreateTime,@"post_create_time",nil];
    UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewV1UrlStr:kListingReviews Method:NetMethodGet andParam:newParam];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:15];
    [request startAsynchronous];
    __weak ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:@"success"]integerValue]==1) {
            NSArray *dataArray = [dic objectForKey:@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
            for (NSDictionary *dataDic in dataArray) {
                NSMutableArray *singleArray = [[NSMutableArray alloc]init];
                //回复者的信息
                PostBarDetailReviewUserItem *userItem = [[PostBarDetailReviewUserItem alloc]init];
                userItem.userName = dataDic[@"user_name"];
                userItem.avatar = dataDic[@"avatar"];
                userItem.postTime = dataDic[@"post_time"];
                userItem.postCreateTime = dataDic[@"post_create_time"];
                userItem.reviewCount = [dataDic[@"review_count"]integerValue];
                userItem.admireCount = [dataDic[@"admire_count"]integerValue];
                userItem.review_id = dataDic[@"review_id"];
                userItem.userId = dataDic[@"user_id"];
                userItem.identify = @"POSTBARDETAILREVIEWUSER";
                userItem.imgId = dataDic[@"img_id"];
                userItem.isAdmire = [dataDic[@"is_admire"]boolValue];
                userItem.height =55;
                [singleArray addObject:userItem];
                //回复的图片
                NSArray *photosArray = dataDic[@"img"];
                if (photosArray.count) {
                    PostBarDetailReviewPhoto *photoItem = [[PostBarDetailReviewPhoto alloc]init];
                    for (NSDictionary *photoDic in photosArray) {
                        NSString *imgThumb = [photoDic objectForKey:@"img_thumb"];
                        [photoItem.photosArray addObject:imgThumb];
                    }
                    photoItem.identify = @"POSTBARDETAILREVIEWPHOTO";
                    photoItem.height = (SCREENWIDTH-15*0.6*3-32-15)/4+10;
                    [singleArray addObject:photoItem];
                }
                //回复的内容
                PostBarDetailReviewDescrible *describleItem = [[PostBarDetailReviewDescrible alloc]init];
                describleItem.descontent = dataDic[@"demand"];
                describleItem.review_id = dataDic[@"review_id"];
                if (describleItem.descontent.length) {
                    CGFloat height = [self getHeightByWidth:SCREENWIDTH-15*0.6*3-32 title:describleItem.descontent font:[UIFont systemFontOfSize:14]];
                    describleItem.height  = height+15;
                    describleItem.identify = @"POSTBARREVIREDESCRIBLE";
                    describleItem.descontent = dataDic[@"demand"];
                    [singleArray addObject:describleItem];
                }
                //回复的回复
                NSArray *reviewReviewArray = dataDic[@"getReviewReviewList"];
                if (reviewReviewArray.count) {
                    for (NSDictionary *reviewDic in reviewReviewArray) {
                    PostBarNewReview_ReviewUserItem *reviewItem = [[PostBarNewReview_ReviewUserItem alloc]init];
                        reviewItem.review_review_id = reviewDic[@"review_review_id"];
                        reviewItem.demand = reviewDic[@"demand"];
                        reviewItem.user_id = reviewDic[@"user_id"];
                        reviewItem.user_name = reviewDic[@"user_name"];
                        reviewItem.avatar = reviewDic[@"avatar"];
                        reviewItem.level_img = reviewDic[@"level_img"];
                        reviewItem.post_create_time = reviewDic[@"post_create_time"];
                        reviewItem.review_id = dataDic[@"review_id"];
                        
                        NSString *reviewNameAndDemand = [NSString stringWithFormat:@"%@:%@",reviewItem.user_name,reviewItem.demand];
                        if (reviewItem.demand.length) {
                            CGFloat heightReview = [self getHeightByWidth:SCREENWIDTH-15*0.6*3-32-10 title:reviewNameAndDemand font:[UIFont systemFontOfSize:12]];
                            reviewItem.height= heightReview+10;
                        }else{
                            reviewItem.height= 20;

                        }
                        
                        [singleArray addObject:reviewItem];
                    }
                    //是否有更多二级回复
                    IsReviewItem *reviewItem = [[IsReviewItem alloc]init];
                    NSString *isReview = dataDic[@"is_review"];
                    NSString *review_count = dataDic[@"review_count"];
                    
                    if ([isReview isEqualToString:@"0"]) {
                        reviewItem.height = 0;
                        reviewItem.isReview = @"0";
                    }else{
                        reviewItem.height = 20;
                        reviewItem.isReview = @"1";
                        reviewItem.review_count = review_count;
                        reviewItem.imgID= dataDic[@"img_id"];;
                        reviewItem.userId = dataDic[@"user_id"];
                        reviewItem.reviewId = dataDic[@"review_id"];
                    }
                    [singleArray addObject:reviewItem];
                }
                [returnArray addObject:singleArray];
            }
            if (returnArray.count == 0) {
                _refreshControl.bottomEnabled = NO;
            }
            if (_postCreateTime == NULL) {
                [_reviewDataArray removeAllObjects];
                _refreshControl.bottomEnabled = YES;
            }
            NSArray *singleArray = [returnArray lastObject];
            PostBarDetailReviewUserItem *item = [singleArray firstObject];
            _postCreateTime = item.postCreateTime;
            [_reviewDataArray addObjectsFromArray:returnArray];
            [_secondTableView reloadData];
            [self refreshComplete:_refreshControl];
        }else{
            [self refreshComplete:_refreshControl];
        }
        
    }];
    [request setFailedBlock:^{
        [self refreshComplete:_refreshControl];
    }];
}
#pragma mark UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_reviewDataArray.count > 0) {
        return [_postDataArray count]+3+[_reviewDataArray count];
        
    }else{
        return [_postDataArray count]+2;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section < _postDataArray.count) {
        NSArray *sectionArray = [_postDataArray objectAtIndex:section];
        return sectionArray.count;
    }else if(section == _postDataArray.count){
        return 1;
    }else if(section == _postDataArray.count +1){
        return _recommendArray.count+1;
    }else if(section == _postDataArray.count+2){
        return 1;
    }else{
        NSArray *sectionArray = [_reviewDataArray objectAtIndex:section-_postDataArray.count-3];
        return sectionArray.count;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < _postDataArray.count) {
        NSArray *sectionArray = [_postDataArray objectAtIndex:indexPath.section];
        PostBarDetailNewBasicItem *item = [sectionArray objectAtIndex:indexPath.row];
        return item.height;
    }else if(indexPath.section == _postDataArray.count){
        if ([self.is_link isEqualToString:@"0"]) {
            return  10*0.6*2+(SCREENWIDTH-10*0.6*2-6*2)/3*0.32;
        }else{
            return   10*0.6*2+(SCREENWIDTH-10*0.6*2-6*2)/3*0.32+50;
        }
        
    }else if (indexPath.section == _postDataArray.count +1){
        return 45;
    }else if(indexPath.section == _postDataArray.count+2){
        return 40;
    }else{
        NSArray *sectionArray = [_reviewDataArray objectAtIndex:indexPath.section-_postDataArray.count-3];
        PostBarDetailNewBasicItem *item = [sectionArray objectAtIndex:indexPath.row];
        return item.height;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return nil;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *returnCell;
    SDWebImageManager *manager=[SDWebImageManager sharedManager];
    if (indexPath.section < _postDataArray.count) {
        NSArray *sectionArray = [_postDataArray objectAtIndex:indexPath.section];
        id obj = [sectionArray objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[PostBarDetailNewDescribeItem class]]) {
            PostBarDetailNewDescribeItem *item=(PostBarDetailNewDescribeItem *) obj;
            
            PostBarDetailDescribeCell *cell=[tableView dequeueReusableCellWithIdentifier:item.identify];
            if (!cell) {
                cell=[[PostBarDetailDescribeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.identify];
            }
            cell.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
            CGFloat height = [self getHeightByWidth:SCREENWIDTH-10*0.6*2 title:item.describeString font:[UIFont systemFontOfSize:16]];
            cell.describeLabel.frame = CGRectMake(10*0.6, 7, SCREENWIDTH-10*0.6*2, height+5);
            cell.describeLabel.text=item.describeString;
            NSDictionary *dictionary = [BBSEmojiInfo detailContentWithStringAndEmoji:cell.describeLabel.text fromArray:facesArray];
            NSString *content = [dictionary objectForKey:@"content"];
            NSArray *tNumArray = [dictionary objectForKey:@"emoji"];
            
            cell.describeLabel.text=content;
            
            for (NSInteger i = tNumArray.count-1; i >=0; i--) {
                
                NSDictionary *dict = [tNumArray objectAtIndex:i];
                int numid = [[dict objectForKey:@"location"] intValue];
                NSString * emojiText = [dict objectForKey:@"emojiText"];
                UIImage *image = [UIImage imageNamed:[facesDictionary objectForKey:emojiText]];
                [cell.describeLabel insertImage:image atIndex:(numid-i*4) margins:UIEdgeInsetsMake(-2, 0, -2, 0)];
                
            }
            
            returnCell=cell;
        }else if ([obj isKindOfClass:[PostBarDetailNewPhotoItem class]]){
            PostBarDetailNewPhotoItem *item=(PostBarDetailNewPhotoItem *) obj;
            
            PostBarDetailPhotoCell *cell=[tableView dequeueReusableCellWithIdentifier:item.identify];
            if (!cell) {
                cell=[[PostBarDetailPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.identify];
            }
            cell.delegate=self;
            cell.imgBtn.indexpath=indexPath;
            
            [cell.imgBtn setBackgroundImage:nil forState:UIControlStateNormal];
            cell.imgBtn.frame=item.frame;
            [cell.imgBtn sd_setImageWithURL:[NSURL URLWithString:item.thumbString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
            cell.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
            
            returnCell=cell;
            
        }
    }else if (indexPath.section == _postDataArray.count){
        NSString *identifier = [NSString stringWithFormat:@"POSTBARNEWDETAILV1"];
        PostBarNewDetailV1AdmireCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        cell.tag = 7888;
        NSString *string = self.linkName;

        if ([self.is_link isEqualToString:@"0"]) {
            [cell hidenLookViewRestFrame:YES goStore:nil];

        }else if([self.is_link isEqualToString:@"1"]){
        [cell hidenLookViewRestFrame:NO goStore:string];
        [cell.lookOriginalBtn addTarget:self action:@selector(pushDetailWebUrl) forControlEvents:UIControlEventTouchUpInside];
            
            
        }else if ([self.is_link isEqualToString:@"2"]){
            [cell hidenLookViewRestFrame:NO goStore:string];
            [cell.lookOriginalBtn addTarget:self action:@selector(pushStoreDetail) forControlEvents:UIControlEventTouchUpInside];
        }
        if (!cell) {
            cell = [[PostBarNewDetailV1AdmireCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]
            ;
        }
        if (self.isAdmirePost == YES) {
            [cell.admireBtn setImage:[UIImage imageNamed:@"postmain_bar_admire_light"] forState:UIControlStateNormal];
            
        }else{
            [cell.admireBtn setImage:[UIImage imageNamed:@"postmain_bar_admire_gray"] forState:UIControlStateNormal];
        }
        [cell.admireBigBtn addTarget:self action:@selector(isAdmireOrCancel:) forControlEvents:UIControlEventTouchUpInside];
        cell.admireCountLabel.text = [NSString stringWithFormat:@"%ld",self.mainAdmireCount];
        cell.admireCountLabel.textColor = [BBSColor hexStringToColor:@"999999"];
       
        if ([ShareSDK isClientInstalled:SSDKPlatformTypeWechat]) {
            [cell.shareWeixin addTarget:self action:@selector(shareWeixinBtn) forControlEvents:UIControlEventTouchUpInside];
            [cell.shareWeixinQuan addTarget:self action:@selector(shareWeixinQuanBtn) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            cell.shareWeixin.hidden = YES;
            cell.shareWeixinQuan.hidden = YES;
            
        }
        
        cell.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        
        returnCell =cell;
        
    }else if (indexPath.section == _postDataArray.count +1){
        if (indexPath.row == 0) {
            NSString *identifier = [NSString stringWithFormat:@"POSTBARRECOMMEND"];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]
                ;
            }
            cell.textLabel.text = @"推荐";
            cell.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
            returnCell =cell;

        }else{
            RecommendListItem *item = [_recommendArray objectAtIndex:indexPath.row-1];
            static NSString *identifier = @"RECOMMENDLISTCELL";
            RecommendCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[RecommendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            if (indexPath.row == 1) {
                cell.lineTopView.hidden = NO;
                cell.lineBottomView.hidden = YES;
                cell.lineView.hidden = NO;
            }else if(indexPath.row == _recommendArray.count){
                cell.lineTopView.hidden = YES;
                cell.lineBottomView.hidden = NO;
                cell.lineView.hidden = YES;
            }else{
                cell.lineTopView.hidden = YES;
                cell.lineBottomView.hidden =YES;
                cell.lineView.hidden = NO;

            }
            cell.recommedTitleLabel.text = item.img_title;
            returnCell = cell;
        }
        
    }else if (indexPath.section == _postDataArray.count+2){
        NSString *identifier = [NSString stringWithFormat:@"POSTBARREVIEWCELL"];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier]
            ;
        }
        cell.textLabel.text = @"评论";
        cell.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        returnCell =cell;
        
    }else if(indexPath.section >_postDataArray.count+2){
       
        NSArray *sectionArray = [_reviewDataArray objectAtIndex:indexPath.section-_postDataArray.count-3];
        id obj = [sectionArray objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[PostBarDetailReviewUserItem class]]) {
            PostBarDetailReviewUserItem *item = (PostBarDetailReviewUserItem*)obj;
            PostBarNewReviewsUserCell *cell = [tableView dequeueReusableCellWithIdentifier:item.identify];
            if (!cell) {
                cell = [[PostBarNewReviewsUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.identify];
            }
            cell.userNameLabel.text = item.userName;
            [manager downloadImageWithURL:[NSURL URLWithString:item.avatar] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [cell.avatarBtn setBackgroundImage:image forState:UIControlStateNormal];
            }];
            cell.timeLabel.text = item.postTime;
            cell.reviewCountLabel.text = [NSString stringWithFormat:@"%ld",(long)item.reviewCount];
            cell.admireCountLabel.text = [NSString stringWithFormat:@"%ld",(long)item.admireCount];
            if (item.isAdmire == YES) {
                [cell.admireBtn setImage:[UIImage imageNamed:@"post_bar_admire_light"] forState:UIControlStateNormal];
            }else{
                [cell.admireBtn setImage:[UIImage imageNamed:@"post_bar_admire_gray"] forState:UIControlStateNormal];
                
            }
            cell.avatarBtn.indexpath = indexPath;
            cell.reviewBtn.indexpath = indexPath;
            cell.admireBtn.indexpath = indexPath;
            cell.admireCountBtn.indexpath = indexPath;
            cell.reviewCountBtn.indexpath = indexPath;
            cell.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
            cell.delegate = self;
            returnCell = cell;
        }else if([obj isKindOfClass:[PostBarDetailReviewDescrible class]]){
            PostBarDetailReviewDescrible *item = (PostBarDetailReviewDescrible*)obj;
            PostBarNewReviewsDescribleCell *cell = [tableView dequeueReusableCellWithIdentifier:item.identify];
            if (!cell) {
                cell = [[PostBarNewReviewsDescribleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.identify];
            }
            cell.describeLabel.text = item.descontent;
            CGFloat height = [self getHeightByWidth:SCREENWIDTH-15*0.6*3-32 title:item.descontent font:[UIFont systemFontOfSize:14]];
            cell.describeLabel.frame = CGRectMake(15*0.6*2+32, 2,SCREENWIDTH-15*0.6*3-32, height +10);
            cell.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
            NSDictionary *dictionary = [BBSEmojiInfo detailContentWithStringAndEmoji:cell.describeLabel.text fromArray:facesArray];
            NSString *content = [dictionary objectForKey:@"content"];
            NSArray *tNumArray = [dictionary objectForKey:@"emoji"];
            cell.describeLabel.text = content;
            
            for (NSInteger i = tNumArray.count-1; i >=0; i--) {
                NSDictionary *dict = [tNumArray objectAtIndex:i];
                int numid = [[dict objectForKey:@"location"] intValue];
                NSString * emojiText = [dict objectForKey:@"emojiText"];
                UIImage *image = [UIImage imageNamed:[facesDictionary objectForKey:emojiText]];
                [cell.describeLabel insertImage:image atIndex:(numid-i*4) margins:UIEdgeInsetsMake(-2, 0, -2, 0)];
            }
            
            returnCell = cell;
        }else if ([obj isKindOfClass:[PostBarDetailReviewPhoto class]]){
            PostBarDetailReviewPhoto *item = (PostBarDetailReviewPhoto*)obj;
            PostBarNewReviewsPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:item.identify];
            NSString *img1 ;
            NSString *img2 ;
            NSString *img3 ;
            NSString *img4 ;
            
            if (!cell) {
                cell = [[PostBarNewReviewsPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.identify];
                
            }
            
            if (item.photosArray.count == 1) {
                img1 = item.photosArray[0];
                
            }else if(item.photosArray.count == 2){
                img1 = item.photosArray[0];
                img2 = item.photosArray[1];
            }else if(item.photosArray.count == 3){
                img3 = item.photosArray[2];
                img1 = item.photosArray[0];
                img2 = item.photosArray[1];
                
            }else if(item.photosArray.count >= 4){
                img4 = item.photosArray[3];
                img3 = item.photosArray[2];
                img1 = item.photosArray[0];
                img2 = item.photosArray[1];
                
            }
            if (img1.length) {
                [manager downloadImageWithURL:[NSURL URLWithString:img1] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [cell.btn1 setBackgroundImage:image forState:UIControlStateNormal];
                    
                }];
                
            }
            if (img2.length) {
                [manager downloadImageWithURL:[NSURL URLWithString:img2] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [cell.btn2 setBackgroundImage:image forState:UIControlStateNormal];
                }];
                
            }
            if (img3.length) {
                [manager downloadImageWithURL:[NSURL URLWithString:img3] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [cell.btn3 setBackgroundImage:image forState:UIControlStateNormal];
                    
                }];
                
            }
            if (img4.length) {
                [manager downloadImageWithURL:[NSURL URLWithString:img4] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [cell.btn4 setBackgroundImage:image forState:UIControlStateNormal];
                    
                }];
            }
            cell.delegate = self;
            
            cell.btn1.indexpath = indexPath;
            cell.btn2.indexpath = indexPath;
            cell.btn3.indexpath = indexPath;
            cell.btn4.indexpath = indexPath;
            cell.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
            
            returnCell = cell;
        }else if ([obj isKindOfClass:[PostBarNewReview_ReviewUserItem class]]){
            PostBarNewReview_ReviewUserItem *item = (PostBarNewReview_ReviewUserItem *)obj;
            ReviewReviewCell *reviewCell = [tableView dequeueReusableCellWithIdentifier:@"REVIEWREVIEWCELL"];
            if (!reviewCell) {
                reviewCell = [[ReviewReviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"REVIEWREVIEWCELL"];
            }
            NSString *nameString = [NSString stringWithFormat:@"%@:%@",item.user_name,item.demand];
            CGFloat heightReview = [self getHeightByWidth:SCREENWIDTH-15*0.6*3-32-10 title:nameString font:[UIFont systemFontOfSize:12]];
            reviewCell.describleLabel.frame = CGRectMake(5, 5, SCREENWIDTH-15*0.6*3-32-10,heightReview+5);
            reviewCell.grayView.frame =  CGRectMake(15*0.6*2+32, 0, SCREENWIDTH-15*0.6*3-32, heightReview+10);
            NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithString:nameString];
            NSArray *tempArr = [nameString componentsSeparatedByString:@":"];
            [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, ((NSString*)tempArr[0]).length)];
            [string addAttribute:NSForegroundColorAttributeName
                           value:[UIColor grayColor]
                            range:NSMakeRange(((NSString *)tempArr[0]).length, ((NSString *)tempArr[1]).length+1)];
            reviewCell.describleLabel.attributedText = string;

            NSDictionary *dictionary = [BBSEmojiInfo detailContentWithStringAndEmoji:nameString fromArray:facesArray];
            NSString *content = [dictionary objectForKey:@"content"];
            NSArray *tNumArray = [dictionary objectForKey:@"emoji"];
            reviewCell.describleLabel.text = content;
            for (NSInteger i = tNumArray.count-1; i >=0; i--) {
                NSDictionary *dict = [tNumArray objectAtIndex:i];
                int numid = [[dict objectForKey:@"location"] intValue];
                NSString * emojiText = [dict objectForKey:@"emojiText"];
                UIImage *image = [UIImage imageNamed:[facesDictionary objectForKey:emojiText]];
                [reviewCell.describleLabel insertImage:image atIndex:(numid-i*4) margins:UIEdgeInsetsMake(-7,0,-7, 0)];
            }
            returnCell = reviewCell;
        }else if ([obj isKindOfClass:[IsReviewItem class]]){
            IsReviewItem *item = (IsReviewItem *)obj;
            ReviewReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ISREVIEWREVIEWCELL"];
            if (!cell) {
                cell = [[ReviewReviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ISREVIEWREVIEWCELL"];
            }
            if ([item.isReview isEqualToString:@"0"]) {
                cell.describleLabel.frame = CGRectMake(0, 2, 0,0);
                cell.grayView.frame =  CGRectMake(0, 0, 0,0);

            }else{
                cell.describleLabel.frame = CGRectMake(5,5, SCREENWIDTH-15*0.6*3-32-10,20);
                cell.describleLabel.text = [NSString stringWithFormat:@"查看全部%@条回复",item.review_count];
                cell.grayView.frame =  CGRectMake(15*0.6*2+32, 0, SCREENWIDTH-15*0.6*3-32,20);
                cell.describleLabel.textColor = [BBSColor hexStringToColor:@"396ba0"];
              }
            returnCell = cell;

        }
    }
    returnCell.selectionStyle=UITableViewCellSelectionStyleNone;
    return returnCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self moveDowToolBar];
    [_toolBaView changetoPostToolBar];
    if (indexPath.section == _postDataArray.count+1) {
        if (indexPath.row == 0) {
            
        }else{
            RecommendListItem *item = [_recommendArray objectAtIndex:indexPath.row-1];
            //0帖子，1群，2商家，5视频
            if ([item.is_group isEqualToString:@"0"]) {
                [self pushPostRecommend:item.img_id];
                
            }else if ([item.is_group isEqualToString:@"1"]){
                [self pushPostMyGroupDetailVC:item.img_id];

            }else if ([item.is_group isEqualToString:@"2"]){
                StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
                storeVC.longin_user_id = LOGIN_USER_ID;
                storeVC.business_id = item.img_id;
                [self.navigationController pushViewController:storeVC animated:YES];
            }else if ([item.is_group isEqualToString:@"5"]) {
                BOOL isHV;//横竖屏
                float height = [item.img_thumb_height floatValue];
                float weight = [item.img_thumb_width floatValue];
                if (height > weight) {
                    isHV = NO;
                }else{
                    isHV = YES;
                }
                BabyShowPlayerVC *babyShowPlayerVC = [[BabyShowPlayerVC alloc]init];
                babyShowPlayerVC.img_id = item.img_id;
                babyShowPlayerVC.videoUrl = item.video_url;
                babyShowPlayerVC.isHV = isHV;
                [self.navigationController pushViewController:babyShowPlayerVC animated:YES];
            }
        }
    }else if (indexPath.section >_postDataArray.count+2){
        NSArray *sectionArray = [_reviewDataArray objectAtIndex:indexPath.section-_postDataArray.count-3];
        id obj = [sectionArray objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[PostBarDetailReviewDescrible class]] ) {
            [_toolBaView moveUp];
            [_toolBaView.textView becomeFirstResponder];
            [_toolBaView hiddenPhotoBtn];
            PostBarDetailReviewDescrible *item = (PostBarDetailReviewDescrible *)obj;
            _sectionIndexReviewId = item.review_id;
            _reviewIndexPath = indexPath;
            
        }else if ( [obj isKindOfClass:[PostBarNewReview_ReviewUserItem class]]){
            [_toolBaView moveUp];
            [_toolBaView.textView becomeFirstResponder];
            [_toolBaView hiddenPhotoBtn];
            PostBarNewReview_ReviewUserItem *item = (PostBarNewReview_ReviewUserItem*)obj;
            _sectionIndexReviewId = item.review_id;
            _reviewIndexPath = indexPath;

        }else if ([obj isKindOfClass:[IsReviewItem class]]) {
            IsReviewItem *item = (IsReviewItem*)obj;
            if ([item.isReview isEqualToString:@"0"]) {
            }else{
                PraiseAndReviewListViewController *reviewListVC=[[PraiseAndReviewListViewController alloc]init];
                reviewListVC.imgID=item.imgID;
                reviewListVC.reviewId = item.reviewId;
                reviewListVC.ownerId = item.userId;
                reviewListVC.useridBePraised=item.userId;
                reviewListVC.type=MyShowReviewList;
                reviewListVC.isPost=YES;
                [self.navigationController pushViewController:reviewListVC animated:YES];
            }
        }
    }
}
#pragma mark 加关注
-(void)addFriendAction{
    [LoadingView startOnTheViewController:self];
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"user_id",self.userNewId,@"idol_id", nil];
    NetAccess *net=[NetAccess sharedNetAccess];
    if ([self.is_idol  isEqualToString:@"0"]) {
        //添加关注
        [net getDataWithStyle:NetStyleFocusOn andParam:paramDic];
    }else if([self.is_idol isEqualToString:@"1"]){
        //取消关注
        [net getDataWithStyle:NetStyleCancelFocus andParam:paramDic];
    }

}
#pragma mark 跳转编辑页面
-(void)pushPostNewMakeSecondVC{
    PostBarNewMakeSecondVC *postSecond = [[PostBarNewMakeSecondVC alloc]init];
    postSecond.img_id = self.img_id;
    postSecond.make_groupId = self.group_tag_id;
    postSecond.isFromGroup = @"isfromPost";
    [self.navigationController pushViewController:postSecond animated:NO];

}
#pragma mark 跳转个人中心
-(void)pushHomepage{
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.userid=self.userNewId;
    myHomePage.hidesBottomBarWhenPushed=YES;
    if ([self.userNewId intValue]==-999) {
        
    }else{
        if ([self.userNewId intValue]==[LOGIN_USER_ID intValue]) {
              myHomePage.Type=0;
        }else{
            
            myHomePage.Type=1;
            
        }
        
        [self.navigationController pushViewController:myHomePage animated:YES];
    }
}
//详细的帖子
-(void)pushDetailPostBar{
    PostBarNewDetialV1VC *detailVC = [[PostBarNewDetialV1VC alloc]init];
    detailVC.img_id=[NSString stringWithFormat:@"%@",self.group_tag_id];
    detailVC.login_user_id=LOGIN_USER_ID;
    detailVC.refreshInVC = ^(BOOL isRefresh){
    };
    [detailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

#pragma mark 跳转相关的帖子
-(void)pushPostRecommend:(NSString*)imgid{
    PostBarNewDetialV1VC *detailVC = [[PostBarNewDetialV1VC alloc]init];
    detailVC.img_id=[NSString stringWithFormat:@"%@",imgid];
    detailVC.login_user_id=LOGIN_USER_ID;
    detailVC.refreshInVC = ^(BOOL isRefresh){
    };
    [detailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailVC animated:YES];

}
#pragma mark 跳转群
-(void)pushGroupPostBar{
    //跳转群详情
    
  [self pushPostMyGroupDetailVC:self.group_tag_id];}
#pragma mark 跳转群详情
-(void)pushPostMyGroupDetailVC:(NSString *)imgId{
    PostBarNewGroupOnlyOneVC *postBarVC = [[PostBarNewGroupOnlyOneVC alloc]init];
    postBarVC.group_id = [imgId intValue];
    [self.navigationController pushViewController:postBarVC animated:YES];

    
}


#pragma mark 跳转标签列表
-(void)pushTagPostList{
    PostBarListNewVC *postBarListVC = [[PostBarListNewVC alloc]init];
    postBarListVC.tag_id = [self.group_tag_id integerValue];
    postBarListVC.img_ids = self.imgID;
    [self.navigationController pushViewController:postBarListVC animated:YES];
}
#pragma mark 跳转商家
-(void)pushStoreDetail{
    StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
    storeVC.longin_user_id = LOGIN_USER_ID;
    storeVC.business_id = self.business_id;
    [self.navigationController pushViewController:storeVC animated:YES];
}

#pragma mark 跳转帖子链接
-(void)pushDetailWebUrl{
    WebViewController *webView=[[WebViewController alloc]init];
    webView.img_id = self.imgID;
    webView.urlStr=[self.postUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [webView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webView animated:YES];
}
#pragma mark  对于主贴的点赞和取消
-(void)isAdmireOrCancel:(id)sender{
    UIButton *admireBigBtn = (id)sender;
    admireBigBtn.enabled = NO;
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:self.userNewId,@"admire_user_id",
                            LOGIN_USER_ID,@"login_user_id",
                            self.imgID,kAdmireImgId,@"1",@"ispost",nil];
    NetAccess *net=[NetAccess sharedNetAccess];
    
    if (self.isAdmirePost==NO) {
        [net getDataWithStyle:NetStyleAdmire andParam:paramDic];
    }else{
        [net getDataWithStyle:NetStyleCancelAdmire andParam:paramDic];
    }
}
#pragma mark PostBarNewReplyViewDelegate
#pragma mark 选择收藏的按钮

-(void)savePost{
    [LoadingView startOnTheViewController:self];
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.imgID,@"img_id", nil];
    NetAccess *net=[NetAccess sharedNetAccess];
    if ([self.is_save  isEqualToString:@"0"]) {
        [net getDataWithStyle:NetStylePostBarAddToBeMyFocus andParam:paramDic];
    }else{
        [net getDataWithStyle:NetStylePostBarCancelFocus andParam:paramDic];
    }

}
-(void)send{
    [LoadingView startOnTheViewController:self];
    
    
    NSString *temptext = [_toolBaView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *text = [temptext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    text=[text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    text=[text stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    if ([_toolBaView.textView.text isEqualToString: @" 写评论..."]) {
        text=@"";
    }
    
    //如果存在就是对主评论的评论
    if (_sectionIndexReviewId.length) {
        NSMutableDictionary *param ;
        param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                 LOGIN_USER_ID,@"login_user_id",
                 text,kReviewDemand,
                 _sectionIndexReviewId,@"review_id",nil];
        [param setObject:@"1" forKey:@"ispost"];
        NetAccess *net=[NetAccess sharedNetAccess];
        [net getDataWithStyle:NetStyleReview andParam:param];
    }else{
    if (text.length || _toolBaView.photosArray.count) {
        
        NSMutableArray *imagesArray=[NSMutableArray array];
        NSMutableArray *urlsArray=[NSMutableArray array];
        
        for (id obj in _toolBaView.photosArray) {
            
            if ([obj isKindOfClass:[UIImage class]]) {
                [imagesArray addObject:obj];
            }else if ([obj isKindOfClass:[NSDictionary class]]){
                NSDictionary *imgDic=(NSDictionary *)obj;
                NSString *UrlStr=[imgDic objectForKey:@"img_down"];
                [urlsArray addObject:UrlStr];
            }
            
        }
        
        NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
        [paramDic setObject:self.img_id forKey:@"img_id"];
        [paramDic setObject:LOGIN_USER_ID forKey:@"login_user_id"];
        NSString *temptext = [_toolBaView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *text = [temptext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
        if (text.length && ![text isEqualToString:@"写评论..."]) {
            [paramDic setObject:text forKey:@"demand"];
        }
        if (imagesArray.count) {
            [paramDic setObject:imagesArray forKey:@"photos"];
            [paramDic setObject:[NSString stringWithFormat:@"%lu",(unsigned long)imagesArray.count] forKey:@"file_count"];
        }
        if (urlsArray.count) {
            [paramDic setObject:urlsArray forKey:@"img_urls"];
        }
        
            [paramDic setObject:@"1" forKey:@"type"];
            
        NetAccess *net=[NetAccess sharedNetAccess];
        [net getDataWithStyle:NetStylePostBarNewMakeAPost andParam:paramDic];
        
    }else{
        [BBSAlert showAlertWithContent:@"描述和图片不能全为空哦" andDelegate:self];
        [LoadingView stopOnTheViewController:self];
        return;
     }
    }
    
    [self moveDowToolBar];
}

-(void)selectPhotos{
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"自由环球租赁" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选",@"从手机相册选",@"拍一张", nil];
    actionSheet.tag=PHOTO;
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}


#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    
    UIColor *color=[UIColor whiteColor];
    NSDictionary *dic=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    imagePicker.navigationBar.titleTextAttributes=dic;
    
    
    if (buttonIndex==1) {
        //从手机相册
        if (_toolBaView.photosArray.count<6) {
            
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            elcPicker.maximumImagesCount = 6-_toolBaView.photosArray.count;
            elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
            elcPicker.imagePickerDelegate = self;
            
            [self presentViewController:elcPicker animated:YES completion:nil];
            
        }else{
            
            NSString *alertStr=[NSString stringWithFormat:@"每次只能上传%d张照片哦",6];
            [BBSAlert showAlertWithContent:alertStr andDelegate:self];
            
        }
        
        
    }else if (buttonIndex==2){
        //拍摄
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
            
            if (_toolBaView.photosArray.count<6) {
                
                imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate=self;
                imagePicker.allowsEditing=NO;
                imagePicker.videoQuality=UIImagePickerControllerQualityType640x480;
                [self.navigationController presentViewController:imagePicker animated:YES completion:^{}];
                
            }else{
                
                NSString *alertStr=[NSString stringWithFormat:@"每次只能上传%d张照片哦",6];
                [BBSAlert showAlertWithContent:alertStr andDelegate:self];
                
            }
            
            
        }else{
            
            [BBSAlert showAlertWithContent:@"相机设备不可用，请到手机 设置->隐私->相机选项卡 打开自由环球租赁的开关" andDelegate:self];
            
        }
    }
    else if (buttonIndex==0){
        //从应用相册
        
        UserInfoManager *manager=[[UserInfoManager alloc]init];
        UserInfoItem *userItem=[manager currentUserInfo];
        if (userItem.userId && [userItem.isVisitor intValue]==1 ){
            //游客没有相册
            [BBSAlert showAlertWithContent:@"您是游客，请登录/注册" andDelegate:nil];
            return;
        }
        
        AlbumListViewController *albumListVC = [[AlbumListViewController alloc] init];
        NSUInteger currentCount = _toolBaView.photosArray.count;
        NSDictionary *movingDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"isChoosing",[NSNumber numberWithUnsignedInteger:currentCount],@"currentCount", nil];
        albumListVC.title = @"选择";
        albumListVC.movingInfo = movingDict;
        albumListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:albumListVC animated:YES];
        
    } else {
        
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        
    }
    
    
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    //是否同步到秀秀
    if (alertView.tag == 100) {
        
        NSMutableArray *imagesArray=[NSMutableArray array];
        NSMutableArray *urlsArray=[NSMutableArray array];
        
        for (id obj in _toolBaView.photosArray) {
            
            if ([obj isKindOfClass:[UIImage class]]) {
                [imagesArray addObject:obj];
            }else if ([obj isKindOfClass:[NSDictionary class]]){
                NSDictionary *imgDic=(NSDictionary *)obj;
                NSString *UrlStr=[imgDic objectForKey:@"img_down"];
                [urlsArray addObject:UrlStr];
            }
            
        }
        
        NSMutableDictionary *paramDic=[NSMutableDictionary dictionary];
        [paramDic setObject:self.img_id forKey:@"root_img_id"];
        [paramDic setObject:self.login_user_id forKey:@"user_id"];
        
        NSString *temptext = [_toolBaView.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *text = [temptext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
        //        text=[text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        //        text=[text stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        //
        if (text.length && ![text isEqualToString:@"写评论..."]) {
            [paramDic setObject:text forKey:@"img_desc"];
        }
        
        if (imagesArray.count) {
            [paramDic setObject:imagesArray forKey:@"photos"];
            [paramDic setObject:[NSString stringWithFormat:@"%lu",(unsigned long)imagesArray.count] forKey:@"file_count"];
        }
        if (urlsArray.count) {
            [paramDic setObject:urlsArray forKey:@"img_urls"];
        }
        
        if (buttonIndex == 0) {
            //不同步到秀秀
            [paramDic setObject:@"1" forKey:@"type"];
            
            
        } else {
            //同步到秀秀
            [paramDic setObject:@"2" forKey:@"type"];
        }
        NetAccess *net=[NetAccess sharedNetAccess];
        [net getDataWithStyle:NetStylePostBarNewMakeAPost andParam:paramDic];
        
    }
}
#pragma mark UIImagePickerViewDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImageOrientation imageOrientation=image.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp)
    {
        
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
    }
    
    [_toolBaView.photosArray addObject:image];
    [_toolBaView showPhotosWithArray:_toolBaView.photosArray];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark ELCImagePickerControllerDelegate

-(void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    for (NSDictionary *dict in info) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        [_toolBaView.photosArray addObject:image];
        
    }
    
    [_toolBaView showPhotosWithArray:_toolBaView.photosArray];
    
}

-(void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark - CellDelegate
//点击评论者的头像跳转页面
-(void)ClickOnTheAvatar:(btnWithIndexPath *)btn{
    NSArray *singleArray = [_reviewDataArray objectAtIndex:btn.indexpath.section-_postDataArray.count-3];
    PostBarDetailReviewUserItem *item = [singleArray objectAtIndex:btn.indexpath.row];
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.userid=[NSString stringWithFormat:@"%@",item.userId];
    myHomePage.hidesBottomBarWhenPushed=YES;
    if ([item.userId intValue] == -999) {
        
    }else{
        if ([item.userId intValue]==[LOGIN_USER_ID intValue]) {
            myHomePage.Type=0;
        }else{
            myHomePage.Type=1;
        }
        
        [self.navigationController pushViewController:myHomePage animated:YES];
    }
}
#pragma mark 评论的点赞和评论
-(void)praise:(btnWithIndexPath *)sender{
    sender.enabled = NO;
    PostBarNewReviewsUserCell *cell = (PostBarNewReviewsUserCell*)[_secondTableView cellForRowAtIndexPath:sender.indexpath];
    NSArray *sectionArray=[_reviewDataArray objectAtIndex:sender.indexpath.section-_postDataArray.count-3];
    PostBarDetailReviewUserItem *item = [sectionArray objectAtIndex:sender.indexpath.row];
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:item.userId,@"admire_user_id",
                            LOGIN_USER_ID,@"login_user_id",
                            item.review_id,@"review_id",nil];
    UrlMaker *urlMaker;
    if (item.isAdmire == NO) {
        urlMaker = [[UrlMaker alloc]initWithNewV1UrlStr:kPublicListingReviewAdmire Method:NetMethodPost andParam:paramDic];
        
    }else{
        urlMaker = [[UrlMaker alloc]initWithNewV1UrlStr:kCancelListingReviewAdmire Method:NetMethodPost andParam:paramDic];
        
    }
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlMaker.url];
    
    for (NSString *key in [paramDic allKeys]) {
        
        id obj = [paramDic objectForKey:key];
        [request setPostValue:obj forKey:key];
    }
    
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    
    __weak ASIFormDataRequest *blockRequest = request;
    [request setCompletionBlock:^{
        
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:kBBSSuccess] integerValue] == YES) {
            sender.enabled = YES;
            if (item.isAdmire == YES) {
                [cell.admireBtn setImage:[UIImage imageNamed:@"post_bar_admire_gray"] forState:UIControlStateNormal];
                item.admireCount--;
                item.isAdmire = NO;
                cell.admireCountLabel.text = [NSString stringWithFormat:@"%ld",(long)item.admireCount];
                
            }else{
                [cell.admireBtn setImage:[UIImage imageNamed:@"post_bar_admire_light"] forState:UIControlStateNormal];
                item.admireCount++;
                item.isAdmire = YES;
                cell.admireCountLabel.text = [NSString stringWithFormat:@"%ld",(long)item.admireCount];
                
            }
            
        }else{
            sender.enabled = YES;
            NSString *errorString=[dic objectForKey:kBBSReMsg];
            [BBSAlert showAlertWithContent:errorString andDelegate:self];
        }
    }];
    
    [request setFailedBlock:^{
        sender.enabled = YES;
        
    }];
    
}
-(void)review:(btnWithIndexPath *)sender{
    _reviewIndexPath = sender.indexpath;
    NSArray *sectionArray=[_reviewDataArray objectAtIndex:sender.indexpath.section-_postDataArray.count-3];
    PostBarDetailReviewUserItem *item = [sectionArray objectAtIndex:sender.indexpath.row];
    PraiseAndReviewListViewController *reviewListVC=[[PraiseAndReviewListViewController alloc]init];
    reviewListVC.imgID=item.imgId;
    reviewListVC.reviewId = item.review_id;
    reviewListVC.ownerId = item.userId;
    reviewListVC.useridBePraised=item.userId;
    reviewListVC.type=MyShowReviewList;
    reviewListVC.isPost=YES;
    [self.navigationController pushViewController:reviewListVC animated:YES];
    
}
//评论里面的点击查看大图
-(void)gotoDetailPhotos:(btnWithIndexPath *)btn{
    [_PhotoArray removeAllObjects];
    NSArray *singleArray = [_reviewDataArray objectAtIndex:btn.indexpath.section-_postDataArray.count-3];
    PostBarDetailReviewPhoto *photoItem = [singleArray objectAtIndex:btn.indexpath.row];
    int i = 0;
    for (NSString *clearstring in photoItem.photosArray) {
        MWPhoto *photo = [[MWPhoto alloc]initWithURL:[NSURL URLWithString:clearstring] info:nil];
        photo.img_info = @{@"description": [NSString stringWithFormat:@"%d/%lu",i+1,(unsigned long)photoItem.photosArray.count]};
        [_PhotoArray addObject:photo];
        i++;
    }
    MWPhotoBrowser *browser =[[ MWPhotoBrowser alloc]initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    //  [browser setCurrentPhotoIndex:item.index];
    browser.type = 10;
    browser.needPlay = NO;     //需要播放
    browser.is_show_album =NO;
    browser.user_id =self.login_user_id;
    
    BBSNavigationController *nav=[[BBSNavigationController alloc]initWithRootViewController:browser];
    [self presentViewController:nav animated:YES completion:nil];
    
}
//主贴里面点击查看大图
-(void)showTheDetailOfThePhoto:(btnWithIndexPath *)btn{
    
    NSArray *sectionArray=[_postDataArray objectAtIndex:btn.indexpath.section];
    PostBarDetailNewPhotoItem *item=[sectionArray objectAtIndex:btn.indexpath.row];
    
    int i=0;
    [_PhotoArray removeAllObjects];
    for (NSString *clearString in item.clearPhotosArray) {
        
        MWPhoto *photo=[[MWPhoto alloc]initWithURL:[NSURL URLWithString:clearString] info:nil];
        photo.img_info =@{@"description": [NSString stringWithFormat:@"%d/%lu",i+1,(unsigned long)item.clearPhotosArray.count]};
        [_PhotoArray addObject:photo];
        i++;
        
    }
    
    
    MWPhotoBrowser *browser =[[ MWPhotoBrowser alloc]initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    [browser setCurrentPhotoIndex:item.index];
    browser.type = 10;
    browser.needPlay = NO;     //需要播放
    browser.is_show_album =NO;
    browser.user_id =self.login_user_id;
    
    BBSNavigationController *nav=[[BBSNavigationController alloc]initWithRootViewController:browser];
    [self presentViewController:nav animated:YES completion:nil];
    
}
#pragma mark MWPhotoBrowserDelegate

-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    
    return _PhotoArray.count;
    
}
-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    if (index < _PhotoArray.count) {
        
        return [_PhotoArray objectAtIndex:index];
        
    }
    
    return nil;
    
}


#pragma mark 单个分享微信和微信圈
-(void)shareWeixinBtn{
    //创建分享参数
    //自定义UI分享
    NSArray *firstArray = [_postDataArray firstObject];
    PostBarDetailNewDescribeItem *describlItem;
    PostBarDetailNewPhotoItem *photoItem;
    for (int i = 0; i <firstArray.count; i++) {
        if ([firstArray[i] isKindOfClass:[PostBarDetailNewDescribeItem class]]) {
            describlItem = firstArray[i];
            continue;
        }
        if ([firstArray[i]isKindOfClass:[PostBarDetailNewPhotoItem class]]) {
            photoItem = firstArray[i];
            break;
        }
    }
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    UIImage *shareImg;
    if (photoItem.thumbString.length > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",photoItem.thumbString]];
        shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        NSData *basicImgData = UIImagePNGRepresentation(shareImg);
        if (basicImgData.length/1024>150) {
            shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
        }

    }else{
        shareImg = [UIImage imageNamed:@"img_default"];
        
    }
    NSString *urlString = [NSString stringWithFormat:@"%@img_id=%@&user_id=%@",PostShareUrl,self.img_id,self.userNewId];
    NSURL *shareUrl = [NSURL URLWithString:urlString];

    [shareParams SSDKSetupWeChatParamsByText:self.titleString title:self.titleString url:shareUrl thumbImage:shareImg image:shareImg musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    [ShareSDK share:SSDKPlatformSubTypeWechatSession parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@", error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateCancel:
            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
                break;
            }
                
                
            default:
                break;
        }
    }];
    
    
}
//分享朋友圈
-(void)shareWeixinQuanBtn{
    //创建分享参数
    //自定义UI分享
    NSArray *firstArray = [_postDataArray firstObject];
    PostBarDetailNewDescribeItem *describlItem;
    PostBarDetailNewPhotoItem *photoItem;
    for (int i = 0; i <firstArray.count; i++) {
        if ([firstArray[i] isKindOfClass:[PostBarDetailNewDescribeItem class]]) {
            describlItem = firstArray[i];
            continue;
        }
        if ([firstArray[i]isKindOfClass:[PostBarDetailNewPhotoItem class]]) {
            photoItem = firstArray[i];
            break;
        }
    }
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    UIImage *shareImg;
    if (photoItem.thumbString.length > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",photoItem.thumbString]];
        shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        NSData *basicImgData = UIImagePNGRepresentation(shareImg);
        if (basicImgData.length/1024>150) {
            shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
        }
        
    }else{
        shareImg = [UIImage imageNamed:@"img_default"];
        
    }
    NSString *urlString = [NSString stringWithFormat:@"%@img_id=%@&user_id=%@",PostShareUrl,self.img_id,self.userNewId];
    NSURL *shareUrl = [NSURL URLWithString:urlString];
    NSLog(@"ssssssss = %@",urlString);
    [shareParams SSDKSetupWeChatParamsByText:self.titleString title:self.titleString url:shareUrl thumbImage:shareImg image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    
    [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@", error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateCancel:
            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
                break;
            }
                
                
            default:
                break;
        }
    }];
    
}

#pragma mark 分享本帖子
-(void)sharePostDetail{
    NSArray *firstArray = [_postDataArray firstObject];
    PostBarDetailNewDescribeItem *describlItem;
    PostBarDetailNewPhotoItem *photoItem;
    for (int i = 0; i <firstArray.count; i++) {
        if ([firstArray[i] isKindOfClass:[PostBarDetailNewDescribeItem class]]) {
            describlItem = firstArray[i];
            continue;
        }
        if ([firstArray[i]isKindOfClass:[PostBarDetailNewPhotoItem class]]) {
            photoItem = firstArray[i];
            break;
        }
    }
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray;
    UIImage *shareImg;
    if (photoItem.thumbString.length > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",photoItem.thumbString]];
        shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        NSData *basicImgData = UIImagePNGRepresentation(shareImg);
        if (basicImgData.length/1024>150) {
            shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
            
        }

    }else{
        shareImg = [UIImage imageNamed:@"img_default"];
        
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@img_id=%@&user_id=%@",PostShareUrl,self.img_id,self.userNewId];
    NSURL *shareUrl = [NSURL URLWithString:urlString];
    
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",self.titleString,shareUrl];

    //设置微博
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:self.timeString image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
    //设置微信好友
    [shareParams SSDKSetupWeChatParamsByText:self.titleString title:self.titleString url:shareUrl thumbImage:shareImg image:shareImg musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    //设置微信圈
    [shareParams SSDKSetupWeChatParamsByText:self.titleString title:self.titleString url:shareUrl thumbImage:shareImg image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    //设置qq
//设置qq空间
    [shareParams SSDKSetupQQParamsByText:self.titleString title:self.titleString url:shareUrl thumbImage:shareImg image:shareImg type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQZone];
    [shareParams SSDKSetupQQParamsByText:self.titleString  title:self.titleString url:shareUrl thumbImage:shareImg image:shareImg type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
        
    //设置拷贝
    [shareParams SSDKSetupCopyParamsByText:self.titleString images:imageArray url:shareUrl type:SSDKContentTypeAuto];
    

    
    //分享
    [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateBegin:
            {
                
                //  [storeVC showLoadingView:YES];
                break;
            }
            case SSDKResponseStateSuccess:
            {
                //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
            }
            case SSDKResponseStateCancel:
            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
                break;
            }
                
            default:
                break;
        }
    }];
    
    
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
#pragma mark 网络失败
-(void)netFail{
    
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:self];

}
#pragma mark 添加或取消关注成功或失败的通知
-(void)focusSucceed{
    [LoadingView stopOnTheViewController:self];
    self.is_idol = @"1";
    [_addFriendBtn setBackgroundImage:[UIImage imageNamed:@"post_bar_cancle_friend"] forState:UIControlStateNormal];
    
}
-(void)focusFail:(NSNotification *) not{
    [LoadingView stopOnTheViewController:self];

    NSString *errorString=not.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    [LoadingView stopOnTheViewController:self];
}
-(void)cancelFocusSucceed{
    
    [LoadingView stopOnTheViewController:self];
    self.is_idol = @"0";
    [_addFriendBtn setBackgroundImage:[UIImage imageNamed:@"post_bar_add_friendnew"] forState:UIControlStateNormal];
    
}

-(void)cancelFocusFail:(NSNotification *) not{
    [LoadingView stopOnTheViewController:self];

    
    NSString *errorString=not.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    [LoadingView stopOnTheViewController:self];
}


#pragma mark 通知收藏帖子是成功还是失败
-(void)SaveSucceed:(NSNotification *) note{
    
    [LoadingView stopOnTheViewController:self];
    if ([self.is_save isEqualToString:@"1"]) {
        self.is_save =@"0";
        [_toolBaView savePostBtn:NO];
        
    }else{
        self.is_save=@"1";
        [_toolBaView savePostBtn:YES];
    }
    
}

-(void)SaveFail:(NSNotification *) note{
    
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:note.object andDelegate:self];
    
}
-(void)PraiseSucceed:(NSNotification *) note{
    
    PostBarNewDetailV1AdmireCell *cell = (PostBarNewDetailV1AdmireCell*)[_secondTableView viewWithTag:7888];
    
    if (self.isAdmirePost==YES) {
        [cell.admireBtn setImage:[UIImage imageNamed:@"postmain_bar_admire_gray"] forState:UIControlStateNormal];
        self.mainAdmireCount--;
        self.isAdmirePost=NO;
        cell.admireCountLabel.text = [NSString stringWithFormat:@"%ld",self.mainAdmireCount];
        cell.admireBigBtn.enabled = YES;
        
        
    }else{
        [cell.admireBtn setImage:[UIImage imageNamed:@"postmain_bar_admire_light"] forState:UIControlStateNormal];
        self.mainAdmireCount++;
        self.isAdmirePost=YES;
        cell.admireCountLabel.text = [NSString stringWithFormat:@"%ld",self.mainAdmireCount];
        cell.admireBigBtn.enabled = YES;
        
    }
    [LoadingView stopOnTheViewController:self];
    
}

-(void)PraiseFail:(NSNotification *) note{
    
    PostBarNewDetailV1AdmireCell *cell = (PostBarNewDetailV1AdmireCell*)[_secondTableView viewWithTag:7888];
    cell.admireBigBtn.enabled = YES;
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:note.object andDelegate:self];
    
}
#pragma mark 对主贴的评论成功和失败
-(void)makeAPostSucceed:(NSNotification *) note{
    [LoadingView stopOnTheViewController:self];
    _toolBaView.textView.text=@"";
    [_toolBaView remowSubviews];
    [_toolBaView.photosArray removeAllObjects];
    [_toolBaView changetoPostToolBar];
    _postCreateTime = NULL;
    [self getReviewData];
    _isRefreshInVC = YES;
    
    
}

-(void)makeAPostFail:(NSNotification *) note{
    
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:note.object andDelegate:self];
    
    
}
#pragma mark 评论的评论或是评论时键盘回收
-(void)moveDowToolBar{
    _sectionIndexReviewId = @"";
    [_toolBaView moveDown];
 
}
#pragma mark 通知评论成功失败
-(void)reviewSucceed:(NSNotification *) note{
   
    [LoadingView stopOnTheViewController:self];
    _toolBaView.textView.text=@"";
    [_toolBaView remowSubviews];
    [_toolBaView.photosArray removeAllObjects];
    [_toolBaView changetoPostToolBar];
    _postCreateTime = NULL;
    [self getReviewData];
    _isRefreshInVC = YES;
    //局部刷新
    //[self refreshDetailInSection:_reviewIndexPath.section];
}
-(void)reviewFail:(NSNotification *) note{
    [LoadingView stopOnTheViewController:self];
    [self moveDowToolBar];
    [BBSAlert showAlertWithContent:note.object andDelegate:self];
}

//原地刷新
-(void)refreshDetailInSection:(NSInteger) section{
    
    // [LoadingView startOnTheViewController:self];
    NSArray *sectionArray=[_reviewDataArray objectAtIndex:section-_postDataArray.count-3];
    PostBarDetailReviewUserItem *item = [sectionArray objectAtIndex:0];
    NSDictionary *newParam=[NSDictionary dictionaryWithObjectsAndKeys:item.userId,@"user_id",
                            LOGIN_USER_ID,@"login_user_id",
                            item.imgId,@"img_id",nil];
    UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kPostInfoV4 Method:NetMethodGet andParam:newParam];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    __weak ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:@"success"]integerValue]==1) {
            NSArray *dataArray = [dic objectForKey:@"data"];
            for (NSDictionary *dataDic in dataArray) {
                NSArray *reviewsArray=[dataDic objectForKey:@"reviews"];
                NSInteger reviewCount = reviewsArray.count;
                item.reviewCount = reviewCount;
            }
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
            NSArray *indexArray = [NSArray arrayWithObjects:indexPath, nil];
            [_secondTableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}
//刷新评论
-(void)refreshSucceed:(NSNotification *) note{
    
    NSString *styleString=note.object;
    NetAccess *net=[NetAccess sharedNetAccess];
    NSArray *returnArray=[net getReturnDataWithNetStyle:[styleString intValue]];
    NSArray *sectionArray=[returnArray firstObject];
    [_reviewDataArray replaceObjectAtIndex:_reviewIndexPath.section withObject:sectionArray];
    
    NSIndexSet *set=[[NSIndexSet alloc]initWithIndex:_reviewIndexPath.section];
    
    [_secondTableView beginUpdates];
    [_secondTableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    [_secondTableView endUpdates];
    
    [LoadingView stopOnTheViewController:self];
    
}

-(void)refreshFail:(NSNotification *) note{
    
    [LoadingView stopOnTheViewController:self];
}

- (void)copyURL:(NSString *)string {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:string];
}

-(void)back{
        self.refreshInVC(_isRefreshInVC);
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark 推送过来的时候的返回按钮
-(void)dismissVC{
    NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:@""forKey:@"push"];
    [pushJudge synchronize];//记得立即同步
    [self dismissViewControllerAnimated:YES completion:nil];

}

//传入字符串，控件宽，字体，比较的高，最大的高，最小的高
-(CGFloat)getHeightByWidth:(CGFloat)width title:(NSString*)title font:(UIFont*)font{
    NIAttributedLabel *label = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
