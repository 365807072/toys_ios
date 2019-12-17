//
//  ToyLeaseDetailVC.m
//  BabyShow
//
//  Created by WMY on 16/12/7.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyLeaseDetailVC.h"
#import "UIImageView+WebCache.h"
#import "NIAttributedLabel.h"
#import "PostBarDetailNewDescribeItem.h"
#import "PostBarDetailNewPhotoItem.h"
#import "PostBarDetailDescribeCell.h"
#import "PostBarDetailPhotoCell.h"
#import "BBSEmojiInfo.h"
#import "Emoji.h"
#import "UIButton+WebCache.h"
#import "BBSNavigationController.h"
#import "MakeSurePaySureVC.h"
#import "LoginHTMLVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "PurchaseCarAnimationTool.h"
#import "ToyCarVC.h"
#import "MakeSureMoneyVC.h"
#import "ToyShareNewVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "BookToysVC.h"
#import "ChangePhoneNumber2VC.h"

@interface ToyLeaseDetailVC ()<PostBarDetailPhotoCellDelegate,UITextFieldDelegate>{
    UITableView *_secondTableView;
    UIView *_headrView;
    NSMutableArray *_postDataArray;
    NSArray *facesArray;
    NSDictionary *facesDictionary;
    NSMutableArray *_PhotoArray;
    UILabel *_badgeValueLabel;
    
}
@property(nonatomic,weak)JSContext *context;
@property(nonatomic,strong)UIWebView *toyWebView;//玩具的网页加载页面
@property(nonatomic,strong)UIButton *shareBtn;//玩具分享
@property(nonatomic,strong)UIImageView *toyImg;
@property(nonatomic,strong)UIImageView *smallToyMark;//小玩具标志
@property(nonatomic,strong)UIView *backNameView;
@property(nonatomic,strong)UILabel *labelToyName;//玩具名
@property(nonatomic,strong)UIView *backSupportView;
@property(nonatomic,strong)UIView *backYearView;
@property(nonatomic,strong)UIImageView *iconImg;//豌豆苗支持图标
@property(nonatomic,strong)UILabel *supportLabel;//蓝色支持文字
@property(nonatomic,strong)UILabel *supportContentLabel;//支持内容
@property(nonatomic,strong)UILabel *supportYearLabel;//适龄儿童
@property(nonatomic,strong)UILabel *yearLabel;//年龄阶段
@property(nonatomic,strong)UILabel *userNameLabel;//发布用户
@property(nonatomic,strong)UILabel *phoneLabel;//联系方式
@property(nonatomic,strong)UIButton *phoneBtn;//联系电话
@property(nonatomic,strong)UILabel *dataPostLabel;//发布日期
@property(nonatomic,strong)UILabel *dataLabel;//发布日期

@property(nonatomic,strong)UIImageView *imgDes;//玩具描述
@property(nonatomic,strong)UIView *backPriceView;//玩具价格
@property(nonatomic,strong)UILabel *priceLabel;//租赁价格
@property(nonatomic,strong)UILabel *markPriceLabel;//市场价格
@property(nonatomic,strong)UIButton *buyBtn;//立即购买
@property(nonatomic,strong)NSString *phoneNumber;
@property(nonatomic,strong)UILabel *QQlabel;
@property(nonatomic,strong)UILabel *QQNumberlabel;
@property(nonatomic,strong)UILabel *desToylabel;
@property(nonatomic,strong)UILabel *remarkLabel;//备注
@property(nonatomic,strong)UILabel *remarkContentLabel;//备注内容
@property(nonatomic,strong) UIImageView *imageView;//网络出错后的页面
@property(nonatomic,strong)UILabel *payforLabel;//最高赔付
@property(nonatomic,strong)UILabel *payforCountLabel;//最高赔付金额

@property(nonatomic,strong)UILabel *ensureLabel;//半径保证
@property(nonatomic,strong)UILabel *ensureCountLabel;//半径保证金额
@property(nonatomic,strong)UIView *explainPayforView;//解释
@property(nonatomic,strong)UILabel *explainPayforLabel;
@property(nonatomic,strong)UIImageView *userImg;
@property(nonatomic,assign)CGFloat isHaveSupeiHeight;
@property(nonatomic,strong)NSURL *imgBigUrl;//最大的图
@property(nonatomic,strong)NSString *toyNameString;//玩具名字

@property(nonatomic,strong)UIButton *toyCarBtn;//购物车
@property(nonatomic,strong)UIButton *changeToyBtn;//更换玩具
@property(nonatomic,strong)UIButton *addCarBtn;//加入购物车
@property(nonatomic,strong)UIButton *makeSureBtn;//立即租下
@property(nonatomic,strong)UIView *lineView1;
@property(nonatomic,strong)NSString *orderStatus;//商品的类型0代表玩具，2代表会员卡
@property(nonatomic,strong)NSString *share_title;//分享的主标题
@property(nonatomic,strong)NSString *share_des;//分享描述
@property(nonatomic,strong)YLButton *shareRequestFriendBtn;//邀请好友得好礼
@property(nonatomic,strong)NSString *toyDetailUrl;//玩具的URL请求
@property(nonatomic,strong)NSString *baseUrl;//基本请求
@property(nonatomic,strong)UIImageView *shadowImage;
@property(nonatomic,strong)NSString *isCardOrToy;//是卡还是玩具
@property(nonatomic,strong)UIButton *isAppointBtn;//是否可以预约的按钮
@property(nonatomic,strong)NSString *is_appoint;//是否可以预约
@property(nonatomic,strong)NSString *appointedTitle;//预约按钮对应的文字
@property(nonatomic,strong)UIButton *otherBtn;//其他按钮
//邀请码的页面
@property(nonatomic,strong)UIView *makeSurePayView;
@property(nonatomic,strong)UIButton *InviteBtn;//点击邀请的按钮
@property(nonatomic,strong)UILabel *priceCardLabel;//减后的结果
@property(nonatomic,strong)UILabel *decreaseMoneyLabel;//立减多少钱
@property(nonatomic,strong)UILabel *explainMoneyLabel;//解释
@property(nonatomic,strong)UIButton *makesurePayBtn;//最后的支付
//弹出填写邀请码页面
@property(nonatomic,strong)UIView *grayView;//日期弹窗出来后的阴影
@property(nonatomic,strong)UIView *inputInviteView;//白色的底部
@property(nonatomic,strong)UILabel *inputInviteLabel;//请输入验证码
@property(nonatomic,strong)UILabel *explainInviteLabel;//验证码使用说明
@property(nonatomic,strong)UIButton *InviteCancelBtn;//点击取消邀请的按钮
@property(nonatomic,strong)UIButton *InviteMakeBtn;//点击确定的按钮
@property(nonatomic,strong)UITextField *inviteTx;

@property(nonatomic,strong)NSString *invite_user_id;
@property(nonatomic,strong)NSString *isHavemobile;
@property(nonatomic,strong)NSString *invite_user_id_default;

@property(nonatomic,strong)NSString *shareImgMiniProgram;//小程序分享的图片
@property(nonatomic,strong)NSString *shareshare_path;//小程序的路径

@property(nonatomic,strong)NSString *business_idChange;

@property(nonatomic,strong)UIButton *saveBtn;
@property(nonatomic,strong)NSString *collect_status;



@end

