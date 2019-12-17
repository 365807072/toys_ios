//
//  MakeSurePaySureVC.m
//  BabyShow
//
//  Created by WMY on 16/12/9.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MakeSurePaySureVC.h"
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
#import "MakeSureMoneyVC.h"
#import "EditAddressVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>

@interface MakeSurePaySureVC ()<UITextViewDelegate,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource>{
}
@property(nonatomic,strong)UIScrollView *bottomScrollView;//整体的底色
@property(nonatomic,strong)UIView *backView1;//用户需要填写的信息
@property(nonatomic,strong)BaseLabel *labelPhoneNumber;
@property(nonatomic,strong)BaseLabel *labelAddress;
@property(nonatomic,strong)BaseLabel *labelName;
@property(nonatomic,strong)UITextField *tfPhoneNumber;
@property(nonatomic,strong)UITextField *tfName;
@property(nonatomic,strong)UITextView *tfAddress;

@property(nonatomic,strong)BaseLabel *labelRemark;
@property(nonatomic,strong)UITextField *tfRemark;

@property(nonatomic,strong)UIView *backView2;//订单信息
@property(nonatomic, strong) UIImageView *photoView;
@property(nonatomic, strong) WMYLabel *toyNameLabel;
@property(nonatomic,strong)UILabel *priceLabel;


@property(nonatomic,strong)UIView *backView3;//租期信息
@property(nonatomic,strong)BaseLabel *labelLease;
@property(nonatomic,strong)BaseLabel *labelExplain;
@property(nonatomic,strong)UIButton *ButDue;//多少天的到期
@property(nonatomic,strong)UIButton *ButDay;//租几天
@property(nonatomic,strong)UIButton *ButIcon;//多少天的到期

@property(nonatomic,strong)UIView *backView4;//价格信息
@property(nonatomic,strong)UIView *backView5;//价格合计
@property(nonatomic,strong)BaseLabel *labelTotal;//合计
@property(nonatomic,strong)BaseLabel *labelTotalPrice;//价格合计

@property(nonatomic,strong)UIView *backView7;//是否使用账户余额
@property(nonatomic,strong)BaseLabel *labelMoney;//余额
@property(nonatomic,strong)UIButton *ButMoney;//选择余额
@property(nonatomic,strong)UIImageView *moreImg;//


@property(nonatomic,strong)UIView *backView6;//支付信息
@property(nonatomic,assign)BOOL isWXAppInstalled;
@property(nonatomic,strong)UIButton *btnPay;
@property(nonatomic,strong)UIImageView *imgPayUnselect;
@property(nonatomic,strong)UIButton *btnWeiXin;
@property(nonatomic,strong)UIImageView *imgWeiXinUnselect;
@property(nonatomic,strong)UIButton *btnSurePay;

@property(nonatomic,strong)NSString *orderId;//订单id
@property(nonatomic,strong)NSString *rent_end_time;//到期时间
@property(nonatomic,strong)NSString *rent_day_des;//租赁免费时间
@property(nonatomic,strong)NSString *rent_day;//最少租几天
@property(nonatomic,strong)NSString *more_rent_day;//最多租几天
@property(nonatomic,strong)NSString *business_title;//订单名称
@property(nonatomic,strong)NSString *every_sell_price;//到期时间
@property(nonatomic,strong)NSString *way;//到期时间
@property(nonatomic,strong)NSString *img_thumb;//图片地址
@property(nonatomic,strong)NSString *total_price;//图片地址
@property(nonatomic,strong)NSString *total_title;//图片地址
@property(nonatomic,strong)NSMutableArray *daysArray;//日期数组
@property(nonatomic,strong)NSMutableArray *daysNumberArray;//日期不带天数的数组
@property(nonatomic,strong)NSMutableArray *timesNumberArray;//时间数组
@property(nonatomic,strong)UIView *grayView;//日期弹窗出来后的阴影
@property(nonatomic,strong)UIPickerView *pickView;//日期选择器
@property(nonatomic,strong)UIView *sureBtnView;//确定日期btn后的vie
@property(nonatomic,strong)UIButton *sureBtn;//确定日期
@property(nonatomic,strong)NSString *selectDay;//选好的日期
@property(nonatomic,strong)NSString *selectTime;//选好的送货时间
@property(nonatomic,strong)NSString *pay_total_price;//支付金额
@property(nonatomic,assign)NSInteger selectButtonTag;//选择的支付方式
@property(nonatomic,assign)NSInteger appding;
@property(nonatomic,strong)NSString *isPayment;//是0元支付的还是需要支付宝和微信支付的
@property(nonatomic,strong)UIImageView *imageViewWrong;//网络错误的情况下
@property(nonatomic,strong)UIImageView *imageViewNoToy;//没有玩具的情况下
@property(nonatomic,strong)NSString *user_name;//用户名
@property(nonatomic,strong)NSString *mobile;//手机号
@property(nonatomic,strong)NSString *address;//地址
@property(nonatomic,strong)NSString *isBalance;//是否使用余额
@property(nonatomic,strong)NSString *balance_info;//余额信息

@property(nonatomic,strong)UIView *backView8;//收货时间的view
@property(nonatomic,strong)UIImageView *timeImg;//收货时间的图片
@property(nonatomic,strong)BaseLabel *timeLabelAlert;//时间的说明
@property(nonatomic,strong)BaseLabel *timeLabel;//收货时间
@property(nonatomic,strong)UIButton *sureTimeBtn;//确定收货的时间
@property(nonatomic,strong)UIButton *selectBut;//确定的时间

@property(nonatomic,assign)NSInteger selectTag;//确定的tag
@property(nonatomic,strong)UILabel *choseDayLabel;

@property(nonatomic,strong)UIView *carAlertView;//确认订单上面的提示页面
@property(nonatomic,strong)UIImageView *alertViewImg;//确认订单上面提示图片
@property(nonatomic,strong)UILabel * alertLabel;//确认订单上面提示的语言

@property(nonatomic,strong)UIView *isUseCarView;//是否开启会员卡
@property(nonatomic,strong)NSString *alertString;//整个订单的提示
@property(nonatomic,strong)NSMutableArray *cardArrayUse;//所有卡的数组
@property(nonatomic,strong)NSString *combined_order_id;//批次单号
@property(nonatomic,strong)NSMutableArray *cardSelectState;//卡的筛选状态
//是否带电池
@property(nonatomic,strong)UIView *backView9;//是否带电池
@property(nonatomic,strong)NSString *isBatteryView;
@property(nonatomic,strong)NSMutableArray *batterOrderIdArray;//所有玩具是否有电池的数组
@property(nonatomic,strong)NSMutableArray *batterStateArray;//所有玩具的电池状态

//用户信息
@property(nonatomic,strong)NSString *userNameSave;
@property(nonatomic,strong)NSString *phoneNumberSave;
@property(nonatomic,strong)NSString *remarkSave;
@property(nonatomic,strong)NSString *dis_prompt;//收货时间的提示

