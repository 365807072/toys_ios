//
//  LoveBabySecondVC.m
//  BabyShow
//
//  Created by WMY on 16/4/11.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "LoveBabySecondVC.h"
#import "SDWebImageManager.h"
#import "BBSTimeTool.h"
#import "UserInfoItem.h"
#import "MyOutPutTitleItem.h"
#import "MyOutPutDescribeItem.h"
#import "MyOutPutUrlItem.h"
#import "MyOutPutImgGroupItem.h"
#import "MyOutPutPraiseAndReviewItem.h"
#import "MyOutPutTitleItemNotToday.h"
#import "MyShowNewTitleItemToday.h"
#import "MyShowNewTitleItemNotToday.h"
#import "MyShowNewPickedTitleFocusItem.h"
#import "MyShowNewPickedTitleTodayItem.h"
#import "MyShowNewPickedTitleNotTodayItem.h"
#import "SVPullToRefresh.h"
#import "ShowAlertView.h"
#import "WebViewController.h"
#import "MakeAShowViewController.h"
#import "ApplyToPlayViewController.h"
//#import "PostBarNewDetailVC.h"
#import "PraiseAndReviewListViewController.h"
#import "PPTViewController.h"
#import "ReportViewController.h"
#import "BBSNavigationController.h"
#import "BBSNavigationControllerNotTurn.h"
#import "ClickViewController.h"
#import "GrowthDiaryLeadingView.h"
#import "SpecialDetailTVC.h"
#import "MoreSpecialTableViewCell.h"
#import "MoreSpecialModel.h"
#import "PostMyGroupDetailVController.h"
#import "WebViewController.h"

#import "StoreMoreListVC.h"
#import "UIButton+WebCache.h"
#import "UIImageView+WebCache.h"
#import "StoreListMyshowCell.h"
#import "SpecialListMyShowCell.h"
#import "StoreImgCell.h"
#import "MyShowNewVersionItem.h"
#import "MyShowNewVersionItem2.h"
#import "MyShowGroupCell.h"
#import "WorthBuyViewController.h"
#import "PostBarNewVC.h"
#import "StoreImgCell.h"
#import "MyHomeNewVersionVC.h"
#import "MyShowBuyCell.h"
#import "PostBarMoreViewController.h"
#import "LoginHTMLVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "RefreshControl.h"
#import "PostBarNewDetialV1VC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "PlayVideoCell.h"
#import "XSMediaPlayer.h"
#import "PlayBabyShowItem.h"
#import "BabyShowPlayerVC.h"
#import "YLImageView.h"
#import "YLGIFImage.h"
#import "PostBarGroupNewVC.h"
#import "PostBarNewGroupOnlyOneVC.h"


#define kDeviceVersion [[UIDevice currentDevice].systemVersion floatValue]

#define kNavbarHeight ((kDeviceVersion>=7.0)? 64 :44 )

@interface LoveBabySecondVC ()<ClickLabelDelegate,RefreshControlDelegate,PlayVideoCellDelegate>{
    RefreshControl *_refreshControl;
    
}
@property(nonatomic,strong)XSMediaPlayer *showPlayer;
@property(nonatomic,strong)PlayVideoCell *currentCell;//当前播放的视频
@property(nonatomic,strong)NSIndexPath *currentIndexPath;//当前cell的index
@property (nonatomic,strong)YLImageView *ylIamgeView;
@property(nonatomic,strong)NSArray *insertRowsArray;
@end

@implementation LoveBabySecondVC

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _dataArrayNew=[[NSMutableArray alloc]init];
        _PhotoArray = [[NSMutableArray alloc]init];
        
        
    }
    return self;
    
}
-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.hasNewShow = NO;
    

    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    //网络错误
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    
    //赞成功与失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseSucceed) name:USER_MYSHOWPRAISE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseFail:) name:USER_MYSHOWPRAISE_FAIL object:nil];
    
    //取消赞成功与失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseSucceed) name:USER_MYSHOWCANCELPRAISE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseFail:) name:USER_MYSHOWCANCELPRAISE_FAIL object:nil];
    
    //删除秀秀
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteShowSucceed:) name:USER_DELETE_SHOW_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteShowFail:) name:USER_DELETE_SHOW_FAIL object:nil];
    
    //添加关注
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusSucceed) name:USER_FOCUS_ON_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusFail:) name:USER_FOCUS_ON_FAIL object:nil];
    self.tabBarController.tabBar.hidden = YES;
    //成功之后的数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeShowShowSucceed) name:USER_MAKEASHOW_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeShowShowFail) name:USER_MAKEASHOW_FAIL object:nil];
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
    

   
    //如果有的话，弹出上传动画
    if (delegate.isHaveUpLoad == YES) {
        _ylIamgeView = [[YLImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH-60,10, 39, 39)];
        _ylIamgeView.image = [YLGIFImage imageNamed:@"up_show.gif"];
        [self.view addSubview:_ylIamgeView];
        delegate.isHaveUpLoad = NO;
    }
  }
// 应用退到后台
- (void)appDidEnterBackground
{
    [_showPlayer playOrPause:YES];
    [_showPlayer playRelease];
    [_showPlayer removeFromSuperview];
}

// 应用进入前台
- (void)appDidEnterPlayGround
{
    [_showPlayer playOrPause:YES];
    [_showPlayer playRelease];
    [_showPlayer removeFromSuperview];

    
}

-(void)netFail{
    [BBSAlert showAlertWithContent:@"网络环境不佳呦！换一个吧" andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    [_ylIamgeView removeFromSuperview];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.hasNewReview==YES && _isIntheVCReview == YES) {
        //有评论之后的刷新
        [self refreshReviewCountInSection:_reviewSection];
        delegate.hasNewReview=NO;
    }
}
-(void)makeShowShowSucceed{
    [_ylIamgeView removeFromSuperview];
    [self refresh];
}
-(void)makeShowShowFail{
    [_ylIamgeView removeFromSuperview];
}
-(void)refresh{
    
    [_ylIamgeView removeFromSuperview];
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.hasNewShow == YES) {
        _postCreateTimeNew = NULL;
        [self getdataArrayNewBabyShow];
        delegate.hasNewShow = NO;
    }
 
}
-(void)viewWillDisappear:(BOOL)animated{
    NSLog(@"秀秀列表即将消失的时候");
    [super viewWillDisappear:animated];
    [_showPlayer playOrPause:YES];
    [_showPlayer playRelease];
    [_showPlayer removeFromSuperview];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    [LoadingView stopOnTheViewController:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _postCreateTimeNew = NULL;
     self.navigationItem.title = self.babyTitle;
    [self setTableView];
    [self refreshControlInit];
    [self setRight];
    [self setBackButton];
    // Do any additional setup after loading the view.
}
#pragma mark 返回按钮
-(void)setBackButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.adjustsImageWhenHighlighted = NO;
    
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;

}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UI
//已复制
-(void)setTableView{
    //最新
    _tableViewNew = [[UITableView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH, SCREENHEIGHT-64)];
    _tableViewNew.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableViewNew.dataSource = self;
    _tableViewNew.delegate = self;
    _tableViewNew.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewNew.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableViewNew];
    
}
//右边按钮发秀秀
-(void)setRight{
    
    _addTopicBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _addTopicBtn.frame=CGRectMake(SCREENWIDTH-53 , SCREENHEIGHT-40-64-42, 42, 42);
    [_addTopicBtn setBackgroundImage:[UIImage imageNamed:@"img_myshow_newmakeashow"] forState:UIControlStateNormal];
    [_addTopicBtn addTarget:self action:@selector(makeAShow) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_addTopicBtn];
}

