//
//  MakeSureMoneyVC.m
//  BabyShow
//
//  Created by WMY on 17/2/23.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//
#import "MakeSureMoneyVC.h"
#import "WMYLabel.h"
#import "UIImageView+WebCache.h"
#import "payRequsestHandler.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "ToyTransportVC.h"
#import "ToyLeaseNewVC.h"
#import "ToyLeaseDetailVC.h"
#import "NIAttributedLabel.h"
#import "ToyOrderListVC.h"
#import "ToyCarVC.h"
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "WXApiObject.h"
#import "WXApi.h"
@interface MakeSureMoneyVC ()
@property(nonatomic,strong)UIScrollView *bottomScrollView;//整体的底色
@property(nonatomic,strong)UIView *carAlertView;//确认订单上面的提示页面
@property(nonatomic,strong)UIImageView *alertViewImg;//确认订单上面提示图片
@property(nonatomic,strong)UILabel * alertLabel;//确认订单上面提示的语言
@property(nonatomic,strong)UIView *backView7;//是否使用账户余额
@property(nonatomic,strong)BaseLabel *labelMoney;//余额
@property(nonatomic,strong)UIButton *ButMoney;//选择余额
@property(nonatomic,strong)UIImageView *moreImg;//
@property(nonatomic,strong)UIView *backView4;//价格信息
@property(nonatomic,strong)UIView *backView5;//价格合计
@property(nonatomic,strong)BaseLabel *labelTotal;//合计
@property(nonatomic,strong)BaseLabel *labelTotalPrice;//价格合计
@property(nonatomic,strong)UIView *backView6;//支付信息
@property(nonatomic,assign)BOOL isWXAppInstalled;
@property(nonatomic,strong)UIButton *btnPay;
@property(nonatomic,strong)UIImageView *imgPayUnselect;
@property(nonatomic,strong)UIButton *btnWeiXin;
@property(nonatomic,strong)UIImageView *imgWeiXinUnselect;
@property(nonatomic,strong)UIButton *btnSurePay;
@property(nonatomic,assign)NSInteger appding;
@property(nonatomic,strong)NSString *isBalance;//是否使用余额
@property(nonatomic,strong)NSString *balance_info;//余额信息
@property(nonatomic,assign)NSInteger selectButtonTag;//选择的支付方式
@property(nonatomic,strong)NSString *isPayment;//是0元支付的还是需要支付宝和微信支付的
@property(nonatomic,strong)NSString *pay_total_price;//支付金额
@property(nonatomic,strong)NSString *total_price;//展示的支付金额

@property(nonatomic,strong)NSString *business_title;//订单名称
@property(nonatomic,strong)UIImageView *imageViewWrong;//网络错误的情况下
@property(nonatomic,strong)NSDictionary *param;//请求的字典
@property(nonatomic,strong)NSString *orderId;//单个玩具支付的时候才会有orderid

@end

@implementation MakeSureMoneyVC
#pragma mark 检查订单是否被支付过
-(void)viewWillAppear:(BOOL)animated{
    self.automaticallyAdjustsScrollViewInsets=NO;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;


    //如果没有获取秘钥，再次请求
    if(PARTNER_ID.length <= 6){
        [self getAppWX];
    }
    //微信支付成功之后的通知
   
   if ([ShareSDK isClientInstalled:SSDKPlatformTypeWechat]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(PaySuccessAndpopVC) name:USER_WEIXINPAY_SUCCEED object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payFail) name:USER_WEIXINPAY_FAIL object:nil];
    }
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkOrderIsPay) name:USER_ISPAY object:nil];
   
}
//检测一下订单是否被支付过
-(void)checkOrderIsPay{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.combined_order_id,@"combined_order_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"checkToysOrderPay" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *dataDic = result[@"data"];
            NSString *is_pay = dataDic[@"is_pay"];
            if ([is_pay isEqualToString:@"1"]) {
            }else{
                NSLog(@"走的是这个么");
                [self PaySuccessAndpopVC];
            }
        }
    } failed:^(NSError *error) {
        
    }];
    
    
}

