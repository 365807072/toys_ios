//
//  ToyTransportVC.m
//  BabyShow
//
//  Created by WMY on 16/12/12.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyTransportVC.h"
#import "RefreshControl.h"
#import "UIImageView+WebCache.h"
#import "ToyTransportItem.h"
#import "ToyLeftCell.h"
#import "ToyRightCell.h"
#import "ToyNoPhotoCell.h"
#import "NIAttributedLabel.h"
#import "ToyLeaseDetailVC.h"
#import "MakeSurePaySureVC.h"
#import "ToyLeaseListVC.h"
#import "WMYLabel.h"
#import "ToyLeaseNewVC.h"
#import "ToyCarVC.h"
#import "MakeSureMoneyVC.h"
#import "ToyClassListVC.h"
#import "SuggestVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "ChangeToySucceedVC.h"
 #import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "MyCardListH5VC.h"
#import "PostBarNewDetialV1VC.h"
#import "ToyLeaseDetailVC.h"
#import "WebViewController.h"
#import "ToyShareNewVC.h"

@interface ToyTransportVC ()<RefreshControlDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    RefreshControl *_refreshControl;
    UIView *_headrView;
    UIView *endView;

}
@property(nonatomic, strong) NSString *post_create_time;
@property(nonatomic,strong)UIView *detailView;//详细的页面
@property(nonatomic,strong)UIView *backView2;//订单信息
@property(nonatomic, strong) UIImageView *photoView;
@property(nonatomic, strong) WMYLabel *toyNameLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *userNameLabel;


@property(nonatomic,strong)UILabel *endDetailLabel;//订单详细信息
@property(nonatomic,strong)UILabel *endTimeLabel;//结束的时间
@property(nonatomic,strong)UIView *bottomView;//底部的view
@property(nonatomic,strong)UILabel *statuLabel;//整个订单的状态
@property(nonatomic,strong)UIButton *refundBtn;//更改订单状态的按钮
@property(nonatomic,strong)UIButton *changeToyBtn;//更换玩具
@property(nonatomic,strong)NSString *is_change;//更换玩具显示的状态
@property(nonatomic,strong)NSString *refund_status;//退款状态数字
@property(nonatomic,strong)NSString *is_refund;//按钮显示状态
@property(nonatomic,strong)NSString *isCharing;//退款是否扣取服务费
@property(nonatomic,strong)NSString *alertString;//退款操作提示语
@property(nonatomic,strong)NSString *orderStatus;//0代表玩具 2代表办卡
@property(nonatomic,strong)UIImageView *smallToyMark;//小玩具标志

@property(nonatomic,strong)UIView *servicePhoneView;
@property(nonatomic,strong)UILabel *servicePhoneLabel;//客服电话
@property(nonatomic,strong)UIButton *servicePhoneNumberBtn;

@property(nonatomic,strong)UILabel *expressPhoneLabel;//快递电话
@property(nonatomic,strong)UIButton *expressPhoneNumberBtn;
@property(nonatomic,strong)NSString *phoneString;//电话号码
@property(nonatomic,strong)NSString *expressPhoneNumber;

@property(nonatomic,strong)NSString *postUrlOrder;//订单的h5页面
@property(nonatomic,strong)UIWebView *orderWebView;//订单的网页加载页面
//发红包的页面
@property(nonatomic,strong)UIView *grayView;
@property(nonatomic,strong)UIButton *goToShareBtn;// 分享大按钮
@property(nonatomic,strong)UIButton *gotoCacelBtn;//取消分享按钮
@property(nonatomic,strong)NSString *shareMainTitle;//分享主标题
@property(nonatomic,strong)NSString *shareSecondTitle;//分享的副标题
@property(nonatomic,strong)NSString *windowImg;//分享的图片
@property(nonatomic,strong)NSString *sharePostUrl;//分享的url
@property(nonatomic,strong)NSString *shareActivityPostUrl;//分享成功后的抽奖页面
@property(nonatomic,strong)NSString *shareToyImgBig;//展示出来的大图
//进入详情后是否有弹窗
@property(nonatomic,strong)UIView *grayNewView;
@property(nonatomic,strong)UIButton *goToShareNewBtn;// 分享大按钮
@property(nonatomic,strong)UIButton *gotoCacelNewBtn;//取消分享按钮

@property(nonatomic,strong)NSString *is_show_float;//浮窗是否展示（0：不展示；1：展示）
@property(nonatomic,strong)NSString *is_showWindow;//弹窗是否展示（0：不展示；1：展示）
@property(nonatomic,strong)NSString *post_url;//跳转链接
@property(nonatomic,strong)NSString *windowImgshare;//弹窗图片
@property(nonatomic,strong)NSString *float_img;//浮窗图片
@property(nonatomic,strong)NSString *type;//跳转类型（2：跳转帖子；41：外链；7：玩具详情；11：邀请页面；52：分享）
@property(nonatomic,strong)NSString *iswechat;//是否跳转小程序（0：否；1：是）
@property(nonatomic,strong)NSString *ShareImgnew;//分享的图片
@property(nonatomic,strong)NSString *newmain_title;//分享的标题
@property(nonatomic,strong)NSString *newsecond_title;//分享的副标题
@property(nonatomic,strong)UIButton *goToShareSamllBtn;//浮窗按钮
@property(nonatomic,strong)NSString *wechat_post_url;// 微信小程序跳转
@property(nonatomic,strong)NSString *activity_post_url_new;//跳转的小程序
@end

