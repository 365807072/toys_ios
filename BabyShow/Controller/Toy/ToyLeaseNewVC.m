//
//  ToyLeaseNewVC.m
//  BabyShow
//
//  Created by WMY on 17/1/11.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyLeaseNewVC.h"
#import "RefreshControl.h"
#import "ToyLeaseItem.h"
#import "ToyLeaseListCell.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "ToyLeaseDetailVC.h"
#import "MakeAToyPostVC.h"
#import "ToyTransportVC.h"
#import "NIAttributedLabel.h"
#import "LoginHTMLVC.h"
#import "WebViewController.h"
#import "MyDepositVC.h"
#import "SpecialHeadListModel.h"
#import "ToyListNewCell.h"
#import "ToyListItem1.h"
#import "PostBarNewDetialV1VC.h"
#import "ToyClassListVC.h"
#import "ToyOrderListCell.h"
#import "ToyOrderItem.h"
#import "ToyDepositCell.h"
#import "MakeSurePaySureVC.h"
#import "ToySearchVC.h"
#import "PurchaseCarAnimationTool.h"
#import "ToyCarDetailCell.h"
#import "ToyCarHeadCell.h"
#import "ToyMessDetailCell.h"
#import "ToyMessDetailItem.h"
#import "ToyCarHeadItem.h"
#import "ToyCarMainItem.h"
#import "LineViewCell.h"
#import "ToyOrderBottomItem.h"
#import "ToyOrderNumberItem.h"
#import "ToyDetailTimeCell.h"
#import "ToyOrderNumberCell.h"
#import "MakeSureMoneyVC.h"
#import "ClickViewController.h"
#import "ToyShareNewVC.h"
#import "BookToysVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "ChangeToySucceedVC.h"
#import "ToySecondStyleCell.h"
#import "ToyThridStyleCell.h"
#import "ToyFourStyleCell.h"
#import "ToyLIstClassItem.h"
#import "ToyAgeClassItem.h"
#import "UIButton+WebCache.h"
#import "ToyOrderHeadItem.h"
#import "MyCardListH5VC.h"
#import "MySaveVC.h"


@interface ToyLeaseNewVC ()<RefreshControlDelegate,ToyAddCarCellDelegate>{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSMutableArray *_toydataArray;
    NSMutableArray *_orderdataArray;
    NSMutableArray *_toyCarDataArray;
    NSMutableArray *_toyCarCanDeleteToyArray;//购物车里面可以删除的数组
    
    RefreshControl *_refreshControl;
    RefreshControl *_refreshControlCollectionview;
    
    UIScrollView *_topNewScrollView;
    UIScrollView *_CardScrollView;
    NSMutableArray *_bannerArray;
    NSMutableArray *_cardArray;
    NSTimer *timer;
    UIPageControl *topPageControl;
    UIButton *firstBtn;
    UIButton *secondBtn;
    UIButton *thridBtn;
    UIButton *fourBtn;
    
    //订单头部的会员卡，收藏，押金，预约
    UIScrollView *_orderHeadScrollView;
    UIView *orderHeadView;
    UIButton *myCardBtn;
    UIButton *myDepositBtn;
    UIButton *myAppointmentBtn;
    UIButton *mySaveBtn;
    

    
    UIView *btnView;
    UIView *headView;
    UIView *headViewSearch;
    NSInteger deleTag;
    UIButton *deleSmallOrderBtn;//单个订单的删除
    UIButton *deleCombineIdBtn;//删除批量订单
    UIButton *moreSmallBtn;//单个订单记录最后点击去支付按钮的indexbtn
    UIButton *moreCombineIdBtn;//整个订单记录最后点击去支付按钮的indexbtn
    UIButton *rightBtn;
    UIButton *_backBtn;
    UIButton *_backBtnInToyCarAndOrder;
    
    UIView *_emptyView;
    UIImageView *_noToyImgView;
    UIButton *searchBtn;
    UIView *_emptyNoToyView;
    UIImageView *_noToySelectImgView;
}
@property(nonatomic,strong)UIView *bannerView;
@property(nonatomic, strong) NSString *post_create_time;
@property(nonatomic, strong) NSString *post_create_timeToy;
@property(nonatomic, strong) NSString *post_create_timeOrder;
@property(nonatomic,strong)NSString *post_create_carToy;//购物车
@property(nonatomic,strong)NSString *orderId;//发完贴之后的玩具订单id
@property(nonatomic,assign)NSInteger lastTag;//最后的按钮
@property(nonatomic,strong)UIView *navSearchView;//搜索的页面
@property(nonatomic,strong)UIView *payToys;//结算页面
@property(nonatomic,strong)UIButton *payBtn;//去结算
@property(nonatomic,strong)UILabel *totalLabel;//合计
@property(nonatomic,strong)UILabel *totalMoneyLabel;//合计金额
@property(nonatomic,strong)UIView *carAlertView;//购物车上面的提示页面
@property(nonatomic,strong)UIImageView *alertViewImg;//购物车提示图片
@property(nonatomic,strong)UILabel * alertLabel;//购物车提示的语言
@property(nonatomic,strong)NSString *searchWordAlert;
@property(nonatomic,strong)NSString *isButton;//去结算的按钮
@property(nonatomic,strong)UIView *grayBackView;//导航的透明页面
@property(nonatomic,strong)UIImageView *imgVip;//展示的查看vip大图

@property(nonatomic,assign)BOOL isDeleteToyCar;//是否是在编辑购物车的状态
@property(nonatomic,strong)YLButton *deleteToyCar;//删除
@property(nonatomic,strong)YLButton *selectAllBtn;//全选购物车
@property(nonatomic,strong)NSMutableArray *deleteArray;//删除选择玩具的数组
@property(nonatomic,strong)YLButton *editBtn;//购物车的编辑按钮
@property(nonatomic,strong)UIBarButtonItem *right;
@property(nonatomic,assign)BOOL isEditSelect;//编辑按钮是否被选中
@property(nonatomic,assign)BOOL isSelectAll;//全选是否被选中
@property(nonatomic,strong)NSString *carWay;//全部或是单个
@property(nonatomic,strong)NSString *cardsString;//购物车数组
@property(nonatomic,strong)YLButton *shareRequestFriendBtn;//邀请好友得好礼

@property(nonatomic,strong)UIButton *goBuyCardBtn;//去购买年卡
@property(nonatomic,strong)NSMutableArray *orderListArray;//订单前2个数组

@property(nonatomic,strong)NSString *myDepositOrderID;//跳转我的押金
@property(nonatomic,strong)NSString *myBookId;//跳转我的预约
//发红包的页面
@property(nonatomic,strong)UIView *grayView;
@property(nonatomic,strong)UIButton *goToShareBtn;// 分享大按钮
@property(nonatomic,strong)UIButton *gotoCacelBtn;//取消分享按钮
@property(nonatomic,strong)NSString *shareMainTitle;//分享主标题
@property(nonatomic,strong)NSString *shareSecondTitle;//分享的副标题
@property(nonatomic,strong)NSString *windowImg;//分享的图片
@property(nonatomic,strong)NSString *sharePostUrl;//分享的url
@property(nonatomic,strong)NSString *shareActivityPostUrl;//分享成功后的抽奖页面
//全部玩具的集合
@property(nonatomic,strong)UICollectionView *collectionView;
//全部玩具的分类
@property(nonatomic,strong)UIView *classifyGrayView;//筛选分类下面的阴影
@property(nonatomic,strong)UIView *classifyView;//
@property(nonatomic,strong)NSMutableArray *chooseBtnArray;
@property(nonatomic,strong)UIView *classifyChooseView;//选择分类的下面view
@property(nonatomic,strong)UIScrollView *classifyChooseScrollView;//选择分类的滑动view
@property(nonatomic,strong)UIScrollView *classifyBrandChooseScrollView;//品牌选择view
@property(nonatomic,strong)UIScrollView *classifyAllChooseScrollView;//综合排序
@property(nonatomic,strong)UIScrollView *classifySelectChooseScrollView;//筛选
//下面都是分类数据
@property(nonatomic,strong)NSDictionary *toysAgeDic;
@property(nonatomic,strong)NSDictionary *toys_brandDic;
@property(nonatomic,strong)NSDictionary *toys_allDic;
@property(nonatomic,strong)NSDictionary *toys_selectDic;
@property(nonatomic,strong)NSString *toyAgeMainTitle;
@property(nonatomic,strong)NSString *toys_brandMainTitle;
@property(nonatomic,strong)NSString *toys_allMainTitle;
@property(nonatomic,strong)NSString *toys_selectMainTitle;
@property(nonatomic,strong)NSMutableArray *toysAgeArray;
@property(nonatomic,strong)NSMutableArray *toys_brandArray;
@property(nonatomic,strong)NSMutableArray *toys_allArray;
@property(nonatomic,strong)NSMutableArray *toys_selectArray;
@property(nonatomic,strong)NSMutableArray *openSelectArray;//展开的数组
@property(nonatomic,strong)UIView *makeSureClassifyView;//筛选确定的页面
@property(nonatomic,strong)UIButton *makeSureClassifyBtn;//筛选确定按钮
//各个分类最后的选中数组
@property(nonatomic,strong)NSMutableArray *ageSelectedArray;
@property(nonatomic,strong)NSMutableArray *ageSelectedBtnArray;
@property(nonatomic,strong)NSString *ageSelectedString;
@property(nonatomic,strong)NSMutableArray *brandSelectedArray;
@property(nonatomic,strong)NSMutableArray *brandSelectedBtnArray;
@property(nonatomic,strong)NSString *allSelectedString;
@property(nonatomic,strong)NSMutableArray *chooseSelectedArray;
@property(nonatomic,strong)NSMutableArray *chooseSelectedNameArray;
//右上角的分享图标
@property(nonatomic,strong)UIImage *shareImg;

@property(nonatomic,strong)NSString *alertAlertClassifyString;//全部列表头部的提示

@property(nonatomic,strong)UIView *carSelectView;//玩具列表
@property(nonatomic,strong)UIImageView *alertSelectViewImg;//玩具列表
@property(nonatomic,strong)UILabel * alertSelectLabel;//玩具列表头部
@property(nonatomic,strong)NSString *classfyMakeString;//从首页跳到全部是否带分类标签
@property(nonatomic,strong)NSString *shareToyImgBig;//展示出来的大图
@property(nonatomic,strong)UIView *iconBgView;
@property(nonatomic,strong)NSString *cardOrderId;


//  广告弹窗
@property(nonatomic,strong)NSString *post_urlActivity;
@property(nonatomic,strong)NSString *imgActivity;
@property(nonatomic,strong)NSString *typeActivity;
@property(nonatomic,strong)UIView *grayViewActivity;
@property(nonatomic,strong)UIButton *goToShareBtnActivity;// 分享大按钮
@property(nonatomic,strong)UIButton *gotoCacelBtnActivity;//取消分享按钮

// 订单头部按钮数组
@property(nonatomic,strong)NSMutableArray *orderHeadArray;

@property(nonatomic,strong)NSString *hotToy;





@end

@implementation ToyLeaseNewVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = [NSMutableArray array];
        _orderdataArray = [NSMutableArray array];
        _toydataArray = [NSMutableArray array];
        _toyCarDataArray = [NSMutableArray array];
        _toyCarCanDeleteToyArray = [NSMutableArray array];//购物车里面玩具可以删除的数组
        _deleteArray = [NSMutableArray array];//购物车准备删除的玩具
        _orderListArray = [NSMutableArray array] ;
        _openSelectArray = [NSMutableArray array];
        // 联合筛选的时候的数组
        _ageSelectedArray = [NSMutableArray array];
        _ageSelectedBtnArray = [NSMutableArray array];
        _brandSelectedArray = [NSMutableArray array];
        _brandSelectedBtnArray = [NSMutableArray array];
        
        _chooseSelectedArray = [NSMutableArray array];
        _chooseSelectedNameArray = [NSMutableArray array];
        _orderHeadArray = [NSMutableArray array];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    if (_inTheViewData == 2001 || _inTheViewData == 2002) {
        self.navigationController.navigationBarHidden = YES;
    }else{
        self.navigationController.navigationBarHidden = NO;
    }
    if (_hideBottomTab) {
        self.tabBarController.tabBar.hidden = NO;
    } else {
        self.tabBarController.tabBar.hidden = YES;
    }
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.translucent = NO;

    //支付成功后的通知
  
    if (_inTheViewData == 2004) {
        [self changeData:2004];
    }else if(_inTheViewData == 2003){
        if (_orderdataArray.count > 0) {
            [self changeData:2003];
        }
    }
    if (_inTheViewData == 2002) {
        [self alertShowInSelectView:_alertAlertClassifyString];
        [self changeDataWithTag:secondBtn];
    }
    [self getToyCarCount];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [BBSColor hexStringToColor:NAVICOLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; [self.navigationController.navigationBar setShadowImage:nil];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.navigationBarHidden = NO;
    [_tableView removeObserver:self forKeyPath:@"contentOffset"];
    self.navigationController.navigationBar.translucent = YES;
    [self cancelActivityView];

}
#pragma mark   是否展示广告弹窗
-(void)isShowActivityView{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"getToysIndexTextimg" params:param success:^(NSDictionary *result) {
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
    _grayViewActivity = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENHEIGHT)];
    _grayViewActivity.backgroundColor = [BBSColor hexStringToColor:@"000000" alpha:0.5];
    [self.view addSubview:_grayViewActivity];
    _grayViewActivity.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerCancelTappedA:)];
    [_grayViewActivity addGestureRecognizer:singleTap];
    
    _goToShareBtnActivity = [UIButton buttonWithType:UIButtonTypeCustom];
    // [_goToShareBtn setBackgroundImage:[UIImage imageNamed:@"toy_share_get_dayBtn"] forState:UIControlStateNormal];
    _goToShareBtnActivity.adjustsImageWhenHighlighted = NO;
    [_goToShareBtnActivity sd_setBackgroundImageWithURL:[NSURL URLWithString:self.imgActivity] forState:UIControlStateNormal];
    
    
    _goToShareBtnActivity.frame =  CGRectMake(0.15*SCREENWIDTH,(SCREENHEIGHT-(1.4*SCREENWIDTH*0.7))/2-30, SCREENWIDTH*0.7, 1.4*SCREENWIDTH*0.7);
    [_grayViewActivity addSubview:_goToShareBtnActivity];
    [_goToShareBtnActivity addTarget:self action:@selector(sendRedPacketActivity) forControlEvents:UIControlEventTouchUpInside];
    
    _gotoCacelBtnActivity = [UIButton buttonWithType:UIButtonTypeCustom];
    [_gotoCacelBtnActivity setBackgroundImage:[UIImage imageNamed:@"toy_cancle_share_get_dayBtn"] forState:UIControlStateNormal];
    _gotoCacelBtnActivity.frame = CGRectMake((SCREENWIDTH-36)/2, _goToShareBtnActivity.frame.origin.y+_goToShareBtnActivity.frame.size.height+30, 36, 36);
    [_grayViewActivity addSubview:_gotoCacelBtnActivity];
    [_gotoCacelBtnActivity addTarget:self action:@selector(cancelActivityView) forControlEvents:UIControlEventTouchUpInside];
    _gotoCacelBtnActivity.adjustsImageWhenHighlighted = NO;
    
    
}
-(void)fingerCancelTappedA:(UITapGestureRecognizer *)gestureRecognizer

{
    [self cancelActivityView];
    
}

-(void)cancelActivityView{
    _grayViewActivity.hidden = YES;
    _gotoCacelBtnActivity.hidden = YES;
    _goToShareBtnActivity.hidden = YES;
    
}
#pragma mark 活动页面跳转
-(void)sendRedPacketActivity{
    if ([self.typeActivity isEqualToString:@"41"]) {
        // 外链
        WebViewController *webView=[[WebViewController alloc]init];
        NSString *urlString =  self.post_urlActivity;
        webView.urlStr=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [webView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:webView animated:YES];
        
    }else  if([self.typeActivity isEqualToString:@"2"]){
        //帖子
        PostBarNewDetialV1VC *detailVC=[[PostBarNewDetialV1VC alloc]init];
        detailVC.img_id=self.post_urlActivity;
        detailVC.login_user_id=LOGIN_USER_ID;
        detailVC.refreshInVC = ^(BOOL isRefresh){
            
        };
        [detailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];

        
       // [self pushPostNewDetialVC:self.post_urlActivity userId:LOGIN_USER_ID];
    }else if ([self.typeActivity isEqualToString:@"7"]){
        //玩具详情
        [self pushDetailToyPage:self.post_urlActivity];
        
    }else if ([self.typeActivity isEqualToString:@"11"]){
        //邀请页面
        [self requestFriendShare];
        
        
    }
}

#pragma mark 换玩具后，分享页面的弹窗
-(void)changeToyAndShare{
    //蒙版
    _grayView = [[UIView  alloc]initWithFrame:CGRectMake(0, -64, SCREEN_WIDTH, SCREENHEIGHT)];
    _grayView.backgroundColor = [BBSColor hexStringToColor:@"000000" alpha:0.5];
    [self.view addSubview:_grayView];
    _grayView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerCancelTapped:)];
    [_grayView addGestureRecognizer:singleTap];

    
    _goToShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //[_goToShareBtn setBackgroundImage:[UIImage imageNamed:@"toy_share_get_dayBtn"] forState:UIControlStateNormal];
    _goToShareBtn.adjustsImageWhenHighlighted = NO;
    _goToShareBtn.frame = CGRectMake(0.15*SCREENWIDTH,(SCREENHEIGHT-(1.4*SCREENWIDTH*0.7))/2-30, SCREENWIDTH*0.7, 1.4*SCREENWIDTH*0.7);

    [_grayView addSubview:_goToShareBtn];
    [_goToShareBtn addTarget:self action:@selector(sendRedPacket) forControlEvents:UIControlEventTouchUpInside];
    
    _gotoCacelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_gotoCacelBtn setBackgroundImage:[UIImage imageNamed:@"toy_cancle_share_get_dayBtn"] forState:UIControlStateNormal];
    _gotoCacelBtn.frame =  CGRectMake((SCREENWIDTH-36)/2, _goToShareBtn.frame.origin.y+_goToShareBtn.frame.size.height+30, 36, 36);
   // CGRectMake((SCREENWIDTH-36)/2, _goToShareBtn.frame.origin.y+280+30, 36, 36);
    [_grayView addSubview:_gotoCacelBtn];
    [_gotoCacelBtn addTarget:self action:@selector(cancelSendRedBag) forControlEvents:UIControlEventTouchUpInside];
    _gotoCacelBtn.adjustsImageWhenHighlighted = NO;

    if (_isAfterPay == YES) {
        [self getDataIsOrNoShare];
        
    }else{
    _grayView.hidden = YES;
    _goToShareBtn.hidden = YES;
    _gotoCacelBtn.hidden = YES;
    }

}
-(void)getDataIsOrNoShare{
    NSString *loginUserId=[NSString stringWithFormat:@"%@",LOGIN_USER_ID];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"login_user_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"GetUserInfoActivity" params:param success:^(NSDictionary *result) {
        NSDictionary *data = result[@"data"];
        
        if ([data[@"display_status"] isEqualToString:@"1"]) {
            self.shareMainTitle = data[@"main_title"];
            self.shareSecondTitle = data[@"second_title"];
            self.windowImg = data[@"window_img"];
            self.sharePostUrl = data[@"post_url"];
            self.shareActivityPostUrl =  data[@"activity_post_url_new"];
            self.shareToyImgBig = data[@"icon_img"];
            [_goToShareBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.shareToyImgBig] forState:UIControlStateNormal];
            [self showShareView];
        }else{
            [self cancelSendRedBag];
        }
        
    } failed:^(NSError *error) {
        [self cancelSendRedBag];

    }];
 
}
-(void)fingerCancelTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [self cancelSendRedBag];
    
}