#pragma mark获取微信的支付信息
-(void)getAppWX{
    [[HTTPClient sharedClient]getNewV1:@"WeChat" params:nil success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = [result objectForKey:@"data"];
            theAppDelegate.appSecret = [data objectForKey:@"wx_key"];
            NSString *string = [data objectForKey:@"wx_key"];
            [[NSUserDefaults standardUserDefaults]setObject:string forKey:@"weiXinAppApi"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    } failed:^(NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButton];
    self.view.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    self.navigationItem.title = @"确认支付";
    // Do any additional setup after loading the view.
    [self allViewDidLoad];
}
#pragma mark返回
-(void)setLeftButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.adjustsImageWhenHighlighted = NO;
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)allViewDidLoad{
    //此为微信支付的时调出页面的次数
    _appding=0;
    //是否安装微信
    _isWXAppInstalled = [ShareSDK isClientInstalled:SSDKPlatformTypeWechat];
    
    _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH,self.view.bounds.size.height)];
    _bottomScrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREEN_HEIGHT*2);
    _bottomScrollView.alwaysBounceVertical = YES;
    _bottomScrollView.backgroundColor = [BBSColor hexStringToColor:@"f9f9f9"];
    [self.view addSubview:_bottomScrollView];
    
    //1、整个页面上的提示语
    self.carAlertView =  [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH, 35)];
    self.carAlertView.backgroundColor = [UIColor whiteColor];
    [_bottomScrollView addSubview:self.carAlertView];
    self.alertViewImg = [[UIImageView alloc]initWithFrame:CGRectMake(9, 9, 15, 18)];
    self.alertViewImg.image = [UIImage imageNamed:@"toy_alert"];
    [self.carAlertView addSubview:self.alertViewImg];
    self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(27, 9, SCREENWIDTH-40, 20)];
    self.alertLabel.textColor = [BBSColor hexStringToColor:@"836843"];
    self.alertLabel.font = [UIFont systemFontOfSize:12];
    self.alertLabel.numberOfLines = 0;
    [self.carAlertView addSubview:self.alertLabel];
    
    //2、是否有余额
    //是否使用余额抵扣
    
    self.backView7 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    self.backView7.backgroundColor = [UIColor whiteColor];
    [_bottomScrollView addSubview:self.backView7];
    
    self.labelMoney = [BaseLabel makeFrame:CGRectMake(10, 10, 270, 20) font:14 textColor:@"666666" textAlignment:NSTextAlignmentLeft text:self.balance_info];
    [self.backView7 addSubview:self.labelMoney];
    
    self.ButMoney = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ButMoney.frame = CGRectMake(SCREENWIDTH-40, 10, 40, 37);
    [self.backView7 addSubview:self.ButMoney];
    
    self.moreImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-35, 13, 17.5, 17.5)];
    [self.backView7 addSubview:self.moreImg];
    //商品解析
    self.backView4 = [[UIView alloc]init];
    self.backView4.backgroundColor = [UIColor whiteColor];
    [_bottomScrollView addSubview:self.backView4];
    //5、
    self.backView5 = [[UIView alloc]initWithFrame:CGRectMake(0, self.backView4.frame.origin.y+self.backView4.frame.size.height, SCREEN_WIDTH, 40)];
    self.backView5.backgroundColor = [UIColor whiteColor];
    [_bottomScrollView addSubview:self.backView5];
    UIView *lineView9 = [[UIView alloc]initWithFrame:CGRectMake(0,2, SCREENWIDTH, 0.7)];
    lineView9.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.backView5 addSubview:lineView9];
    self.labelTotal = [BaseLabel makeFrame:CGRectMake(SCREEN_WIDTH-170, 10, 100, 20) font:14 textColor:@"999999" textAlignment:NSTextAlignmentLeft text:@""];
    [self.backView5 addSubview:self.labelTotal];
    self.labelTotalPrice = [BaseLabel makeFrame:CGRectMake(SCREEN_WIDTH-90, 10, 80, 20) font:14 textColor:@"fc6262" textAlignment:NSTextAlignmentLeft text:@""];
    self.labelTotalPrice.textAlignment = NSTextAlignmentRight;
    [self.backView5 addSubview:self.labelTotalPrice];
    //
    UIView *payView = [[UIView alloc]init];
    payView.frame = CGRectMake(0, 0, SCREENWIDTH, 51);
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50.5, SCREENWIDTH, 0.5)];
    line1.backgroundColor = [BBSColor hexStringToColor:@"ebebeb"];
    [payView addSubview:line1];
    UIImageView *payImg = [[UIImageView alloc]initWithFrame:CGRectMake(13,15, 41, 24)];
    payImg.image = [UIImage imageNamed:@"img_order_pay"];
    [payView addSubview:payImg];
    UILabel *payLabel = [[UILabel alloc]initWithFrame:CGRectMake(62, payImg.frame.origin.y+3, 100, 13)];
    payLabel.text = @"支付宝支付";
    payLabel.font = [UIFont systemFontOfSize:12];
    [payView addSubview:payLabel];
    _btnPay = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnPay.frame = CGRectMake(0, 3 , SCREENWIDTH, 45);
    [_btnPay addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _btnPay.tag = 500;
    [payView addSubview:_btnPay];
    
    _imgPayUnselect = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-34, 13, 18.5, 18.5)];
    _imgPayUnselect.image = [UIImage imageNamed:@"btn_select_pay"];
    [payView addSubview:_imgPayUnselect];
    
    //微信支付页面
    UIView *weixinView = [[UIView alloc]init];
    weixinView.frame = CGRectMake(0, 51, SCREENWIDTH, 51);
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 50.5, SCREENWIDTH, 0.5)];
    line2.backgroundColor = [BBSColor hexStringToColor:@"ebebeb"];
    [weixinView addSubview:line2];
    UIImageView *weixinImg = [[UIImageView alloc]initWithFrame:CGRectMake(13,15, 41, 24)];
    weixinImg.image = [UIImage imageNamed:@"img_order_weixin"];
    [weixinView addSubview:weixinImg];
    
    UILabel *weixinLabel = [[UILabel alloc]initWithFrame:CGRectMake(62,weixinImg.frame.origin.y+3, 100, 13)];
    weixinLabel.text = @"微信支付";
    weixinLabel.font = [UIFont systemFontOfSize:12];
    [weixinView addSubview:weixinLabel];
    
    _btnWeiXin = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnWeiXin.frame = CGRectMake(0, 1 , SCREENWIDTH, 45);
    [_btnWeiXin addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _btnWeiXin.tag = 600;
    [weixinView addSubview:_btnWeiXin];
    _imgWeiXinUnselect = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-34,13, 18.5, 18.5)];
    _imgWeiXinUnselect.image = [UIImage imageNamed:@"btn_unselect_pay"];
    [weixinView addSubview:_imgWeiXinUnselect];
    if (_isWXAppInstalled == YES) {
        self.backView6 = [[UIView alloc]initWithFrame:CGRectMake(0, self.backView5.frame.origin.y+self.backView5.frame.size.height+10, SCREEN_WIDTH, 102)];
        self.backView6.backgroundColor = [UIColor whiteColor];
        [_bottomScrollView addSubview:self.backView6];
        [self.backView6 addSubview:payView];
        [self.backView6 addSubview:weixinView];
    }else{
        self.backView6 = [[UIView alloc]initWithFrame:CGRectMake(0, self.backView5.frame.origin.y+self.backView5.frame.size.height+10, SCREEN_WIDTH, 51)];
        self.backView6.backgroundColor = [UIColor whiteColor];
        [_bottomScrollView addSubview:self.backView6];
        [self.backView6 addSubview:payView];
    }
    
    _btnSurePay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnSurePay.layer.masksToBounds = YES;
    _btnSurePay.layer.cornerRadius = 21;
    _btnSurePay.frame = CGRectMake(13,self.backView6.frame.origin.y+self.backView6.frame.size.height+12, SCREENWIDTH-27, 43);
    _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
    _btnSurePay.titleLabel.text = @"确认支付";
    [_btnSurePay setTitle:@"确认支付" forState:UIControlStateNormal];
    [_btnSurePay setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
    [_bottomScrollView addSubview:_btnSurePay];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.combined_order_id,@"combined_order_id",_invite_user_id,@"invite_user_id",nil];
    self.param = params;
    [self getDataAndView:NO];
}
-(void)getDataAndView:(BOOL)isOrNoBalance{
    [_imageViewWrong removeFromSuperview];
    NSString *url;
    if (isOrNoBalance == YES) {
        //代表是编辑过的
        url = @"editToysBalancePrice";
    }else{
        url = @"getToysOrderPriceNew";
    }
    [[HTTPClient sharedClient]getNewV1:url params:self.param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *dataDic = result[@"data"];
            NSLog(@"datadic = %@",dataDic);
            //是什么支付
            self.isPayment = dataDic[@"is_payment"];
            self.orderId = dataDic[@"order_id"];
            NSString *card_title = dataDic[@"prompt_title"];
            if (card_title.length <=0) {
                self.carAlertView.frame = CGRectMake(0, 0, SCREENWIDTH, 0);
            }else{
                CGFloat cardHeight = [self getHeightByWidth:SCREENWIDTH-40 title:card_title font:[UIFont systemFontOfSize:12]];
                if (cardHeight <= 12) {
                    cardHeight = 17;
                }else{
                    cardHeight = cardHeight;
                }
                self.alertLabel.frame  = CGRectMake(27, 9,SCREEN_WIDTH-40,cardHeight);
                self.alertLabel.text = card_title;
                self.carAlertView.frame = CGRectMake(0, 0, SCREENWIDTH, cardHeight+18);
            }
            
            self.isBalance = dataDic[@"is_balance"];
            NSString *isHidden = dataDic[@"show_balance"];;
            
            if ([isHidden isEqualToString:@"1"]) {
                //显示
                self.backView7.frame = CGRectMake(0, self.carAlertView.frame.origin.y+self.carAlertView.frame.size.height+10, SCREEN_WIDTH, 47);
                self.balance_info = dataDic[@"balance_info"];
                self.labelMoney.text = self.balance_info;
                [self.ButMoney addTarget:self action:@selector(chooseRedBag) forControlEvents:UIControlEventTouchUpInside];
                //是否可以使用余额
                if ([self.isBalance isEqualToString:@"1"]) {
                    self.moreImg.image = [UIImage imageNamed:@"btn_select_pay"];
                }else{
                    self.moreImg.image = [UIImage imageNamed:@"btn_unselect_pay"];
                }
            }else{
                //不显示余额支付
                self.backView7.frame = CGRectMake(0, self.carAlertView.frame.origin.y+self.carAlertView.frame.size.height, SCREENWIDTH, 0);
            }
            //3、价格信息的解析
            NSArray *priceArray = dataDic[@"price"];
            float heightPack = 0 ;
            for (UIView *tempView in self.backView4.subviews) {
                [tempView removeFromSuperview];
            }
            for (NSDictionary *priceDic in priceArray) {
                UIView *priceView = [[UIView alloc]initWithFrame:CGRectMake(0,heightPack, SCREENWIDTH, 30)];
                [self.backView4 addSubview:priceView];
                NSString *title = priceDic[@"price_title"];
                NSString *price = priceDic[@"sell_price"];
                BaseLabel *leftLabel = [BaseLabel makeFrame:CGRectMake(10, 10, 180, 15) font:14 textColor:@"666666" textAlignment:NSTextAlignmentLeft text:title];
                leftLabel.numberOfLines = 0;
                [priceView addSubview:leftLabel];
                CGFloat height = [self getHeightByWidth:180 title:title font:[UIFont systemFontOfSize:14]];
                leftLabel.frame = CGRectMake(10, 10, 180, height);
                priceView.frame = CGRectMake(0, heightPack, SCREENWIDTH, height+20);
                CGFloat heightView = height+20;
                BaseLabel *rightLabel = [BaseLabel makeFrame:CGRectMake(SCREENWIDTH-120, 10, 110, 15) font:14 textColor:@"666666" textAlignment:NSTextAlignmentRight text:price];
                [priceView addSubview:rightLabel];
                heightPack += heightView;
            }
            
            self.backView4.frame = CGRectMake(0, self.backView7.frame.origin.y+self.backView7.frame.size.height+10, SCREENWIDTH, heightPack);
            //5、合计
     
            NSString *total_title = dataDic[@"total_title"];
            self.total_price = dataDic[@"total_price"];
            self.pay_total_price = dataDic[@"pay_total_price"];
            self.business_title = dataDic[@"pay_title"];
            
            self.labelTotal.text = total_title;
            self.labelTotalPrice.text = self.total_price;
            self.backView5.frame = CGRectMake(0, self.backView4.frame.origin.y+self.backView4.frame.size.height, SCREEN_WIDTH, 40);
            //支付方式
            self.backView6.frame = CGRectMake(0, self.backView5.frame.origin.y+self.backView5.frame.size.height+10, SCREEN_WIDTH, self.backView6.frame.size.height);
            _btnSurePay.frame = CGRectMake(13,self.backView6.frame.origin.y+self.backView6.frame.size.height+12, SCREENWIDTH-27, 43);
            //确认支付的按钮
            [_btnSurePay addTarget:self action:@selector(paySure) forControlEvents:UIControlEventTouchUpInside];
            _bottomScrollView.contentSize = CGSizeMake(SCREENWIDTH, _btnSurePay.frame.origin.y+_btnSurePay.frame.size.height+20);
        }else{
            if ([[result objectForKey:@"reCode"]integerValue] == 3000) {
                [self PaySuccessAndpopVC];
                [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
            }else{
                [self showWrongNet:@"1"];
                [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
            }
            //订单出现问题的时候的状态分析
        }
    } failed:^(NSError *error) {
        [self showWrongNet:@"2"];
    }];
}
#pragma mark 加载失败的页面展示
-(void)showWrongNet:(NSString*)type{
    //[_bottomScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    _imageViewWrong = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    if ([type isEqualToString:@"1"]) {
        _imageViewWrong.image = [UIImage imageNamed :@"toy_lease_pay_cancel_img"];
    }else{
    if (SCREENWIDTH==320 && SCREENHEIGHT==480 ) {
        _imageViewWrong.image = [UIImage imageNamed :@"img_netwrong_4"];
    }else if (SCREENWIDTH==320 && SCREENHEIGHT==568){
        _imageViewWrong.image = [UIImage imageNamed :@"img_netwrong_5"];
    }else if(SCREENWIDTH==375 && SCREENHEIGHT==667){
        _imageViewWrong.image = [UIImage imageNamed :@"img_netwrong_6"];
    }else if(SCREENWIDTH==414 && SCREENHEIGHT==736){
        _imageViewWrong.image = [UIImage imageNamed :@"img_netwrong_6p"];
    }else{
        _imageViewWrong.image =[UIImage imageNamed :@"img_netwrong_6"];
        
    }
    }
    _bottomScrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREEN_HEIGHT);
    [self.view addSubview:_imageViewWrong];
    _imageViewWrong.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getDataAndView:)];
    [_imageViewWrong addGestureRecognizer:singleTap];
}
#pragma mark 余额支付页面
-(void)chooseRedBag{
    if ([self.isBalance isEqualToString:@"1"]) {
        self.moreImg.image = [UIImage imageNamed:@"btn_unselect_pay"];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.combined_order_id,@"combined_order_id",@"0",@"is_balance",nil];
        self.param = params;
        [self getDataAndView:YES];
    }else{
        self.moreImg.image = [UIImage imageNamed:@"btn_select_pay"];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.combined_order_id,@"combined_order_id",@"1",@"is_balance",nil];
        self.param = params;
        [self getDataAndView:YES];
    }
}
#pragma mark 选择支付方式
-(void)buttonAction:(UIButton*)sender{
    UIButton *button = (UIButton*)sender;
    _selectButtonTag = button.tag;
    if (button.tag == 500) {
        //支付宝
        _imgPayUnselect.image=[UIImage imageNamed:@"btn_select_pay"];
        _imgWeiXinUnselect.image = [UIImage imageNamed:@"btn_unselect_pay"];
    }else if (button.tag == 600){
        //微信
        _imgPayUnselect.image=[UIImage imageNamed:@"btn_unselect_pay"];
        _imgWeiXinUnselect.image = [UIImage imageNamed:@"btn_select_pay"];
        
    }
}
-(void)paySure{
    //0元支付
    if ([self.isPayment isEqualToString:@"0"]) {
        //结果为0
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.pay_total_price,@"price",self.combined_order_id,@"combined_order_id", nil];
        //免费类型
        [[HTTPClient sharedClient]getNewV1:@"payToysOrderV1" params:params success:^(NSDictionary *result) {
            if ([[result objectForKey:kBBSSuccess]boolValue]) {
                [self PaySuccessAndpopVC];
            }else{
                _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
                _btnSurePay.enabled = YES;
                [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
            }
        } failed:^(NSError *error) {
            _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
            _btnSurePay.enabled = YES;
            [BBSAlert showAlertWithContent:@"您似乎与网络断开,检查一下吧！" andDelegate:self];
        }];
    }else{
        if (_selectButtonTag == 500) {
            //支付宝支付
            [self alipayOrder];
        }else if (_selectButtonTag == 600){
            //微信支付
            [self weXinPayOrder];

        }else{
            [self alipayOrder];
        }
    }
}