@implementation ToyTransportVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray=[NSMutableArray array];
    }
    return self;
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    //删除观察者
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USER_TOY_PAY_SUCCEED object:nil];


    //支付成功后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPayDataSucceed:) name:USER_TOY_PAY_SUCCEED object:nil];
}
-(void)viewWillDisappear:(BOOL)animated{

}
#pragma mark 支付成功后的通知
-(void)getPayDataSucceed:(NSNotification*)not{
    NSLog(@"支付成功dddddddddd");
    _post_create_time                           = NULL;
    NSString *orderId = not.object;
    self.order_id = orderId;
    _isHaveShare = YES;
    [self getListData];
    
    [self getDataIsOrNoShare];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationItem.title = @"订单详情";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setHeaderView];
    [self setBackButton];
    [self setTableView];
    [self setBottomViews];
    [self refreshControlInit];
    [self setRightBtn];
    [self changeToyAndShare];
    //支持活动的页面
    [self initViewAlertview];
    
    //支付过来才会有
    NSLog(@"iiiiiiii = %ld",_isHaveShare);
//        if (_isHaveShare == YES) {
//            _isHaveShare = NO;
//           // [self getDataIsOrNoShare];
//        }else{
//            _isHaveShare = YES;
//           // [self cancelSendRedBag];
//        }
    [self floatBtn];


    // Do any additional setup after loading the view.
}
#pragma mark 浮窗小按钮
-(void)floatBtn{
    _goToShareSamllBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _goToShareSamllBtn.frame = CGRectMake(SCREENWIDTH-65, SCREENHEIGHT-136, 43, 50);
    _goToShareSamllBtn.adjustsImageWhenHighlighted = NO;
    [self.view addSubview:_goToShareSamllBtn];
    _goToShareSamllBtn.hidden = YES;

    
}
#pragma mark  是否展示这个分享页面
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
            //self.activity_post_url_new
            self.shareToyImgBig = data[@"icon_img"];
            [_goToShareBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.shareToyImgBig] forState:UIControlStateNormal];
            [_goToShareBtn addTarget:self action:@selector(sendRedPacket) forControlEvents:UIControlEventTouchUpInside];
            [self showShareView];
        }else{
            [self cancelSendRedBag];
        }
        
    } failed:^(NSError *error) {
        [self cancelSendRedBag];
        
    }];
}
#pragma mark 支持活动后的弹窗页面
-(void)initViewAlertview{
    //蒙版
    _grayNewView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENHEIGHT)];
    _grayNewView.backgroundColor = [BBSColor hexStringToColor:@"000000" alpha:0.5];
    [self.view addSubview:_grayNewView];
    _grayNewView.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerCancelTapped:)];
    [_grayNewView addGestureRecognizer:singleTap];
    
    
    _goToShareNewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSLog(@"self.shareToyImgBig = %@",self.shareToyImgBig);
    // [_goToShareBtn setBackgroundImage:[UIImage imageNamed:@"toy_share_get_dayBtn"] forState:UIControlStateNormal];
    _goToShareNewBtn.adjustsImageWhenHighlighted = NO;
    
    _goToShareNewBtn.frame =   CGRectMake(0.15*SCREENWIDTH,(SCREENHEIGHT-(1.4*SCREENWIDTH*0.7))/2-30, SCREENWIDTH*0.7, 1.4*SCREENWIDTH*0.7);
    [_grayNewView addSubview:_goToShareNewBtn];
    
    _gotoCacelNewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_gotoCacelNewBtn setBackgroundImage:[UIImage imageNamed:@"toy_cancle_share_get_dayBtn"] forState:UIControlStateNormal];
    _gotoCacelNewBtn.frame = CGRectMake((SCREENWIDTH-36)/2, _goToShareNewBtn.frame.origin.y+_goToShareNewBtn.frame.size.height+30, 36, 36);
    [_grayNewView addSubview:_gotoCacelNewBtn];
    [_gotoCacelNewBtn addTarget:self action:@selector(cancelSendAlertView) forControlEvents:UIControlEventTouchUpInside];
    _gotoCacelNewBtn.adjustsImageWhenHighlighted = NO;
    
    
    _grayNewView.hidden = YES;
    _goToShareNewBtn.hidden = YES;
    _gotoCacelNewBtn.hidden = YES;
    
}


#pragma mark 换玩具后，分享页面的弹窗
-(void)changeToyAndShare{
    //蒙版
    _grayView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENHEIGHT)];
    _grayView.backgroundColor = [BBSColor hexStringToColor:@"000000" alpha:0.5];
    [self.view addSubview:_grayView];
    _grayView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerCancelTapped:)];
    [_grayView addGestureRecognizer:singleTap];
    
    
    _goToShareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    NSLog(@"self.shareToyImgBig = %@",self.shareToyImgBig);
   // [_goToShareBtn setBackgroundImage:[UIImage imageNamed:@"toy_share_get_dayBtn"] forState:UIControlStateNormal];
    _goToShareBtn.adjustsImageWhenHighlighted = NO;

    _goToShareBtn.frame =   CGRectMake(0.15*SCREENWIDTH,(SCREENHEIGHT-(1.4*SCREENWIDTH*0.7))/2-30, SCREENWIDTH*0.7, 1.4*SCREENWIDTH*0.7);
    [_grayView addSubview:_goToShareBtn];
    
    _gotoCacelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_gotoCacelBtn setBackgroundImage:[UIImage imageNamed:@"toy_cancle_share_get_dayBtn"] forState:UIControlStateNormal];
    _gotoCacelBtn.frame = CGRectMake((SCREENWIDTH-36)/2, _goToShareBtn.frame.origin.y+_goToShareBtn.frame.size.height+30, 36, 36);
    [_grayView addSubview:_gotoCacelBtn];
    [_gotoCacelBtn addTarget:self action:@selector(cancelSendRedBag) forControlEvents:UIControlEventTouchUpInside];
    _gotoCacelBtn.adjustsImageWhenHighlighted = NO;
    

    _grayView.hidden = YES;
    _gotoCacelBtn.hidden = YES;
    _goToShareBtn.hidden = YES;

}
-(void)fingerCancelTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [self cancelSendRedBag];
    
}
#pragma mark  活动展示
-(void)showNewAlertView{
    _grayNewView.hidden = NO;
    _goToShareNewBtn.hidden = NO;
    _gotoCacelNewBtn.hidden = NO;
    [self.view bringSubviewToFront:_grayNewView];
}
#pragma mark 取消分享
-(void)cancelSendAlertView{
    _grayNewView.hidden = YES;
    _goToShareNewBtn.hidden = YES;
    _gotoCacelNewBtn.hidden = YES;
}

