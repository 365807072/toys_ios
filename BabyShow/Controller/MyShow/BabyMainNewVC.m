//
//  BabyMainNewVC.m
//  BabyShow
//
//  Created by WMY on 16/7/26.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "BabyMainNewVC.h"
#import "TESTFloatingView.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "ThreePictureOneBigCell.h"
#import "SinglePhotoForthCell.h"
#import "ThreePictureSmallCell.h"
#import "LeftPictureCell.h"
#import "SearchResultVC.h"
#import "BabyShowMainItem.h"
#import "PostBarFirstCell.h"
#import "PostBarSecondCell.h"
#import "UIButton+WebCache.h"
#import "ThreePictureSmallCell.h"
#import "PlayVideoMyMainCell.h"
#import "SinglePhotoForthCell.h"
#import "LeftPictureCell.h"
#import "PostBarListNewVC.h"//帖子和群，视频列表
#import "StoreMainNewListVC.h"//商家列表
#import "BabyShowPlayerVC.h"//视频详情
#import "PostBarNewDetialV1VC.h"//帖子详情
#import "StoreDetailNewVC.h"//商家详情
#import "PostMyGroupDetailVController.h"//群详情
#import "MyShowNewPickedTitleTodayItem.h"
#import "MyShowNewPickedTitleNotTodayItem.h"
#import "MyOutPutTitleItemNotToday.h"
#import "MyOutPutImgGroupItem.h"
#import "MyOutPutDescribeItem.h"
#import "MyOutPutPraiseAndReviewItem.h"
#import "MyShowNewTitleItemToday.h"
#import "MyShowNewTitleTodayCell.h"
#import "ClickViewController.h"
#import "MyShowNewTitleItemNotToday.h"
#import "MyShowNewTitleNotTodayCell.h"
#import "MyShowNewPickedTitleFocusItem.h"
#import "MyShowNewPickedTitleCell.h"
#import "MyShowNewPickedTitleFriendsCell.h"
#import "MyShowNewPickedTitleNotTodayCell.h"
#import "MyShowNewDescribeCell.h"
#import "PlayVideoCell.h"
#import "MyOutPutSingleImgCell.h"
#import "MyShowNewPhotoCell.h"
#import "MyOutPutPraiseAndReviewCell.h"
#import "MyHomeNewVersionVC.h"
#import "MyShowPickedBabyCell.h"
#import "MyOutPutUrlCell.h"
#import "XSMediaPlayer.h"
#import "SpecialDetailTVC.h"
#import "PPTViewController.h"
#import "WebViewController.h"
#import "StoreDetailNewVC.h"
#import "StoreMoreListVC.h"
#import "BBSNavigationControllerNotTurn.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "ReportViewController.h"
#import "YLImageView.h"
#import "YLGIFImage.h"
#import "PostBarGroupNewVC.h"
#import "PostBarNewGroupOnlyOneVC.h"
#import "MyGroupOrToyCell.h"
#import "ToyLeaseListHtmlVC.h"
#import "ToyLeaseNewVC.h"
#import "ToyClassListVC.h"
#import "ToyLeaseDetailVC.h"
#import "LoveBabySecondVC.h"
#import "LeftPictureNoTitleCell.h"
#import "LoginHTMLVC.h"
#import "MyshowOnePicCell.h"
#import "StorePicListMoreVC.h"
#define kDeviceVersion [[UIDevice currentDevice].systemVersion floatValue]
#define kNavbarHeight ((kDeviceVersion>=7.0)? StatusAndNavBar_HEIGHT :44 )

@interface BabyMainNewVC ()<MyOutPutUrlCellDelegate,
MyOutPutSingleImgCellDelegate,
MyOutPutPraiseAndReviewCellDelegate,
UIActionSheetDelegate,
MyShowNewPhotoCellDelegate,
MyShowNewTitleTodayCellDelegate,
MyShowNewTitleNotTodayCellDelegate,
MyShowNewPickedTitleCellDelegate,
MyShowNewPickedTitleFriendsCellDelegate,
MyShowNewPickedTitleNotTodayCellDelegate,
MyShowPickedBabyCellDelegate,PlayVideoCellDelegate,PlayVideoMyMainCellDelegate>{
    RefreshControl *_refreshControl;
    UIScrollView *_topNewScrollView;
    NSMutableArray *_bannerArray;
    NSMutableArray *_navArray;
    UIPageControl *topPageControl;
    UIButton *theSearchBarBtn;
    UIButton *searchBtn;
    UIButton *moreBack;//导航页的展示
    UITableView *_tableViewNew;
    //最新、热门、关注数组
    NSMutableArray *tableNewArray;
    NSMutableArray *tableHotArray;
    NSMutableArray *tableAdArray;
    //刷新
    NSString *postCreatNew;
    NSString *postCreatHot;
    NSString *postCreatAn;
    
}
@property(nonatomic,strong)UIView *bannerView;

@property(nonatomic,strong)TESTFloatingView *buttonsView;
@property(nonatomic,strong)UIButton *firstVCBtn;
@property(nonatomic,strong)UIButton *secondVCBtn;
@property(nonatomic,strong)UIButton *thirdVCBtn;
@property(nonatomic,strong)UIView *navSearchView;
@property(nonatomic,assign)NSInteger inTheViewData;
@property(nonatomic,strong)UIView *iconView;
@property(nonatomic,strong)XSMediaPlayer *showPlayer;
@property(nonatomic,strong)PlayVideoCell *currentCell;//当前播放的视频
@property(nonatomic,strong)NSIndexPath *currentIndexPath;//当前cell的index
@property (nonatomic,strong)YLImageView *ylIamgeView;
@property(nonatomic,strong)UIView *navBackView;//导航页面
@property(nonatomic,strong)UIView *grayBackView;//导航的透明页面
@property(nonatomic,strong)UIButton *lookMore;//查看更多
@property(nonatomic,strong)UIButton *lookMoreIcon;//查看更多的小箭头
@property(nonatomic,strong)UIButton *addTopicBtn;//发秀秀

//  广告弹窗
@property(nonatomic,strong)NSString *post_urlActivity;
@property(nonatomic,strong)NSString *imgActivity;
@property(nonatomic,strong)NSString *typeActivity;

@property(nonatomic,strong)UIView *grayView;
@property(nonatomic,strong)UIButton *goToShareBtn;// 分享大按钮
@property(nonatomic,strong)UIButton *gotoCacelBtn;//取消分享按钮
@property(nonatomic,strong)UITextField *textTx;

@end

@implementation BabyMainNewVC

-(void)viewWillAppear:(BOOL)animated{
    NSLog(@"页面将出现");
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.tabBarController.tabBar.hidden = NO;
    //赞成功与失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseSucceed) name:USER_MYSHOWPRAISE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseFail:) name:USER_MYSHOWPRAISE_FAIL object:nil];
    
    //取消赞成功与失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseSucceed) name:USER_MYSHOWCANCELPRAISE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseFail:) name:USER_MYSHOWCANCELPRAISE_FAIL object:nil];
    
    //删除秀秀
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteShowSucceed:) name:USER_DELETE_SHOW_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteShowFail:) name:USER_DELETE_SHOW_FAIL object:nil];
    
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
    //正在发布中
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postingSuceed) name:USER_POSTBAR_NEW_MAKE_A_POSTING_SUCCEED object:nil];

    //发布成功后提示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postSuceed) name:USER_POSTBAR_NEW_MAKE_A_POST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postFailed) name:USER_POSTBAR_NEW_MAKE_A_POST_FAIL object:nil];
    [_tableViewNew addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;

}
-(void)postingSuceed{
    _ylIamgeView = [[YLImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH-60,SCREENHEIGHT-100, 39, 39)];
    _ylIamgeView.image = [YLGIFImage imageNamed:@"up_show.gif"];
    [self.view addSubview:_ylIamgeView];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:USER_POSTBAR_NEW_MAKE_A_POSTING_SUCCEED object:nil];
    _inTheViewData = 1008;
    _iconView.frame = CGRectMake(SCREENWIDTH/3-(SCREENWIDTH/3-55)+10, SCREENHEIGHT*0.072-10, 5, 5);
    postCreatHot = NULL;
    [self getHotTableViewData];


}
-(void)postSuceed{
    NSLog(@"提交成功的方法");
    [_ylIamgeView removeFromSuperview];
    _inTheViewData = 1008;
    _iconView.frame = CGRectMake(SCREENWIDTH/3-(SCREENWIDTH/3-55)+10, SCREENHEIGHT*0.072-10, 5, 5);
    postCreatHot = NULL;
    [self getHotTableViewData];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:USER_POSTBAR_NEW_MAKE_A_POST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:USER_POSTBAR_NEW_MAKE_A_POST_FAIL object:nil];
}

-(void)postFailed{
    [_ylIamgeView removeFromSuperview];
    _inTheViewData = 1008;
    _iconView.frame = CGRectMake(SCREENWIDTH/3-(SCREENWIDTH/3-55)+10, SCREENHEIGHT*0.072-10, 5, 5);

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
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
  
}
-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.tabBarController.tabBar.hidden = NO;
    [_tableViewNew removeObserver:self forKeyPath:@"contentOffset"];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:USER_MYSHOWPRAISE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:USER_MYSHOWPRAISE_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:USER_MYSHOWCANCELPRAISE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:USER_MYSHOWCANCELPRAISE_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:USER_DELETE_SHOW_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:USER_DELETE_SHOW_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:USER_POSTBAR_NEW_MAKE_A_POST_SUCCEED object:self];
    [self cancelActivityView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    if (!tableNewArray) {
        tableNewArray = [NSMutableArray array];
    }
    if (!tableHotArray) {
        tableHotArray = [NSMutableArray array];
    }
    if (!tableAdArray) {
        tableAdArray = [NSMutableArray array];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    _inTheViewData = 1008;
    [LoadingView startOntheView:self.view];
    [self setBannerHead];//轮播图
    //[self setButtons];//设置下面的几个按钮】
    [self setTableViewNew];
    [self setSearchBar];//搜素按钮
    [self refreshControlInit];
    [self startAnimation];
   // [self setNavBackView];
    _tableViewNew.scrollsToTop = YES;
    // Do any additional setup after loading the view.
    [self setRight];
   // [self setLoginUserid];

    if (theAppDelegate.isRequestActivity == YES) {
         [self isShowActivityView];
        theAppDelegate.isRequestActivity = NO;

    }
    
    
}
#pragma mark   直接输用户的loginid，去确定
-(void)setLoginUserid{
    _textTx = [[UITextField alloc]initWithFrame:CGRectMake(100, 100, 180, 60)];
    _textTx.placeholder = @"请输入用户ID";
    _textTx.font = [UIFont systemFontOfSize:14];
    _textTx.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textTx.backgroundColor = [UIColor yellowColor];
    _textTx.delegate = self;
    _textTx.keyboardType = UIKeyboardTypeNumberPad;
    _textTx.layer.masksToBounds = YES;
    [self.view addSubview:_textTx];
    UIButton *sumbitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sumbitButton.adjustsImageWhenHighlighted = NO;
    sumbitButton.frame = CGRectMake(100, 155+64, 180, 35);
    [sumbitButton addTarget:self action:@selector(makeSureLoginid) forControlEvents:UIControlEventTouchUpInside];
    [sumbitButton setBackgroundImage:[UIImage imageNamed:@"btn_diary_sumbitheight"] forState:UIControlStateNormal];
    
    
    [self.view addSubview:sumbitButton];
    
}
-(void)makeSureLoginid{
    UserInfoItem *userItem=[[UserInfoItem alloc]init];
    userItem.userId=_textTx.text;
    userItem.email=@"";
    userItem.userName=@"";;
    userItem.nickname=@"";;
    userItem.avatarStr=@"";;
    userItem.city = @"";;
    userItem.isVisitor=[NSNumber numberWithBool:NO];
    userItem.password = @"";;
    UserInfoManager *userInfoManager=[[UserInfoManager alloc]init];
    [userInfoManager saveUserInfo:userItem];
    [self.view endEditing:YES];
    
    NSLog(@"logggggg = %@,%@",LOGIN_USER_ID,_textTx.text
          );
    
}

#pragma mark   是否展示广告弹窗
-(void)isShowActivityView{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"getIndexTextimg" params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *dataDic = result[@"data"];
            if ([dataDic[@"is_show"]isEqualToString:@"1"]) {
                self.post_urlActivity = dataDic[@"post_url"];
                self.imgActivity = dataDic[@"img"];
                self.typeActivity = dataDic[@"type"];
                [self showActivityView];
                
                
            }else{
                [self cancelActivityView];
            }
        }
       
    } failed:^(NSError *error) {
        
    }];

}
-(void)showActivityView{
    //蒙版
    _grayView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENHEIGHT)];
    _grayView.backgroundColor = [BBSColor hexStringToColor:@"000000" alpha:0.5];
    [self.view addSubview:_grayView];
    _grayView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerCancelTapped:)];
    [_grayView addGestureRecognizer:singleTap];
    
    _goToShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    // [_goToShareBtn setBackgroundImage:[UIImage imageNamed:@"toy_share_get_dayBtn"] forState:UIControlStateNormal];
    _goToShareBtn.adjustsImageWhenHighlighted = NO;
    [_goToShareBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.imgActivity] forState:UIControlStateNormal];

    
    _goToShareBtn.frame = CGRectMake(0.15*SCREENWIDTH,(SCREENHEIGHT-(1.4*SCREENWIDTH*0.7))/2-30, SCREENWIDTH*0.7, 1.4*SCREENWIDTH*0.7);
    [_grayView addSubview:_goToShareBtn];
    [_goToShareBtn addTarget:self action:@selector(sendRedPacket) forControlEvents:UIControlEventTouchUpInside];
    
    _gotoCacelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_gotoCacelBtn setBackgroundImage:[UIImage imageNamed:@"toy_cancle_share_get_dayBtn"] forState:UIControlStateNormal];
    _gotoCacelBtn.frame = CGRectMake((SCREENWIDTH-36)/2, _goToShareBtn.frame.origin.y+_goToShareBtn.frame.size.height+30, 36, 36);
    [_grayView addSubview:_gotoCacelBtn];
    [_gotoCacelBtn addTarget:self action:@selector(cancelActivityView) forControlEvents:UIControlEventTouchUpInside];
    _gotoCacelBtn.adjustsImageWhenHighlighted = NO;
}
-(void)fingerCancelTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [self cancelActivityView];
    
}