#pragma mark 换玩具后会展示出来的分享抽奖页面
-(void)showShareView{
    _isAfterPay = NO;
    _grayView.hidden = NO;
    _gotoCacelBtn.hidden = NO;
    _goToShareBtn.hidden = NO;
 
}
#pragma mark 取消分享
-(void)cancelSendRedBag{
    _grayView.hidden = YES;
    _gotoCacelBtn.hidden = YES;
    _goToShareBtn.hidden = YES;
}
#pragma mark 分享页面抽奖
-(void)sendRedPacket{
    //NSString *urlString = self.sharePostUrl;
    NSString *content = self.shareSecondTitle;
    __weak ToyLeaseNewVC *myStoreVC = self;
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSURL *url = [NSURL URLWithString:self.windowImg];
    UIImage *shareImg;
    if (self.windowImg.length > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.windowImg]];
        shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        UIImage *weixinImg = shareImg;
        NSData *basicImgData = UIImagePNGRepresentation(shareImg);
        if (basicImgData.length/1024>150) {
            shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
            weixinImg = [self scaleToSize:weixinImg size:CGSizeMake(150, 120)];
        }
        
    }else{
        shareImg = [UIImage imageNamed:@"img_default"];
        
    }
    NSArray* imageArray = @[shareImg];
    NSString *urlString = self.sharePostUrl;
    [shareParams SSDKSetupShareParamsByText:self.shareSecondTitle
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]
                                      title:self.shareMainTitle
                                       type:SSDKContentTypeAuto];

    //设置新浪微博
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",self.shareMainTitle,[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:self.shareMainTitle image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
//    [shareParams SSDKSetupWeChatMiniProgramShareParamsByTitle:self.shareMainTitle description:self.shareSecondTitle webpageUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] path:_sharePath thumbImage:shareImg hdThumbImage:weixinImg userName:@"gh_740dc1537e7c" withShareTicket:NO miniProgramType:0 forPlatformSubType:SSDKPlatformSubTypeWechatSession];

    
   // NSArray* imageArray = @[shareImg];
        [shareParams SSDKSetupWeChatParamsByText:content title:self.shareMainTitle url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] thumbImage:shareImg image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    

    
    [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateBegin:
            {
                //  [storeVC showLoadingView:YES];
                [self cancelSendRedBag];
                break;
            }

            case SSDKResponseStateSuccess:
            {
                //分享成功后的抽奖页面
                [self cancelSendRedBag];

                WebViewController *webView=[[WebViewController alloc]init];
                NSString *urlString =  self.shareActivityPostUrl;
                webView.urlStr=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [webView setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:webView animated:YES];

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
    

    //分享
  
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


#pragma mark 批次订单支付成功后的通知
-(void)getPayDataSucceed{
    _inTheViewData = 2003;
   [self getDataIsOrNoShare];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPayDataSucceed) name:USER_TOY_PAYCOMBINE_SUCCEED object:nil];

    self.view.backgroundColor = [UIColor whiteColor];
    [self getDataSearchWord];
    _post_create_time = NULL;
    _post_create_timeToy = NULL;
    _post_create_timeOrder = NULL;
    _post_create_carToy = NULL;
    if (_inTheViewData != 2003 && _inTheViewData != 2002) {
        _inTheViewData = 2001;
    }
    if (_inTheViewData == 2001 || _inTheViewData == 2002) {
        self.navigationController.navigationBarHidden = YES;
    }else{
        self.navigationController.navigationBarHidden = NO;
    }
    [self setHeadViewCar];
    [self setBannerHead];
     //订单头部
    [self setOrderBannerHead];
    //搜索工具栏
    [self setTableView];
    //设置集合的view
    [self setCollectionViewLay];
    [self setRightBtn];
    [self setSearchBar];
    [self setClassifyBtnView];
    [self setBackButton];
    [self setBottomView];
    [self refreshControlInit];
    
    [self refreshCollectviewInit];
    
    [self startAnimation];
    headView = [[UIView alloc]initWithFrame:CGRectZero];
    //获取购物车里面的玩具数量
    [self getToyCarCount];
    [self changeToyAndShare];
    [self setAlertingViewInSelectView];
    if (theAppDelegate.isRequestActivityToy == YES) {
        [self isShowActivityView];
        theAppDelegate.isRequestActivityToy = NO;

    }

}
#pragma mark 在全部列表头部的提示通知
-(void)setAlertingViewInSelectView{
    self.carSelectView =  [[UIView alloc]initWithFrame:CGRectMake(0,self.navSearchView.frame.size.height+self.navSearchView.frame.origin.y+34, SCREENWIDTH, 30)];
    self.carSelectView.backgroundColor = [BBSColor hexStringToColor:@"fff6dd"];
    [self.view addSubview:self.carSelectView];
    self.alertSelectViewImg = [[UIImageView alloc]initWithFrame:CGRectMake(9, 6, 15, 18)];
    self.alertSelectViewImg.image = [UIImage imageNamed:@"toy_alert"];
    [self.carSelectView addSubview:self.alertSelectViewImg];
    self.alertSelectLabel = [[UILabel alloc]initWithFrame:CGRectMake(27, 6, SCREENWIDTH-40, 18)];
    self.alertSelectLabel.textColor = [BBSColor hexStringToColor:@"836843"];
    self.alertSelectLabel.font = [UIFont systemFontOfSize:12];
    self.alertSelectLabel.numberOfLines = 0;
    [self.carSelectView addSubview:self.alertSelectLabel];
    self.carSelectView.hidden = YES;


}
#pragma mark 邀请好友得好礼
-(void)setShareRequestFirend{
    _shareRequestFriendBtn = [YLButton buttonWithFrame:CGRectMake(SCREENWIDTH-90, SCREENHEIGHT-46-50-35, 80, 26) type:UIButtonTypeCustom backImage:nil target:self action:@selector(requestFriendShare) forControlEvents:UIControlEventTouchUpInside];
    _shareRequestFriendBtn.backgroundColor = [BBSColor hexStringToColor:NAVICOLOR alpha:0.8];
    _shareRequestFriendBtn.layer.masksToBounds = YES;
    _shareRequestFriendBtn.layer.cornerRadius = 15;
    [_shareRequestFriendBtn setTitle:@"邀请好友得好礼" forState:UIControlStateNormal];
    [_shareRequestFriendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _shareRequestFriendBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [self.view addSubview:_shareRequestFriendBtn];
    [self.view bringSubviewToFront:_shareRequestFriendBtn];
}
#pragma mark -------------------------获取全部玩具列表的头部分类-------------------------
#pragma mark 全部玩具的头部分类
-(void)setClassifyBtnView{
    
    _classifyView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navSearchView.frame.size.height+self.navSearchView.frame.origin.y, SCREEN_WIDTH, 34)];
    //self.navSearchView.frame.size.height+self.navSearchView.frame.origin.y+34
    _classifyView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_classifyView];
    _classifyView.hidden = YES;
    _chooseBtnArray = [NSMutableArray array];
    
    _classifyGrayView = [[UIView alloc]initWithFrame:CGRectMake(0, self.navSearchView.frame.size.height+self.navSearchView.frame.origin.y+34, SCREEN_WIDTH, SCREENHEIGHT-34-self.navSearchView.frame.size.height)];
    _classifyGrayView.backgroundColor = [BBSColor hexStringToColor:@"000000" alpha:0.3];
    [self.view addSubview:_classifyGrayView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeClassifyGrayView:)];
    singleTap.delegate = self;
    [_classifyGrayView addGestureRecognizer:singleTap];
    _classifyGrayView.hidden = YES;
    for (int i = 0; i <4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        btn.tag = 4001+i;
        [btn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
        if (i == 3) {
            btn.frame = CGRectMake(SCREEN_WIDTH*0.78, 0, SCREEN_WIDTH*0.22, 34);
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -10, 0, 20)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(2, 50,2, 5)];

        }else{
            btn.frame = CGRectMake((SCREEN_WIDTH*0.78)/3*i, 0, (SCREEN_WIDTH*0.78)/3, 34);
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(2, 65,1, -5)];
            

        }
        [btn setImage:[UIImage imageNamed:@"classifyToyUnselect@3x"] forState:UIControlStateNormal];
        [_classifyView addSubview:btn];
        _classifyView.backgroundColor = [UIColor whiteColor];
        [_chooseBtnArray addObject:btn];
    }
    [self getClassifyDate];
    
}
-(void)removeClassifyGrayView:(UITapGestureRecognizer*)tap{
    _classifyGrayView.hidden = YES;
    _classifyChooseView.hidden = YES;
    [self hiddenAllClassifyView];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([touch.view isDescendantOfView:_classifyChooseView]) {
        return NO;
    }
    return YES;
}