#pragma mark -refreshControl
-(void)refreshControlInit{
    _refreshControl = [[RefreshControl alloc]initWithScrollView:_tableViewNew delegate:self];
    _refreshControl.topEnabled = YES;
    _refreshControl.bottomEnabled = NO;
    [_refreshControl startRefreshingDirection:RefreshDirectionTop];
    
}
-(void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    if (refreshControl == _refreshControl) {
        [_showPlayer playRelease];
        [_showPlayer removeFromSuperview];
        if (direction == RefreshDirectionTop) {
            _postCreateTimeNew = NULL;
            
        }
        
        [self getdataArrayNewBabyShow];
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
#pragma mark data
-(void)getdataArrayNewBabyShow{
    
    NSDictionary *newParam = [NSDictionary dictionaryWithObjectsAndKeys:
                              LOGIN_USER_ID,@"login_user_id",@"100",@"tag_id",self.postCreateTimeNew,@"post_create_time",nil];
    UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:@"getBabyList" Method:NetMethodGet andParam:newParam];
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
        
        if ([[dic objectForKey:@"success"] integerValue]==1) {
            NSArray *dataArray=[dic objectForKey:@"data"];
            NSMutableArray *returnArray=[NSMutableArray array];
            for (NSDictionary *dic in dataArray) {
                NSMutableArray *singleArray=[[NSMutableArray alloc]init];
                NSDictionary *imgDic=[dic objectForKey:kMyShowImg];
                NSNumber *time=[imgDic objectForKey:kMyShowCreatTime];
                //未关注
                if ([[imgDic objectForKey:@"is_focus"] intValue]==0) {
                    MyShowNewPickedTitleFocusItem *titleItem=[[MyShowNewPickedTitleFocusItem alloc]init];
                    titleItem.imgid=[imgDic objectForKey:kMyShowImgId];
                    titleItem.height=43;
                    titleItem.create_time = [imgDic objectForKey:kMyShowCreatTime];
                    //titleItem.is_recommend = [[imgDic objectForKey:@"recommend"] boolValue];
                    titleItem.avatarStr=[imgDic objectForKey:@"avatar"];
                    titleItem.username=[imgDic objectForKey:@"user_name"];
                    titleItem.userid=[imgDic objectForKey:@"user_id"];
                    titleItem.identify=@"TITLEFOCUS";
                    titleItem.level_img = [imgDic objectForKey:@"level_img"];
                    [singleArray addObject:titleItem];
                }else if ([self isToday:time]==YES){
                    
                    //xx小时前
                    MyShowNewPickedTitleTodayItem *titleItem=[[MyShowNewPickedTitleTodayItem alloc]init];
                    titleItem.imgid=[imgDic objectForKey:kMyShowImgId];
                    titleItem.time=[self getTimeStrFromNow:time];
                    titleItem.create_time = [imgDic objectForKey:kMyShowCreatTime];
                    titleItem.height=43;
                    // titleItem.is_recommend = [[imgDic objectForKey:@"recommend"] boolValue];
                    titleItem.avatarStr=[imgDic objectForKey:@"avatar"];
                    titleItem.username=[imgDic objectForKey:@"user_name"];
                    titleItem.userid=[imgDic objectForKey:@"user_id"];
                    titleItem.identify=@"PICKEDTITLETODAY";
                    titleItem.level_img = [imgDic objectForKey:@"level_img"];
                    titleItem.img_cate = [[imgDic objectForKey:@"img_cate"]stringValue];
                    [singleArray addObject:titleItem];
                }else if ([self isToday:time]==NO){
                    //xx年月日
                    MyShowNewPickedTitleNotTodayItem *titleItem=[[MyShowNewPickedTitleNotTodayItem alloc]init];
                    titleItem.imgid=[imgDic objectForKey:kMyShowImgId];
                    titleItem.avatarStr=[imgDic objectForKey:@"avatar"];
                    titleItem.username=[imgDic objectForKey:@"user_name"];
                    titleItem.userid=[imgDic objectForKey:@"user_id"];
                    titleItem.create_time = [imgDic objectForKey:kMyShowCreatTime];
                    MyOutPutTitleItemNotToday *item=[self MyOutPutGetTime:time];
                    titleItem.day=item.day;
                    titleItem.month=item.month;
                    titleItem.year=item.year;
                    titleItem.height=42;
                    // titleItem.is_recommend = [[imgDic objectForKey:@"recommend"] boolValue];
                    titleItem.identify=@"PICKEDTITLENOTTODAY";
                    titleItem.level_img = [imgDic objectForKey:@"level_img"];
                    titleItem.img_cate = [[imgDic objectForKey:@"img_cate"]stringValue];
                    [singleArray addObject:titleItem];
                    
                }
                NSArray *photoArray=[imgDic objectForKey:@"img"];
                if (photoArray.count) {
                    
                    MyOutPutImgGroupItem *imgItem=[[MyOutPutImgGroupItem alloc]init];
                    imgItem.video_url = [imgDic objectForKey:@"video_url"];
                    imgItem.imgid = [imgDic objectForKey:kMyShowImgId];
                    imgItem.desecontent = [imgDic objectForKey:kMyShowDescription];
                    for (NSDictionary *photoDic in photoArray) {
                        MyShowImageItem *imageItem=[[MyShowImageItem alloc]init];
                        imageItem.imageStr=[photoDic objectForKey:kMyShowImgThumb];
                        imageItem.imageClearStr=[photoDic objectForKey:kMyShowImg];
                        imageItem.img_down=[photoDic objectForKey:kMyShowImgDown];
                        imageItem.img_height=[photoDic objectForKey:kMyShowImgWidth];
                        imageItem.img_width=[photoDic objectForKey:kMyShowImgHeight];
                        imageItem.img_thumb_width=[photoDic objectForKey:kMyShowImgThumbWidth];
                        imageItem.img_thumb_height=[photoDic objectForKey:kMyShowImgThumbHeight];
                        [imgItem.photosArray addObject:imageItem];
                        
                    }
                    
                    if (photoArray.count==1) {
                        //单张
                        imgItem.identify=@"IMGONE";
                        NSDictionary *singleImgDic=[photoArray objectAtIndex:0];
                        float height=[[singleImgDic objectForKey:kMyShowImgThumbHeight] floatValue];
                        float width=[[singleImgDic objectForKey:kMyShowImgThumbWidth] floatValue];
                        
                        if (imgItem.video_url.length > 0) {
                            imgItem.height = SCREENWIDTH*0.6+20;
                            
                        }else{
                            imgItem.frame=[MyShowImgFrame getFrameWithTheImageWidth:width AndHeight:height];
                            imgItem.height=imgItem.frame.size.height;

                        }
                        
                    }else{
                        //多张
                        imgItem.identify=@"IMG";
                        imgItem.height=160;
                        
                    }
                    
                    [singleArray addObject:imgItem];
                }
                
                
                MyOutPutDescribeItem *desItem=[[MyOutPutDescribeItem alloc]init];
                desItem.desContent=[imgDic objectForKey:kMyShowDescription];
                if (desItem.desContent.length) {
                    
                    desItem.identify=@"DESCRIBE";
                    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle.copy};
                    CGSize size=[desItem.desContent boundingRectWithSize:CGSizeMake(292, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                    
                    if (size.height>18) {
                        desItem.height = size.height+6;
                    }else{
                        desItem.height=24;
                    }
                    
                    [singleArray addObject:desItem];
                    
                }
                
                MyOutPutPraiseAndReviewItem *praiseItem=[[MyOutPutPraiseAndReviewItem alloc]init];
                praiseItem.praise_count=[imgDic objectForKey:kMyShowAdmireCount];
                praiseItem.review_count=[imgDic objectForKey:kMyShowReviewCount];
                praiseItem.isPraised=[[imgDic objectForKey:kMyShowImgIsAdmired] boolValue];
                praiseItem.imgid=[imgDic objectForKey:kMyShowImgId];
                praiseItem.img_cate = [[imgDic objectForKey:@"img_cate"]stringValue];
                
                praiseItem.userid=[imgDic objectForKey:@"user_id"];
                praiseItem.cate_name = imgDic[@"cate_name"];
                NSNumber *cate_id = imgDic[@"cate_id"];
                praiseItem.cate_id = [cate_id integerValue];
                praiseItem.create_time = imgDic[@"post_create_time"];
                praiseItem.height=40;
                praiseItem.identify=@"PRAISE";
                praiseItem.groupId = [[imgDic objectForKey:@"group_id"]integerValue];
                praiseItem.videoUrl = [imgDic objectForKey:@"video_url"];
                
                [singleArray addObject:praiseItem];
                [returnArray addObject:singleArray];
            }
            if (returnArray.count == 0) {
                _refreshControl.bottomEnabled = NO;
                
            }
            if (_postCreateTimeNew == NULL) {
                [_dataArrayNew removeAllObjects];
                _refreshControl.bottomEnabled = YES;
            }
            NSArray *singleArray = [returnArray lastObject];
            MyOutPutPraiseAndReviewItem *pItem = [singleArray lastObject];
            _postCreateTimeNew = pItem.create_time;
            [_dataArrayNew addObjectsFromArray:returnArray];
            [_tableViewNew reloadData];
            [self refreshComplete:_refreshControl];
            
            
        }else{
            [self refreshComplete:_refreshControl];
            if (dic) {
                [BBSAlert showAlertWithContent:[dic objectForKey:kBBSReMsg] andDelegate:self];

            }else{
                [BBSAlert showAlertWithContent:@"请刷新" andDelegate:self];
            }
            
        }
        
    }];
    [request setFailedBlock:^{
        [self refreshComplete:_refreshControl];
    }];
    
    
    
}
#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_dataArrayNew.count) {
        NSArray *singleArrayNew = [_dataArrayNew objectAtIndex:section];
        return singleArrayNew.count;
    }
    return 0;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArrayNew.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *singleArray=[_dataArrayNew objectAtIndex:indexPath.section];
    MyOutPutBasicItem *item=[singleArray objectAtIndex:indexPath.row];
    return item.height+5;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *singleArray=[_dataArrayNew objectAtIndex:indexPath.section];
    
    MyShowNewBasicItem *item=[singleArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell;
    
    //精选，人气宝宝
    ClickViewController *clickVC = [[ClickViewController alloc] init];
    if ([item isKindOfClass:[MyShowNewTitleItemToday class]]) {
        
        MyShowNewTitleItemToday *titleItem=(MyShowNewTitleItemToday *)item;
        MyShowNewTitleTodayCell *todayCell=[tableView dequeueReusableCellWithIdentifier:titleItem.identify];
        if (!todayCell) {
            todayCell=[[MyShowNewTitleTodayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleItem.identify];
        }
        todayCell.backgroundColor = [UIColor whiteColor];
        todayCell.timeLabel.text=titleItem.time;
        todayCell.nameLabel.text=titleItem.username;
        
        SDWebImageManager *manager=[SDWebImageManager sharedManager];
        [todayCell.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:titleItem.avatarStr] forState:UIControlStateNormal];
        CGRect nameFrame = todayCell.nameLabel.frame;
        CGSize size = [titleItem.username boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:todayCell.nameLabel.font} context:nil].size;
        
        if (!(item.level_img.length<= 0)) {
            [manager downloadImageWithURL:[NSURL URLWithString:item.level_img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                todayCell.levelImageView.frame = CGRectMake(nameFrame.origin.x + size.width + 1, nameFrame.origin.y+5,image.size.width*0.8,image.size.height*0.8);
                
                todayCell.levelImageView.image = image;
            }];
            
        } else {
            todayCell.levelImageView.image = nil;
        }
        [todayCell.levelImageView setClickToViewController:clickVC];
        todayCell.avatarBtn.indexpath=indexPath;
        todayCell.delegate=self;
        cell=todayCell;
        
    }else if ([item isKindOfClass:[MyShowNewTitleItemNotToday class]]){
        //不是今天
        MyShowNewTitleItemNotToday *titleItemNT=( MyShowNewTitleItemNotToday *)item;
        //
        MyShowNewTitleNotTodayCell *notTodayCell=[tableView dequeueReusableCellWithIdentifier:titleItemNT.identify];
        if (!notTodayCell) {
            notTodayCell=[[MyShowNewTitleNotTodayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleItemNT.identify];
        }
        notTodayCell.backgroundColor = [UIColor whiteColor];
        notTodayCell.dayLabel.text=titleItemNT.day;
        notTodayCell.monthLabel.text=[NSString stringWithFormat:@"%@月",titleItemNT.month];
        notTodayCell.yearLabel.text=[NSString stringWithFormat:@"%@年",titleItemNT.year];
        notTodayCell.nameLabel.text=titleItemNT.username;
        SDWebImageManager *manager=[SDWebImageManager sharedManager];
        [notTodayCell.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:titleItemNT.avatarStr] forState:UIControlStateNormal];
        
        CGRect nameFrame = notTodayCell.nameLabel.frame;
        CGSize size = [titleItemNT.username boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:notTodayCell.nameLabel.font} context:nil].size;
        
        if (!(item.level_img.length<= 0)) {
            
            [manager downloadImageWithURL:[NSURL URLWithString:item.level_img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                notTodayCell.levelImageView.frame = CGRectMake(nameFrame.origin.x + size.width + 1, nameFrame.origin.y+5, image.size.width*0.8,image.size.height*0.8);
                
                notTodayCell.levelImageView.image = image;
            }];
        } else {
            notTodayCell.levelImageView.image = nil;
        }
        [notTodayCell.levelImageView setClickToViewController:clickVC];
        
        notTodayCell.avatarBtn.indexpath=indexPath;
        notTodayCell.delegate=self;
        cell=notTodayCell;
        
    }else if ([item isKindOfClass:[MyShowNewPickedTitleFocusItem class]]){
        
        MyShowNewPickedTitleFocusItem *titleItem=(MyShowNewPickedTitleFocusItem *)item;
        //
        MyShowNewPickedTitleCell *titleCell=[tableView dequeueReusableCellWithIdentifier:titleItem.identify];
        if (!titleCell) {
            titleCell=[[MyShowNewPickedTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleItem.identify];
        }
        titleCell.backgroundColor = [UIColor whiteColor];
        
        titleCell.nameLabel.text=titleItem.username;
        SDWebImageManager *manager=[SDWebImageManager sharedManager];
        [titleCell.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:titleItem.avatarStr] forState:UIControlStateNormal];
        
        CGRect nameFrame = titleCell.nameLabel.frame;
        CGSize size = [titleItem.username boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:titleCell.nameLabel.font} context:nil].size;
        
        if (!(item.level_img.length<= 0)) {
            [manager downloadImageWithURL:[NSURL URLWithString:item.level_img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                titleCell.levelImageView.frame = CGRectMake(nameFrame.origin.x + size.width + 1, nameFrame.origin.y+5,image.size.width*0.8,image.size.height*0.8);
                titleCell.levelImageView.image = image;
            }];
        } else {
            titleCell.levelImageView.image = nil;
        }
        [titleCell.levelImageView setClickToViewController:clickVC];
        
        titleCell.delegate=self;
        titleCell.avatarBtn.indexpath=indexPath;
        titleCell.addFriendsBtn.indexpath=indexPath;
        
        cell=titleCell;
        
    }else if ([item isKindOfClass:[MyShowNewPickedTitleTodayItem class]]){
        //
        MyShowNewPickedTitleTodayItem *titleItem=(MyShowNewPickedTitleTodayItem *)item;
        MyShowNewPickedTitleFriendsCell *titleCell=[tableView dequeueReusableCellWithIdentifier:titleItem.identify];
        if (!titleCell) {
            titleCell=[[MyShowNewPickedTitleFriendsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleItem.identify];
        }
        titleCell.backgroundColor = [UIColor whiteColor];
        titleCell.nameLabel.text=titleItem.username;
        titleCell.timeLabel.text=titleItem.time;
        SDWebImageManager *manager=[SDWebImageManager sharedManager];
        
        [titleCell.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:titleItem.avatarStr] forState:UIControlStateNormal];
        
        CGRect nameFrame = titleCell.nameLabel.frame;
        CGSize size = [titleItem.username boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:titleCell.nameLabel.font} context:nil].size;
        
        if (!(item.level_img.length<= 0)) {
            [manager downloadImageWithURL:[NSURL URLWithString:item.level_img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                titleCell.levelImageView.frame =CGRectMake(nameFrame.origin.x + size.width + 1, nameFrame.origin.y+5, image.size.width*0.8,image.size.height*0.8);
                
                titleCell.levelImageView.image = image;
            }];
        } else {
            titleCell.levelImageView.image = nil;
        }
        [titleCell.levelImageView setClickToViewController:clickVC];
        titleCell.delegate=self;
        titleCell.avatarBtn.indexpath=indexPath;
        cell=titleCell;
        
    }else if ([item isKindOfClass:[MyShowNewPickedTitleNotTodayItem class]]){
        
        MyShowNewPickedTitleNotTodayItem *titleItem=(MyShowNewPickedTitleNotTodayItem *)item;
        //
        MyShowNewPickedTitleNotTodayCell *titleCell=[tableView dequeueReusableCellWithIdentifier:titleItem.identify];
        if (!titleCell) {
            titleCell=[[MyShowNewPickedTitleNotTodayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleItem.identify];
        }
        titleCell.backgroundColor = [UIColor whiteColor];
        titleCell.nameLabel.text=titleItem.username;
        titleCell.dayLabel.text=titleItem.day;
        titleCell.monthLabel.text=[NSString stringWithFormat:@"%@月",titleItem.month];
        titleCell.yearLabel.text=[NSString stringWithFormat:@"%@年",titleItem.year];
        SDWebImageManager *manager=[SDWebImageManager sharedManager];
        [titleCell.avatarBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:titleItem.avatarStr] forState:UIControlStateNormal];
        
        CGRect nameFrame = titleCell.nameLabel.frame;
        CGSize size = [titleItem.username boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:titleCell.nameLabel.font} context:nil].size;
        
        if (!(item.level_img.length<= 0)) {
            [manager downloadImageWithURL:[NSURL URLWithString:item.level_img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                titleCell.levelImageView.frame = CGRectMake(nameFrame.origin.x + size.width + 1, nameFrame.origin.y+5,image.size.width*0.8,image.size.height*0.8);
                titleCell.levelImageView.image = image;
                
            }];
        } else {
            titleCell.levelImageView.image = nil;
        }
        [titleCell.levelImageView setClickToViewController:clickVC];
        
        titleCell.delegate=self;
        titleCell.avatarBtn.indexpath=indexPath;
        cell=titleCell;
        
    }else if ([item isKindOfClass:[MyOutPutDescribeItem class]]){
        
        MyOutPutDescribeItem *desItem=(MyOutPutDescribeItem *)item;
        
        MyShowNewDescribeCell *desCell=[tableView dequeueReusableCellWithIdentifier:desItem.identify];
        if (!desCell) {
            desCell=[[MyShowNewDescribeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:desItem.identify];
        }
        desCell.backgroundColor = [UIColor whiteColor];
        desCell.describeLabel.frame=CGRectMake(14, 5, 292, desItem.height);
        NSString *desContent = desItem.desContent;
        desContent = [desContent stringByReplacingOccurrencesOfString:@"" withString:@""];
        desCell.describeLabel.text=[NSString stringWithFormat:@"%@",desContent];
        if ([desCell.describeLabel.text hasPrefix:@"//来自☆话题//"]) {
            desCell.describeLabel.indexPath = indexPath;
            desCell.describeLabel.clickDelegate = self;
            [desCell.describeLabel setTextColor:[UIColor redColor] range:[desCell.describeLabel.text rangeOfString:@"//来自☆话题//"]];
            
            
        }else if([desCell.describeLabel.text hasPrefix:@"//来自活动☆"])
        {
            desCell.describeLabel.indexPath = indexPath;
            desCell.describeLabel.clickDelegate = self;
            // desCell.describeLabel.textColor = [UIColor redColor];
            [desCell.describeLabel setTextColor:[UIColor redColor] range:[desCell.describeLabel.text rangeOfString:@"来自活动☆"]];
        }
        else {
            desCell.describeLabel.indexPath = nil;
            desCell.describeLabel.clickDelegate = nil;
            desCell.describeLabel.textColor = [BBSColor hexStringToColor:@"6e6550"];
        }
        cell=desCell;
        
    }else if ([item isKindOfClass:[MyOutPutImgGroupItem class]]){
        //单个图片的样式
        MyOutPutImgGroupItem *imgItem=(MyOutPutImgGroupItem *) item;

        if (imgItem.photosArray.count==1) {
            /**
             *  这个是对的，先做测试，注掉
             */
            if (imgItem.video_url.length >0 ) {
                //播放视频的
                static NSString *identifier =@"PLAYVIDEOCELL";
                PlayVideoCell *playCell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!playCell) {
                    playCell = [[PlayVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                playCell.delegate = self;
                playCell.playSamllBtn.indexpath = indexPath;
                playCell.ImgBtn.indexpath = indexPath;
                playCell.grayView.indexpath = indexPath;
                playCell.imgBigBtn.indexpath = indexPath;
                MyShowImageItem *imgthing=[imgItem.photosArray firstObject];
                float height = [imgthing.img_thumb_height floatValue];
                float weight = [imgthing.img_thumb_width floatValue];
                SDWebImageManager *manager=[SDWebImageManager sharedManager];
                //长图
                if (height>weight) {
                    [manager downloadImageWithURL:[NSURL URLWithString:imgthing.imageStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        [playCell.ImgBtn setBackgroundImage:image forState:UIControlStateNormal];
                        [playCell.imgBigBtn setBackgroundImage:image forState:UIControlStateNormal];
                        playCell.imgBigBtn.hidden = NO;
                        playCell.grayView.hidden = NO;
                    }];

                }else{
                [manager downloadImageWithURL:[NSURL URLWithString:imgthing.imageStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [playCell.ImgBtn setBackgroundImage:image forState:UIControlStateNormal];
                    playCell.imgBigBtn.hidden = YES;
                    playCell.grayView.hidden = YES;
                }];
                }
                cell=playCell;
            }else{

            MyOutPutSingleImgCell *singleImgCell=[tableView dequeueReusableCellWithIdentifier:imgItem.identify];
            if (!singleImgCell) {
                               singleImgCell=[[MyOutPutSingleImgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imgItem.identify];
                               }
                               singleImgCell.backgroundColor = [UIColor whiteColor];
                               [singleImgCell.imgBtn setBackgroundImage:nil forState:UIControlStateNormal];
                               singleImgCell.imgBtn.indexpath=indexPath;
                               singleImgCell.delegate=self;
                               [LoadingView startOntheView:singleImgCell.imgBtn];
                               singleImgCell.imgBtn.frame=imgItem.frame;
                               MyShowImageItem *imgthing=[imgItem.photosArray firstObject];
                               SDWebImageManager *manager=[SDWebImageManager sharedManager];
                               [manager downloadImageWithURL:[NSURL URLWithString:imgthing.imageStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                               
                               } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                               [LoadingView stopOnTheView:singleImgCell.imgBtn];
                               CATransition *animation = [CATransition animation];
                               [animation setDuration:0.1];
                               [animation setFillMode:kCAFillModeForwards];
                               [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
                               [singleImgCell.imgBtn.layer addAnimation:animation forKey:nil];
                               
                               if (singleImgCell.imgBtn.indexpath==indexPath) {
                               
                               [singleImgCell.imgBtn setBackgroundImage:image forState:UIControlStateNormal];
                               
                               }
                               
                               }];
                cell = singleImgCell;
                    }
            
        }else{
            MyShowNewPhotoCell *imgGroupCell=[tableView dequeueReusableCellWithIdentifier:imgItem.identify];
            if (!imgGroupCell) {
                imgGroupCell=[[MyShowNewPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imgItem.identify];
            }
            imgGroupCell.backgroundColor = [UIColor whiteColor];
            
            for (btnWithIndexPath *btn in imgGroupCell.btnArry) {
                btn.hidden=YES;
                [btn setBackgroundImage:nil forState:UIControlStateNormal];
            }
            
            imgGroupCell.delegate=self;
            
            NSUInteger maxNum=imgItem.photosArray.count>2?2:imgItem.photosArray.count;
            
            for (int i=0;  i< maxNum; i++) {
                
                MyShowImageItem *imgThing=[imgItem.photosArray objectAtIndex:i];
                btnWithIndexPath *btn=[imgGroupCell.btnArry objectAtIndex:i];
                [btn setBackgroundImage:nil forState:UIControlStateNormal];
                btn.hidden=NO;
                [LoadingView startOntheView:btn];
                btn.indexpath=indexPath;
                
                SDWebImageManager *manager=[SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:imgThing.imageStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [LoadingView stopOnTheView:btn];
                    CATransition *animation = [CATransition animation];
                    [animation setDuration:0.1];
                    [animation setFillMode:kCAFillModeForwards];
                    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
                    [btn.layer addAnimation:animation forKey:nil];
                    if (btn.indexpath==indexPath) {
                        [btn setBackgroundImage:image forState:UIControlStateNormal];
                        
                    }
                    
                }];
                
            }
            imgGroupCell.imageview.hidden=YES;
            if (imgItem.photosArray.count>2) {
                imgGroupCell.countLabel.text=[NSString stringWithFormat:@"%lu张",(unsigned long)imgItem.photosArray.count];
                imgGroupCell.imageview.hidden=NO;
            }
            
            cell=imgGroupCell;
            
        }
        
    }else if ([item isKindOfClass:[MyOutPutPraiseAndReviewItem class]]){
        
        MyOutPutPraiseAndReviewItem *pItem=(MyOutPutPraiseAndReviewItem *)item;
        
        MyOutPutPraiseAndReviewCell *pCell=[tableView dequeueReusableCellWithIdentifier:pItem.identify];
        if (!pCell) {
            pCell=[[MyOutPutPraiseAndReviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pItem.identify];
        }
        pCell.backgroundColor = [UIColor whiteColor];
        [pCell.praiseBtn setTitle:[NSString stringWithFormat:@"%@",pItem.praise_count] forState:UIControlStateNormal];
        [pCell.reviewBtn setTitle:[NSString stringWithFormat:@"%@",pItem.review_count] forState:UIControlStateNormal];
        if (pItem.isPraised==YES) {
            [pCell.praiseBtn setBackgroundImage:[UIImage imageNamed:@"btn_myoutput_praised"] forState:UIControlStateNormal];
        }else{
            [pCell.praiseBtn setBackgroundImage:[UIImage imageNamed:@"btn_unlike"] forState:UIControlStateNormal];
        }
        if ([pItem.img_cate isEqualToString:@"1"]) {
            pCell.typeView.hidden = NO;
        }else{
            pCell.typeView.hidden = YES;
        }
        pCell.delegate=self;
        pCell.praiseBtn.tag=indexPath.section;
        pCell.reviewBtn.tag=indexPath.section;
        pCell.moreBtn.tag=indexPath.section;
        cell=pCell;
        
    }
    //        }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

#pragma mark 点赞
-(void)praiseSucceed{
    
    NSArray *singleArray=[_dataArrayNew objectAtIndex:_praiseSection];
    MyOutPutPraiseAndReviewItem *pItem=[singleArray lastObject];
    
    int count=[pItem.praise_count intValue];
    
    if (pItem.isPraised==YES) {
        pItem.isPraised=NO;
        count--;
        pItem.praise_count=[NSString stringWithFormat:@"%d",count];
    }else{
        pItem.isPraised=YES;
        count++;
        pItem.praise_count=[NSString stringWithFormat:@"%d",count];
    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:singleArray.count-1 inSection:_praiseSection];
    NSArray *array=[NSArray arrayWithObject:indexPath];
    
    [_tableViewNew reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    
}

-(void)praiseFail:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];
    
}
#pragma mark 删除秀秀

-(void)deleteShowSucceed:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];

    
    NSIndexSet *set=[[NSIndexSet alloc]initWithIndex:_deleteSection];
    
    NSArray *itemsArray=[_dataArrayNew objectAtIndex:_deleteSection];
    NSMutableArray *indexPathsArray=[[NSMutableArray alloc]init];
    
    for (int i=0;i<itemsArray.count;i++) {
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:_deleteSection];
        [indexPathsArray addObject:indexPath];
        
    }
    
    [_dataArrayNew removeObjectAtIndex:_deleteSection];
    
    [_tableViewNew beginUpdates];
    
    [_tableViewNew deleteRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationFade];
    [_tableViewNew deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
    
    [_tableViewNew endUpdates];
    
    [_tableViewNew reloadData];
}

-(void)deleteShowFail:(NSNotification *)not{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}
#pragma mark 添加关注

-(void)focusSucceed{
    
    [self refreshTitleInSection:_focusSection];
}
-(void)focusFail:(NSNotification *) note{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=note.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}
-(void)refreshTitleInSection:(NSInteger) section{
    
    NSMutableArray *singleArray=[_dataArrayNew objectAtIndex:section];
    MyShowNewBasicItem *item=[singleArray firstObject];
    NSDictionary *newParam=[NSDictionary dictionaryWithObjectsAndKeys:
                            LOGIN_USER_ID,@"login_user_id",
                            item.imgid,@"img_id",nil];
    UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:@"getBabyImgInfo" Method:NetMethodGet andParam:newParam];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
    __weak ASIHTTPRequest *blockRequest = request;
    [request setCompletionBlock:^{
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:blockRequest.responseData options:0 error:nil];
        
        if ([[dic objectForKey:@"success"] integerValue]==1) {
            
            NSArray *dataArray=[dic objectForKey:@"data"];
            
            for (NSDictionary *dic in dataArray) {
                
                NSDictionary *imgDic=[dic objectForKey:kMyShowImg];
                
                NSNumber *time=[imgDic objectForKey:kMyShowCreatTime];
                
                if ([[imgDic objectForKey:@"is_focus"] intValue]==0) {
                    
                    MyShowNewPickedTitleFocusItem *titleItem=[[MyShowNewPickedTitleFocusItem alloc]init];
                    titleItem.imgid=[imgDic objectForKey:kMyShowImgId];
                    titleItem.height=43;
                    titleItem.avatarStr=[imgDic objectForKey:@"avatar"];
                    titleItem.username=[imgDic objectForKey:@"user_name"];
                    titleItem.userid=[imgDic objectForKey:@"user_id"];
                    titleItem.identify=@"TITLEFOCUS";
                    titleItem.level_img = [imgDic objectForKey:@"level_img"];
                    [singleArray replaceObjectAtIndex:0 withObject:titleItem];
                    
                }else if ([BBSTimeTool isToday:time]==YES){
                    MyShowNewPickedTitleTodayItem *titleItem=[[MyShowNewPickedTitleTodayItem alloc]init];
                    titleItem.imgid=[imgDic objectForKey:kMyShowImgId];
                    titleItem.time=[BBSTimeTool getTimeStrFromNow:time];
                    titleItem.height=43;
                    titleItem.avatarStr=[imgDic objectForKey:@"avatar"];
                    titleItem.username=[imgDic objectForKey:@"user_name"];
                    titleItem.userid=[imgDic objectForKey:@"user_id"];
                    titleItem.identify=@"PICKEDTITLETODAY";
                    titleItem.level_img = [imgDic objectForKey:@"level_img"];
                    [singleArray replaceObjectAtIndex:0 withObject:titleItem];
                    
                }else if ([BBSTimeTool isToday:time]==NO){
                    
                    MyShowNewPickedTitleNotTodayItem *titleItem=[[MyShowNewPickedTitleNotTodayItem alloc]init];
                    titleItem.imgid=[imgDic objectForKey:kMyShowImgId];
                    titleItem.avatarStr=[imgDic objectForKey:@"avatar"];
                    titleItem.username=[imgDic objectForKey:@"user_name"];
                    titleItem.userid=[imgDic objectForKey:@"user_id"];
                    titleItem.level_img = [imgDic objectForKey:@"level_img"];
                    NSDateComponents *components=[BBSTimeTool MyOutPutGetTime:time];
                    titleItem.day=[NSString stringWithFormat:@"%ld",(long)[components day]];
                    if (titleItem.day.length<2) {
                        titleItem.day=[NSString stringWithFormat:@"0%ld",(long)[components day]];
                    }
                    titleItem.month=[NSString stringWithFormat:@"%ld",(long)[components month]];
                    titleItem.year=[NSString stringWithFormat:@"%ld",(long)[components year]];
                    titleItem.height=42;
                    titleItem.identify=@"PICKEDTITLENOTTODAY";
                    [singleArray replaceObjectAtIndex:0 withObject:titleItem];
                    
                }
            }
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:section];
            NSArray *indexArray=[NSArray arrayWithObjects:indexPath, nil];
            [_tableViewNew reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
            
        }
        else{
            
        }
        
        
    }];
    [request startAsynchronous];
    
    [LoadingView stopOnTheViewController:self];
    
}
#pragma mark 有评论之后的刷新
-(void)refreshReviewCountInSection:(NSInteger) section{
    
    NSMutableArray *singleArray=[_dataArrayNew objectAtIndex:section];
    MyShowNewBasicItem *item=[singleArray firstObject];
    
    NSDictionary *newParam=[NSDictionary dictionaryWithObjectsAndKeys:item.userid,@"user_id",
                            LOGIN_USER_ID,@"login_user_id",
                            @"1",@"is_new",
                            item.imgid,@"img_id",nil];
    UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kImgInfo Method:NetMethodGet andParam:newParam];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
    __weak ASIHTTPRequest *blockRequest = request;
    [request setCompletionBlock:^{
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:blockRequest.responseData options:0 error:nil];
        
        if ([[dic objectForKey:@"success"] integerValue]==1) {
            
            NSArray *dataArray=[dic objectForKey:@"data"];
            
            for (NSDictionary *dic in dataArray) {
                NSDictionary *imgDic=[dic objectForKey:kMyShowImg];
                MyOutPutPraiseAndReviewItem *pItem=[singleArray lastObject];
                pItem.review_count=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"review_count"]];
                
            }
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:singleArray.count-1 inSection:section];
            NSArray *indexArray=[NSArray arrayWithObjects:indexPath, nil];
            [_tableViewNew reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
            
        }
        else{
            
        }
        
    }];
    [request startAsynchronous];
    
    [LoadingView stopOnTheViewController:self];
    
    
}
#pragma mark cell_delegate各个代理