@property(nonatomic,strong)UIButton *goBuyCardBtn;//去购买年卡
@property(nonatomic,strong)NSString *isCardVip;//是否是会员
@property(nonatomic,strong)NSArray *cardInfo;
//非会员支付的时候的提示语
@property(nonatomic,strong)NSString *messAlert;

@end

@implementation MakeSurePaySureVC

-(void)viewWillAppear:(BOOL)animated{
    _btnSurePay.enabled = YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
     //[self getOrderDetailData];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;



}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    

   }

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.cardArrayUse) {
        self.cardArrayUse = [NSMutableArray array];

    }
    if (!self.cardSelectState) {
        self.cardSelectState = [NSMutableArray array];
    }
    if (!self.batterOrderIdArray) {
        self.batterOrderIdArray = [NSMutableArray array];
    }
    if (!self.batterStateArray) {
        self.batterStateArray =[NSMutableArray array];
    }
    [self setLeftButton];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"确认订单";
    [self allViewDidLoad];
      // Do any additional setup after loading the view.
}

-(void)allViewDidLoad{
    //此为微信支付的时调出页面的次数
    _appding=0;
    _daysArray = [NSMutableArray array];
    _daysNumberArray = [NSMutableArray array];
    _timesNumberArray = [NSMutableArray array];
    //是否安装微信
    _isWXAppInstalled = [ShareSDK isClientInstalled:SSDKPlatformTypeWechat];
    CGFloat height;
    if (self.businessId) {
        height = 64;
    }else{
        height = 64;
    }
    _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, height, SCREENWIDTH,SCREEN_HEIGHT-height)];
    _bottomScrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREEN_HEIGHT*2);
    _bottomScrollView.alwaysBounceVertical = YES;
    _bottomScrollView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.view addSubview:_bottomScrollView];
    _bottomScrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [_bottomScrollView addGestureRecognizer:singleTap];
    [self setSubViews];
    
    self.pickView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-150, SCREENWIDTH, 150)];
    self.pickView.showsSelectionIndicator = YES;
    self.pickView.userInteractionEnabled = YES;
    self.pickView.backgroundColor = [UIColor whiteColor];
    
    self.sureBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-180, SCREENWIDTH, 50)];
    self.sureBtnView.backgroundColor = [UIColor whiteColor];
    
    _choseDayLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 120, 20)];
    _choseDayLabel.textColor = [BBSColor hexStringToColor:@"999999"];
    _choseDayLabel.font = [UIFont systemFontOfSize:15];
    [self.sureBtnView addSubview:_choseDayLabel];
    
    self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureBtn.frame = CGRectMake(SCREENWIDTH-50, 10, 40, 40);
    [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [self.sureBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
    [self.sureBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.sureBtnView addSubview:self.sureBtn];
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [_bottomScrollView endEditing:YES];
    
}

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
-(void)setSubViews{
    //整个页面上的提示语
    self.carAlertView =  [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH, 35)];
    self.carAlertView.backgroundColor = [UIColor whiteColor];
    [_bottomScrollView addSubview:self.carAlertView];
    self.isUseCarView =  [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH, 35)];
    self.isUseCarView.backgroundColor = [UIColor whiteColor];
    [_bottomScrollView addSubview:self.isUseCarView];

   //是不是有电池页面
    self.backView9 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 35)];
    self.backView9.backgroundColor = [UIColor whiteColor];
    [_bottomScrollView addSubview:self.backView9];
    
    self.alertViewImg = [[UIImageView alloc]initWithFrame:CGRectMake(9, 9, 15, 18)];
    self.alertViewImg.image = [UIImage imageNamed:@"toy_alert"];
    [self.carAlertView addSubview:self.alertViewImg];
    
    self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(27, 9, SCREENWIDTH-40, 18)];
    self.alertLabel.textColor = [BBSColor hexStringToColor:@"836843"];
    self.alertLabel.font = [UIFont systemFontOfSize:12];
    self.alertLabel.numberOfLines = 0;
    [self.carAlertView addSubview:self.alertLabel];


    //1、姓名电话地址
    self.backView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 132, SCREEN_WIDTH, 200+40+20)];
    self.backView1.backgroundColor = [UIColor whiteColor];
    [_bottomScrollView addSubview:self.backView1];
    self.labelName = [BaseLabel makeFrame:CGRectMake(10, 10, 80, 20) font:14 textColor:@"666666" textAlignment:NSTextAlignmentLeft text:@"您的姓名："];
    [self.backView1 addSubview:self.labelName];
    self.tfName = [[UITextField alloc]initWithFrame:CGRectMake(83,10, 200, 20)];
    self.tfName.placeholder = @"";
    self.tfName.delegate = self;
    self.tfName.font = [UIFont systemFontOfSize:14];
    self.tfName.borderStyle = UITextBorderStyleNone;
    [self.backView1 addSubview:self.tfName];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 0.5)];
    lineView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.backView1 addSubview:lineView];
    self.labelPhoneNumber = [BaseLabel makeFrame:CGRectMake(10, 10+40, 80, 20) font:14 textColor:@"666666" textAlignment:NSTextAlignmentLeft text:@"手机号码："];
    [self.backView1 addSubview:self.labelPhoneNumber];
    self.tfPhoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(83,10+40,200, 20)];
    self.tfPhoneNumber.placeholder = @"这里必填哦···";
    self.tfPhoneNumber.delegate = self;
    self.tfPhoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.tfPhoneNumber.font = [UIFont systemFontOfSize:14];
    self.tfPhoneNumber.borderStyle = UITextBorderStyleNone;
    [self.backView1 addSubview:self.tfPhoneNumber];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40+40, SCREENWIDTH, 0.5)];
    lineView1.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.backView1 addSubview:lineView1];
    
    self.labelRemark = [BaseLabel makeFrame:CGRectMake(10, 10+40+40+40+20, 80, 20) font:14 textColor:@"666666" textAlignment:NSTextAlignmentLeft text:@"其他备注："];
    [self.backView1 addSubview:self.labelRemark];
    self.tfRemark = [[UITextField alloc]initWithFrame:CGRectMake(83,10+40+40+40+20 ,200, 20)];
    self.tfRemark.placeholder = @"尽量满足哦···";
    self.tfRemark.delegate = self;
    self.tfRemark.font = [UIFont systemFontOfSize:14];
    self.tfRemark.borderStyle = UITextBorderStyleNone;
    [self.backView1 addSubview:self.tfRemark];
    
    self.timeLabelAlert = [BaseLabel makeFrame:CGRectMake(10, 10+40+40+40+40+20,SCREEN_WIDTH-30, 20) font:11 textColor:@"999999" textAlignment:NSTextAlignmentLeft text:@""];
    self.timeLabelAlert.numberOfLines = 0;
    self.timeLabelAlert.textAlignment = NSTextAlignmentCenter;
    self.timeLabelAlert.textColor = [BBSColor hexStringToColor:@"fc6262"];
    
    [self.backView1 addSubview:self.timeLabelAlert];

    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 40+40+40+20, SCREENWIDTH, 0.5)];
    lineView2.backgroundColor =  [BBSColor hexStringToColor:@"f5f5f5"];
    [self.backView1 addSubview:lineView2];
    self.labelAddress = [BaseLabel makeFrame:CGRectMake(10, 10+40+40, 80, 20) font:14 textColor:@"666666" textAlignment:NSTextAlignmentLeft text:@"收货地址："];
    [self.backView1 addSubview:self.labelAddress];
    self.tfAddress=[[UITextView alloc]initWithFrame:CGRectMake(80,40+40+4,SCREENWIDTH-80-10, 50)];
    self.tfAddress.text=@"要写完善哦···";
    self.tfAddress.font=[UIFont systemFontOfSize:14];
    self.tfAddress.textColor=[BBSColor hexStringToColor:@"#cfcfd4"];
    //self.tfAddress.delegate=self;
    [self.backView1 addSubview:self.tfAddress];
    //添加改善地址的手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped)];
    [self.tfAddress addGestureRecognizer:singleTap];
    

    //2、订单的数据
    self.backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 85)];
    self.backView2.backgroundColor = [UIColor whiteColor];
    [_bottomScrollView addSubview:self.backView2];
    
    //租期信息
    self.backView3 = [[UIView alloc]initWithFrame:CGRectMake(0, self.backView1.frame.origin.y+self.backView1.frame.size.height+5, SCREEN_WIDTH, 48)];
    self.backView3.backgroundColor = [UIColor whiteColor];
    [_bottomScrollView addSubview:self.backView3];
    self.labelLease = [BaseLabel makeFrame:CGRectMake(10, 5, 80, 20) font:14 textColor:@"666666" textAlignment:NSTextAlignmentLeft text:@""];
    [self.backView3 addSubview:self.labelLease];
    
    self.labelExplain = [BaseLabel makeFrame:CGRectMake(10, 25, 160, 20) font:11 textColor:@"999999" textAlignment:NSTextAlignmentLeft text:@""];
    [self.backView3 addSubview:self.labelExplain];
    
    self.ButIcon = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ButIcon.frame = CGRectMake(SCREENWIDTH-17, 17, 7, 12);
    [self.ButIcon setImage:[UIImage imageNamed:@"post_group_more_arrow"] forState:UIControlStateNormal];
    [self.backView3 addSubview:self.ButIcon];
    self.ButIcon.tag = 1001;
    [self.ButIcon addTarget:self action:@selector(showList:) forControlEvents:UIControlEventTouchUpInside];

    self.ButDay =[UIButton buttonWithType:UIButtonTypeCustom];
    self.ButDay.frame = CGRectMake(SCREENWIDTH-300, 5,300,40);
    self.ButDay.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.ButDay setTitleColor:[BBSColor hexStringToColor:@"fc6262"] forState:UIControlStateNormal];
    self.ButDay.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.ButDay setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 20)];
    [self.ButDay setTitle:@"" forState:UIControlStateNormal];
    [self.backView3 addSubview:self.ButDay];
    self.ButDay.tag = 1002;
    [self.ButDay addTarget:self action:@selector(showList:) forControlEvents:UIControlEventTouchUpInside];
    
    self.ButDue =[UIButton buttonWithType:UIButtonTypeCustom];
    self.ButDue.frame = CGRectMake(SCREENWIDTH-140, 26, 123, 20);
    [self.ButDue setTitleColor:[BBSColor hexStringToColor:@"999999"] forState:UIControlStateNormal];
    self.ButDue.titleLabel.font = [UIFont systemFontOfSize:11];

    self.ButDue.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.backView3 addSubview:self.ButDue];
    
    //收货时间的view
    self.backView8 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    self.backView8.backgroundColor = [UIColor whiteColor];
    //[_bottomScrollView addSubview:self.backView8];
    //收货时间
    self.timeLabel = [BaseLabel makeFrame:CGRectMake(10, 10, 100, 15) font:14 textColor:@"666666" textAlignment:NSTextAlignmentLeft text:@"收货时间"];
    //[self.backView8 addSubview:self.timeLabel];
    
    self.selectBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectBut.frame = CGRectMake(SCREEN_WIDTH-17,self.timeLabel.frame.origin.y, 7, 12);
    [self.selectBut setImage:[UIImage imageNamed:@"post_group_more_arrow"] forState:UIControlStateNormal];
    self.selectBut.tag = 1003;
    //[self.backView8 addSubview:self.selectBut];
    
    self.sureTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.sureTimeBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    self.sureTimeBtn.frame = CGRectMake(SCREENWIDTH-240, 5, 220, 20);
    [self.sureTimeBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    
    self.sureTimeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
   
    [self.sureTimeBtn setTitleColor:[BBSColor hexStringToColor:@"fc6262"] forState:UIControlStateNormal];
    self.sureTimeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [self.sureTimeBtn setTitle:@"" forState:UIControlStateNormal];
    //[self.backView8 addSubview:self.sureTimeBtn];
    self.sureTimeBtn.tag = 1004;
    [self.sureTimeBtn addTarget:self action:@selector(showList:) forControlEvents:UIControlEventTouchUpInside];
    
       //[self.backView8 addSubview:self.timeLabelAlert];


    //是否使用余额抵扣
    self.backView7 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 47)];
    self.backView7.backgroundColor = [UIColor whiteColor];
   // [_bottomScrollView addSubview:self.backView7];
    
    self.labelMoney = [BaseLabel makeFrame:CGRectMake(10, 10, 270, 20) font:14 textColor:@"666666" textAlignment:NSTextAlignmentLeft text:@""];
    [self.backView7 addSubview:self.labelMoney];
    
    self.ButMoney = [UIButton buttonWithType:UIButtonTypeCustom];
    self.ButMoney.frame = CGRectMake(SCREENWIDTH-40, 10, 40, 37);
    
    [self.backView7 addSubview:self.ButMoney];
    self.moreImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-35, 13, 17.5, 17.5)];
    self.moreImg.image = [UIImage imageNamed:@"btn_unselect_pay"];
    [self.backView7 addSubview:self.moreImg];
    
