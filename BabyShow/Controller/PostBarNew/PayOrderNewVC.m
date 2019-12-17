//
//  PayOrderNewVC.m
//  BabyShow
//
//  Created by WMY on 16/3/28.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PayOrderNewVC.h"
#import "SubmitOrderViewController.h"
#import "Order.h"
#import "DataSigner.h"
#import <AlipaySDK/AlipaySDK.h>
#import "MyOrdersViewController.h"
#import "WXApi.h"
#import "payRequsestHandler.h"
#import <ShareSDKExtension/ShareSDK+Extension.h>
@interface PayOrderNewVC ()
@property(nonatomic,strong)UIScrollView *bottomScrollView;
@property(nonatomic,strong)UILabel *labelOrderName;
@property(nonatomic,strong)UILabel *labelOrderPrice;
@property(nonatomic,strong)UILabel *labelNeedPay;
@property(nonatomic,strong)UILabel *labelNeedPayPrice;
@property(nonatomic,strong)UIButton *btnPayInStore;
@property(nonatomic,strong)UIImageView *imgPayStoreUnselect;
@property(nonatomic,strong)UIButton *btnPay;
@property(nonatomic,strong)UIImageView *imgPayUnselect;
@property(nonatomic,strong)UIButton *btnWeiXin;
@property(nonatomic,strong)UIImageView *imgWeiXinUnselect;
@property(nonatomic,strong)UIButton *btnUnion;
@property(nonatomic,strong)UIImageView *imgUnionUnselect;
@property(nonatomic,strong)UIButton *btnSurePay;
@property(nonatomic,strong)UILabel *labelMoney;
@property(nonatomic,assign)NSInteger selectButtonTag;

@property(nonatomic,strong)UILabel *babyShowRedLabel;
@property(nonatomic,strong)UILabel *redBagLabel;
@property(nonatomic,strong)UIImageView *redBagImg;
@property(nonatomic,strong)YLButton *redBagBtn;
@property(nonatomic,strong)NSString *resultMoney;
@property(nonatomic,assign)BOOL isSelect;
@property(nonatomic,assign)BOOL isHavePacket;
@property(nonatomic,assign)NSInteger appding;
@property(nonatomic,strong)UIView *backView2;

@property(nonatomic,assign)BOOL isWXAppInstalled;
@property(nonatomic,strong)NSString *business_payment;//支持哪种支付方式
@property(nonatomic,strong)NSString *business_title;//商家名称
@property(nonatomic,strong)NSString *price;//需要支付
@property(nonatomic,strong)NSString *need_price;//订单价格
@property(nonatomic,assign)NSInteger packet_id;//是否有红包
@property(nonatomic,strong)NSString *packet_price;//红包价格
@property(nonatomic,strong)UIView *backPayView;

@end

@implementation PayOrderNewVC

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
    _btnSurePay.enabled = YES;
    if ([ShareSDK isClientInstalled:SSDKPlatformTypeWechat]) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushOrderList) name:USER_WEIXINPAY_SUCCEED object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(payFail) name:USER_WEIXINPAY_FAIL object:nil];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(checkOrderIsPay) name:USER_ISPAY object:nil];
 
    //如果没有获取秘钥，再次请求
     if(PARTNER_ID.length <= 6){
    NSLog(@"再次请求app秘钥 = %@,app.le = %ld",PARTNER_ID,PARTNER_ID.length);
        [self getAppWX];
        
    }


}
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
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
//检测一下订单是否被支付过
-(void)checkOrderIsPay{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_order_id,@"order_id", nil];
    [[HTTPClient sharedClient]getNewV1:kCheckOrderPay params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *dataDic = result[@"data"];
            NSString *status = dataDic[@"status"];
            if ([status isEqualToString:@"2"]) {
                
            }else{
                [BBSAlert showAlertWithContent:@"此订单已完成" andDelegate:self andDismissAnimated:2];
                MyOrdersViewController *myOrderVC = [[MyOrdersViewController alloc]init];
                myOrderVC.fromPayOrder = @"fromPayOrder";
                [self.navigationController pushViewController:myOrderVC animated:YES];
                
            }
        }
        
    } failed:^(NSError *error) {
        
    }];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //此为微信支付的时调出页面的次数
    _appding=0;
    //是否安装微信
    _isWXAppInstalled = [ ShareSDK isClientInstalled:SSDKPlatformTypeWechat];
    [self setLeftButton];
    _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,self.view.bounds.size.height)];
    _bottomScrollView.alwaysBounceVertical = YES;
    _bottomScrollView.backgroundColor = [BBSColor hexStringToColor:@"f9f9f9"];
    [self.view addSubview:_bottomScrollView];
    //调取支付的相关数据
    [self getDataPayOrder];
    
    // Do any additional setup after loading the view.
}
#pragma mark UI
-(void)setLeftButton{
    
    //返回按钮
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 31)];
    imagev.image = [UIImage imageNamed:@"btn_back1.png"];
    [_backBtn addSubview:imagev];
    UILabel *cateName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 31)];
    cateName.textColor = [UIColor whiteColor];
    cateName.text = @"支付订单";
    [_backBtn addSubview:cateName];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