#pragma mark 换玩具后会展示出来的分享抽奖页面
-(void)showShareView{
    NSLog(@"____________");
    _grayView.hidden = NO;
    _gotoCacelBtn.hidden = NO;
    _goToShareBtn.hidden = NO;
    [self.view bringSubviewToFront:_grayView];
    
}
#pragma mark 取消分享
-(void)cancelSendRedBag{
    _grayView.hidden = YES;
    _gotoCacelBtn.hidden = YES;
    _goToShareBtn.hidden = YES;
}
#pragma mark 下单后的分享页面抽奖
-(void)sendRedPacket{
    NSString *content = self.shareSecondTitle;
    __weak ToyTransportVC *myStoreVC = self;
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSURL *url = [NSURL URLWithString:self.windowImg];
    //1、创建分享参数（必要）
    UIImage *shareImg;
    if (self.windowImg.length > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.windowImg]];
        shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        NSData *basicImgData = UIImagePNGRepresentation(shareImg);
        if (basicImgData.length/1024>150) {
            shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
        }
        
    }else{
        shareImg = [UIImage imageNamed:@"img_default"];
        
    }
    NSArray* imageArray = @[shareImg];
  NSString *urlString = self.sharePostUrl;
    NSURL *shareUrl = [NSURL URLWithString:urlString];
    NSLog(@"ssssssss = %@",urlString);
    [shareParams SSDKSetupShareParamsByText:self.shareSecondTitle
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]
                                      title:self.shareMainTitle
                                       type:SSDKContentTypeAuto];
    
    //设置新浪微博
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",self.shareMainTitle,[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:self.shareMainTitle image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
    
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
                [self cancelSendRedBag];

                //分享成功后的抽奖页面
                WebViewController *webView=[[WebViewController alloc]init];
                NSString *urlString =  self.shareActivityPostUrl;
                webView.urlStr=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [webView setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:webView animated:YES];

                
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
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}