//    self.backView4 = [[UIView alloc]initWithFrame:CGRectMake(0, 340+65, SCREEN_WIDTH, 47)];
//    self.backView4.backgroundColor = [UIColor redColor];
//    [_bottomScrollView addSubview:self.backView4];
    
    //5、合计
    self.backView5 = [[UIView alloc]initWithFrame:CGRectMake(0, self.backView4.frame.origin.y+self.backView4.frame.size.height, SCREEN_WIDTH, 40)];
    self.backView5.backgroundColor = [UIColor whiteColor];
    //[_bottomScrollView addSubview:self.backView5];
    UIView *lineView9 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
    lineView9.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.backView5 addSubview:lineView9];
    self.labelTotal = [BaseLabel makeFrame:CGRectMake(SCREEN_WIDTH-170, 10, 100, 20) font:14 textColor:@"999999" textAlignment:NSTextAlignmentLeft text:@""];
    [self.backView5 addSubview:self.labelTotal];
    self.labelTotalPrice = [BaseLabel makeFrame:CGRectMake(SCREEN_WIDTH-90, 10, 80, 20) font:14 textColor:@"fc6262" textAlignment:NSTextAlignmentLeft text:@""];
    self.labelTotalPrice.textAlignment = NSTextAlignmentRight;
    [self.backView5 addSubview:self.labelTotalPrice];

    _btnSurePay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnSurePay.layer.masksToBounds = YES;
    _btnSurePay.layer.cornerRadius = 21;
    _btnSurePay.frame = CGRectMake(13,300, SCREENWIDTH-27, 43);
    _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
    _btnSurePay.titleLabel.text = @"确认订单";
    _btnSurePay.enabled = YES;
    [_btnSurePay setTitle:@"确认订单" forState:UIControlStateNormal];
    [_btnSurePay setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
    [_bottomScrollView addSubview:_btnSurePay];
    [self getOrderDetailData];
}
-(void)showList:(UIButton*)button{
    _selectTag = button.tag;
    [_bottomScrollView endEditing:YES];
    _grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _grayView.backgroundColor =  [BBSColor hexStringToColor:@"000000" alpha:0.3];
    [self.view addSubview:_grayView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeList)];
    [_grayView addGestureRecognizer:singleTap];
    if (_selectTag == 1001||_selectTag == 1002) {
        _choseDayLabel.text = @"选择租期";
    }else if (_selectTag == 1003||_selectTag == 1004){
        _choseDayLabel.text = @"选择送货时间";
    }
    self.pickView.dataSource = self;
    self.pickView.delegate = self;
    [self.view addSubview:self.pickView];
    [self.view addSubview:self.sureBtnView];
    [self.sureBtn addTarget:self action:@selector(makeSureDay) forControlEvents:UIControlEventTouchUpInside];
}