-(void)PickedBabyClickOnTheAvatar:(btnWithIndexPath *)btn{
    
    NSArray *singleArray=[_dataArrayNew objectAtIndex:btn.indexpath.section];
    MyShowNewBasicItem *item=[singleArray objectAtIndex:btn.indexpath.row];
    
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.userid=[NSString stringWithFormat:@"%@",item.userid];
    myHomePage.hidesBottomBarWhenPushed=YES;
    
    if ([item.userid intValue]==[LOGIN_USER_ID intValue]) {
        
        myHomePage.Type=0;
        
    }else{
        
        myHomePage.Type=1;
        
    }
    
    [self.navigationController pushViewController:myHomePage animated:YES];
    
}

-(void)PickedTitleNotTodayGotoTheUserPage:(btnWithIndexPath *)btn{
    
    NSArray *singleArray=[_dataArrayNew objectAtIndex:btn.indexpath.section];
    MyShowNewBasicItem *item=[singleArray objectAtIndex:btn.indexpath.row];
    
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.userid=[NSString stringWithFormat:@"%@",item.userid];
    myHomePage.hidesBottomBarWhenPushed=YES;
    
    if ([item.userid intValue]==[LOGIN_USER_ID intValue]) {
        
        myHomePage.Type=0;
        
    }else{
        
        myHomePage.Type=1;
        
    }
    
    [self.navigationController pushViewController:myHomePage animated:YES];
    
    
}