@implementation ToyLeaseDetailVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"宝贝详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault]; [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self isHaveMoble];
    self.navigationController.navigationBar.translucent = NO;
    //self.view.backgroundColor = [UIColor greenColor];
    
}
-(void)isHaveMoble{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"getUserMobileIsBind" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSLog(@"resultffff = %@,%@",result,result[@"is_mobile"]);
            if ([result[@"is_mobile"] isEqualToString:@"1"]) {
                _isHavemobile = @"1";
            }else{
                _isHavemobile = @"0";
            }
        }else{
          _isHavemobile = @"1";
        }
        
    } failed:^(NSError *error) {
        _isHavemobile = @"1";
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_postDataArray) {
        _postDataArray = [NSMutableArray array];
    }
    if (!facesArray) {
        facesArray = [[NSArray alloc]initWithArray:[Emoji allEmoji]];
    }
    if (!facesDictionary) {
        facesDictionary = [[NSDictionary alloc]initWithDictionary:[Emoji allEmojiDictionary]];
    }
    if (!_PhotoArray) {
        _PhotoArray = [NSMutableArray array];
    }
    
    [self setLeftButton];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setWebView];
    [self setBottomView];
    //加载h5页面
    [self getNewToyData:@"yes"];
    [self setRightButton];
    
    
    self.toyImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, SCREENWIDTH, SCREENWIDTH*0.55)];
    [self.toyImg setContentMode:UIViewContentModeScaleAspectFill];
    self.toyImg.clipsToBounds = YES;
    [_headrView addSubview:self.toyImg];
    
    // [self setShareRequestFirend];
    
    
}
#pragma mark 消失
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [BBSColor hexStringToColor:NAVICOLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; [self.navigationController.navigationBar setShadowImage:nil];
    self.navigationController.navigationBar.translucent = YES;

    
}
#pragma mark 加载下面数据和分享数据
-(void)getNewToyData:(NSString*)firstLoading{
    NSDictionary *ParamDic=[NSDictionary dictionaryWithObjectsAndKeys:
                            LOGIN_USER_ID,@"login_user_id",
                            self.business_id,@"business_id",nil];
    UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:@"toysDetailV2" Method:NetMethodGet andParam:ParamDic];
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
        if ([[dic objectForKey:@"success"]integerValue] == 1) {
            NSDictionary *dataDic = dic[@"data"];
            
            //玩具详情的描述
            NSDictionary *detailDic = dataDic[@"detail"];
            //玩具大图
            NSString *imgString = MBNonEmptyString(detailDic[@"img_thumb"]);
            _imgBigUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imgString]];
            [self.toyImg sd_setImageWithURL:_imgBigUrl placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
            //分享字段
            self.share_des =  [NSString stringWithFormat:@"%@",MBNonEmptyString(detailDic[@"share_des"])];
            self.share_title = [NSString stringWithFormat:@"%@",MBNonEmptyString(detailDic[@"share_title"])];
            self.shareImgMiniProgram = detailDic[@"share_img"];
            self.shareshare_path = detailDic[@"share_path"];
            
            //立即购买按钮显示状态（0显示、1不显示）
            NSString *isOrder = MBNonEmptyString(detailDic[@"is_order"]);
            self.baseUrl = MBNonEmptyString(detailDic[@"post_url"]);
            NSLog(@"self.baseurl = %@",self.baseUrl);
            if ([firstLoading isEqualToString:@"yes"]) {
                [self setUrlView];
            }
            //获取购物车里面的玩具数量
            [self getToyCarCount];
            
            
            NSDictionary *button_info = dataDic[@"button_info"];
            NSDictionary *appointDic = button_info[@"appoint_button"];
            NSDictionary *cartDic = button_info[@"cart_button"];
            NSDictionary *orderDic = button_info[@"order_button"];
            NSDictionary *otherDic = button_info[@"other_button"];
            
            
            //订单来源（0玩具、2办卡）
            self.orderStatus = MBNonEmptyString(detailDic[@"order_status"]);
            if ([self.orderStatus isEqualToString:@"0"]) {
                //玩具订单
                //1.购物车是否显示（0显示、1不显示）
                NSString *is_cart_number = MBNonEmptyString(detailDic[@"is_cart_number"]);
                if ([is_cart_number isEqualToString:@"0"]) {
                    _toyCarBtn.hidden = NO;
                    self.lineView1.hidden = NO;
                    [_toyCarBtn addTarget:self action:@selector(pushtoyCar) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    _toyCarBtn.hidden = YES;
                    self.lineView1.hidden = YES;
                }
                
                //2.收藏按钮
                _collect_status = MBNonEmptyString(detailDic[@"collect_status"]);
                if ([_collect_status isEqualToString:@"0"]) {
                    //未收藏
                    self.saveBtn.hidden = NO;
               [self.saveBtn setBackgroundImage:[UIImage imageNamed:@"myCancleSaveBtnDetail"] forState:UIControlStateNormal];
                }else{self.saveBtn.hidden = NO;
                  [self.saveBtn setBackgroundImage:[UIImage imageNamed:@"mySaveBtnDetail"] forState:UIControlStateNormal];
                    //已收藏
                }
                [self.saveBtn addTarget:self action:@selector(sureOrCacleSave) forControlEvents:UIControlEventTouchUpInside];

                
                //5.预约按钮
                NSString *is_show_book = MBNonEmptyString(appointDic[@"is_show"]);
                NSString *button_title_book = MBNonEmptyString(appointDic[@"button_title"]);
                _is_appoint = MBNonEmptyString(appointDic[@"appoint_status"]);
                if ([is_show_book isEqualToString:@"0"]) {
                    self.isAppointBtn.hidden = NO;
                    self.isAppointBtn.backgroundColor = [BBSColor hexStringToColor:@"5C92FF"];
                   // [self.isAppointBtn setBackgroundImage:[UIImage imageNamed:@"toy_detail_book"] forState:UIControlStateNormal];
                    [self.isAppointBtn setTitle:button_title_book forState:UIControlStateNormal];
                    self.isAppointBtn.frame = CGRectMake(SCREENWIDTH/3*2, 0, SCREENWIDTH/3, 51);
                    [self.isAppointBtn addTarget:self action:@selector(sureOrCancle) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    self.isAppointBtn.hidden = YES;
                    self.isAppointBtn.frame = CGRectMake(SCREENWIDTH, 7, 0, 0);
                }
                //4.即将上新
                NSString *is_show_other = MBNonEmptyString(otherDic[@"is_show"]);
                NSString *button_title_other = MBNonEmptyString(otherDic[@"button_title"]);
                if ([is_show_other isEqualToString:@"0"]) {
                    self.otherBtn.hidden = NO;
                    
                   // [self.otherBtn setBackgroundImage:[UIImage imageNamed:@"toy_detail_new"] forState:UIControlStateNormal];
                    self.otherBtn.backgroundColor = [BBSColor hexStringToColor:@"FA8762"];
                    [self.otherBtn setTitle:button_title_other forState:UIControlStateNormal];
                    self.otherBtn.frame = CGRectMake(SCREENWIDTH/3*2, 0,SCREENWIDTH/3, 51);
                }else{
                    self.otherBtn.hidden = YES;
                    self.otherBtn.frame = CGRectMake(self.isAppointBtn.frame.origin.x-0, 7, 0,0);
                }
                //3.立即抢租
                NSString *is_show_order = MBNonEmptyString(orderDic[@"is_show"]);
                NSString *button_title_order = MBNonEmptyString(orderDic[@"button_title"]);
                
                if ([is_show_order isEqualToString:@"0"]) {
                    self.buyBtn.hidden = NO;
                   // [self.buyBtn setBackgroundImage:[UIImage imageNamed:@"toy_detail_pay"] forState:UIControlStateNormal];
                    self.buyBtn.backgroundColor = [BBSColor hexStringToColor:@"FDA503"];
                    [self.buyBtn setTitle:button_title_order forState:UIControlStateNormal];
                    self.buyBtn.frame = CGRectMake((SCREENWIDTH/3)*2,0,SCREENWIDTH/3, 51);
                    
                }else{
                    self.buyBtn.hidden = YES;
                    self.buyBtn.frame = CGRectMake(self.otherBtn.frame.origin.x-0, 7, 0, 37);
                }
                //2.加入购物车是否显示
                NSString *is_show_cart = MBNonEmptyString(cartDic[@"is_show"]);
                NSString *button_title_cart = MBNonEmptyString(cartDic[@"button_title"]);
                if ([is_show_cart isEqualToString:@"0"]) {
                    _addCarBtn.hidden = NO;
                    _addCarBtn.frame =  CGRectMake(SCREENWIDTH/3, 0, SCREENWIDTH/3, 51);
                    [_addCarBtn addTarget:self action:@selector(addToyToCar) forControlEvents:UIControlEventTouchUpInside];
                    _addCarBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                    [_addCarBtn setTitle:button_title_cart forState:UIControlStateNormal];
                }else{
                    _addCarBtn.hidden = YES;
                    _addCarBtn.frame = CGRectMake(self.buyBtn.frame.origin.x-0, 7, 0, 37);
                    
                }
                
                
                
                
            }else if ([self.orderStatus isEqualToString:@"2"]){
                [[HTTPClient sharedClient]getNewV1:@"getPayButtonInfoV1" params:ParamDic success:^(NSDictionary *result) {
                    if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                        NSDictionary *data = result[@"data"];
                        if ([data[@"is_card"] isEqualToString:@"0"])  {
                            //各种卡的情况
                            NSLog(@"卡的分类分类");
                            self.lineView1.hidden = YES;
                            NSString *is_show = MBNonEmptyString(orderDic[@"is_show"]);
                            
                            if ([is_show isEqualToString:@"1"]) {
                                self.buyBtn.hidden = YES;
                            }else{
                                self.buyBtn.hidden = NO;
                            }
                            NSString *buy =  MBNonEmptyString(orderDic[@"button_title"]);
                            self.buyBtn.frame = CGRectMake(0, 0, SCREENWIDTH, 51);
                            self.buyBtn.backgroundColor = [BBSColor hexStringToColor:NAVICOLOR];
                            self.buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                            [self.buyBtn setTitle:buy forState:UIControlStateNormal];

                        }else{
                            NSString *isCard = data[@"is_card"];
                            [self setViewBottom:data isHidden:isCard];
                        }
                    }else{
                        [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
                    }
                } failed:^(NSError *error) {
                    
                }];
                
            }
            //玩具支持
            [self.buyBtn addTarget:self action:@selector(goToOrderDetail) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }];
    
}
#pragma mark 底部支付的页面
-(void)setViewBottom:(NSDictionary*)data isHidden:(NSString*)isHidden{
    self.toyWebView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREENHEIGHT-StatusAndNavBar_HEIGHT - IPhoneXSafeHeight-40);
    _backPriceView.hidden = YES;
    _makeSurePayView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-StatusAndNavBar_HEIGHT - IPhoneXSafeHeight - 40, SCREENWIDTH,40)];
    
    _makeSurePayView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_makeSurePayView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
    lineView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
    [_makeSurePayView addSubview:lineView];
    
    _InviteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_InviteBtn setBackgroundImage:[UIImage imageNamed:@"makesure_toy_invite"] forState:UIControlStateNormal];
    _InviteBtn.frame = CGRectMake(10, -13, 44, 44);
    [_makeSurePayView addSubview:_InviteBtn];
    [_InviteBtn addTarget:self action:@selector(getDataInvitedata) forControlEvents:UIControlEventTouchUpInside];

    
    _priceCardLabel = [[UILabel alloc]initWithFrame:CGRectMake(62, 0, 60, 23)];
    _priceCardLabel.text = data[@"price_end"];
    _priceCardLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    _priceCardLabel.font = [UIFont systemFontOfSize:18];
   // _priceCardLabel.backgroundColor = [UIColor redColor];
    _priceCardLabel.font = [UIFont fontWithName:@ "Arial Rounded MT Bold"  size:(17.0)];
    [_makeSurePayView addSubview:_priceCardLabel];
    
    _decreaseMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 4, SCREENWIDTH-125-78, 18)];
    _decreaseMoneyLabel.text = data[@"price_del"];
    _decreaseMoneyLabel.textColor = [BBSColor hexStringToColor:@"fc6463"];
    _decreaseMoneyLabel.font = [UIFont systemFontOfSize:11];
    //_decreaseMoneyLabel.backgroundColor = [UIColor yellowColor];
    [_makeSurePayView addSubview:_decreaseMoneyLabel];
    
    _explainMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(62,20,SCREENWIDTH-62-78, 20)];
    _explainMoneyLabel.text = data[@"title"];
    _explainMoneyLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    _explainMoneyLabel.font = [UIFont systemFontOfSize:10];
    [_makeSurePayView addSubview:_explainMoneyLabel];
   // _explainMoneyLabel.backgroundColor = [UIColor greenColor];
    
    _invite_user_id_default = data[@"invite_user_id"];

    
    _makesurePayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_makesurePayBtn setBackgroundImage:[UIImage imageNamed:@"makesure_toy_pay"] forState:UIControlStateNormal];
    _makesurePayBtn.frame = CGRectMake(SCREENWIDTH-69, 0, 69, 40);
    [_makeSurePayView addSubview:_makesurePayBtn];
    [_makesurePayBtn addTarget:self action:@selector(goToOrderDetail) forControlEvents:UIControlEventTouchUpInside];
    [self changeBtnFrame:isHidden];
}
-(void)changeBtnFrame:(NSString*)iscard{
    
    if ([iscard isEqualToString:@"10"]) {
        _InviteBtn.hidden = YES;
        _priceCardLabel.hidden = NO;
        _decreaseMoneyLabel.hidden = NO;
        _explainMoneyLabel.hidden = NO;
        _priceCardLabel.frame = CGRectMake(12, 0, 70, 23);
        _decreaseMoneyLabel.frame = CGRectMake(60, 4, SCREENWIDTH-125-78, 18);
        _explainMoneyLabel.frame =CGRectMake(12,20,SCREENWIDTH-62-78, 20);


    }else{
        _InviteBtn.hidden = NO;
        _priceCardLabel.frame = CGRectMake(62, 0, 60, 23);
        _decreaseMoneyLabel.frame = CGRectMake(120, 4, SCREENWIDTH-125-78, 18);
        _explainMoneyLabel.frame =CGRectMake(62,20,SCREENWIDTH-62-78, 20);

    }

}
-(void)getDataInvitedata{
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"getPayButtonText" params:dic success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = [result objectForKey:@"data"];
            [self getInputInviteView:data];

        }

    } failed:^(NSError *error) {
        
    }];
}
-(void)getInputInviteView:(NSDictionary*)dataDic{
    if (!_grayView) {
        _grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-40)];
        _grayView.backgroundColor =  [BBSColor hexStringToColor:@"000000" alpha:0.5];
        [self.view addSubview:_grayView];

    }
    _grayView.hidden = NO;
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeList)];
    [_grayView addGestureRecognizer:singleTap];
    
    _inputInviteView = [[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-240)/2, 150, 240,225)];
    _inputInviteView.backgroundColor = [UIColor whiteColor];
    [_grayView addSubview:_inputInviteView];
    
    _inputInviteLabel = [[UILabel alloc]initWithFrame:CGRectMake(24,20, 150, 25)];
    _inputInviteLabel.text = @"请输入邀请码";
    _inputInviteLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    _inputInviteLabel.font = [UIFont systemFontOfSize:15];
    _inputInviteLabel.textAlignment = NSTextAlignmentLeft;
    [_inputInviteView addSubview:_inputInviteLabel];
    
     _inviteTx = [[UITextField alloc]initWithFrame:CGRectMake(_inputInviteLabel.frame.origin.x,_inputInviteLabel.frame.origin.y+_inputInviteLabel.frame.size.height+5,190, 30)];
    _inviteTx.font = [UIFont systemFontOfSize:16];
    _inviteTx.borderStyle=UITextBorderStyleRoundedRect;
    _inviteTx.returnKeyType =UIReturnKeyDone;
    if ([dataDic[@"invite_user_id"] isEqualToString:@"0"]) {
        
    }else{
    _inviteTx.placeholder = dataDic[@"invite_user_id"];
    }
    
    _inviteTx.delegate = self;
    [_inputInviteView addSubview:_inviteTx];
    
    NSArray *eachArray = dataDic[@"list_info"];
    float height = _inviteTx.frame.origin.y+_inviteTx.frame.size.height+7;
    for (int i = 0 ; i<eachArray.count; i++) {
        NSDictionary *eachInfo = eachArray[i];
        NSString *title = eachInfo[@"each_info"];
        UILabel *explainLabel = [[UILabel alloc]init];//Frame:CGRectMake(_inputInviteLabel.frame.origin.x,height+18*i, 200, 18)];
        explainLabel.text = title;
        explainLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        explainLabel.font = [UIFont systemFontOfSize:12];
        explainLabel.textAlignment = NSTextAlignmentLeft;
         float heightExplain = [self getHeightByWidth:200 title:title font:[UIFont systemFontOfSize:12]];
        explainLabel.frame = CGRectMake(_inputInviteLabel.frame.origin.x, height, 200, heightExplain);
        explainLabel.numberOfLines = 0;
        height += heightExplain;
        [_inputInviteView addSubview:explainLabel];

    }
    
    _InviteCancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_InviteCancelBtn setBackgroundImage:[UIImage imageNamed:@"toy_inviteCancelBtn"] forState:UIControlStateNormal];
    _InviteCancelBtn.frame = CGRectMake(0, 225-41, 120,41);
    [_inputInviteView addSubview:_InviteCancelBtn];
    [_InviteCancelBtn addTarget:self action:@selector(removeList) forControlEvents:UIControlEventTouchUpInside];
    
    
    _InviteMakeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_InviteMakeBtn setBackgroundImage:[UIImage imageNamed:@"toy_inviteMakeBtn"] forState:UIControlStateNormal];
    _InviteMakeBtn.frame = CGRectMake(120, 225-41, 120, 41);
    [_inputInviteView addSubview:_InviteMakeBtn];
    [_InviteMakeBtn addTarget:self action:@selector(changeInviteBtnText) forControlEvents:UIControlEventTouchUpInside];
    [self.view  bringSubviewToFront:_makeSurePayView];


}
-(void)removeList{
    _grayView.hidden = YES;
   // [_grayView removeFromSuperview];
}
//点击确定后
-(void)changeInviteBtnText{
    
    if (_inviteTx.text.length > 0) {
        _invite_user_id = _inviteTx.text;
    }else if (_inviteTx.text.length <= 0){
        if (_inviteTx.placeholder.length > 0) {
            _invite_user_id = _invite_user_id_default;
        }else{
            _invite_user_id = @"";
        }
    }

    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.business_id,@"business_id",_invite_user_id,@"invite_user_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"getPayButtonInfoagainV1" params:dic success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = [result objectForKey:@"data"];
            _priceCardLabel.text = data[@"price_end"];
            _decreaseMoneyLabel.text = data[@"price_del"];
            _explainMoneyLabel.text = data[@"title"];
            _invite_user_id = data[@"invite_user_id"];
            [self changeBtnFrame:data[@"is_card"]];
            self.business_idChange = data[@"business_id"];
            [self changeWebview:self.business_idChange];
            [self removeList];
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
        }
        
    } failed:^(NSError *error) {
        
    }];

}
-(void)changeWebview:(NSString*)businessId{
    NSString *urlString = [NSString stringWithFormat:@"%@?login_user_id=%@&business_id=%@",self.baseUrl,LOGIN_USER_ID,businessId];
    self.toyDetailUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:self.toyDetailUrl];
    NSLog(@"1111 = %@",urlString);
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
    [self.toyWebView loadRequest:request];
    
    
}
#pragma mark 是否收藏或取消
-(void)sureOrCacleSave{
    
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    NSLog(@"isddddd = %@",_isHavemobile);
    if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
        return;
    }else{
        //collect_status = 0,表示未收藏状态，需要收藏
        if ([_collect_status isEqualToString:@"0"]) {
            [self saveToy];
        }else{
            [self cancelSaveToy];
        }
        
    }
}
-(void)saveToy{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.business_id,@"business_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"ToysUserCollectAdd" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            [self getNewToyData:@""];
           NSString *alerting = @"收藏成功！";
           [BBSAlert showAlertWithContent:alerting andDelegate:self andDismissAnimated:1];
            
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您似乎与网络断开,检查一下吧！" andDelegate:self];
    }];

}
-(void)cancelSaveToy{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.business_id,@"business_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"ToysUserCollectDel" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            [self getNewToyData:@""];
            NSString *alerting = @"取消收藏！";
            [BBSAlert showAlertWithContent:alerting andDelegate:self andDismissAnimated:0.5];

        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您似乎与网络断开,检查一下吧！" andDelegate:self];
    }];

}
#pragma mark 是否取消或者预约
-(void)sureOrCancle{
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    NSLog(@"isddddd = %@",_isHavemobile);
    if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
        return;
    }else{
        if ([_isHavemobile  isEqualToString:@"0"]) {
            
            [self isBandMobile];
        }else{
        NSString *alertTitle;
        if ([_is_appoint isEqualToString:@"0"]) {
            alertTitle = @"确定预约这个宝贝么";
        }else{
            alertTitle = @"确定不预约了么";
        }
        
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:alertTitle preferredStyle:UIAlertControllerStyleAlert];
            __weak ToyLeaseDetailVC *babyVC = self;
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if ([_is_appoint isEqualToString:@"0"]) {
                    [babyVC addToyToAppointment];
                }else{
                    [babyVC cancleAppointmentToy];
                }
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:alertTitle delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alertView.tag = 105;
            [alertView show];
        }
    }
    }
}
#pragma mark  是否绑定手机号
-(void)isBandMobile{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"需要先绑定一下手机号哦" preferredStyle:UIAlertControllerStyleAlert];
        __weak ToyLeaseDetailVC *babyVC = self;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"绑定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self bandingMobile];
            
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"需要先绑定一下手机号哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定", nil];
        alertView.tag = 106;
        [alertView show];

        
    }
}
-(void)bandingMobile{
    ChangePhoneNumber2VC *change2VC = [[ChangePhoneNumber2VC alloc]init];
    change2VC.typeChangeOrBing = 1;//之前没有手机号现在绑定
    [self.navigationController pushViewController:change2VC animated:YES];

}
#pragma mark 玩具下单的时候绑定手机号