-(void)removeList{
    [_grayView removeFromSuperview];
    [self.pickView removeFromSuperview];
    [self.sureBtnView removeFromSuperview];
}
-(void)makeSureDay{
    [self removeList];
}
-(void)fingerTapped{
    EditAddressVC *editAddressVC = [[EditAddressVC alloc]init];
    [self.navigationController pushViewController:editAddressVC animated:YES];
    editAddressVC.getDataBlock = ^(NSDictionary *dataDic){
        [self refreshAddress:dataDic];
    };
}
#pragma mark收货地址回来后的刷新
-(void)refreshAddress:(NSDictionary *)dataDic{
    self.tfAddress.text = dataDic[@"address"];
    self.tfAddress.textColor = [BBSColor hexStringToColor:@"333333"];
    self.dis_prompt = dataDic[@"dis_prompt"];
    if (self.dis_prompt.length > 0) {
        CGFloat heightTime = [self getHeightByWidth:SCREEN_WIDTH-30 title:self.dis_prompt font:[UIFont systemFontOfSize:12]];
        self.timeLabelAlert.frame = CGRectMake(10, 10+40+40+40+30+20, SCREEN_WIDTH-30, heightTime);
        self.timeLabelAlert.text = self.dis_prompt;
        self.backView1.frame = CGRectMake(0, self.carAlertView.frame.origin.y+self.carAlertView.frame.size.height+10, SCREEN_WIDTH, 190+heightTime);
        
        self.backView3.frame  = CGRectMake(0, self.backView1.frame.origin.y+self.backView1.frame.size.height+10, SCREEN_WIDTH, self.backView3.frame.size.height);

        if (self.backView3.frame.size.height > 0) {
            self.isUseCarView.frame = CGRectMake(0,self.backView3.frame.origin.y+self.backView3.frame.size.height+10, SCREENWIDTH,self.isUseCarView.frame.size.height);
        }else{
            self.isUseCarView.frame = CGRectMake(0,self.backView3.frame.origin.y+self.backView3.frame.size.height, SCREENWIDTH,self.isUseCarView.frame.size.height);
        }
        if (self.isUseCarView.frame.size.height >0) {
            self.backView9.frame = CGRectMake(0, self.isUseCarView.frame.origin.y+self.isUseCarView.frame.size.height+10,SCREENWIDTH , self.backView9.frame.size.height);
        }else{
            self.backView9.frame = CGRectMake(0, self.isUseCarView.frame.origin.y+self.isUseCarView.frame.size.height,SCREENWIDTH , self.backView9.frame.size.height);
        }
        if (self.backView9.frame.size.height >0 ) {
        self.backView2.frame = CGRectMake(0,self.backView9.frame.origin.y+self.backView9.frame.size.height+10, SCREEN_WIDTH, self.backView2.frame.size.height);
        }else{
        self.backView2.frame = CGRectMake(0,self.backView9.frame.origin.y+self.backView9.frame.size.height, SCREEN_WIDTH, self.backView2.frame.size.height);
        }
        _btnSurePay.frame = CGRectMake(13,self.backView2.frame.origin.y+self.backView2.frame.size.height+20, SCREENWIDTH-27, 43);
        _btnSurePay.enabled = YES;

        

        
    }
}
#pragma mark UIPickerViewDataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;//列数
}
// pickerView 每列个数
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (_selectTag == 1001 || _selectTag == 1002) {
        return [_daysArray count];

    }else if (_selectTag == 1003 || _selectTag == 1004){
        return [_timesNumberArray count];
    }
    return 0;
}
#pragma Mark -- UIPickerViewDelegate
// 每列宽度
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    if (_selectTag == 1001||_selectTag == 1002) {
        return 100;
    }else if (_selectTag == 1003 || _selectTag == 1004){
        return 250;
    }
    return 100;
}
// 返回选中的行
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (_selectTag == 1001||_selectTag == 1002) {
        _selectDay =  _daysNumberArray[row];
        NSString *select = [NSString stringWithFormat:@"%@天",_selectDay];
        [self.ButDay setTitle:select forState:UIControlStateNormal];

     }else if (_selectTag == 1003 || _selectTag == 1004){
         _selectTime = _timesNumberArray[row];
         [self.sureTimeBtn setTitle:_selectTime forState:UIControlStateNormal];

    }
}
//返回当前行的内容,此处是将数组中数值添加到滚动的那个显示栏上
-(NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (_selectTag == 1001||_selectTag == 1002) {
      return  [_daysArray objectAtIndex:row];
    }else if (_selectTag == 1003 || _selectTag == 1004){
      return  [_timesNumberArray objectAtIndex:row];
    }
    return nil;
}
#pragma mark  订单数据
-(void)getOrderDetailData{
    [_imageViewWrong removeFromSuperview];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:LOGIN_USER_ID forKey:@"login_user_id"];
    if (self.source) {
        [params setObject:self.source forKey:@"source"];
    }
    if (self.orderIdOrderList) {
        [params setObject:self.orderIdOrderList forKey:@"order_id"];
     }
    if (self.businessId) {
        [params setObject:self.businessId forKey:@"business_id"];
       }
    if (self.combined_order_idOrderLst) {
        [params setObject:self.combined_order_idOrderLst forKey:@"combined_order_id"];
    }
    
    [[HTTPClient sharedClient]getNewV1:@"publictoysOrderV2" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            
            NSDictionary *dataDic = result[@"data"];
            NSLog(@"确认订单data = %@",dataDic);
            self.img_thumb = MBNonEmptyString(dataDic[@"img_thumb"]);
            self.business_title = MBNonEmptyString(dataDic[@"business_title"]);
            self.every_sell_price = MBNonEmptyString(dataDic[@"every_sell_price"]);
            self.labelTotal.text = MBNonEmptyString( dataDic[@"total_title"]);
            self.labelTotalPrice.text = MBNonEmptyString(dataDic[@"total_price"]);
            self.orderId = MBNonEmptyString(dataDic[@"order_id"]);
            self.pay_total_price = MBNonEmptyString(dataDic[@"pay_total_price"]);
            self.isPayment = MBNonEmptyString(dataDic[@"is_payment"]);
            self.user_name = MBNonEmptyString(dataDic[@"user_name"]);
            self.mobile = MBNonEmptyString(dataDic[@"mobile"]);
            self.address = MBNonEmptyString(dataDic[@"address"]);
            self.combined_order_id = MBNonEmptyString(dataDic[@"combined_order_id"]);
            //1、订单是否有提示
            self.alertString = MBNonEmptyString(dataDic[@"prompt_title"]);
            //收货时间的提示
            self.dis_prompt = MBNonEmptyString(dataDic[@"dis_prompt"]);
            //非会员用户的提示
            self.messAlert = MBNonEmptyString(dataDic[@"no_card_title"]);
            
            [self setAlertViewframe];
            //2、用户信息
            [self setUserViewFrame];
            //3、是否显示租期
            NSDictionary *rentInfoDic = dataDic[@"rent_info"];
            [self setRentDayIsHidden:rentInfoDic];
            //4、收货时间的选择
            [self getTimeChooseDeliveryTitle:dataDic[@"delivery_title"] delivery_des:dataDic[@"delivery_des"] defalut_delivery_time:dataDic[@"defalut_delivery_time"] deliverArray:dataDic[@"delivery_info"]];
                //5、是否启用会员卡
            self.cardInfo = dataDic[@"card_info"];
            [self getCardInfo:self.cardInfo];
            //7、是否展示电池，电池使用情况
            self.isBatteryView = dataDic[@"battery_state"];
            NSArray *battery_infoArray = dataDic[@"battery_info"];
            [self getBatteryInfo:battery_infoArray];

                //6、商品的信息
            NSArray *toyMesArray = dataDic[@"toys_info"];
            [self getToyMessTitle:dataDic[@"toys_title"] total_price:dataDic[@"total_price"] toyMesArray:toyMesArray];
            //是否使用
            self.isBalance = dataDic[@"is_balance"];
            self.balance_info = dataDic[@"balance_info"];
            _btnSurePay.frame = CGRectMake(13,self.backView2.frame.origin.y+self.backView2.frame.size.height+20, SCREENWIDTH-27, 43);
            [_btnSurePay addTarget:self action:@selector(paySure) forControlEvents:UIControlEventTouchUpInside];
            _bottomScrollView.contentSize = CGSizeMake(SCREENWIDTH, _btnSurePay.frame.origin.y+_btnSurePay.frame.size.height+20);

        }else{
            [self showWrongNet:@"1"];
            if (result == nil) {
                [BBSAlert showAlertWithContent:@"未能成功获取订单" andDelegate:self];
            }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
            }
        }
    } failed:^(NSError *error) {
        [self showWrongNet:@"2"];
    }];
}
#pragma mark 是否启用会员卡
-(void)startUsingCard:(UIButton*)sender{
    NSInteger buttonTag = sender.tag-400;
    NSString *cardId = self.cardArrayUse[buttonTag];
    NSString *checkState = self.cardSelectState[buttonTag];
    if ([checkState isEqualToString:@"1"]) {
        checkState = @"0";
    }else{
        checkState = @"1";
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.combined_order_id,@"combined_order_id",cardId,@"card_id",checkState,@"selected_state",nil];
   
    [[HTTPClient sharedClient]postNewV1:@"editCardOrder" params:params success:^(NSDictionary *result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *dataDic = result[@"data"];
            
            //租期最近
            NSDictionary *rentInfoDic = dataDic[@"rent_info"];
            [self setRentDayIsHidden:rentInfoDic];


            //会员卡启用
            self.cardInfo = dataDic[@"card_info"];
            [self getCardInfo:self.cardInfo];
            self.combined_order_id = dataDic[@"combined_order_id"];
            if (self.isUseCarView.frame.size.height>0) {
                self.backView9.frame = CGRectMake(0, self.isUseCarView.frame.origin.y+self.isUseCarView.frame.size.height+10,SCREENWIDTH , self.backView9.frame.size.height);

            }else{
                self.backView9.frame = CGRectMake(0, self.isUseCarView.frame.origin.y+self.isUseCarView.frame.size.height,SCREENWIDTH , self.backView9.frame.size.height);
            }
            if (self.backView9.frame.size.height >0 ) {
                self.backView2.frame = CGRectMake(0,self.backView9.frame.origin.y+self.backView9.frame.size.height+10, SCREEN_WIDTH, self.backView2.frame.size.height);
            }else{
                self.backView2.frame = CGRectMake(0,self.backView9.frame.origin.y+self.backView9.frame.size.height, SCREEN_WIDTH, self.backView2.frame.size.height);
            }

            //商品的信息
            NSArray *toyMesArray = dataDic[@"toys_info"];
            [self getToyMessTitle:dataDic[@"toys_title"] total_price:dataDic[@"total_price"] toyMesArray:toyMesArray];
            _btnSurePay.frame = CGRectMake(13,self.backView2.frame.origin.y+self.backView2.frame.size.height+20, SCREENWIDTH-27, 43);
            _bottomScrollView.contentSize = CGSizeMake(SCREENWIDTH, _btnSurePay.frame.origin.y+_btnSurePay.frame.size.height+20);
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
        }
    } failed:^(NSError *error) {
         [BBSAlert showAlertWithContent:@"您似乎与网络断开,检查一下吧！" andDelegate:self];
    }];
}
#pragma mark 加载失败的页面
-(void)showWrongNet:(NSString*)type{
    _imageViewWrong = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    if ([type isEqualToString:@"1"]) {
        _imageViewWrong.image =[UIImage imageNamed :@"toy_lease_pay_cancel_img"];

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
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getOrderDetailData)];
    [_imageViewWrong addGestureRecognizer:singleTap];
}
#pragma mark 是否显示上面的提示，提示页面的frame
-(void)setAlertViewframe{
    if (self.alertString.length <=0) {
        self.carAlertView.frame = CGRectMake(0, 0, SCREENWIDTH, 0);
    }else{
        CGFloat cardHeight = [self getHeightByWidth:SCREENWIDTH-40 title:self.alertString font:[UIFont systemFontOfSize:12]];
        if (cardHeight <= 12) {
            cardHeight = 17;
        }else{
            cardHeight = cardHeight;
        }
        self.alertLabel.frame = CGRectMake(27,9, SCREENWIDTH-40, cardHeight);
        self.alertLabel.text = self.alertString;
        self.carAlertView.frame = CGRectMake(0, 0, SCREENWIDTH, cardHeight+13);
        }
}
#pragma mark 去买年卡
-(void)gotoBuyCard{
    ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
    toyDetailVC.business_id = @"1629";
    [self.navigationController pushViewController:toyDetailVC animated:YES];
    
}

