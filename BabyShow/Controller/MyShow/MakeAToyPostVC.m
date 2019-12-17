//
//  MakeAToyPostVC.m
//  BabyShow
//
//  Created by WMY on 16/12/8.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MakeAToyPostVC.h"
#import "NIAttributedLabel.h"
#import "ELCImagePickerController.h"
#import "AlbumListViewController.h"
#import "UIImageView+WebCache.h"
#import "Reachability.h"

@interface MakeAToyPostVC ()<UIActionSheetDelegate,UITextViewDelegate,ELCImagePickerControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)UIView *textBackView;//文字背景
@property(nonatomic,strong)UILabel *titleLabel;//标题
@property(nonatomic,strong)UIView *photoBackView;//图片选择器
//添加图片view
@property(nonatomic,strong)UIView *imgView;
@property(nonatomic,strong)UIButton *addImgBtn;
@property(nonatomic,strong)UIButton *imgTextAddBtn;

@property(nonatomic,strong)UIView *backView2;//商品卖还是租，是否受豌豆苗支持
@property(nonatomic,strong)UILabel *classLabel;
@property(nonatomic,strong)UIView *chooseView1;
@property(nonatomic,strong)UIButton *leaseToyBtn;
@property(nonatomic,strong)UIButton *buyToyBtn;

@property(nonatomic,strong)UILabel *supportLabel;
@property(nonatomic,strong)UIView *chooseView2;
@property(nonatomic,strong)UIButton *yesSupportBtn;
@property(nonatomic,strong)UIButton *noSupportBtn;

@property(nonatomic,strong)UIView *backView3;//具体情节
@property(nonatomic,strong)BaseLabel *labelDadyPrice;

@property(nonatomic,strong)BaseLabel *labelDeposit;
@property(nonatomic,strong)BaseLabel *labelYear;
@property(nonatomic,strong)BaseLabel *labelPhoneNumber;
@property(nonatomic,strong)BaseLabel *labelQQ;
@property(nonatomic,strong)BaseLabel *labelAddress;
@property(nonatomic,strong)BaseLabel *LabelmoneyDay;
@property(nonatomic,strong)BaseLabel *labelMoney;
@property(nonatomic,strong)BaseLabel *labelRemark;
@property(nonatomic,strong)UITextField *tfRemark;


@property(nonatomic,strong)UITextField *tfDadyPrice;
@property(nonatomic,strong)UITextField *tfDeposit;
@property(nonatomic,strong)UITextField *tfYear;
@property(nonatomic,strong)UITextField *tfPhoneNumber;
@property(nonatomic,strong)UITextField *tfQQ;
@property(nonatomic,strong)UITextView *tfAddress;

@property(nonatomic,strong)UIView *backView4;//对通过不通过的说明
@property(nonatomic,strong)UIImageView *iconImg;//豌豆苗支持图标
@property(nonatomic,strong)UILabel *issupportLabel;//蓝色支持文字
@property(nonatomic,strong)UILabel *supportContentLabel;//支持内容
@property(nonatomic,assign)BOOL way;//租卖方式(0售卖【默认】、 1 租赁)
@property(nonatomic,assign)BOOL is_support;//豌豆苗支持状态(0不支持【默认】、1 支持)
@property(nonatomic,assign)CGFloat keyHeight;//键盘高度

@end