#pragma mark 加载webview页面
-(void)setWebView{
    self.toyWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENHEIGHT - IPhoneXSafeHeight-51)];
    self.toyWebView.scrollView.bounces = NO;
    self.toyWebView.scalesPageToFit = NO;
    self.toyWebView.autoresizesSubviews = NO;
    self.toyWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.toyWebView.delegate = self;
    [self.view addSubview:self.toyWebView];
}
-(void)setUrlView{
    //所要加载的URL
    NSString *urlString = [NSString stringWithFormat:@"%@?login_user_id=%@&business_id=%@",self.baseUrl,LOGIN_USER_ID,self.business_id];
    self.toyDetailUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:self.toyDetailUrl];
    NSLog(@"1111 = %@",urlString);
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:5.0];
    [self.toyWebView loadRequest:request];
    
}

#pragma mark web delegate
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSLog(@"contextcontext = %@",_context);
    _context [@"callMethodToToysDetail"] = ^(){
        NSArray *args = [JSContext currentArguments];
        NSString *toyId = args[0];
        [self pushMoreToy:toyId];
        
    };
}

#pragma mark 跳转同类的推荐产品
-(void)pushMoreToy:(NSString *)toyId{
    ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
    toyDetailVC.business_id = toyId;
    [self.navigationController pushViewController:toyDetailVC animated:YES];
}
#pragma mark 邀请好友得好礼
-(void)setShareRequestFirend{
    _shareRequestFriendBtn = [YLButton buttonWithFrame:CGRectMake(SCREENWIDTH-90, SCREENHEIGHT-46-50, 80, 26) type:UIButtonTypeCustom backImage:nil target:self action:@selector(getAskPage) forControlEvents:UIControlEventTouchUpInside];
    _shareRequestFriendBtn.backgroundColor = [BBSColor hexStringToColor:NAVICOLOR alpha:0.8];
    _shareRequestFriendBtn.layer.masksToBounds = YES;
    _shareRequestFriendBtn.layer.cornerRadius = 15;
    [_shareRequestFriendBtn setTitle:@"邀请好友得好礼" forState:UIControlStateNormal];
    [_shareRequestFriendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _shareRequestFriendBtn.titleLabel.font = [UIFont systemFontOfSize:9];
    [self.view addSubview:_shareRequestFriendBtn];
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
        ToyShareNewVC *toyShareVC = [[ToyShareNewVC alloc]init];
        [self.navigationController pushViewController:toyShareVC animated:YES];
    }
    
}