#pragma mark 用户信息的展示
-(void)setUserViewFrame{
    if (self.dis_prompt.length > 0) {
        CGFloat heightTime = [self getHeightByWidth:SCREEN_WIDTH-30 title:self.dis_prompt font:[UIFont systemFontOfSize:12]];
        self.timeLabelAlert.frame = CGRectMake(10, 10+40+40+40+30+20, SCREEN_WIDTH-30, heightTime);
        self.timeLabelAlert.text = self.dis_prompt;
        self.backView1.frame = CGRectMake(0, self.carAlertView.frame.origin.y+self.carAlertView.frame.size.height+10, SCREEN_WIDTH, 190+heightTime);

    }else{
        self.backView1.frame = CGRectMake(0, self.carAlertView.frame.origin.y+self.carAlertView.frame.size.height+10, SCREEN_WIDTH, 180);
    }
    if (self.user_name.length > 0) {
        self.tfName.text = self.user_name;
    }
    if (self.mobile.length > 0) {
        self.tfPhoneNumber.text = self.mobile;
    }
    if (self.address.length > 0) {
        self.tfAddress.text = self.address;
        self.tfAddress.textColor = [BBSColor hexStringToColor:@"333333"];
    }
}
#pragma mark 用户显示租期与否
-(void)setRentDayIsHidden:(NSDictionary*)rentDic{
    NSDictionary *rentInfoDic = rentDic;
    NSString *isRent = rentInfoDic[@"is_rent"];
    
    if ([isRent isEqualToString:@"1"]) {
        //显示
        self.backView3.frame  = CGRectMake(0, self.backView1.frame.origin.y+self.backView1.frame.size.height+10, SCREEN_WIDTH, 48+20);
        for (UIView *view in self.backView3.subviews) {
            view.hidden = NO;
        }

        self.labelLease.text = @"选择租期";
        self.rent_day_des = MBNonEmptyString(rentInfoDic[@"rent_day_des"]);
        self.labelExplain.text = self.rent_day_des;
        if (_selectDay.length <=0) {
            _selectDay = rentInfoDic[@"rent_day"];
        }
        
        self.rent_day = [NSString stringWithFormat:@"%@天",_selectDay];
        [self.ButDay setTitle:self.rent_day forState:UIControlStateNormal];
        self.rent_end_time = MBNonEmptyString(rentInfoDic[@"rent_end_time"]);
        [self.ButDue setTitle:self.rent_end_time forState:UIControlStateNormal];
        self.more_rent_day = MBNonEmptyString(rentInfoDic[@"more_rent_day"]);
        int rentDay = [self.rent_day intValue];
        int moreDay = [self.more_rent_day intValue];
        [_daysArray removeAllObjects];
        [_daysNumberArray removeAllObjects];
        for (int i = rentDay; i<moreDay+1; i++) {
            NSString *day = [NSString stringWithFormat:@"%d天",i];
            [_daysArray addObject:day];
            NSString *dayNumber = [NSString stringWithFormat:@"%d",i];
            [_daysNumberArray addObject:dayNumber];
        }
    }else{
        
        //不显示
        self.backView3.frame  = CGRectMake(0, self.backView1.frame.origin.y+self.backView1.frame.size.height+10, SCREEN_WIDTH, 0);
        for (UIView *view in self.backView3.subviews) {
            view.hidden = YES;
        }
        
    }
  
}
#pragma mark 收货时间的选择
/**
 *  收货时间的选择
 *
 *  @param deliveryTitle         收货时间题目
 *  @param delivery_des          收货时间下面的提示
 *  @param defalut_delivery_time 当前默认的收货时间
 *  @param deliverArray          返回的收货时间数组
 */