#pragma mark 加载webview,根据posturl判断是加载什么样的页面
-(void)setWebView{
    self.orderWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREENHEIGHT-64-51)];
    self.orderWebView.scrollView.bounces = NO;
    self.orderWebView.scalesPageToFit = NO;
    self.orderWebView.autoresizesSubviews = NO;
    self.orderWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.orderWebView.delegate = self;
    [self.view addSubview:self.orderWebView];
    //所要加载的URL
    NSString *urlString = [NSString stringWithFormat:@"%@?login_user_id=%@&order_id=%@",self.postUrlOrder,LOGIN_USER_ID,self.order_id];
    NSString *orderUrlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:orderUrlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
    [self.orderWebView loadRequest:request];

}
-(void)setRightBtn{
   UIButton *rightBtn = [YLButton buttonWithFrame:CGRectMake(SCREENWIDTH-60, 0, 60, 22) type:UIButtonTypeCustom backImage:nil target:self action:@selector(getDataSuggest) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [rightBtn setTitle:@"反馈建议" forState:UIControlStateNormal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
}
-(void)getDataSuggest{
    
    SuggestVC *suggestVC = [[SuggestVC alloc]init];
    suggestVC.orderId = self.order_id;
    [self.navigationController pushViewController:suggestVC animated:YES];
}
-(void)setBottomViews{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-55, SCREENWIDTH, 55)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    self.statuLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 13, 100, 24)];
    self.statuLabel.font = [UIFont systemFontOfSize:15];
    self.statuLabel.textColor = [BBSColor hexStringToColor:@"fc6262"];
    [_bottomView addSubview:self.statuLabel];
    
    self.refundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.refundBtn.frame = CGRectMake(SCREENWIDTH-85-10, 10, 85, 35);
    [self.refundBtn setBackgroundImage:[UIImage imageNamed:@"toy_buy_btn"] forState:UIControlStateNormal];
    [self.refundBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.refundBtn.titleLabel.font = [UIFont systemFontOfSize:15];

    [_bottomView addSubview:self.refundBtn];
    
    self.changeToyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changeToyBtn.frame = CGRectMake(SCREENWIDTH-190, 10, 85, 35);
    [self.changeToyBtn setBackgroundImage:[UIImage imageNamed:@"toy_buy_btn"] forState:UIControlStateNormal];
    [self.changeToyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.changeToyBtn setTitle:@"换玩具" forState:UIControlStateNormal];
    self.changeToyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    self.changeToyBtn.hidden = YES;
    [_bottomView addSubview:self.changeToyBtn];

}
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
-(void)setHeaderView{
    _headrView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREENWIDTH, 0)];
    _headrView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    endView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    endView.backgroundColor = [UIColor whiteColor];
    [_headrView addSubview:endView];
    
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 22, 22)];
    img.image= [UIImage imageNamed:@"endtime"];
    [endView addSubview:img];
    self.endTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(42, 10, 270, 20)];
    self.endTimeLabel.numberOfLines = 0;
    self.endTimeLabel.font = [UIFont systemFontOfSize:12];
    self.endTimeLabel.textColor = [BBSColor hexStringToColor:@"836843"];
    [endView addSubview:self.endTimeLabel];
    
    self.detailView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0)];
    self.detailView.backgroundColor = [UIColor whiteColor];
    [_headrView addSubview:self.detailView];
    self.endDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREENWIDTH-20, 30)];
    self.endDetailLabel.font = [UIFont systemFontOfSize:14];
    self.endDetailLabel.numberOfLines = 0;
    self.endDetailLabel.textColor = [BBSColor hexStringToColor:@"333333"];
    [self.detailView addSubview:self.endDetailLabel];
    
    //联系电话
    self.servicePhoneView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    self.servicePhoneView.backgroundColor = [UIColor whiteColor];
    [_headrView addSubview:self.servicePhoneView];
    self.servicePhoneLabel = [BaseLabel makeFrame:CGRectMake(10, 10, 180, 15) font:12 textColor:@"333333" textAlignment:NSTextAlignmentLeft text:@"半径客服"];
    [self.servicePhoneView addSubview:self.servicePhoneLabel];
    
    self.servicePhoneNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.servicePhoneNumberBtn.frame = CGRectMake(SCREENWIDTH-200, 5, 190, 30);
    [self.servicePhoneView addSubview:self.servicePhoneNumberBtn];
    [self.servicePhoneNumberBtn setTitle:@"18515394818" forState:UIControlStateNormal];
    [self.servicePhoneNumberBtn setTitleColor:[BBSColor hexStringToColor:@"fc6262"] forState:UIControlStateNormal];
    self.servicePhoneNumberBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.servicePhoneNumberBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.servicePhoneNumberBtn setImage:[UIImage imageNamed:@"toy_phone_btn"] forState:UIControlStateNormal];
    self.servicePhoneNumberBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.servicePhoneNumberBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 161, 0, 0);
    self.servicePhoneNumberBtn.tag = 501;
    [self.servicePhoneNumberBtn addTarget:self action:@selector(alertViewShow:) forControlEvents:UIControlEventTouchUpInside];
    
    //快递电话
    self.expressPhoneLabel = [BaseLabel makeFrame:CGRectMake(10, 50, 180, 15) font:12 textColor:@"333333" textAlignment:NSTextAlignmentLeft text:@"配送小哥"];
    [self.servicePhoneView addSubview:self.expressPhoneLabel];
    
    self.expressPhoneNumberBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.expressPhoneNumberBtn.frame = CGRectMake(SCREENWIDTH-200,50, 190, 30);
    [self.servicePhoneView addSubview:self.expressPhoneNumberBtn];
    
    [self.expressPhoneNumberBtn setTitleColor:[BBSColor hexStringToColor:@"fc6262"] forState:UIControlStateNormal];
    self.expressPhoneNumberBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.expressPhoneNumberBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.expressPhoneNumberBtn setImage:[UIImage imageNamed:@"toy_phone_btn"] forState:UIControlStateNormal];
    self.expressPhoneNumberBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    self.expressPhoneNumberBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 161, 0, 0);
    self.expressPhoneNumberBtn.tag = 502;
    [self.expressPhoneNumberBtn addTarget:self action:@selector(alertViewShow:) forControlEvents:UIControlEventTouchUpInside];


    
    self.backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 113)];
    self.backView2.backgroundColor = [UIColor whiteColor];
    [_headrView addSubview:self.backView2];
    self.photoView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 77, 77)];
    self.photoView.image = [UIImage imageNamed:@"img_message_photo"];
    [self.photoView setContentMode:UIViewContentModeScaleAspectFill];
    self.photoView.clipsToBounds = YES;
    [self.backView2 addSubview:self.photoView];
    
    _smallToyMark = [[UIImageView alloc]initWithFrame:CGRectMake(77-17, 77-16,17, 16)];
    [self.photoView addSubview:_smallToyMark];
    _smallToyMark.hidden = YES;

    
    self.toyNameLabel = [[WMYLabel alloc]initWithFrame:CGRectMake(self.photoView.frame.origin.x+self.photoView.frame.size.width+10, self.photoView.frame.origin.y+10, SCREENWIDTH-157, 50)];
    self.toyNameLabel.font = [UIFont systemFontOfSize:15];
    self.toyNameLabel.numberOfLines = 0;
    self.toyNameLabel.textColor = [BBSColor hexStringToColor:@"333333"];
    [self.backView2 addSubview:self.toyNameLabel];
    
    [self.toyNameLabel setVerticalAlignment:VerticalAlignmentTop];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-80,self.toyNameLabel.frame.origin.y ,70, 20)];
    self.priceLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.priceLabel.font = [UIFont systemFontOfSize:11];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    [self.backView2 addSubview:self.priceLabel];
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.toyNameLabel.frame.origin.x,60, 170, 15)];
    self.userNameLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.userNameLabel.font = [UIFont systemFontOfSize:10];
    [self.backView2 addSubview:self.userNameLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 103, SCREENWIDTH, 10)];
    lineView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.backView2 addSubview:lineView];
    
    
}
-(void)setTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect tableviewFrame=CGRectMake(0,64, SCREENWIDTH, SCREENHEIGHT-64-55);
    _tableView=[[UITableView alloc]initWithFrame:tableviewFrame];
    _tableView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
}
#pragma mark- refreshControl
-(void)refreshControlInit{
    _refreshControl                             = [[RefreshControl alloc] initWithScrollView:_tableView delegate:self];
    _refreshControl.topEnabled                  = YES;
    _refreshControl.bottomEnabled               = NO;
    [_refreshControl startRefreshingDirection:RefreshDirectionTop];
    
    
}
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    if (refreshControl == _refreshControl) {
        if (direction == RefreshDirectionTop) {
            _post_create_time                           = NULL;
        }
        [self getListData];
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
#pragma mark 弹窗和浮窗,活动点击事件，根据type值判断事件
-(void)pushOtherView{
    [self cancelSendAlertView];
    if ([_type isEqualToString:@"2"]) {
        //跳转帖子
        PostBarNewDetialV1VC *detailVC=[[PostBarNewDetialV1VC alloc]init];
        detailVC.img_id= _post_url;
        detailVC.login_user_id=LOGIN_USER_ID;
        detailVC.refreshInVC = ^(BOOL isRefresh){
            
        };
        [detailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];

        
    }else if ([_type isEqualToString:@"41"]){
        //外链
        WebViewController *webView=[[WebViewController alloc]init];
        NSString *url =_post_url;
        webView.urlStr=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [webView setHidesBottomBarWhenPushed:YES];
        webView.fromWhree = @"1";
        [self.navigationController pushViewController:webView animated:YES];

        
    }else if ([_type isEqualToString:@"7"]){
        //玩具详情
        ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
        NSString *imgid = [NSString stringWithFormat:@"%@",_post_url];
        toyDetailVC.business_id = imgid;
        [self.navigationController pushViewController:toyDetailVC animated:YES];

        
    }else if ([_type isEqualToString:@"11"]){
        //邀请页面
        ToyShareNewVC *toyShareVC = [[ToyShareNewVC alloc]init];
        [self.navigationController pushViewController:toyShareVC animated:YES];

        
    }else if ([_type isEqualToString:@"52"]){
        //分享
        [self sendActivity];
        
    }
}
-(void)sendActivity{
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_ShareImgnew]]];
    UIImage *weixinImg = shareImg;
    NSData *basicImgData = UIImagePNGRepresentation(shareImg);
    if (basicImgData.length/1024>150) {
        shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
        weixinImg = [self scaleToSize:weixinImg size:CGSizeMake(150, 120)];
        
    }
    NSArray* imageArray = @[shareImg];
    NSString *shareURl = [NSString stringWithFormat:@"%@?order_id=%@",_post_url,self.order_id];//缺少分享的url
    NSString *urlString= [NSString stringWithFormat:@"%@",shareURl];
    NSString *shareDes = _newsecond_title;
    NSString *shareTitle = _newmain_title;
    [shareParams SSDKSetupShareParamsByText:shareDes
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]
                                      title:shareTitle
                                       type:SSDKContentTypeAuto];
    
    //设置新浪微博
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",shareDes,[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:shareTitle image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
    //跳转小程序的时候，缺少路径
    if ([_iswechat isEqualToString:@"0"]) {
        //不分享小程序
        [shareParams SSDKSetupWeChatParamsByText:shareDes title:shareTitle url:urlString thumbImage:shareImg image:shareImg musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];

    }else{
        //分享小程序
       
        [shareParams SSDKSetupWeChatMiniProgramShareParamsByTitle:shareTitle description:shareDes webpageUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] path:_wechat_post_url  thumbImage:shareImg hdThumbImage:weixinImg userName:@"gh_740dc1537e7c" withShareTicket:NO miniProgramType:0 forPlatformSubType:SSDKPlatformSubTypeWechatSession];

    }

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
#pragma mark  活动分享是否展示图片和浮窗
-(void)haveShareNeedOrFloat{
    //弹窗是否展示（0：不展示；1：展示）
    if ([_is_showWindow isEqualToString:@"1"]) {
        [_goToShareNewBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:self.windowImg] forState:UIControlStateNormal];
        [self showNewAlertView];
        [_goToShareNewBtn addTarget:self action:@selector(pushOtherView) forControlEvents:UIControlEventTouchUpInside];

    }else if ([_is_showWindow isEqualToString:@"0"]){
        [self cancelSendAlertView];
    }
    
}
#pragma mark 是否有分享提示弹窗，浮窗，用于分享活动时用
/*参数：login_user_id：用户id
 source：1：会员卡订单页面  2：活动页面分享  3：订单页面
  source=1时：会员卡订单页面
 传值：order_id    订单id*/