-(void)setBottomView{
    //玩具价格
    self.backPriceView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-StatusAndNavBar_HEIGHT - IPhoneXSafeHeight-51, SCREENWIDTH, 51)];
    self.backPriceView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backPriceView];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
    lineView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
    [self.backPriceView addSubview:lineView];
    
    //购物车
    self.toyCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    float toyCarX = (SCREENWIDTH/6-24)/2;
    self.toyCarBtn.frame = CGRectMake(toyCarX, 15, 24, 22);
    [self.toyCarBtn setBackgroundImage:[UIImage imageNamed:@"toy_detail_carnew"] forState:UIControlStateNormal];
    [self.backPriceView addSubview:self.toyCarBtn];
    self.toyCarBtn.hidden = YES;
    
    self.lineView1 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/6, 0, 1, 51)];
    self.lineView1.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
    [self.backPriceView addSubview:self.lineView1];
    
    self.saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveBtn.frame = CGRectMake(SCREENWIDTH/6+toyCarX, 15, 24, 22);
    [self.saveBtn setBackgroundImage:[UIImage imageNamed:@"myCancleSaveBtnDetail"] forState:UIControlStateNormal];
    self.saveBtn.hidden = YES;
    [self.backPriceView addSubview:self.saveBtn];
    
    
    //购物车的数量的label
    _badgeValueLabel=[[UILabel alloc]initWithFrame:CGRectMake(20, -5, 15, 15)];
    _badgeValueLabel.backgroundColor=[BBSColor hexStringToColor:@"FF7F7C"];
    ;
    _badgeValueLabel.textColor=[UIColor whiteColor];
    _badgeValueLabel.font=[UIFont systemFontOfSize:8];
    _badgeValueLabel.textAlignment=NSTextAlignmentCenter;
    _badgeValueLabel.layer.masksToBounds=YES;
    _badgeValueLabel.layer.cornerRadius=7.5;
    [self.toyCarBtn addSubview:_badgeValueLabel];
    _badgeValueLabel.hidden = YES;
    
    
   // self.changeToyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changeToyBtn.frame = CGRectMake(68, 7, 71, 37);
    [self.changeToyBtn setBackgroundImage:[UIImage imageNamed:@"toy_change"] forState:UIControlStateNormal];
    [self.backPriceView addSubview:self.changeToyBtn];
    self.changeToyBtn.hidden = YES;
    //加入购物车
    float addCarX = SCREENWIDTH/3;
    self.addCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addCarBtn.frame = CGRectMake(SCREENWIDTH/3, 0, SCREENWIDTH/3, 51);
    self.addCarBtn.backgroundColor = [BBSColor hexStringToColor:@"FF5050"];
    //[self.addCarBtn setBackgroundImage:[UIImage imageNamed:@"toy_detail_addCar"] forState:UIControlStateNormal];
    [self.backPriceView addSubview:self.addCarBtn];
    self.addCarBtn.hidden = YES;
    
    self.buyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyBtn.frame = CGRectMake(SCREENWIDTH-80, 7, 71, 37);
    self.buyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.backPriceView addSubview:self.buyBtn];
    
    //其他按钮
    self.otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.otherBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.backPriceView addSubview:self.otherBtn];
    self.otherBtn.hidden = YES;
    //预约按钮
    self.isAppointBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.isAppointBtn.frame = CGRectMake(SCREENWIDTH/3*2, 0,SCREENWIDTH/3, 51);
    self.isAppointBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [self.backPriceView addSubview:self.isAppointBtn];
    self.isAppointBtn.hidden = YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
        [textField resignFirstResponder];
   return  YES;
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