#pragma mark 支付宝支付,支付成功后的跳转，如果是单个订单跳转订单详情，如果是批次订单，跳转订单列表
-(void)PaySuccessAndpopVC{
    //fromwhere 来自哪，0代表玩具详情，1代表购物车，2代表来着订单物流详情支付,3代表订单列表,4代表来自非首页购物车
    //如果是1代表单个订单,跳订单详情，如果是2代表批量订单，跳订单列表
    if (self.orderId.length > 0) {
        //fromwhere 来自哪，0代表玩具详情，1代表购物车，2代表来着订单物流详情支付,3代表订单列表
        if ([self.fromWhere isEqualToString:@"2"]) {
            //来自物流，返回刷新
            [[NSNotificationCenter defaultCenter]postNotificationName:USER_TOY_PAY_SUCCEED object:self.orderId];
            [self popVC:[ToyTransportVC class]];
        }else{
            //如果是来自其他直接跳转订单详情
            [self pushToyVC];
        }
    }else{
        //如果是多个玩具,跳转玩具订单列表
        [self pushToyCarOrOrderList];
    }
}
#pragma mark 支付宝支付
-(void)alipayOrder{
    _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
    _btnSurePay.enabled = YES;
    NSString *partner = KPartner;
    NSString *seller ;//= KSeller;
    NSString *privateKey = KPrivateKey;
    //生成订单信息及签名
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
        _btnSurePay.enabled = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"暂不支持支付宝"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = [NSString stringWithFormat:@"%@d4",self.combined_order_id]; //订单ID（由商家自行制定）
    order.productName = _business_title; //商品标题
    order.productDescription = _business_title; //商品描述
    order.amount = self.pay_total_price; //商品价格
    order.notifyURL =  @"http://checkpic.meimei.yihaoss.top/BusPay/notifyurlorder"; //回调URL
    order.service = @"mobile.securitypay.pay";
    
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"AlipayInBabyShow";
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        //支付结果回调
        __weak MakeSureMoneyVC *payOrderVC = self;
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"支付宝result了 = %@",resultDic);
            NSInteger result = [[resultDic objectForKey:@"resultStatus"] integerValue];
            switch (result) {
                case 9000:{
                    NSLog(@"支付宝成功啦");
                    [self PaySuccessAndpopVC];
                }
                    break;
                case 8000:{
                    
                    NSString *resultPay = @"正在处理";
                    [payOrderVC resultPayStr:resultPay];
                }
                    break;
                case 4000:{
                    NSString *resultPay = @"支付失败,请返回重新";
                    [payOrderVC resultPayStr:resultPay];
                }
                    break;
                case 6001:{
                    NSString *resultPay = @"用户取消,请返回重新";
                    [payOrderVC resultPayStr:resultPay];
                    
                }
                    break;
                case 6002:{
                    NSString *resultPay = @"网络连接出错,请检查您的网络是否连接";
                    [payOrderVC resultPayStr:resultPay];
                    
                }
                    break;
                    
                default:
                    break;
            }
            
        }];
    }
    
}
/**
 *  支付宝处理返回客户端参数
 *
 *  @param result 客户端错误码
 */