@implementation MakeAToyPostVC{
    UIScrollView *_scrollView;
    UITextView *_describeTextView;
    UIButton *_sendBtn;
    UITextView *_titleTextView;
    UIView *_seperateView;
    float  imageWidth;

}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pickedImagesArray=[NSMutableArray array];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.tabBarController.tabBar.hidden = YES;
    
    //注册通知，键盘通知的方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisapper:) name:UIKeyboardWillHideNotification object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,self.view.bounds.size.height)];
    _scrollView.contentSize=CGSizeMake(SCREENWIDTH, 1200);
    _scrollView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.view addSubview:_scrollView];
    _scrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [_scrollView addGestureRecognizer:singleTap];
    [self setLeftBtn];
    [self setRightBtn];
    [self setSubviews];
    

    // Do any additional setup after loading the view.
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [_scrollView endEditing:YES];
    
}
#pragma mark 获取提交订单的相关信息接口
-(void)getdata{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"gettoysService" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *dataDic = result[@"data"];
            self.issupportLabel.text = MBNonEmptyString(dataDic[@"support_name"]);
            NSString *content = MBNonEmptyString(dataDic[@"support_des"]);
            CGFloat heightSupport = [self getHeightByWidth:SCREENWIDTH-20 title:content font:[UIFont systemFontOfSize:13]];
            self.supportContentLabel.text = content;
            self.supportContentLabel.frame = CGRectMake(13, self.issupportLabel.frame.origin.y+self.issupportLabel.frame.size.height+10, SCREENWIDTH-26, heightSupport);
            self.supportLabel.text = MBNonEmptyString(dataDic[@"service_title"]);
            self.backView4.frame = CGRectMake(0, _photoBackView.frame.origin.y+_photoBackView.frame.size.height, SCREENWIDTH, self.supportContentLabel.frame.origin.y+heightSupport+10);
            self.backView2.frame = CGRectMake(0, self.backView4.frame.origin.y+self.backView4.frame.size.height, SCREENWIDTH, 80);
            self.backView3.frame = CGRectMake(0, self.backView2.frame.origin.y+self.backView2.frame.size.height, SCREENWIDTH, 340);
            _scrollView.contentSize = CGSizeMake(SCREENWIDTH, self.backView3.frame.origin.y+self.backView3.frame.size.height+30);
            NSUserDefaults *defaultlat = [NSUserDefaults standardUserDefaults];

            [defaultlat setObject:MBNonEmptyString(dataDic[@"support_name"]) forKey:@"support_name"];
            [defaultlat setObject:MBNonEmptyString(dataDic[@"support_des"]) forKey:@"support_des"];
            [defaultlat setObject:MBNonEmptyString(dataDic[@"service_title"]) forKey:@"service_title"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            

        }else{
             NSUserDefaults *defaultlat = [NSUserDefaults standardUserDefaults];
            NSString *supportName = [defaultlat valueForKey:@"support_name"];
            NSString *supportDes = [defaultlat valueForKey:@"support_des"];
            NSString *title = [defaultlat valueForKey:@"service_title"];
            
            self.issupportLabel.text = supportName;
            NSString *content = supportDes;
            CGFloat heightSupport = [self getHeightByWidth:SCREENWIDTH-20 title:content font:[UIFont systemFontOfSize:13]];
            self.supportContentLabel.text = content;
            self.supportContentLabel.frame = CGRectMake(13, self.issupportLabel.frame.origin.y+self.issupportLabel.frame.size.height+10, SCREENWIDTH-26, heightSupport);
            self.supportLabel.text = title;
            self.backView4.frame = CGRectMake(0, _photoBackView.frame.origin.y+_photoBackView.frame.size.height, SCREENWIDTH, self.supportContentLabel.frame.origin.y+heightSupport+10);
            self.backView2.frame = CGRectMake(0, self.backView4.frame.origin.y+self.backView4.frame.size.height, SCREENWIDTH, 80);
            self.backView3.frame = CGRectMake(0, self.backView2.frame.origin.y+self.backView2.frame.size.height, SCREENWIDTH, 340);
            _scrollView.contentSize = CGSizeMake(SCREENWIDTH, self.backView3.frame.origin.y+self.backView3.frame.size.height+30);
            
            
        }
        
    } failed:^(NSError *error) {
        NSUserDefaults *defaultlat = [NSUserDefaults standardUserDefaults];
        NSString *supportName = [defaultlat valueForKey:@"support_name"];
        NSString *supportDes = [defaultlat valueForKey:@"support_des"];
        NSString *title = [defaultlat valueForKey:@"service_title"];
        
        self.issupportLabel.text = supportName;
        NSString *content = supportDes;
        CGFloat heightSupport = [self getHeightByWidth:SCREENWIDTH-20 title:content font:[UIFont systemFontOfSize:13]];
        self.supportContentLabel.text = content;
        self.supportContentLabel.frame = CGRectMake(13, self.issupportLabel.frame.origin.y+self.issupportLabel.frame.size.height+10, SCREENWIDTH-26, heightSupport);
        self.supportLabel.text = title;
        self.backView4.frame = CGRectMake(0, _photoBackView.frame.origin.y+_photoBackView.frame.size.height, SCREENWIDTH, self.supportContentLabel.frame.origin.y+heightSupport+10);
        self.backView2.frame = CGRectMake(0, self.backView4.frame.origin.y+self.backView4.frame.size.height, SCREENWIDTH, 80);
        self.backView3.frame = CGRectMake(0, self.backView2.frame.origin.y+self.backView2.frame.size.height, SCREENWIDTH, 340);
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH, self.backView3.frame.origin.y+self.backView3.frame.size.height+30);
        
    }];
}
#pragma mark 布局
-(void)setSubviews{
    _textBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    _textBackView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_textBackView];
    
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 11, 50, 30)];
    self.titleLabel.text = @"标题：";
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    [_textBackView addSubview:self.titleLabel];
    _titleTextView=[[UITextView alloc]initWithFrame:CGRectMake(50, 10, SCREENWIDTH-20, 30)];
    _titleTextView.text=@"一句话描述一下宝贝吧";
    _titleTextView.font=[UIFont systemFontOfSize:15];
    _titleTextView.textColor=[BBSColor hexStringToColor:@"#9b9b9b"];
    _titleTextView.delegate=self;
    [_textBackView addSubview:_titleTextView];
    
    _seperateView=[[UIView alloc]initWithFrame:CGRectMake(10, 50, SCREENWIDTH-20, 0.5)];
    _seperateView.backgroundColor=[UIColor lightGrayColor];
    [_textBackView addSubview:_seperateView];
    
    _describeTextView=[[UITextView alloc]initWithFrame:CGRectMake(7, 60, SCREENWIDTH-20, 60)];
    _describeTextView.text=@"补充下宝贝的描述和亮点吧！";
    _describeTextView.textColor = [BBSColor hexStringToColor:@"9b9b9b"];
    _describeTextView.font=[UIFont systemFontOfSize:15];
    _describeTextView.delegate=self;
    [_textBackView addSubview:_describeTextView];
    
    //添加图片和视频的view
    imageWidth = (SCREENWIDTH-60)/5;

     _photoBackView = [[UIView alloc]initWithFrame:CGRectMake(0, _textBackView.frame.size.height, SCREENWIDTH,80)];
    _photoBackView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_photoBackView];
    
    //添加图片
    self.imgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, imageWidth+20)];
    self.imgView.backgroundColor = [UIColor whiteColor];
    [_photoBackView addSubview:self.imgView];
    //添加图片的按钮
    self.addImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addImgBtn.frame = CGRectMake(10, 10, imageWidth, imageWidth);
    [self.addImgBtn setImage:[UIImage imageNamed:@"toy_addphoto"] forState:UIControlStateNormal];
    self.addImgBtn.adjustsImageWhenDisabled = NO;
    [self.addImgBtn addTarget:self action:@selector(ChoosePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.imgView addSubview:self.addImgBtn];
    self.imgTextAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imgTextAddBtn.frame = CGRectMake(self.addImgBtn.frame.origin.x+imageWidth+10, 13, imageWidth+5, imageWidth);
    [self.imgTextAddBtn setTitle:@"添加图片" forState:UIControlStateNormal];
    self.imgTextAddBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.imgTextAddBtn setTitleColor:[BBSColor hexStringToColor:@"999999"] forState:UIControlStateNormal];
    [self.imgTextAddBtn addTarget:self action:@selector(ChoosePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.imgView addSubview:self.imgTextAddBtn];
    
    self.backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, self.backView4.frame.origin.y+self.backView4.frame.size.height, SCREENWIDTH, 80)];
    
    self.backView2.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [_scrollView addSubview:self.backView2];
    
    self.classLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,170, 20)];
    self.classLabel.textColor = [BBSColor hexStringToColor:@"999999"];
    self.classLabel.font = [UIFont systemFontOfSize:12];
    self.classLabel.text = @"详情";
    [self.backView2 addSubview:self.classLabel];
    self.chooseView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 40)];
    self.chooseView1.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
    [self.backView2 addSubview:self.chooseView1];
    
    self.leaseToyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.leaseToyBtn.frame = CGRectMake(10, 10, 80, 20);
    [self.chooseView1 addSubview:self.leaseToyBtn];
    
    [self.leaseToyBtn setTitle:@"租出去" forState:UIControlStateNormal];
    [self.leaseToyBtn setTitleColor:[BBSColor hexStringToColor:@"333333"] forState:UIControlStateNormal];
    self.leaseToyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.leaseToyBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.leaseToyBtn setImage:[UIImage imageNamed:@"btn_select_pay"] forState:UIControlStateNormal];
    self.leaseToyBtn.titleEdgeInsets = UIEdgeInsetsMake(5, -50, 5, 0);
    self.leaseToyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    self.leaseToyBtn.tag = 801;
    [self.leaseToyBtn addTarget:self action:@selector(chooseLeaseOrBuy:) forControlEvents:UIControlEventTouchUpInside];
    _way = YES;
    self.buyToyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.buyToyBtn.frame = CGRectMake(SCREENWIDTH/2, 10, 80, 20);
    [self.chooseView1 addSubview:self.buyToyBtn];
    
    [self.buyToyBtn setTitle:@"直接卖" forState:UIControlStateNormal];
    [self.buyToyBtn setTitleColor:[BBSColor hexStringToColor:@"333333"] forState:UIControlStateNormal];
    self.buyToyBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.buyToyBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.buyToyBtn setImage:[UIImage imageNamed:@"btn_unselect_pay"] forState:UIControlStateNormal];
    self.buyToyBtn.titleEdgeInsets = UIEdgeInsetsMake(5, -50, 5, 0);
    self.buyToyBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    self.buyToyBtn.tag = 802;
    [self.buyToyBtn addTarget:self action:@selector(chooseLeaseOrBuy:) forControlEvents:UIControlEventTouchUpInside];

    
    //通过和不通过的说明提示
    self.backView4 = [[UIView alloc]initWithFrame:CGRectMake(0, _photoBackView.frame.origin.y+_photoBackView.frame.size.height, SCREENWIDTH, 200+80)];
    [_scrollView addSubview:self.backView4];

    //是否支持
    UIView *grayView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    grayView1.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.backView4 addSubview:grayView1];
    self.supportLabel= [[UILabel alloc]initWithFrame:CGRectMake(10, 10,170, 20)];
    self.supportLabel.textColor = [BBSColor hexStringToColor:@"999999"];
    self.supportLabel.font = [UIFont systemFontOfSize:12];
    self.supportLabel.text = @"支持";
    [grayView1 addSubview:self.supportLabel];
    
    self.chooseView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 40)];
    self.chooseView2.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
    [self.backView4 addSubview:self.chooseView2];
    _is_support = YES;
    
    self.yesSupportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.yesSupportBtn.frame = CGRectMake(10, 10, 80, 20);
    [self.chooseView2 addSubview:self.yesSupportBtn];
    
    [self.yesSupportBtn setTitle:@"要通过" forState:UIControlStateNormal];
    [self.yesSupportBtn setTitleColor:[BBSColor hexStringToColor:@"333333"] forState:UIControlStateNormal];
    self.yesSupportBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.yesSupportBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.yesSupportBtn setImage:[UIImage imageNamed:@"btn_select_pay"] forState:UIControlStateNormal];
    self.yesSupportBtn.titleEdgeInsets = UIEdgeInsetsMake(5, -50, 5, 0);
    self.yesSupportBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    self.yesSupportBtn.tag = 803;
    [self.yesSupportBtn addTarget:self action:@selector(chooseLeaseOrBuy:) forControlEvents:UIControlEventTouchUpInside];
    
    self.noSupportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.noSupportBtn.frame = CGRectMake(SCREENWIDTH/2, 10, 80, 20);
    [self.chooseView2 addSubview:self.noSupportBtn];
    
    [self.noSupportBtn setTitle:@"不通过" forState:UIControlStateNormal];
    [self.noSupportBtn setTitleColor:[BBSColor hexStringToColor:@"333333"] forState:UIControlStateNormal];
    self.noSupportBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    self.noSupportBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.noSupportBtn setImage:[UIImage imageNamed:@"btn_unselect_pay"] forState:UIControlStateNormal];
    self.noSupportBtn.titleEdgeInsets = UIEdgeInsetsMake(5, -50, 5, 0);
    self.noSupportBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 50, 0, 0);
    self.noSupportBtn.tag = 804;
    [self.noSupportBtn addTarget:self action:@selector(chooseLeaseOrBuy:) forControlEvents:UIControlEventTouchUpInside];
    self.iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(13, 80+10, 18, 22)];
    self.iconImg.image = [UIImage imageNamed:@"toy_support"];
    [self.backView4 addSubview:self.iconImg];
    self.backView4.backgroundColor = [UIColor whiteColor];
    
    self.issupportLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImg.frame.origin.x+self.iconImg.frame.size.width+7, 80+12, SCREENWIDTH-self.issupportLabel.frame.origin.x-self.issupportLabel.frame.size.width-20, 20)];
    self.issupportLabel.textColor = [BBSColor hexStringToColor:@"c08423"];
    self.issupportLabel.font = [UIFont systemFontOfSize:12];
    [self.backView4 addSubview:self.issupportLabel];
    
    self.supportContentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.issupportLabel.frame.origin.y+self.issupportLabel.frame.size.height+10, SCREENWIDTH-20, 30)];
    self.supportContentLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    self.supportContentLabel.font = [UIFont  systemFontOfSize:13];
    self.supportContentLabel.numberOfLines = 0;
    [self.backView4 addSubview:self.supportContentLabel];

    
    self.backView3 = [[UIView alloc]initWithFrame:CGRectMake(0, self.backView2.frame.origin.y+self.backView2.frame.size.height, SCREENWIDTH, 300)];
    self.backView3.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:self.backView3];
    
    UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 40)];
    grayView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    //[self.backView3 addSubview:grayView];
    
    UILabel *detailLabel= [[UILabel alloc]initWithFrame:CGRectMake(10, 10,170, 20)];
    detailLabel.textColor = [BBSColor hexStringToColor:@"999999"];
    detailLabel.font = [UIFont systemFontOfSize:12];
    detailLabel.text = @"具体";
   // [grayView addSubview:detailLabel];

    self.labelDadyPrice = [BaseLabel makeFrame:CGRectMake(13, 10, 80, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"日收租金："];
    [self.backView3 addSubview:self.labelDadyPrice];
    self.tfDadyPrice = [[UITextField alloc]initWithFrame:CGRectMake(93,10 , 80, 20)];
    self.tfDadyPrice.placeholder = @"如：3";
    self.tfDadyPrice.keyboardType = UIKeyboardTypeNumberPad;
    self.tfDadyPrice.delegate = self;
    self.tfDadyPrice.font = [UIFont systemFontOfSize:14];
    self.tfDadyPrice.borderStyle = UITextBorderStyleNone;
    [self.backView3 addSubview:self.tfDadyPrice];
    
    self.LabelmoneyDay = [BaseLabel makeFrame:CGRectMake(93+80, 10, 80, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"元/天"];
    [self.backView3 addSubview:self.LabelmoneyDay];
    
    
    self.labelDeposit = [BaseLabel makeFrame:CGRectMake(13, 40+10, 80, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"最高损赔："];
    [self.backView3 addSubview:self.labelDeposit];
    self.tfDeposit = [[UITextField alloc]initWithFrame:CGRectMake(93,40+10 , 80, 20)];
    self.tfDeposit.placeholder = @"如：50";
    self.tfDeposit.keyboardType = UIKeyboardTypeNumberPad;
    self.tfDeposit.delegate = self;
    self.tfDeposit.font = [UIFont systemFontOfSize:14];
    self.tfDeposit.borderStyle = UITextBorderStyleNone;
    [self.backView3 addSubview:self.tfDeposit];
    self.labelMoney = [BaseLabel makeFrame:CGRectMake(93+80, 40+10, 80, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"元"];
    [self.backView3 addSubview:self.labelMoney];

    self.labelYear = [BaseLabel makeFrame:CGRectMake(13, 40+40+10, 80, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"适龄儿童："];
    [self.backView3 addSubview:self.labelYear];
    self.tfYear = [[UITextField alloc]initWithFrame:CGRectMake(93,40+40+10 , 200, 20)];
    self.tfYear.placeholder = @"如：3-5岁";
    self.tfYear.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.tfYear.delegate = self;
    self.tfYear.font = [UIFont systemFontOfSize:14];
    self.tfYear.borderStyle = UITextBorderStyleNone;
    [self.backView3 addSubview:self.tfYear];

    
    self.labelPhoneNumber = [BaseLabel makeFrame:CGRectMake(13, 40+40+40+10, 80, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"联系电话："];
    [self.backView3 addSubview:self.labelPhoneNumber];
    self.tfPhoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(93,40+40+40+10 , 200, 20)];
    self.tfPhoneNumber.placeholder = @"重要信息一定要填写正确呦！";
    self.tfPhoneNumber.delegate = self;
    self.tfPhoneNumber.keyboardType =  UIKeyboardTypePhonePad;
    self.tfPhoneNumber.font = [UIFont systemFontOfSize:14];
    self.tfPhoneNumber.borderStyle = UITextBorderStyleNone;
    [self.backView3 addSubview:self.tfPhoneNumber];
    
    self.labelQQ = [BaseLabel makeFrame:CGRectMake(13, 40+40+40+40+10, 80, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"Q Q号码："];
    [self.backView3 addSubview:self.labelQQ];
    self.tfQQ = [[UITextField alloc]initWithFrame:CGRectMake(93,40+40+40+40+10 , 200, 20)];
    self.tfQQ.placeholder = @"";
    self.tfQQ.keyboardType = UIKeyboardTypeNumberPad;
    self.tfQQ.delegate = self;
    self.tfQQ.font = [UIFont systemFontOfSize:14];
    self.tfQQ.borderStyle = UITextBorderStyleNone;
    [self.backView3 addSubview:self.tfQQ];
    //备注
    self.labelRemark = [BaseLabel makeFrame:CGRectMake(13, 40+40+40+40+40+10, 80, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"其他备注："];
    [self.backView3 addSubview:self.labelRemark];
    
    self.tfRemark = [[UITextField alloc]initWithFrame:CGRectMake(93,40+40+40+40+40+10 , 200, 20)];
    self.tfRemark.placeholder = @"";
    self.tfRemark.delegate = self;
    self.tfRemark.font = [UIFont systemFontOfSize:14];
    self.tfRemark.borderStyle = UITextBorderStyleNone;
    [self.backView3 addSubview:self.tfRemark];
    
    self.labelAddress = [BaseLabel makeFrame:CGRectMake(13, 40+40+40+40+40+40+10, 80, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"取货地址："];
    [self.backView3 addSubview:self.labelAddress];
    self.tfAddress=[[UITextView alloc]initWithFrame:CGRectMake(93, 40+40+40+40+40+40+5, SCREENWIDTH-93-10, 40)];
    self.tfAddress.text=@"地址不会显示在您的发布信息里面";
    self.tfAddress.font=[UIFont systemFontOfSize:14];
    self.tfAddress.textColor=[BBSColor hexStringToColor:@"#9b9b9b"];
    self.tfAddress.delegate=self;
    [self.backView3 addSubview:self.tfAddress];

    
    for (int i = 0; i <5; i++) {
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(10, 40*(i+1)+39.5, SCREENWIDTH-20, 0.5)];
        lineView1.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [self.backView3 addSubview:lineView1];

    }
    
    [self getdata];
}
-(void)setLeftBtn{
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(cancelback) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
-(void)cancelback{
        [self.navigationController popViewControllerAnimated:YES];
}
-(void)setRightBtn{
    CGRect sendBtnFrame=CGRectMake(0, 0, 50, 24);
    _sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame=sendBtnFrame;
    [_sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(sendPostBar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_sendBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}
-(void)sendPostBar{
    [_scrollView endEditing:YES];
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NSParameterAssert([reach isKindOfClass:[Reachability class]]);
    NetworkStatus stats = [reach currentReachabilityStatus];
    if (stats == NotReachable) {
        [BBSAlert showAlertWithContent:@"您似乎与网络断开，检查一下网络再发送吧" andDelegate:self];
    }else{
        if ([_titleTextView.text isEqualToString:@"一句话描述一下宝贝吧"] &&[_describeTextView.text isEqualToString:@"补充下宝贝的描述和亮点吧！"]&&[_tfQQ.text isEqualToString:@""]&&[_tfYear.text isEqualToString:@""]&&[_tfAddress.text isEqualToString:@""]&&[_tfDeposit.text isEqualToString:@""]&&[_tfDadyPrice.text isEqualToString:@""]&&[_tfPhoneNumber.text isEqualToString:@""]&&[_tfRemark.text isEqualToString:@""]) {
            
        }else{
            //网络请求，继续秀一下
            //将图片和url地址分别封装
            NSMutableArray *imgageArray=[[NSMutableArray alloc]init];
            NSMutableArray *imgStrArray=[[NSMutableArray alloc]init];
            for (id obj in self.pickedImagesArray) {
                if ([obj isKindOfClass:[UIImage class]]) {
                    [imgageArray addObject:obj];
                }else if ( [obj isKindOfClass:[NSDictionary class]]){
                    NSDictionary *imgDic=(NSDictionary *)obj;
                    NSString *UrlStr=[imgDic objectForKey:@"img_down"];
                    [imgStrArray addObject:UrlStr];
                }
            }
            NSMutableDictionary *param=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        LOGIN_USER_ID, @"login_user_id",nil];
            [param setObject:[NSString stringWithFormat:@"%d",_way] forKey:@"way"];
            [param setObject:[NSString stringWithFormat:@"%d",_is_support] forKey:@"is_support"];
            if (![_titleTextView.text isEqualToString:@"一句话描述一下宝贝吧"]) {
                [param setObject:_titleTextView.text forKey:@"business_title"];
                
            }
            if (![_tfRemark.text isEqualToString:@""]) {
                [param setObject:_tfRemark.text forKey:@"addtext"];
            }
            if (![_describeTextView.text isEqualToString:@"补充下宝贝的描述和亮点吧！"]) {
                [param setObject:_describeTextView.text forKey:@"business_des"];
             }
            if (![_tfDadyPrice.text isEqualToString:@""]) {
                [param setObject:_tfDadyPrice.text forKey:@"sell_price"];

            }
            
            if (![_tfDeposit.text isEqualToString:@""]) {
                [param setObject:_tfDeposit.text forKey:@"market_price"];
            }
            
            if (![_tfPhoneNumber.text isEqualToString:@""]) {
                [param setObject:_tfPhoneNumber.text forKey:@"business_contact"];
                
            }
            if (![_tfQQ.text isEqualToString:@""]) {
                [param setObject:_tfQQ.text forKey:@"qq"];
                
            }
            if (![_tfAddress.text isEqualToString:@""]) {
                [param setObject:_tfAddress.text forKey:@"business_location"];
                
            }
            if (![_tfYear.text isEqualToString:@""]) {
                [param setObject:_tfYear.text forKey:@"age"];
                
            }
            //是否有图
            if (imgageArray.count) {
                [param setObject:[NSString stringWithFormat:@"%lu",(unsigned long)imgageArray.count] forKey:@"file_count"];
                [param setObject:imgageArray forKey:@"photos"];
            }
            
            if (imgStrArray.count) {
                [param setObject:imgStrArray forKey:@"img_urls"];
            }
            [self postData:param];

        }
        
    }

    
}
#pragma mark 数据请求
-(void)postData:(NSDictionary*)Param{
    [LoadingView startOnTheViewController:self];
    UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewV1UrlStr:@"publicToys" Method:NetMethodPost andParam:Param];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
    for (NSString *key in [Param allKeys]) {
        
        if ([key isEqualToString:@"photos"]) {
            
            NSArray *photoArray=[Param objectForKey:key];
            
            if (photoArray.count==1) {
                
                UIImage *image=[photoArray firstObject];
                NSData *basicImgData=UIImagePNGRepresentation(image);
                
                if (basicImgData.length/1024>300) {
                    
                    CGFloat scale=512/image.size.width;
                    CGSize size=CGSizeMake(512, image.size.height*scale);
                    UIImage *newImage=[image scaleToSize:image size:size];
                    
                    float quality=0.75;
                    NSData *imgData=UIImageJPEGRepresentation(newImage, quality);
                    [request setData:imgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",1]];
                    
                }else{
                    
                    [request setData:basicImgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",1]];
                    
                }
                
            }else{
                
                for (int i=0; i<[photoArray count] ; i++) {
                    
                    UIImage *image=[photoArray objectAtIndex:i];
                    NSData *basicImgData=UIImagePNGRepresentation(image);
                    
                    if (basicImgData.length/1024>200) {
                        
                        CGFloat scale=320/image.size.width;
                        CGSize size=CGSizeMake(320, image.size.height*scale);
                        UIImage *newImage=[image scaleToSize:image size:size];
                        
                        float quality=0.75;
                        NSData *imgData=UIImageJPEGRepresentation(newImage, quality);
                        [request setData:imgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                        
                    }else{
                        
                        [request setData:basicImgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                        
                    }
                    
                }
                
            }
            
        }else if ([key isEqualToString:@"img_urls"]){
            
            NSArray *urlArry=[Param objectForKey:key];
            NSString *urlJsonStr=[urlArry JSONRepresentation];
            
            [request setPostValue:urlJsonStr forKey:key];
            
        }else{
            NSString *value=[Param objectForKey:key];
            [request setPostValue:value forKey:key];
        }
    }
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:120];
    [request startAsynchronous];
    __weak ASIFormDataRequest *blockRequest=request;
    [request setCompletionBlock:^{
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:@"success"]integerValue] == 1) {
            self.refreshIngrowthVC();
            [LoadingView stopOnTheViewController:self];
            [self.navigationController popViewControllerAnimated:YES];

        }else{
            [LoadingView stopOnTheViewController:self];

            NSString *errorString=[dic objectForKey:@"reMsg"];
            [BBSAlert showAlertWithContent:errorString andDelegate:self];
        }
    
    }];
    [request setFailedBlock:^{
        [LoadingView stopOnTheViewController:self];
        [BBSAlert showAlertWithContent:@"您似乎与网络断开，检查一下网络再发送吧" andDelegate:self];

    }];
}
#pragma mark 选择图片
-(void)ChoosePhoto{
    
    [_titleTextView resignFirstResponder];
    [_describeTextView resignFirstResponder];
    [_tfAddress resignFirstResponder];
    [_scrollView endEditing:YES];
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"自由环球租赁" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选",@"从手机相册选",@"拍一张", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}
#pragma mark 类别选项
-(void)chooseLeaseOrBuy:(UIButton*)sender{
    [_scrollView endEditing:YES];
    UIButton *button = (UIButton*)sender;
    if (button.tag == 801) {
        _way = YES;
        [self.leaseToyBtn setImage:[UIImage imageNamed:@"btn_select_pay"] forState:UIControlStateNormal];
        [self.buyToyBtn setImage:[UIImage imageNamed:@"btn_unselect_pay"] forState:UIControlStateNormal];
        self.labelDadyPrice.text = @"日收租金：";
        self.LabelmoneyDay.text = @"元/天";
        self.labelDeposit.text = @"最高损赔：";
        self.tfDadyPrice.placeholder = @"如：3";
        self.tfDeposit.placeholder = @"如：50";


    }else if (button.tag == 802){
        _way = NO;
        [self.leaseToyBtn setImage:[UIImage imageNamed:@"btn_unselect_pay"] forState:UIControlStateNormal];
        [self.buyToyBtn setImage:[UIImage imageNamed:@"btn_select_pay"] forState:UIControlStateNormal];
        self.labelDadyPrice.text = @"出售价格：";
        self.LabelmoneyDay.text = @"元";
        self.labelDeposit.text = @"市场价格：";
        self.tfDadyPrice.placeholder = @"如：100";
        self.tfDeposit.placeholder = @"如：100";


    }else if (button.tag == 803){
        _is_support = YES;
        [self.noSupportBtn setImage:[UIImage imageNamed:@"btn_unselect_pay"] forState:UIControlStateNormal];
        [self.yesSupportBtn setImage:[UIImage imageNamed:@"btn_select_pay"] forState:UIControlStateNormal];
        
    }else if (button.tag == 804){
        _is_support = NO;
        [self.noSupportBtn setImage:[UIImage imageNamed:@"btn_select_pay"] forState:UIControlStateNormal];
        [self.yesSupportBtn setImage:[UIImage imageNamed:@"btn_unselect_pay"] forState:UIControlStateNormal];

    }
    
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

#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (textView==_titleTextView) {
        
        if ([textView.text isEqualToString:@"一句话描述一下宝贝吧"]) {
            _titleTextView.frame = CGRectMake(50, 12, SCREENWIDTH-20, 30);
            textView.text=@"";
            
        }
        
    }else if (textView==_describeTextView){
        
        if ([textView.text isEqualToString:@"补充下宝贝的描述和亮点吧！"]) {
            textView.text=@"";
        }
        
    }else if (textView == self.tfAddress){
        if ([textView.text isEqualToString:@"地址不会显示在您的发布信息里面"]) {
            textView.text=@"";
        }

    }
    
}
-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView==_titleTextView) {
        
        if (textView.text.length==0) {
            textView.text=@"一句话描述一下宝贝吧";
            _titleTextView.frame = CGRectMake(50, 13, SCREENWIDTH-20, 30);
        }
        
    }else if (textView==_describeTextView){
        
        if (textView.text.length==0) {
            textView.text=@"补充下宝贝的描述和亮点吧！";
        }
        
    }else if (textView==_tfAddress){
        
        if (textView.text.length==0) {
            textView.text=@"地址不会显示在您的发布信息里面";
        }
        
    }
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    if (textView==_titleTextView) {
        
        if (textView.text.length>=50) {
            [BBSAlert showAlertWithContent:@"标题最多50字哟！" andDelegate:self];
            textView.text=[textView.text substringToIndex:50];
        }
    }else if (textView==_describeTextView){
        //        if (textView.text.length>=500) {
        //            [BBSAlert showAlertWithContent:@"描述最多500字哟！" andDelegate:self];
        //            textView.text=[textView.text substringToIndex:500];
        //        }
        
    }
}
#pragma mark notification keyboard
//键盘变化的监听方法
-(void)keyboardWillShow:(NSNotification *) note{
    
    NSDictionary *userInfoDic=[note userInfo];
    NSValue *framenValue=[userInfoDic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame=[framenValue CGRectValue];
    _keyHeight = frame.size.height;
   _scrollView.contentSize = CGSizeMake(SCREENWIDTH, self.backView3.frame.origin.y+self.backView3.frame.size.height+30+_keyHeight);
}

-(void)keyboardWillDisapper:(NSNotification *) note{
    _scrollView.contentSize = CGSizeMake(SCREENWIDTH, self.backView3.frame.origin.y+self.backView3.frame.size.height+30);
}


#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    
    UIColor *color=[UIColor whiteColor];
    NSDictionary *dic=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    imagePicker.navigationBar.titleTextAttributes=dic;
    
    
    if (buttonIndex==1) {
        //从手机相册
        if (self.pickedImagesArray.count<6) {
            
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            elcPicker.maximumImagesCount = 6-self.pickedImagesArray.count;
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
            
            if (self.pickedImagesArray.count<6) {
                
                [self.pickedImagesArray removeAllObjects];
                
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
        NSUInteger currentCount = self.pickedImagesArray.count;
        NSDictionary *movingDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"isChoosing",[NSNumber numberWithUnsignedInteger:currentCount],@"currentCount", nil];
        albumListVC.title = @"选择";
        albumListVC.movingInfo = movingDict;
        albumListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:albumListVC animated:YES];
        
    }else {
        
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        
    }
    
}
#pragma mark UIImagePickerViewDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    UIImageOrientation imageOrientation=image.imageOrientation;
    if(imageOrientation!=UIImageOrientationUp)
    {
        UIGraphicsBeginImageContext(image.size);
        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    
    [self.pickedImagesArray addObject:image];
    [self showImagesWithPhotosArray:self.pickedImagesArray];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark ELCImagePickerControllerDelegate

-(void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    for (NSDictionary *dict in info) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        [self.pickedImagesArray addObject:image];
        
    }
    
    // [self removeImageViews];
    [self showImagesWithPhotosArray:self.pickedImagesArray];
    
}

-(void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)showImagesWithPhotosArray:(NSArray *) photosArray{
    
    for (id obj in photosArray) {
        NSInteger i = [photosArray indexOfObject:obj];
        CGRect imageviewFrame;
        if (i<3) {
            imageviewFrame=CGRectMake(10+(i+2)*(imageWidth+10), 10, imageWidth, imageWidth);
            
        }else if (i<7){
            
            imageviewFrame=CGRectMake(10+(i-2)*(imageWidth+10), imageWidth+20, imageWidth, imageWidth);
            
        }
        UIImageView *photoView = [[UIImageView alloc]initWithFrame:imageviewFrame];
        if ([obj isKindOfClass:[UIImage class]]) {
            photoView.image = (UIImage *)obj;
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            NSDictionary *imgDic = (NSDictionary *)obj;
            NSString *thumbUrlStr=[imgDic objectForKey:@"img_thumb"];
            [photoView sd_setImageWithURL:[NSURL URLWithString:thumbUrlStr]];
        }
        [_imgView addSubview:photoView];
        _imgView.frame =  CGRectMake(0, 0, SCREENWIDTH, imageviewFrame.origin.y+imageviewFrame.size.height+10);
        _photoBackView.frame = CGRectMake(0, _textBackView.frame.size.height,SCREENWIDTH, imageviewFrame.origin.y+imageviewFrame.size.height+10);
        self.imgTextAddBtn.frame = CGRectMake(self.addImgBtn.frame.origin.x+imageWidth+10, 10, imageWidth+5, imageWidth);
        self.backView4.frame = CGRectMake(0, _photoBackView.frame.origin.y+_photoBackView.frame.size.height, SCREENWIDTH, self.backView4.frame.size.height);

        self.backView2.frame = CGRectMake(0, self.backView4.frame.origin.y+self.backView4.frame.size.height, SCREENWIDTH, 80);
        self.backView3.frame = CGRectMake(0, self.backView2.frame.origin.y+self.backView2.frame.size.height, SCREENWIDTH, 300);
        _scrollView.contentSize = CGSizeMake(SCREENWIDTH, self.backView3.frame.origin.y+self.backView3.frame.size.height+30);
        
    }
    
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