-(void)PickedTitleFriendsCellGotoTheUserPage:(btnWithIndexPath *)btn{
    NSArray *singleArray=[_dataArrayNew objectAtIndex:btn.indexpath.section];
    MyShowNewBasicItem *item=[singleArray objectAtIndex:btn.indexpath.row];
    
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.userid=[NSString stringWithFormat:@"%@",item.userid];
    myHomePage.hidesBottomBarWhenPushed=YES;
    
    if ([item.userid intValue]==[LOGIN_USER_ID intValue]) {
        
        myHomePage.Type=0;
        
    }else{
        
        myHomePage.Type=1;
        
    }
    
    [self.navigationController pushViewController:myHomePage animated:YES];
    
}

-(void)PickedTitleCellGotoTheUserPage:(btnWithIndexPath *)btn{
    NSArray *singleArray=[_dataArrayNew objectAtIndex:btn.indexpath.section];
    MyShowNewBasicItem *item=[singleArray objectAtIndex:btn.indexpath.row];
    
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.userid=[NSString stringWithFormat:@"%@",item.userid];
    myHomePage.hidesBottomBarWhenPushed=YES;
    
    if ([item.userid intValue]==[LOGIN_USER_ID intValue]) {
        
        myHomePage.Type=0;
        
    }else{
        
        myHomePage.Type=1;
        
    }
    
    [self.navigationController pushViewController:myHomePage animated:YES];
    
}