#pragma mark 加载成功的页面
-(void)setSubViews{
    [_bottomScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    UIImageView *backView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 80)];
    backView1.image = [UIImage imageNamed:@"img_order_back1"];
    [_bottomScrollView addSubview:backView1];
    
    //订单图标
    UIImageView *orderImg = [[UIImageView alloc]initWithFrame:CGRectMake(18, 12, 12.5, 14.5)];
    orderImg.image = [UIImage imageNamed:@"img_order_order"];
    [backView1 addSubview:orderImg];
    //订单名称
    _labelOrderName = [[UILabel alloc]initWithFrame:CGRectMake(42, 12, 250, 15)];
    _labelOrderName.font = [UIFont systemFontOfSize:14];
    _labelOrderName.textColor = [BBSColor hexStringToColor:@"000000"];
    _labelOrderName.text =[NSString stringWithFormat:@"订单名称：%@",_business_title];
    [backView1 addSubview:_labelOrderName];
    //订单价格图标
    UIImageView *priceImg = [[UIImageView alloc]initWithFrame:CGRectMake(18, 43, 14.5, 14.5)];
    priceImg.image = [UIImage imageNamed:@"img_order_price"];
    [backView1 addSubview:priceImg];
    //订单价格
    _labelOrderPrice = [[UILabel alloc]initWithFrame:CGRectMake(42, 43, 250, 15)];
    _labelOrderPrice.font = [UIFont systemFontOfSize:14];
    _labelOrderPrice.text =  [NSString stringWithFormat:@"订单价格：¥%@",_need_price];
    [backView1 addSubview:_labelOrderPrice];
    
    //支付宝支付的页面
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
    _btnPay.frame = CGRectMake(0, 1 , SCREENWIDTH, 45);
    [_btnPay addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _btnPay.tag = 500;
    [payView addSubview:_btnPay];
    
    _imgPayUnselect = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-34, 10, 18.5, 18.5)];
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
    _imgWeiXinUnselect = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-34,10, 18.5, 18.5)];
    _imgWeiXinUnselect.image = [UIImage imageNamed:@"btn_unselect_pay"];
    [weixinView addSubview:_imgWeiXinUnselect];
    
    
    //上门支付
    UIView *inStorePayView = [[UIView alloc]init];
    inStorePayView.frame = CGRectMake(0, 51, SCREENWIDTH, 51);
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 50.5, SCREENWIDTH, 0.5)];
    line3.backgroundColor = [BBSColor hexStringToColor:@"ebebeb"];
    [inStorePayView addSubview:line3];
    UIImageView *inStoreImg = [[UIImageView alloc]initWithFrame:CGRectMake(13,15, 41, 24)];
    inStoreImg.image = [UIImage imageNamed:@"img_order_storePay"];
    [inStorePayView addSubview:inStoreImg];
    
    UILabel *inStoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(62,inStoreImg.frame.origin.y+3, 100, 13)];
    inStoreLabel.text = @"上门支付";
    inStoreLabel.font = [UIFont systemFontOfSize:12];
    [inStorePayView addSubview:inStoreLabel];
   
    _btnPayInStore = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnPayInStore.frame = CGRectMake(0, 1, SCREENWIDTH, 45);
    _btnPayInStore.backgroundColor = [UIColor clearColor];
    [_btnPayInStore addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _btnPayInStore.tag = 800;
    [inStorePayView addSubview:_btnPayInStore];
    
    _imgPayStoreUnselect = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-34, 10, 18.5, 18.5)];
    _imgPayStoreUnselect.image = [UIImage imageNamed:@"btn_unselect_pay"];
    [inStorePayView addSubview:_imgPayStoreUnselect];

    
    //成长记录关注的时候升级为白金会员需要的支付页面，无红包，无上门支付
    if ([self.order_role isEqualToString:@"1"]) {
        _backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, backView1.frame.origin.y+80+7.5, SCREENWIDTH, 51)];
        _backView2.backgroundColor = [UIColor whiteColor];
        //还需支付
        UILabel *needPayLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 14, 85, 16)];
        needPayLabel.text = @"还需支付：";
        needPayLabel.font = [UIFont systemFontOfSize:16];
        needPayLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        [_backView2 addSubview:needPayLabel];
        //需要支付的钱数
        _labelMoney = [[UILabel alloc]initWithFrame:CGRectMake(100, 14, 100, 15)];
        _labelMoney.textColor = [BBSColor hexStringToColor:@"ff8042"];
        _labelMoney.font = [UIFont systemFontOfSize:14];
        _labelMoney.text = [NSString stringWithFormat:@"¥%@",_price];
        [_backView2 addSubview:_labelMoney];
        [_bottomScrollView addSubview:_backView2];

        if (_isWXAppInstalled == YES) {
            _backPayView = [[UIView alloc]initWithFrame:CGRectMake(0, _backView2.frame.origin.y+51, SCREENWIDTH, 102)];
            _backPayView.backgroundColor = [UIColor whiteColor];
            [_bottomScrollView addSubview:_backPayView];
            [_backPayView addSubview:payView];
            weixinView.frame = CGRectMake(0, 51, SCREENWIDTH, 51);
            [_backPayView addSubview:weixinView];
           
        }else{
            _backPayView = [[UIView alloc]initWithFrame:CGRectMake(0, _backView2.frame.origin.y+51, SCREENWIDTH, 51)];
            _backPayView.backgroundColor = [UIColor whiteColor];
            [_bottomScrollView addSubview:_backPayView];
            [_backPayView addSubview:payView];
        }
    }else{
        //正常秀秀商家支付的页面，有红包有上门支付
        UIView *backView3 = [[UIView alloc]initWithFrame:CGRectMake(0, backView1.frame.origin.y+80+7.5, SCREENWIDTH, 46)];
        backView3.backgroundColor = [UIColor whiteColor];
        [_bottomScrollView addSubview:backView3];
        self.babyShowRedLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 16, 85, 16)];
        self.babyShowRedLabel.text = @"秀秀红包";
        self.babyShowRedLabel.font = [UIFont systemFontOfSize:16];
        self.babyShowRedLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        [backView3 addSubview:self.babyShowRedLabel];
        
        self.redBagLabel = [[UILabel alloc]initWithFrame:CGRectMake(125, 14, 154, 15)];
        self.redBagLabel.textAlignment = NSTextAlignmentRight;
        self.redBagLabel.font = [UIFont systemFontOfSize:13];
        self.redBagLabel.textColor = [BBSColor hexStringToColor:@"fe4d3d"];
        [backView3 addSubview:self.redBagLabel];
        if (_packet_id == 0) {
            self.redBagLabel.text = @"暂无红包可用";
            _isHavePacket = 0;
        }else{
            self.redBagLabel.text = @"点击可使用红包";
            _isHavePacket = 1;
            self.redBagBtn = [YLButton buttonEasyInitBackColor:nil frame:CGRectMake(140, 14, SCREENWIDTH-140, 15) type:UIButtonTypeSystem backImage:nil target:self action:nil forControlEvents:UIControlEventTouchUpInside];
            [backView3 addSubview:self.redBagBtn];
            [self.redBagBtn addTarget:self action:@selector(chooseRedBag) forControlEvents:UIControlEventTouchUpInside];
            self.redBagImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-35, 13, 17.5, 17.5)];
            self.redBagImg.image = [UIImage imageNamed:@"btn_unselect_pay"];
            [backView3 addSubview:self.redBagImg];

        }
        _backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, backView3.frame.origin.y+46+7.5, SCREENWIDTH, 51)];
        _backView2.backgroundColor = [UIColor whiteColor];
        
        //还需支付
        UILabel *needPayLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, 14, 85, 16)];
        needPayLabel.text = @"还需支付：";
        needPayLabel.font = [UIFont systemFontOfSize:16];
        needPayLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        [_backView2 addSubview:needPayLabel];
        
        
        _labelMoney = [[UILabel alloc]initWithFrame:CGRectMake(100, 14, 100, 15)];
        _labelMoney.textColor = [BBSColor hexStringToColor:@"ff8042"];
        _labelMoney.font = [UIFont systemFontOfSize:14];
        _labelMoney.text = [NSString stringWithFormat:@"¥%@",_price];
        [_backView2 addSubview:_labelMoney];
        [_bottomScrollView addSubview:_backView2];
        if (_isWXAppInstalled == YES) {
            if ([_business_payment isEqualToString:@"0"]) {
                //支持所有
                _backPayView = [[UIView alloc]initWithFrame:CGRectMake(0, _backView2.frame.origin.y+51, SCREENWIDTH, 153)];
                _backPayView.backgroundColor = [UIColor whiteColor];
                [_bottomScrollView addSubview:_backPayView];
                //支付宝
                [_backPayView addSubview:payView];
                //微信支付
                weixinView.frame = CGRectMake(0, 51, SCREENWIDTH, 51);
                [_backPayView addSubview:weixinView];
                //上门支付
                inStorePayView.frame = CGRectMake(0, 102, SCREENWIDTH, 51);
                [_backPayView addSubview:inStorePayView];
                
            }else if ([_business_payment isEqualToString:@"1"]){
                _backPayView = [[UIView alloc]initWithFrame:CGRectMake(0, _backView2.frame.origin.y+51, SCREENWIDTH, 102)];
                _backPayView.backgroundColor = [UIColor whiteColor];
                [_bottomScrollView addSubview:_backPayView];
                [_backPayView addSubview:payView];
                weixinView.frame = CGRectMake(0, 51, SCREENWIDTH, 51);
                [_backPayView addSubview:weixinView];
                //线上
                
            }else if ([_business_payment isEqualToString:@"2"]){
                //上门
                _backPayView = [[UIView alloc]initWithFrame:CGRectMake(0,  _backView2.frame.origin.y+51, SCREENWIDTH, 51)];
                _backPayView.backgroundColor = [UIColor whiteColor];
                [_bottomScrollView addSubview:_backPayView];
                inStorePayView.frame = CGRectMake(0, 0, SCREENWIDTH, 51);
                [_backPayView addSubview:inStorePayView];
                self.redBagLabel.text = @"上门支付不可用";
                self.redBagImg.hidden = YES;
                self.redBagBtn.hidden = YES;
                _selectButtonTag=800;


            }
        }else{
            //未安装微信
            if ([_business_payment isEqualToString:@"0"]) {
                //支持所有
                _backPayView = [[UIView alloc]initWithFrame:CGRectMake(0,  _backView2.frame.origin.y+51, SCREENWIDTH, 102)];
                _backPayView.backgroundColor = [UIColor whiteColor];
                [_bottomScrollView addSubview:_backPayView];
                [_backPayView addSubview:payView];
                inStorePayView.frame = CGRectMake(0, 51, SCREENWIDTH, 51);
                [_backPayView addSubview:inStorePayView];

                
            }else if ([_business_payment isEqualToString:@"1"]){
                //支持线上
                _backPayView = [[UIView alloc]initWithFrame:CGRectMake(0,  _backView2.frame.origin.y+51, SCREENWIDTH, 51)];
                _backPayView.backgroundColor = [UIColor whiteColor];
                [_bottomScrollView addSubview:_backPayView];
                [_backPayView addSubview:payView];
                
            }else if ([_business_payment isEqualToString:@"2"]){
                //支持线下
                _backPayView = [[UIView alloc]initWithFrame:CGRectMake(0, _backView2.frame.origin.y+51, SCREENWIDTH, 51)];
                _backPayView.backgroundColor = [UIColor whiteColor];
                [_bottomScrollView addSubview:_backPayView];
                
                inStorePayView.frame = CGRectMake(0, 0, SCREENWIDTH, 51);
                [_backPayView addSubview:inStorePayView];
                self.redBagLabel.text = @"上门支付不可用";
                self.redBagImg.hidden = YES;
                self.redBagBtn.hidden = YES;
                _selectButtonTag=800;

                
            }
        }
        
    }
    
    _btnSurePay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnSurePay.layer.masksToBounds = YES;
    _btnSurePay.layer.cornerRadius = 20;
    _btnSurePay.frame = CGRectMake(13, _backPayView.frame.origin.y+_backPayView.frame.size.height+12, SCREENWIDTH-27, 43);
    _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
    _btnSurePay.titleLabel.text = @"确认支付";
    
    [_btnSurePay setTitle:@"确认支付" forState:UIControlStateNormal];
    [_btnSurePay setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
    [_bottomScrollView addSubview:_btnSurePay];
    [_btnSurePay addTarget:self action:@selector(paySure) forControlEvents:UIControlEventTouchUpInside];
    
}
#pragma mark 加载失败的页面
-(void)showWrongNet{
    [_bottomScrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    if (SCREENWIDTH==320 && SCREENHEIGHT==480 ) {
        imageView.image = [UIImage imageNamed :@"img_netwrong_4"];
    }else if (SCREENWIDTH==320 && SCREENHEIGHT==568){
        imageView.image = [UIImage imageNamed :@"img_netwrong_5"];
    }else if(SCREENWIDTH==375 && SCREENHEIGHT==667){
        imageView.image = [UIImage imageNamed :@"img_netwrong_6"];
    }else if(SCREENWIDTH==414 && SCREENHEIGHT==736){
        imageView.image = [UIImage imageNamed :@"img_netwrong_6p"];
    }else{
        imageView.image =[UIImage imageNamed :@"img_netwrong_6"];
        
    }
    [_bottomScrollView addSubview:imageView];
    imageView.userInteractionEnabled = YES;
      UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getDataPayOrder)];
    [imageView addGestureRecognizer:singleTap];
    
    
}
#pragma mark 数据加载
-(void)getDataPayOrder{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.business_id,@"business_id",self.priceCombine,@"package",self.order_role,@"order_role", nil];
    [[HTTPClient sharedClient]getNew:kPublicOrder params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue]==YES) {
            NSDictionary *dataDic = result[@"data"];
            _business_payment = dataDic[@"business_payment"];
            _business_title = dataDic[@"business_title"];
            _order_id = dataDic[@"order_id"];
            _price = dataDic[@"price"];
            _need_price = dataDic[@"need_price"];
            _packet_id = [dataDic[@"packet_id"]integerValue];
            _packet_price = dataDic[@"packet_price"];
            self.resultMoney = _price;
            [self setSubViews];
            //星期六
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
        }
    
    } failed:^(NSError *error) {
         [self showWrongNet];
    
    }];
    
}