-(void)cancelActivityView{
    _grayView.hidden = YES;
    _gotoCacelBtn.hidden = YES;
    _goToShareBtn.hidden = YES;

}
#pragma mark 活动页面跳转
-(void)sendRedPacket{
    if ([self.typeActivity isEqualToString:@"41"]) {
        // 外链
        WebViewController *webView=[[WebViewController alloc]init];
        NSString *urlString =  self.post_urlActivity;
        webView.urlStr=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [webView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:webView animated:YES];

    }else if([self.typeActivity isEqualToString:@"2"]){
        //帖子
        [self pushPostNewDetialVC:self.post_urlActivity userId:LOGIN_USER_ID];
    }else if ([self.typeActivity isEqualToString:@"3"]){
         //视频
    }else if ([self.typeActivity isEqualToString:@"4"]){
        //新商家列表
         [self pushStoreMoreList:self.post_urlActivity title:@"精选商家"];
    }else if ([self.typeActivity isEqualToString:@"51"]){
        //玩具世界首页
        [self pushToyList];
        
    }else if ([self.typeActivity isEqualToString:@"22"]){
        //单个商家
        [self pushStoreDetialNewVC:self.post_urlActivity];
        
    }else if ([self.typeActivity isEqualToString:@"7"]){
        //玩具详情
        ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
        toyDetailVC.business_id =  self.post_urlActivity;
        [self.navigationController pushViewController:toyDetailVC animated:YES];

    }else if ([self.typeActivity isEqualToString:@"32"]){
        [self pushPostMyGroupDetailVC:self.post_urlActivity];

    }
}
#pragma mark 右边按钮发秀秀
//右边按钮发秀秀
-(void)setRight{
    
    _addTopicBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    
    _addTopicBtn.frame=CGRectMake(SCREENWIDTH-45 ,StatusBar_HEIGHT + 5 + 50, 40, 40);
    
    [_addTopicBtn setImage:[UIImage imageNamed:@"img_myshow_newmakeashow"] forState:UIControlStateNormal];
    [_addTopicBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    [_addTopicBtn addTarget:self action:@selector(makeAShow) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_addTopicBtn];
}
#pragma mark 发秀秀
-(void)makeAShow{
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    if ([userItem.isVisitor boolValue] == YES ||userItem.userId == NULL) {
        //[self loginIn];
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
        return;
        
    }
    [self makeAPostPresent];
    
}
#pragma mark 发秀秀调起
-(void)makeAPostPresent{
    PostBarNewMakeAPost *postBarNewMakeApost = [[PostBarNewMakeAPost alloc]init];
    postBarNewMakeApost.isFromMain = @"isFromMain";
    postBarNewMakeApost.update = ^(){
        [self postSuceed];
    };
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"CheckGroup" params:dic success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = [result objectForKey:@"data"];
            NSString *groupId = data[@"group_id"];
            if (groupId.length>0) {
                postBarNewMakeApost.groupId = data[@"group_id"];
                postBarNewMakeApost.groupName = data[@"group_name"];
                postBarNewMakeApost.isHiddenGroup = NO;
            }else{
                postBarNewMakeApost.isHiddenGroup = YES;
                
            }
            [self.navigationController pushViewController:postBarNewMakeApost animated:YES];
            
        }
    } failed:^(NSError *error) {
        
    }];
    
}

#pragma Mark 首页导航
-(void)setNavBackView{
    
    self.grayBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-44)];
    self.grayBackView.backgroundColor = [BBSColor hexStringToColor:@"65544b" alpha:0.5];
   // [self.view addSubview:self.grayBackView];
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeNavBack)];
    [self.grayBackView addGestureRecognizer:singleTap1];
    
    self.navBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-84)];
    self.navBackView.backgroundColor = [BBSColor hexStringToColor:@"ebfeff"];
    [self.grayBackView addSubview:self.navBackView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeNavBack)];
    [self.navBackView addGestureRecognizer:singleTap];
    
    //添加轻扫手势
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(removeNavBack)];
    //设置轻扫的方向
    swipeGesture.direction = UISwipeGestureRecognizerDirectionUp; // 向上
    [self.navBackView addGestureRecognizer:swipeGesture];
    
    self.lookMore = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lookMore.frame = CGRectMake((SCREENWIDTH-90)/2, SCREENHEIGHT-84-30, 90, 30);
    [self.lookMore setTitle:@"上拉查看更多" forState:UIControlStateNormal];
    [self.lookMore setTitleColor:[BBSColor hexStringToColor:@"44a7c7"] forState:UIControlStateNormal];
    self.lookMore.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.lookMore addTarget:self action:@selector(removeNavBack) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackView addSubview:self.lookMore];
    
    self.lookMoreIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    self.lookMoreIcon.frame = CGRectMake((SCREENWIDTH-15)/2, SCREENHEIGHT-84-30-17, 15, 17);
    [self.lookMoreIcon setBackgroundImage:[UIImage imageNamed:@"more_baby_btn"] forState:UIControlStateNormal];
    [self.lookMoreIcon addTarget:self action:@selector(removeNavBack) forControlEvents:UIControlEventTouchUpInside];
    [self.navBackView addSubview:self.lookMoreIcon];
    [LoadingView startOnTheViewController:self];
    [self setNavData];
}
-(void)removeNavBack{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [UIView animateWithDuration:2.0 // 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:1.0 // 类似弹簧振动效果 0~1它的范围为 0.0f 到 1.0f ，数值越小「弹簧」的振动效果越明显
          initialSpringVelocity:2.0 // 初始速度
                        options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                     animations:^{
                         // code...
                         CGPoint point = CGPointMake(SCREENWIDTH/2, -500);
                         [self.grayBackView setCenter:point];
                     } completion:^(BOOL finished) {
                     }];
    
}
#pragma mark 首页导航数据
-(void)setNavData{
    NSDictionary *params;
    NSUserDefaults *defaultlat = [NSUserDefaults standardUserDefaults];
    NSString *lat = [defaultlat valueForKey:@"latitude"];
    NSUserDefaults *defaultlog = [NSUserDefaults standardUserDefaults];
    NSString *longitude = [defaultlog valueForKey:@"longitude"];
    params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%@,%@",lat,longitude],@"mapsign", nil];
    [[HTTPClient sharedClient]getNewV1:@"getModuleList" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            for (UIView *view in self.navBackView.subviews) {
                [view removeFromSuperview];
            }
            [self.navBackView addSubview:self.lookMore];
            [self.navBackView addSubview:self.lookMoreIcon];
            NSArray *navArray = result[@"data"];
            [self setDataArray:navArray];
        }else{
            [LoadingView stopOnTheViewController:self];
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
        }

    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
    }];
}
#pragma mark 读取缓存数据
-(void)setDataArray:(NSArray*)array{
    [self performSelector:@selector(loadViewDissAppear) withObject:nil afterDelay:3];
    //[LoadingView stopOnTheViewController:self];
    _navArray = [NSMutableArray array];
    for (NSDictionary *headImageDic in array) {
        SpecialHeadListModel *model = [[SpecialHeadListModel alloc]init];
        model.type = [headImageDic[@"type"]integerValue];
        model.isClick = [headImageDic[@"is_click"]boolValue];
        if(headImageDic[@"cate_id"] !=nil &&headImageDic[@"cate_id"]!= NULL){
            model.cateId = [headImageDic[@"cate_id"]integerValue];
        }
        if (headImageDic[@"cate_name"]!= nil && headImageDic[@"cate_name"] != NULL) {
            model.cateName = headImageDic[@"cate_name"];
        }
        if (headImageDic[@"img"]!=nil &&headImageDic
            [@"img"]!= NULL) {
            model.img = headImageDic[@"img"];
        }
        if (headImageDic[@"img_id"]!=nil &&headImageDic
            [@"img_id"]!= NULL) {
            model.img_id = [headImageDic[@"img_id"]integerValue];
        }
        if (headImageDic[@"business_url"]!=nil &&headImageDic
            [@"business_url"]!= NULL) {
            model.businessUrl = headImageDic[@"business_url"];
        }
        if (headImageDic[@"group_id"]!=nil &&headImageDic
            [@"group_id"]!= NULL) {
            model.group_id = [headImageDic[@"group_id"]integerValue];
        }
        if (headImageDic[@"group_name"]!=nil &&headImageDic
            [@"group_name"]!= NULL) {
            model.groupName = headImageDic[@"group_name"];
        }
        if (headImageDic[@"business_id"]!=nil &&headImageDic
            [@"business_id"]!= NULL) {
            model.businessId = headImageDic[@"business_id"] ;
        }
        if (headImageDic[@"business_name"]!=nil &&headImageDic
            [@"business_name"]!= NULL) {
            model.businessName = headImageDic[@"business_name"];
        }
        if (headImageDic[@"video_url"]!=nil &&headImageDic
            [@"video_url"]!= NULL) {
            model.video_url = headImageDic[@"video_url"];
        }
        model.title = headImageDic[@"title"];
        [_navArray addObject:model];
    }
    for (int i = 0; i < _navArray.count; i++) {
        SpecialHeadListModel *model = _navArray[i];
        if (i == 0) {
            NSString *imgString = model.img[0][@"img_thumb"];
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imgString]];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 2000+i;
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 10;
            button.frame = CGRectMake(10, 20,SCREENWIDTH-20,(SCREENWIDTH-20)*0.34);
            [_navBackView addSubview:button];
            [button sd_setBackgroundImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"home_img_cache0"]];
            [button addTarget:self action:@selector(pushNavAction:) forControlEvents:UIControlEventTouchUpInside];
            button.adjustsImageWhenHighlighted = NO;
        }else{
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 2000+i;
            float RowInI = (i-1)/2;
            int rowInI = ceil(RowInI);
            NSString *imgString = model.img[0][@"img_thumb"];
            [button sd_setBackgroundImageWithURL:[NSURL URLWithString:imgString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"home_img_cache%d",i]]];
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5;
            button.adjustsImageWhenHighlighted = NO;
            [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
            if (SCREENWIDTH == 320 && SCREENHEIGHT == 480) {
                button.frame = CGRectMake(28+(118+28)*((i-1)%2), 20+(SCREENWIDTH-20)*0.34+10+(5+76)*rowInI, 118, 76);
            }else{
                button.frame = CGRectMake(10+(143+14)*((i-1)%2), 20+(SCREENWIDTH-20)*0.34+10+(10+94)*rowInI, 143, 94);
            }
            [button addTarget:self action:@selector(pushNavAction:) forControlEvents:UIControlEventTouchUpInside];
            [_navBackView addSubview:button];
            UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 10, 100, 20)];
            titleLabel.text = model.title;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            titleLabel.font = [UIFont systemFontOfSize:16];
            titleLabel.textColor = [UIColor whiteColor];
            [button addSubview:titleLabel];
            NSLog(@"布局完成2");
        }
    }
    
 
}
-(void)loadViewDissAppear{
    [LoadingView stopOnTheViewController:self];
}
#pragma mark导航图跳转
-(void)pushNavAction:(UIButton*)sender{
    SpecialHeadListModel *model = _navArray[sender.tag-2000];
    if (model.isClick == NO) {
        
    }else if(model.isClick == YES){
        if(model.type== 1){
            //跳转帖子列表
            [self pushPostBarNewList:model.img_id imgIds:nil type:nil title:model.title isThrid:NO];
        }else if(model.type== 2){
            //跳转帖子详情
            PostBarNewDetialV1VC *detailVC=[[PostBarNewDetialV1VC alloc]init];
            detailVC.img_id=[NSString stringWithFormat:@"%ld",(long)model.img_id];
            detailVC.login_user_id=LOGIN_USER_ID;
            detailVC.refreshInVC = ^(BOOL isRefresh){
            };
            [detailVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:detailVC animated:YES];
        }else if (model.type == 3){
            //视频帖
            BOOL isHV;//横竖屏
            float height = [model.img[0][@"img_thumb_height"] floatValue];
            float weight = [model.img[0][@"img_thumb_width"] floatValue];
            if (height > weight) {
                isHV = NO;//竖屏
            }else{
                isHV = YES;
            }
            [self pushBabyShowPlayer:model.video_url imgId:[NSString stringWithFormat:@"%ld",(long)model.img_id] isHV:isHV];
            
        }else if(model.type == 21){
            //商家列表
            BBSTabBarViewController *tabVC = [[BBSTabBarViewController alloc]init];
            theAppDelegate.window.rootViewController = tabVC;
            [tabVC setBBStabbarSelectedIndex:1];
            tabVC.selectedIndex = 1;
            
        }else if(model.type == 22){
            //商家详情
            StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
            storeVC.longin_user_id =LOGIN_USER_ID;
            storeVC.business_id = model.businessId;
            [self.navigationController pushViewController:storeVC animated:YES];

        }else if (model.type == 31){
            //群列表
            [self pushPostBarNewList:model.img_id imgIds:nil   type:@"31" title:model.title isThrid:NO];

        }else if(model.type== 32){
            //跳转群详情
            NSString *groupId = [NSString stringWithFormat:@"%ld",(long)model.group_id];
            [self pushPostMyGroupDetailVC:groupId];
        }else if(model.type== 41){
            //跳转到值得买商家
            WebViewController *webView=[[WebViewController alloc]init];
            NSString *urlString = model.businessUrl;
            webView.urlStr=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            webView.img_id = [NSString stringWithFormat:@"%ld",(long)model.img_id];
            [webView setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:webView animated:YES];
        }else if(model.type== 42){
            [self removeNavBack];
            //跳转到热门
            _inTheViewData = 1008;
            if (tableHotArray.count<=0) {
                [self getHotTableViewData];
            }
            _iconView.frame=CGRectMake(SCREENWIDTH/2-1, SCREENHEIGHT*0.072-10, 5, 5);
            [_firstVCBtn setImage:[UIImage imageNamed:@"btn_baby_main_new"] forState:UIControlStateNormal];
            [_secondVCBtn setImage:[UIImage imageNamed:@"btn_baby_main_hots"] forState:UIControlStateNormal];
            [_thirdVCBtn setImage:[UIImage imageNamed:@"btn_baby_main_attention"] forState:UIControlStateNormal];
            [_tableViewNew reloadData];
        }else if(model.type== 43){
            //跳转到萌宝
            NSString *imgId = [NSString stringWithFormat:@"%ld",(long)model.img_id];
            NSString *babyTitle = model.title;
            [self pushLoveBabyList:imgId title:babyTitle];
        }else if(model.type == 44){
            //跳转到成长记录
            BBSTabBarViewController *tabVC = [[BBSTabBarViewController alloc]init];
            theAppDelegate.window.rootViewController = tabVC;
            [tabVC setBBStabbarSelectedIndex:2];
            tabVC.selectedIndex = 2;
            
        }else if (model.type == 53){
            //玩具分类
            [self pushClassList:[NSString stringWithFormat:@"%ld",(long)model.img_id]];

        }else if (model.type == 52){
            //玩具详情
            ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
            toyDetailVC.business_id = [NSString stringWithFormat:@"%ld",(long)model.img_id];
            [self.navigationController pushViewController:toyDetailVC animated:YES];
         }else if (model.type == 51){
             //玩具首页
             [self pushToyList];

        }
    }
}
-(void)pushLoveBabyList:(NSString*)babyId  title:(NSString*)babyTitle{
    LoveBabySecondVC *loveBabyVC = [[LoveBabySecondVC alloc]init];
    loveBabyVC.babyId = babyId;
    loveBabyVC.babyTitle = babyTitle;
    [self.navigationController pushViewController:loveBabyVC animated:YES];
}
#pragma mark 跳转玩具分类列表
-(void)pushClassList:(NSString*)imgID{
    ToyClassListVC *classList = [[ToyClassListVC alloc]init];
    classList.businessId = imgID;
    [self.navigationController pushViewController:classList animated:YES];

}
//首页轮播图
-(void)setBannerHead{
    _bannerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.37+30+20)];
    //轮播图布局
    _topNewScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH ,SCREENWIDTH*0.37+20)];
    _topNewScrollView.backgroundColor=[UIColor clearColor];
    _topNewScrollView.userInteractionEnabled = YES;
    _topNewScrollView.bounces=NO;
    _topNewScrollView.pagingEnabled=YES;
    _topNewScrollView.showsVerticalScrollIndicator = NO;
    _topNewScrollView.showsHorizontalScrollIndicator=NO;  //控制是否显示水平方向的滚动条, 默认显示
    _topNewScrollView.delegate=self;
    _topNewScrollView.contentSize=CGSizeMake(SCREENWIDTH*_bannerArray.count, _topNewScrollView.frame.size.height);
    [_bannerView addSubview:_topNewScrollView];
    topPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(SCREENWIDTH/3,SCREENWIDTH*0.37-20,90,10)];
    UIImageView *logoImg = [[UIImageView alloc]init];
    logoImg.frame = CGRectMake((320-200)/2,SCREENWIDTH*0.37+6+20, 199, 18);
    logoImg.image = [UIImage imageNamed:@"babyshow_logo"];
    [_bannerView addSubview:logoImg];
}