-(void)PickedTitleCellAddFocus:(btnWithIndexPath *)btn{
    
    _focusSection=btn.indexpath.section;
    
    NSArray *singleArray=[_dataArrayNew objectAtIndex:btn.indexpath.section];
    MyShowNewBasicItem *item=[singleArray objectAtIndex:btn.indexpath.row];
    
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setObject:item.userid forKey:@"idol_id"];
    [param setObject:LOGIN_USER_ID forKey:@"user_id"];
    
    NetAccess *net=[NetAccess sharedNetAccess];
    [net getDataWithStyle:NetStyleFocusOn andParam:param];
    [LoadingView startOnTheViewController:self];
    
}

-(void)ClickOnTheAvatar:(btnWithIndexPath *)btn{
    
    NSArray *singleArray=[_dataArrayNew objectAtIndex:btn.indexpath.section];
    MyShowNewTitleItemToday *item=[singleArray objectAtIndex:btn.indexpath.row];
    
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.userid=[NSString stringWithFormat:@"%@",item.userid];
    myHomePage.hidesBottomBarWhenPushed=YES;
    
    if ([item.userid intValue]==[LOGIN_USER_ID intValue]) {
        
        myHomePage.Type=0;
        
    }else{
        
        myHomePage.Type=1;
        
    }
    
    [self.navigationController pushViewController:myHomePage animated:YES];
    
}