-(void)getClassifyDate{
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    
    [[HTTPClient sharedClient]getNewV1:@"getToysSelectInfo" params:dic success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = result[@"data"];
            self.toysAgeDic = data[@"toys_age"];
            self.toys_brandDic = data[@"toys_brand"];
            self.toys_allDic = data[@"toys_all"];
            self.toys_selectDic = data[@"toys_select"];
            //解析年龄的数组
            NSArray *ageArray = self.toysAgeDic[@"main_val"];
            _toysAgeArray = [NSMutableArray array];
            for (NSDictionary *ageDic in ageArray) {
                ToyAgeClassItem *itemAge = [[ToyAgeClassItem alloc]init];
                itemAge.each_title = ageDic[@"each_title"];
                itemAge.each_val = ageDic[@"each_val"];
                [_toysAgeArray addObject:itemAge];
            }
            //解析品牌的数组
            NSArray *brandArray = self.toys_brandDic[@"main_val"];
            _toys_brandArray = [NSMutableArray array];
            for (NSDictionary *ageDic in brandArray) {
                ToyAgeClassItem *itemBrand = [[ToyAgeClassItem alloc]init];
                itemBrand.each_title = ageDic[@"each_title"];
                itemBrand.each_val = ageDic[@"each_val"];
                [_toys_brandArray addObject:itemBrand];
            }
            //解析综合排序
            NSArray *toyAllArray = self.toys_allDic[@"main_val"];
            _toys_allArray = [NSMutableArray array];
            for (NSDictionary *ageDic in toyAllArray) {
                ToyAgeClassItem *itemAll = [[ToyAgeClassItem alloc]init];
                itemAll.each_title = ageDic[@"each_title"];
                itemAll.each_val = ageDic[@"each_val"];
                [_toys_allArray addObject:itemAll];
            }
            //解析筛选的数组
            NSArray *toysSelectArray = self.toys_selectDic[@"main_val"];
            _toys_selectArray = [NSMutableArray array];
            for (NSDictionary *selectDic in toysSelectArray) {
                ToyAgeClassItem *itemSelect = [[ToyAgeClassItem alloc]init];
                itemSelect.each_title = selectDic[@"main_title_son"];
                itemSelect.main_val_sonArray = [NSArray array];
                itemSelect.main_val_sonArray = selectDic[@"main_val_son"];
                [_toys_selectArray addObject:itemSelect];

            }
            _toyAgeMainTitle = self.toysAgeDic[@"main_title"];
            _toys_brandMainTitle = self.toys_brandDic[@"main_title"];
            _toys_allMainTitle = self.toys_allDic[@"main_title"];
            _toys_selectMainTitle = self.toys_selectDic[@"main_title"];
            NSArray *chooseArray = [NSArray arrayWithObjects:_toyAgeMainTitle,_toys_brandMainTitle,_toys_allMainTitle,_toys_selectMainTitle, nil];
            for (int i = 0; i < chooseArray.count; i++) {
                UIButton *btn = [self.view viewWithTag:(4001+i)];
                NSString *title = chooseArray[i];
                
                [btn setTitle:title forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:12];
                btn.selected = NO;
                [btn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(changeClassifyDataBtn:) forControlEvents:UIControlEventTouchUpInside];
            }

        }
        
    } failed:^(NSError *error) {
        
    }];
}
#pragma mark 直接回收所有的筛选页面
-(void)hiddenAllClassifyView{
    //没有被选中
    _classifyChooseView.hidden = YES;
    _classifyGrayView.hidden = YES;
    for (int i = 0; i < 4; i++) {
        [_chooseBtnArray[i] setImage:[UIImage imageNamed:@"classifyToyUnselect@3x"] forState:UIControlStateNormal];
        [_chooseBtnArray[i] setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
        UIButton *btn = _chooseBtnArray[i];
        btn.selected = NO;
    }

}
#pragma mark 点击全部列表上面分类
-(void)changeClassifyDataBtn:(UIButton *)btn{
    btn.selected = !btn.selected;
    if (btn.selected == YES) {
        for (int i = 0; i < 4; i++) {
            if (i == btn.tag-4001) {
                [_chooseBtnArray[i] setImage:[UIImage imageNamed:@"classifyToySelect@3x"] forState:UIControlStateNormal];
                [_chooseBtnArray[i] setTitleColor: RGBACOLOR(253, 99, 99, 1) forState:UIControlStateNormal];
                btn.selected = YES;
                
            }else{
                [_chooseBtnArray[i] setImage:[UIImage imageNamed:@"classifyToyUnselect@3x"] forState:UIControlStateNormal];
                [_chooseBtnArray[i] setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
                btn.selected = NO;
            }
        }
        [self setAgeChooseViewTag:btn];

    }else{
        //没有被选中
        [self hiddenAllClassifyView];
    }

}
#pragma mark  全部年龄分类下面的弹窗
-(void)setAgeChooseViewTag:(UIButton*)btn{
    if (!_classifyChooseView) {
        _classifyChooseView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 200)];
        _classifyChooseView.backgroundColor = [UIColor whiteColor];
        [_classifyGrayView addSubview:_classifyChooseView];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [_classifyChooseView addSubview:lineView];
        
        _makeSureClassifyView = [[UIView alloc]initWithFrame:CGRectMake(0, 161, SCREEN_WIDTH, 40)];
        [_classifyChooseView addSubview:_makeSureClassifyView];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 2)];
        lineView1.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [_makeSureClassifyView addSubview:lineView1];
        
        _makeSureClassifyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _makeSureClassifyBtn.frame = CGRectMake((SCREEN_WIDTH-(0.225*SCREEN_WIDTH))/2, 10, 0.225*SCREEN_WIDTH, 20);
        _makeSureClassifyBtn.layer.masksToBounds = YES;
        _makeSureClassifyBtn.layer.cornerRadius = 10;
        _makeSureClassifyBtn.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
        [_makeSureClassifyBtn setTitle:@"确定" forState:UIControlStateNormal];
        _makeSureClassifyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [_makeSureClassifyBtn setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
        [_makeSureClassifyBtn addTarget:self action:@selector(getSearchResult:) forControlEvents:UIControlEventTouchUpInside];
        [_makeSureClassifyView addSubview:_makeSureClassifyBtn];
        
    }
    [self.view bringSubviewToFront:_classifyGrayView];
    //全部年龄
    _classifyGrayView.hidden = NO;
    _classifyChooseView.hidden = NO;
    //点击上面的筛选按钮时候，下面的按钮的变化
    for (int i = 0; i < 4; i++) {
        UIButton *btnTemp = _chooseBtnArray[i];
        if (btnTemp == btn) {
            btnTemp.selected = YES;
        }else{
            btnTemp.selected = NO;
        }
    }
    if (btn.tag == 4001) {
        [self setAgeBtnsView];
        _makeSureClassifyView.hidden = NO;
        _makeSureClassifyBtn.tag = 100;
        _classifyChooseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);
        

    }else if (btn.tag == 4002){
        [self setBrandBtnsView];
        _makeSureClassifyView.hidden = NO;
        _makeSureClassifyBtn.tag = 101;
        _classifyChooseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);


    }else if (btn.tag == 4003){
        [self setAllBtnsView];
        _makeSureClassifyView.hidden = YES;
        _makeSureClassifyBtn.tag = 102;
        
        _classifyAllChooseScrollView.frame =CGRectMake(0, 2, SCREENWIDTH,(_toys_allArray.count*34));
        _classifyChooseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, _toys_allArray.count*34);
        
    }else if (btn.tag == 4004){
        [self setSelectBtnsView];
        _makeSureClassifyView.hidden = NO;
        _makeSureClassifyBtn.tag = 103;
        _classifyChooseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 200);


    }
}
//全部年龄
-(void)setAgeBtnsView{
    if (!_classifyChooseScrollView) {
        _classifyChooseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 2, SCREENWIDTH,160)];
        _classifyChooseScrollView.alwaysBounceVertical = YES;
        _classifyChooseScrollView.backgroundColor = [UIColor whiteColor];
        [_classifyChooseView addSubview:_classifyChooseScrollView];
        for (int i = 0; i < _toysAgeArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((SCREEN_WIDTH/3)*(i%3)+0.05*SCREEN_WIDTH, (i/3)*34+7, 0.225*SCREEN_WIDTH, 20);
            btn.tag = 5001+i;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 10;
            if (i == 0) {
                btn.selected = YES;
                btn.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
                [btn setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];

            }else{
            btn.selected = NO;
                btn.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
                [btn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];


            }
            ToyAgeClassItem *itemAge = _toysAgeArray[i];
            NSString *btnTitle = itemAge.each_title;
            [btn setTitle:btnTitle forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            [btn addTarget:self action:@selector(ageConditionSelect:) forControlEvents:UIControlEventTouchUpInside];
            [_classifyChooseScrollView addSubview:btn];
        }
        _classifyChooseScrollView.contentSize = CGSizeMake(SCREENWIDTH, ((_toysAgeArray.count/3)*34)+34);
    }
    
    _classifyBrandChooseScrollView.hidden = YES;
    _classifySelectChooseScrollView.hidden = YES;
    _classifyAllChooseScrollView.hidden = YES;
    _classifyChooseScrollView.hidden = NO;
    
}
-(void)ageConditionSelect:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.tag == 5001) {
        for (int i = 0; i < _toysAgeArray.count; i++) {
            UIButton *btn = [self.view viewWithTag:5001+i];
            if (i == 0) {
                btn.selected = YES;
                [self hiddenAllClassifyView];
                _post_create_timeToy = NULL;
                [_ageSelectedArray removeAllObjects];
                [_ageSelectedBtnArray removeAllObjects];
                
                [self getToyListData:1];
                btn.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
                [btn setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
                
            }else{
                [_ageSelectedBtnArray removeObject:btn];
                btn.selected = NO;
                btn.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
                [btn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
            }
        }
    }else{
        for (int i = 0; i < _toysAgeArray.count; i++) {
            UIButton *btn = [self.view viewWithTag:5001+i];
            if (i == 0) {
                btn.selected = NO;
                [_ageSelectedBtnArray removeAllObjects];
                btn.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
                [btn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
            }else{
                if (btn.selected == YES) {
                    [_ageSelectedBtnArray addObject:btn];
                    btn.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
                    [btn setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
                }else{
                    [_ageSelectedBtnArray removeObject:btn];
                    btn.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
                    [btn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
                }

                
            }
        }
        
    }
    if (_ageSelectedBtnArray.count == 0) {
        UIButton *btn = [self.view viewWithTag:5001];
        btn.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
        [btn setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
    }
    NSLog(@"_ageselectedarray = %@",_ageSelectedBtnArray);
    
    }
#pragma mark 品牌的筛选及点击事件
-(void)setBrandBtnsView{
    if (!_classifyBrandChooseScrollView) {
        _classifyBrandChooseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,2, SCREENWIDTH,160)];
        _classifyBrandChooseScrollView.alwaysBounceVertical = YES;
        _classifyBrandChooseScrollView.backgroundColor = [UIColor whiteColor];
        [_classifyChooseView addSubview:_classifyBrandChooseScrollView];
        NSArray *arrayMakeArray = [NSArray array];
        arrayMakeArray = [_classfyMakeString componentsSeparatedByString:@","];
        NSLog(@"fffffff = %@",arrayMakeArray);
        for (int i = 0; i < _toys_brandArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((SCREEN_WIDTH/3)*(i%3)+0.05*SCREEN_WIDTH, (i/3)*34+7, 0.225*SCREEN_WIDTH, 20);
            btn.tag = 6001+i;
            btn.layer.masksToBounds = YES;
            btn.layer.cornerRadius = 10;
            ToyAgeClassItem *itemAge = _toys_brandArray[i];
            NSString *btnTitle = itemAge.each_title;
            if (_classfyMakeString.length > 0) {
                for (int j = 0; j < arrayMakeArray.count; j++) {
                    NSString *selectTitle = [arrayMakeArray objectAtIndex:j];
                    NSLog(@"sellecttitle = %@",selectTitle);
                    if ([selectTitle isEqualToString:btnTitle]) {
                        btn.selected = YES;
                        btn.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
                        [btn setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
                        
                    }                }
 
            }else{
            
            if (i == 0) {
                btn.selected = YES;
                btn.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
                [btn setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];

            }else{
                btn.selected = NO;
                btn.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
                [btn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
            }
            }
            [btn addTarget:self action:@selector(brandConditionSelect:) forControlEvents:UIControlEventTouchUpInside];
            [btn setTitle:btnTitle forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:10];

            [_classifyBrandChooseScrollView addSubview:btn];
        }
        _classifyBrandChooseScrollView.contentSize = CGSizeMake(SCREENWIDTH, ((_toys_brandArray.count/3)*34)+34);
    }
    _classifyBrandChooseScrollView.hidden = NO;
    _classifySelectChooseScrollView.hidden = YES;
    _classifyAllChooseScrollView.hidden = YES;
    _classifyChooseScrollView.hidden = YES;

}
-(void)brandConditionSelect:(UIButton*)sender{
    sender.selected = !sender.selected;
    if (sender.tag == 6001) {
        for (int i = 0; i < _toys_brandArray.count; i++) {
            UIButton *btn = [self.view viewWithTag:6001+i];
            if (i == 0) {
                btn.selected = YES;
                [self hiddenAllClassifyView];
                _post_create_timeToy = NULL;
                [_brandSelectedArray removeAllObjects];
                [_brandSelectedBtnArray removeAllObjects];
                [self getToyListData:2];
                btn.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
                [btn setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
                
            }else{
                [_brandSelectedBtnArray removeObject:btn];
                btn.selected = NO;
                btn.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
                [btn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
            }
        }
    }else{
        for (int i = 0; i < _toys_brandArray.count; i++) {
            UIButton *btn = [self.view viewWithTag:6001+i];
            if (i == 0) {
                btn.selected = NO;
                [_brandSelectedBtnArray removeAllObjects];
                btn.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
                [btn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
            }else{
                if (btn.selected == YES) {
                    [_brandSelectedBtnArray addObject:btn];
                    btn.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
                    [btn setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
                }else{
                    [_brandSelectedBtnArray removeObject:btn];
                    btn.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
                    [btn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
                }
                
                
            }
        }
        
    }
    if (_brandSelectedBtnArray.count == 0) {
        UIButton *btn = [self.view viewWithTag:6001];
        btn.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
        [btn setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
    }

    
}
#pragma mark  综合排序及点击事件
-(void)setAllBtnsView{
    if (!_classifyAllChooseScrollView) {
        _classifyAllChooseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 2, SCREENWIDTH,160)];
        _classifyAllChooseScrollView.alwaysBounceVertical = YES;
        _classifyAllChooseScrollView.backgroundColor = [UIColor whiteColor];
        [_classifyChooseView addSubview:_classifyAllChooseScrollView];
        for (int i = 0; i < _toys_allArray.count; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((SCREENWIDTH-200)/2, i*34+6, 200, 20);
            btn.tag = 7001+i;
            if (i == 0) {
                btn.selected = YES;
                [btn setTitleColor:[BBSColor hexStringToColor:@"fd6363"] forState:UIControlStateNormal];
            }else{
                btn.selected = NO;
                [btn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
            }
            ToyAgeClassItem *itemAge = _toys_allArray[i];
            NSString *btnTitle = itemAge.each_title;
            [btn setTitle:btnTitle forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:10];
            [_classifyAllChooseScrollView addSubview:btn];
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, (i+1)*34, SCREENWIDTH, 1)];
            lineView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
            [_classifyAllChooseScrollView addSubview:lineView];
            [btn addTarget:self action:@selector(allConditionSelect:) forControlEvents:UIControlEventTouchUpInside];
        }
        _classifyAllChooseScrollView.contentSize = CGSizeMake(SCREENWIDTH, (_toys_allArray.count*34));
    }
    _classifyBrandChooseScrollView.hidden = YES;
    _classifySelectChooseScrollView.hidden = YES;
    _classifyAllChooseScrollView.hidden = NO;
    _classifyChooseScrollView.hidden = YES;

}
-(void)allConditionSelect:(UIButton*)btn{
    for (int i = 0; i < _toys_allArray.count; i++) {
        ToyAgeClassItem *itemAge = _toys_allArray[i];
        NSString *btnTitle = itemAge.each_title;
        NSString *btnValue = itemAge.each_val;
        UIButton *tempBtn = [self.view viewWithTag:7001+i];
        if (tempBtn == btn){
            tempBtn.selected = YES;
            [tempBtn setTitleColor:[BBSColor hexStringToColor:@"fd6363"] forState:UIControlStateNormal];
            [self hiddenAllClassifyView];
            _post_create_timeToy = NULL;
            _allSelectedString = btnTitle;
            _hotToy = btnValue;
            [self getToyListData:1];

        }else{
            tempBtn.selected = NO;
            [tempBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];

        }
    }
}
#pragma mark 筛选及其点击事件
-(void)setSelectBtnsView{
    if (!_classifySelectChooseScrollView) {
        _classifySelectChooseScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 2, SCREENWIDTH,160)];
        _classifySelectChooseScrollView.alwaysBounceVertical = YES;
        _classifySelectChooseScrollView.backgroundColor = [UIColor whiteColor];
        [_classifyChooseView addSubview:_classifySelectChooseScrollView];
        float height = 0.0;
        for (int i = 0; i < _toys_selectArray.count; i++) {
            ToyAgeClassItem *itemAge = _toys_selectArray[i];
            UIView *selectView = [[UIView alloc]initWithFrame:CGRectMake(0, height, 0, 0)];
            [_classifySelectChooseScrollView addSubview:selectView];
            selectView.tag = 310+i;
       
            UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 3, 15)];
            img.image = [UIImage imageNamed:@"ToyFirstMark1"];
            [selectView addSubview:img];
            UILabel *typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 10, 300, 14)];
            typeLabel.textColor = RGBACOLOR(153, 153, 153, 1);
            typeLabel.font = [UIFont systemFontOfSize:12];
            typeLabel.text = itemAge.each_title;
            [selectView addSubview:typeLabel];
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((SCREEN_WIDTH/4)*3, 0, SCREEN_WIDTH/4, 34);
            [btn setImageEdgeInsets:UIEdgeInsetsMake(2, 50,2, 15)];
            [btn setImage:[UIImage imageNamed:@"classifyToyUnselect@3x"] forState:UIControlStateNormal];
            [selectView addSubview:btn];
            btn.tag = 8001+i;
            btn.selected = NO;
            [btn addTarget:self action:@selector(openOrCloseType:) forControlEvents:UIControlEventTouchUpInside];
            
            if (itemAge.main_val_sonArray.count < 3) {
                selectView.frame = CGRectMake(0, height, SCREEN_WIDTH, 68);
                height += 68;
                btn.hidden = YES;
            }else if (itemAge.main_val_sonArray.count > 3 && itemAge.main_val_sonArray.count <= 6){
                selectView.frame = CGRectMake(0, height, SCREEN_WIDTH, 68+34);
                height += 102;
                btn.hidden = NO;
                
            }else{
                 selectView.frame = CGRectMake(0, height, SCREEN_WIDTH, 68+34);
                height += 102;
                btn.hidden = NO;
            }
            for (int j = 0; j < itemAge.main_val_sonArray.count; j++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.frame = CGRectMake((SCREEN_WIDTH/3)*(j%3)+0.05*SCREEN_WIDTH, (j/3)*34+7+34, SCREEN_WIDTH*0.225, 20);
                btn.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
                [selectView addSubview:btn];
                NSDictionary *itemSelect = itemAge.main_val_sonArray[j];
                NSString *btnTitle = itemSelect[@"each_title_son"];
                [btn setTitle:btnTitle forState:UIControlStateNormal];
                btn.layer.masksToBounds = YES;
                btn.layer.cornerRadius = 10;
                btn.titleLabel.font = [UIFont systemFontOfSize:10];
                [btn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
                btn.tag = (i+1)*10000+j;
                btn.selected = NO;
                
                
                if (j>5) {
                    btn.hidden = YES;
                }
                [btn addTarget:self action:@selector(chooseConditionSelect:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
                _classifySelectChooseScrollView.contentSize = CGSizeMake(SCREENWIDTH, height+34);

    }
    _classifyBrandChooseScrollView.hidden = YES;
    _classifySelectChooseScrollView.hidden = NO;
    _classifyAllChooseScrollView.hidden = YES;
    _classifyChooseScrollView.hidden = YES;

}
-(void)chooseConditionSelect:(UIButton*)btn{

    btn.selected = !btn.selected;
    NSInteger btnSup = (btn.tag/10000)-1;
    NSInteger btnSon = btn.tag-((btnSup+1)*10000);
    ToyAgeClassItem *itemAge = _toys_selectArray[btnSup];
    NSDictionary *itemSelect = itemAge.main_val_sonArray[btnSon];
    NSString *chooseSelectString = itemSelect[@"each_val_son"];
    if (btn.selected == YES) {
        btn.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
        [btn setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
      }else{
    btn.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [btn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
    }
    
    
}
#pragma mark 点击筛选下面的展开按钮
-(void)openOrCloseType:(UIButton*)sender{
    for (int i = 0; i < _toys_selectArray.count; i++) {
        if (i == sender.tag-8001) {
            sender.selected = !sender.selected;
            //如果被选中，展开
            if (sender.selected == YES) {
                NSLog(@"ddjjdjdj 展开展开");
                UIView *selectView = [sender superview];
                ToyAgeClassItem *itemAge = _toys_selectArray[i];
                NSInteger count = itemAge.main_val_sonArray.count/3;
                if (itemAge.main_val_sonArray.count%3 > 0 ) {
                    count = count+1;
                }
                selectView.frame = CGRectMake(selectView.frame.origin.x, selectView.frame.origin.y, SCREEN_WIDTH, count*34+34);
                for (UIView *btn in selectView.subviews) {
                    btn.hidden = NO;
                }
                [sender setImage:[UIImage imageNamed:@"classifyToySelect"] forState:UIControlStateNormal];

            }else{
                //收起
                //[sender setImage:[UIImage imageNamed:@"classifyToyUnselect@3x"] forState:UIControlStateNormal];
                UIView *selectView = [sender superview];
                ToyAgeClassItem *itemAge = _toys_selectArray[i];
                selectView.frame = CGRectMake(selectView.frame.origin.x, selectView.frame.origin.y, SCREEN_WIDTH, 68+34);
                for (UIView *btn in selectView.subviews) {
                    NSInteger btnSup = (btn.tag/10000)-1;
                    NSInteger btnSon;
                    if (btnSup < 0) {
                        btnSon = 1;
                    }else{
                      btnSon = btn.tag-((btnSup+1)*10000);
                    }
                    if (btnSon > 5) {
                        btn.hidden = YES;
                    }else{
                        btn.hidden = NO;
                    }
                }
                NSLog(@"ffffffffffff");
                [sender setImage:[UIImage imageNamed:@"classifyToyUnselect@3x"] forState:UIControlStateNormal];
                
                
 
            }
        }
    }
     [self changeSelectView];
    
}
-(void)changeSelectView{
    float height= 0;
    float everyHeight = 0.0;
    for (int i = 0; i < _toys_selectArray.count; i++) {
        UIView *selectView = [self.view viewWithTag:(310+i)];
        selectView.frame = CGRectMake(0, everyHeight, SCREEN_WIDTH, selectView.frame.size.height);
        everyHeight += selectView.frame.size.height;

        if (i == _toys_selectArray.count-1) {
            height = selectView.frame.origin.y+selectView.frame.size.height+34;
        }
        
    }
    _classifySelectChooseScrollView.contentSize = CGSizeMake(SCREENWIDTH,height +34);
}
#pragma mark  点击确定的时候的搜索结果
-(void)getSearchResult:(UIButton*)sender{
    [self hiddenAllClassifyView];
    _post_create_timeToy = NULL;
    
    if (sender.tag == 100) {
        //年龄
        [_ageSelectedArray removeAllObjects];
        for (int i = 0; i < _toysAgeArray.count; i++) {
            UIButton *btn = [self.view viewWithTag:5001+i];
            ToyAgeClassItem *itemAge = _toysAgeArray[i];
            NSString *btnTitle = itemAge.each_title;
            
            if (btn.selected == YES) {
                [_ageSelectedArray addObject:btnTitle];
            }else{
                [_ageSelectedArray removeObject:btnTitle];
            }
        }
        [self getToyListData:1];
        
    }else if(sender.tag == 101){
        //品牌
        [_brandSelectedArray removeAllObjects];
        for (int i = 0; i < _toys_brandArray.count; i++) {
            UIButton *btn = [self.view viewWithTag:6001+i];
            ToyAgeClassItem *itemAge = _toys_brandArray[i];
            NSString *btnTitle = itemAge.each_title;
            if (btn.selected == YES) {
                [_brandSelectedArray addObject:btnTitle];
            }else{
                [_brandSelectedArray removeObject:btnTitle];
            }
        }
        [self getToyListData:2];
    }else if (sender.tag == 102){
        //排序
        [self getToyListData:3];
        
    }else if(sender.tag == 103){
        //筛选
        [_chooseSelectedArray removeAllObjects];
        [_chooseSelectedNameArray removeAllObjects];
        for (int i = 0; i < _toys_selectArray.count; i++) {
            ToyAgeClassItem *itemAge = _toys_selectArray[i];
            for (int j = 0; j < itemAge.main_val_sonArray.count ; j++) {
                UIButton *btn = [self.view viewWithTag:((i+1)*10000+j)];
                NSDictionary *itemSelect = itemAge.main_val_sonArray[j];
                NSString *chooseString = itemSelect[@"each_val_son"];
                NSString *chooseNameString = itemSelect[@"each_title_son"];
                if (btn.selected == YES) {
                    [_chooseSelectedArray addObject:chooseString];
                    [_chooseSelectedNameArray addObject:chooseNameString];
                }else{
                    [_chooseSelectedArray removeObject:chooseString];
                    [_chooseSelectedNameArray removeObject:chooseNameString];
                }
            }
        }
        [self getToyListData:4];
        
    }
}

#pragma mark ----------------------------------全部页面头部结束--------------------------------
#pragma mark 全部玩具的列表
-(void)setCollectionViewLay{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置headerView的尺寸大小
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    //layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100);
    //layout.itemSize = CGSizeMake(SCREEN_WIDTH/2, 1.19*SCREEN_WIDTH/2);
    CGRect userFram = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - IPhoneXSafeHeight-46);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _collectionView = [[UICollectionView alloc]initWithFrame:userFram collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.hidden = YES;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
    
    //_collectionView.estimatedRowHeight = 0;
    //_collectionView.estimatedSectionHeaderHeight = 0;
    //_collectionView.estimatedSectionFooterHeight = 0;
    
    [self.view addSubview:_collectionView];
   // [_collectionView registerClass:[ToyAllListCell class] forCellWithReuseIdentifier:@"ToyAllListCell"];
}
#pragma mark 购物车里面的玩具数量
-(void)getToyCarCount{
    NSDictionary *param = [NSDictionary dictionaryWithObject:LOGIN_USER_ID forKey:@"login_user_id"];
    [[HTTPClient sharedClient]getNewV1:@"getToysCartNumber" params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = result[@"data"];
            NSString *toyCount = data[@"cart_number"];
            if ([toyCount isEqualToString:@"0"]) {
                _badgeValueLabel.hidden = YES;
            }else{
                _badgeValueLabel.hidden = NO;
                _badgeValueLabel.text = toyCount;
            }
        }
    } failed:^(NSError *error) {
        
    }];
}
#pragma mark 大家最近在搜什么
-(void)getDataSearchWord{
    NSDictionary *param = [NSDictionary dictionaryWithObject:LOGIN_USER_ID forKey:@"login_user_id"];
    [[HTTPClient sharedClient]getNewV1:@"toySearchTips" params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = result[@"data"];
            self.searchWordAlert = data[@"search_name"];
            [searchBtn setTitle:self.searchWordAlert forState:UIControlStateNormal];
        }
    } failed:^(NSError *error) {
    }];
}
#pragma mark 搜索玩具按钮
-(void)setSearchBar{
    self.navSearchView = [[UIView alloc]init];
    if (ISIPhoneX ) {
        self.navSearchView.frame = CGRectMake(0, 20, SCREEN_WIDTH, 44+12);
    }else{
        self.navSearchView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44+12);

    }
//WithFrame:CGRectMake(0,20, SCREENWIDTH, 44+12)];
    self.navSearchView.backgroundColor = [BBSColor hexStringToColor:@"ffffff" alpha:0];
    [self.view addSubview:self.navSearchView];
    
    CGRect backBtnFrame = CGRectMake(10, 12+18, 30, 17);
    _backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.adjustsImageWhenHighlighted = NO;
    [_backBtn setImage:[UIImage imageNamed:@"btn_toy_detail_back"] forState:UIControlStateNormal];
    [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    [self.navSearchView addSubview:_backBtn];
    
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navSearchView addSubview:searchBtn];
    [searchBtn setBackgroundImage:nil forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(33, 12+13, SCREENWIDTH-33-40, 25);
    searchBtn.backgroundColor = [BBSColor hexStringToColor:@"ededed" alpha:0.65];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 12;
    [searchBtn setTitle:@"" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    //[searchBtn setImage:[UIImage imageNamed:@"btn_baby_show_search"] forState:UIControlStateNormal];
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(1, 10,1, 0)];
    [searchBtn addTarget:self action:@selector(pushSearchView) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [[HTTPClient sharedClient]getNewV1:@"GetToysIcon" params:@{@"login_user_id":LOGIN_USER_ID} success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = result[@"data"];
            NSString *img = data[@"icon_img"];
            NSURL *url = [NSURL URLWithString:img];
            _shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            
            [shareBtn setBackgroundImage:_shareImg forState:UIControlStateNormal];
            CGFloat weight;
            if (_shareImg == nil) {
                weight = 53;
            }else{
                weight = _shareImg.size.width/_shareImg.size.height*40;

            }
            shareBtn.frame = CGRectMake(SCREENWIDTH-weight, 17, weight, 40);
            [shareBtn addTarget:self action:@selector(getAskPage) forControlEvents:UIControlEventTouchUpInside];
            [self.navSearchView addSubview:shareBtn];

        }
    } failed:^(NSError *error) {
    }];
}
#pragma mark KVC回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        if (offset.y < StatusAndNavBar_HEIGHT ) {
            self.navSearchView.backgroundColor = [BBSColor hexStringToColor:@"ffffff" alpha:0];
        } else  if(offset.y >= StatusAndNavBar_HEIGHT) {
            self.navSearchView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5" alpha:1];
        }
    }
    
}

#pragma mark - UISearchBarDelegate Methods搜索
-(void)pushSearchView{
    ToySearchVC *toySearchVC = [[ToySearchVC alloc]init];
    [self.navigationController pushViewController:toySearchVC animated:NO];
}

#pragma mark  底部按钮，结算状态下面的按钮
-(void)setBottomView{
    //底部合计金额的页面
    self.payToys = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-StatusAndNavBar_HEIGHT - IPhoneXSafeHeight-46-50, SCREENWIDTH, 50)];
    self.payToys.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.payToys];
    
    self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payBtn.frame = CGRectMake(SCREENWIDTH-92, 3, 86, 44);
    [self.payToys addSubview:self.payBtn];
    self.totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 30)];
    self.totalLabel.font = [UIFont systemFontOfSize:14];
    self.totalLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    [self.payToys addSubview:self.totalLabel];
    
    self.totalMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.totalLabel.frame.origin.x+self.totalLabel.frame.size.width-15, 10, 185, 30)];
    self.totalMoneyLabel.textColor = [BBSColor hexStringToColor:@"fd6363"];
    self.totalMoneyLabel.textAlignment = NSTextAlignmentLeft;
    self.totalMoneyLabel.font = [UIFont systemFontOfSize:15];
    [self.payToys addSubview:self.totalMoneyLabel];
    self.payToys.hidden = YES;
    
    if (!_hideBottomTab) {
        
        btnView = [[UIView alloc]init];
        if (_inTheViewData == 2001 || _inTheViewData == 2002) {
            btnView.frame = CGRectMake(0,  SCREENHEIGHT- IPhoneXSafeHeight-49 , SCREENWIDTH,49);
        }else{
            btnView.frame = CGRectMake(0,  SCREENHEIGHT-StatusAndNavBar_HEIGHT - IPhoneXSafeHeight-46 , SCREENWIDTH,46);
        }
        btnView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:btnView];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [btnView addSubview:lineView];
        //首页
        firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        firstBtn.frame = CGRectMake(0, 2, SCREENWIDTH/4, 40);
        [firstBtn setImage:[UIImage imageNamed:@"firtst_select"] forState:UIControlStateNormal];
        firstBtn.tag = 2001;
        [btnView addSubview:firstBtn];
        [firstBtn addTarget:self action:@selector(changeDataWithTag:) forControlEvents:UIControlEventTouchUpInside];
        //全部
        secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        secondBtn.frame = CGRectMake(SCREENWIDTH/4, 2, SCREENWIDTH/4, 40);
        [secondBtn setImage:[UIImage imageNamed:@"all_unselect"] forState:UIControlStateNormal];
        [btnView addSubview:secondBtn];
        secondBtn.tag = 2002;
        [secondBtn addTarget:self action:@selector(changeDataWithTag:) forControlEvents:UIControlEventTouchUpInside];
        //购物车
        fourBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fourBtn.frame = CGRectMake(SCREENWIDTH*2/4, 2, SCREENWIDTH/4, 40);
        [fourBtn setImage:[UIImage imageNamed:@"car_unselect"] forState:UIControlStateNormal];
        [btnView addSubview:fourBtn];
        fourBtn.tag = 2004;
        [fourBtn addTarget:self action:@selector(changeDataWithTag:) forControlEvents:UIControlEventTouchUpInside];
        
        //购物车的数量的label
        _badgeValueLabel=[[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH*2/4+48, 0, 20, 20)];
        _badgeValueLabel.backgroundColor=[BBSColor hexStringToColor:@"FF7F7C"];
        _badgeValueLabel.textColor=[UIColor whiteColor];
        _badgeValueLabel.font=[UIFont systemFontOfSize:10];
        _badgeValueLabel.textAlignment=NSTextAlignmentCenter;
        _badgeValueLabel.text=@"";
        _badgeValueLabel.layer.masksToBounds=YES;
        _badgeValueLabel.layer.cornerRadius=10;
        [btnView addSubview:_badgeValueLabel];
        _badgeValueLabel.hidden = YES;

        //订单
        thridBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        thridBtn.frame = CGRectMake(SCREENWIDTH*3/4,2, SCREENWIDTH/4, 40);
        [thridBtn setImage:[UIImage imageNamed:@"order_unselect"] forState:UIControlStateNormal];
        [btnView addSubview:thridBtn];
        thridBtn.tag = 2003;
        [thridBtn addTarget:self action:@selector(changeDataWithTag:) forControlEvents:UIControlEventTouchUpInside];
    }
    [self changeFrameAndSearchBarHidden];
    [self setDeleteButtons];
}
#pragma mark 删除状态下面的按钮
-(void)setDeleteButtons{
    //删除购物车的按钮，最开始状态是隐藏的
    self.deleteToyCar = [YLButton buttonWithFrame: CGRectMake(SCREENWIDTH-92, 3, 86, 44) type:UIButtonTypeCustom backImage:[UIImage imageNamed:@"toy_delete_toy_car"] target:self action:@selector(deleteSureToyCar) forControlEvents:UIControlEventTouchUpInside];
    [self.payToys addSubview:self.deleteToyCar];
    self.deleteToyCar.hidden = YES;
    
    self.selectAllBtn = [YLButton buttonWithFrame:CGRectMake(10, 10, 80, 30) type:UIButtonTypeCustom backImage:[UIImage imageNamed:@"toy_car_buy_unselect"] target:self action:@selector(selectAllToyToDelete) forControlEvents:UIControlEventTouchUpInside];
    [self.selectAllBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0,30 )];
    [self.selectAllBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 20)];
    [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.selectAllBtn.hidden = YES;
    [self.payToys addSubview:self.selectAllBtn];
 
}
-(void)setRightBtn{
        rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
   _iconBgView = [[UIView alloc]
                          init];
    [[HTTPClient sharedClient]getNewV1:@"GetToysIcon" params:@{@"login_user_id":LOGIN_USER_ID} success:^(NSDictionary *result) {
            if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                NSDictionary *data = result[@"data"];
                NSString *img = data[@"icon_img"];
                NSURL *url = [NSURL URLWithString:img];
                _shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];

                [rightBtn setBackgroundImage:_shareImg forState:UIControlStateNormal];
                CGFloat weight;
                if (_shareImg == nil) {
                    weight = 53;
                }else{
                   weight  = _shareImg.size.width/_shareImg.size.height*40;
                }
                
                _iconBgView.frame =CGRectMake(SCREENWIDTH-weight, 17, weight, 40);
                rightBtn.frame = CGRectMake(0, 0, weight, 40);
                [_iconBgView addSubview:rightBtn];
                
            }
        } failed:^(NSError *error) {
        }];
        [rightBtn addTarget:self action:@selector(getAskPage) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.adjustsImageWhenHighlighted = NO;
        
        _right = [[UIBarButtonItem alloc]initWithCustomView:_iconBgView];
        self.navigationItem.rightBarButtonItem = _right;

    
    _editBtn = [YLButton buttonWithFrame:CGRectMake(SCREENWIDTH-40, 0, 30, 22) type:UIButtonTypeCustom backImage:nil target:self action:@selector(getAskPage) forControlEvents:UIControlEventTouchUpInside];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
    
    
}
#pragma mark 邀请好友
-(void)requestFriendShare{
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
        return;
    }else{
        ToyShareNewVC *toyShareVC = [[ToyShareNewVC alloc]init];
        [self.navigationController pushViewController:toyShareVC animated:YES];
    }

}
-(void)getAskPage{
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
        return;
    }else{
        if (_inTheViewData == 2004) {
            _isEditSelect = !_isEditSelect;
            if (_isEditSelect == YES) {
                [self deleteCarToy];
            }else{
                [self completeDeleteToy];
            }
            
        }else{
        ToyShareNewVC *toyShareVC = [[ToyShareNewVC alloc]init];
        [self.navigationController pushViewController:toyShareVC animated:YES];
        }
    }

}
#pragma mark 删除状态下里面的玩具
-(void)deleteCarToy{
    [_editBtn setTitle:@"完成" forState:UIControlStateNormal];
    _isDeleteToyCar = YES;
    _isEditSelect = YES;
    _deleteToyCar.hidden = NO;
    _selectAllBtn.hidden = NO;
    self.payBtn.hidden = YES;
    self.totalLabel.hidden = YES;
    [_tableView reloadData];
    self.totalMoneyLabel.hidden = YES;
    
}
#pragma mark 完成状态下的购物车玩具
-(void)completeDeleteToy{
    _isDeleteToyCar = NO;
    _isEditSelect = NO;
    _deleteToyCar.hidden = YES;
    _selectAllBtn.hidden = YES;
    _isSelectAll = NO;
    self.payBtn.hidden = NO;
    self.totalLabel.hidden = NO;
    self.totalMoneyLabel.hidden = NO;
     [_tableView reloadData];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    if (_isSelectAll == NO) {
        [self.selectAllBtn setImage:[UIImage imageNamed:@"toy_car_buy_unselect"] forState:UIControlStateNormal];
    }

}

#pragma mark  确定删除某个玩具或全选删除
-(void)deleteSureToyCar{
    if (_isSelectAll == YES) {
        //删除全部
        _carWay = @"1";
        [self deleteAlertViewToyCar];
    }else{
        if (_deleteArray.count<=0) {
            [BBSAlert showAlertWithContent:@"您还没选择要删除的玩具哦" andDelegate:self];
        }else{
            
            NSString *cardString = [_deleteArray componentsJoinedByString:@","];
            [self deleteAlertViewToyCar];
            _carWay = @"0";
            _cardsString = cardString;
        }
    }
    
}
#pragma mark 点击删除时全选的tableview变化
-(void)selectAllToyToDelete{
    _isSelectAll = !_isSelectAll;
    if (_isSelectAll == YES) {
        [self.selectAllBtn setImage:[UIImage imageNamed:@"toy_car_buy_select"] forState:UIControlStateNormal];
        [_tableView reloadData];
    }else{
        [self.selectAllBtn setImage:[UIImage imageNamed:@"toy_car_buy_unselect"] forState:UIControlStateNormal];
        [_tableView reloadData];
    }
}
#pragma mark 购物车删除最后接口，如果是1的话就是全选，如果是0的话是部分
-(void)deleteAlertViewToyCar{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确认删除玩具" preferredStyle:UIAlertControllerStyleAlert];
        __weak ToyLeaseNewVC *babyVC = self;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [babyVC deleteToyCarAllSure];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确认删除玩具" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
        alertView.tag = 103;
        [alertView show];
    }
}
-(void)deleteToyCarAllSure{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:LOGIN_USER_ID forKey:@"login_user_id"];
    if ([_carWay isEqualToString:@"1"]) {
      [param setObject:@"1" forKey:@"way"];
    }else{
      [param setObject:@"0" forKey:@"way"];
      [param setObject:_cardsString forKey:@"cart_ids"];
    }
    [[HTTPClient sharedClient]postNewV1:@"ToysCartDel" params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSLog(@"result = %@",result);
            NSDictionary *dataDic = result[@"data"];
            NSString *cartCount = dataDic[@"cart_count"];
            if ([cartCount isEqualToString:@"0"]) {
                [self completeDeleteToy];
            }
            _post_create_carToy = NULL;
            [self getToyCarListData];
            [_tableView reloadData];
            [self getToyCarCount];
            [_deleteArray removeAllObjects];
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
 
    }];
}