-(void)setLeftButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 30, 17);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.adjustsImageWhenHighlighted = NO;
    
    [_backBtn setImage:[UIImage imageNamed:@"btn_toy_detail_back"] forState:UIControlStateNormal];
    [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)setRightButton{
    UIView *iconBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 18,18)];

    self.shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.shareBtn.frame = CGRectMake(0, 0,18,18);
   //[self.shareBtn setBackgroundImage:[UIImage imageNamed:@"btn_new_toy_share"] forState:UIControlStateNormal];
    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"btn_new_toy_shares"] forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(shareStoreMeg) forControlEvents:UIControlEventTouchUpInside];
    [iconBgView addSubview:self.shareBtn];
 
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:iconBgView];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
#pragma mark 分享商家
-(void)shareStoreMeg{
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:_imgBigUrl]];
    UIImage *weixinImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shareImgMiniProgram]]];
    NSData *basicImgData = UIImagePNGRepresentation(shareImg);
    NSData *weixinImgData = UIImagePNGRepresentation(weixinImg);
    
    if (basicImgData.length/1024>128) {
        shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
        
    }
    if (weixinImgData.length/1024>128) {
        NSLog(@"weixinImgddddd压缩前= %ld",weixinImgData.length/1024);

        weixinImg = [self scaleToSize:weixinImg size:CGSizeMake(150, 136)];
        NSData *weixinImgData = UIImagePNGRepresentation(weixinImg);


    }

    NSArray* imageArray = @[shareImg];
    NSString *urlString;
    if ([self.orderStatus isEqualToString:@"0"]) {
        //玩具
        urlString = [NSString stringWithFormat:@"%@business_id=%@&login_user_id=%@",kToyNewShare,self.business_id,LOGIN_USER_ID];
    }else{
        //卡
        urlString = [NSString stringWithFormat:@"%@business_id=%@&login_user_id=%@",kToyCardShare,self.business_id,LOGIN_USER_ID];
    }
    NSString *content = [NSString stringWithFormat:@"%@-%@",_toyNameString,self.priceLabel.text];
    [shareParams SSDKSetupShareParamsByText:self.share_des
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]
                                      title:self.share_title
                                       type:SSDKContentTypeAuto];
    
    //设置新浪微博
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",content,[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:self.share_title image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeWebPage];
     //设置微信平台


    [shareParams SSDKSetupWeChatMiniProgramShareParamsByTitle:self.share_title description:self.share_des webpageUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] path:self.shareshare_path thumbImage:weixinImg hdThumbImage:weixinImg userName:@"gh_740dc1537e7c" withShareTicket:NO miniProgramType:0 forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    //设置微信圈
    [shareParams SSDKSetupWeChatParamsByText:self.share_des title:self.share_title url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] thumbImage:imageArray image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    //设置qq
    //设置qq空间
    [shareParams SSDKSetupQQParamsByText:self.share_des title:self.share_title url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] thumbImage:imageArray image:imageArray type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQZone];
    [shareParams SSDKSetupQQParamsByText:self.share_des  title:self.share_title url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] thumbImage:imageArray image:imageArray type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    
    //设置拷贝
    [shareParams SSDKSetupCopyParamsByText:self.share_des images:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] type:SSDKContentTypeAuto];

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