-(void)getTimeChooseDeliveryTitle:(NSString*)deliveryTitle delivery_des:(NSString*)delivery_des defalut_delivery_time:(NSString*)defalut_delivery_time deliverArray:(NSArray*)deliverArray{
    _selectTime = defalut_delivery_time;
    self.timeLabel.text = deliveryTitle;
    self.sureTimeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.sureTimeBtn setTitle:defalut_delivery_time forState:UIControlStateNormal];
    //self.backView8.frame = CGRectMake(0, self.backView3.frame.origin.y+self.backView3.frame.size.height+10, SCREEN_WIDTH,0);
    [_timesNumberArray removeAllObjects];
    for (NSDictionary *deliverDic in deliverArray) {
        NSString *deliveryTime = deliverDic[@"delivery_time"];
        [_timesNumberArray addObject:deliveryTime];
    }
    
}
#pragma mark 是否开启会员卡
-(void)getCardInfo:(NSArray*)cardInfo{
    float heightCard = 0;
    if (cardInfo.count) {
        for (UIView *view in self.isUseCarView.subviews) {
            [view removeFromSuperview];
        }
        if (self.backView3.frame.size.height > 0) {
            self.isUseCarView.frame = CGRectMake(0,self.backView3.frame.origin.y+self.backView3.frame.size.height+10, SCREENWIDTH, 35*cardInfo.count);
        }else{
            self.isUseCarView.frame = CGRectMake(0,self.backView3.frame.origin.y+self.backView3.frame.size.height, SCREENWIDTH, 35*cardInfo.count);
        }
    
        int i = 0;
        [self.cardArrayUse removeAllObjects];
        [self.cardSelectState removeAllObjects];
        for (NSDictionary *cardInfoDic in cardInfo) {
            NSString *cardId = cardInfoDic[@"card_id"];
            [self.cardArrayUse addObject:cardId];
            NSString *card_title = cardInfoDic[@"card_title"];
            NSString *card_title_new = cardInfoDic[@"card_title_new"];
            NSString *isChoose = cardInfoDic[@"is_choose"];
            NSString *selected_state = cardInfoDic[@"selected_state"];
            [self.cardSelectState addObject:selected_state];
            UIButton *alertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            alertBtn.frame = CGRectMake(0, heightCard, SCREEN_WIDTH, 35);
            alertBtn.tag = i+400;
            [alertBtn addTarget:self action:@selector(startUsingCard:) forControlEvents:UIControlEventTouchUpInside];
            i++;
            [self.isUseCarView addSubview:alertBtn];
            
            UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(38, 9, SCREENWIDTH-40, 18)];
            alertLabel.font = [UIFont systemFontOfSize:12];
            alertLabel.numberOfLines = 0;
            alertLabel.text = card_title_new;
            [alertBtn addSubview:alertLabel];
            UIImageView *alertViewImg = [[UIImageView alloc]initWithFrame:CGRectMake(9, 9, 19,19)];
            [alertBtn addSubview:alertViewImg];
            if ([selected_state isEqualToString:@"0"]) {
                //显示未选中状态
                alertViewImg.image = [UIImage imageNamed:@"toy_car_buy_unselect"];
                alertLabel.textColor = [BBSColor hexStringToColor:@"6e6e6e"];
            }else{
                alertViewImg.image = [UIImage imageNamed:@"toy_car_buy_select"];
                alertLabel.textColor = [BBSColor hexStringToColor:@"fe4d3d"];
            }
            heightCard += 35;
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 34, SCREEN_WIDTH, 1)];
            lineView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
            [alertBtn addSubview:lineView];
        }
    }else{
        if (self.backView3.frame.size.height > 0) {
            self.isUseCarView.frame = CGRectMake(0,self.backView3.frame.origin.y+self.backView3.frame.size.height+10, SCREENWIDTH, 0);
        }else{
            self.isUseCarView.frame = CGRectMake(0,self.backView3.frame.origin.y+self.backView3.frame.size.height, SCREENWIDTH, 0);
        }
    }
}
#pragma mark 玩具是否用电池
-(void)getBatteryInfo:(NSArray *)batteryArray{
    float height = 0;
    if ([self.isBatteryView isEqualToString:@"1"]) {
        for (UIView *view in self.backView9.subviews) {
            [view removeFromSuperview];
        }
      
        int i = 0;
        [self.batterOrderIdArray removeAllObjects];
        [self.batterStateArray removeAllObjects];
        float heightOne = 0;
        for (NSDictionary *batteryDic in batteryArray) {
            NSString *order_id = batteryDic[@"order_id"];
            [self.batterOrderIdArray addObject:order_id];
            NSString *is_battery = batteryDic[@"is_battery"];
            [self.batterStateArray addObject:is_battery];
            NSString *battery_title = batteryDic[@"battery_title"];
            //布局
            UIButton *alertBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            alertBtn.frame = CGRectMake(0, height, SCREEN_WIDTH, 35);
            alertBtn.tag = i+500;
            [alertBtn addTarget:self action:@selector(startUseBattery:) forControlEvents:UIControlEventTouchUpInside];
            i++;
            [self.backView9 addSubview:alertBtn];

            heightOne = [self getHeightByWidth:SCREENWIDTH-40 title:battery_title font:[UIFont systemFontOfSize:12]]+15;
            
            UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(38, 3, SCREENWIDTH-40, heightOne)];
            alertLabel.font = [UIFont systemFontOfSize:12];
            alertLabel.numberOfLines = 0;
            alertLabel.text = battery_title;
            [alertBtn addSubview:alertLabel];
            alertBtn.frame = CGRectMake(0, height, SCREEN_WIDTH, heightOne+5);

            UIImageView *alertViewImg = [[UIImageView alloc]initWithFrame:CGRectMake(9,(heightOne+5-19)/2, 19,19)];
            [alertBtn addSubview:alertViewImg];
            alertLabel.frame = CGRectMake(38, 5, SCREENWIDTH-40, heightOne);
            if ([is_battery isEqualToString:@"0"]) {
                //显示未选中状态
                alertViewImg.image = [UIImage imageNamed:@"toy_car_buy_unselect"];
                alertLabel.textColor = [BBSColor hexStringToColor:@"6e6e6e"];
            }else{
                alertViewImg.image = [UIImage imageNamed:@"toy_car_buy_select"];
                alertLabel.textColor = [BBSColor hexStringToColor:@"fe4d3d"];
            }
            UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, heightOne+4, SCREEN_WIDTH, 1)];
            lineView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
            [alertBtn addSubview:lineView];
            height += heightOne;
        }
        if (self.isUseCarView.frame.size.height >0) {
            self.backView9.frame = CGRectMake(0, self.isUseCarView.frame.origin.y+self.isUseCarView.frame.size.height+10,SCREENWIDTH , height);
        }else{
            self.backView9.frame = CGRectMake(0, self.isUseCarView.frame.origin.y+self.isUseCarView.frame.size.height,SCREENWIDTH , height);
        }

    }else{
              if (self.isUseCarView.frame.size.height >0) {
            self.backView9.frame = CGRectMake(0, self.isUseCarView.frame.origin.y+self.isUseCarView.frame.size.height+10,SCREENWIDTH , 0);
        }else{
            self.backView9.frame = CGRectMake(0, self.isUseCarView.frame.origin.y+self.isUseCarView.frame.size.height,SCREENWIDTH , 0);
        }

    }
}
#pragma mark 玩具电池是否需要带
-(void)startUseBattery:(UIButton *)sender{
    NSInteger buttonTag = sender.tag-500;
    NSString *order_id = self.batterOrderIdArray[buttonTag];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",order_id,@"order_id",nil];
    [[HTTPClient sharedClient]postNewV1:@"editOrderBattery" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *dataArray = result[@"data"];
            NSString *isbattery = dataArray[@"is_battery"];
            for (id subview in sender.subviews) {
                if ([subview isKindOfClass:[UIImageView class]]) {
                    UIImageView *img = subview;
                    if ([isbattery isEqualToString:@"1"]) {
                        img.image = [UIImage imageNamed:@"toy_car_buy_select"];
                    }else{
                        img.image = [UIImage imageNamed:@"toy_car_buy_unselect"];
                    }
                }
                if ([subview isKindOfClass:[UILabel class]]) {
                    UILabel *label = subview;
                    if ([isbattery isEqualToString:@"1"]) {
                        label.textColor = [BBSColor hexStringToColor:@"fe4d3d"];
                    }else{
                        label.textColor = [BBSColor hexStringToColor:@"6e6e6e"];

                    }

                }
            }
           // [self getBatteryInfo:dataArray];
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您似乎与网络断开,检查一下吧！" andDelegate:self];
    }];

}
#pragma mark 玩具的每条信息
/**
 *   玩具的每条信息
 *
 *  @param toys_title  玩具总价标题
 *  @param total_price 玩具金额合计
 *  @param toyMesArray 每条玩具的基本信息
 */