-(void)ClickOnTheAvatarNotToday:(btnWithIndexPath *)btn{
    
    NSArray *singleArray=[_dataArrayNew objectAtIndex:btn.indexpath.section];
    MyShowNewTitleItemToday *item=[singleArray objectAtIndex:btn.indexpath.row];
    
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.userid=[NSString stringWithFormat:@"%@",item.userid];
    myHomePage.hidesBottomBarWhenPushed=YES;
    
    if ([item.userid intValue]==[LOGIN_USER_ID intValue]) {
        
        myHomePage.Type=0;
        
    }else{
        
        myHomePage.Type=1;
        
    }
    
    [self.navigationController pushViewController:myHomePage animated:YES];
}

-(void)jumpToTheWebView:(btnWithIndexPath *)btn{
    
    NSArray *singleArray=[_dataArrayNew objectAtIndex:btn.indexpath.section];
    MyOutPutUrlItem *urlItem=[singleArray objectAtIndex:btn.indexpath.row];
    
    WebViewController *webVC=[[WebViewController alloc]init];
    webVC.urlStr=urlItem.url_string;
    [webVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webVC animated:YES];
    
}

//点击图片进入图片详情

-(void)gotoTheDetail:(btnWithIndexPath *)btn{
    
    [_PhotoArray removeAllObjects];
    
    NSArray *singleArray=[_dataArrayNew objectAtIndex:btn.indexpath.section];
    MyOutPutImgGroupItem *photoItem=[singleArray objectAtIndex:btn.indexpath.row];
    
    NSMutableArray *imgArr = [[NSMutableArray alloc]init];
    int i = 0;
    for (MyShowImageItem *imgItem in photoItem.photosArray) {
        
        NSMutableDictionary *imgDic=[[NSMutableDictionary alloc]init];
        [imgDic setObject:imgItem.imageClearStr forKey:kMyShowImg];
        [imgDic setObject:imgItem.img_down forKey:kMyShowImgDown];
        [imgDic setObject:imgItem.img_width forKey:kMyShowImgWidth];
        [imgDic setObject:imgItem.img_height forKey:kMyShowImgHeight];
        [imgDic setObject:imgItem.imageStr forKey:kMyShowImgThumb];
        [imgDic setObject:imgItem.img_thumb_width forKey:kMyShowImgThumbWidth];
        [imgDic setObject:imgItem.img_thumb_height forKey:kMyShowImgThumbHeight];
        [imgArr addObject:imgDic];
        MWPhoto *photo=[[MWPhoto alloc]initWithURL:[NSURL URLWithString:imgItem.imageClearStr] info:nil];
        photo.img_info =@{@"description": [NSString stringWithFormat:@"%d/%lu",i+1,(unsigned long)photoItem.photosArray.count]};
        [_PhotoArray addObject:photo];
        i++;
        
    }
    
    MWPhotoBrowser *browser =[[ MWPhotoBrowser alloc]initWithDelegate:self];
    //    browser.imgstr=imgItem.imageStr;
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    [browser setCurrentPhotoIndex:btn.tag];
    browser.type = 10;
    browser.needPlay = YES;     //需要播放
    browser.imgArr = imgArr;    //播放需要的东西
    browser.is_show_album =NO;
    browser.user_id =self.userid;
    
    BBSNavigationController *nav=[[BBSNavigationController alloc]initWithRootViewController:browser];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)clickLabel:(ClickDescLabel *)label touchesWithIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *singleArray = [_dataArrayNew objectAtIndex:indexPath.section];
    MyOutPutDescribeItem *desItem= [singleArray objectAtIndex:2];
    MyShowNewBasicItem *item = [singleArray objectAtIndex:0];
    MyOutPutPraiseAndReviewItem *item1 = [singleArray lastObject];
    if (item1.cate_id != 0 && [desItem.desContent hasPrefix:@"//来自活动"]) {
        SpecialDetailTVC *specialTVC = [[SpecialDetailTVC alloc]init];
        specialTVC.cate_id = item1.cate_id;
        specialTVC.login_user_id = LOGIN_USER_ID;
        specialTVC.isFromMyShow = YES;
        [self.navigationController pushViewController:specialTVC animated:YES];
    }
    else if (item1.groupId != 0){
        //
        
        NSString *string = [NSString stringWithFormat:@"%ld",item1.groupId];
        [self pushPostMyGroupDetailVC:string];
        
    }else{
        if (item1.videoUrl.length>0) {
            //话题是视频的时候，需要直接跳转
            BabyShowPlayerVC *babyShowPlayerVc = [[BabyShowPlayerVC alloc]init];
            babyShowPlayerVc.videoUrl = item1.videoUrl;
            babyShowPlayerVc.img_id = item1.imgid;
            [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
 
        }else{
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                LOGIN_USER_ID,@"login_user_id",
                                item.userid,@"user_id",
                                item.imgid,@"img_id",
                                item.create_time,@"create_time", nil];
        [LoadingView startOnTheViewController:self];
        
        [[HTTPClient sharedClient] getNew:kGoToPost params:params success:^(NSDictionary *result) {
            [LoadingView stopOnTheViewController:self];
            if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
                NSDictionary *dict = [result objectForKey:kBBSData];
                PostBarNewDetialV1VC *detailVC=[[PostBarNewDetialV1VC alloc]init];
                detailVC.img_id = [dict objectForKey:@"img_id"];
                detailVC.user_id = item.userid;
                detailVC.login_user_id = LOGIN_USER_ID;
                detailVC.refreshInVC = ^(BOOL isRefresh){
                    
                };
                [detailVC setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:detailVC animated:YES];
                
            } else {
                
            }
        } failed:^(NSError *error) {
            [LoadingView stopOnTheViewController:self];
        }];
    }
    }
}
#pragma mark 跳转群详情
-(void)pushPostMyGroupDetailVC:(NSString *)imgId{
    PostBarNewGroupOnlyOneVC *postBarVC = [[PostBarNewGroupOnlyOneVC alloc]init];
    postBarVC.group_id = [imgId intValue];
    [self.navigationController pushViewController:postBarVC animated:YES];
    
}


-(void)SeeTheSingleImage:(btnWithIndexPath *)btn{
    
    [_PhotoArray removeAllObjects];
    
    NSArray *singleArray=[_dataArrayNew objectAtIndex:btn.indexpath.section];
    MyOutPutImgGroupItem *photoItem=[singleArray objectAtIndex:btn.indexpath.row];
    
    NSMutableArray *imgArr = [[NSMutableArray alloc]init];
    int i = 0;
    for (MyShowImageItem *imgItem in photoItem.photosArray) {
        
        NSMutableDictionary *imgDic=[[NSMutableDictionary alloc]init];
        [imgDic setObject:imgItem.imageClearStr forKey:kMyShowImg];
        [imgDic setObject:imgItem.img_down forKey:kMyShowImgDown];
        [imgDic setObject:imgItem.img_width forKey:kMyShowImgWidth];
        [imgDic setObject:imgItem.img_height forKey:kMyShowImgHeight];
        [imgDic setObject:imgItem.imageStr forKey:kMyShowImgThumb];
        [imgDic setObject:imgItem.img_thumb_width forKey:kMyShowImgThumbWidth];
        [imgDic setObject:imgItem.img_thumb_height forKey:kMyShowImgThumbHeight];
        [imgArr addObject:imgDic];
        MWPhoto *photo=[[MWPhoto alloc]initWithURL:[NSURL URLWithString:imgItem.imageClearStr] info:nil];
        photo.img_info =@{@"description": [NSString stringWithFormat:@"1/1"]};
        [_PhotoArray addObject:photo];
        i++;
        
    }
    
    MWPhotoBrowser *browser =[[ MWPhotoBrowser alloc]initWithDelegate:self];
    //    browser.imgstr=imgItem.imageStr;
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    [browser setCurrentPhotoIndex:btn.tag];
    browser.type = 10;
    browser.needPlay = NO;     //需要播放
    browser.imgArr = imgArr;    //播放需要的东西
    browser.is_show_album =NO;
    browser.user_id =self.userid;
    
    BBSNavigationController *nav=[[BBSNavigationController alloc]initWithRootViewController:browser];
    [self presentViewController:nav animated:YES completion:nil];
    
}