-(void)setHeaderView{
    _headrView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREENWIDTH, 0)];
    _headrView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    //大图
    self.toyImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.55)];
    [self.toyImg setContentMode:UIViewContentModeScaleAspectFill];
    self.toyImg.clipsToBounds = YES;
    [_headrView addSubview:self.toyImg];
    
    _smallToyMark = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-48, SCREENWIDTH*0.55-44,48, 44)];
    [self.toyImg addSubview:_smallToyMark];
    _smallToyMark.hidden = YES;
    
    //玩具名称
    self.backNameView = [[UIView alloc]initWithFrame:CGRectMake(0, self.toyImg.frame.size.height, SCREENWIDTH, 47)];
    self.backNameView.backgroundColor = [UIColor whiteColor];
    [_headrView addSubview:self.backNameView];
    
    self.labelToyName = [[UILabel alloc]initWithFrame:CGRectMake(13, 0, 0, 0)];
    self.labelToyName.textColor = [BBSColor hexStringToColor:@"333333"];
    self.labelToyName.font = [UIFont systemFontOfSize:16];
    self.labelToyName.numberOfLines = 0;
    [self.backNameView addSubview:self.labelToyName];
    
    self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 14,170, 20)];
    self.priceLabel.textColor = [BBSColor hexStringToColor:@"fc6262"];
    self.priceLabel.font = [UIFont systemFontOfSize:22];
    [self.backNameView addSubview:self.priceLabel];
    
    self.markPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 14+27,170, 15)];
    self.markPriceLabel.textColor = [BBSColor hexStringToColor:@"999999"];
    self.markPriceLabel.font = [UIFont systemFontOfSize:12];
    [self.backNameView addSubview:self.markPriceLabel];
    
    
    self.userImg = [[UIImageView alloc]initWithFrame:CGRectMake(13, 10, 24, 24)];
    self.userImg.layer.masksToBounds = YES;
    self.userImg.layer.cornerRadius = 12;
    [self.backNameView addSubview:self.userImg];
    self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, self.labelToyName.frame.origin.y+self.labelToyName.frame.size.height+10, 100, 17)];
    self.userNameLabel.textColor = [BBSColor hexStringToColor:@"333333"];
    self.userNameLabel.font = [UIFont  systemFontOfSize:14];
    [self.backNameView addSubview:self.userNameLabel];
    
    
    //豌豆苗支持
    self.backSupportView = [[UIView alloc]initWithFrame:CGRectMake(0, self.backNameView.frame.origin.y+self.backNameView.frame.size.height+10, SCREENWIDTH, 47)];
    self.backSupportView.backgroundColor = [UIColor whiteColor];
    [_headrView addSubview:self.backSupportView];
    
    self.iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(13, 10, 18, 22)];
    self.iconImg.image = [UIImage imageNamed:@"support"];
    [self.backSupportView addSubview:self.iconImg];
    
    self.supportLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImg.frame.origin.x+self.iconImg.frame.size.width+7, 12, SCREENWIDTH-self.supportLabel.frame.origin.x-self.supportLabel.frame.size.width-20, 20)];
    self.supportLabel.textColor = [BBSColor hexStringToColor:@"2399c0"];
    self.supportLabel.font = [UIFont systemFontOfSize:12];
    [self.backSupportView addSubview:self.supportLabel];
    
    self.supportContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, self.supportLabel.frame.origin.y+self.supportLabel.frame.size.height+10, SCREENWIDTH-26, 30)];
    self.supportContentLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.supportContentLabel.font = [UIFont  systemFontOfSize:13];
    self.supportContentLabel.numberOfLines = 0;
    [self.backSupportView addSubview:self.supportContentLabel];
    
    
    //适龄儿童的
    self.backYearView = [[UIView alloc]initWithFrame:CGRectMake(0, self.backSupportView.frame.origin.y+self.backSupportView.frame.size.height+10, SCREENWIDTH, 47)];
    self.backYearView.backgroundColor = [UIColor whiteColor];
    [_headrView addSubview:self.backYearView];
    
    self.phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 10, 100, 17)];
    self.phoneLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.phoneLabel.font = [UIFont  systemFontOfSize:14];
    self.phoneLabel.text = @"联系方式";
    [self.backYearView addSubview:self.phoneLabel];
    
    self.phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.phoneBtn.frame = CGRectMake(SCREENWIDTH-200, 5, 190, 30);
    [self.backYearView addSubview:self.phoneBtn];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 37, SCREENWIDTH, 0.5)];
    lineView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.backYearView addSubview:lineView];
    
    //qq联系方式
    self.QQlabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 47, 100, 17)];
    self.QQlabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.QQlabel.font = [UIFont  systemFontOfSize:14];
    self.QQlabel.text = @"微信号码";
    [self.backYearView addSubview:self.QQlabel];
    
    self.QQNumberlabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-200, 40, 190, 30)];
    self.QQNumberlabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.QQNumberlabel.font = [UIFont  systemFontOfSize:14];
    self.QQNumberlabel.textAlignment = NSTextAlignmentRight;
    [self.backYearView addSubview:self.QQNumberlabel];
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 37+37.5, SCREENWIDTH, 0.5)];
    lineView1.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.backYearView addSubview:lineView1];
    
    self.supportYearLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, lineView1.frame.origin.y+10, 100, 17)];
    self.supportYearLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.supportYearLabel.font = [UIFont  systemFontOfSize:14];
    [self.backYearView addSubview:self.supportYearLabel];
    
    self.yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-150, lineView1.frame.origin.y+10, 140, 17)];
    self.yearLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.yearLabel.font = [UIFont  systemFontOfSize:14];
    [self.backYearView addSubview:self.yearLabel];
    
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 37+37.5+37.5, SCREENWIDTH, 0.5)];
    lineView2.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.backYearView addSubview:lineView2];
    
    self.dataPostLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, lineView2.frame.origin.y+10, 100, 17)];
    self.dataPostLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.dataPostLabel.font = [UIFont  systemFontOfSize:14];
    [self.backYearView addSubview:self.dataPostLabel];
    
    self.dataLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-150, self.dataPostLabel.frame.origin.y, 140, 17)];
    self.dataLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.dataLabel.textAlignment = NSTextAlignmentRight;
    self.dataLabel.font = [UIFont  systemFontOfSize:14];
    [self.backYearView addSubview:self.dataLabel];
    //最高赔付
    //赔付
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 37+37.5+37.5+37.5, SCREENWIDTH, 0.5)];
    lineView3.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.backYearView addSubview:lineView3];
    self.payforLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, lineView3.frame.origin.y+10, 100, 17)];
    self.payforLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.payforLabel.font = [UIFont  systemFontOfSize:14];
    self.payforLabel.text = @"最高损赔";
    [self.backYearView addSubview:self.payforLabel];
    
    self.payforCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-150, self.payforLabel.frame.origin.y, 140, 17)];
    self.payforCountLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.payforCountLabel.textAlignment = NSTextAlignmentRight;
    self.payforCountLabel.font = [UIFont  systemFontOfSize:14];
    [self.backYearView addSubview:self.payforCountLabel];
    //保证
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(0, 37+37.5+37.5+37.5+37.5, SCREENWIDTH, 0.5)];
    lineView4.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.backYearView addSubview:lineView4];
    
    self.ensureLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, lineView4.frame.origin.y+10, 100, 17)];
    self.ensureLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.ensureLabel.font = [UIFont  systemFontOfSize:14];
    self.ensureLabel.text = @"半径保障";
    [self.backYearView addSubview:self.ensureLabel];
    
    self.ensureCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-150, self.ensureLabel.frame.origin.y, 140, 17)];
    self.ensureCountLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.ensureCountLabel.textAlignment = NSTextAlignmentRight;
    self.ensureCountLabel.font = [UIFont  systemFontOfSize:14];
    [self.backYearView addSubview:self.ensureCountLabel];
    
    //说明
    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(0, 37+37.5+37.5+37.5+37.5+37.5, SCREENWIDTH, 0.5)];
    lineView5.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.backYearView addSubview:lineView5];
    
    self.explainPayforView = [[UIView alloc]initWithFrame:CGRectMake(0, lineView5.frame.origin.y+0.5, SCREENWIDTH, 37)];
    self.explainPayforView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.backYearView addSubview:self.explainPayforView];
    
    self.explainPayforLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 17)];
    self.explainPayforLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.explainPayforLabel.textAlignment = NSTextAlignmentLeft;
    self.explainPayforLabel.font = [UIFont  systemFontOfSize:14];
    [self.explainPayforView addSubview:self.explainPayforLabel];
    
    
    self.remarkLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, self.explainPayforView.frame.origin.y+self.explainPayforView.frame.size.height+10, 100, 17)];
    self.remarkLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.remarkLabel.font = [UIFont  systemFontOfSize:14];
    self.remarkLabel.text = @"其他备注";
    [self.backYearView addSubview:self.remarkLabel];
    
    self.remarkContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-150, self.remarkLabel.frame.origin.y, 140, 17)];
    self.remarkContentLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.remarkContentLabel.textAlignment = NSTextAlignmentRight;
    self.remarkContentLabel.font = [UIFont  systemFontOfSize:14];
    [self.backYearView addSubview:self.remarkContentLabel];
    
    self.imgDes = [[UIImageView alloc]init];
    [_headrView addSubview:self.imgDes];
    self.desToylabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 7, 97, 21)];
    self.desToylabel.textColor = [UIColor whiteColor];
    self.desToylabel.font = [UIFont systemFontOfSize:14];
    [self.imgDes addSubview:self.desToylabel];
    
    
}
-(void)setSecondTableView{
    _secondTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-32)];
    _secondTableView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _secondTableView.delegate = self;
    _secondTableView.dataSource = self;
    _secondTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_secondTableView];
}
#pragma mark 下面按钮的数据请求，和分享的数据
-(void)getBaseData{
    
}
#pragma mark 数据请求
-(void)getToyData{
    [_imageView removeFromSuperview];
    NSDictionary *ParamDic=[NSDictionary dictionaryWithObjectsAndKeys:
                            LOGIN_USER_ID,@"login_user_id",
                            self.business_id,@"business_id",nil];
    UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:@"toysDetail" Method:NetMethodGet andParam:ParamDic];
    
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
            NSDictionary *dataDic = dic[@"data"];
            //玩具详情的描述
            NSDictionary *detailDic = dataDic[@"detail"];
            NSDictionary *priceDic = dataDic[@"price"];
            
            //玩具大图
            NSString *imgString = MBNonEmptyString(detailDic[@"img_thumb"]);
            _imgBigUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imgString]];
            [self.toyImg sd_setImageWithURL:_imgBigUrl placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
            NSString *sizeImg = detailDic[@"size_img_thumb"] ;
            if (sizeImg.length > 0) {
                [_smallToyMark sd_setImageWithURL:[NSURL URLWithString:sizeImg]];
                _smallToyMark.hidden = NO;
            }else{
                _smallToyMark.hidden = YES;
            }
            //玩具名称
            _toyNameString = MBNonEmptyString(detailDic[@"main_business_title"]);
            CGFloat height = [self getHeightByWidth:SCREENWIDTH-13*2 title:_toyNameString font:[UIFont systemFontOfSize:16]] + 5;
            self.labelToyName.frame = CGRectMake(13, 10, SCREENWIDTH-13*2, height);
            self.labelToyName.text = _toyNameString;
            self.labelToyName.lineBreakMode = UILineBreakModeWordWrap;
            
            self.priceLabel.text = MBNonEmptyString(priceDic[@"sell_price"]);
            self.markPriceLabel.text = MBNonEmptyString(priceDic[@"market_price"]);
            self.priceLabel.frame = CGRectMake(13, self.labelToyName.frame.origin.y+self.labelToyName.frame.size.height+10, 170, 20);
            self.markPriceLabel.frame =  CGRectMake(13, self.priceLabel.frame.origin.y+self.priceLabel.frame.size.height+7, 170, 15);
            
            self.userNameLabel.frame = CGRectMake(45, self.markPriceLabel.frame.origin.y+self.markPriceLabel.frame.size.height+10, 100, 17);
            self.userImg.frame = CGRectMake(13, self.userNameLabel.frame.origin.y-5, 24, 24);
            NSString *urlImg = MBNonEmptyString(detailDic[@"userIconUrl"]);
            [self.userImg sd_setImageWithURL:[NSURL URLWithString:urlImg]];
            self.backNameView.frame = CGRectMake(0, self.toyImg.frame.size.height, SCREENWIDTH, height+30+17+52);
            //最高损赔
            self.payforCountLabel.text = MBNonEmptyString(detailDic[@"sunpei"]);
            self.ensureCountLabel.text = MBNonEmptyString(detailDic[@"baozhang"]);
            if (MBNonEmptyString(detailDic[@"sunpeihint"]).length<=0) {
                self.explainPayforView.frame =  CGRectMake(0, 37+37.5+37.5+37.5+37.5+37.5+0.5, SCREENWIDTH, 0);
                _isHaveSupeiHeight =111+37+37*3;
            }else{
                _isHaveSupeiHeight =111+37+37*4;
                self.explainPayforLabel.text = MBNonEmptyString(detailDic[@"sunpeihint"]);
            }
            self.remarkLabel.frame = CGRectMake(13, self.explainPayforView.frame.origin.y+self.explainPayforView.frame.size.height+10, 100, 17);
            self.remarkContentLabel.frame = CGRectMake(SCREENWIDTH-230, self.remarkLabel.frame.origin.y, 225, 17);
            self.remarkContentLabel.text = MBNonEmptyString(detailDic[@"addtext"]);
            NSString *isOrder = MBNonEmptyString(detailDic[@"is_order"]);
            //玩具支持
            NSString *isSupport = MBNonEmptyString(detailDic[@"is_support"]);
            //
            self.orderStatus = MBNonEmptyString(detailDic[@"order_status"]);
            NSString *isCart = MBNonEmptyString(detailDic[@"is_cart"]);
            NSString *is_cart_number = MBNonEmptyString(detailDic[@"is_cart_number"]);
            NSString *is_change = MBNonEmptyString(detailDic[@"is_change"]);
            //分享字段
            self.share_des =  [NSString stringWithFormat:@"%@",MBNonEmptyString(detailDic[@"share_des"])];
            self.share_title = [NSString stringWithFormat:@"%@",MBNonEmptyString(detailDic[@"share_title"])];
            //购物车
            if ([is_cart_number isEqualToString:@"0"]) {
                _toyCarBtn.hidden = NO;
                self.lineView1.hidden = NO;
                [_toyCarBtn addTarget:self action:@selector(pushtoyCar) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                _toyCarBtn.hidden = YES;
                self.lineView1.hidden = YES;
            }
            //更换按钮
            if ([is_change isEqualToString:@"0"]) {
                _changeToyBtn.hidden = NO;
                [_changeToyBtn addTarget:self action:@selector(changeToyIsOrNo) forControlEvents:UIControlEventTouchUpInside];
            }else{
                _changeToyBtn.hidden = YES;
            }
            //加入购物车按钮显示
            if ([isCart isEqualToString:@"0"]) {
                _addCarBtn.hidden = NO;
                [_addCarBtn addTarget:self action:@selector(addToyToCar) forControlEvents:UIControlEventTouchUpInside];
            }else{
                _addCarBtn.hidden = YES;
            }
            
            if ([self.orderStatus isEqualToString:@"0"]) {
                if ([isOrder isEqualToString:@"1"]) {
                    // 已租不可以再租
                   // [self.buyBtn setBackgroundImage:[UIImage imageNamed:@"toy_buy_unbtn"] forState:UIControlStateNormal];
                    self.buyBtn.backgroundColor = [BBSColor hexStringToColor:@"FDA503"];
                    self.buyBtn.enabled = NO;
                }else{
                    //待租
                    self.buyBtn.hidden = NO;
                    //是立即购买还是联系卖家
                    self.buyBtn.backgroundColor = [BBSColor hexStringToColor:@"FDA503"];

                  //  [self.buyBtn setBackgroundImage:[UIImage imageNamed:@"add_toy_release_btn"] forState:UIControlStateNormal];
                }
                NSString *buy =  MBNonEmptyString(priceDic[@"price_button"]);
                [self.buyBtn setTitle:buy forState:UIControlStateNormal];
                
                
            }else if ([self.orderStatus isEqualToString:@"2"]){
                //卡的情况
                if ([isOrder isEqualToString:@"1"]) {
                    self.buyBtn.hidden = YES;
                }else{
                    //待租
                    self.buyBtn.hidden = NO;
                    self.lineView1.hidden = YES;
                    //是立即购买还是联系卖家
                    NSString *buy =  MBNonEmptyString(priceDic[@"price_button"]);
                    [self.buyBtn setBackgroundImage:[UIImage imageNamed:@"add_toy_release_btn"] forState:UIControlStateNormal];
                    [self.buyBtn setTitle:buy forState:UIControlStateNormal];
                }
            }
            if ([isSupport isEqualToString:@"0"]) {
                self.backSupportView.frame = CGRectMake(0, self.backNameView.frame.origin.y+self.backNameView.frame.size.height+10, 0, 0);
                //适龄儿童
                
                self.backYearView.frame = CGRectMake(0, self.backSupportView.frame.origin.y+self.backSupportView.frame.size.height, SCREENWIDTH, _isHaveSupeiHeight);
                [self.buyBtn addTarget:self action:@selector(alertViewShow) forControlEvents:UIControlEventTouchUpInside];
            }else{
                self.supportLabel.text = MBNonEmptyString(detailDic[@"support_name"]);
                NSString *content = MBNonEmptyString(detailDic[@"support_des"]);
                CGFloat heightSupport = [self getHeightByWidth:SCREENWIDTH-26 title:content font:[UIFont systemFontOfSize:13]];
                self.supportContentLabel.text = content;
                
                self.supportContentLabel.frame = CGRectMake(13, self.supportLabel.frame.origin.y+self.supportLabel.frame.size.height+10, SCREENWIDTH-26, heightSupport);
                self.backSupportView.frame = CGRectMake(0, self.backNameView.frame.origin.y+self.backNameView.frame.size.height+10,SCREENWIDTH, self.supportContentLabel.frame.origin.y+heightSupport+10);
                //适龄儿童
                self.backYearView.frame = CGRectMake(0, self.backSupportView.frame.origin.y+self.backSupportView.frame.size.height+10, SCREENWIDTH, _isHaveSupeiHeight);
                [self.buyBtn addTarget:self action:@selector(goToOrderDetail) forControlEvents:UIControlEventTouchUpInside];
            }
            
            self.supportYearLabel.text = MBNonEmptyString(detailDic[@"age_range"]);
            self.yearLabel.text = MBNonEmptyString(detailDic[@"age"]);
            self.yearLabel.textAlignment = NSTextAlignmentRight;
            
            self.userNameLabel.text = MBNonEmptyString(detailDic[@"user_name"]);
            self.phoneNumber = MBNonEmptyString(detailDic[@"business_contact"]);
            //如果没有电话号
            if (self.phoneNumber.length<=0) {
                self.phoneBtn.hidden = YES;
            }else{
                [self.phoneBtn setTitle:self.phoneNumber forState:UIControlStateNormal];
                [self.phoneBtn setTitleColor:[BBSColor hexStringToColor:@"fc6262"] forState:UIControlStateNormal];
                self.phoneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                self.phoneBtn.titleLabel.textAlignment = NSTextAlignmentRight;
                [self.phoneBtn setImage:[UIImage imageNamed:@"toy_phone_btn"] forState:UIControlStateNormal];
                self.phoneBtn.titleEdgeInsets = UIEdgeInsetsMake(5, 0, 5, 0);
                self.phoneBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 161, 0, 0);
                [self.phoneBtn addTarget:self action:@selector(alertViewShow) forControlEvents:UIControlEventTouchUpInside];
            }
            self.QQNumberlabel.text = MBNonEmptyString(detailDic[@"wx"]);
            self.dataPostLabel.text = @"发布时间";
            self.dataLabel.text = MBNonEmptyString(detailDic[@"create_time"]);
            self.dataLabel.textAlignment = NSTextAlignmentRight;
            
            self.imgDes.frame = CGRectMake(0, self.backYearView.frame.origin.y+self.backYearView.frame.size.height+10, 103, 35);
            self.imgDes.image = [UIImage imageNamed:@"toy_backgroup"];
            self.desToylabel.text = MBNonEmptyString(dataDic[@"toys_description"]);
            _headrView.frame = CGRectMake(0, 0, SCREENWIDTH, self.imgDes.frame.origin.y+self.imgDes.frame.size.height+10);
            _secondTableView.tableHeaderView = _headrView;
            
            
            NSArray *dataArray = dataDic[@"description"];
            if (dataArray == nil && ![dataArray isKindOfClass:[NSNull class]] && dataArray.count == 0) {
                self.imgDes.hidden = YES;
                
            }else{
                NSMutableArray *returnArray = [NSMutableArray array];
                for (NSDictionary *imgDic in dataArray) {
                    NSMutableArray *singleArray = [NSMutableArray array];
                    //文字
                    PostBarDetailNewDescribeItem *desItem = [[PostBarDetailNewDescribeItem alloc]init];
                    desItem.describeString = [NSString stringWithFormat:@"%@",imgDic[@"business_des"]];
                    desItem.identify = @"DESCRIBE";
                    if (desItem.describeString.length) {
                        CGFloat height = [self getHeightByWidth:SCREENWIDTH-10*2 title:desItem.describeString font:[UIFont systemFontOfSize:14]];
                        desItem.height = height + 12;
                        [singleArray addObject:desItem];
                    }
                    NSArray *imgArray = imgDic[@"img"];
                    for (NSDictionary *singleImgDic in imgArray) {
                        PostBarDetailNewPhotoItem *photoItem = [[PostBarDetailNewPhotoItem alloc]init];
                        photoItem.thumbString = [NSString stringWithFormat:@"%@",[singleImgDic objectForKey:@"img_thumb"]];
                        
                        photoItem.index = [imgArray indexOfObject:singleImgDic];
                        float width=[[singleImgDic objectForKey:@"img_thumb_width"] floatValue];
                        float height=[[singleImgDic objectForKey:@"img_thumb_height"] floatValue];
                        
                        photoItem.frame = CGRectMake(10, 5, SCREENWIDTH-10*2, height*(SCREENWIDTH-10*2)/width);
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
            }
            [_secondTableView reloadData];
        }else{
            [BBSAlert showAlertWithContent:[dic objectForKey:kBBSReMsg] andDelegate:self];
            
        }
        
    }];
    [request setFailedBlock:^{
        [self showWrongNet];
    }];
    
    
}
#pragma mark 进入购物车
-(void)pushtoyCar{
    if ([self isVisitor] == YES) {
        [self loginIn];
    }else{
        ToyCarVC *toyCarVC = [[ToyCarVC alloc]init];
        [self.navigationController pushViewController:toyCarVC animated:YES];
    }
}
#pragma mark 立即更换
-(void)changeToyIsOrNo{
    [self addToyToCar];
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"此玩具已成为备选，最终更换需要到购物车里完成！" preferredStyle:UIAlertControllerStyleAlert];
        __weak ToyLeaseDetailVC *babyVC = self;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再挑挑" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"去购物车" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [babyVC pushtoyCar];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"此玩具已成为备选，最终更换需要到购物车里完成！" delegate:self cancelButtonTitle:@"再挑挑" otherButtonTitles:@"去购物车", nil];
        alertView.tag = 102;
        [alertView show];
    }
    
}
#pragma mark 我要预约
-(void)addToyToAppointment{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.business_id,@"business_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"ToysUserAppointmentAdd" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            [self getNewToyData:@""];
            NSString *alerting = @"预约成功！查看预约请到“订单-我的预约”";
            [self cancelOrPushBookToysList:alerting];
            
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您似乎与网络断开,检查一下吧！" andDelegate:self];
    }];
    
}
#pragma mark 取消预约
-(void)cancleAppointmentToy{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.business_id,@"business_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"ToysUserAppointmentDel" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            [self getNewToyData:@""];
            NSString *alerting = @"已取消！查看预约请到“订单-我的预约”";
            [self cancelOrPushBookToysList:alerting];

            
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您似乎与网络断开,检查一下吧！" andDelegate:self];
    }];
    
}
-(void)cancelOrPushBookToysList:(NSString*)alertTitle{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:alertTitle preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self pushMyBookingToys];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark 进入我的预约
-(void)pushMyBookingToys{
    BookToysVC *book = [[BookToysVC alloc]init];
    [self.navigationController pushViewController:book animated:YES];
}