-(void)setBackButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 50, 17);
    _backBtnInToyCarAndOrder = [UIButton buttonWithType:UIButtonTypeCustom];
    _backBtnInToyCarAndOrder.adjustsImageWhenHighlighted = NO;
    [_backBtnInToyCarAndOrder setImage:[UIImage imageNamed:@"btn_toy_detail_back"] forState:UIControlStateNormal];
    [_backBtnInToyCarAndOrder setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [_backBtnInToyCarAndOrder addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtnInToyCarAndOrder.frame = backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtnInToyCarAndOrder];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)setOrderBannerHead{
    orderHeadView = [[UIView alloc]init];
    orderHeadView.frame = CGRectMake(0, 0, SCREENWIDTH, 0.787*(SCREENWIDTH/4)+11);
    _orderHeadScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 1, SCREENWIDTH ,75)];
    _orderHeadScrollView.backgroundColor=[UIColor clearColor];
    _orderHeadScrollView.bounces=NO;
    _orderHeadScrollView.pagingEnabled=YES;
    _orderHeadScrollView.showsVerticalScrollIndicator = NO;
    _orderHeadScrollView.showsHorizontalScrollIndicator=NO;  //控制是否显示水平方向的滚动条, 默认显示
    _orderHeadScrollView.delegate=self;
    _orderHeadScrollView.contentSize=CGSizeMake(SCREENWIDTH, _orderHeadScrollView.frame.size.height);
    [orderHeadView addSubview:_orderHeadScrollView];
    
    myCardBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    myCardBtn.frame = CGRectMake(0, 0, SCREENWIDTH/4+1, 0.787*(SCREENWIDTH/4));
       [myCardBtn setImage:[UIImage imageNamed:@"myCardBtn"] forState:UIControlStateNormal];
    [_orderHeadScrollView addSubview:myCardBtn];
    myCardBtn.adjustsImageWhenHighlighted = NO;
    
    myDepositBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    myDepositBtn.frame = CGRectMake(SCREENWIDTH/4, 0, SCREENWIDTH/4,0.787*(SCREENWIDTH/4));
    [myDepositBtn setImage:[UIImage imageNamed:@"myDepositBtn"] forState:UIControlStateNormal];
    [_orderHeadScrollView addSubview:myDepositBtn];
    myDepositBtn.adjustsImageWhenHighlighted = NO;
    
    myAppointmentBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    myAppointmentBtn.frame = CGRectMake(SCREENWIDTH/2, 0, SCREENWIDTH/4+1, 0.787*(SCREENWIDTH/4));
    [myAppointmentBtn setImage:[UIImage imageNamed:@"myAppointmentBtn"] forState:UIControlStateNormal];
    [_orderHeadScrollView addSubview:myAppointmentBtn];
    myAppointmentBtn.adjustsImageWhenHighlighted = NO;
    
    
    mySaveBtn =  [UIButton buttonWithType:UIButtonTypeCustom];
    mySaveBtn.frame = CGRectMake(SCREENWIDTH*3/4, 0, SCREENWIDTH/4, 0.787*(SCREENWIDTH/4));
    [mySaveBtn setImage:[UIImage imageNamed:@"mySaveBtn"] forState:UIControlStateNormal];
    //myCardBtn.backgroundColor = [UIColor redColor];
    [_orderHeadScrollView addSubview:mySaveBtn];
    mySaveBtn.adjustsImageWhenHighlighted = NO;

    
}
-(void)setBannerHead{
    _bannerView = [[UIView alloc]init];
    if (ISIPhoneX == YES) {
        _bannerView.frame =  CGRectMake(0, 0, SCREENWIDTH, 216+SCREEN_WIDTH*0.15+20+20);
    }else{
        _bannerView.frame =  CGRectMake(0, 0, SCREENWIDTH, 216+SCREEN_WIDTH*0.15+20-13);
    }
   // _bannerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 216+SCREEN_WIDTH*0.15+20)];
    //轮播图布局
    _topNewScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH ,SCREENWIDTH*0.47+50)];
    _topNewScrollView.backgroundColor=[UIColor clearColor];
    _topNewScrollView.bounces=NO;
    _topNewScrollView.pagingEnabled=YES;
    _topNewScrollView.showsVerticalScrollIndicator = NO;
    _topNewScrollView.showsHorizontalScrollIndicator=NO;  //控制是否显示水平方向的滚动条, 默认显示
    _topNewScrollView.delegate=self;
    _topNewScrollView.contentSize=CGSizeMake(SCREENWIDTH*_bannerArray.count, _topNewScrollView.frame.size.height);
    [_bannerView addSubview:_topNewScrollView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.47+20, SCREENWIDTH, 1)];
    lineView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
    [_bannerView addSubview:lineView];
    
    _CardScrollView=[[UIScrollView alloc]init];//WithFrame:CGRectMake(0,SCREENWIDTH*0.47+1+20, SCREENWIDTH ,216+0.15*SCREEN_WIDTH-SCREENWIDTH*0.47-2-13)];
    if (ISIPhoneX) {
        _CardScrollView.frame = CGRectMake(0,SCREENWIDTH*0.47+1+20, SCREENWIDTH ,216+0.15*SCREEN_WIDTH-SCREENWIDTH*0.47-2-7);
    }else{
        _CardScrollView.frame = CGRectMake(0,SCREENWIDTH*0.47+1+20, SCREENWIDTH ,216+0.15*SCREEN_WIDTH-SCREENWIDTH*0.47-2-13);

    }
    _CardScrollView.backgroundColor=[UIColor clearColor];
    _CardScrollView.bounces=NO;
    _CardScrollView.pagingEnabled=NO;
    _CardScrollView.showsVerticalScrollIndicator = NO;
    _CardScrollView.showsHorizontalScrollIndicator=NO;  //控制是否显示水平方向的滚动条, 默认显示
    _CardScrollView.delegate=self;
    _CardScrollView.contentSize=CGSizeMake(4+130*_cardArray.count, _CardScrollView.frame.size.height);
    [_bannerView addSubview:_CardScrollView];
    topPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0,SCREENWIDTH*0.37-20,0,0)];

}
#pragma mark 购物车上的提示页面
-(void)setHeadViewCar{
    self.carAlertView =  [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH, 35)];
    self.carAlertView.backgroundColor = [BBSColor hexStringToColor:@"fffdf6"];
    [self.view addSubview:self.carAlertView];
    self.alertViewImg = [[UIImageView alloc]initWithFrame:CGRectMake(9, 9, 15, 18)];
    self.alertViewImg.image = [UIImage imageNamed:@"toy_alert"];
    [self.carAlertView addSubview:self.alertViewImg];
    
    self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(27, 9, SCREENWIDTH-40, 18)];
    self.alertLabel.textColor = [BBSColor hexStringToColor:@"846943"];
    self.alertLabel.font = [UIFont systemFontOfSize:12];
    self.alertLabel.numberOfLines = 0;
    [self.carAlertView addSubview:self.alertLabel];
    
}
#pragma mark 添加购物车之后的结算
-(void)makeSureOrder{
    if ([self.isButton isEqualToString:@"1"]) {
        MakeSurePaySureVC *makeSureVC = [[MakeSurePaySureVC alloc]init];
        makeSureVC.fromWhere = @"1";
        makeSureVC.source = @"1";
        [self.navigationController pushViewController:makeSureVC animated:YES];
    }else{
        [BBSAlert showAlertWithContent:@"请选择要结算的商品" andDelegate:self];
    }
    
}
#pragma mark ----------------点击上面按钮的时候数据的切换-------------
-(void)changeDataWithTag:(UIButton*)sender{
    UIButton *button = sender;
    if (sender.tag == 2003 || sender.tag == 2004) {
        _lastTag = _inTheViewData;
    }
    _inTheViewData = button.tag;
    if (_inTheViewData == 2001) {
        BBSTabBarViewController *tabVC = (BBSTabBarViewController *)theAppDelegate.window.rootViewController;
        [tabVC setBBStabbarSelectedIndex:0];
        tabVC.selectedIndex = 0;
    }
    [self changeData:_inTheViewData];
    [self hiddenAllClassifyView];
    
}
-(void)changeData:(NSInteger)tag{
    _emptyView.hidden = YES;
    _emptyNoToyView.hidden = YES;
    [self getToyCarCount];
    [self completeDeleteToy];
    if (_inTheViewData == 2001) {
        [self changeFrameAndSearchBarHidden];
        if (_dataArray.count<=0) {
            _post_create_time = NULL;
            [self getBannarData];
            [self getListData];
        }
          _backBtn.hidden = NO;
        _tableView.hidden = NO;
        _collectionView.hidden = YES;
        self.carSelectView.hidden = YES;
         [_tableView reloadData];
        self.navigationItem.title = @"首页";
    }else if (_inTheViewData == 2002){
        [self changeFrameAndSearchBarHidden];
        [self alertShowInSelectView:_alertAlertClassifyString];
        if (_toydataArray.count <= 0) {
            _post_create_timeToy = NULL;
            [self getToyListData:0];
        }
        _tableView.hidden = YES;
        _collectionView.hidden = NO;
        if (_alertAlertClassifyString.length > 0) {
            self.carSelectView.hidden = NO;
        }
        _backBtn.hidden = NO;
        [_collectionView reloadData];
        self.navigationItem.title = @"全部";
    }else if (_inTheViewData == 2003){
        UserInfoManager *manager=[[UserInfoManager alloc]init];
        UserInfoItem *userItem=[manager currentUserInfo];
        if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
            LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
            _inTheViewData = _lastTag;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
            [self presentViewController:nav animated:YES completion:^{
                
            }];
            if (_inTheViewData == 2002) {
                _tableView.hidden = YES;
                _collectionView.hidden = NO;
                if (_alertAlertClassifyString.length > 0) {
                    self.carSelectView.hidden = NO;
                }

                [_collectionView reloadData];
            }else{
                _tableView.hidden = NO;
                _collectionView.hidden = YES;
                self.carSelectView.hidden = YES;
                [_tableView reloadData];
            }
            return;

        }else{
            self.navigationItem.title = @"订单";
            _backBtn.hidden = NO;
            [self changeFrameAndSearchBarHidden];
            _post_create_timeOrder = NULL;
            [self getOrderListData];
            _tableView.hidden = NO;
            _collectionView.hidden = YES;
            self.carSelectView.hidden = YES;
            [_tableView reloadData];
        }
    }else if (_inTheViewData == 2004){
        UserInfoManager *manager=[[UserInfoManager alloc]init];
        UserInfoItem *userItem=[manager currentUserInfo];
        if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
            LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
            _inTheViewData = _lastTag;
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
            [self presentViewController:nav animated:YES completion:^{
            }];
            if (_inTheViewData == 2002) {
                _tableView.hidden = YES;
                _collectionView.hidden = NO;
                if (_alertAlertClassifyString.length > 0) {
                    self.carSelectView.hidden = NO;
                }
                [_collectionView reloadData];
            }else{
            _tableView.hidden = NO;
            _collectionView.hidden = YES;
            self.carSelectView.hidden = YES;
            [_tableView reloadData];
            }

            return;
        }else{
            self.navigationItem.title = @"购物车";
            _backBtn.hidden = NO;
            [self changeFrameAndSearchBarHidden];
            _post_create_carToy = NULL;
            [self getToyCarListData];
            _tableView.hidden = NO;
            _collectionView.hidden = YES;
            self.carSelectView.hidden = YES;
            [_tableView reloadData];
        }
    }
}
#pragma mark --------------改变搜索的展示和隐藏----------------
-(void)changeFrameAndSearchBarHidden{
    if (_inTheViewData == 2001) {
        self.navigationItem.title = @"首页";
        [firstBtn setImage:[UIImage imageNamed:@"firtst_select"] forState:UIControlStateNormal];
        [secondBtn setImage:[UIImage imageNamed:@"all_unselect"] forState:UIControlStateNormal];
        [thridBtn setImage:[UIImage imageNamed:@"order_unselect"] forState:UIControlStateNormal];
        [fourBtn setImage:[UIImage imageNamed:@"car_unselect"] forState:UIControlStateNormal];
        _tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-IPhoneXSafeHeight-46);
        self.navSearchView.hidden = NO;
        _tableView.tableHeaderView = _bannerView;
        self.payToys.hidden = YES;
        self.carAlertView.hidden = YES;
        self.navigationController.navigationBarHidden = YES;
        _classifyView.hidden = YES;
         btnView.frame = CGRectMake(0,  SCREENHEIGHT- IPhoneXSafeHeight-46 , SCREENWIDTH,46);

    }else if (_inTheViewData == 2002){
        self.navigationItem.title = @"全部";
        [firstBtn setImage:[UIImage imageNamed:@"firtst_unselect"] forState:UIControlStateNormal];
        [secondBtn setImage:[UIImage imageNamed:@"all_select"] forState:UIControlStateNormal];
        [thridBtn setImage:[UIImage imageNamed:@"order_unselect"] forState:UIControlStateNormal];
        [fourBtn setImage:[UIImage imageNamed:@"car_unselect"] forState:UIControlStateNormal];
        _tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-StatusAndNavBar_HEIGHT-46);

        self.navSearchView.hidden = NO;
        _tableView.hidden = YES;
        _collectionView.hidden = NO;
        self.payToys.hidden = YES;
        self.carAlertView.hidden = YES;
        self.navigationController.navigationBarHidden = YES;
        _classifyView.hidden = NO;
        btnView.frame = CGRectMake(0,  SCREENHEIGHT- IPhoneXSafeHeight-46 , SCREENWIDTH,46);

        

    }else if (_inTheViewData == 2003){
        self.navigationItem.title = @"订单";
        self.navSearchView.hidden = YES;
        [firstBtn setImage:[UIImage imageNamed:@"firtst_unselect"] forState:UIControlStateNormal];
        [secondBtn setImage:[UIImage imageNamed:@"all_unselect"] forState:UIControlStateNormal];
        [thridBtn setImage:[UIImage imageNamed:@"order_select"] forState:UIControlStateNormal];
        [fourBtn setImage:[UIImage imageNamed:@"car_unselect"] forState:UIControlStateNormal];
        _tableView.frame = CGRectMake(0,0, SCREENWIDTH, SCREENHEIGHT-StatusAndNavBar_HEIGHT-46);
        _tableView.tableHeaderView = orderHeadView;
        self.carAlertView.hidden = YES;
        self.payToys.hidden = YES;
        NSLog(@"购物车切订单，self.payToys.hidden = %ld",self.payToys.hidden);
        _noToyImgView.image = [UIImage imageNamed:@"img_no_toyorder"];
        self.navigationController.navigationBarHidden = NO;
        _right = [[UIBarButtonItem alloc]initWithCustomView:_iconBgView];
        self.navigationItem.rightBarButtonItem = _right;
        _classifyView.hidden = YES;
        btnView.frame = CGRectMake(0,  SCREENHEIGHT-StatusAndNavBar_HEIGHT - IPhoneXSafeHeight-46 , SCREENWIDTH,46);

        

    }else if (_inTheViewData == 2004){
        self.navSearchView.hidden = YES;
        self.navigationItem.title = @"购物车";
        [firstBtn setImage:[UIImage imageNamed:@"firtst_unselect"] forState:UIControlStateNormal];
        [secondBtn setImage:[UIImage imageNamed:@"all_unselect"] forState:UIControlStateNormal];
        [thridBtn setImage:[UIImage imageNamed:@"order_unselect"] forState:UIControlStateNormal];
        [fourBtn setImage:[UIImage imageNamed:@"car_select"] forState:UIControlStateNormal];
        _tableView.tableHeaderView = headView;
        //self.payToys.hidden = NO;
        self.carAlertView.hidden = YES;
        self.navigationController.navigationBarHidden = NO;
        NSLog(@"订单切到购物车");

        _noToyImgView.image = [UIImage imageNamed:@"img_no_toy_car"];
        _right = [[UIBarButtonItem alloc]initWithCustomView:_editBtn];
        self.navigationItem.rightBarButtonItem = _right;
        _tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-StatusAndNavBar_HEIGHT-46);
        _classifyView.hidden = YES;
        btnView.frame = CGRectMake(0,  SCREENHEIGHT-StatusAndNavBar_HEIGHT - IPhoneXSafeHeight-46 , SCREENWIDTH,46);


    }
}
#pragma mark---------------------------------------------

#pragma mark tableview
-(void)setTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH, SCREENHEIGHT-46)];
    _tableView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
#endif
    
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    [self.view addSubview:_tableView];


    //[self.view addSubview:_tableView];
    [self changeFrameAndSearchBarHidden];
}

#pragma mark data 处理
-(void)getBannarData{
    NSDictionary *params;
    params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    UrlMaker *urlMark = [[UrlMaker alloc]initWithNewV1UrlStr:@"AppIndexClassBannerCard" Method:NetMethodGet andParam:params];
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
        if ([[dic objectForKey:kBBSSuccess]boolValue] == YES) {
            _bannerArray = [NSMutableArray array];
            _cardArray = [NSMutableArray array];
            for (UIView *view in _topNewScrollView.subviews) {
                [view removeFromSuperview];
            }
            //玩具的banner
            for (NSDictionary *headDic in dic[@"data"]) {
             SpecialHeadListModel *headListModel = [[SpecialHeadListModel alloc]init];
                headListModel.type = [headDic[@"type"]integerValue];
                headListModel.isClick = [headDic[@"is_click"]boolValue];
                headListModel.img = headDic[@"img"];
                headListModel.img_id = [headDic[@"img_id"]integerValue];
                headListModel.businessUrl = headDic[@"business_url_app"];
                [_bannerArray addObject:headListModel];
            }
            topPageControl.numberOfPages = _bannerArray.count;
            topPageControl.currentPage = 0;
            topPageControl.hidden =  YES;
            [_bannerView addSubview:topPageControl];
            _topNewScrollView.contentSize=CGSizeMake(SCREENWIDTH*_bannerArray.count,_topNewScrollView.frame.size.height);
            for (int i = 0; i < _bannerArray.count; i++) {
                SpecialHeadListModel *headListModel = (SpecialHeadListModel*)_bannerArray[i];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH*i, 0,SCREENWIDTH,SCREENWIDTH*0.47+20)];
                imageView.contentMode = UIViewContentModeScaleToFill;
                imageView.userInteractionEnabled = YES;
                imageView.tag = 100+i;
                NSString *imgString = headListModel.img[0][@"img_thumb"];
                [_topNewScrollView addSubview:imageView];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imgString]];
                [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushViewController:)];
                [imageView addGestureRecognizer:singleTap];
            }
            //会员卡
            for (NSDictionary *cardDic in dic[@"data1"]) {
                SpecialHeadListModel *cardModel = [[SpecialHeadListModel alloc]init];
                cardModel.img_id= [cardDic[@"business_id"]integerValue];
                cardModel.businessUrl = cardDic[@"img_thumb"];
                cardModel.is_jump = cardDic[@"is_jump"];
                cardModel.postUrl = cardDic[@"post_url"];
                [_cardArray addObject:cardModel];
            }
            for (UIView *view in _CardScrollView.subviews) {
                [view removeFromSuperview];
            }
            _CardScrollView.contentSize = CGSizeMake(6+130*_cardArray.count, _CardScrollView.frame.size.height);
            //_CardScrollView.backgroundColor = [UIColor redColor];
            for (int i = 0; i < _cardArray.count; i++) {
                 SpecialHeadListModel *headListModel = (SpecialHeadListModel*)_cardArray[i];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(4+126*i+4*(i+1),10,122,90)];
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                imageView.userInteractionEnabled = YES;
                imageView.tag = 200+i;
                //imageView.backgroundColor = [UIColor yellowColor];
                NSString *imgString = headListModel.businessUrl;
                [_CardScrollView addSubview:imageView];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imgString]];
                [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
                UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushCardViewController:)];
                [imageView addGestureRecognizer:singleTap];
            }
            
            
        }
 
    }];

    
}
#pragma mark 首页banner跳转页面
-(void)pushViewController:(UITapGestureRecognizer*)singleTap//已写
{
   SpecialHeadListModel *model = _bannerArray[singleTap.view.tag-100];
    if (model.isClick == NO) {
    }else{
        if (model.type == 3) {
            //跳转帖子详情
            PostBarNewDetialV1VC *detailVC=[[PostBarNewDetialV1VC alloc]init];
            detailVC.img_id=[NSString stringWithFormat:@"%ld",(long)model.img_id];
            detailVC.login_user_id=LOGIN_USER_ID;
            detailVC.refreshInVC = ^(BOOL isRefresh){
                
            };
            [detailVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:detailVC animated:YES];

        }else if (model.type == 9){
            ToyClassListVC *toyClassVC = [[ToyClassListVC alloc]init];
            toyClassVC.businessId = [NSString stringWithFormat:@"%ld",(long)model.img_id];
            [self.navigationController pushViewController:toyClassVC animated:YES];


        }else if (model.type == 10){
            ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
            toyDetailVC.business_id = [NSString stringWithFormat:@"%ld",(long)model.img_id];
            [self.navigationController pushViewController:toyDetailVC animated:YES];
         
        }else if (model.type == 5){
            WebViewController *webView=[[WebViewController alloc]init];
            NSString *url = model.businessUrl;
            webView.urlStr=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [webView setHidesBottomBarWhenPushed:YES];
            webView.fromWhree = @"1";
            [self.navigationController pushViewController:webView animated:YES];
        }
    }
}
#pragma mark 商家卡
-(void)pushCardViewController:(UITapGestureRecognizer*)singleTap//已写
{
    SpecialHeadListModel *modelVC = _cardArray[singleTap.view.tag-200];
    if ([modelVC.is_jump isEqualToString:@"1"]) {
        [self pushWebUrl:modelVC.postUrl];
    }else{
        ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
        NSString *imgid = [NSString stringWithFormat:@"%ld",modelVC.img_id];
        toyDetailVC.business_id = imgid;
        [self.navigationController pushViewController:toyDetailVC animated:YES];
  
    }
    
}