//设置搜索
-(void)setSearchBar{
    self.navSearchView = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH-50, 0, SCREENWIDTH, StatusAndNavBar_HEIGHT)];
    [self.view addSubview:self.navSearchView];
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    searchBtn.frame = CGRectMake(10, StatusBar_HEIGHT + 5, 30, 30);
    [searchBtn setBackgroundImage:[UIImage imageNamed:@"baby_main_search"] forState:UIControlStateNormal];
    [self.navSearchView addSubview:searchBtn];
    
    [searchBtn addTarget:self action:@selector(pushSearchView) forControlEvents:UIControlEventTouchUpInside];
    
    moreBack = [UIButton buttonWithType:UIButtonTypeCustom];
    moreBack.frame = CGRectMake(10, 25, 30, 30);
    [moreBack setBackgroundImage:[UIImage imageNamed:@"more_baby_nav"] forState:UIControlStateNormal];
}
#pragma mark 导航展示
-(void)showNavView{
   
    [UIView animateWithDuration:1.0 // 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:1.0 // 类似弹簧振动效果 0~1它的范围为 0.0f 到 1.0f ，数值越小「弹簧」的振动效果越明显
          initialSpringVelocity:3.0 // 初始速度
                        options:UIViewAnimationOptionCurveLinear // 动画过渡效果
                     animations:^{
                         self.grayBackView.hidden = NO;
                         // code...
                     } completion:^(BOOL finished) {
                         // 动画完成后执行
                         [UIView animateWithDuration:1.0 animations:^{
                             [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
                             self.grayBackView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-44);
                         }];

                     }];
}

-(void)setButtons{
    _buttonsView = [[TESTFloatingView alloc]initWithFrame:CGRectMake(0, 0.37*SCREENWIDTH, SCREENWIDTH, SCREENHEIGHT*0.072)];
    _buttonsView.backgroundColor = [UIColor whiteColor];
    [_bannerView addSubview:_buttonsView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT*0.072-0.5, SCREENWIDTH, 0.5)];
    lineView.backgroundColor = [BBSColor hexStringToColor:@"e8e8e8"];
    [_buttonsView addSubview:lineView];

    _firstVCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _firstVCBtn.frame = CGRectMake(0, 0, SCREENWIDTH/3, SCREENHEIGHT*0.072);

    [_buttonsView addSubview:_firstVCBtn];
    [_firstVCBtn setImage:[UIImage imageNamed:@"btn_baby_main_news"] forState:UIControlStateNormal];
    _firstVCBtn.imageEdgeInsets = UIEdgeInsetsMake((SCREENHEIGHT*0.072-15)/2-4,SCREENWIDTH/3-55, (SCREENHEIGHT*0.072-15)/2+4, 25);
    
    _firstVCBtn.tag = 1007;
    [_firstVCBtn addTarget:self action:@selector(changeDataWithTag:) forControlEvents:UIControlEventTouchUpInside];
    //按钮下面的红色小点
    _iconView = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/3-(SCREENWIDTH/3-55)+10, SCREENHEIGHT*0.072-10, 5, 5)];
    _iconView.backgroundColor = [BBSColor hexStringToColor:NAVICOLOR];
    _iconView.layer.masksToBounds = YES;
    _iconView.layer.cornerRadius = 2.5;
    [_buttonsView addSubview:_iconView];
    
    _secondVCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _secondVCBtn.frame = CGRectMake(SCREENWIDTH/3, 0, SCREENWIDTH/3, SCREENHEIGHT*0.072);
    [_buttonsView addSubview:_secondVCBtn];
    [_secondVCBtn setImage:[UIImage imageNamed:@"btn_baby_main_hot"] forState:UIControlStateNormal];
    _secondVCBtn.tag = 1008;
    [_secondVCBtn addTarget:self action:@selector(changeDataWithTag:) forControlEvents:UIControlEventTouchUpInside];
   
    _secondVCBtn.imageEdgeInsets = UIEdgeInsetsMake((SCREENHEIGHT*0.072-15)/2-4,(SCREENWIDTH/3-30)/2, (SCREENHEIGHT*0.072-15)/2+4, (SCREENWIDTH/3-30)/2);
    
    _thirdVCBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _thirdVCBtn.frame = CGRectMake(SCREENWIDTH*2/3, 0, SCREENWIDTH/3, SCREENHEIGHT*0.072);
    _thirdVCBtn.backgroundColor = [UIColor clearColor];
    [_buttonsView addSubview:_thirdVCBtn];
    _thirdVCBtn.tag = 1009;
    [_thirdVCBtn addTarget:self action:@selector(changeDataWithTag:) forControlEvents:UIControlEventTouchUpInside];
    [_thirdVCBtn setImage:[UIImage imageNamed:@"btn_baby_main_attention"] forState:UIControlStateNormal];
    _thirdVCBtn.imageEdgeInsets = UIEdgeInsetsMake((SCREENHEIGHT*0.072-15)/2-4, 25, (SCREENHEIGHT*0.072-15)/2+4, SCREENWIDTH/3-55);
}
#pragma mark 点击上面按钮的时候数据的切换
-(void)changeDataWithTag:(UIButton*)sender{
    UIButton *button = sender;
    _inTheViewData = button.tag;
     [_tableViewNew scrollRectToVisible:_tableViewNew.frame animated:NO];
    
    if (_inTheViewData == 1007) {
        
        _iconView.frame = CGRectMake(SCREENWIDTH/3-(SCREENWIDTH/3-55)+10, SCREENHEIGHT*0.072-10, 5, 5);
        [_firstVCBtn setImage:[UIImage imageNamed:@"btn_baby_main_news"] forState:UIControlStateNormal];
        [_secondVCBtn setImage:[UIImage imageNamed:@"btn_baby_main_hot"] forState:UIControlStateNormal];
        [_thirdVCBtn setImage:[UIImage imageNamed:@"btn_baby_main_attention"] forState:UIControlStateNormal];
        [_showPlayer playOrPause:YES];
        [_showPlayer playRelease];
        [_showPlayer removeFromSuperview];

        if (tableNewArray.count<=0) {
            [self getNewTableViewData];
        }
    }else if (_inTheViewData == 1008){
        if (tableHotArray.count<=0) {
            [self getHotTableViewData];
        }
        _iconView.frame=CGRectMake(SCREENWIDTH/2-1, SCREENHEIGHT*0.072-10, 5, 5);
        [_firstVCBtn setImage:[UIImage imageNamed:@"btn_baby_main_new"] forState:UIControlStateNormal];
        [_secondVCBtn setImage:[UIImage imageNamed:@"btn_baby_main_hots"] forState:UIControlStateNormal];
        [_thirdVCBtn setImage:[UIImage imageNamed:@"btn_baby_main_attention"] forState:UIControlStateNormal];
        [_showPlayer playOrPause:YES];
        [_showPlayer playRelease];
        [_showPlayer removeFromSuperview];

    }else if (_inTheViewData == 1009){
        if (tableAdArray.count<=0) {
            [self getAdTableViewData];
        }
        [_firstVCBtn setImage:[UIImage imageNamed:@"btn_baby_main_new"] forState:UIControlStateNormal];
        [_secondVCBtn setImage:[UIImage imageNamed:@"btn_baby_main_hot"] forState:UIControlStateNormal];
        [_thirdVCBtn setImage:[UIImage imageNamed:@"btn_baby_main_attentions"] forState:UIControlStateNormal];
        [_showPlayer playOrPause:YES];
        [_showPlayer playRelease];
        [_showPlayer removeFromSuperview];
        _iconView.frame=CGRectMake(SCREENWIDTH*2/3+35, SCREENHEIGHT*0.072-10, 5, 5);
    }
    [_tableViewNew reloadData];
}
//上拉的时候改变搜索框的frame
-(void)changeSearchBar{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    self.navSearchView.frame = CGRectMake(0, 0, SCREENWIDTH, StatusAndNavBar_HEIGHT);
    self.navSearchView.backgroundColor = [BBSColor hexStringToColor:NAVICOLOR];
    [searchBtn setBackgroundImage:nil forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(5, StatusBar_HEIGHT + 5, SCREENWIDTH-10, 30);
    searchBtn.backgroundColor = [UIColor whiteColor];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 14;
    [searchBtn setTitle:@"用户、商家、帖子" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [searchBtn setImage:[UIImage imageNamed:@"btn_baby_show_search"] forState:UIControlStateNormal];
    [searchBtn setImageEdgeInsets:UIEdgeInsetsMake(2, -40, 1, -30)];
    
    [UIView commitAnimations];
    moreBack.hidden = YES;

    
}

-(void)changeSearchBarTop{
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.navSearchView.backgroundColor = [UIColor clearColor];
        self.navSearchView.frame = CGRectMake(SCREENWIDTH-50, 0, SCREENWIDTH, StatusAndNavBar_HEIGHT);

        searchBtn.frame =CGRectMake(10, StatusBar_HEIGHT + 5, 30, 30);
        [searchBtn setTitle:@"" forState:UIControlStateNormal];
        searchBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [searchBtn setImage:nil forState:UIControlStateNormal];
        searchBtn.backgroundColor = [UIColor clearColor];
        [searchBtn setBackgroundImage:[UIImage imageNamed:@"baby_main_search"] forState:UIControlStateNormal];
     }completion:^(BOOL finished){
  
          }];
    moreBack.hidden = NO;
}