#pragma mark 加入购物车
-(void)addToyToCar{
    if ([self isVisitor] == YES) {
        [self loginIn];
    }else{
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.business_id,@"business_id", nil];
        [[HTTPClient sharedClient]getNewV1:@"publicToysCart" params:param success:^(NSDictionary *result) {
            if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                NSDictionary *data = result[@"data"];
                NSString *isCart = data[@"is_cart"];
                NSString *cateName = data[@"cart_name"];
                NSString *toyCount = data[@"cart_number"];
                if ([toyCount isEqualToString:@"0"]) {
                    _badgeValueLabel.hidden = YES;
                }else{
                    _badgeValueLabel.text = data[@"cart_number"];
                    _badgeValueLabel.hidden = NO;
                }
                [[PurchaseCarAnimationTool shareTool]startAnimationandView:self.toyImg andRect:self.toyImg.frame andFinisnRect:CGPointMake(22,SCREENHEIGHT-25) andFinishBlock:^(BOOL finish) {
                    
                }];
                [self  getNewToyData:@""];
            }else{
                [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
            }
        } failed:^(NSError *error) {
            
        }];
    }
}
#pragma mark 玩具详情各按钮之后的刷新
-(void)getDataWithButtons{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.business_id,@"business_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"gettoysDetailStatus" params:param success:^(NSDictionary *result) {
        NSDictionary *detailDic = result[@"data"];
        NSString *isOrder = MBNonEmptyString(detailDic[@"is_order"]);
        NSString *orderStatus = MBNonEmptyString(detailDic[@"order_status"]);
        NSString *isCart = MBNonEmptyString(detailDic[@"is_cart"]);
        NSString *is_cart_number = MBNonEmptyString(detailDic[@"is_cart_number"]);
        NSString *is_change = MBNonEmptyString(detailDic[@"is_change"]);
        NSString *toyCount =  MBNonEmptyString(detailDic[@"cart_number"]);
        NSString *buy =  MBNonEmptyString(detailDic[@"price_button"]);
        
        if ([toyCount isEqualToString:@"0"]) {
            _badgeValueLabel.hidden = YES;
        }else{
            _badgeValueLabel.text = toyCount;
            _badgeValueLabel.hidden = NO;
        }
        
        if ([is_cart_number isEqualToString:@"0"]) {
            _toyCarBtn.hidden = NO;
            [_toyCarBtn addTarget:self action:@selector(pushtoyCar) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            _toyCarBtn.hidden = YES;
        }
        if ([is_change isEqualToString:@"0"]) {
            _changeToyBtn.hidden = NO;
            
            [_changeToyBtn addTarget:self action:@selector(addToyToCar) forControlEvents:UIControlEventTouchUpInside];
        }else{
            _changeToyBtn.hidden = YES;
        }
        
        if ([isCart isEqualToString:@"0"]) {
            _addCarBtn.hidden = NO;
            [_addCarBtn addTarget:self action:@selector(addToyToCar) forControlEvents:UIControlEventTouchUpInside];
        }else{
            _addCarBtn.hidden = YES;
        }
        
        if ([orderStatus isEqualToString:@"0"]) {
            if ([isOrder isEqualToString:@"1"]) {
                // 已租不可以再租
                self.buyBtn.backgroundColor = [BBSColor hexStringToColor:@"FDA503"];
    //            [self.buyBtn setBackgroundImage:[UIImage imageNamed:@"toy_buy_unbtn"] forState:UIControlStateNormal];
                self.buyBtn.enabled = NO;
            }else{
                //待租
                self.buyBtn.hidden = NO;
                //是立即购买还是联系卖家
                self.buyBtn.backgroundColor = [BBSColor hexStringToColor:@"FDA503"];

              //  [self.buyBtn setBackgroundImage:[UIImage imageNamed:@"add_toy_release_btn"] forState:UIControlStateNormal];
                [self.buyBtn setTitle:buy forState:UIControlStateNormal];
            }
            
        }else if ([orderStatus isEqualToString:@"2"]){
            //卡的情况
            if ([isOrder isEqualToString:@"1"]) {
                self.buyBtn.hidden = YES;
            }else{
                //待租
                self.buyBtn.hidden = NO;
                //是立即购买还是联系卖家
                [self.buyBtn setTitle:buy forState:UIControlStateNormal];
                
            }
        }
        
    } failed:^(NSError *error) {
        
    }];
}
#pragma mark 加载失败的页面
-(void)showWrongNet{
    //[self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    if (SCREENWIDTH==320 && SCREENHEIGHT==480 ) {
        _imageView.image = [UIImage imageNamed :@"img_netwrong_4"];
    }else if (SCREENWIDTH==320 && SCREENHEIGHT==568){
        _imageView.image = [UIImage imageNamed :@"img_netwrong_5"];
    }else if(SCREENWIDTH==375 && SCREENHEIGHT==667){
        _imageView.image = [UIImage imageNamed :@"img_netwrong_6"];
    }else if(SCREENWIDTH==414 && SCREENHEIGHT==736){
        _imageView.image = [UIImage imageNamed :@"img_netwrong_6p"];
    }else{
        _imageView.image =[UIImage imageNamed :@"img_netwrong_6"];
        
    }
    [self.view addSubview:_imageView];
    _imageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getToyData)];
    [_imageView addGestureRecognizer:singleTap];
}