-(void)isHaveShareActiveInCardOrderOrToyOrder{
    NSDictionary *params ;
    if ([self.orderStatus isEqualToString:@"0"]) {
      //代表玩具订单
        params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",@"3",@"source",self.order_id,@"order_id", nil];
    }else if ([self.orderStatus isEqualToString:@"2"]){
       //代表年卡订单
        params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",@"1",@"source",self.order_id,@"order_id", nil];
    }
    [[HTTPClient sharedClient]getNewV1:@"getToysShareInfo" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = result[@"data"];
             _is_show_float = data[@"is_show_float"];
            _is_showWindow = data[@"is_show_window"];
            _post_url = data[@"post_url"];
            _windowImg = data[@"window_img"];
            _float_img = data[@"float_img"];
            _type = data[@"type"];
            _iswechat = data[@"is_wechat"];
            _ShareImgnew = data[@"share_img"];
            _newmain_title = data[@"main_title"];
            _newsecond_title = data[@"second_title"];
            _wechat_post_url = [NSString stringWithFormat:@"%@?order_id=%@",data[@"wechat_post_url"],_order_id];
            NSLog(@"小程序分析的路径 = %@",_wechat_post_url);
            
            
            //管理浮窗
            if ([_is_show_float isEqualToString:@"0"]) {
                //这个改过来需要
                _goToShareSamllBtn.hidden = YES;
            }else{
                _goToShareSamllBtn.hidden = NO;
                [self.view bringSubviewToFront:_goToShareSamllBtn];
                [_goToShareSamllBtn sd_setBackgroundImageWithURL:[NSURL URLWithString:_float_img] forState:UIControlStateNormal];
                [_goToShareSamllBtn addTarget:self action:@selector(pushOtherView) forControlEvents:UIControlEventTouchUpInside];
            }
            //管理弹窗
            [self haveShareNeedOrFloat];
        }
        
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark 获取玩具数据
-(void)getListData{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.order_id,@"order_id",_post_create_time,@"post_create_time", nil];
    NSString *url;
    url = @"getToysOrderDetailV1";
    UrlMaker *urlMark = [[UrlMaker alloc]initWithNewV1UrlStr:url Method:NetMethodGet andParam:params];
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
            NSDictionary *dataDic = [dic objectForKey:@"data"];
            NSArray *dataArray = dataDic[@"order_listing"];
            self.orderStatus = dataDic[@"order_status"];
            [self isHaveShareActiveInCardOrderOrToyOrder];
            
            NSMutableArray *returnArray = [NSMutableArray array];
            self.postUrlOrder = dataDic[@"post_url"];
            
            if (_isHaveShare == YES) {
                _isHaveShare = NO;
                if (self.postUrlOrder.length > 0) {
                    [self cancelSendRedBag];
                }else{
                    [self getDataIsOrNoShare];
                }
            }else{
                [self cancelSendRedBag];
            }


            if (self.postUrlOrder.length > 0) {
                [self cancelSendRedBag];
                [self refreshComplete:_refreshControl];
                [self setWebView];
                
 
            }else{
                for (NSDictionary *listDic in dataArray) {
                    
                    ToyTransportItem *item = [[ToyTransportItem alloc]init];
                    if ([self.orderStatus isEqualToString:@"0"]) {
                        item.listing_create_time = MBNonEmptyString(listDic[@"listing_create_time"]);
                        item.img_thumb = MBNonEmptyString(listDic[@"img_thumb"]);
                        item.listing_status_name = MBNonEmptyString(listDic[@"listing_status_name"]);
                        item.style = MBNonEmptyString(listDic[@"style"]);
                    }else if ([self.orderStatus isEqualToString:@"2"]){
                        item.img_thumb = MBNonEmptyString(listDic[@"img_thumb"]);
                        item.img_thumb_width = [listDic[@"img_thumb_width"]floatValue];
                        item.img_thumb_height = [listDic[@"img_thumb_height"]floatValue];
                        
                    }
                    [returnArray addObject:item];
                    
                }
                NSString *expString = MBNonEmptyString(dataDic[@"order_post_time"]);
                CGFloat height1 = [self getHeightByWidth:270 title:expString font:[UIFont systemFontOfSize:12]];
                if (height1 <20) {
                    height1 = 20;
                }
                self.endTimeLabel.frame = CGRectMake(42, 10, 270, height1);
                self.endTimeLabel.text = MBNonEmptyString(dataDic[@"order_post_time"]);
                endView.frame = CGRectMake(0, 0, SCREENWIDTH, height1+20);
                NSString *detailOrder = MBNonEmptyString(dataDic[@"orderdetail"]);
                CGFloat height = [self getHeightByWidth:SCREENWIDTH-10*2 title:detailOrder font:[UIFont systemFontOfSize:14]];
                self.endDetailLabel.text = detailOrder;
                self.endDetailLabel.frame = CGRectMake(10, 0, SCREENWIDTH-20,0);
                
                //订单那一条
                NSString *img_thumb =MBNonEmptyString(dataDic[@"img_thumb"]);
                [self.photoView sd_setImageWithURL:[NSURL URLWithString:img_thumb] placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
                NSString *sizeImg = dataDic[@"new_size_img_thumb"];
                if (sizeImg.length > 0) {
                    _smallToyMark.hidden = NO;
                    [_smallToyMark sd_setImageWithURL:[NSURL URLWithString:sizeImg]];
                }else{
                    _smallToyMark.hidden = YES;
                }
                NSString *business_title = MBNonEmptyString(dataDic[@"business_title"]);
                self.toyNameLabel.text = business_title;
                NSString *every_sell_price = MBNonEmptyString(dataDic[@"every_sell_price"]);
                self.priceLabel.text = every_sell_price;
                NSString *statu = MBNonEmptyString(dataDic[@"status_name"]);
                self.userNameLabel.text = statu;
                self.userNameLabel.textColor = [BBSColor hexStringToColor:@"F08556"];
                float heightPack = 0;
                NSArray *orderInfoArray = dataDic[@"orderinfo"];
                [self.detailView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                for (NSDictionary *priceDic in orderInfoArray) {
                    UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(0,heightPack, SCREENWIDTH, 35)];
                    [self.detailView addSubview:priceView];
                    NSString *title = priceDic[@"order_title"];
                    NSString *price = priceDic[@"order_value"];
                    BaseLabel *leftLabel = [BaseLabel makeFrame:CGRectMake(10, 10, 180, 15) font:12 textColor:@"333333" textAlignment:NSTextAlignmentLeft text:title];
                    [priceView addSubview:leftLabel];
                    BaseLabel *rightLabel;
                    UIView *lineView;
                    if (price.length > 16) {
                        rightLabel = [BaseLabel makeFrame:CGRectMake(10, 30, SCREENWIDTH-20, 30) font:12 textColor:@"999999" textAlignment:NSTextAlignmentLeft text:price];
                        rightLabel.numberOfLines = 2;
                        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 0.5)];
                        lineView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
                        [priceView addSubview:lineView];
                        heightPack += 65;
                    }else{
                        rightLabel = [BaseLabel makeFrame:CGRectMake(SCREENWIDTH-200, 10, 190, 15) font:12 textColor:@"999999" textAlignment:NSTextAlignmentRight text:price];
                        lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 34, SCREENWIDTH, 0.5)];
                        lineView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
                        [priceView addSubview:lineView];
                        heightPack += 35;
                    }
                    [priceView addSubview:rightLabel];
                }
                UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, heightPack, SCREENWIDTH, 10)];
                lineview.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
                [self.detailView addSubview:lineview];
                
                self.expressPhoneNumber = dataDic[@"postman_mobile"];
                if (self.expressPhoneNumber.length > 0) {
                    self.servicePhoneView.frame = CGRectMake(0, endView.frame.size.height+10, SCREENWIDTH, 80);
                    self.expressPhoneLabel.hidden = NO;
                    self.expressPhoneNumberBtn.hidden = NO;
                    [self.expressPhoneNumberBtn setTitle:self.expressPhoneNumber forState:UIControlStateNormal];
                    
                }else{
                    self.servicePhoneView.frame = CGRectMake(0, endView.frame.size.height+10, SCREENWIDTH, 40);
                    self.expressPhoneLabel.hidden = YES;
                    self.expressPhoneNumberBtn.hidden = YES;
                    
                }
                
                self.detailView.frame = CGRectMake(0, self.servicePhoneView.frame.origin.y+self.servicePhoneView.frame.size.height+10, SCREENWIDTH, heightPack+10);
                self.backView2.frame = CGRectMake(0, self.detailView.frame.origin.y+self.detailView.frame.size.height, SCREENWIDTH, 103);
                
                _headrView.frame = CGRectMake(0, 0, SCREENWIDTH, heightPack+50+10+113+height1+20);
                
                _tableView.tableHeaderView = _headrView;
                if (returnArray.count == 0) {
                    _refreshControl.bottomEnabled = NO;
                }
                if (_post_create_time == NULL) {
                    [_dataArray removeAllObjects];
                    _refreshControl.bottomEnabled = NO;
                }
                [_dataArray addObjectsFromArray:returnArray];
                [_tableView reloadData];
                [self refreshComplete:_refreshControl];
 
            }

            
            self.statuLabel.text = MBNonEmptyString(dataDic[@"status_name"]);
            self.refund_status = MBNonEmptyString(dataDic[@"refund_status"]);
            NSString *re = MBNonEmptyString(dataDic[@"refund_status"]);
            [self.refundBtn addTarget:self action:@selector(gotoOrderDetail) forControlEvents:UIControlEventTouchUpInside];
            
            self.businessId = MBNonEmptyString(dataDic[@"business_id"]);
            //支付按钮的状态
            self.is_refund = MBNonEmptyString(dataDic[@"is_refund"]);
            if ([self.is_refund isEqualToString:@"0"]) {
                self.refundBtn.hidden = YES;
            }else if ([self.is_refund isEqualToString:@"1"]){
                self.refundBtn.hidden = NO;
            }
            //更换玩具按钮是否显示
            self.is_change = MBNonEmptyString(dataDic[@"is_change"]);
            if ([self.is_change isEqualToString:@"0"]) {
                //显示
                self.changeToyBtn.hidden = NO;
                [self.changeToyBtn addTarget:self action:@selector(gotoToyList) forControlEvents:UIControlEventTouchUpInside];
            }else{
                self.changeToyBtn.hidden = YES;
            }
            self.alertString = MBNonEmptyString(dataDic[@"refund_des"]);
            NSString *refund_name = MBNonEmptyString(dataDic[@"refund_name"]);
            [self.refundBtn setTitle:refund_name forState:UIControlStateNormal];
            
        }else{
            [self refreshComplete:_refreshControl];
            
            [BBSAlert showAlertWithContent:[dic objectForKey:kBBSReMsg] andDelegate:self];

        }
   
    }];
    [request setFailedBlock:^{
        [self refreshComplete:_refreshControl];
        [BBSAlert showAlertWithContent:@"您似乎与网络断开，检查一下网络吧" andDelegate:self];
    }];

}
#pragma mark 订单是未支付状态下去支付
-(void)gotoOrderDetail{
    if ([self.refund_status isEqualToString:@"1"]) {
        if ([self.orderStatus isEqualToString:@"2"]) {
            [LoadingView startOnTheViewController:self];
           NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.order_id,@"order_id",@"2",@"source",nil];
            [[HTTPClient sharedClient]getNewV1:@"publictoysOrderV2" params:params success:^(NSDictionary *result) {
                [LoadingView stopOnTheViewController:self];
                if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                    NSDictionary *dataDic = result[@"data"];
                    NSString *combined_order_id;
                    combined_order_id = MBNonEmptyString(dataDic[@"combined_order_id"]);
                    MakeSureMoneyVC *makeSureVC = [[MakeSureMoneyVC alloc]init];
                    makeSureVC.combined_order_id = combined_order_id;
                    makeSureVC.fromWhere = @"2";
                    [self.navigationController pushViewController:makeSureVC animated:YES];
                }
            } failed:^(NSError *error) {
                [LoadingView stopOnTheViewController:self];
            }];
   
        }else{
        MakeSurePaySureVC *makeSurePay = [[MakeSurePaySureVC alloc]init];
        makeSurePay.orderIdOrderList = self.order_id;
        makeSurePay.source = @"2";
        makeSurePay.fromWhere = @"2";
        [self.navigationController pushViewController:makeSurePay animated:YES];
        }
    }else if ([self.refund_status isEqualToString:@"8"] ||[self.refund_status isEqualToString:@"10"]){
        [self cancelBtn];
    }
}
#pragma mark 更换玩具
-(void)gotoToyList{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"选好您要换的玩具，最终更换需要加到购物车里完成" preferredStyle:UIAlertControllerStyleAlert];
        __weak ToyTransportVC *babyVC = self;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"先不换" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"去选玩具" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [babyVC changePushToyList];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"选好您要换的玩具，加到购物车后即可操作" delegate:self cancelButtonTitle:@"先不换" otherButtonTitles:@"去选玩具", nil];
        alertView.tag = 102;
        [alertView show];
    }

}
#pragma mark 更换玩具
-(void)changePushToyList{
    ToyClassListVC *toyClassListVC = [[ToyClassListVC alloc]init];
    [self.navigationController pushViewController:toyClassListVC animated:YES];

}
#pragma mark 订单在未完成前取消订单退款
-(void)cancelBtn{
    [self cancleOrder:_alertString];
}
-(void)cancleOrder:(NSString*)alertString{
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:alertString preferredStyle:UIAlertControllerStyleAlert];
            __weak ToyTransportVC *babyVC = self;
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [babyVC sureCancelOrder];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:alertString delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"继续", nil];
            alertView.tag = 101;
            [alertView show];
        }
}
#pragma mark 取消订单
-(void)sureCancelOrder{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",@"0",@"source",self.order_id,@"order_id",self.refund_status,@"refund_status", nil];
    
    [[HTTPClient sharedClient]getNewV1:@"toysOrderRefund" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            [self getListData];
            [BBSAlert showAlertWithContent:@"取消成功" andDelegate:self];
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您的网络出现错误" andDelegate:self];
    }];

}
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        if (buttonIndex == 0) {
        }else{
            [self sureCancelOrder];
        }

    }else if (alertView.tag == 103) {
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneString]]];
        }

    }else{
        if (buttonIndex == 0) {
        }else{
            [self changePushToyList];
        }

    }
    
}
#pragma mark 订单完成后退押金
-(void)refundMoney{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",@"0",@"source",self.order_id,@"order_id",@"11",@"refund_status", nil];
    
    [[HTTPClient sharedClient]getNewV1:@"toysOrderRefund" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            [self getListData];
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您的网络出现错误" andDelegate:self];
    }];

}
#pragma mark  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     ToyTransportItem *item = [_dataArray objectAtIndex:indexPath.row];
    if ([self.orderStatus isEqualToString:@"2"]) {
        float height = item.img_thumb_height/item.img_thumb_width*SCREENWIDTH;
        return height;
    }else{
    if ([item.style isEqualToString:@"3"]) {
        return 66;
    }else{
    return 108;
    }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *returnCell;
    ToyTransportItem *item = [_dataArray objectAtIndex:indexPath.row];

    if ([self.orderStatus isEqualToString:@"2"]) {
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        float height = item.img_thumb_height/item.img_thumb_width*SCREENWIDTH;
        UIImageView *avatarImgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREENWIDTH, height)];
        avatarImgV.image = [UIImage imageNamed:@"img_message_avatar_100"];
        [avatarImgV sd_setImageWithURL:[NSURL URLWithString:item.img_thumb] placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
        [cell addSubview:avatarImgV];
        returnCell = cell;
        returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
 
    }else{
    if ([item.style isEqualToString:@"3"]) {
         static NSString *identifier = @"TOYNOPHPTPCELL";
        ToyNoPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ToyNoPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell.btnStatu setTitle:item.listing_status_name forState:UIControlStateNormal];
        [cell.btnStatu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        returnCell = cell;
        
    }else if ([item.style isEqualToString:@"2"]){
        static NSString *identifier = @"TOYLEFTCELL";
        ToyLeftCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ToyLeftCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell.btnStatu setTitle:item.listing_status_name forState:UIControlStateNormal];
        [cell.btnStatu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        cell.timeLabel.text = item.listing_create_time;
        [cell.photoImgView sd_setImageWithURL:[NSURL URLWithString:item.img_thumb] placeholderImage:[UIImage imageNamed:@"img_message_photo"]];

        returnCell = cell;

    }else if ([item.style isEqualToString:@"1"]){
        static NSString *identifier = @"TOYRIGHTCELL";
        ToyRightCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[ToyRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        [cell.btnStatu setTitle:item.listing_status_name forState:UIControlStateNormal];
        [cell.btnStatu setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cell.photoImgView sd_setImageWithURL:[NSURL URLWithString:item.img_thumb] placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
        cell.timeLabel.text = item.listing_create_time;
        returnCell = cell;
        
    }
    if ((indexPath.row%2) == 0 ){
        returnCell.contentView.backgroundColor = [BBSColor hexStringToColor:@"ecffe6"];
    }else{
        returnCell.contentView.backgroundColor = [BBSColor hexStringToColor:@"c2ffaf"];
        
    }
     returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return returnCell;
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

#pragma mark alertView拨打电话提示
-(void)alertViewShow:(UIButton*)sender{
    NSString *telephone;
    if (sender.tag == 501) {
        _phoneString = @"18515394818";
        telephone  = [NSString stringWithFormat:@"确认拨打%@",_phoneString];

    }else{
        _phoneString = self.expressPhoneNumber;
        telephone  = [NSString stringWithFormat:@"确认拨打%@",self.expressPhoneNumber];

    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:telephone delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    alert.tag = 103;
    [alert show];

}
-(void)back{
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    if ([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
        NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults];
        [pushJudge setObject:@""forKey:@"push"];
        [pushJudge synchronize];//记得立即同步
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        NSLog(@"selfwhrer = %@",self.fromWhere);
        //fromwhere 来自哪，0代表玩具详情，1代表购物车，2代表来着订单物流详情支付,3代表订单列表,4代表非首页购物车
        if ([self.fromWhere isEqualToString:@"0"]) {
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[ToyLeaseDetailVC class] ]) {
                    [self.navigationController popToViewController:temp animated:YES];
                    break;
                }
            }
        }else if ([self.fromWhere isEqualToString:@"4"]){
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[ToyCarVC class] ]) {
                    [self.navigationController popToViewController:temp animated:YES];
                    break;
                }
            }
        }else if ([self.fromWhere isEqualToString:@"5"]){
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[MyCardListH5VC class] ]) {
                    [self.navigationController popToViewController:temp animated:YES];
                    break;
                }
            }
        } else  {
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[ToyLeaseNewVC class] ]) {
                    [self.navigationController popToViewController:temp animated:YES];
                    break;
                }
            }
        }
    }
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