//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark  刷新控件refreshControl
-(void)refreshControlInit{
    _refreshControl = [[RefreshControl alloc]initWithScrollView:_tableViewNew delegate:self];
    _refreshControl.delegate = self;
    _refreshControl.topEnabled = YES;
    _refreshControl.bottomEnabled = NO;
    [_refreshControl startRefreshingDirection:RefreshDirectionTop];
}
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    if (refreshControl == _refreshControl) {
        if (direction == RefreshDirectionTop) {
            postCreatAn = NULL;
            postCreatHot = NULL;
            postCreatNew =NULL;
            [self getBannarData];
            
        }
        if (_inTheViewData == 1007) {
            [self getNewTableViewData];
            if (tableHotArray.count <= 0) {
                [self getHotTableViewData];
            }
            if (tableAdArray.count <= 0) {
                [self getAdTableViewData];
            }

        }else if (_inTheViewData == 1008){
            [self getHotTableViewData];

        }else if(_inTheViewData == 1009){
            [self getAdTableViewData];

        }
        
        
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

#pragma mark tableview
-(void)setTableViewNew{
 
    _tableViewNew = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-TabbarHeight)];
    _tableViewNew.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableViewNew.tableHeaderView = _bannerView;
    _tableViewNew.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewNew.showsVerticalScrollIndicator = NO;
    _tableViewNew.delegate = self;
    _tableViewNew.dataSource = self;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        _tableViewNew.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif

    _tableViewNew.estimatedRowHeight = 0;
    _tableViewNew.estimatedSectionHeaderHeight = 0;
    _tableViewNew.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableViewNew];
}
#pragma mark KVC回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (offset.y < StatusAndNavBar_HEIGHT ) {
            [self changeSearchBarTop];
            
            _buttonsView.frame = CGRectMake(0, 0.37*SCREENWIDTH, SCREENHEIGHT, SCREENHEIGHT*0.072);
            [_bannerView addSubview:_buttonsView];
            
        } else  if(offset.y >= StatusAndNavBar_HEIGHT) {
            [self changeSearchBar];
            
            _buttonsView.frame = CGRectMake(0, StatusAndNavBar_HEIGHT, SCREENHEIGHT, SCREENHEIGHT*0.072);
            [self.view addSubview:_buttonsView];


        }
    }

}
#pragma mark data
-(void)getBannarData{
    
    NSDictionary *params;
    NSUserDefaults *defaultlat = [NSUserDefaults standardUserDefaults];
    NSString *lat = [defaultlat valueForKey:@"latitude"];
    NSUserDefaults *defaultlog = [NSUserDefaults standardUserDefaults];
    NSString *longitude = [defaultlog valueForKey:@"longitude"];
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];

    params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", currentVersion,@"versionName",[NSString stringWithFormat:@"%@,%@",lat,longitude],@"mapsign", nil];
    UrlMaker *urlMark = [[UrlMaker alloc]initWithNewV1UrlStr:@"HeadBannerVideo" Method:NetMethodGet andParam:params];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMark.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    __weak ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:kBBSSuccess] integerValue]==200) {
            [self refreshComplete:_refreshControl];
            _bannerArray = [NSMutableArray array];
            
            for (UIView *view in _topNewScrollView.subviews) {
                [view removeFromSuperview];
            }
            
            for (NSDictionary *headImageDic in dic[@"data"]) {
                _specialHeadListModel = [[SpecialHeadListModel alloc]init];
                _specialHeadListModel.type = [headImageDic[@"type"]integerValue];
                _specialHeadListModel.isClick = [headImageDic[@"is_click"]boolValue];
                if(headImageDic[@"cate_id"] !=nil &&headImageDic[@"cate_id"]!= NULL){
                    _specialHeadListModel.cateId = [headImageDic[@"cate_id"]integerValue];
                }
                if (headImageDic[@"cate_name"]!= nil && headImageDic[@"cate_name"] != NULL) {
                    _specialHeadListModel.cateName = headImageDic[@"cate_name"];
                }
                if (headImageDic[@"img"]!=nil &&headImageDic
                    [@"img"]!= NULL) {
                    _specialHeadListModel.img = headImageDic[@"img"];
                }
                if (headImageDic[@"img_id"]!=nil &&headImageDic
                    [@"img_id"]!= NULL) {
                    _specialHeadListModel.img_id = [headImageDic[@"img_id"]integerValue];
                }
                if (headImageDic[@"business_url"]!=nil &&headImageDic
                    [@"business_url"]!= NULL) {
                    _specialHeadListModel.businessUrl = headImageDic[@"business_url"];
                }
                if (headImageDic[@"group_id"]!=nil &&headImageDic
                    [@"group_id"]!= NULL) {
                    _specialHeadListModel.group_id = [headImageDic[@"group_id"]integerValue];
                }
                if (headImageDic[@"group_name"]!=nil &&headImageDic
                    [@"group_name"]!= NULL) {
                    _specialHeadListModel.groupName = headImageDic[@"group_name"];
                }
                if (headImageDic[@"business_id"]!=nil &&headImageDic
                    [@"business_id"]!= NULL) {
                    _specialHeadListModel.businessId = headImageDic[@"business_id"] ;
                }
                if (headImageDic[@"business_name"]!=nil &&headImageDic
                    [@"business_name"]!= NULL) {
                    _specialHeadListModel.businessName = headImageDic[@"business_name"];
                }
                if (headImageDic[@"video_url"]!=nil &&headImageDic
                    [@"video_url"]!= NULL) {
                    _specialHeadListModel.video_url = headImageDic[@"video_url"];
                }

                
                [_bannerArray addObject:_specialHeadListModel];
            }
            topPageControl.numberOfPages = _bannerArray.count;
            topPageControl.currentPage = 0;
            topPageControl.currentPageIndicatorTintColor = [BBSColor hexStringToColor:@"ff5f5f"];
            topPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
            //[_bannerView addSubview:topPageControl];
            _topNewScrollView.contentSize=CGSizeMake(SCREENWIDTH*_bannerArray.count,_topNewScrollView.frame.size.height);
            _specialTopView.homeTopArray = _bannerArray;
            
            for (int i = 0; i < _bannerArray.count; i++) {
                _specialHeadListModel = (SpecialHeadListModel*)_bannerArray[i];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH*i, 0,SCREENWIDTH,SCREENWIDTH*0.37+20)];
                imageView.contentMode = UIViewContentModeScaleToFill;
                imageView.userInteractionEnabled = YES;
                imageView.tag = 100+i;
                NSString *imgString = _specialHeadListModel.img[0][@"img_thumb"];
                //[_topNewScrollView addSubview:imageView];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imgString]];
                [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.frame =CGRectMake(SCREENWIDTH*i, 0,SCREENWIDTH,SCREENWIDTH*0.37+20);
                button.tag = 100+i;
                [button sd_setBackgroundImageWithURL:[NSURL URLWithString:imgString] forState:UIControlStateNormal];
                button.adjustsImageWhenHighlighted = NO;
                [button.imageView setContentMode:UIViewContentModeScaleAspectFill];
                [button addTarget:self action:@selector(pushViewController:) forControlEvents:UIControlEventTouchUpInside];
                [_topNewScrollView addSubview:button];

                

            }
            for (int i = 0; i < _bannerArray.count; i++) {
                UIView *view = (UIView *)[_topNewScrollView viewWithTag:100+i];
                view.userInteractionEnabled = YES;
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushViewController:)];
               // [view addGestureRecognizer:singleTap];
            }

        }else{
            
        }
    }];
    
}
#pragma mark 轮播图跳转
-(void)pushViewController:(UIButton*)singleTap//已写
{
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    
    _specialHeadListModel = _bannerArray[singleTap.tag-100];
    if (_specialHeadListModel.isClick == NO) {
        if (_specialHeadListModel.type == 9) {
            [self pushToyList];
        }
    }else if(_specialHeadListModel.isClick == YES){
        if(_specialHeadListModel.type== 1){
            //跳转专题详情
            SpecialDetailTVC *specialDetail = [[SpecialDetailTVC alloc]init];
            specialDetail.recievedIndex = 0;
            specialDetail.cate_id = _specialHeadListModel.cateId;
            specialDetail.title = _specialHeadListModel.cateName;
            [self.navigationController pushViewController:specialDetail animated:YES];
            
        }else if(_specialHeadListModel.type== 2){
            //跳转群详情
            NSString *groupId = [NSString stringWithFormat:@"%ld",(long)_specialHeadListModel.group_id];
            [self pushPostMyGroupDetailVC:groupId];
//            PostBarGroupNewVC *detailVC = [[PostBarGroupNewVC alloc]init];
//            detailVC.group_id = _specialHeadListModel.group_id;
//            [self.navigationController pushViewController:detailVC animated:YES];

        }else if(_specialHeadListModel.type== 3){
            //跳转帖子详情
            PostBarNewDetialV1VC *detailVC=[[PostBarNewDetialV1VC alloc]init];
            detailVC.img_id=[NSString stringWithFormat:@"%ld",(long)_specialHeadListModel.img_id];
            //detailVC.user_id=item.userid;
            detailVC.login_user_id=userItem.userId;
            detailVC.refreshInVC = ^(BOOL isRefresh){
                
            };
            [detailVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
        else if(_specialHeadListModel.type== 4){
            //跳转到个人相册展播
            //NSMutableArray *imgArray = specialHeadListModel[@"img"];
            NSMutableArray *headerArray  = [NSMutableArray array];
            for (NSDictionary *imgDic in _specialHeadListModel.img) {
                NSString *imgString = imgDic[@"img_thumb"];
                [headerArray addObject:imgString];
            }
            [MobClick event:UMEVENTZHANBO];
            PPTViewController *ppt=[[PPTViewController alloc]init];
            ppt.maxPlayNumOnce=3;
            ppt.photosArray=(NSMutableArray *)headerArray;
            BBSNavigationControllerNotTurn *nav=[[BBSNavigationControllerNotTurn alloc]initWithRootViewController:ppt];
            [self presentViewController:nav animated:YES completion:^{}];
        }else if(_specialHeadListModel.type== 5){
            //跳转到值得买商家
            WebViewController *webView=[[WebViewController alloc]init];
            NSString *urlString =_specialHeadListModel.businessUrl;
            webView.urlStr=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            webView.img_id = [NSString stringWithFormat:@"%ld",(long)_specialHeadListModel.img_id];
            [webView setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:webView animated:YES];
        }else if(_specialHeadListModel.type == 6){
            StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
            storeVC.longin_user_id = userItem.userId;
            storeVC.business_id = _specialHeadListModel.businessId;
            [self.navigationController pushViewController:storeVC animated:YES];
        }else if(_specialHeadListModel.type == 7){
            StoreMoreListVC *storeListVC = [[StoreMoreListVC alloc]init];
            storeListVC.login_user_id = userItem.userId;
            [self.navigationController pushViewController:storeListVC animated:YES];
            
        }else if (_specialHeadListModel.type == 8){
            BOOL isHV;//横竖屏
            float height = [_specialHeadListModel.img[0][@"img_thumb_height"] floatValue];
            float weight = [_specialHeadListModel.img[0][@"img_thumb_width"] floatValue];
            if (height > weight) {
                isHV = NO;//竖屏
            }else{
                isHV = YES;
            }
            [self pushBabyShowPlayer:_specialHeadListModel.video_url imgId:[NSString stringWithFormat:@"%ld",_specialHeadListModel.img_id] isHV:isHV];
            
        }else if (_specialHeadListModel.type == 9){
            
        }
        
    }
}

#pragma mark 请求列表数据
//最新
-(void)getNewTableViewData{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",postCreatNew,@"post_create_time", nil];
    UrlMaker *urlMark = [[UrlMaker alloc]initWithNewV1UrlStr:kListingNew Method:NetMethodGet andParam:params];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMark.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    __weak ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:@"success"]integerValue] == 1) {
            NSArray *dataArray = [dic objectForKey:@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
            for (NSDictionary *dataDic in dataArray) {
                BabyShowMainItem *item = [[BabyShowMainItem alloc]init];
                item.imgTitle = MBNonEmptyString(dataDic[@"img_title"]);
                item.reviewCount = MBNonEmptyString(dataDic[@"review_count"]);
                item.postCount = MBNonEmptyString(dataDic[@"post_count"]);
                //话题群商家
                item.style = MBNonEmptyString(dataDic[@"style"]);
                //图片样式
                item.imgStyle = [MBNonEmptyString(dataDic[@"img_style"])integerValue];
                item.video_url = MBNonEmptyString(dataDic[@"video_url"]);
                item.tag_id = [MBNonEmptyString(dataDic[@"tag_id"])integerValue];
                item.userName = MBNonEmptyString(dataDic[@"user_name"]);
                item.img_ids = MBNonEmptyString(dataDic[@"img_ids"]);
                item.img_description = MBNonEmptyString(dataDic[@"img_description"]);
                //跳转
                item.type = MBNonEmptyString(dataDic[@"type"]);
                item.imgArray = dataDic[@"img"];
                item.color = dataDic[@"color"];
                
                if (item.imgStyle == 1) {
                    //单图13字号
                    item.height = [self resetFrameWithTitle:item.imgTitle widths:SCREENWIDTH-10];
                    
                }else if (item.imgStyle == 2){
                    item.height = [self resetFrameWithTitle:item.imgTitle widths:SCREENWIDTH-10];
                    //单视频
                }else if (item.imgStyle == 3){
                    item.height = [self resetFrameWithTitle:item.imgTitle widths:SCREENWIDTH-10];
                    //一拖二
                }else if (item.imgStyle == 4){
                    //三图并列
                    item.height = [self resetFrameWithTitle:item.imgTitle widths:SCREENWIDTH-10];
                }else if (item.imgStyle == 5){
                    item.height = [self resetFrameWithTitle:item.imgTitle width:SCREENWIDTH-10];
                    //纯文字
                }else if (item.imgStyle == 6){
                    //单图加文字
                    item.height = [self resetFrameWithTitle:item.imgTitle width:SCREENWIDTH-104-20];
                }else if (item.imgStyle == 7){
                    //单图加文字
                    item.height = [self resetFrameWithTitle:item.imgTitle width:SCREENWIDTH-104-20];
                }

                [returnArray addObject:item];
            }
            if (returnArray.count == 0) {
                _refreshControl.bottomEnabled = NO;
            }
            if (postCreatNew == NULL) {
                [tableNewArray removeAllObjects];
                _refreshControl.bottomEnabled = YES;
            }
            if (_inTheViewData == 1007) {
                BabyShowMainItem *item = [returnArray lastObject];
                postCreatNew = [item.imgArray lastObject][@"post_create_time"];

            }
            [tableNewArray addObjectsFromArray:returnArray];
            [_tableViewNew reloadData];
            if (_inTheViewData == 1007) {
                [self refreshComplete:_refreshControl];

            }
        }else{
            if (_inTheViewData == 1007) {
                [self refreshComplete:_refreshControl];
                if (dic) {
                    [BBSAlert showAlertWithContent:[dic objectForKey:kBBSReMsg] andDelegate:self];
                    
                }else{
                    [BBSAlert showAlertWithContent:@"请刷新" andDelegate:self];
                }


            }
        }
    }];
    [request setFailedBlock:^{
        [self refreshComplete:_refreshControl];
    }];

}
#pragma mark 热门数据
-(void)getHotTableViewData{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",postCreatHot,@"post_create_time", nil];
    UrlMaker *urlMark = [[UrlMaker alloc]initWithNewV1UrlStr:kgetHotListData Method:NetMethodGet andParam:params];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMark.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    __weak ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:@"success"]integerValue] == 1) {
            NSArray *dataArray = [dic objectForKey:@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
            for (NSDictionary *dataDic in dataArray) {
                BabyShowMainItem *item = [[BabyShowMainItem alloc]init];
                item.imgTitle = MBNonEmptyString(dataDic[@"img_title"]);
                item.imgId = MBNonEmptyString(dataDic[@"img_id"]);
                item.img_description = MBNonEmptyString(dataDic[@"img_description"]);
                item.reviewCount = MBNonEmptyString(dataDic[@"review_count"]);
                item.postCount = MBNonEmptyString(dataDic[@"post_count"]);
                //话题群商家
                item.style = MBNonEmptyString(dataDic[@"style"]);
                //图片样式
                item.imgStyle = [MBNonEmptyString(dataDic[@"img_style"])integerValue];
                item.video_url = MBNonEmptyString(dataDic[@"video_url"]);
                item.tag_id = [MBNonEmptyString(dataDic[@"tag_id"])integerValue];
                item.userName = MBNonEmptyString(dataDic[@"user_name"]);
                item.show_post_create_time = MBNonEmptyString(dataDic[@"show_post_create_time"]);
                item.postCreattime = MBNonEmptyString(dataDic[@"post_create_time"]);
                item.hot_time_title = MBNonEmptyString(dataDic[@"hot_time_title"]);
                //跳转
                item.type = MBNonEmptyString(dataDic[@"type"]);
                item.img_ids = MBNonEmptyString(dataDic[@"img_ids"]);
                item.imgArray = dataDic[@"img"];
                item.post_url = dataDic[@"post_url"];
                if (item.imgStyle == 8) {
                    //单图
                    if (item.hot_time_title.length > 0) {
                        item.height = 223;

                    }else{
                        item.height = 160;
                    }
                }else if (item.imgStyle == 5){
                    item.height = [self resetFrameWithTitle:item.imgTitle width:SCREENWIDTH-10];
                    //纯文字
                }else if (item.imgStyle == 6 || item.imgStyle == 7){
                    //单图加文字
                    item.height = [self resetFrameWithTitle:item.imgTitle width:SCREENWIDTH-104-20];
                }else if (item.imgStyle == 9){
                    item.height = SCREENWIDTH*0.3+20;
                    
                }
                [returnArray addObject:item];
            }
            if (returnArray.count == 0) {
                _refreshControl.bottomEnabled = NO;
            }
            if (postCreatHot == NULL) {
                [tableHotArray removeAllObjects];
                _refreshControl.bottomEnabled = YES;
            }
            if (_inTheViewData == 1008) {
                BabyShowMainItem *item = [returnArray lastObject];
                postCreatHot = item.postCreattime;

            }
            [tableHotArray addObjectsFromArray:returnArray];
            [_tableViewNew reloadData];
            if (_inTheViewData == 1008) {
                [self refreshComplete:_refreshControl];

            }
        }else{
            if (_inTheViewData == 1008) {
                [self refreshComplete:_refreshControl];
                if (dic) {
                    [BBSAlert showAlertWithContent:[dic objectForKey:kBBSReMsg] andDelegate:self];
                    
                }else{
                    [BBSAlert showAlertWithContent:@"请刷新" andDelegate:self];
                }
            }
        }
    }];
    [request setFailedBlock:^{
        [self refreshComplete:_refreshControl];
    }];

    
}
#pragma mark 关注数据
-(void)getAdTableViewData{
    NSDictionary *newParam = [NSDictionary dictionaryWithObjectsAndKeys:
                              LOGIN_USER_ID,@"login_user_id",postCreatAn,@"post_create_time",nil];
    UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kMyFocusList Method:NetMethodGet andParam:newParam];
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
                NSNumber *time=[imgDic objectForKey:@"post_create_time"];
                //未关注
                 if ([self isToday:time]==YES){
                    
                    //xx小时前
                    MyShowNewPickedTitleTodayItem *titleItem=[[MyShowNewPickedTitleTodayItem alloc]init];
                    titleItem.imgid=[imgDic objectForKey:kMyShowImgId];
                    titleItem.time=[self getTimeStrFromNow:time];
                    titleItem.create_time = [imgDic objectForKey:@"post_create_time"];
                    titleItem.height=43;
                    titleItem.avatarStr=[imgDic objectForKey:@"avatar"];
                    titleItem.username=[imgDic objectForKey:@"user_name"];
                    titleItem.userid=[imgDic objectForKey:@"user_id"];
                    titleItem.identify=@"PICKEDTITLETODAY";
                    titleItem.level_img = [imgDic objectForKey:@"level_img"];
                    [singleArray addObject:titleItem];
                }else if ([self isToday:time]==NO){
                    //xx年月日
                    MyShowNewPickedTitleNotTodayItem *titleItem=[[MyShowNewPickedTitleNotTodayItem alloc]init];
                    titleItem.imgid=[imgDic objectForKey:kMyShowImgId];
                    titleItem.avatarStr=[imgDic objectForKey:@"avatar"];
                    titleItem.username=[imgDic objectForKey:@"user_name"];
                    titleItem.userid=[imgDic objectForKey:@"user_id"];
                    titleItem.create_time = [imgDic objectForKey:@"post_create_time"];
                    MyOutPutTitleItemNotToday *item=[self MyOutPutGetTime:time];
                    titleItem.day=item.day;
                    titleItem.month=item.month;
                    titleItem.year=item.year;
                    titleItem.height=42;
                    titleItem.identify=@"PICKEDTITLENOTTODAY";
                    titleItem.level_img = [imgDic objectForKey:@"level_img"];
                    [singleArray addObject:titleItem];
                    
                }
                NSArray *photoArray=[imgDic objectForKey:@"img"];
                if (photoArray.count) {
                    
                    MyOutPutImgGroupItem *imgItem=[[MyOutPutImgGroupItem alloc]init];
                    imgItem.video_url = [imgDic objectForKey:@"video_url"];
                    imgItem.imgid = [imgDic objectForKey:kMyShowImgId];
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
                praiseItem.userid=[imgDic objectForKey:@"user_id"];
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
            if (postCreatAn == NULL) {
                [tableAdArray removeAllObjects];
                _refreshControl.bottomEnabled = YES;
            }
            if (_inTheViewData == 1009) {
                NSArray *singleArray = [returnArray lastObject];
                MyOutPutPraiseAndReviewItem *pItem = [singleArray lastObject];
                postCreatAn = pItem.create_time;

            }
            
            [tableAdArray addObjectsFromArray:returnArray];
            [_tableViewNew reloadData];
            [self refreshComplete:_refreshControl];
        }else{
            if (_inTheViewData == 1009) {
                [self refreshComplete:_refreshControl];
                if (dic) {
                    [BBSAlert showAlertWithContent:[dic objectForKey:kBBSReMsg] andDelegate:self];
                    
                }else{
                    [BBSAlert showAlertWithContent:@"请刷新" andDelegate:self];
                }

            }
            
        }
        
    }];
    [request setFailedBlock:^{
        [self refreshComplete:_refreshControl];
    }];
    
    
    
}
#pragma mark  UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_inTheViewData == 1007) {
        return tableNewArray.count-2;
    }else if (_inTheViewData == 1008){
        return tableHotArray.count;
    }else if (_inTheViewData == 1009){
        if (tableAdArray.count) {
            NSArray *singleArrayNew = [tableAdArray objectAtIndex:section];
            return singleArrayNew.count;
        }
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_inTheViewData == 1009) {
        return tableAdArray.count;
    }
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //1单图，2单视频，3多图一托二，4多图三并列，5小图纯文字，6小图加文字，7小图视频
    if (_inTheViewData == 1007) {
        if (indexPath.row == 0) {
            return 111;
            
        }else{
        BabyShowMainItem *item = [tableNewArray objectAtIndex:indexPath.row+2];
        if (item.imgStyle == 1) {
            if (item.height == 0) {
                return SCREENWIDTH/3+0.5;
            }else{
                return SCREENWIDTH/3+10+item.height+10;
            }
        }else if (item.imgStyle == 2){
            if (item.height == 0) {
                return SCREENWIDTH/2+0.5;
            }else{
                return SCREENWIDTH/2+10+item.height+10;
            }
        }else if (item.imgStyle == 3){
            if (item.height == 0) {
                return 169.5;
            }else{
                return 169+10+item.height+10;
              }
        }else if (item.imgStyle == 4){
            if (item.height == 0) {
                return 12+86+10;
            }else{
            return 12+86+5+item.height+10;
            }
        }else if (item.imgStyle == 5){
            if (item.height == 0) {
                return 12+12+12;
            }else{
            return 12+item.height+12+12+12;
            }
            
        }else if (item.imgStyle == 6){
            return 90;
            
        }else if (item.imgStyle == 7){
            return 90;
            
        }
        return 200;
        }
    }else if (_inTheViewData == 1008){
       // 5小图纯文字，6小图加文字，7小图视频，8大图
        BabyShowMainItem *item = [tableHotArray objectAtIndex:indexPath.row];
        if (item.imgStyle == 8) {
            return item.height;
        }else if(item.imgStyle == 7 || item.imgStyle == 6 ){
            return 90;
        }else if (item.imgStyle == 9){
            return SCREENWIDTH*0.3+20;
        }else if (item.imgStyle == 5 ){
            if (item.height == 0) {
                return 12+12+12;
            }else{
                return 12+item.height+12+12+12;
            }

        }

        return 100;
    }else if (_inTheViewData == 1009){
        NSArray *singleArray=[tableAdArray objectAtIndex:indexPath.section];
        MyOutPutBasicItem *item=[singleArray objectAtIndex:indexPath.row];
        return item.height+5;

    }
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *returnCell;
    if (_inTheViewData == 1007) {
        if (indexPath.row == 0) {
            BabyShowMainItem *item1 = [tableNewArray objectAtIndex:0];
            BabyShowMainItem *item2 = [tableNewArray objectAtIndex:1];
            BabyShowMainItem *item3 = [tableNewArray objectAtIndex:2];


            static NSString *identifier = @"MYGROUPORTOYCELL";
            MyGroupOrToyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[MyGroupOrToyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.backViewLeft.backgroundColor = [BBSColor hexStringToColor:item1.color];
            
            if (item1.imgArray) {
                NSString *imgTitle1;
                NSDictionary *imgDic1;
                imgDic1 = item1.imgArray[0];
                imgTitle1 = MBNonEmptyString(imgDic1[@"img_thumb"]);
                 [cell.iconImgLeft sd_setImageWithURL:[NSURL URLWithString:imgTitle1] placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
            }
            cell.groupNameLabelLeft.text = item1.imgTitle;
            cell.groupDesLabelLeft.text = item1.img_description;
            UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToyDetailVC:)];
            cell.backViewLeft.tag = 6770;
            [cell.backViewLeft addGestureRecognizer:singleTap1];
            
            UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToyDetailVC:)];
            cell.backViewRight.tag = 6771;
            [cell.backViewRight addGestureRecognizer:singleTap2];
            
            UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushToyDetailVC:)];
            cell.backViewTop.tag = 6772;
            [cell.backViewTop addGestureRecognizer:singleTap3];

            cell.backViewLeft.backgroundColor = [BBSColor hexStringToColor:item1.color];
            cell.backViewRight.backgroundColor = [BBSColor hexStringToColor:item2.color];
            if (item2.imgArray) {
                NSString *imgTitle1;
                NSDictionary *imgDic1;
                imgDic1 = item2.imgArray[0];
                imgTitle1 = MBNonEmptyString(imgDic1[@"img_thumb"]);
                [cell.iconImgRight sd_setImageWithURL:[NSURL URLWithString:imgTitle1] placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
            }
            cell.groupNameLabelRight.text = item2.imgTitle;
            cell.groupDesLabelRight.text = item2.img_description;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            returnCell = cell;
            return returnCell;
 
        }else{
        BabyShowMainItem *item = [tableNewArray objectAtIndex:indexPath.row+2];
        if (item.imgStyle == 1) {
            //单图
            static NSString *identifier = @"SINGLEPHOTOFORTHCELL";
            SinglePhotoForthCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[SinglePhotoForthCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            if (item.imgArray) {
                NSString *imgTitle1;
                NSDictionary *imgDic1;
                imgDic1 = item.imgArray[0];
                imgTitle1 = MBNonEmptyString(imgDic1[@"img_thumb"]);
                 [cell.photoView sd_setImageWithURL:[NSURL URLWithString:imgTitle1] placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
            }
            cell.titleNameLabel.text = item.imgTitle;
            cell.titleNameLabel.lineBreakMode =1;
            
            [cell resetFrameWithDescribeContent:item.imgTitle];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            returnCell = cell;
        }else if (item.imgStyle == 2){
            //单视频
            static NSString *identifier = @"PLAYVIDEOMYMAINCELL";
            PlayVideoMyMainCell *playCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (playCell == nil) {
                playCell = [[PlayVideoMyMainCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            playCell.delegate = self;
            playCell.playSamllBtn.indexpath = indexPath;
            playCell.ImgBtn.indexpath = indexPath;
            playCell.grayView.indexpath = indexPath;
            playCell.imgBigBtn.indexpath = indexPath;
            NSString *imgTitle1;
            NSDictionary *imgDic1;
            NSString *widthString;
            NSString *heightString;
            NSString *imgString;

            if (item.imgArray) {
                imgDic1 = item.imgArray[0];
                imgTitle1 = MBNonEmptyString(imgDic1[@"img_thumb"]);
                widthString = MBNonEmptyString(imgDic1[@"img_thumb_width"]);
                heightString = MBNonEmptyString(imgDic1[@"img_thumb_height"]);
                }
            float height = [heightString floatValue];
            float weight = [widthString floatValue];
            
            SDWebImageManager *manager=[SDWebImageManager sharedManager];
            if (height >weight) {
                [manager downloadImageWithURL:[NSURL URLWithString:imgTitle1] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [playCell.ImgBtn setBackgroundImage:image forState:UIControlStateNormal];
                    [playCell.imgBigBtn setBackgroundImage:image forState:UIControlStateNormal];
                    playCell.imgBigBtn.hidden = NO;
                    playCell.grayView.hidden = NO;
                }];

            }else{
                [manager downloadImageWithURL:[NSURL URLWithString:imgTitle1] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [playCell.ImgBtn setBackgroundImage:image forState:UIControlStateNormal];
                    playCell.imgBigBtn.hidden = YES;
                    playCell.grayView.hidden = YES;
                }];
                
                
            }
            playCell.titleNameLabel.text = item.imgTitle;
            [playCell resetFrameWithDescribeContent:item.imgTitle];
            playCell.selectionStyle = UITableViewCellSelectionStyleNone;
            returnCell = playCell;
        }else if (item.imgStyle == 3){
            //一拖二图片
            static NSString *identifier = @"THREEPICTUREONEBIGCELL";
            ThreePictureOneBigCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[ThreePictureOneBigCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            NSString *imgTitle1;
            NSString *imgTitle2;
            NSString *imgTitle3;
            NSDictionary *imgDic1 ;
            NSDictionary *imgDic2;
            NSDictionary *imgDic3;
            float height1;
            float width1;
            

            if (item.imgArray.count ==3) {
                imgDic1 = item.imgArray[0];
                imgDic2 = item.imgArray[1];
                imgDic3 = item.imgArray[2];
                imgTitle1 = MBNonEmptyString(imgDic1[@"img_thumb"]);
                imgTitle2 = MBNonEmptyString(imgDic2[@"img_thumb"]);
                imgTitle3 = MBNonEmptyString(imgDic3[@"img_thumb"]);
                height1 = [imgDic1[@"img_thumb_height"]floatValue];
                width1 = [imgDic1[@"img_thumb_width"]floatValue];

            }else if (item.imgArray.count ==2){
                imgDic1 = item.imgArray[0];
                imgDic2 = item.imgArray[1];
                imgTitle1 = MBNonEmptyString(imgDic1[@"img_thumb"]);
                imgTitle2 = MBNonEmptyString(imgDic2[@"img_thumb"]);
                height1 = [imgDic1[@"img_thumb_height"]floatValue];
                width1 = [imgDic1[@"img_thumb_width"]floatValue];

            }else{
                imgDic1 = item.imgArray[0];
                imgTitle1 = MBNonEmptyString(imgDic1[@"img_thumb"]);
            }
//            if (height1 > width1) {
//                //竖屏
//                cell.firstSmallImg.hidden = NO;
//                cell.grayImg.hidden = NO;
//                 [cell.firstSmallImg sd_setImageWithURL:[NSURL URLWithString:imgTitle1]];
//            }else{
//                //横屏
//                cell.firstSmallImg.hidden =YES;
//                cell.grayImg.hidden = YES;
//            }
            
            [cell.firstPicBtn sd_setImageWithURL:[NSURL URLWithString:imgTitle1] placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
           
            [cell.secondPicBtn sd_setImageWithURL:[NSURL URLWithString:imgTitle2] placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
            [cell.thridPicBtn sd_setImageWithURL:[NSURL URLWithString:imgTitle3] placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
            cell.titleNameLabel.text = item.imgTitle;
            if (item.userName.length >0 && item.postCount.length > 0) {
                cell.avatarNameLable.text = [NSString stringWithFormat:@"%@   %@观看",item.userName,item.postCount];
            }else if (item.userName.length >0 && item.postCount.length <= 0){
                cell.avatarNameLable.text = [NSString stringWithFormat:@"%@",item.userName];
            }else if (item.userName.length <=0 && item.postCount.length >0){
                cell.avatarNameLable.text = [NSString stringWithFormat:@"%@观看",item.postCount];
            }
            
            [cell resetFrameWithDescribeContent:item.imgTitle];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            returnCell = cell;
        }else if (item.imgStyle == 4){
            //三个并列图片
            static NSString *identifier = @"THREEPICTURESMALLCELL";
            ThreePictureSmallCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[ThreePictureSmallCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            NSString *imgTitle1;
            NSString *imgTitle2;
            NSString *imgTitle3;
            NSDictionary *imgDic1 ;
            NSDictionary *imgDic2;
            NSDictionary *imgDic3;
            if (item.imgArray.count ==3) {
                imgDic1 = item.imgArray[0];
                imgDic2 = item.imgArray[1];
                imgDic3 = item.imgArray[2];
                imgTitle1 = MBNonEmptyString(imgDic1[@"img_thumb"]);
                imgTitle2 = MBNonEmptyString(imgDic2[@"img_thumb"]);
                imgTitle3 = MBNonEmptyString(imgDic3[@"img_thumb"]);
            }else if (item.imgArray.count ==2){
                imgDic1 = item.imgArray[0];
                imgDic2 = item.imgArray[1];
                imgTitle1 = MBNonEmptyString(imgDic1[@"img_thumb"]);
                imgTitle2 = MBNonEmptyString(imgDic2[@"img_thumb"]);
            }else{
                imgDic1 = item.imgArray[0];
                imgTitle1 = MBNonEmptyString(imgDic1[@"img_thumb"]);
                
            }
            [cell.imgStore1 sd_setImageWithURL:[NSURL URLWithString:imgTitle1]];
            [cell.imgStore2 sd_setImageWithURL:[NSURL URLWithString:imgTitle2]];
            [cell.imgStore3 sd_setImageWithURL:[NSURL URLWithString:imgTitle3]];
            cell.titleNameLabel.text =item.imgTitle;
            if (item.userName.length >0 && item.postCount.length > 0) {
                cell.avatarNameLable.text = [NSString stringWithFormat:@"%@   %@观看",item.userName,item.postCount];
            }else if (item.userName.length >0 && item.postCount.length <= 0){
                cell.avatarNameLable.text = [NSString stringWithFormat:@"%@",item.userName];
            }else if (item.userName.length <=0 && item.postCount.length >0){
                cell.avatarNameLable.text = [NSString stringWithFormat:@"%@观看",item.postCount];
            }

            [cell resetFrameWithDescribeContent:item.imgTitle];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;


            returnCell = cell;

            
        }else if (item.imgStyle == 5){
            //纯文字
            NSString *identifier = [NSString stringWithFormat:@"POSTBARFIRSTCELL"];
            PostBarFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[PostBarFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.describleLabel.text = item.imgTitle;
            if (item.userName.length >0 && item.postCount.length > 0) {
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@   %@观看",item.userName,item.postCount];
            }else if (item.userName.length >0 && item.postCount.length <= 0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@",item.userName];
            }else if (item.userName.length <=0 && item.postCount.length >0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@观看",item.postCount];
            }

            [cell resetFrameWithDescribeContent:item.imgTitle];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;

        }else if (item.imgStyle == 6 || item.imgStyle == 7){
            //图加文
            NSString *identifierSecond = [NSString stringWithFormat:@"POSTBARSECOND"];
            PostBarSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierSecond];
            if (!cell) {
                cell = [[PostBarSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierSecond];
            }
            cell.titleLabel.text = item.imgTitle;
            [cell resetFrameWithDescribeContent:item.imgTitle];
            
            NSString *imgTitle;
            NSDictionary *imgDic1;
            NSString *imgString;
            
            if (item.imgArray) {
                imgDic1 = item.imgArray[0];
                imgTitle = MBNonEmptyString(imgDic1[@"img_thumb"]);
                
            }

            if (imgTitle.length > 0) {
                [cell.photoView sd_setImageWithURL:[NSURL URLWithString:imgTitle]];
            }
            if (item.userName.length >0 && item.postCount.length > 0) {
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@   %@观看",item.userName,item.postCount];
            }else if (item.userName.length >0 && item.postCount.length <= 0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@",item.userName];
            }else if (item.userName.length <=0 && item.postCount.length >0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@观看",item.postCount];
            }

            if (item.video_url.length>0) {
                cell.videoView.frame = CGRectMake(213+30, 30, 67*0.5, 67*0.5);
            }else{
                cell.videoView.frame = CGRectMake(0, 0, 0, 0);
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
        }
        
    }else if (_inTheViewData == 1008){
        
        BabyShowMainItem *item = [tableHotArray objectAtIndex:indexPath.row];
        NSLog(@"imgggggggg = %ld,%@",(long)item.imgStyle,item.imgTitle);
        if (item.imgStyle == 5){
            //纯文字
            NSString *identifier = [NSString stringWithFormat:@"POSTBARFIRSTCELL"];
            PostBarFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[PostBarFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.describleLabel.text = item.imgTitle;
            if (item.userName.length >0 && item.postCount.length > 0) {
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@   %@观看",item.userName,item.postCount];
            }else if (item.userName.length >0 && item.postCount.length <= 0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@",item.userName];
            }else if (item.userName.length <=0 && item.postCount.length >0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@观看",item.postCount];
            }
            
            [cell resetFrameWithDescribeContent:item.imgTitle];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            returnCell = cell;
            
        }else if (item.imgStyle == 7 || item.imgStyle == 6){
            //图加文
            NSString *identifierSecond = [NSString stringWithFormat:@"POSTBARSECOND"];
            PostBarSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierSecond];
            if (!cell) {
                cell = [[PostBarSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierSecond];
            }
            cell.titleLabel.text = item.imgTitle;
            [cell resetFrameWithDescribeContent:item.imgTitle];
            
            NSString *imgTitle;
            NSDictionary *imgDic1;
            
            if (item.imgArray) {
                imgDic1 = item.imgArray[0];
                imgTitle = MBNonEmptyString(imgDic1[@"img_thumb"]);
                
            }

            if (imgTitle.length > 0) {
                [cell.photoView sd_setImageWithURL:[NSURL URLWithString:imgTitle]];
            }
            if (item.userName.length >0 && item.postCount.length > 0) {
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@   %@观看",item.userName,item.postCount];
            }else if (item.userName.length >0 && item.postCount.length <= 0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@",item.userName];
            }else if (item.userName.length <=0 && item.postCount.length >0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@观看",item.postCount];
            }
            
            if (item.video_url.length>0) {
                cell.videoView.frame = CGRectMake(SCREEN_WIDTH-107+28, 30, 67*0.5, 67*0.5);
            }else{
                cell.videoView.frame = CGRectMake(0, 0, 0, 0);
                
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            returnCell = cell;
        }else if (item.imgStyle == 9){
            //固定的广告位置
            NSString *identifierSecond = [NSString stringWithFormat:@"MYSHOWONEPICCELL"];
             MyshowOnePicCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierSecond];
            if (!cell) {
                cell = [[MyshowOnePicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierSecond];
            }
            NSString *imgTitle;
            NSDictionary *imgDic1;
            
            if (item.imgArray) {
                imgDic1 = item.imgArray[0];
                imgTitle = MBNonEmptyString(imgDic1[@"img_thumb"]);
                
            }

            
              [cell.OnePicView sd_setImageWithURL:[NSURL URLWithString:imgTitle]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            returnCell = cell;

            
            
        }else if (item.imgStyle == 8){
            if (item.hot_time_title.length > 0) {
                NSString *identifier = [NSString stringWithFormat:@"LEFTPICTURECELL"];
                
                LeftPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[LeftPictureCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                NSString *imgTitle;
                NSDictionary *imgDic1;
                NSString *imgString;
                
                if (item.imgArray) {
                    imgDic1 = item.imgArray[0];
                    imgTitle = MBNonEmptyString(imgDic1[@"img_thumb"]);
                    
                }
                if (imgTitle.length > 0) {
                    [cell.imgViewBig sd_setImageWithURL:[NSURL URLWithString:imgTitle]];
                }
                cell.dateLabel.text = item.userName;
                cell.titleLabel.text = item.imgTitle;
                cell.subuTitleLabel.text = item.img_description;
                cell.hotDataLabel.text = [NSString stringWithFormat:@"-  %@  -",item.hot_time_title];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                returnCell = cell;
            }else{
                NSString *identifier = [NSString stringWithFormat:@"LEFTPICTURENOCELL"];
                
                LeftPictureNoTitleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[LeftPictureNoTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                NSString *imgTitle;
                NSDictionary *imgDic1;
                NSString *imgString;
                
                if (item.imgArray) {
                    imgDic1 = item.imgArray[0];
                    imgTitle = MBNonEmptyString(imgDic1[@"img_thumb"]);
                    
                }
                if (imgTitle.length > 0) {
                    [cell.imgViewBig sd_setImageWithURL:[NSURL URLWithString:imgTitle]];
                }
                cell.dateLabel.text = item.userName;
                cell.titleLabel.text = item.imgTitle;
                cell.subuTitleLabel.text = item.img_description;
                //cell.hotDataLabel.text = [NSString stringWithFormat:@"-  %@  -",item.hot_time_title];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                returnCell = cell;

            }
        }
    }else if(_inTheViewData == 1009){
        ClickViewController *clickVC = [[ClickViewController alloc] init];
        NSArray *singleArray=[tableAdArray objectAtIndex:indexPath.section];
        MyShowNewBasicItem *item=[singleArray objectAtIndex:indexPath.row];
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
            todayCell.avatarBtn.indexpath=indexPath;//跳转个人中心
            todayCell.delegate=self;
            returnCell=todayCell;
            
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
            returnCell=notTodayCell;
            
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
            
            returnCell=titleCell;
            
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
            returnCell=titleCell;
            
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
            returnCell=titleCell;
            
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
                desCell.describeLabel.indexPath =indexPath;
                desCell.describeLabel.clickDelegate = self;
                desCell.describeLabel.textColor = [BBSColor hexStringToColor:@"6e6550"];
            returnCell=desCell;
            
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
                    returnCell=playCell;
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
                    returnCell = singleImgCell;
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
                
                returnCell=imgGroupCell;
                
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
            returnCell=pCell;
            
        }
        returnCell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }
    return returnCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_inTheViewData == 1007) {
        if (indexPath.row == 0) {
            
        }else{
        BabyShowMainItem *item = [tableNewArray objectAtIndex:indexPath.row+2];
        NSString *imgId;
        NSString *userId ;
        NSString *imgIds;//跳列表时用的标示
        NSString *type;
        BOOL isHV;//横竖屏
        
        if (item.imgArray) {
            imgId  = item.imgArray[0][@"img_id"];
            userId = item.imgArray[0][@"user_id"];
            float height = [item.imgArray[0][@"img_thumb_height"] floatValue];
            float weight = [item.imgArray[0][@"img_thumb_width"] floatValue];
            if (height > weight) {
                isHV = NO;//竖屏
            }else{
                isHV = YES;
            }

        }
        imgIds = item.img_ids;
        type = item.type;
        
        if ([item.type isEqualToString:@"1"]) {
            [self pushPostBarNewList:item.tag_id imgIds:imgIds type:type title:item.imgTitle isThrid:NO];
            //话题列表
        }else if ([item.type isEqualToString:@"2"]){
            //某个帖
            [self pushPostNewDetialVC:imgId userId:userId];
            
        }else if ([item.type isEqualToString:@"3"]){
            //视频帖
            [self pushBabyShowPlayer:item.video_url imgId:imgId isHV:isHV];
            
        }else if ([item.type isEqualToString:@"21"]){
            //商家列表
            [self pushStoreNewList:item.tag_id imgIds:imgIds title:item.imgTitle];
            
        }
        else if ([item.type isEqualToString:@"22"]){
            //商家详情
            [self pushStoreDetialNewVC:imgId];
            
        }else if ([item.type isEqualToString:@"31"]){
            //群列表
            [self pushPostBarNewList:item.tag_id imgIds:imgId type:type title:item.imgTitle isThrid:NO];
            
        }else if ([item.type isEqualToString:@"32"]){
            //群详情//可以
            [self pushPostMyGroupDetailVC:imgId];
            
        }else if ([item.type isEqualToString:@"51"]){
            [self pushToyList];
        }
        }
    }else if (_inTheViewData == 1008){
        BabyShowMainItem *item = [tableHotArray objectAtIndex:indexPath.row];
        NSString *imgId;
        NSString *userId ;
        NSString *imgIds;//跳列表时用的标示
        NSString *type;
        BOOL isHV;
        if (item.imgArray) {
            imgId  = item.imgArray[0][@"img_id"];
            userId = item.imgArray[0][@"user_id"];
            float height = [item.imgArray[0][@"img_thumb_height"] floatValue];
            float weight = [item.imgArray[0][@"img_thumb_width"] floatValue];
            if (height > weight) {
                isHV = NO;//横屏
            }else{
                isHV = YES;
            }
        }
        imgIds = item.img_ids;
        type = item.type;
        
        if ([item.type isEqualToString:@"1"]) {
            [self pushPostBarNewList:item.tag_id imgIds:imgIds type:type title:item.imgTitle isThrid:NO];
            //话题列表
        }else if ([item.type isEqualToString:@"2"]){
            //某个帖
            [self pushPostNewDetialVC:imgId userId:userId];
            
        }else if ([item.type isEqualToString:@"3"]){
            //视频帖
            [self pushBabyShowPlayer:item.video_url imgId:imgId isHV:isHV];
            
        }else if ([item.type isEqualToString:@"4"]){
            //新商家列表
            //[self pushStoreNewList:item.tag_id imgIds:imgIds title:item.imgTitle];
            [self pushStoreMoreList:imgIds title:item.imgTitle];
            
        }
        else if ([item.type isEqualToString:@"22"]){
            //单个商家详情
            [self pushStoreDetialNewVC:imgIds];
            
        }else if ([item.type isEqualToString:@"41"]){
            //外链
            WebViewController *webView=[[WebViewController alloc]init];
            NSString *urlString = item.post_url;
            webView.urlStr=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [webView setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:webView animated:YES];

            
        }else if ([item.type isEqualToString:@"7"]){
            //玩具详情
            ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
            toyDetailVC.business_id = imgIds;
            [self.navigationController pushViewController:toyDetailVC animated:YES];


            
        }else if ([item.type isEqualToString:@"32"]){
            //群详情//可以
            [self pushPostMyGroupDetailVC:imgIds];
            
        }

    }
    
}
-(void)pushToyDetailVC:(UITapGestureRecognizer*)singleTap{
    BabyShowMainItem *item = tableNewArray [singleTap.view.tag - 6770];
    NSString *imgId;
    NSString *userId ;
    NSString *imgIds;//跳列表时用的标示
    NSString *type;
    BOOL isHV;//横竖屏
    
    if (item.imgArray) {
        imgId  = item.imgArray[0][@"img_id"];
        userId = item.imgArray[0][@"user_id"];
        float height = [item.imgArray[0][@"img_thumb_height"] floatValue];
        float weight = [item.imgArray[0][@"img_thumb_width"] floatValue];
        if (height > weight) {
            isHV = NO;//竖屏
        }else{
            isHV = YES;
        }
        
    }
    imgIds = item.img_ids;
    type = item.type;
    
    if ([item.type isEqualToString:@"1"]) {
        [self pushPostBarNewList:item.tag_id imgIds:imgIds type:type title:item.imgTitle isThrid:YES];
        //话题列表
    }else if ([item.type isEqualToString:@"2"]){
        //某个帖
        [self pushPostNewDetialVC:imgId userId:userId];
        
    }else if ([item.type isEqualToString:@"3"]){
        //视频帖
        [self pushBabyShowPlayer:item.video_url imgId:imgId isHV:isHV];
        
    }else if ([item.type isEqualToString:@"21"]){
        //商家列表
        [self pushStoreNewList:item.tag_id imgIds:imgIds title:item.imgTitle];
        
    }
    else if ([item.type isEqualToString:@"22"]){
        //商家详情
        [self pushStoreDetialNewVC:imgId];
        
    }else if ([item.type isEqualToString:@"31"]){
        //首页前三条数据跳转群列表和其他跳转群列表不一样
        
        [self pushPostBarNewList:item.tag_id imgIds:imgId type:type title:item.imgTitle isThrid:YES];
        
    }else if ([item.type isEqualToString:@"32"]){
        //群详情//可以
        [self pushPostMyGroupDetailVC:imgId];
        
    }else if ([item.type isEqualToString:@"51"]){
        //玩具跳转
       [self pushToyList];
        
    }
}
#pragma mark 自动轮播的方法
-(void)cycleScroll
{
    NSInteger page = (topPageControl.currentPage+1) % (_bannerArray.count);
    topPageControl.currentPage = page;
    if (page == _bannerArray.count-1) {
        page = 0;
    }else
    {
        page++;
    }
    [self pageChange:topPageControl];
}
-(void)pageChange:(UIPageControl*)pageControl{
    CGFloat x = (pageControl.currentPage)*(_topNewScrollView.bounds.size.width);
    [_topNewScrollView setContentOffset:CGPointMake(x, 0) animated:YES];

}
-(void)startAnimation
{
    if (_bannerArray.count > 0) {
        
        timer = [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(cycleScroll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];

    }
}
#pragma mark 跳转帖子列表 isThrid代表是否是前三条，如果是前三条，在群页面接口不一样，前三条用getOwnGroupList，下面的列表用另外的

-(void)pushPostBarNewList:(NSInteger)tagId  imgIds:(NSString*)imgIds type:(NSString*)type  title:(NSString*)title  isThrid:(BOOL)isThrid{
    PostBarListNewVC *postBarListVC = [[PostBarListNewVC alloc]init];
    postBarListVC.tag_id = tagId;
    postBarListVC.img_ids = imgIds;
    postBarListVC.type = type;
    postBarListVC.titleNav = title;
    postBarListVC.isThrid = isThrid;
    [self.navigationController pushViewController:postBarListVC animated:YES];
}
#pragma mark 跳转帖子详情
-(void)pushPostNewDetialVC:(NSString *)imgId userId:(NSString*)userId {
    //跳转帖子详情
    PostBarNewDetialV1VC *detailVC = [[PostBarNewDetialV1VC alloc]init];
    // PostBarNewDetailVC *detailVC=[[PostBarNewDetailVC alloc]init];
    
    detailVC.img_id=[NSString stringWithFormat:@"%@",imgId];
    detailVC.user_id=userId;
    detailVC.login_user_id=LOGIN_USER_ID;
    detailVC.refreshInVC = ^(BOOL isRefresh){
    };
    [detailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
#pragma mark 跳转视频帖子
-(void)pushBabyShowPlayer:(NSString *)video_url imgId:(NSString*)imgId   isHV:(BOOL)isHV{
    BabyShowPlayerVC *babyShowPlayerVC = [[BabyShowPlayerVC alloc]init];
    babyShowPlayerVC.img_id = imgId;
    babyShowPlayerVC.videoUrl = video_url;
    babyShowPlayerVC.isHV = isHV;
    [self.navigationController pushViewController:babyShowPlayerVC animated:YES];
}
#pragma mark 跳转群详情
-(void)pushPostMyGroupDetailVC:(NSString *)imgId{
    PostBarNewGroupOnlyOneVC *postBarVC = [[PostBarNewGroupOnlyOneVC alloc]init];
    postBarVC.group_id = [imgId intValue];
    [self.navigationController pushViewController:postBarVC animated:YES];
}

#pragma mark 跳转商家列表
-(void)pushStoreNewList:(NSInteger)tagId  imgIds:(NSString *)imgIds title:(NSString*)title{
    StoreMainNewListVC *storeMainVC = [[StoreMainNewListVC alloc]init];
    storeMainVC.tag_id = tagId;
    storeMainVC.img_ids = imgIds;
    storeMainVC.titleNav = title;
    [self.navigationController pushViewController:storeMainVC animated:YES];
    
}
#pragma mark 跳转新商家列表
-(void)pushStoreMoreList:(NSString*)imgIds  title:(NSString*)title {
    StorePicListMoreVC *storeMoreListVC = [[StorePicListMoreVC alloc]init];
    storeMoreListVC.imgIds = imgIds;
    storeMoreListVC.imgTitle = title;
    [self.navigationController pushViewController:storeMoreListVC animated:YES];
}

#pragma mark 跳转商家详情
-(void)pushStoreDetialNewVC:(NSString*)imgId{
    StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
    storeVC.longin_user_id = LOGIN_USER_ID;
    storeVC.business_id = imgId;
    [self.navigationController pushViewController:storeVC animated:YES];
}

#pragma mark 跳转玩具列表
-(void)pushToyList{
    ToyLeaseNewVC *listVC = [[ToyLeaseNewVC alloc]init];
    listVC.inTheViewData = 2001;
    [self.navigationController pushViewController:listVC animated:YES];

}
#pragma mark - UISearchBarDelegate Methods搜索
-(void)pushSearchView{
    SearchResultVC *searchResultVC = [[SearchResultVC alloc]init];
    [self.navigationController pushViewController:searchResultVC animated:NO];

}
//传入宽度和题目之后的高度
-(CGFloat)resetFrameWithTitle:(NSString*)title width:(CGFloat)width{
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float height = 0.0;
    
    if (title.length>0) {
        if (size.height >17.900391) {
            height = 40;
        }else{
            height = 20;
        }

    }else{
        height = 0;
    }
    
    return height;
    
}
-(CGFloat)resetFrameWithTitle:(NSString*)title widths:(CGFloat)widths{
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[title boundingRectWithSize:CGSizeMake(widths, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float height = 0.0;
    
    if (title.length>0) {
        if (size.height >15.513672) {
            height = 36;
        }else{
            height = 18;
        }
        
    }else{
        height = 0;
    }
    
    return height;
    
}

#pragma mark 当滚动的时候隐藏和显示导航条

CGPoint point;
//开始移动的时候停止轮播
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    point=scrollView.contentOffset;
    [timer invalidate];
    
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    [self startAnimation];
        //down
    if (point.y-scrollView.contentOffset.y>10) {
//        [self changeSearchBarTop];
    }
    if (point.y-scrollView.contentOffset.y<-10) {
//        [self changeSearchBar];
    
    }
    
}
//轮播图的变化
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    topPageControl.currentPage = scrollView.contentOffset.x/320;
}
#pragma mark cell delegate
//跳转个人中心
-(void)ClickOnTheAvatar:(btnWithIndexPath *)btn{
    
    NSArray *singleArray=[tableAdArray objectAtIndex:btn.indexpath.section];
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
    
    NSArray *singleArray=[tableAdArray objectAtIndex:btn.indexpath.section];
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
-(void)PickedTitleFriendsCellGotoTheUserPage:(btnWithIndexPath *)btn{
    NSArray *singleArray=[tableAdArray objectAtIndex:btn.indexpath.section];
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
#pragma mark 之前是要跳转到播放大图，现在是直接跳转帖子详情
-(void)SeeTheSingleImage:(btnWithIndexPath *)btn{
    NSArray *singleArray=[tableAdArray objectAtIndex:btn.indexpath.section];
    MyOutPutImgGroupItem *photoItem=[singleArray objectAtIndex:btn.indexpath.row];
    [self pushPostNewDetialVC:photoItem.imgid userId:photoItem.userid];
    
}
//点击图片进入图片详情
-(void)gotoTheDetail:(btnWithIndexPath *)btn{
    NSArray *singleArray=[tableAdArray objectAtIndex:btn.indexpath.section];
    MyOutPutImgGroupItem *photoItem=[singleArray objectAtIndex:btn.indexpath.row];
    [self pushPostNewDetialVC:photoItem.imgid userId:photoItem.userid];
}
//点击文字的时候的跳转
- (void)clickLabel:(ClickDescLabel *)label touchesWithIndexPath:(NSIndexPath *)indexPath {
    NSArray *singleArray = [tableAdArray objectAtIndex:indexPath.section];
    MyOutPutPraiseAndReviewItem *item1 = [singleArray lastObject];
    MyShowNewBasicItem *item;
    //=[singleArray objectAtIndex:indexPath.row];
    NSLog(@"singleArray = %@",singleArray);
    BOOL isHV;
    
        if (item1.videoUrl.length>0) {
            //话题是视频的时候，需要直接跳转
            BabyShowPlayerVC *babyShowPlayerVc = [[BabyShowPlayerVC alloc]init];
            babyShowPlayerVc.videoUrl = item1.videoUrl;
            babyShowPlayerVc.img_id = item1.imgid;
            for (item in singleArray) {
                if ([item isKindOfClass:[MyOutPutImgGroupItem class]]) {
                    MyOutPutImgGroupItem *imgItem=(MyOutPutImgGroupItem *) item;
                    MyShowImageItem *imgthing=[imgItem.photosArray firstObject];
                    float height = [imgthing.img_thumb_height floatValue];
                    float weight = [imgthing.img_thumb_width floatValue];
                    if (height > weight) {
                        isHV = NO;
                        babyShowPlayerVc.isHV = isHV;
                        [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
                        break;
                    }else{
                        isHV = YES;
                        babyShowPlayerVc.isHV = isHV;
                        [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
                        break;
                        
                    }
                    
                }
                

            }


            
        }else{
            [self pushPostNewDetialVC:item1.imgid userId:item1.userid];
    }
}
-(void)praise:(UIButton *)btn{
    
    _praiseSection=btn.tag;
    
    NetAccess *net=[NetAccess sharedNetAccess];
    
    
    NSArray *singleArray=[tableAdArray objectAtIndex:btn.tag];
    MyOutPutPraiseAndReviewItem *pItem=[singleArray lastObject];
 
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:pItem.userid,@"admire_user_id",
                            LOGIN_USER_ID,@"login_user_id",
                            pItem.imgid,kAdmireImgId,@"1",@"ispost",nil];
    if (pItem.isPraised==YES) {
        [net getDataWithStyle:NetStyleCancelAdmire andParam:paramDic];
    }else{
        [net getDataWithStyle:NetStyleAdmire andParam:paramDic];
    }
    
    
}
#pragma mark 删除秀秀

-(void)deleteShowSucceed:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];
    
    NSIndexSet *set=[[NSIndexSet alloc]initWithIndex:_deleteSection];
    
    NSArray *itemsArray=[tableAdArray objectAtIndex:_deleteSection];
    NSMutableArray *indexPathsArray=[[NSMutableArray alloc]init];
    
    for (int i=0;i<itemsArray.count;i++) {
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:_deleteSection];
        [indexPathsArray addObject:indexPath];
        
    }
    
    [tableAdArray removeObjectAtIndex:_deleteSection];
    
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

#pragma mark 点赞
-(void)praiseSucceed{
    
    NSArray *singleArray=[tableAdArray objectAtIndex:_praiseSection];
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
    [BBSAlert showAlertWithContent:not.object andDelegate:self];

    [LoadingView stopOnTheViewController:self];
    
}
//点击评论的时候
-(void)review:(UIButton *)btn{

    NSArray *singleArray=[tableAdArray objectAtIndex:btn.tag];
    MyOutPutPraiseAndReviewItem *pItem=[singleArray lastObject];
    //MyShowNewBasicItem *item=[singleArray objectAtIndex:btn.row];
    MyShowNewBasicItem *item;
    BOOL isHV;

    if (pItem.videoUrl.length>0) {
        BabyShowPlayerVC *babyShowPlayerVc = [[BabyShowPlayerVC alloc]init];
        babyShowPlayerVc.videoUrl = pItem.videoUrl;
        babyShowPlayerVc.img_id = pItem.imgid;
        for (item in singleArray) {
            if ([item isKindOfClass:[MyOutPutImgGroupItem class]]) {
                MyOutPutImgGroupItem *imgItem=(MyOutPutImgGroupItem *) item;
                MyShowImageItem *imgthing=[imgItem.photosArray firstObject];
                float height = [imgthing.img_thumb_height floatValue];
                float weight = [imgthing.img_thumb_width floatValue];
                if (height >weight) {
                    isHV = NO;//横屏
                    babyShowPlayerVc.isHV = isHV;
                    [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
                    break;
                }else{
                    isHV = YES;
                    babyShowPlayerVc.isHV = isHV;
                    [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
                    break;

                }

            }
        }
        
    }else{
        [self pushPostNewDetialVC:pItem.imgid userId:pItem.userid];
    }
}
//点击分享的时候
-(void)more:(UIButton *)btn{
    NSArray *singleArray=[tableAdArray objectAtIndex:btn.tag];
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
                [self shareToThird];
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
            action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享",message,nil];
            action.tag=btn.tag;
            action.destructiveButtonIndex = action.numberOfButtons - 2;
        [action showFromTabBar:self.tabBarController.tabBar];
    }
    
    
}

- (void)shareToThird {
    NSArray *singleArray=[tableAdArray objectAtIndex:_deleteSection];
    NSString *userID,*imgID,*desc,*thumbString,*isvideo;
    
    MyShowNewBasicItem *item = singleArray[0];
    userID = item.userid;
    imgID = item.imgid;
    
    for (int i = 0; i < singleArray.count; i++) {
        
        if ([singleArray[i] isKindOfClass:[MyOutPutImgGroupItem class]]) {
            MyOutPutImgGroupItem *photoItem = singleArray[i];
            MyShowImageItem *imageItem = [photoItem.photosArray firstObject];
            thumbString = imageItem.imageStr;
            isvideo = photoItem.video_url;
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
    NSString *urlString;
    if (isvideo.length > 0) {
        urlString = [NSString stringWithFormat:@"%@img_id=%@&user_id=%@",VideoShareUrl,imgID,userID];
    }else{
        urlString = [NSString stringWithFormat:@"%@img_id=%@&user_id=%@",PostShareUrl,imgID,userID];

    }
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
    NSString *shareTitle;
    if (desc.length>0) {
        shareTitle = desc;
    }else{
        shareTitle = @"自由环球租赁话题分享";
    }
    [shareParams SSDKSetupShareParamsByText:desc
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]
                                      title:shareTitle
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
                //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
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
- (void)deleteOrReport {
    NSArray *singleArray=[tableAdArray objectAtIndex:_deleteSection];
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
        [paramDic setObject:@"1" forKey:@"ispost"];
        [net getDataWithStyle:NetStyleDelShow andParam:paramDic];
    }else{
        //举报
        ReportViewController *report=[[ReportViewController alloc]init];
        report.imgId=pItem.imgid;
        report.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:report animated:YES];
        
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
-(void)PickedTitleCellGotoTheUserPage:(btnWithIndexPath *)btn{
    NSArray *singleArray=[tableAdArray objectAtIndex:btn.indexpath.section];
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
    
    NSArray *singleArray=[tableAdArray objectAtIndex:btn.indexpath.section];
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
#pragma mark -点击视频展示 点击图片跳转播放详情页面
-(void)playVideoUrl:(btnWithIndexPath *)btn{
    
    _currentIndexPath = btn.indexpath;
    NSString *videoUrl;
    NSString *imgId;
    BOOL isHV;
    if (_inTheViewData == 1007) {
        BabyShowMainItem *item = [tableNewArray objectAtIndex:_currentIndexPath.row];
            imgId  = item.imgArray[0][@"img_id"];
            float height = [item.imgArray[0][@"img_thumb_height"] floatValue];
            float weight = [item.imgArray[0][@"img_thumb_width"] floatValue];
            if (height > weight) {
                isHV = NO;//横屏
            }else{
                isHV = YES;
            }

        videoUrl = item.video_url;
        
    }else {
        NSArray *singleArray=[tableAdArray objectAtIndex:_currentIndexPath.section];
        MyOutPutImgGroupItem *photoItem=[singleArray objectAtIndex:_currentIndexPath.row];
        videoUrl = photoItem.video_url;
        imgId = photoItem.imgid;
        MyShowImageItem *imgthing=[photoItem.photosArray firstObject];
        float height = [imgthing.img_thumb_height floatValue];
        float weight = [imgthing.img_thumb_width floatValue];
        if (height > weight) {
            isHV = NO;//横屏
        }else{
            isHV = YES;
            
        }


    }
    
    BabyShowPlayerVC *babyShowPlayerVc = [[BabyShowPlayerVC alloc]init];
    babyShowPlayerVc.videoUrl = videoUrl;
    babyShowPlayerVc.img_id = imgId;
    babyShowPlayerVc.isHV = isHV;
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
            __weak BabyMainNewVC *babyVC = self;
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
    
    NSString *videoUrl;
    NSString *imgId;
    NSString *imgThumb;
    BOOL isHV;
    if (_inTheViewData == 1007) {
        BabyShowMainItem *item = [tableNewArray objectAtIndex:_currentIndexPath.row];
            imgId  = item.imgArray[0][@"img_id"];
            imgThumb = item.imgArray[0][@"img_thumb"];
            float height = [item.imgArray[0][@"img_thumb_height"] floatValue];
            float weight = [item.imgArray[0][@"img_thumb_width"] floatValue];
            if (height > weight) {
                isHV = NO;//竖屏
            }else{
                isHV = YES;
            }
        videoUrl = item.video_url;
    }else {
        NSArray *singleArray=[tableAdArray objectAtIndex:_currentIndexPath.section];
        MyOutPutImgGroupItem *photoItem=[singleArray objectAtIndex:_currentIndexPath.row];
        MyShowImageItem *imgthing=[photoItem.photosArray firstObject];
        imgThumb = imgthing.imageStr;
        videoUrl = photoItem.video_url;
        imgId = photoItem.imgid;
        float height = [imgthing.img_thumb_height floatValue];
        float weight = [imgthing.img_thumb_width floatValue];
        if (height > weight) {
            isHV = NO;//横屏
        }else{
            isHV = YES;
            
        }
    }
    SDWebImageManager *manager=[SDWebImageManager sharedManager];
    
    if (_showPlayer) {
        [_showPlayer removeFromSuperview];
        float heightInTheView;
        if (_inTheViewData == 1007) {
            heightInTheView = SCREENWIDTH/2;
            _showPlayer = [[XSMediaPlayer alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, heightInTheView)];
            
        }else{
            heightInTheView = SCREENWIDTH*0.6+20;
            _showPlayer = [[XSMediaPlayer alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, heightInTheView)];
            
        }
        _showPlayer.videoURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@",videoUrl]];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

    }else{
        float heightInTheView;
        if (_inTheViewData == 1007) {
            heightInTheView = SCREENWIDTH/2;
            _showPlayer = [[XSMediaPlayer alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, heightInTheView)];

        }else{
            heightInTheView = SCREENWIDTH*0.6+20;
            _showPlayer = [[XSMediaPlayer alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, heightInTheView)];

        }
        _showPlayer.videoURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@",videoUrl]];
        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];

        
    }
    [manager downloadImageWithURL:[NSURL URLWithString:imgThumb] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [_showPlayer settingBackgroupImg:image];
        
    }];
    
    _showPlayer.isFromList = YES;
    _showPlayer.isHV = isHV;
    _showPlayer.imgID = imgId;
    _showPlayer.videoUrlString = videoUrl;
    
    _showPlayer.nav = self.navigationController;
    [_showPlayer setHorizontalOrVerticalScreen:isHV];
    [_showPlayer.player play];
    [_currentCell addSubview:_showPlayer ];
    
}
#pragma mark -scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _tableViewNew) {
        currentPage  =_topNewScrollView.contentOffset.x/_topNewScrollView.frame.size.width;
        topPageControl.currentPage = currentPage;

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