#pragma mark 全部列表
-(void)getListData{
    NSDictionary *newParam = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",nil];
    UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:@"AppIndexClass" Method:NetMethodGet andParam:newParam];
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
        if ([[dic objectForKey:@"success"]integerValue] == 1) {
            NSArray *dataArray = [dic objectForKey:@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
            [_dataArray removeAllObjects];
            for (NSDictionary *dataDic in dataArray) {
                ToyListItem1 *item = [[ToyListItem1 alloc]init];
                item.class_title = dataDic[@"class_title"];
                item.class_more_title = dataDic[@"class_more_title"];
                item.show_type = dataDic[@"show_type"];
                item.category_id = dataDic[@"category_id"];
                item.business_info = [NSMutableArray array];
                for (NSDictionary *dataDic1 in dataDic[@"business_info"]) {
                    ToyLIstClassItem *item1 = [[ToyLIstClassItem alloc]init];
                    item1.business_id = dataDic1[@"business_id"];
                    item1.business_title = dataDic1[@"business_title"];
                    item1.sell_price = dataDic1[@"sell_price"];
                    item1.business_pic = dataDic1[@"business_pic"];
                    item1.source = dataDic1[@"source"];
                    item1.web_link = dataDic1[@"web_link"];
                    item1.unit_name = dataDic1[@"unit_name"];
                    item1.business_title_ios14 = dataDic1[@"business_title_ios14"];
                    item1.business_title_ios16 = dataDic1[@"business_title_ios16"];
                    [item.business_info addObject:item1];
                }
                [returnArray addObject:item];
            }
                _refreshControl.bottomEnabled = NO;
            ToyListItem1 *item = [returnArray lastObject];
            _post_create_time = item.post_create_time;
            
            [_dataArray addObjectsFromArray:returnArray];
            [_tableView reloadData];
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
#pragma mark   玩具列表头部通知展示
-(void)alertShowInSelectView:(NSString*)alertString{
    if (_inTheViewData != 2002) {
        self.carSelectView.hidden = YES;
    }else
    if (alertString.length > 0) {
        self.carSelectView.hidden = NO;
        self.alertSelectLabel.text = alertString;
        CGFloat width = [self getTitleWidth:alertString fontSize:12];
        _collectionView.frame = CGRectMake(0, self.navSearchView.frame.size.height+self.navSearchView.frame.origin.y+34+30, SCREEN_WIDTH, SCREENHEIGHT-(self.navSearchView.frame.size.height+self.navSearchView.frame.origin.y+34)-46-30);
        
        if (width < (SCREEN_WIDTH-20-25)) {
        self.alertSelectLabel.frame = CGRectMake(27, self.alertSelectLabel.frame.origin.y, width, self.alertSelectLabel.frame.size.height);
  
        }else{
        self.alertSelectLabel.frame = CGRectMake(27, self.alertSelectLabel.frame.origin.y, width, self.alertSelectLabel.frame.size.height);
          self.carSelectView.frame = CGRectMake(SCREEN_WIDTH,self.navSearchView.frame.size.height+self.navSearchView.frame.origin.y+34, 25+width+20, 30);
        [UIView beginAnimations:@"testAnimation"context:NULL];
        [UIView setAnimationDuration:20.0f];
        [UIView setAnimationCurve:UIViewAnimationCurveLinear];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationRepeatCount:999999];
        //self.alertSelectLabel.frame = CGRectMake(-width, 9, width, 18);
        self.carSelectView.frame = CGRectMake(-width,self.navSearchView.frame.size.height+self.navSearchView.frame.origin.y+34,  25+width+20, 30);
        
        [UIView commitAnimations];
        }
        
        
    }else{
        self.carSelectView.hidden = YES;
        _collectionView.frame = CGRectMake(0, self.navSearchView.frame.size.height+self.navSearchView.frame.origin.y+34, SCREEN_WIDTH, SCREENHEIGHT-(self.navSearchView.frame.size.height+self.navSearchView.frame.origin.y+34)-46);

    }
    
}
#pragma mark 玩具列表
-(void)getToyListData:(NSInteger)selectIndex{
    
    NSMutableDictionary *params;
    NSString *ageString = [NSString stringWithFormat:@""];
    NSString *brandString = [NSString stringWithFormat:@""];
    NSString *chooseString = [NSString stringWithFormat:@""];

    params  = [NSMutableDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    if (_post_create_timeToy.length > 0) {
        [params setObject:_post_create_timeToy forKey:@"post_create_time"];
    }
    //年龄参数
    if (_ageSelectedArray.count > 0) {
        for (int i = 0; i <_ageSelectedArray.count; i++) {
            NSString *tempString;
            if (i == _ageSelectedArray.count-1) {
                tempString =[NSString stringWithFormat:@"%@", _ageSelectedArray[i]];
            }else{
                tempString =[NSString stringWithFormat:@"%@,", _ageSelectedArray[i]];
            }
            ageString = [NSString stringWithFormat:@"%@%@",ageString,tempString];
        }
        if (ageString.length>0) {
            [params setObject:[ageString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"toys_age"];
            //改变的btn上面的文字
            UIButton *btn =  [self.view viewWithTag:4001];
            [btn setTitle:ageString forState:UIControlStateNormal];
        }else{
            UIButton *btn =  [self.view viewWithTag:4001];
            [btn setTitle:@"全部年龄" forState:UIControlStateNormal];
        }


    }else{
        UIButton *btn =  [self.view viewWithTag:4001];
        [btn setTitle:@"全部年龄" forState:UIControlStateNormal];

    }
    //品牌参数
    //品牌
    if (_brandSelectedArray.count > 0) {
        for (int i = 0; i < _brandSelectedArray.count; i++) {
            NSString *brandTempString;
            if (i == _brandSelectedArray.count-1) {
                brandTempString = [NSString stringWithFormat:@"%@",_brandSelectedArray[i]];
            }else{
                brandTempString = [NSString stringWithFormat:@"%@,",_brandSelectedArray[i]];
            }
            brandString = [NSString stringWithFormat:@"%@%@",brandString,brandTempString];
        }
        if (brandString.length > 0) {
            [params setObject:[brandString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"toys_brand"];
            //改变的btn上面的文字
            UIButton *btn =  [self.view viewWithTag:4002];
            [btn setTitle:brandString forState:UIControlStateNormal];
            
        }else{
            UIButton *btn =  [self.view viewWithTag:4002];
            [btn setTitle:@"全部品牌" forState:UIControlStateNormal];
            
        }
    }else{
        UIButton *btn =  [self.view viewWithTag:4002];
        [btn setTitle:@"全部品牌" forState:UIControlStateNormal];
        
    }
    //综合排序
    UIButton *btn3 = [self.view viewWithTag:4003];

    if (_allSelectedString.length > 0) {
        [params setObject:[_hotToy stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"toys_rank"];
        [btn3 setTitle:_allSelectedString forState:UIControlStateNormal];
        
    }else{
        [btn3 setTitle:@"综合排序" forState:UIControlStateNormal];

    }
    //筛选
    UIButton *btn4 = [self.view viewWithTag:4004];
    NSString *chooseNameString = @"";
    if (_chooseSelectedArray.count > 0) {
        for (int i = 0; i < _chooseSelectedArray.count; i ++) {
            NSString *tempString;
            NSString *tempNameString;
            if (i == _chooseSelectedArray.count - 1) {
                tempString = [NSString stringWithFormat:@"%@",_chooseSelectedArray[i]];
                tempNameString = [NSString stringWithFormat:@"%@",_chooseSelectedNameArray[i]];
            }else{
                tempString = [NSString stringWithFormat:@"%@,",_chooseSelectedArray[i]];
                tempNameString = [NSString stringWithFormat:@"%@,",_chooseSelectedNameArray[i]];
            }
            chooseString = [NSString stringWithFormat:@"%@%@",chooseString,tempString];
            chooseNameString = [NSString stringWithFormat:@"%@%@",chooseNameString,tempNameString];
        }
        if (chooseString.length > 0) {
            [params setObject:[chooseString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"toys_select"];
            [btn4 setTitle:chooseNameString forState:UIControlStateNormal];
        }else{
            [btn4 setTitle:@"筛选" forState:UIControlStateNormal];
            
        }
    }else{
        [btn4 setTitle:@"筛选" forState:UIControlStateNormal];
    }

    UrlMaker *urlMark = [[UrlMaker alloc]initWithNewV1UrlStr:@"getSelectToysList" Method:NetMethodGet andParam:params];
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
            //展示通告
            //NSDictionary *alertDic = dic[@"data2"];
            _alertAlertClassifyString = dic[@"data2"];
            [self alertShowInSelectView:_alertAlertClassifyString];
            
            NSMutableArray *returnArray = [NSMutableArray array];
            for (NSDictionary *dataDic in dataArray) {
                ToyLeaseItem *item = [[ToyLeaseItem alloc]init];
                item.business_id = dataDic[@"business_id"];
                item.user_name = dataDic[@"user_name"];
                item.business_title = dataDic[@"business_title_ios"];
                item.way = dataDic[@"way"];
                item.img_thumb = dataDic[@"img_thumb"];
                item.is_support = dataDic[@"is_support"];
                item.sell_price = dataDic[@"sell_price"];
                item.is_order = dataDic[@"is_order"];
                item.post_create_time = dataDic[@"post_create_time"];
                item.status = dataDic[@"status"];
                item.status_name = dataDic[@"status_name"];
                item.avatar = dataDic[@"avatar"];
                item.support_name = dataDic[@"support_name"];
                item.order_id = dataDic[@"order_id"];
                item.is_jump = dataDic[@"is_jump"];
                item.postUrl = dataDic[@"post_url"];
                item.is_cart = dataDic[@"is_cart"];
                item.size_img_thumb = dataDic[@"size_img_thumb"];
                item.age = dataDic[@"age"];
                item.unit_name = dataDic[@"unit_name"];
                
                [returnArray addObject:item];
            }
            if (returnArray.count == 0 && _toydataArray.count > 0) {
                //[self showHUDWithMessage:@"没有更多玩具啦！"];
                _refreshControlCollectionview.bottomEnabled = NO;
            }
            if (_post_create_timeToy == NULL) {
                [_toydataArray removeAllObjects];
                _refreshControlCollectionview.bottomEnabled = YES;
            }
            ToyLeaseItem *item = [returnArray lastObject];
            _post_create_timeToy = item.post_create_time;
            [_toydataArray addObjectsFromArray:returnArray];
            [CATransaction setDisableActions:YES];
            [_collectionView reloadData];
            [CATransaction commit];
            if (_toydataArray.count == 0 ) {
                [self addEmptySelectView];
                _emptyNoToyView.hidden = NO;
            }else{
                _emptyNoToyView.hidden = YES;
            }
            
            [self refreshComplete:_refreshControlCollectionview];
            
        }else{
            [self refreshComplete:_refreshControlCollectionview];
            if (dic) {
                [BBSAlert showAlertWithContent:[dic objectForKey:kBBSReMsg] andDelegate:self];
            }else{
                [BBSAlert showAlertWithContent:@"请刷新" andDelegate:self];
            }
            
        }
    }];
    [request setFailedBlock:^{
        [self refreshComplete:_refreshControlCollectionview];
        
    }];
}
-(void)someViewHidden{
    self.carAlertView.hidden = YES;
    self.payToys.hidden = YES;
    _classifyView.hidden = YES;
    _tableView.frame = CGRectMake(0,0, SCREENWIDTH, SCREENHEIGHT-StatusAndNavBar_HEIGHT-46);

}
#pragma mark 订单列表
-(void)getOrderListData{
    [self performSelector:@selector(someViewHidden) withObject:nil afterDelay:0.1];
    NSDictionary *newParam = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",_post_create_timeOrder,@"post_create_time",nil];
    UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:@"getToysOrderListV3" Method:NetMethodGet andParam:newParam];
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
        if ([[dic objectForKey:@"success"]integerValue] == 1) {
            NSArray *dataOrderArray = [dic objectForKey:@"data2"];
            for (NSDictionary *dataDic in dataOrderArray) {
                ToyOrderHeadItem *item = [[ToyOrderHeadItem alloc]init];
                item.type = dataDic[@"type"];
                item.img = dataDic[@"img"];
                item.num = dataDic[@"num"];
                item.order_id = dataDic[@"order_id"];
                [_orderHeadArray addObject:item];
                if ([item.type isEqualToString:@"1"]) {
                    //type=1时，根据num判断跳转方向，num=1时，跳转单张会员卡详情（参数为order_id）；其他情况跳转我的会员卡列表
                    if ([item.num isEqualToString:@"1"]) {
                        _cardOrderId = item.order_id;
                        [myCardBtn addTarget:self action:@selector(pushCardDetail:) forControlEvents:UIControlEventTouchUpInside];
                    }else{
                        [myCardBtn addTarget:self action:@selector(pushCardList) forControlEvents:UIControlEventTouchUpInside];
                    }
                }else if ([item.type isEqualToString:@"2"]){
                    //进入我的押金
                    self.myDepositOrderID = item.order_id;
                    [myDepositBtn addTarget:self action:@selector(pushMyDepostitVC:) forControlEvents:UIControlEventTouchUpInside];
                }else if ([item.type isEqualToString:@"3"]){
                    //进入我的预约
                    [myAppointmentBtn addTarget:self action:@selector(pushMyBookingToys) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    [mySaveBtn addTarget:self action:@selector(pushSaveList) forControlEvents:UIControlEventTouchUpInside];
                    
                }
            }
            NSArray *dataArray = [dic objectForKey:@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
            for (NSDictionary *mainDic in dataArray) {
                NSMutableArray *singleArray = [NSMutableArray array];
               
                ToyOrderNumberItem *item = [[ToyOrderNumberItem alloc]init];
                item.orderNumberString = [NSString stringWithFormat:@"订单批号：%@",mainDic[@"combined_order_id"]];
                item.post_create_time = mainDic[@"post_create_time"];
                item.cellHeight = 40;
                NSString *combine = mainDic[@"combined_order_id"];
                if (combine.length>0) {
                    [singleArray addObject:item];
                }
                NSArray *toysInfoArray = mainDic[@"toys_info"];
                for (NSDictionary *dataDic in toysInfoArray) {
                    ToyOrderItem *item = [[ToyOrderItem alloc]init];
                    item.business_id = dataDic[@"business_id"];
                    item.business_title = dataDic[@"business_title"];
                    item.img_thumb = dataDic[@"img_thumb"];
                    item.sell_price = dataDic[@"sell_price"];
                    item.status = dataDic[@"status"];
                    item.post_create_time = mainDic[@"post_create_time"];
                    item.status_name = dataDic[@"status_name"];
                    item.order_id = dataDic[@"order_id"];
                    item.is_del = dataDic[@"is_del"];
                    item.is_reset = dataDic[@"is_reset"];
                    item.order_status = dataDic[@"order_status"];
                    item.is_jump = dataDic[@"is_jump"];
                    item.post_url = dataDic[@"post_url"];
                    item.size_img_thumb = dataDic[@"size_img_thumb"];
                    item.toys_card_info = dataDic[@"toys_card_info"];
                    item.day_title = dataDic[@"day_title"];
                    item.is_prize_status = dataDic[@"is_prize_status"];
                    
                    if ([item.order_status isEqualToString:@"1"]) {
                        item.cellHeight = 63;
                    }else{
                        item.cellHeight = 98;
                    }
                    [singleArray addObject:item];
                }
                ToyOrderBottomItem *toyOrderItem = [[ToyOrderBottomItem alloc]init];
                toyOrderItem.mainTitle = mainDic[@"toys_title"];
                toyOrderItem.isDelete = mainDic[@"is_del"];
                toyOrderItem.isPayBtn = mainDic[@"is_reset"];
                toyOrderItem.combineId = mainDic[@"combined_order_id"];
                toyOrderItem.combineOrderStatus = mainDic[@"order_status"];
                toyOrderItem.post_create_time = mainDic[@"post_create_time"];
                toyOrderItem.cellHeight = 70;
                if ([toyOrderItem.combineOrderStatus isEqualToString:@"1"]) {
                    
                }else{
                    [singleArray addObject:toyOrderItem];
                  }
                [returnArray addObject:singleArray];
            }
            if (returnArray.count == 0) {
                _refreshControl.bottomEnabled = NO;
            }
            if (_post_create_timeOrder == NULL || [_post_create_timeOrder isEqualToString:@"0"]) {
                [_orderdataArray removeAllObjects];
                _refreshControl.bottomEnabled = YES;
            }
            NSArray *singleArray = [returnArray lastObject];
            ToyCarMainItem *item = [singleArray lastObject];
            _post_create_timeOrder = item.post_create_time;
            [_orderdataArray addObjectsFromArray:returnArray];
            if (_orderdataArray.count == 0) {
                NSLog(@"无订单时无订单时");
                [self addEmptyHintView];
                _emptyView.hidden = NO;
            }else{
                _emptyView.hidden = YES;
            }
            [_tableView reloadData];
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
#pragma mark 获取购物车的数据
-(void)getToyCarListData{
    NSDictionary *newParam = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",nil];
    UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:@"getCartList" Method:NetMethodGet andParam:newParam];
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
        if ([[dic objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data1 = [dic objectForKey:@"data1"];
            NSString *card_title = data1[@"card_title"];
            NSString *is_card = data1[@"is_card"];
            
            if (card_title.length <=0) {
                self.carAlertView.hidden = YES;
                _tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-StatusAndNavBar_HEIGHT-46-50);
            }else{
                if (_inTheViewData != 2004) {
                    NSLog(@"购物车切换订单的时候，页面的展示");
                    self.carAlertView.hidden = YES;
  
                }else{
                    self.carAlertView.hidden = NO;
                    CGFloat cardHeight = [self getHeightByWidth:SCREENWIDTH-40 title:card_title font:[UIFont systemFontOfSize:12]];
                    if (cardHeight <= 12) {
                        cardHeight = 17;
                    }else{
                        cardHeight = cardHeight;
                    }
                    self.alertLabel.frame = CGRectMake(27,9, SCREENWIDTH-40, cardHeight);
                    self.alertLabel.text = card_title;
                    self.carAlertView.frame = CGRectMake(0, 0, SCREENWIDTH, cardHeight+18);
                    _tableView.frame = CGRectMake(0, cardHeight+18, SCREENWIDTH, SCREENHEIGHT-StatusAndNavBar_HEIGHT - IPhoneXSafeHeight-46-50-cardHeight-18);
                }
            }
            //去结算按钮的状态
            self.isButton = data1[@"is_button"];
            [self.payBtn addTarget:self action:@selector(makeSureOrder) forControlEvents:UIControlEventTouchUpInside];
            if ([self.isButton isEqualToString:@"1"]) {
               //显示可以点击
                [self.payBtn setBackgroundImage:[UIImage imageNamed:@"toy_go_pay"] forState:UIControlStateNormal];
            }else{
                [self.payBtn setBackgroundImage:[UIImage imageNamed:@"toy_ungo_pay"] forState:UIControlStateNormal];
            }
            
            self.totalLabel.text = data1[@"total_title"];
            NSString *totalMoneyString = data1[@"total_price"];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:totalMoneyString attributes:@{NSKernAttributeName:@(-1)}];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalMoneyString length])];
            self.totalMoneyLabel.attributedText = attributedString;
            NSArray *dataArray = [dic objectForKey:@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
            NSMutableArray *returnDeleteArray = [NSMutableArray array];
            for (NSDictionary *mainDic in dataArray) {
                NSMutableArray *singleArray = [[NSMutableArray alloc]init];
                NSMutableArray *singleArrayDelete = [[NSMutableArray alloc]init];
                NSString *cart_delete_status = mainDic[@"cart_delete_status"];
                //添加头部的item
                ToyCarHeadItem *titleItem = [[ToyCarHeadItem alloc]init];
                titleItem.toys_title = MBNonEmptyString(mainDic[@"toys_title"]);
                titleItem.isMember = MBNonEmptyString(mainDic[@"is_member"]);
                titleItem.type = MBNonEmptyString(mainDic[@"type"]);
                if ([titleItem.type isEqualToString:@"1"]) {
                    CGFloat heightTitle = [self getHeightByWidth:300 title:titleItem.toys_title font:[UIFont systemFontOfSize:13]];
                    if (heightTitle <=13) {
                        titleItem.cellHeight = 36;
                    }else{
                        titleItem.cellHeight = 20+heightTitle;
                    }
                    
                }else {
                    titleItem.cellHeight = 10;
                }
                [singleArray addObject:titleItem];
                //添加玩具信息的item
                NSArray *toysArray = mainDic[@"toys_info"];
                if (toysArray.count) {
                    for (NSDictionary *toyDic in toysArray) {
                        ToyMessDetailItem *item = [[ToyMessDetailItem alloc]init];
                        item.cart_id = MBNonEmptyString(toyDic[@"cart_id"]);
                        item.business_id = MBNonEmptyString(toyDic[@"business_id"]);
                        item.business_title = MBNonEmptyString(toyDic[@"business_title"]);
                        item.every_price = MBNonEmptyString(toyDic[@"every_price"]);
                        item.img_thumb = MBNonEmptyString(toyDic[@"img_thumb"]);
                        item.check_state = MBNonEmptyString(toyDic[@"check_state"]);
                        item.is_order = MBNonEmptyString(toyDic[@"is_order"]);
                        item.order_id = MBNonEmptyString(toyDic[@"order_id"]);
                        item.descriptionOrder = MBNonEmptyString(toyDic[@"description"]);
                        item.smallImgThumb = MBNonEmptyString(toyDic[@"new_size_img_thumb"]);
                        item.cellHeight = 70+5;
                        [singleArray addObject:item];
                        if ([cart_delete_status isEqualToString:@"1"]) {
                            [singleArrayDelete addObject:item];
                        }
                    }
                }
                [returnArray addObject:singleArray];
                [returnDeleteArray addObject:singleArrayDelete];
            }
            
            if (returnArray.count == 0) {
                _refreshControl.bottomEnabled = NO;
            }
            if (_isDeleteToyCar == YES) {
                if (returnDeleteArray.count == 0) {
                    _refreshControl.bottomEnabled = NO;
                }
                _refreshControl.topEnabled = NO;
            }
            if (_post_create_carToy == NULL) {
                [_toyCarDataArray removeAllObjects];
                [_toyCarCanDeleteToyArray removeAllObjects];
                _refreshControl.bottomEnabled = YES;
            }
            [_toyCarDataArray addObjectsFromArray:returnArray];
            [_toyCarCanDeleteToyArray addObjectsFromArray:returnDeleteArray];//购物车删除状态下面的数组
            if (_toyCarDataArray.count == 0) {
                [self addEmptyHintView];
                _emptyView.hidden = NO;
                if (_inTheViewData != 2004) {
                    self.payToys.hidden = YES;
                }else{
                    self.payToys.hidden = YES;
 
                }
                
            }else{
                if (_inTheViewData != 2004) {
                    _emptyView.hidden = YES;
                    self.payToys.hidden = YES;

                }else{
                _emptyView.hidden = YES;
                self.payToys.hidden = NO;
                }
                
            }
            [_tableView reloadData];
            [self refreshComplete:_refreshControl];
        }else{
            [self refreshComplete:_refreshControl];
            if (dic) {
                [BBSAlert showAlertWithContent:[dic objectForKey:kBBSReMsg] andDelegate:self];
            }else{
                [BBSAlert showAlertWithContent:@"请刷新"andDelegate:self];
            }
        }
    }];
    [request setFailedBlock:^{
        [self refreshComplete:_refreshControl];
    }];

}
#pragma mark 跳转会员卡列表或详情
-(void)pushCardList{
    MyCardListH5VC *myCardListVC = [[MyCardListH5VC alloc]init];
    myCardListVC.refreshInVC = ^(BOOL isrefresh){
        NSLog(@"issisisiis = %ld",isrefresh);
        _inTheViewData = 2001;
        [self changeData:2001];
    };
    [self.navigationController pushViewController:myCardListVC animated:YES];
    
}
-(void)pushCardDetail:(NSString*)oderId{
    ToyTransportVC *toyTransportVC = [[ToyTransportVC alloc]init];
    toyTransportVC.order_id = _cardOrderId;
    toyTransportVC.fromWhere = @"3";
    [self.navigationController pushViewController:toyTransportVC animated:YES];

    
}
#pragma mark 跳转会员的收藏
-(void)pushSaveList{
    MySaveVC *mySave = [[MySaveVC alloc]init];
    [self.navigationController pushViewController:mySave animated:YES];
    
}
#pragma mark 进入我的押金
-(void)pushMyDepostitVC:(ToyLeaseItem*)item{
    MyDepositVC *myDepostitVC = [[MyDepositVC alloc]init];
    myDepostitVC.orderId = self.myDepositOrderID;
    [self.navigationController pushViewController:myDepostitVC animated:YES];
    
}
#pragma mark 进入我的预约
-(void)pushMyBookingToys{
    BookToysVC *book = [[BookToysVC alloc]init];
    [self.navigationController pushViewController:book animated:YES];
}

#pragma mark 去买年卡
-(void)gotoBuyCard{
    ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
    toyDetailVC.business_id = @"1629";
    [self.navigationController pushViewController:toyDetailVC animated:YES];
    
}

#pragma mark 轮播图
-(void)startAnimation
{
    if (_bannerArray.count > 0) {
        timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(cycleScroll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];

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
//轮播图的变化
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    topPageControl.currentPage = scrollView.contentOffset.x/320;
}

#pragma mark 没有订单的时候显示无订单页面
-(void)addEmptyHintView {
    UIImage *image;

    if (_emptyView) {
        if (_inTheViewData == 2003) {
            image = [UIImage imageNamed:@"img_no_toyorder"];
            if (ISIPhoneX) {
                _emptyView.frame = CGRectMake(0,75, SCREENWIDTH, SCREENHEIGHT-75-64-51-32-21);
                float height = SCREENHEIGHT-75-64-51-32-21;
                NSLog(@"hccccchhhhhhh = %f",height);
                _noToyImgView.frame=CGRectMake((SCREENWIDTH-0.77*height)/2,0, 0.77*height,height);
                
            }else{
                _emptyView.frame = CGRectMake(0,75, SCREENWIDTH, SCREENHEIGHT-75-47-70);
                float height = SCREENHEIGHT-75-47-44-60-15;
                NSLog(@"hccccchhhhhhh = %f",height);
                _noToyImgView.frame=CGRectMake((SCREENWIDTH-0.77*height)/2,0, 0.77*height,height);
            }
            

        }else{
            if (ISIPhoneX) {
                image = [UIImage imageNamed:@"img_no_toy_car"];
                _emptyView.frame = CGRectMake(0,44, SCREENWIDTH, SCREENHEIGHT-44-47-60-90);
                //_emptyView.backgroundColor = [UIColor redColor];
                float height = SCREENHEIGHT-44-47-60-90;
                _noToyImgView.frame=CGRectMake((SCREENWIDTH-0.8*height)/2,0, 0.8*height, height);
                
            }else{
                image = [UIImage imageNamed:@"img_no_toy_car"];
                _emptyView.frame = CGRectMake(0,44, SCREENWIDTH, SCREENHEIGHT-44-47-60);
                _noToyImgView.frame=CGRectMake(0,0, SCREENWIDTH, SCREENHEIGHT-44-47-44-60);
            }

        }
        _noToyImgView.image = image;

        return;
    }else{
        _emptyView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _emptyView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_emptyView];
        _noToyImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-44-47)];
        [_emptyView addSubview:_noToyImgView];
        _noToyImgView.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped)];
        [_noToyImgView addGestureRecognizer:singleTap];
        
        if (_inTheViewData == 2003) {
            image = [UIImage imageNamed:@"img_no_toyorder"];
            if (ISIPhoneX) {
                _emptyView.frame = CGRectMake(0,75, SCREENWIDTH, SCREENHEIGHT-75-64-51-32-21);
                float height = SCREENHEIGHT-75-64-51-32-21;
                NSLog(@"hccccchhhhhhh = %f",height);
                _noToyImgView.frame=CGRectMake((SCREENWIDTH-0.77*height)/2,0, 0.77*height,height);

            }else{
            _emptyView.frame = CGRectMake(0,75, SCREENWIDTH, SCREENHEIGHT-75-47-70);
            float height = SCREENHEIGHT-75-47-44-60-15;
            NSLog(@"hccccchhhhhhh = %f",height);
            _noToyImgView.frame=CGRectMake((SCREENWIDTH-0.77*height)/2,0, 0.77*height,height);
            }

        }else{
            if (ISIPhoneX) {
                image = [UIImage imageNamed:@"img_no_toy_car"];
                _emptyView.frame = CGRectMake(0,44, SCREENWIDTH, SCREENHEIGHT-44-47-60-90);
                //_emptyView.backgroundColor = [UIColor redColor];
                float height = SCREENHEIGHT-44-47-60-90;
                _noToyImgView.frame=CGRectMake((SCREENWIDTH-0.8*height)/2,0, 0.8*height, height);

            }else{
            image = [UIImage imageNamed:@"img_no_toy_car"];
            _emptyView.frame = CGRectMake(0,44, SCREENWIDTH, SCREENHEIGHT-44-47-60);
            _noToyImgView.frame=CGRectMake(0,0, SCREENWIDTH, SCREENHEIGHT-44-47-44-60);
            }

        }
        _noToyImgView.image = image;
    }

    [self.view bringSubviewToFront:_shareRequestFriendBtn];


}
-(void)addEmptySelectView{
    if (_emptyNoToyView) {
        return;
    }else{
        _emptyNoToyView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _emptyNoToyView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
        _emptyNoToyView.frame = CGRectMake(0,self.navSearchView.frame.size.height+self.navSearchView.frame.origin.y+34, SCREENWIDTH, SCREENHEIGHT-44-(self.navSearchView.frame.size.height+self.navSearchView.frame.origin.y+34));
        
        UIImage *image = [UIImage imageNamed:@"toy_no_result@3x"];
        _noToySelectImgView =[[UIImageView alloc]initWithImage:image];
        _noToySelectImgView.frame=CGRectMake((SCREENWIDTH-232)/2,(SCREENHEIGHT-100-44-232)/2, 232, 232);
        [_noToySelectImgView setContentMode:UIViewContentModeScaleAspectFill];
        _noToySelectImgView.clipsToBounds = YES;
        [_emptyNoToyView addSubview:_noToySelectImgView];
        _noToySelectImgView.userInteractionEnabled = YES;
        [self.view addSubview:_emptyNoToyView];
    }
    

}
-(void)fingerTapped{
    _inTheViewData = 2001;
    [self changeData:2001];
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

#pragma mark- refreshControl

-(void)refreshControlInit{
    _refreshControl                             = [[RefreshControl alloc] initWithScrollView:_tableView delegate:self];
    _refreshControl.topEnabled                  = YES;
    _refreshControl.bottomEnabled               = NO;
    [_refreshControl startRefreshingDirection:RefreshDirectionTop];
    
    
}
-(void)refreshCollectviewInit{
    _refreshControlCollectionview                             = [[RefreshControl alloc] initWithScrollView:_collectionView delegate:self];
    _refreshControlCollectionview.topEnabled                  = YES;
    _refreshControlCollectionview.bottomEnabled               = NO;
    [_refreshControlCollectionview startRefreshingDirection:RefreshDirectionTop];

}
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    if (refreshControl == _refreshControl) {
        if (direction == RefreshDirectionTop) {
            if (_inTheViewData == 2001) {
                _post_create_time  = NULL;
                [self getBannarData];
            }else if (_inTheViewData == 2003){
                _post_create_timeOrder = NULL;
            }else if (_inTheViewData == 2004){
                _post_create_carToy = NULL;
            }
        }
        if (_inTheViewData == 2001) {
            [self getListData];

        }else if (_inTheViewData == 2003){
            [self getOrderListData];
        }else if (_inTheViewData == 2004){
            [self getToyCarListData];
        }
    }else if (refreshControl == _refreshControlCollectionview){
        if (direction == RefreshDirectionTop) {
            if (_inTheViewData == 2002) {
                _post_create_timeToy = NULL;
            }
        }
        if (_inTheViewData == 2002) {
            [self getToyListData:0];
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
#pragma mark 实现collectionview的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return  [_toydataArray count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //注册cell
    //注册cell
    [collectionView registerClass:[ToyAllListCell class] forCellWithReuseIdentifier:@"ToyAllListCell"];
    ToyAllListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ToyAllListCell" forIndexPath:indexPath];
    ToyLeaseItem *item = [_toydataArray objectAtIndex:indexPath.row];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    if (item.img_thumb.length >0) {
        [cell.toyPicImg sd_setImageWithURL:[NSURL URLWithString:item.img_thumb]];
    }else{
        cell.toyPicImg.image = [UIImage imageNamed:@"img_message_photo"];
    }
    cell.toyNameLabel.text = item.business_title;
    NSLog(@"jihe jibe = %ld,item.business_title = %@",indexPath.row,item.business_title);
    if (indexPath.row == 0 || indexPath.row == 1) {
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 1)];
            lineView1.backgroundColor = [BBSColor hexStringToColor:@"05f5f5"];
            //[cell.contentView addSubview:lineView1];

    }


    NSMutableAttributedString *makeString1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",item.sell_price,item.unit_name]];
    [makeString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, item.sell_price.length)];
    [makeString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(item.sell_price.length, item.unit_name.length)];

    cell.priceLabel.attributedText = makeString1;
    NSString *string = [NSString stringWithFormat:@"%@%@",item.sell_price,item.unit_name];
    float widthPrice = [self getTitleWidth:string fontSize:11];
    
    cell.markImg.hidden = YES;
    if (item.size_img_thumb.length > 0) {
        cell.markImg.hidden = NO;
        cell.markImg.frame = CGRectMake(10+widthPrice, cell.priceLabel.frame.origin.y, 14, 14);
        [cell.markImg sd_setImageWithURL:[NSURL URLWithString:item.size_img_thumb]];
    }else{
        cell.markImg.hidden = YES;
    }
    cell.ageLabel.text = item.age;
    
    
    return cell;//为什么我的成长记录没有他们那种的红色标记
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ToyLeaseItem *item = [_toydataArray objectAtIndex:indexPath.row];
    ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
    toyDetailVC.business_id = item.business_id;
    [self.navigationController pushViewController:toyDetailVC animated:YES];
    
    
}
//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/2,(SCREEN_WIDTH/2)*1.1);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