-(void)praise:(UIButton *)btn{
    
    _praiseSection=btn.tag;
    
    NetAccess *net=[NetAccess sharedNetAccess];
    
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:LOGIN_USER_ID forKey:kAdmireUserId];
    
    NSArray *singleArray=[_dataArrayNew objectAtIndex:btn.tag];
    MyOutPutPraiseAndReviewItem *pItem=[singleArray lastObject];
    [paramDic setObject:pItem.userid forKey:kAdmireAdmireId];
    [paramDic setObject:pItem.imgid forKey:kAdmireImgId];
    if (pItem.videoUrl.length > 0) {
        [paramDic setObject:@"1" forKey:@"ispost"];
    }
    if (pItem.isPraised==YES) {
        [net getDataWithStyle:NetStyleCancelAdmire andParam:paramDic];
    }else{
        [net getDataWithStyle:NetStyleAdmire andParam:paramDic];
    }
    
    
}

-(void)review:(UIButton *)btn{
    _isIntheVCReview = YES;
    _reviewSection=btn.tag;
    NSArray *singleArray=[_dataArrayNew objectAtIndex:btn.tag];
    MyOutPutPraiseAndReviewItem *pItem=[singleArray lastObject];
    if (pItem.videoUrl.length) {
        BabyShowPlayerVC *babyShowPlayerVc = [[BabyShowPlayerVC alloc]init];
        babyShowPlayerVc.videoUrl = pItem.videoUrl;
        babyShowPlayerVc.img_id = pItem.imgid;
        [self.navigationController pushViewController:babyShowPlayerVc animated:YES];

    }else{
        PostBarNewDetialV1VC *detailVC = [[PostBarNewDetialV1VC alloc]init];
        detailVC.img_id=[NSString stringWithFormat:@"%@",pItem.imgid];
        detailVC.user_id = pItem.userid;
        detailVC.login_user_id=LOGIN_USER_ID;
        detailVC.refreshInVC = ^(BOOL isRefresh){
        };
        [detailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }
}

//分享删除等
-(void)more:(UIButton *)btn{
    
    NSArray *singleArray=[_dataArrayNew objectAtIndex:btn.tag];
    MyOutPutPraiseAndReviewItem *pItem=[singleArray lastObject];
    NSLog(@"pitem yyyyyy = %@",pItem.videoUrl);
    
    NSArray *superUser = [BABYSHOWSUPERGRANTUSER componentsSeparatedByString:@","];
    BOOL isSuperGrant = NO;
    for (int i = 0 ; i < superUser.count; i++) {
        NSString *user = [superUser objectAtIndex:i];
        if ([LOGIN_USER_ID integerValue] == [user integerValue] )  {
            isSuperGrant = YES;
            break;
        }
    }
    
    NSString *message ;
    if ([pItem.userid intValue]==[LOGIN_USER_ID intValue] || isSuperGrant) {
        message = @"删除";
    }else{
        message = @"举报";
    }
    _deleteSection = btn.tag;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >=8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            //不是视频的时候
        UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            if (pItem.videoUrl.length > 0) {
                [self shareVedio];

            }else{
            [self shareToThird];
            }
        }];
         [alertController addAction:shareAction];
        
        [alertController addAction:[UIAlertAction actionWithTitle:message style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self deleteOrReport];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
            
    } else {
        UIActionSheet *action;
        if (pItem.videoUrl.length>0) {
            action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享",message,nil];
            action.tag=btn.tag;
            action.destructiveButtonIndex = action.numberOfButtons - 2;
            
        }else{
        action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享",message,nil];
        action.tag=btn.tag;
        action.destructiveButtonIndex = action.numberOfButtons - 2;

        }
        [action showFromTabBar:self.tabBarController.tabBar];
    }
    
}
-(void)shareVedio{
    //1、创建分享参数（必要）
    NSArray *singleArray=[_dataArrayNew objectAtIndex:_deleteSection];
    NSString *userID,*imgID,*desc,*thumbString;
    
    MyShowNewBasicItem *item = singleArray[0];
    userID = item.userid;
    imgID = item.imgid;
    NSString *titleString;

    for (int i = 0; i < singleArray.count; i++) {
        
        if ([singleArray[i] isKindOfClass:[MyOutPutImgGroupItem class]]) {
            MyOutPutImgGroupItem *photoItem = singleArray[i];
            MyShowImageItem *imageItem = [photoItem.photosArray firstObject];
            thumbString = imageItem.imageStr;
            titleString = photoItem.desecontent;
            continue;
        }
        if ([singleArray[i] isKindOfClass:[MyOutPutDescribeItem class]]) {
            MyOutPutDescribeItem *descItem = singleArray[i];
            desc = descItem.desContent;
            if ([desc hasPrefix:@"//来自☆话题//"]) {
                desc = [desc substringFromIndex:[desc rangeOfString:@"//来自☆话题//"].length];
            }
            break;
        }
    }

    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray;
    UIImage *shareImg;
    if (thumbString.length > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",thumbString]];
        shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        NSData *basicImgData = UIImagePNGRepresentation(shareImg);
        if (basicImgData.length/1024>150) {
            shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
            
        }
        
    }else{
        shareImg = [UIImage imageNamed:@"img_default"];
        
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@img_id=%@&user_id=%@",VideoShareUrl,imgID,userID];
    NSURL *shareUrl = [NSURL URLWithString:urlString];
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",titleString,shareUrl];
    //设置微博
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:titleString image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
    //设置微信好友
    [shareParams SSDKSetupWeChatParamsByText:titleString title:titleString url:shareUrl thumbImage:shareImg image:shareImg musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    //设置微信圈
    [shareParams SSDKSetupWeChatParamsByText:titleString title:titleString url:shareUrl thumbImage:shareImg image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    //设置qq
    [shareParams SSDKSetupQQParamsByText:titleString title:titleString url:shareUrl  thumbImage:shareImg image:shareImg type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    //设置qq空间
    [shareParams SSDKSetupQQParamsByText:titleString title:titleString url:shareUrl  thumbImage:shareImg image:shareImg type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQZone];
    //设置拷贝
    [shareParams SSDKSetupCopyParamsByText:titleString images:imageArray url:shareUrl type:SSDKContentTypeAuto];
    
    
    
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
                break;
            }
                
            default:
                break;
        }
    }];

}
#pragma mark -点击图片跳转播放详情页面
-(void)playVideoUrl:(btnWithIndexPath *)btn{
   
    _currentIndexPath = btn.indexpath;
    NSArray *singleArray=[_dataArrayNew objectAtIndex:_currentIndexPath.section];
    MyOutPutImgGroupItem *photoItem=[singleArray objectAtIndex:_currentIndexPath.row];
    
    BabyShowPlayerVC *babyShowPlayerVc = [[BabyShowPlayerVC alloc]init];
    babyShowPlayerVc.videoUrl = photoItem.video_url;
    babyShowPlayerVc.img_id = photoItem.imgid;
    [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
    
}
#pragma mark -点击本页面播放
-(void)playVideoInTheView:(btnWithIndexPath *)btn{
    _currentIndexPath = btn.indexpath;
    _currentCell = [_tableViewNew cellForRowAtIndexPath:btn.indexpath];
    //检查网络设置
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NSParameterAssert([reach isKindOfClass:[Reachability class]]);
    NetworkStatus stats = [reach currentReachabilityStatus];
    if (stats == NotReachable) {
        [BBSAlert showAlertWithContent:@"您似乎与网络断开，检查一下网络设置" andDelegate:self];
        
    }else if(stats == ReachableViaWiFi){
        NSLog(@"网络wifi");
        [self canPlayVideo];

        
    }else if (stats == ReachableViaWWAN|| stats == kReachableVia4G || stats == kReachableVia3G || stats == kReachableVia2G){

        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您当前并未连接WIFI，继续播放将使用手机流量，是否继续？" preferredStyle:UIAlertControllerStyleAlert];
            __weak LoveBabySecondVC *babyVC = self;
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [babyVC canPlayVideo];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您当前并未连接WIFI，继续播放将使用手机流量，是否继续？" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"继续", nil];
            alertView.tag = 101;
            [alertView show];
        }
    }
    
}
#pragma mark 点击播放
-(void)canPlayVideo{
    NSArray *singleArray=[_dataArrayNew objectAtIndex:_currentIndexPath.section];
    MyOutPutImgGroupItem *photoItem=[singleArray objectAtIndex:_currentIndexPath.row];
    MyShowImageItem *imgthing=[photoItem.photosArray firstObject];
    SDWebImageManager *manager=[SDWebImageManager sharedManager];

    if (_showPlayer) {
        
        [_showPlayer removeFromSuperview];
        _showPlayer.videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",photoItem.video_url]];
    }else{
        _showPlayer = [[XSMediaPlayer alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.6+20)];
        _showPlayer.videoURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@",photoItem.video_url]];
        
    }
    [manager downloadImageWithURL:[NSURL URLWithString:imgthing.imageStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [_showPlayer settingBackgroupImg:image];
        
    }];
    
    _showPlayer.isFromList = YES;
    _showPlayer.imgID = photoItem.imgid;
    _showPlayer.videoUrlString = photoItem.video_url;
    _showPlayer.nav = self.navigationController;
    [_showPlayer.player play];
    [_currentCell addSubview:_showPlayer ];

}
#pragma mark -scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _tableViewNew) {
        if (_showPlayer == nil) {
            return;
        }
        if (_showPlayer.superview) {
            CGRect rectInTableView = [_tableViewNew rectForRowAtIndexPath:_currentIndexPath];
            CGRect rectInSuperview = [_tableViewNew convertRect:rectInTableView toView:[_tableViewNew superview]];
            if (rectInSuperview.origin.y-kNavbarHeight <-(SCREENWIDTH*0.6+20)||rectInSuperview.origin.y>SCREENHEIGHT) {
                [_showPlayer.player pause];
                [_showPlayer playRelease];
                [_showPlayer removeFromSuperview];
                [_tableViewNew reloadData];
              
            }else{
                if (![_currentCell.subviews containsObject:_showPlayer]) {
                    [_showPlayer playOrPause:YES ];
                }
                
            }
            
        }
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
    }else{
        [self canPlayVideo];
    }

}