#pragma mark 点击添加红包
-(void)chooseRedBag{
    if (_isSelect == NO) {
        _isSelect = YES;
        self.redBagLabel.text = [NSString stringWithFormat:@"已自动选择最优红包 %@元",_packet_price];
        float price = [_price floatValue];
        float packerPrice  = [_packet_price floatValue];
        float result = price - packerPrice;
        self.redBagImg.image = [UIImage imageNamed:@"btn_select_pay"];
        if (result <0) {
            self.resultMoney = @"0.0";
            _labelMoney.text = @"¥0.00";
        }else{
            self.resultMoney = [NSString stringWithFormat:@"%.2f",result];
            _labelMoney.text = [NSString stringWithFormat:@"¥%.2f",result];
        }
    }else{
        _isSelect = NO;
        self.redBagLabel.text = @"点击可使用红包";
        _labelMoney.text = [NSString stringWithFormat:@"¥%@",_price];
        self.redBagImg.image = [UIImage imageNamed:@"btn_unselect_pay"];
        self.resultMoney = _price;
    }
    
}
#pragma mark 点击事件
-(void)buttonAction:(UIButton*)sender{
    UIButton *button = (UIButton*)sender;
    _selectButtonTag = button.tag;
    if (button.tag == 500) {
        //支付宝
        _imgPayUnselect.image=[UIImage imageNamed:@"btn_select_pay"];
        _imgWeiXinUnselect.image = [UIImage imageNamed:@"btn_unselect_pay"];
        _imgPayStoreUnselect.image =[UIImage imageNamed:@"btn_unselect_pay"];
        if (_isHavePacket == 0) {
            self.redBagLabel.text = @"暂无红包可用";
            self.redBagImg.hidden = NO;
            self.resultMoney = _price;
            
        }else{
            if (_isSelect == NO) {
                self.redBagLabel.text = @"点击可使用红包";
                self.redBagImg.hidden = NO;
                self.redBagBtn.hidden = NO;
                _labelMoney.text = [NSString stringWithFormat:@"¥%@",_price];
                self.resultMoney =_price;
            }else{
                self.redBagLabel.text = [NSString stringWithFormat:@"已自动选择最优红包 %@元",_packet_price];
                self.redBagImg.hidden = NO;
                self.redBagBtn.hidden = NO;
                float price = [_price floatValue];
                float packerPrice  = [_packet_price floatValue];
                float result = price - packerPrice;
                NSLog(@"支付宝price = %f,%f,%f",price,packerPrice,result);
                if (result<=0) {
                    result = 0;
                }else{
                    result = result;
                }
                _labelMoney.text = [NSString stringWithFormat:@"¥%.2f",result];
                self.resultMoney = [NSString stringWithFormat:@"%.2f",result];
            }
        }
    } else if(button.tag == 600){
        //微信
        _imgPayUnselect.image=[UIImage imageNamed:@"btn_unselect_pay"];
        _imgWeiXinUnselect.image = [UIImage imageNamed:@"btn_select_pay"];
        _imgPayStoreUnselect.image =[UIImage imageNamed:@"btn_unselect_pay"];
        if (_isHavePacket == 0) {
            self.redBagLabel.text = @"暂无红包可用";
            self.redBagImg.hidden = NO;
            self.resultMoney = _price;
        }else{
            if (_isSelect == NO) {
                self.redBagLabel.text = @"点击可使用红包";
                self.redBagImg.hidden = NO;
                self.redBagBtn.hidden = NO;
                _labelMoney.text =[NSString stringWithFormat:@"¥%@",_price];
                self.resultMoney = _price;
            }else{
                self.redBagLabel.text = [NSString stringWithFormat:@"已自动选择最优红包 %@元",_packet_price];
                self.redBagImg.hidden = NO;
                self.redBagBtn.hidden = NO;
                float price = [_price floatValue];
                float packerPrice  = [_packet_price floatValue];
                float result = price - packerPrice;
                if (result<=0) {
                    result = 0;
                }else{
                    result = result;
                }
                _labelMoney.text = [NSString stringWithFormat:@"¥%.2f",result];
                self.resultMoney = [NSString stringWithFormat:@"%.2f",result];
                NSLog(@"微信price = %f,%f,%f,%@",price,packerPrice,result,self.resultMoney);
            }
        }
    }else if(button.tag == 800){
        //上门支付
        _imgPayUnselect.image=[UIImage imageNamed:@"btn_unselect_pay"];
        _imgWeiXinUnselect.image = [UIImage imageNamed:@"btn_unselect_pay"];
        _imgPayStoreUnselect.image =[UIImage imageNamed:@"btn_select_pay"];
        self.redBagLabel.text = @"上门支付不可用";
        self.redBagImg.hidden = YES;
        self.redBagBtn.hidden = YES;
        self.resultMoney = _price;
        _labelMoney.text = [NSString stringWithFormat:@"¥%@",_price];

    }
}
#pragma mark 点击支付确认
-(void)paySure{
    _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"cccccc"];
    _btnSurePay.enabled = NO;
    
    //如果是最后支付的价格是
    if ([self.resultMoney isEqualToString:@"0.00"] || [self.resultMoney isEqualToString:@"0.0"]||[self.resultMoney integerValue] <0) {
        NSString *payMent;
        if (_isSelect == NO) {
            payMent = @"5";
        }else{
            payMent = @"6";
        }
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",payMent,@"payment",_order_id,@"order_id",self.resultMoney,@"price", nil];
        [[HTTPClient sharedClient]getNew:KPayOrder params:params success:^(NSDictionary *result) {
            if ([[result objectForKey:kBBSSuccess]boolValue]==YES) {
                _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
                _btnSurePay.enabled = YES;
                MyOrdersViewController *myOrderVC = [[MyOrdersViewController alloc]init];
                myOrderVC.fromPayOrder = @"fromPayOrder";
                [self.navigationController pushViewController:myOrderVC animated:YES];
            }else{
                _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
                _btnSurePay.enabled = YES;
                [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
            }
            
        } failed:^(NSError *error) {
            
            _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
            _btnSurePay.enabled = YES;

            
        }];
        
        
    }else{
        if (_selectButtonTag == 800) {
            //上门支付
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",@"4",@"payment",_order_id,@"order_id",self.resultMoney,@"price", nil];
            [[HTTPClient sharedClient]getNew:KPayOrder params:params success:^(NSDictionary *result) {
                if ([[result objectForKey:kBBSSuccess]boolValue]==YES) {
                    _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
                    _btnSurePay.enabled = YES;
                    MyOrdersViewController *myOrderVC = [[MyOrdersViewController alloc]init];
                    myOrderVC.fromPayOrder = @"fromPayOrder";
                    [self.navigationController pushViewController:myOrderVC animated:YES];
                }else{
                    _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
                    _btnSurePay.enabled = YES;
                    [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
                }
                
            } failed:^(NSError *error) {
                _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
                _btnSurePay.enabled = YES;
                
            }];
        }else if(_selectButtonTag == 500){
            //支付宝支付
            [self alipayOrder];
            
        }else if(_selectButtonTag == 600){
           
                [self weXinPayOrder];
            
        }else if(_selectButtonTag == 700){
            //银联支付，暂时不需要
            self.channel = @"upacp";
            
        }else{
            //默认支付方式，支付宝
            self.channel = @"alipay";
            [self alipayOrder];
        }
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
    order.tradeNO = _order_id; //订单ID（由商家自行制定）
    order.productName = _business_title; //商品标题
    order.productDescription = _business_title; //商品描述
    order.amount = self.resultMoney; //商品价格
    
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
        NSLog(@"orderSpec1111111 = %@",orderSpec);

        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
    
        //支付结果回调
        __weak PayOrderNewVC *payOrderVC = self;
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"result支付宝支付支付宝 = %@",resultDic);
            NSInteger result = [[resultDic objectForKey:@"resultStatus"] integerValue];
            
   

            switch (result) {
                case 9000:{
                    _btnSurePay.enabled = YES;

                    MyOrdersViewController *myOrderVC = [[MyOrdersViewController alloc]init];
                    myOrderVC.fromPayOrder = @"fromPayOrder";
                    [self.navigationController pushViewController:myOrderVC animated:YES];
                    
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
//微信支付
-(void)weXinPayOrder{
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
    NSString *price = self.resultMoney;
    _appding++;
    NSString *appedingString  = [NSString stringWithFormat:@"%@a%ld",_order_id,_appding];
    
    NSMutableDictionary *dict = [req temp_name:_business_title tempno:appedingString   temp_price:price];
    NSLog(@"dict微信支付的 = %@",dict);
    if (dict == nil) {
        _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
        _btnSurePay.enabled = YES;

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
#pragma mark 微信支付成功的方法
-(void)pushOrderList{
    _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
    _btnSurePay.enabled = YES;

    MyOrdersViewController *myOrderVC = [[MyOrdersViewController alloc]init];
    myOrderVC.fromPayOrder = @"fromPayOrder";
    [self.navigationController pushViewController:myOrderVC animated:YES];
    
}
-(void)payFail{
    _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
    _btnSurePay.enabled = YES;
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