#pragma mark  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_inTheViewData == 2001) {
        return [_dataArray count];
    }else if (_inTheViewData == 2002){
        return [_toydataArray count];
    }else if(_inTheViewData == 2003){
        NSArray *singArray = [_orderdataArray objectAtIndex:section];
        return [singArray count];
    }else if (_inTheViewData == 2004){
        if (_isDeleteToyCar == YES) {
            NSArray *singleDeleteArray = [_toyCarCanDeleteToyArray objectAtIndex:section];
            return [singleDeleteArray count];
        }else{
        NSArray *singArray = [_toyCarDataArray objectAtIndex:section];
        return [singArray count];
        }
    }
    return 0;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_inTheViewData == 2001) {
        return 1;
    }else if (_inTheViewData == 2002){
        return 1;
    }else if(_inTheViewData == 2003){
        return _orderdataArray.count;
    }else if (_inTheViewData == 2004){
        if (_isDeleteToyCar == YES) {
            return _toyCarCanDeleteToyArray.count;
        }else{
        return _toyCarDataArray.count;
        }
    }
    return 0;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_inTheViewData == 2001) {
        ToyListItem1 *item = [_dataArray objectAtIndex:indexPath.row];
        if([item.show_type isEqualToString:@"1"]){
        
            if (indexPath.row == _dataArray.count-1) {
                return 118;
            }else{
           return 118+13;
            }

        }else if ([item.show_type isEqualToString:@"2"]){
            return SCREEN_WIDTH/3*1.3+34+13;
        }else if ([item.show_type isEqualToString:@"3"]){
            return SCREENWIDTH*0.52+34+13+28;
        }else if ([item.show_type isEqualToString:@"4"]){
           return  SCREENWIDTH*0.52+34+13;
        }
    }else if (_inTheViewData == 2002){
        return 122;
    }else if(_inTheViewData == 2003){
        NSArray *singArray = [_orderdataArray objectAtIndex:indexPath.section];
            if (singArray.count == 1 && indexPath.section != 0) {
                return 0;
            }else{
        ToyCarMainItem *item = [singArray objectAtIndex:indexPath.row];
        return item.cellHeight;
            }
        
    }else if (_inTheViewData == 2004){
        if (_isDeleteToyCar == YES) {
            NSArray *singleArray = [_toyCarCanDeleteToyArray objectAtIndex:indexPath.section];
            ToyCarMainItem *item = [singleArray objectAtIndex:indexPath.row];
            return item.cellHeight;
        }else{
        NSArray *singleArray = [_toyCarDataArray objectAtIndex:indexPath.section];
        ToyCarMainItem *item = [singleArray objectAtIndex:indexPath.row];
        return item.cellHeight;
        }
    }
    return 0;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableViewCell;
    //购物车
    if (_inTheViewData == 2004) {
        NSArray *singleArray;
        if (_isDeleteToyCar == YES) {
            singleArray = [_toyCarCanDeleteToyArray objectAtIndex:indexPath.section];
           }else{
            singleArray = [_toyCarDataArray objectAtIndex:indexPath.section];
        }
        ToyCarMainItem *item = [singleArray objectAtIndex:indexPath.row];
        if ([item isKindOfClass:[ToyCarHeadItem class]]){
            ToyCarHeadItem *headItem = (ToyCarHeadItem*)item;
            if ([headItem.type isEqualToString:@"1"]) {
                NSString *identifier = [NSString stringWithFormat:@"TOYCARGEADCELL"];
                ToyCarHeadCell *toyCell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!toyCell) {
                    toyCell = [[ToyCarHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                toyCell.backView.frame = CGRectMake(0, 0, SCREENWIDTH, item.cellHeight);
                toyCell.lineView.frame = CGRectMake(0, item.cellHeight, SCREENWIDTH, 1);
                toyCell.selectionName.text = headItem.toys_title;
                toyCell.selectionName.frame = CGRectMake(15, 10, 300, item.cellHeight-20);
                toyCell.selectionStyle = UITableViewCellSelectionStyleNone;
                tableViewCell = toyCell;
            }else {
                NSString *identifier = [NSString stringWithFormat:@"TOYCARDETAILCELLLINE"];
                LineViewCell *toyCell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!toyCell) {
                    toyCell = [[LineViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                toyCell.selectionStyle = UITableViewCellSelectionStyleNone;
                tableViewCell = toyCell;
              }
        }else if([item isKindOfClass:[ToyMessDetailItem class]]){
            ToyMessDetailItem *toyItem = (ToyMessDetailItem*)item;
            NSString *identifier = [NSString stringWithFormat:@"TOYMESSDETAILCELL"];
            ToyMessDetailCell *toyCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!toyCell) {
                toyCell = [[ToyMessDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            if (toyItem.img_thumb.length >0) {
                [toyCell.photoView sd_setImageWithURL:[NSURL URLWithString:toyItem.img_thumb]];
            }else{
                toyCell.photoView.image = [UIImage imageNamed:@"img_message_photo"];
            }
            if (_isDeleteToyCar == YES) {
                //购物车删除的时候的状态

                if (_isSelectAll == YES) {
                [toyCell.selectBtn setImage:[UIImage imageNamed:@"toy_car_buy_select"] forState:UIControlStateNormal];
                }else{
                [toyCell.selectBtn setImage:[UIImage imageNamed:@"toy_car_buy_unselect"] forState:UIControlStateNormal];
                }
            }else{
            //勾选上的状态，非购物车状态上的点击
            if ([toyItem.check_state isEqualToString:@"1"]) {
                [toyCell.selectBtn setImage:[UIImage imageNamed:@"toy_car_buy_select"] forState:UIControlStateNormal];
            }else{
                [toyCell.selectBtn setImage:[UIImage imageNamed:@"toy_car_buy_unselect"] forState:UIControlStateNormal];
            }
            }
            toyCell.delegate = self;
            toyCell.selectBtn.tag = indexPath.section;
            CGFloat height = [self getHeightByWidth:  SCREEN_WIDTH-16-44-50-10-80 title:toyItem.business_title font:[UIFont systemFontOfSize:13]];
            toyCell.toyNameLabel.frame = CGRectMake(toyCell.toyNameLabel.frame.origin.x, toyCell.toyNameLabel.frame.origin.y,   SCREEN_WIDTH-16-44-50-10-80, 33);
            
            height = 33;
            toyCell.toyNameLabel.text = toyItem.business_title;
            //有库存
            if ([toyItem.is_order isEqualToString:@"0"]) {
                toyCell.decLabel.text = toyItem.descriptionOrder;
                toyCell.decLabel.textColor = [BBSColor hexStringToColor:@"fd6363"];
                
            }else{
                toyCell.decLabel.text = toyItem.descriptionOrder;
                toyCell.decLabel.textColor = [BBSColor hexStringToColor:@"9d9d9d"];
            }
            toyCell.decLabel.frame = CGRectMake(toyCell.decLabel.frame.origin.x, toyCell.toyNameLabel.frame.origin.y+height, SCREEN_WIDTH-16-44-50-10-80, 20);
            if (toyItem.smallImgThumb.length > 0) {
                toyCell.vipImgview.hidden = NO;
                UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:toyItem.smallImgThumb]]];
                [toyCell.vipImgview setImage:img forState:UIControlStateNormal];
                [toyCell.vipImgview addTarget:self action:@selector(clickToBigPic) forControlEvents:UIControlEventTouchUpInside];
            }else{
                toyCell.vipImgview.hidden = YES;
            }
            toyCell.priceLabel.text = toyItem.every_price;
            toyCell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableViewCell = toyCell;
        }

    }else if (_inTheViewData == 2001) {
         ToyListItem1 *item = [_dataArray objectAtIndex:indexPath.row];
        ToyLIstClassItem *classItem1;
        ToyLIstClassItem *classItem2;
        ToyLIstClassItem *classItem3;
        ToyLIstClassItem *classItem4;
        
        if ([item.show_type isEqualToString:@"1"]) {
            //一张图
            NSString *identifierStyle4 = [NSString stringWithFormat:@"ToyFourStyleCell"];
            ToyFourStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStyle4];
            if (!cell) {
                cell = [[ToyFourStyleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStyle4];
            }
            classItem1 = item.business_info[0];
            [cell.storeImg  sd_setImageWithURL:[NSURL URLWithString:classItem1.business_pic]];
            cell.storeImg.userInteractionEnabled = YES;
            cell.storeImg.tag = indexPath.row;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushSinglePic:)];
            [cell.storeImg addGestureRecognizer:singleTap];
            tableViewCell = cell;

        }else if ([item.show_type isEqualToString:@"2"]){
            //三图并列
            classItem1 = item.business_info[0];
            classItem2 = item.business_info[1];
            classItem3 = item.business_info[2];
            NSString *identifier = [NSString stringWithFormat:@"TOYLEASENEWVC"];
            ToyListNewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ToyListNewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                
            }
            cell.selectionName.text = item.class_title;
            
            NSString *moretitle = [NSString stringWithFormat:@"%@",item.class_more_title];
            cell.moreLabel.text = moretitle;
            
            cell.moreButton.tag = indexPath.row;
            [cell.moreButton addTarget:self action:@selector(pushMoreDetail:) forControlEvents:UIControlEventTouchUpInside];
            //下面的三图基本排列
            //第一组
            cell.toyNameLabel1.text = classItem1.business_title_ios16;
            [cell.storeImg1 sd_setImageWithURL:[NSURL URLWithString:classItem1.business_pic]];
            NSMutableAttributedString *makeString1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",classItem1.sell_price,classItem1.unit_name]];
            [makeString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, classItem1.sell_price.length-1)];
            [makeString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(classItem1.sell_price.length, classItem1.unit_name.length)];
            
            cell.priceShow1.attributedText = makeString1;
            
            //第二组
            cell.toyNameLabel2.text = classItem2.business_title_ios16;
            [cell.storeImg2 sd_setImageWithURL:[NSURL URLWithString:classItem2.business_pic]];

            NSMutableAttributedString *makeString = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",classItem2.sell_price,classItem2.unit_name]];
            [makeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, classItem2.sell_price.length-1)];
            [makeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(classItem2.sell_price.length, classItem2.unit_name.length)];
            cell.priceShow2.attributedText = makeString;
            

            //第三组
            cell.toyNameLabel3.text = classItem3.business_title_ios16;
            [cell.storeImg3 sd_setImageWithURL:[NSURL URLWithString:classItem3.business_pic]];
            NSMutableAttributedString *makeString3 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",classItem3.sell_price,classItem3.unit_name]];
            [makeString3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, classItem3.sell_price.length-1)];
            [makeString3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(classItem3.sell_price.length, classItem3.unit_name.length)];
            cell.priceShow3.attributedText = makeString3;
            cell.toyView1.tag = indexPath.row;
            [cell.toyView1 addTarget:self action:@selector(pushSinglePic:) forControlEvents:UIControlEventTouchUpInside];
            cell.storeImg1.tag = indexPath.row;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushSinglePic:)];
            [cell.storeImg1 addGestureRecognizer:singleTap];
            //第二个
            cell.toyView2.tag = indexPath.row;
            UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushSecondPic:)];
            [cell.toyView2 addGestureRecognizer:singleTap2];
            cell.storeImg2.userInteractionEnabled = YES;
            
            //第三个
            cell.toyView3.tag = indexPath.row;
            UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushThirdPic:)];
            [cell.toyView3 addGestureRecognizer:singleTap3];
            cell.storeImg3.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableViewCell = cell;

        }else if ([item.show_type isEqualToString:@"3"]){
            //一拖三
            classItem1 = item.business_info[0];
            classItem2 = item.business_info[1];
            classItem3 = item.business_info[2];
            classItem4 = item.business_info[3];
            NSString *identifierStyle2 = [NSString stringWithFormat:@"ToySecondStyleCell"];
            ToySecondStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStyle2];
            if (!cell) {
                cell = [[ToySecondStyleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStyle2];
            }
            cell.selectionName.text = item.class_title;
            
            NSString *moretitle = [NSString stringWithFormat:@"%@",item.class_more_title];
            cell.moreLabel.text = moretitle;
            
            cell.moreButton.tag = indexPath.row;
            [cell.moreButton addTarget:self action:@selector(pushMoreDetail:) forControlEvents:UIControlEventTouchUpInside];
            
           //一拖三左边大图
            //1
            cell.toyNameLabel1.text = classItem1.business_title;
            [cell.storeImg1 sd_setImageWithURL:[NSURL URLWithString:classItem1.business_pic]];
            NSMutableAttributedString *makeString1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",classItem1.sell_price,classItem1.unit_name]];
            [makeString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, classItem1.sell_price.length-1)];
            [makeString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(classItem1.sell_price.length, classItem1.unit_name.length)];
            cell.priceShow1.attributedText = makeString1;

            //2
            cell.toyNameLabel2.text = classItem2.business_title;
            [cell.storeImg2 sd_setImageWithURL:[NSURL URLWithString:classItem2.business_pic]];
            NSMutableAttributedString *makeString2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",classItem2.sell_price,classItem2.unit_name]];
            [makeString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, classItem2.sell_price.length-1)];
            [makeString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(classItem2.sell_price.length, classItem2.unit_name.length)];
            cell.priceShow2.attributedText = makeString2;
           

            
            //3
            cell.toyNameLabel3.text = classItem3.business_title_ios14;

            [cell.storeImg3 sd_setImageWithURL:[NSURL URLWithString:classItem3.business_pic]];
            NSMutableAttributedString *makeString3 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",classItem3.sell_price,classItem3.unit_name]];
            [makeString3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, classItem3.sell_price.length-1)];
            [makeString3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(classItem3.sell_price.length, classItem3.unit_name.length)];
            cell.priceShow3.attributedText = makeString3;

            //4
            cell.toyNameLabel4.text = classItem4.business_title_ios14;
            [cell.storeImg4 sd_setImageWithURL:[NSURL URLWithString:classItem4.business_pic]];
            NSMutableAttributedString *makeString4 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",classItem4.sell_price,classItem4.unit_name]];
            [makeString4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, classItem4.sell_price.length-1)];
            [makeString4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(classItem4.sell_price.length, classItem4.unit_name.length)];
            cell.priceShow4.attributedText = makeString4;