#pragma mark - UIActionsheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    _deleteSection=actionSheet.tag;
    NSArray *singleArray=[_dataArrayNew objectAtIndex:_deleteSection];
    MyOutPutPraiseAndReviewItem *pItem=[singleArray lastObject];

    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:NO];
    if (actionSheet.numberOfButtons == 2) {
        if (buttonIndex == 0) {
            [self deleteOrReport];
            //分享
            //如果actionsheet没有完全消失就调用分享列表会崩溃
            
        }
        
    }else{

    if (buttonIndex == 0) {

        //如果actionsheet没有完全消失就调用分享列表会崩溃
        if (pItem.videoUrl > 0) {
            [self shareVedio];
        }else{
        [self shareToThird];
        }
        
    } else if (buttonIndex==1) {
        [self deleteOrReport];
    }
    }
    
}
- (void)deleteOrReport {
    NSArray *singleArray=[_dataArrayNew objectAtIndex:_deleteSection];
    MyOutPutPraiseAndReviewItem *pItem=[singleArray lastObject];
    
    NSArray *superUser = [BABYSHOWSUPERGRANTUSER componentsSeparatedByString:@","];
    BOOL isSuperGrant = NO;
    for (int i = 0 ; i < superUser.count; i++) {
        NSString *user = [superUser objectAtIndex:i];
        if ([LOGIN_USER_ID integerValue] == [user integerValue] )  {
            isSuperGrant = YES;
            break;
        }
    }
    
    if ([pItem.userid intValue]==[LOGIN_USER_ID intValue] || isSuperGrant) {
        //删除
        [LoadingView startOnTheViewController:self];
        
        NetAccess *net=[NetAccess sharedNetAccess];
        NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
        [paramDic setObject:LOGIN_USER_ID forKey:@"user_id"];
        [paramDic setObject:pItem.imgid forKey:@"img_ids"];
        if (pItem.videoUrl.length >0) {
            [paramDic setObject:@"1" forKey:@"is_video"];
        }

        [net getDataWithStyle:NetStyleDelShow andParam:paramDic];
    }else{
        //举报
        ReportViewController *report=[[ReportViewController alloc]init];
        report.imgId=pItem.imgid;
        report.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:report animated:YES];
        
    }
    
}
- (void)shareToThird {
    NSArray *singleArray=[_dataArrayNew objectAtIndex:_deleteSection];
    NSString *userID,*imgID,*desc,*thumbString;
    
    MyShowNewBasicItem *item = singleArray[0];
    userID = item.userid;
    imgID = item.imgid;
    
    for (int i = 0; i < singleArray.count; i++) {
        
        if ([singleArray[i] isKindOfClass:[MyOutPutImgGroupItem class]]) {
            MyOutPutImgGroupItem *photoItem = singleArray[i];
            MyShowImageItem *imageItem = [photoItem.photosArray firstObject];
            thumbString = imageItem.imageStr;
            continue;
        }
        if ([singleArray[i] isKindOfClass:[MyOutPutDescribeItem class]]) {
            MyOutPutDescribeItem *descItem = singleArray[i];
            desc = descItem.desContent;
            if ([desc hasPrefix:@"//来自☆话题//"]) {
                desc = [desc substringFromIndex:[desc rangeOfString:@"//来自☆话题//"].length];
            }
            break;
        }
    }
    //NSString *urlString = [NSString stringWithFormat:@"%@img_id=%@&user_id=%@",AppShareUrl,imgID,userID];
        NSString *urlString = [NSString stringWithFormat:@"%@img_id=%@&user_id=%@",PostShareUrl,imgID,userID];
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray;
    if (thumbString.length > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",thumbString]];
        UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        NSData *basicImgData = UIImagePNGRepresentation(shareImg);
        if (basicImgData.length/1024>150) {
            shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
            
        }
        imageArray = @[shareImg];
    }else{
        imageArray = @[[UIImage imageNamed:@"img_default"]];
        
    }
    [shareParams SSDKSetupShareParamsByText:desc
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]
                                      title:@"自由环球租赁宝宝秀一下"
                                       type:SSDKContentTypeAuto];
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",desc,[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:desc image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
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
                break;
            }
            case SSDKResponseStateCancel:
            {
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
- (void)copyURL:(NSString *)string {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:string];
}
#pragma mark - MWPhotoBrowserDelegate

-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    
    return _PhotoArray.count;
    
}
-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    if (index < _PhotoArray.count) {
        
        return [_PhotoArray objectAtIndex:index];
        
    }
    
    return nil;
    
}
#pragma mark 发秀秀
-(void)makeAShow{
    
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    
    if ([userItem.isVisitor boolValue]==YES ||LOGIN_USER_ID == NULL) {
        
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
        return;
    }
    
    
    MakeAShowViewController *makeAShow=[[MakeAShowViewController alloc]init];
    makeAShow.Type=0;
    makeAShow.tag_id = self.babyId;
    makeAShow.refreshMyBlock = ^(){
//        _postCreateTimeNew = NULL;
//        [self getdataArrayNewBabyShow];
    };
    [makeAShow setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:makeAShow animated:YES];
}
-(void)performDelay{
    UIAlertView *alertSucess = [[UIAlertView alloc]initWithTitle:APPNAME message:@"秀秀上传中" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [alertSucess show];
    _postCreateTimeNew = NULL;
    [self getdataArrayNewBabyShow];
    [self performSelector:@selector(dimissAlert:) withObject:alertSucess afterDelay:1];
}
-(void)dimissAlert:(UIAlertView *)alert{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}

#pragma mark time

-(NSString *)getTimeStrFromNow:(NSNumber *) time{
    
    NSTimeInterval nsTimeInterval = [time longLongValue]/1000;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    NSString *str=[self compareCurrentTime:date];
    return str;
}

-(BOOL)isToday:(NSNumber *)time{
    
    NSTimeInterval nsTimeInterval = [time longLongValue]/1000;
    NSDate *oneDay = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *todayStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:todayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending || result == NSOrderedAscending) {
        return NO;
    }
    return YES;
}

-(MyOutPutTitleItemNotToday *) MyOutPutGetTime:(NSNumber *) time{
    
    NSTimeInterval nsTimeInterval = [time longLongValue]/1000;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    NSInteger day = [components day];
    NSInteger month= [components month];
    NSInteger year= [components year];
    
    MyOutPutTitleItemNotToday *titleItem=[[MyOutPutTitleItemNotToday alloc]init];
    
    titleItem.day=[NSString stringWithFormat:@"%ld",(long)day];
    if (titleItem.day.length<2) {
        titleItem.day=[NSString stringWithFormat:@"0%ld",(long)day];
    }
    titleItem.month=[NSString stringWithFormat:@"%ld",(long)month];
    titleItem.year=[NSString stringWithFormat:@"%ld",(long)year];
    
    return titleItem;
    
}


-(NSString *) compareCurrentTime:(NSDate*) date

{
    
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        
        result = [NSString stringWithFormat:@"刚刚"];
        
    }
    
    else if((temp = timeInterval/60) <60){
        
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
        
    }
    
    else if((temp = temp/60) <24){
        
        result = [NSString stringWithFormat:@"%ld小时前",temp];
        
    }
    
    else if((temp = temp/24) <30){
        
        result = [NSString stringWithFormat:@"%ld天前",temp];
        
    }
    
    else if((temp = temp/30) <12){
        
        result = [NSString stringWithFormat:@"%ld月前",temp];
        
    }
    
    else{
        
        temp = temp/12;
        
        result = [NSString stringWithFormat:@"%ld年前",temp];
        
    }
    
    return  result;
    
}

- (NSString *)stringFromTime:(NSNumber *)time{
    
    NSTimeInterval nsTimeInterval = [time longLongValue]/1000;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
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