-(void)getToyMessTitle:(NSString*)toys_title total_price:(NSString*)total_price toyMesArray:(NSArray*)toyMesArray{
    for (UIView *view in self.backView2.subviews) {
        [view removeFromSuperview];
    }
    UIView *toysTitleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    toysTitleView.backgroundColor = [UIColor whiteColor];
    [self.backView2 addSubview:toysTitleView];
    UILabel *toysTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,10,SCREEN_WIDTH-50, 20)];
    toysTitleLabel.font = [UIFont systemFontOfSize:14];
    toysTitleLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    toysTitleLabel.text = toys_title;
    [toysTitleView addSubview:toysTitleLabel];
    
    UILabel *toysPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-150,10,140, 20)];
    toysPriceLabel.textAlignment = NSTextAlignmentRight;
    toysPriceLabel.font = [UIFont systemFontOfSize:14];
    toysPriceLabel.textColor = [BBSColor hexStringToColor:@"fd6363"];
    toysPriceLabel.text = total_price;
    [toysTitleView addSubview:toysPriceLabel];
    
    float heightToyMess = 40;
    for (NSDictionary *toyMessDic in toyMesArray) {
        UIView *toyMessView = [[UIView alloc]initWithFrame:CGRectMake(0,heightToyMess, SCREENWIDTH, 73)];
        toyMessView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];

        [self.backView2 addSubview:toyMessView];
        //玩具的图片
        UIImageView *photoView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 60, 60)];
        photoView.image = [UIImage imageNamed:@"img_message_photo"];
        [photoView setContentMode:UIViewContentModeScaleAspectFill];
        photoView.clipsToBounds = YES;
        [toyMessView addSubview:photoView];
        NSString *imgThumb = toyMessDic[@"img_thumb"];
        [photoView sd_setImageWithURL:[NSURL URLWithString:imgThumb] placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
        NSString *sizeimg = toyMessDic[@"new_size_img_thumb"];
        if (sizeimg.length > 0) {
            UIImageView *smallToyMark = [[UIImageView alloc]initWithFrame:CGRectMake(60-15, 60-14,15, 14)];
            [photoView addSubview:smallToyMark];
            [smallToyMark sd_setImageWithURL:[NSURL URLWithString:sizeimg]];

        }
        //玩具的名字
        WMYLabel *toyNameLabel = [[WMYLabel alloc]initWithFrame:CGRectMake(photoView.frame.origin.x+photoView.frame.size.width+10, photoView.frame.origin.y, SCREENWIDTH-85, 33)];
        toyNameLabel.font = [UIFont systemFontOfSize:13];
        toyNameLabel.numberOfLines = 2;
        toyNameLabel.textColor = [BBSColor hexStringToColor:@"333333"];
        [toyMessView addSubview:toyNameLabel];
        [toyNameLabel setVerticalAlignment:VerticalAlignmentTop];
        toyNameLabel.text = toyMessDic[@"business_title"];
        //玩具的原价
        UILabel *markPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(toyNameLabel.frame.origin.x,toyNameLabel.frame.origin.y+toyNameLabel.frame.size.height, 100, 15)];
        markPriceLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        markPriceLabel.font = [UIFont systemFontOfSize:12];
        [toyMessView addSubview:markPriceLabel];
        //markPriceLabel.backgroundColor = [UIColor redColor];
        markPriceLabel.text = toyMessDic[@"market_price"];
        //玩具的价位
        UILabel *priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(toyNameLabel.frame.origin.x,53, 100, 17)];
        priceLabel.textColor = [BBSColor hexStringToColor:@"fe6565"];
        priceLabel.font = [UIFont systemFontOfSize:14];
        [toyMessView addSubview:priceLabel];
        priceLabel.text = toyMessDic[@"every_sell_price"];
        //会员价位
        UILabel *memberLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-170,53,160, 20)];
        memberLabel.textColor = [BBSColor hexStringToColor:@"fe6565"];
        memberLabel.font = [UIFont systemFontOfSize:13];
        memberLabel.textAlignment = NSTextAlignmentRight;
        [toyMessView addSubview:memberLabel];
        memberLabel.text = toyMessDic[@"order_card_info"];
        heightToyMess += 73;
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 72, SCREEN_WIDTH, 1)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"e8e8e8"];
        [toyMessView addSubview:lineView];
    }
    if (self.backView9.frame.size.height >0 ) {
          self.backView2.frame = CGRectMake(0,self.backView9.frame.origin.y+self.backView9.frame.size.height+10, SCREEN_WIDTH, heightToyMess);
    }else{
        self.backView2.frame = CGRectMake(0,self.backView9.frame.origin.y+self.backView9.frame.size.height, SCREEN_WIDTH, heightToyMess);
    }

}
#pragma mark 确认订单
-(void)paySure{
    
    if (_tfPhoneNumber.text.length <= 0){
        [BBSAlert showAlertWithContent:@"请提交电话号码，很重要哟！" andDelegate:self];
    }else{
        if (self.messAlert.length > 0) {
            [self gotoPayOrder];
            _btnSurePay.enabled = NO;

        }else{
            [self gotoPayOrder];
            _btnSurePay.enabled = NO;

     }
    }
}
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 801) {
        if (buttonIndex == 0) {
            [self gotoPayOrder];
        }else{
            [self gotoBuyCard];
        }
    }
    
        
}