//1
            cell.toyView1.tag = indexPath.row;
            UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushSinglePic:)];
            [cell.toyView1 addGestureRecognizer:singleTap1];
            cell.storeImg1.userInteractionEnabled = YES;
            
            //2
            cell.toyView2.tag = indexPath.row;
            UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushSecondPic:)];
            [cell.toyView2 addGestureRecognizer:singleTap2];
            cell.storeImg2.userInteractionEnabled = YES;
                         //3
            cell.toyView3.tag = indexPath.row;
            UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushThirdPic:)];
            [cell.toyView3 addGestureRecognizer:singleTap3];
            cell.storeImg3.userInteractionEnabled = YES;
            //4
            cell.toyView4.tag = indexPath.row;
            UITapGestureRecognizer *singleTap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushFourPic:)];
            [cell.toyView4 addGestureRecognizer:singleTap4];
            cell.storeImg4.userInteractionEnabled = YES;


            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            tableViewCell = cell;
            
        }else if ([item.show_type isEqualToString:@"4"]){
            //四图并行
            classItem1 = item.business_info[0];
            classItem2 = item.business_info[1];
            classItem3 = item.business_info[2];
            classItem4 = item.business_info[3];
            NSString *identifierStyle3 = [NSString stringWithFormat:@"ToyThridStyleCell"];
            ToyThridStyleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierStyle3];
            if (!cell) {
                cell = [[ToyThridStyleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierStyle3];
            }
            cell.selectionName.text = item.class_title;
            
            NSString *moretitle = [NSString stringWithFormat:@"%@",item.class_more_title];
            cell.moreLabel.text = moretitle;
            
            cell.moreButton.tag = indexPath.row;
            [cell.moreButton addTarget:self action:@selector(pushMoreDetail:) forControlEvents:UIControlEventTouchUpInside];
            //1
            cell.toyNameLabel1.text = classItem1.business_title;
            [cell.storeImg1 sd_setImageWithURL:[NSURL URLWithString:classItem1.business_pic]];
            
            NSMutableAttributedString *makeString1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",classItem1.sell_price,classItem1.unit_name]];
            [makeString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, classItem1.sell_price.length-1)];
            [makeString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(classItem1.sell_price.length, classItem1.unit_name.length)];
            cell.priceShow1.attributedText = makeString1;

            //2
            cell.toyNameLabel2.text = classItem2.business_title;
            [cell.storeImg2 sd_setImageWithURL:[NSURL URLWithString:classItem2.business_pic]];
            NSMutableAttributedString *makeString2 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",classItem2.sell_price,classItem2.unit_name]];
            [makeString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, classItem2.sell_price.length-1)];
            [makeString2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(classItem2.sell_price.length, classItem2.unit_name.length)];
            cell.priceShow2.attributedText = makeString2;
            
            //3
            cell.toyNameLabel3.text = classItem3.business_title;
            [cell.storeImg3 sd_setImageWithURL:[NSURL URLWithString:classItem3.business_pic]];
            NSMutableAttributedString *makeString3 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",classItem3.sell_price,classItem3.unit_name]];
            [makeString3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, classItem3.sell_price.length-1)];
            [makeString3 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(classItem3.sell_price.length, classItem3.unit_name.length)];
            cell.priceShow3.attributedText = makeString3;

            //4
            cell.toyNameLabel4.text = classItem4.business_title;
            [cell.storeImg4 sd_setImageWithURL:[NSURL URLWithString:classItem4.business_pic]];
            NSMutableAttributedString *makeString4 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",classItem4.sell_price,classItem4.unit_name]];
            [makeString4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, classItem4.sell_price.length-1)];
            [makeString4 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(classItem4.sell_price.length, classItem4.unit_name.length)];
            cell.priceShow4.attributedText = makeString4;

            //1
            cell.toyView1.tag = indexPath.row;
            UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushSinglePic:)];
            [cell.toyView1 addGestureRecognizer:singleTap1];
            cell.storeImg1.userInteractionEnabled = YES;
            //2
            cell.toyView2.tag = indexPath.row;
            UITapGestureRecognizer *singleTap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushSecondPic:)];
            [cell.toyView2 addGestureRecognizer:singleTap2];
            cell.storeImg2.userInteractionEnabled = YES;
            //3
            cell.toyView3.tag = indexPath.row;
            UITapGestureRecognizer *singleTap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushThirdPic:)];
            [cell.toyView3 addGestureRecognizer:singleTap3];
            cell.storeImg3.userInteractionEnabled = YES;
            //4
            cell.toyView4.tag = indexPath.row;
            UITapGestureRecognizer *singleTap4 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushFourPic:)];
            [cell.toyView4 addGestureRecognizer:singleTap4];
            cell.storeImg4.userInteractionEnabled = YES;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableViewCell = cell;
            
        }

    }else if (_inTheViewData == 2002){
        NSString *identifier = [NSString stringWithFormat:@"TOYLEASELISTCELL"];
        ToyLeaseListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[ToyLeaseListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        ToyLeaseItem *item = [_toydataArray objectAtIndex:indexPath.row];
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        if (item.img_thumb.length >0) {
            [cell.photoView sd_setImageWithURL:[NSURL URLWithString:item.img_thumb]];
        }else{
            cell.photoView.image = [UIImage imageNamed:@"img_message_photo"];
        }
        if (item.size_img_thumb.length > 0) {
            cell.toyImg.hidden = NO;
            [cell.toyImg sd_setImageWithURL:[NSURL URLWithString:item.size_img_thumb]];
        }else{
            cell.toyImg.hidden = YES;
        }

        cell.smallToyMark.hidden = YES;
        CGFloat height = [self getHeightByWidth:SCREENWIDTH-157 title:item.business_title font:[UIFont systemFontOfSize:16]];
        cell.toyNameLabel.frame = CGRectMake(cell.toyNameLabel.frame.origin.x, cell.toyNameLabel.frame.origin.y, SCREENWIDTH-157, height);
        cell.toyNameLabel.text = item.business_title;
        cell.toyNameLabel.lineBreakMode = UILineBreakModeWordWrap;

        [manager downloadImageWithURL:[NSURL URLWithString:item.avatar] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            //cell.userImg.image = image;
        }];
        cell.userImg.frame = CGRectMake(cell.toyNameLabel.frame.origin.x, cell.toyNameLabel.frame.origin.y+cell.toyNameLabel.frame.size.height+4, 15,15);
        cell.userNameLabel.frame = CGRectMake(cell.userImg.frame.origin.x+cell.userImg.frame.size.width+5, cell.userImg.frame.origin.y, 170, 15);
        
        cell.userNameLabel.text = item.user_name;
        cell.explainLabel.text = item.support_name;
        
       // 玩具租状态(0可租、1预约、2取消预约、3不显示【例如：即将上新】)

        if ([item.is_order isEqualToString:@"0"]) {
            cell.addCarBtn.hidden = NO;
            cell.addCarBtn.enabled = YES;
            cell.addCarBtn.adjustsImageWhenDisabled = NO;
            [cell.addCarBtn setBackgroundImage:[UIImage imageNamed:@"add_car"] forState:UIControlStateNormal];
            cell.addCarBtn.tag = indexPath.row;
            cell.addCars = ^(UIImageView *toyImgView){
                UserInfoManager *manager=[[UserInfoManager alloc]init];
                UserInfoItem *userItem=[manager currentUserInfo];
                if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
                    LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
                    [self presentViewController:nav animated:YES completion:^{
                    }];
                    return;
                }else{
                    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",item.business_id,@"business_id", nil];
                    [[HTTPClient sharedClient]getNewV1:@"publicToysCart" params:param success:^(NSDictionary *result) {
                        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                            NSDictionary *data = result[@"data"];
                            NSString *isCart = data[@"is_cart"];
                            NSString *cateName = data[@"cart_name"];
                            NSString *toyCount = data[@"cart_number"];
                            item.is_cart = isCart;
                            [self refreshCellSection:0 row:indexPath.row];
                            if ([toyCount isEqualToString:@"0"]) {
                                _badgeValueLabel.hidden = YES;
                            }else{
                                _badgeValueLabel.text = data[@"cart_number"];
                                _badgeValueLabel.hidden = NO;
                            }
                            CGRect rect = [tableView rectForRowAtIndexPath:indexPath];
                            //获取当前cell 相对于self.view 当前的坐标
                            rect.origin.y = rect.origin.y - [tableView contentOffset].y;
                            CGRect imageViewRect = toyImgView.frame;
                            imageViewRect.origin.y = rect.origin.y+imageViewRect.origin.y+55;
                            [[PurchaseCarAnimationTool shareTool]startAnimationandView:toyImgView andRect:imageViewRect andFinisnRect:CGPointMake(SCREENWIDTH/4*2.5, SCREENHEIGHT-49) andFinishBlock:^(BOOL finisn){
                                [BBSAlert showAlertWithContent:cateName andDelegate:self andDismissAnimated:2];
                            }];
                        }else{
                            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
                        }
                    } failed:^(NSError *error) {
                        [BBSAlert showAlertWithContent:@"您似乎与网络断开，检查一下吧" andDelegate:nil];
                    }];

                }
            };
        }else if([item.is_order isEqualToString:@"1"]){
            cell.addCarBtn.hidden = NO;
            cell.addCarBtn.enabled = YES;
            cell.addCarBtn.adjustsImageWhenDisabled = NO;
            [cell.addCarBtn setBackgroundImage:[UIImage imageNamed:@"toy_book_btn"] forState:UIControlStateNormal];
            cell.addCarBtn.tag = indexPath.row;
            cell.addCars = ^(UIImageView *toyImgView){
                UserInfoManager *manager=[[UserInfoManager alloc]init];
                UserInfoItem *userItem=[manager currentUserInfo];
                if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
                    LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
                    [self presentViewController:nav animated:YES completion:^{
                    }];
                    return;
                }else{
                    [self sureBookOrCancelToy:YES item:item row:indexPath.row];
                }
            };//车
        }else if ([item.is_order isEqualToString:@"2"]){
            //玩具取消
            cell.addCarBtn.hidden = NO;
            cell.addCarBtn.enabled = YES;
            cell.addCarBtn.adjustsImageWhenDisabled = NO;
            [cell.addCarBtn setBackgroundImage:[UIImage imageNamed:@"toy_cancle_book_btn"] forState:UIControlStateNormal];
            cell.addCarBtn.tag = indexPath.row;
            cell.addCars = ^(UIImageView *toyImgView){
                UserInfoManager *manager=[[UserInfoManager alloc]init];
                UserInfoItem *userItem=[manager currentUserInfo];
                if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
                    LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
                    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
                    [self presentViewController:nav animated:YES completion:^{
                    }];
                    return;
                }else{
                    [self sureBookOrCancelToy:NO item:item row:indexPath.row];

                }
            };

            
        }else{
            cell.addCarBtn.hidden = YES;
        }
        
        cell.priceLabel.text = item.sell_price;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        tableViewCell = cell;

    }else if (_inTheViewData == 2003){
        //订单
//        if (indexPath.section<0) {
//            NSArray *singleArray = [_orderdataArray objectAtIndex:0];
//            ToyCarMainItem *mainItem = [singleArray objectAtIndex:indexPath.row];
//            ToyOrderItem *item1 = (ToyOrderItem*)mainItem;
//
//            NSArray *secondArray = [_orderdataArray objectAtIndex:1];
//            ToyCarMainItem *mainItem2 = [secondArray objectAtIndex:indexPath.row];
//            ToyOrderItem *item2 = (ToyOrderItem*)mainItem2;
//
//            NSString *identifier = [NSString stringWithFormat:@"TOYDEPOSITCELL"];
//            ToyDepositCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//            if (!cell) {
//                cell = [[ToyDepositCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//            }
//            cell.titleLabel.text = item1.business_title;
//            cell.moneyLabel.text = item1.sell_price;
//            self.myDepositOrderID = item1.order_id;
//            self.myBookId = item2.order_id;
//            [cell.photoImgView addTarget:self action:@selector(pushMyDepostitVC:) forControlEvents:UIControlEventTouchUpInside];
//
//            cell.titleToyBookLabel.text = item2.business_title;
//            cell.countBookLabel.text = item2.sell_price;
//            [cell.photoToyBookImgView addTarget:self action:@selector(pushMyBookingToys) forControlEvents:UIControlEventTouchUpInside];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            cell.photoImgView.adjustsImageWhenHighlighted = NO;
//            cell.photoToyBookImgView.adjustsImageWhenHighlighted = NO;
//            tableViewCell = cell;
//
//
//        }else
        
            NSArray *singleArray = [_orderdataArray objectAtIndex:indexPath.section];

            if (singleArray.count<=1) {
                NSString *identifier = [NSString stringWithFormat:@"TOYDEPOSITCELLLIST"];
                ToyDepositCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!cell) {
                    cell = [[ToyDepositCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                tableViewCell = cell;

            }else{
        ToyCarMainItem *mainItem = [singleArray objectAtIndex:indexPath.row];
        if ([mainItem isKindOfClass:[ToyOrderNumberItem class]]) {
            ToyOrderNumberItem *item = (ToyOrderNumberItem*)mainItem;
            NSString *identifier = [NSString stringWithFormat:@"TOYORDERNUMBERCELL"];
            ToyOrderNumberCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ToyOrderNumberCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.toyNumberLabel.text = item.orderNumberString;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableViewCell = cell;
        }else if ([mainItem isKindOfClass:[ToyOrderItem class]]){
        ToyOrderItem *item = (ToyOrderItem*)mainItem;
        if ([item.order_status isEqualToString:@"1"]) {
            NSString *identifier = [NSString stringWithFormat:@"TOYDEPOSITCELL"];
            ToyDepositCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ToyDepositCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.titleLabel.text = item.business_title;
            cell.moneyLabel.text = item.sell_price;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableViewCell = cell;
        }else {
            NSString *identifier = [NSString stringWithFormat:@"TOYORDERLISTCELL"];
            ToyOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ToyOrderListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
                if ([item.order_status isEqualToString:@"2"]) {
                    if ([item.is_prize_status isEqualToString:@"1"]) {
                        cell.photoView.frame = CGRectMake(10, 10, 77, 77);
                        [cell.photoView sd_setImageWithURL:[NSURL URLWithString:item.img_thumb]];
                        [cell.photoView setContentMode:UIViewContentModeScaleAspectFill];

                    }else{
                    cell.photoView.frame = CGRectMake(10, 20, 77, 53);
                    [cell.photoView sd_setImageWithURL:[NSURL URLWithString:item.img_thumb]];
                    [cell.photoView setContentMode:UIViewContentModeScaleAspectFit];
                    }

                }else{
                    cell.photoView.frame = CGRectMake(10, 10, 77, 77);
                    [cell.photoView setContentMode:UIViewContentModeScaleAspectFill];

                   [cell.photoView sd_setImageWithURL:[NSURL URLWithString:item.img_thumb]];
                }
                
            if (item.size_img_thumb.length > 0) {
                cell.smallToyMark.hidden = NO;
                [cell.smallToyMark sd_setImageWithURL:[NSURL URLWithString:item.size_img_thumb]];
            }else{
                cell.smallToyMark.hidden = YES;
            }
            CGFloat height = [self getHeightByWidth:SCREENWIDTH-160 title:item.business_title font:[UIFont systemFontOfSize:14]];
            cell.toyNameLabel.frame = CGRectMake(cell.toyNameLabel.frame.origin.x, cell.toyNameLabel.frame.origin.y, SCREENWIDTH-160, height);
            cell.toyNameLabel.text = item.business_title;
            cell.toyNameLabel.lineBreakMode = UILineBreakModeWordWrap;

            cell.userNameLabel.frame = CGRectMake(cell.toyNameLabel.frame.origin.x, cell.toyNameLabel.frame.origin.y+cell.toyNameLabel.frame.size.height+4, 150, 15);
            
            NSString *statusString = [NSString stringWithFormat:@"%@ %@",item.status_name,item.day_title];
            cell.userNameLabel.text = statusString;
            cell.priceLabel.text = item.sell_price;
            cell.userNameLabel.font = [UIFont systemFontOfSize:12];
            cell.userNameLabel.textColor = [BBSColor hexStringToColor:@"F08556"];
            if ([item.is_del isEqualToString:@"0"]) {
                cell.delelBtn.hidden = YES;
                //删除按钮
            }else{
                cell.delelBtn.hidden = NO;
                cell.delelBtn.tag = indexPath.row;
                [cell.delelBtn setBackgroundImage:[UIImage imageNamed:@"toy_dele_samll"] forState:UIControlStateNormal];
                [cell.delelBtn addTarget:self action:@selector(deleOrder:) forControlEvents:UIControlEventTouchUpInside];
            }
            if ([item.is_reset isEqualToString:@"0"]) {
                //支付按钮不显示
                cell.moreLeaseBtn.hidden = YES;
            }else if ([item.is_reset isEqualToString:@"1"]){
                //再租一次
                cell.moreLeaseBtn.hidden = NO;
                cell.moreLeaseBtn.tag = indexPath.row;
                [cell.moreLeaseBtn setBackgroundImage:[UIImage imageNamed:@"toy_moreBuy_small"] forState:UIControlStateNormal];
                [cell.moreLeaseBtn addTarget:self action:@selector(moreOder:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                //去支付
                cell.moreLeaseBtn.hidden = NO;
                cell.moreLeaseBtn.tag = indexPath.row;
                [cell.moreLeaseBtn setBackgroundImage:[UIImage imageNamed:@"toy_pay_small"] forState:UIControlStateNormal];
                [cell.moreLeaseBtn addTarget:self action:@selector(moreOder:) forControlEvents:UIControlEventTouchUpInside];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableViewCell = cell;
        }
        }else if ([mainItem isKindOfClass:[ToyOrderBottomItem class]]){
            ToyOrderBottomItem *item = (ToyOrderBottomItem*)mainItem;
            NSString *identifier = [NSString stringWithFormat:@"TOYDEAILTIMECELL"];
            ToyDetailTimeCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[ToyDetailTimeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.toyDaysLabel.text = item.mainTitle;
            if ([item.isDelete isEqualToString:@"0"]) {
                cell.delelBtn.hidden = YES;
                //删除按钮
            }else{
                cell.delelBtn.hidden = NO;
                cell.delelBtn.tag = indexPath.row;
                [cell.delelBtn setBackgroundImage:[UIImage imageNamed:@"toy_dele"] forState:UIControlStateNormal];
                //批量删除订单
                [cell.delelBtn addTarget:self action:@selector(deleOrderCombine:) forControlEvents:UIControlEventTouchUpInside];
            }
            if ([item.isPayBtn isEqualToString:@"0"]) {
                //支付按钮不显示
                cell.moreLeaseBtn.hidden = YES;
            }else if ([item.isPayBtn isEqualToString:@"1"]){
                //再租一次
                cell.moreLeaseBtn.hidden = NO;
                cell.moreLeaseBtn.tag = indexPath.row;
                [cell.moreLeaseBtn setBackgroundImage:[UIImage imageNamed:@"toy_moreBuy"] forState:UIControlStateNormal];
                [cell.moreLeaseBtn addTarget:self action:@selector(moreCombineOrder:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                //去支付
                cell.moreLeaseBtn.hidden = NO;
                cell.moreLeaseBtn.tag = indexPath.row;
                [cell.moreLeaseBtn setBackgroundImage:[UIImage imageNamed:@"toy_pay"] forState:UIControlStateNormal];
                [cell.moreLeaseBtn addTarget:self action:@selector(moreCombineOrder:) forControlEvents:UIControlEventTouchUpInside];
            }

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableViewCell = cell;
        }
            
        }
    }
    return tableViewCell;
}
-(void)sureBookOrCancelToy:(BOOL)isBook  item:(ToyLeaseItem*)item row:(NSInteger)row{
    NSString *alertTitle;
    if (isBook == YES) {
        alertTitle = @"确定预约这个宝贝么";
    }else{
        alertTitle = @"确定不预约了么";
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:alertTitle preferredStyle:UIAlertControllerStyleAlert];
    __weak ToyLeaseNewVC *babyVC = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if (isBook == YES) {
            [babyVC addToyToAppointment:item row:row];
        }else{
            [babyVC cancleAppointmentToy:item row:row];
        }
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
-(void)addToyToAppointment:(ToyLeaseItem*)item row:(NSInteger)row{
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",item.business_id,@"business_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"ToysUserAppointmentAdd" params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            item.is_order = @"2";
            NSString *alerting = @"预约成功！查看预约请到“订单-我的预约”";
            [self cancelOrPushBookToysList:alerting];
            //[BBSAlert showAlertWithContent:@"预约成功！查看预约请到“订单-我的预约”" andDelegate:self];
            [self refreshCellSection:0 row:row];
            
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您似乎与网络断开，检查一下吧" andDelegate:nil];
    }];
    
    
}
-(void)cancelOrPushBookToysList:(NSString*)alertTitle{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:alertTitle preferredStyle:UIAlertControllerStyleAlert];
    __weak ToyLeaseNewVC *babyVC = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self pushMyBookingToys];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
 
}
-(void)cancleAppointmentToy:(ToyLeaseItem*)item row:(NSInteger)row{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",item.business_id,@"business_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"ToysUserAppointmentDel" params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            item.is_order = @"1";
            NSString *alerting = @"已取消！查看预约请到“订单-我的预约”";
            [self cancelOrPushBookToysList:alerting];

            [self refreshCellSection:0 row:row];
            
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您似乎与网络断开，检查一下吧" andDelegate:nil];
    }];
    
}


#pragma mark 查看vip大图
-(void)clickToBigPic{
    if (!_grayBackView) {
        _grayBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENHEIGHT)];
        _grayBackView.backgroundColor = [BBSColor hexStringToColor:@"65544b" alpha:0.5];
        [self.view addSubview:_grayBackView];
        _imgVip = [[UIImageView alloc]initWithFrame:CGRectMake(45, 120,227, 319)];
        _imgVip.image = [UIImage imageNamed:@"toy_vip"];
        [_grayBackView addSubview:_imgVip];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeNavBack)];
        [_grayBackView addGestureRecognizer:singleTap];
    }else{
        self.grayBackView.frame = CGRectMake(0,0, SCREENWIDTH, SCREENHEIGHT);
        self.imgVip.frame = CGRectMake(45, 120,227, 319);
        
    }
}
-(void)removeNavBack{
    self.imgVip.frame = CGRectMake(0, 0, 0, 0);
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [UIView animateWithDuration:1.0 // 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:1.0 // 类似弹簧振动效果 0~1它的范围为 0.0f 到 1.0f ，数值越小「弹簧」的振动效果越明显
          initialSpringVelocity:2.0 // 初始速度
                        options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                     animations:^{
                         // code...
                         
                         CGPoint point = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
                         self.grayBackView.frame = CGRectMake(SCREEN_WIDTH/2, SCREENHEIGHT/2, 0, 0);
                         [self.grayBackView setCenter:point];
                     } completion:^(BOOL finished) {
                     }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_inTheViewData == 2002) {
        ToyLeaseItem *item = [_toydataArray objectAtIndex:indexPath.row];
//        if ([item.is_jump isEqualToString:@"1"]) {
//            ToyTransportVC *toyTransportVC = [[ToyTransportVC alloc]init];
//            toyTransportVC.order_id = item.order_id;
//            toyTransportVC.fromWhere = @"3";
//            [self.navigationController pushViewController:toyTransportVC animated:YES];
//        }else if ([item.is_jump isEqualToString:@"0"]){
//            ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
//            toyDetailVC.business_id = item.business_id;
//            [self.navigationController pushViewController:toyDetailVC animated:YES];
//        }else if ([item.is_jump isEqualToString:@"2"]){
//            [self pushWebUrl:item.postUrl];
//        }
        ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
        toyDetailVC.business_id = item.business_id;
        [self.navigationController pushViewController:toyDetailVC animated:YES];
        
    }else if (_inTheViewData == 2003){
        NSArray *singleArray = [_orderdataArray objectAtIndex:indexPath.section];
        ToyCarMainItem *items = [singleArray objectAtIndex:indexPath.row];
        if ([items isKindOfClass:[ToyOrderItem class]]) {
            ToyOrderItem *item = (ToyOrderItem*)items;

            if ([item.is_jump isEqualToString:@"1"]) {
                [self pushWebUrl:item.post_url];
            }else{
                if ([item.order_status isEqualToString:@"0"]) {
                    //跳订单
                    ToyTransportVC *toyTransportVC = [[ToyTransportVC alloc]init];
                    toyTransportVC.order_id = item.order_id;
                    toyTransportVC.fromWhere = @"3";
                    [self.navigationController pushViewController:toyTransportVC animated:YES];
                }else if ([item.order_status isEqualToString:@"1"]){
                    //跳押金
                    /*
                    MyDepositVC *myDepostitVC = [[MyDepositVC alloc]init];
                    myDepostitVC.orderId = item.order_id;
                    [self.navigationController pushViewController:myDepostitVC animated:YES];
                     */
                }else if ([item.order_status isEqualToString:@"2"]){
                    //跳卡详情
                    ToyTransportVC *toyTransportVC = [[ToyTransportVC alloc]init];
                    toyTransportVC.order_id = item.order_id;
                    [self.navigationController pushViewController:toyTransportVC animated:YES];
                }
            }

        }
    }else if (_inTheViewData == 2004){
        //购物车
        NSArray *singleArray;
        if (_isDeleteToyCar == YES) {
            singleArray = [_toyCarCanDeleteToyArray objectAtIndex:indexPath.section];
        }else{
            singleArray = [_toyCarDataArray objectAtIndex:indexPath.section];
        }
        ToyCarMainItem *item = [singleArray objectAtIndex:indexPath.row];
        if ([item isKindOfClass:[ToyMessDetailItem class]]) {
            ToyMessDetailItem *toyItem = (ToyMessDetailItem*)item;
            ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
            toyDetailVC.business_id = toyItem.business_id;
            [self.navigationController pushViewController:toyDetailVC animated:YES];
        }
    }
}
#pragma mark 加入购物车后cell的刷新
-(void)refreshCellSection:(NSInteger)section row:(NSInteger)row{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSArray *indexPathArray = @[indexPath];
    [_tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
    
}
#pragma mark 勾选按钮 获取cell所在的
-(void)addToyToCar:(UIButton *)btn{
    UIButton *btns = (UIButton*)btn;
    UIView *sup = [btns superview];
    UIView *sup1 = [sup superview];
    UIView *sup2 = [sup1 superview];
    ToyMessDetailCell *cell = (ToyMessDetailCell*)sup2;
    NSInteger section = [[_tableView indexPathForCell:cell]section];
    NSInteger row = [[_tableView indexPathForCell:cell]row];
    NSMutableArray *singleArray;
    if (_isDeleteToyCar == YES) {
        singleArray = [_toyCarCanDeleteToyArray objectAtIndex:section];
    }else{
    singleArray = [_toyCarDataArray objectAtIndex:section];
    }
    ToyMessDetailItem *item = [singleArray objectAtIndex:row];
    if (_isDeleteToyCar == YES) {
        //选择删除的玩具
        if ([cell.selectBtn.imageView.image isEqual:[UIImage imageNamed:@"toy_car_buy_unselect"]]) {
            [cell.selectBtn setImage:[UIImage imageNamed:@"toy_car_buy_select"] forState:UIControlStateNormal];
            [_deleteArray addObject:item.cart_id];
        }else{
            [cell.selectBtn setImage:[UIImage imageNamed:@"toy_car_buy_unselect"] forState:UIControlStateNormal];
            [_deleteArray removeObject:item.cart_id];
        }
    }else{
    //是否有库存
    if ([item.is_order isEqualToString:@"1"]) {
        //无库存
        [BBSAlert showAlertWithContent:item.descriptionOrder andDelegate:self];
    }else{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:LOGIN_USER_ID forKey:@"login_user_id"];
    [param setObject:item.cart_id forKey:@"cart_id"];
    [param setObject:item.order_id forKey:@"order_id"];
    [[HTTPClient sharedClient]getNewV1:@"editCartCheckState" params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *toyDic = result[@"data"];
            ToyMessDetailItem *item = [[ToyMessDetailItem alloc]init];
            item.cart_id = MBNonEmptyString(toyDic[@"cart_id"]);
            item.business_id = MBNonEmptyString(toyDic[@"business_id"]);
            item.business_title = MBNonEmptyString(toyDic[@"business_title"]);
            item.every_price = MBNonEmptyString(toyDic[@"every_price"]);
            item.img_thumb = MBNonEmptyString(toyDic[@"img_thumb"]);
            item.check_state = MBNonEmptyString(toyDic[@"check_state"]);
            item.is_order = MBNonEmptyString(toyDic[@"is_order"]);
            item.order_id = MBNonEmptyString(toyDic[@"order_id"]);
            item.descriptionOrder = MBNonEmptyString(toyDic[@"description"]);
            item.smallImgThumb = MBNonEmptyString(toyDic[@"new_size_img_thumb"]);
            item.close_order_des = MBNonEmptyString(toyDic[@"close_order_des"]);
            item.cellHeight = 75;
            [singleArray replaceObjectAtIndex:row withObject:item];
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:section];
            NSArray *indexArray=[NSArray arrayWithObjects:indexPath, nil];
            [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
            self.totalLabel.text = MBNonEmptyString(toyDic[@"total_title"]);
            NSString *totalMoneyString = MBNonEmptyString(toyDic[@"total_price"]);
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:totalMoneyString attributes:@{NSKernAttributeName:@(-1)}];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalMoneyString length])];
            self.totalMoneyLabel.attributedText = attributedString;
            
            self.isButton = MBNonEmptyString(toyDic[@"is_button"]);
            if ([self.isButton isEqualToString:@"1"]) {
                //显示可以点击
                [self.payBtn setBackgroundImage:[UIImage imageNamed:@"toy_go_pay"] forState:UIControlStateNormal];
            }else{
                [self.payBtn setBackgroundImage:[UIImage imageNamed:@"toy_ungo_pay"] forState:UIControlStateNormal];
            }
            if (item.close_order_des.length > 0) {
                [BBSAlert showAlertWithContent:item.close_order_des andDelegate:self];
            }


        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
        [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
    }];
    }
    }

    
}
#pragma mark 删除按钮
-(void)deleOrder:(UIButton *)sender{
    deleTag = sender.tag;
    deleSmallOrderBtn = sender;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您确认删除此订单么" preferredStyle:UIAlertControllerStyleAlert];
        __weak ToyLeaseNewVC *babyVC = self;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [babyVC deleSure];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您确认删除此订单么" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"确定", nil];
        alertView.tag = 101;
        [alertView show];
    }
    
}
#pragma mark 删除单个小订单
-(void)deleSure{
    [LoadingView startOnTheViewController:self];
    UIView *sup = [deleSmallOrderBtn superview];
    UIView *sup1 = [sup superview];
    UITableViewCell *cell = (UITableViewCell*)sup1;
    NSInteger section = [[_tableView indexPathForCell:cell]section];
    NSInteger row = [[_tableView indexPathForCell:cell]row];
    NSMutableArray *singleArray = [_orderdataArray objectAtIndex:section];
    ToyOrderItem *item = [singleArray objectAtIndex:row];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:LOGIN_USER_ID forKey:@"login_user_id"];
    [param setObject:item.order_id forKey:@"order_id"];
    [[HTTPClient sharedClient]getNewV1:@"cancelToysOrderV1" params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSIndexPath *refresh = [NSIndexPath indexPathForRow:row inSection:section];
            NSArray *array = [NSArray arrayWithObject:refresh];
            [singleArray removeObjectAtIndex:row];
            BOOL isDeleSection;//是否删除整组
        
                if (singleArray.count > 2) {
                    isDeleSection = NO;
                }else{
                    isDeleSection = YES;
                }
            if (isDeleSection == NO) {
                [_tableView beginUpdates];
                [_tableView deleteRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationFade];
                [_tableView reloadData];
                [_tableView endUpdates];
            }else{
                //删除整个分组
                NSIndexSet *set=[[NSIndexSet alloc]initWithIndex:section];
                NSMutableArray *indexPathsArray=[[NSMutableArray alloc]init];
                for (int i=0;i<singleArray.count;i++) {
                    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:section];
                    [indexPathsArray addObject:indexPath];
                    
                }
                [_orderdataArray removeObjectAtIndex:section];
                [_tableView beginUpdates];
                [_tableView deleteRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationFade];
                [_tableView deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
                [_tableView endUpdates];
                [_tableView reloadData];
            }

            [LoadingView stopOnTheViewController:self];
        }else{
            [LoadingView stopOnTheViewController:self];
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
        [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
     }];

    
}
#pragma mark 批量删除订单
-(void)deleOrderCombine:(UIButton*)sender{
    deleCombineIdBtn = sender;
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您确认删除这一批订单么" preferredStyle:UIAlertControllerStyleAlert];
        __weak ToyLeaseNewVC *babyVC = self;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [babyVC deleSureCombine];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您确认删除这一批订单么" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"确定", nil];
        alertView.tag = 102;
        [alertView show];
    }

}
-(void)deleSureCombine{
    [LoadingView startOnTheViewController:self];
    UIView *sup = [deleCombineIdBtn superview];
    UIView *sup1 = [sup superview];
    UITableViewCell *cell = (UITableViewCell*)sup1;
    NSInteger section = [[_tableView indexPathForCell:cell]section];
    NSInteger row = [[_tableView indexPathForCell:cell]row];
    NSMutableArray *singleArray = [_orderdataArray objectAtIndex:section];
    ToyOrderBottomItem *item = [singleArray objectAtIndex:row];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:LOGIN_USER_ID forKey:@"login_user_id"];
    [param setObject:item.combineId forKey:@"combined_order_id"];
    [[HTTPClient sharedClient]getNewV1:@"cancelToysOrderV1" params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSIndexSet *set=[[NSIndexSet alloc]initWithIndex:section];
            
            NSArray *itemsArray=[_orderdataArray objectAtIndex:section];
            NSMutableArray *indexPathsArray=[[NSMutableArray alloc]init];
            
            for (int i=0;i<itemsArray.count;i++) {
                
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:section];
                [indexPathsArray addObject:indexPath];
                
            }
            [_orderdataArray removeObjectAtIndex:section];
            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationFade];
            [_tableView deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
            [_tableView endUpdates];
            [_tableView reloadData];
            [LoadingView stopOnTheViewController:self];
        }else{
            [LoadingView stopOnTheViewController:self];
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
        [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
    }];

    
}
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
        }else{
            [self deleSure];
        }

    }else if (alertView.tag == 102){
        if (buttonIndex == 0) {
        }else{
            [self deleSureCombine];
        }
    }else if (alertView.tag == 103){
        if (buttonIndex == 0) {
        }else{
            [self deleteToyCarAllSure];
        }
 
    }
    
}