- (void)resultPayStr:(NSString *)result{
    UIAlertView * alertPay = [[UIAlertView alloc] initWithTitle:nil message:result delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertPay show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
        // [self.navigationController popViewControllerAnimated:YES];
    }
}
//客户端提示信息
- (void)alert:(NSString *)title msg:(NSString *)msg
{
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alter show];
}
#pragma mark 微信支付
-(void)weXinPayOrder{
    _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
    _btnSurePay.enabled = YES;
    //本实例只是演示签名过程， 请将该过程在商户服务器上实现
    //创建支付签名对象
    payRequsestHandler *req = [payRequsestHandler alloc];
    //初始化支付签名对象
    [req init:APP_ID mch_id:MCH_ID];
    //设置密钥
    NSLog(@"app秘钥 = %@,%@",PARTNER_ID,[[NSUserDefaults standardUserDefaults]objectForKey:@"weiXinAppApi"]);
    
    if ( PARTNER_ID.length <= 6) {
        //这种情况看看
        if (![[NSUserDefaults standardUserDefaults]objectForKey:@"weiXinAppApi"]) {
            [self getAppWX];
        }else{
            theAppDelegate.appSecret = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"weiXinAppApi"]];
        }
        
    }
    [req setKey:PARTNER_ID];
    //获取到实际调起微信支付的参数后，在app端调起支付
    NSString *price =  self.pay_total_price;
    _appding++;
    NSString *appedingString  = [NSString stringWithFormat:@"%@a%ldd4",self.combined_order_id,_appding];
    
    NSMutableDictionary *dict = [req temp_name:_business_title tempno:appedingString   temp_price:price];
    NSLog(@"dict微信支付的 = %@",dict);
    if (dict == nil) {
        
        //错误提示
        NSString *debug = [req getDebugifo];
        NSLog(@"%@",debug);
        [self alert:@"提示信息" msg:@"出现了点问题稍后重试"];
        
    }else{
        _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
        _btnSurePay.enabled = YES;
        
        NSLog(@"%@\n\n",[req getDebugifo]);
        //[self alert:@"确认" msg:@"下单成功，点击OK后调起支付！"];
        
        NSLog(@"dict = %@",dict);
        NSMutableString *stamp  = [dict objectForKey:@"timestamp"];
       
        //调起微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.openID              = [dict objectForKey:@"appid"];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = stamp.intValue;
        NSLog(@"req.timeatamp = %u",(unsigned int)req.timeStamp);
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        [WXApi sendReq:req];
    }
    
}