-(void)gotoPayOrder{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.combined_order_id,@"combined_order_id",_selectTime,@"delivery_time", nil];
    if (_selectDay.length > 0) {
        [params setObject:_selectDay forKey:@"rent_day"];
    }
    if (![_tfAddress.text isEqualToString:@"要写完善哦···"]) {
        [params setObject:_tfAddress.text forKey:@"address"];
    }
    if (_tfPhoneNumber.text.length > 0) {
        [params setObject:_tfPhoneNumber.text forKey:@"mobile"];
    }
    if (_tfName.text.length > 0) {
        [params setObject:_tfName.text forKey:@"user_name"];
    }
    if (![_tfRemark.text isEqualToString:@"尽量满足哦···"]) {
        [params setObject:_tfRemark.text forKey:@"addtext"];
    }
    [[HTTPClient sharedClient]postNewV1:@"editUserOrderInfo" params:params success:^(NSDictionary *result) {
        _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"cccccc"];
        _btnSurePay.enabled = NO;
        if ([[result objectForKey:kBBSSuccess]boolValue]) {
            MakeSureMoneyVC *makeSureVC = [[MakeSureMoneyVC alloc]init];
            makeSureVC.combined_order_id = self.combined_order_id;
            makeSureVC.fromWhere = self.fromWhere;
            [self.navigationController pushViewController:makeSureVC animated:YES];
            _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
            _btnSurePay.enabled = YES;
        }else{
            _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
            _btnSurePay.enabled = YES;
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
        }
    } failed:^(NSError *error) {
        _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fe4d3d"];
        _btnSurePay.enabled = YES;
    }];

}
#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return YES;
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

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
      if (textView == self.tfAddress){
        if ([textView.text isEqualToString:@"要写完善哦···"]) {
            
//            EditAddressVC *editAddressVC = [[EditAddressVC alloc]init];
//            [self.navigationController pushViewController:editAddressVC animated:YES];
            textView.text=@"";
            self.tfAddress.textColor=[BBSColor hexStringToColor:@"333333"];

        }
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    
   if (textView==_tfAddress){
        
        if (textView.text.length==0) {
            textView.text=@"要写完善哦···";
            self.tfAddress.textColor=[BBSColor hexStringToColor:@"cfcfd4"];

        }
        
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
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