#pragma mark 再租一次或者去支付
-(void)moreOder:(UIButton *)sender{
    UIView *sup = [sender superview];
    UIView *sup1 = [sup superview];
    UITableViewCell *cell = (UITableViewCell*)sup1;
    NSInteger section = [[_tableView indexPathForCell:cell]section];
    NSInteger row = [[_tableView indexPathForCell:cell]row];
    NSMutableArray *singleArray = [_orderdataArray objectAtIndex:section];
    ToyOrderItem *item = [singleArray objectAtIndex:row];
    if ([item.order_status isEqualToString:@"2"]) {
        [LoadingView startOnTheViewController:self];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",item.order_id,@"order_id",@"2",@"source",nil];
        [[HTTPClient sharedClient]getNewV1:@"publictoysOrderV2" params:params success:^(NSDictionary *result) {
            [LoadingView stopOnTheViewController:self];
            if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                NSDictionary *dataDic = result[@"data"];
                NSString *combined_order_id;
                combined_order_id = MBNonEmptyString(dataDic[@"combined_order_id"]);
                MakeSureMoneyVC *makeSureVC = [[MakeSureMoneyVC alloc]init];
                makeSureVC.combined_order_id = combined_order_id;
                makeSureVC.fromWhere = @"3";
                [self.navigationController pushViewController:makeSureVC animated:YES];
            }
        } failed:^(NSError *error) {
            [LoadingView stopOnTheViewController:self];
        }];
    }else{
        MakeSurePaySureVC *makeSurePay = [[MakeSurePaySureVC alloc]init];
        makeSurePay.orderIdOrderList = item.order_id;
        makeSurePay.source = @"2";
        makeSurePay.fromWhere = @"3";
        [self.navigationController pushViewController:makeSurePay animated:YES];
    }
}
#pragma mark 批量订单
-(void)moreCombineOrder:(UIButton*)sender{
    UIView *sup = [sender superview];
    UIView *sup1 = [sup superview];
    UITableViewCell *cell = (UITableViewCell*)sup1;
    NSInteger section = [[_tableView indexPathForCell:cell]section];
    NSInteger row = [[_tableView indexPathForCell:cell]row];
    NSMutableArray *singleArray = [_orderdataArray objectAtIndex:section];
    ToyOrderBottomItem *item = [singleArray objectAtIndex:row];
    if ([item.combineOrderStatus isEqualToString:@"2"]) {
        [LoadingView startOnTheViewController:self];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",item.combineId,@"combined_order_id",@"3",@"source",nil];
        [[HTTPClient sharedClient]getNewV1:@"publictoysOrderV2" params:params success:^(NSDictionary *result) {
            [LoadingView stopOnTheViewController:self];
            if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                NSDictionary *dataDic = result[@"data"];
                NSString *combined_order_id;
                combined_order_id = MBNonEmptyString(dataDic[@"combined_order_id"]);
                MakeSureMoneyVC *makeSureVC = [[MakeSureMoneyVC alloc]init];
                makeSureVC.combined_order_id = combined_order_id;
                makeSureVC.fromWhere = @"3";
                [self.navigationController pushViewController:makeSureVC animated:YES];
            }
        } failed:^(NSError *error) {
            [LoadingView stopOnTheViewController:self];
        }];
 
    }else{
        MakeSurePaySureVC *makeSurePay = [[MakeSurePaySureVC alloc]init];
        makeSurePay.fromWhere = @"3";
        makeSurePay.source = @"3";
        makeSurePay.combined_order_idOrderLst = item.combineId;
        [self.navigationController pushViewController:makeSurePay animated:YES];
    }

}
#pragma mark 点击跳转更多
-(void)pushMoreDetail:(UIButton *)sender{
    ToyListItem1 *item = [_dataArray objectAtIndex:sender.tag];
    if ([item.category_id isEqualToString:@"0"]) {
        _inTheViewData = 2002;
        //_classfyMakeString = @"小泰克,澳贝";
        [self changeData:_inTheViewData];

    }else{
        [self pushToyList:item.category_id];
    }
    
}

#pragma mark 点击单图,第二图，第三图，第四图
-(void)pushSinglePic:(UITapGestureRecognizer*)sender{
    ToyListItem1 *item = [_dataArray objectAtIndex:sender.view.tag];
    ToyLIstClassItem *itemClass1 = item.business_info[0];
    [self pushWhere:itemClass1.source pushId:itemClass1.business_id webUrl:itemClass1.web_link];
}
-(void)pushSecondPic:(UITapGestureRecognizer*)sender{
    ToyListItem1 *item = [_dataArray objectAtIndex:sender.view.tag];
    ToyLIstClassItem *itemClass1 = item.business_info[1];

    [self pushWhere:itemClass1.source pushId:itemClass1.business_id webUrl:itemClass1.web_link];

}
-(void)pushThirdPic:(UITapGestureRecognizer*)sender{
    ToyListItem1 *item = [_dataArray objectAtIndex:sender.view.tag];
    ToyLIstClassItem *itemClass1 = item.business_info[2];
    [self pushWhere:itemClass1.source pushId:itemClass1.business_id webUrl:itemClass1.web_link];
}
-(void)pushFourPic:(UITapGestureRecognizer*)sender{
    ToyListItem1 *item = [_dataArray objectAtIndex:sender.view.tag];
    ToyLIstClassItem *itemClass1 = item.business_info[3];
    [self pushWhere:itemClass1.source pushId:itemClass1.business_id webUrl:itemClass1.web_link];
}


-(void)pushWhere:(NSString*)type  pushId:(NSString*)pushId  webUrl:(NSString *)webUrl{
    //跳转方向（1：玩具详情；2：玩具列表  3：外链；）
    NSLog(@"type,pushid,weburl = %@,%@,%@",type,pushId,webUrl);
    if ([type isEqualToString:@"1"]) {
        [self pushDetailToyPage:pushId];
        
    }else if ([type isEqualToString:@"2"]){
        if ([pushId isEqualToString:@"0"]) {
            _inTheViewData = 2002;
            [self changeData:_inTheViewData];
        }else{
            [self pushToyList:pushId];
        }
        
    }else if ([type isEqualToString:@"3"]){
        [self pushWebUrl:webUrl];
    }
}

#pragma mark 跳转玩具详情
-(void)pushDetailToyPage:(NSString *)toyID{
    ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
    toyDetailVC.business_id = toyID;
    [self.navigationController pushViewController:toyDetailVC animated:YES];

}
#pragma mark 跳转玩具列表
-(void)pushToyList:(NSString*)listId{
    ToyClassListVC *classList = [[ToyClassListVC alloc]init];
    classList.businessId = listId;
    [self.navigationController pushViewController:classList animated:YES];
    
}
#pragma mark 跳转web链接
-(void)pushWebUrl:(NSString*)url{
    WebViewController *webView=[[WebViewController alloc]init];
    webView.urlStr=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [webView setHidesBottomBarWhenPushed:YES];
    webView.fromWhree = @"1";
    [self.navigationController pushViewController:webView animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back{
    [self hiddenAllClassifyView];

    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    if ([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
        NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults];
        [pushJudge setObject:@""forKey:@"push"];
        [pushJudge synchronize];//记得立即同步
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        if (_inTheViewData == 2001) {
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[MakeSurePaySureVC class]]) {
                    [self.navigationController popToRootViewControllerAnimated:YES];
                    break;
                }
            }
            if ([self.fromMain isEqualToString:@"main"]) {
                
                BBSTabBarViewController *tabVC = [[BBSTabBarViewController alloc]init];
                theAppDelegate.window.rootViewController = tabVC;
                [tabVC setBBStabbarSelectedIndex:0];
                tabVC.selectedIndex = 0;
                NSLog(@"self.navigationController = 从首页tab进入");
            }else{
                NSLog(@"self.navigationController = 要退回首页首页");
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
            
        }else{
            _inTheViewData = 2001;
            [self changeDataWithTag:firstBtn];
            _backBtn.hidden = NO;
        }
    }
}
#pragma mark 文字的宽

-(float)getTitleWidth:(NSString *)title fontSize:(NSInteger )fontSize{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize nickSize = [title sizeWithAttributes:attributes];
    return nickSize.width+3;

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
-(void)showHUDWithMessage:(NSString *)message{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60,64+20+50+50+50+5 , 200, 30)];
    label.backgroundColor = [UIColor darkGrayColor];
    label.layer.cornerRadius = 3.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:14];
    label.alpha=0.5;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [self.view addSubview:label];
    [UIView commitAnimations];
    [self performSelector:@selector(remove:) withObject:label afterDelay:1.5];
    
}
-(void)remove:(UILabel *)label{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [label removeFromSuperview];
    [UIView commitAnimations];
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