#pragma mark //传入字符串，控件宽，字体，比较的高，最大的高，最小的高
-(CGFloat)getHeightByWidth:(CGFloat)width title:(NSString*)title font:(UIFont*)font{
    NIAttributedLabel *label = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}
#pragma mark 支付完成跳转问题
-(void)popVC:(id)class{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:class]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:USER_TOY_PAY_SUCCEED object:self.orderId];
            [self.navigationController popToViewController:temp animated:YES];
            break;
        }
    }

}
-(void)pushToyVC{
    ToyTransportVC *toyVC = [[ToyTransportVC alloc]init];
    toyVC.order_id = self.orderId;
    toyVC.fromWhere = self.fromWhere;
    toyVC.isHaveShare = YES;
    [self.navigationController pushViewController:toyVC animated:YES];

}
#pragma mark 批次订单成功后的跳转
-(void)pushToyCarOrOrderList{
    NSInteger count = self.navigationController.viewControllers.count;
    NSInteger a = 0;
    NSArray *controllerCount = self.navigationController.viewControllers;
    for (int i = 1; i < count+1; i++) {
        if ([[controllerCount objectAtIndex:i-1] isKindOfClass:[ToyLeaseNewVC class]]) {
            a = i;
        }
    }
    if (a != 0) {
        [self.navigationController popToViewController:[controllerCount objectAtIndex:a-1] animated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:USER_TOY_PAYCOMBINE_SUCCEED object:nil];
    }else{
        ToyLeaseNewVC *toyLeaseListVc = [[ToyLeaseNewVC alloc]init];
        toyLeaseListVc.inTheViewData =  2003;
        toyLeaseListVc.isAfterPay = YES;
        [self.navigationController pushViewController:toyLeaseListVc animated:YES];
    }
}
#pragma mark 微信支付失败的时候的回调
-(void)payFail{
    _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
    _btnSurePay.enabled = YES;
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
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