#pragma mark UITableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [_postDataArray count];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *sectionArray = [_postDataArray objectAtIndex:section];
    return sectionArray.count;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *sectionArray = [_postDataArray objectAtIndex:indexPath.section];
    PostBarDetailNewBasicItem *item = [sectionArray objectAtIndex:indexPath.row];
    return item.height;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *returnCell;
    if (indexPath.section < _postDataArray.count) {
        NSArray *sectionArray = [_postDataArray objectAtIndex:indexPath.section];
        id obj = [sectionArray objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[PostBarDetailNewDescribeItem class]]) {
            PostBarDetailNewDescribeItem *item=(PostBarDetailNewDescribeItem *) obj;
            PostBarDetailDescribeCell *cell=[tableView dequeueReusableCellWithIdentifier:item.identify];
            cell.backgroundColor = [UIColor whiteColor];
            if (!cell) {
                cell=[[PostBarDetailDescribeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.identify];
            }
            //cell.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
            CGFloat height = [self getHeightByWidth:SCREENWIDTH-10*2 title:item.describeString font:[UIFont systemFontOfSize:14]];
            cell.describeLabel.frame = CGRectMake(10, 7, SCREENWIDTH-10*2, height+5);
            cell.describeLabel.font = [UIFont systemFontOfSize:14];
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
            cell.backgroundColor = [UIColor whiteColor];
            
            returnCell=cell;
            
        }
    }
    returnCell.selectionStyle=UITableViewCellSelectionStyleNone;
    return returnCell;
}
#pragma mark 联系电话
#pragma mark alertView拨打电话提示
-(void)alertViewShow{
    NSString *telephone = [NSString stringWithFormat:@"确认拨打%@",self.phoneNumber];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:telephone delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    [alert show];
    
}
#pragma mark alerviewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 102) {
        if (buttonIndex == 0) {
        }else{
            [self pushtoyCar];
        }
    }else if (alertView.tag == 105) {
        if (buttonIndex == 0) {
            
        }else{
            if ([_is_appoint isEqualToString:@"0"]) {
                [self addToyToAppointment];
            }else{
                [self cancleAppointmentToy];
            }
            
        }
        
    }else if (alertView.tag == 106){
        if (buttonIndex == 0) {
        }else{
            [self bandingMobile];
        }

    }
    else{
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.phoneNumber]]];
        }
    }
}

#pragma mark 跳转购买页面
-(void)goToOrderDetail{
    if ([self isVisitor] == YES) {
        [self loginIn];
    }else{
       // [self  getNewToyData:@""];
        if ([_isHavemobile isEqualToString:@"0"]) {
            [self isBandMobile];
        }else{
            if ([self.orderStatus isEqualToString:@"2"]) {
                [LoadingView startOnTheViewController:self];
                NSDictionary *params;
                if (self.business_idChange.length > 0 ) {
                    params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.business_idChange,@"business_id",@"0",@"source",nil];
                    
                }else{
                    params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.business_id,@"business_id",@"0",@"source",nil];
                    
                    
                }
                
                [[HTTPClient sharedClient]getNewV1:@"publictoysOrderV2" params:params success:^(NSDictionary *result) {
                    [LoadingView stopOnTheViewController:self];
                    if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                        NSDictionary *dataDic = result[@"data"];
                        NSString *combined_order_id;
                        combined_order_id = MBNonEmptyString(dataDic[@"combined_order_id"]);
                        MakeSureMoneyVC *makeSureVC = [[MakeSureMoneyVC alloc]init];
                        makeSureVC.combined_order_id = combined_order_id;
                        makeSureVC.fromWhere = @"0";
                        if (_invite_user_id.length > 0) {
                            makeSureVC.invite_user_id = _invite_user_id;
                        }else{
                            makeSureVC.invite_user_id = _invite_user_id_default;
                        }
                        
                        [self.navigationController pushViewController:makeSureVC animated:YES];
                    }
                } failed:^(NSError *error) {
                    [LoadingView stopOnTheViewController:self];
                }];
            }else{
                MakeSurePaySureVC *makeSurePay = [[MakeSurePaySureVC alloc]init];
                makeSurePay.fromWhere = @"0";
                makeSurePay.businessId = self.business_id;
                makeSurePay.source = @"0";
                
                [self.navigationController pushViewController:makeSurePay animated:YES];
            }

            
        }
    }
}
#pragma mark 是否是用户登录还是游客
-(BOOL)isVisitor{
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    if ([userItem.isVisitor boolValue] == YES || LOGIN_USER_ID == NULL) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark 判断用户身份后的登录
-(void)loginIn{
    LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:^{
    }];
    return;
    
    
}
#pragma mark 查看大图
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
    browser.user_id =LOGIN_USER_ID;
    
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
#pragma mark back返回
-(void)back{
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
        NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults];
        [pushJudge setObject:@""forKey:@"push"];
        [pushJudge synchronize];//记得立即同步
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
}/*
  #pragma mark - Navigation
  
  // In a storyboard-based application, you will often want to do a little preparation before navigation
  - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  // Get the new view controller using [segue destinationViewController].
  // Pass the selected object to the new view controller.
  }
  */

@end
