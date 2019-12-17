//
//  StoreDetailNewVC.m
//  BabyShow
//
//  Created by WMY on 16/6/2.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "StoreDetailNewVC.h"
#import "DeleteLineLabel.h"
#import "SDWebImageManager.h"
#import "SubmitOrderViewController.h"
#import "StoreMoreListVC.h"
#import "PostMyGroupDetailVController.h"
#import "PostBarSecondeVC.h"
#import "PostBarMoreViewController.h"
#import "MWPhotoBrowser.h"
#import "BBSNavigationController.h"
#import "MWPhoto.h"
#import "StoreMapViewController.h"
#import "UIImageView+WebCache.h"
#import "BusinessCommentListVC.h"
#import "ShowAlertView.h"
#import "LoginHTMLVC.h"
#import "PayOrderNewVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "payRequsestHandler.h"
#import "PostBarGroupNewVC.h"
#import "PostBarNewGroupOnlyOneVC.h"


@interface StoreDetailNewVC ()
@property(nonatomic,strong)UIButton *shareBtn;
@property(nonatomic,strong)UIScrollView *bottomScrollView;//整体的底色
@property(nonatomic,strong)UIView *imgBackView;//商家图片
@property(nonatomic,strong)NSMutableArray *thumbArray;
@property(nonatomic,strong)NSMutableArray *imgBigArray;//商家大小图片的数组
@property(nonatomic,strong)NSMutableArray *storePicArray;


@property(nonatomic,strong)UIView *introductionBackView;//商家时间
@property(nonatomic,strong)UIView *packageBackView;

@property(nonatomic,strong)NSString *lat;
@property(nonatomic,strong)NSString *log;
@property(nonatomic,strong)NSString *tencentLat;
@property(nonatomic,strong)NSString *tencentLog;

@property(nonatomic,strong)UIView *detailBackView;//商家详情
@property(nonatomic,strong)UIView *backViewComment;//商家评价
@property(nonatomic,strong)NSString *storeNameString; //商家名称
@property(nonatomic,strong)NSString *storeAddressString;//商家地址
@property(nonatomic,strong)NSString *phoneString; //电话号码
@property(nonatomic,assign)NSInteger user_role;//是否是商家角色
@property(nonatomic,strong)NSString *business_payment;
@property(nonatomic,strong)NSMutableArray *businessPaymentArray;
@property(nonatomic,strong)NSMutableArray *packageArray;
@property(nonatomic,strong)NSString *groupId;//如果商家建了群，要关联跳转

@end

@implementation StoreDetailNewVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    self.storePicArray = [[NSMutableArray alloc]init];
    self.tabBarController.tabBar.hidden = YES;
    NSLog(@"app秘钥 = %@,长度 = %ld,app=%@",PARTNER_ID,PARTNER_ID.length,[NSString stringWithFormat:@"%@",theAppDelegate.appSecret]);

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButton];
    [self setRightButton];
    
    _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,self.view.bounds.size.height)];
    _bottomScrollView.contentSize = CGSizeMake(SCREENWIDTH, 3500);
    _bottomScrollView.alwaysBounceVertical = YES;
    _bottomScrollView.backgroundColor = [BBSColor hexStringToColor:@"f9f9f9"];
    [self.view addSubview:_bottomScrollView];
    
    [self getStoreData];
    // Do any additional setup after loading the view.
}
#pragma mark UI布局
-(void)setLeftButton{
    //返回按钮
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 31)];
    imagev.image = [UIImage imageNamed:@"btn_back1.png"];
    [_backBtn addSubview:imagev];
    UILabel *cateName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 31)];
    cateName.textColor = [UIColor whiteColor];
    cateName.text = @"商家详情";
    [_backBtn addSubview:cateName];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
-(void)setRightButton{
    UIView *iconBgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];

    self.shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.shareBtn.frame = CGRectMake(0, 0, 18, 18);
    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"btn_new_toy_share"] forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(shareStoreMeg) forControlEvents:UIControlEventTouchUpInside];
    [iconBgView addSubview:self.shareBtn];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:iconBgView];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
#pragma mark Data
-(void)getStoreData{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.business_id,@"business_id", nil];
    [LoadingView startOnTheViewController:self];
    [[HTTPClient sharedClient]getNewV1:KBusinessDetailV6 params:params success:^(NSDictionary *result){
        if ([[result objectForKey:kBBSSuccess]boolValue]==YES) {
            [LoadingView stopOnTheViewController:self];
            NSDictionary *dataDic = result[@"data"];
            self.user_role = [dataDic[@"user_role"]integerValue];
            //商家图片的数组
            NSArray *imgsArray = dataDic[@"img"];
            
            _thumbArray = [NSMutableArray array];
            _imgBigArray = [NSMutableArray array];
            for (NSDictionary *imgDic in imgsArray) {
                [_thumbArray addObject:imgDic[@"img_thumb"]];
                [_imgBigArray addObject:imgDic[@"img"]];
            }
            //商家图片
            self.imgBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 124)];
            self.imgBackView.backgroundColor = [UIColor whiteColor];
            UIImageView *imgStoreView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,SCREENWIDTH,124)];
            [imgStoreView sd_setImageWithURL:[NSURL URLWithString:_thumbArray[0]] placeholderImage:[UIImage imageNamed:@"img_imgloding"]];
            
            [imgStoreView  setContentMode:UIViewContentModeScaleAspectFill];
            imgStoreView.clipsToBounds = YES;

            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(lookDetailPic)];
            imgStoreView.userInteractionEnabled = YES;
            [imgStoreView addGestureRecognizer:singleTap];
            [self.imgBackView addSubview:imgStoreView];
            [self.bottomScrollView addSubview:self.imgBackView];
            //商家图片上的小控件
            UIImageView *imgCountBack =  [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-70, 100,60, 20)];
            imgCountBack.image = [UIImage imageNamed:@"img_myshownew_countlabel_backgroundnew"];
            imgCountBack.backgroundColor = [BBSColor hexStringToColor:@"333333" alpha:0.5];
            [imgStoreView addSubview:imgCountBack];
            CGRect countLabelFrame=CGRectMake(20, 0, 40, 19.5);
            UILabel *countLabel=[[UILabel alloc]initWithFrame:countLabelFrame];
            countLabel.font=[UIFont systemFontOfSize:10];
            countLabel.textColor=[UIColor whiteColor];
            countLabel.textAlignment=NSTextAlignmentCenter;
            [imgCountBack addSubview:countLabel];
            countLabel.text = [NSString stringWithFormat:@"%lu张",(unsigned long)_thumbArray.count];
            
            //商家建群之后跳转，如果groupid存在，那就可以有
            self.groupId = dataDic[@"group_id"];
            if (self.groupId.length > 0) {
                UIButton *addGroupBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                addGroupBtn.frame = CGRectMake(SCREENWIDTH-140, 100, 60, 20);
                [addGroupBtn setBackgroundImage:[UIImage imageNamed:@"btn_enter_storeGroup"] forState:UIControlStateNormal];
                [imgStoreView addSubview:addGroupBtn];
                [addGroupBtn addTarget:self action:@selector(pushInGroupDetail) forControlEvents:UIControlEventTouchUpInside];

            }
            
            
            //商家名称和商家简介
            self.introductionBackView =[[UIView alloc]init];
            self.introductionBackView.backgroundColor = [UIColor whiteColor];
            [self.bottomScrollView addSubview:self.introductionBackView];
            
            NSString *storeName = dataDic[@"business_title"];
            self.storeNameString = storeName;
            NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
            CGSize textsize = [storeName boundingRectWithSize:CGSizeMake(SCREENWIDTH-22, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            //商家名称
            UILabel *labelStoreName = [[UILabel alloc]initWithFrame:CGRectMake(11,8, SCREENWIDTH-22, textsize.height)];
            labelStoreName.font = [UIFont systemFontOfSize:14];
            labelStoreName.numberOfLines = 0;
            labelStoreName.text = storeName;
            [self.introductionBackView addSubview:labelStoreName];
            UIImageView *imgLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, labelStoreName.frame.origin.y+labelStoreName.frame.size.height+8, SCREENWIDTH, 1)];
            imgLine1.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
            [self.introductionBackView addSubview:imgLine1];
            //商家地址
            UILabel *_labelAddress = [[UILabel alloc]initWithFrame:CGRectMake(labelStoreName.frame.origin.x,imgLine1.frame.origin.y+5, 235, 32)];
            _labelAddress.font = [UIFont systemFontOfSize:13];
            _labelAddress.numberOfLines = 0;
            _labelAddress.lineBreakMode = NSLineBreakByWordWrapping;
            _labelAddress.text = dataDic[@"business_location"];
            [self.introductionBackView addSubview:_labelAddress];
            UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH-67,imgLine1.frame.origin.y+1+10, 1, 25)];
            lineView1.backgroundColor = [BBSColor hexStringToColor:@"e6e6e6"];
            [self.introductionBackView addSubview:lineView1];
            //商家地图
            UIImageView *_imgMap =  [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-43,lineView1
                                                                                 .frame.origin.y+3, 14.5, 19.5)];
            _imgMap.userInteractionEnabled = YES;
            _imgMap.image = [UIImage imageNamed:@"img_store_position"];
            [self.introductionBackView addSubview:_imgMap];
            
            self.lat = dataDic[@"lat"];
            self.log = dataDic[@"log"];
            self.tencentLat = dataDic[@"tencent_lat"];
            self.tencentLog = dataDic[@"tencent_log"];
            self.storeAddressString = dataDic[@"business_location"];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickMap)];
            [_imgMap addGestureRecognizer:tap];
            //我是时间地址的分界线
            UIImageView *imgLine2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, _labelAddress.frame.origin.y+_labelAddress.frame.size.height+8, SCREENWIDTH, 1)];
            imgLine2.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
            [self.introductionBackView addSubview:imgLine2];
            //时间
            UILabel *_labelOpenTime = [[UILabel alloc]initWithFrame:CGRectMake(_labelAddress.frame.origin.x,imgLine2.frame.origin.y+8,235, 32)];
            _labelOpenTime.font = [UIFont systemFontOfSize:13];
            _labelOpenTime.textColor = [BBSColor hexStringToColor:@"434343"];
            _labelOpenTime.numberOfLines = 0;
            _labelOpenTime.lineBreakMode = NSLineBreakByWordWrapping;
            _labelOpenTime.text = dataDic[@"work_time"];
            [self.introductionBackView addSubview:_labelOpenTime];
            
            UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH-67,imgLine2.frame.origin.y+11 , 1, 25)];
            lineView2.backgroundColor = [BBSColor hexStringToColor:@"e6e6e6"];
            [self.introductionBackView addSubview:lineView2];
            //电话
            UIButton *_phoneButton = [UIButton buttonWithType:UIButtonTypeSystem];
            _phoneButton.frame = CGRectMake(_imgMap.frame.origin.x, lineView2.frame.origin.y+3, 15, 20);
            [_phoneButton setBackgroundImage:[UIImage imageNamed:@"btn_store_call"] forState:UIControlStateNormal];
            [_phoneButton addTarget:self action:@selector(alertViewShow) forControlEvents:UIControlEventTouchUpInside];
            [self.introductionBackView addSubview:_phoneButton];
            _phoneString = dataDic[@"business_contact"];
            
            self.introductionBackView.frame = CGRectMake(0, 124, SCREENWIDTH, _phoneButton.frame.origin.y+_phoneButton.frame.size.height+10);
            
            //商家套餐
            self.packageBackView = [[UIView alloc]init];
            [self.bottomScrollView addSubview:self.packageBackView];
            NSArray *packArray = dataDic[@"package"];
            float heightPack = 0 ;
            int index = 0;
            _packageArray = [NSMutableArray array];
            _businessPaymentArray = [NSMutableArray array];
            for (NSDictionary *packageDic in packArray) {
                UIView *backCombine = [[UIView alloc]init];
                self.packageBackView.backgroundColor = [UIColor whiteColor];
                [self.packageBackView addSubview:backCombine];
                //哪个套餐
                UILabel *priceCombineLabel = [[UILabel alloc]initWithFrame:CGRectMake(11, 10, 80, 20)];
                priceCombineLabel.text = packageDic[@"package_name"];
                priceCombineLabel.textAlignment = NSTextAlignmentLeft;
                priceCombineLabel.textColor = [BBSColor hexStringToColor:@"6191fe"];
                [backCombine addSubview:priceCombineLabel];
                //立即抢购
                UIButton *_buttonPay = [UIButton buttonWithType:UIButtonTypeSystem];
                _buttonPay.frame = CGRectMake(SCREENWIDTH-80, priceCombineLabel.frame.origin.y-2, 73.5, 24);
                _buttonPay.adjustsImageWhenHighlighted = NO;
                //存放支付方式的数组
                [_businessPaymentArray addObject:packageDic[@"business_payment"]];
                
                //存放套餐的数组
                NSString *package =[NSString stringWithFormat:@"%@",packageDic[@"package"] ];
                [_packageArray addObject:package];
                _buttonPay.tag = index++;
                if ([packageDic[@"business_free_state"]isEqualToString:@"1"]) {
                    [_buttonPay setBackgroundImage:[UIImage imageNamed:@"btn_store_unpay"] forState:UIControlStateNormal];
                    _buttonPay.enabled = NO;
                }else{
                    [_buttonPay setBackgroundImage:[UIImage imageNamed:@"btn_store_pay"] forState:UIControlStateNormal];
                    _buttonPay.enabled = YES;
                    [_buttonPay addTarget:self action:@selector(pushSubmitOrder:) forControlEvents:UIControlEventTouchUpInside];
                    //代表支付方式是什么（0代表线上和上门，1代表线上，2代表上门）
                    _business_payment = [NSString stringWithFormat:@"%@",dataDic[@"business_payment"]];
                    
                }
                
                [backCombine addSubview:_buttonPay];
                
                
                //秀秀价
                UIImageView *linePrice = [[UIImageView alloc]initWithFrame:CGRectMake(0,priceCombineLabel.frame.origin.y+priceCombineLabel.frame.size.height+10, SCREENWIDTH, 1)];
                linePrice.backgroundColor = [BBSColor hexStringToColor:@"f2f2f2"];//1
                [backCombine addSubview:linePrice];
                
                //会员价
                UILabel *memberPrice = [[UILabel alloc]initWithFrame:CGRectMake(11, 50, 60, 16)];
                memberPrice.font = [UIFont systemFontOfSize:11];
                memberPrice.text = @"玩具会员价";
                memberPrice.textAlignment = NSTextAlignmentLeft;
                memberPrice.textColor = [BBSColor hexStringToColor:@"333333"];
                [backCombine addSubview:memberPrice];
                
                UILabel *memberPriceCount = [[UILabel alloc]initWithFrame:CGRectMake(memberPrice.frame.origin.x+memberPrice.frame.size.width,47 , 70, 20)];
                //memberPriceCount.backgroundColor = [UIColor redColor];
                memberPriceCount.font = [UIFont systemFontOfSize:16];
                memberPriceCount.text = packageDic[@"business_member_price"];;
                memberPriceCount.textAlignment = NSTextAlignmentLeft;
                memberPriceCount.textColor = [BBSColor hexStringToColor:@"ff4d4d"];
                [backCombine addSubview:memberPriceCount];


                
                
                UILabel *babyShowPrice = [[UILabel alloc]initWithFrame:CGRectMake(memberPriceCount.frame.origin.x+memberPriceCount.frame.size.width-5, 50, 39, 16)];
                babyShowPrice.font = [UIFont systemFontOfSize:11];
                babyShowPrice.text = @"秀秀价";
                babyShowPrice.textAlignment = NSTextAlignmentLeft;
                babyShowPrice.textColor = [BBSColor hexStringToColor:@"333333"];
                [backCombine addSubview:babyShowPrice];
                
                UILabel *babyShowPriceCount = [[UILabel alloc]initWithFrame:CGRectMake(babyShowPrice.frame.origin.x+babyShowPrice.frame.size.width, 47, 70, 20)];
                babyShowPriceCount.font = [UIFont systemFontOfSize:16];
                babyShowPriceCount.text = packageDic[@"business_babyshow_price"];;
                babyShowPriceCount.textAlignment = NSTextAlignmentLeft;
                babyShowPriceCount.textColor = [BBSColor hexStringToColor:@"ff4d4d"];
                [backCombine addSubview:babyShowPriceCount];
                
                //原价
                UILabel *markPrice = [[DeleteLineLabel alloc]initWithFrame:CGRectMake(babyShowPriceCount.frame.origin.x+babyShowPriceCount.frame.size.width-5, 50, 100, 16)];
                markPrice.font = [UIFont systemFontOfSize:11];
                markPrice.textColor = [BBSColor hexStringToColor:@"999999"];
                [backCombine addSubview:markPrice];
                markPrice.text = [NSString stringWithFormat:@"店面价%@",packageDic[@"business_market_price"]];
                //活动
                NSString *business_package = packageDic[@"business_package"];
                NSDictionary  *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
                CGSize textsize1 = [business_package boundingRectWithSize:CGSizeMake(SCREENWIDTH-22, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
                UILabel *_labelHudong = [[UILabel alloc]initWithFrame:CGRectMake(priceCombineLabel.frame.origin.x, 68, SCREENWIDTH-22, textsize1.height+5)];
                _labelHudong.font = [UIFont systemFontOfSize:12];
                _labelHudong.textColor = [BBSColor hexStringToColor:@"666666"];
                _labelHudong.numberOfLines = 0;
                _labelHudong.text = business_package;
                [backCombine addSubview:_labelHudong];
                
                NSString *business_activity_num = packageDic[@"business_activity_num"];
                CGSize textsizeCount1 = [business_activity_num boundingRectWithSize:CGSizeMake(SCREENWIDTH-22, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
                UILabel *countOfCombine = [[UILabel alloc]initWithFrame:CGRectMake(priceCombineLabel.frame.origin.x, _labelHudong.frame.origin.y+_labelHudong.frame.size.height+10, SCREENWIDTH-22, textsizeCount1.height+5)];
                countOfCombine.font = [UIFont systemFontOfSize:12];
                countOfCombine.textColor = [BBSColor hexStringToColor:@"999999"];
                countOfCombine.numberOfLines = 0;
                countOfCombine.text =business_activity_num;
                [backCombine addSubview:countOfCombine];
                //有效期
                NSString *timeExpireString = packageDic[@"business_activity_time"];
                CGSize textsizeTime1 = [timeExpireString boundingRectWithSize:CGSizeMake(SCREENWIDTH-22, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
                
                
                UILabel *timeExpire = [[UILabel alloc]initWithFrame:CGRectMake(priceCombineLabel.frame.origin.x, countOfCombine.frame.origin.y+countOfCombine.frame.size.height+10, SCREENWIDTH-22, textsizeTime1.height+5)];
                timeExpire.text = timeExpireString;
                timeExpire.font = [UIFont systemFontOfSize:12];
                timeExpire.textColor = [BBSColor hexStringToColor:@"999999"];
                timeExpire.numberOfLines = 0;
                [backCombine addSubview:timeExpire];
                backCombine.frame = CGRectMake(0, 0, SCREENWIDTH,timeExpire.frame.origin.y+timeExpire.frame.size.height+10);
                UIView *lineCombine1 = [[UIView alloc]initWithFrame:CGRectMake(0, backCombine.frame.size.height-0.5, SCREENWIDTH, 0.5)];
                lineCombine1.backgroundColor = [BBSColor hexStringToColor:@"e6e6e6"];
                [backCombine addSubview:lineCombine1];
                backCombine.frame = CGRectMake(0, heightPack, SCREENWIDTH, lineCombine1.frame.origin.y+1);
                
                heightPack = heightPack+lineCombine1.frame.origin.y+1;
                self.packageBackView.frame = CGRectMake(0, self.introductionBackView.frame.origin.y+self.introductionBackView.frame.size.height+7, SCREENWIDTH, heightPack);
                
            }
            //商家简介
            self.detailBackView = [[UIView alloc]initWithFrame:CGRectMake(0, self.packageBackView.frame.origin.y+self.packageBackView.frame.size.height+7, SCREENWIDTH, 300)];
            self.detailBackView.backgroundColor = [UIColor whiteColor];
            [self.bottomScrollView addSubview:self.detailBackView];
            UILabel *_simpleLabel = [[UILabel alloc]initWithFrame:CGRectMake(11,10, 60, 17)];
            _simpleLabel.text = @"简介 ：";
            _simpleLabel.font = [UIFont systemFontOfSize:13];
            [self.detailBackView addSubview:_simpleLabel];
            
            NSString *simpleString =  dataDic[@"business_description"];
            NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:simpleString];
            NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle1 setLineSpacing:5.0];
            [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [simpleString length])];
            UILabel *labelSimpleDetail = [[UILabel alloc]initWithFrame:CGRectMake(11, _simpleLabel.frame.origin.y+20, SCREENWIDTH-25, 30)];
            labelSimpleDetail.text = @"暂无简介详情";
            labelSimpleDetail.font = [UIFont systemFontOfSize:12];
            labelSimpleDetail.numberOfLines = 0;
            [labelSimpleDetail setAttributedText:attributedString1];
            [labelSimpleDetail sizeToFit];
            
            labelSimpleDetail.lineBreakMode = NSLineBreakByWordWrapping;
            labelSimpleDetail.textColor = [BBSColor hexStringToColor:@"666666"];
            labelSimpleDetail.frame = CGRectMake(labelSimpleDetail.frame.origin.x,labelSimpleDetail.frame.origin.y, SCREENWIDTH-25, labelSimpleDetail.frame.size.height);
            [self.detailBackView addSubview:labelSimpleDetail];
            
            self.detailBackView.frame = CGRectMake(0, self.packageBackView.frame.origin.y+self.packageBackView.frame.size.height+7, SCREENWIDTH, labelSimpleDetail.frame.origin.y+labelSimpleDetail.frame.size.height+10);
            //综合评价
            self.backViewComment = [[UIView alloc]init];
            self.backViewComment.backgroundColor = [UIColor whiteColor];
            [self.bottomScrollView addSubview:self.backViewComment];
            
            UILabel *labelCommentTotal = [[UILabel alloc]initWithFrame:CGRectMake(11 ,8, 65, 20)];
            labelCommentTotal.text = @"综合评价";
            labelCommentTotal.textColor = [BBSColor hexStringToColor:@"666666"];
            labelCommentTotal.font = [UIFont systemFontOfSize:14];
            [self.backViewComment addSubview:labelCommentTotal];
            UIImageView *lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(72, 9.5,1, 16)];
            lineImg.backgroundColor = [BBSColor hexStringToColor:@"f2f2f2"];
            [self.backViewComment addSubview:lineImg];
            
            NSString *grade1 = dataDic[@"grade1"];
            UIImageView  *_imgLevelChild = [[UIImageView alloc]initWithFrame:CGRectMake(85, 10, 82, 13)];
            [_imgLevelChild sd_setImageWithURL:[NSURL URLWithString:grade1]];
            [self.backViewComment addSubview:_imgLevelChild];
            
            
            NSString *commentPeople = dataDic[@"user_name"];
            if (commentPeople.length <= 0) {
                self.backViewComment.frame =CGRectMake(0, self.detailBackView.frame.origin.y+self.detailBackView.frame.size.height+7, SCREENWIDTH, 35);
            }else{
                UIImageView *lineImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 33,SCREENWIDTH, 1)];
                lineImg2.backgroundColor = [BBSColor hexStringToColor:@"eaeae9"];
                [self.backViewComment addSubview:lineImg2];
                
                UILabel *_babyCommentLabel = [[UILabel alloc]initWithFrame:CGRectMake(11 ,lineImg2.frame.origin.y+1+10,100, 17)];
                _babyCommentLabel.text = @"秀秀用户评论";
                _babyCommentLabel.textColor = [BBSColor hexStringToColor:@"666666"];
                _babyCommentLabel.font = [UIFont systemFontOfSize:14];
                [self.backViewComment addSubview:_babyCommentLabel];
                
                UIImageView *_lineImg3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, _babyCommentLabel.frame.origin.y+_babyCommentLabel.frame.size.height+10,SCREENWIDTH, 1)];
                _lineImg3.backgroundColor = [BBSColor hexStringToColor:@"eaeae9"];
                [self.backViewComment addSubview:_lineImg3];
                
                //用户名
                NSString *userName = dataDic[@"user_name"];
                UILabel *userLabel = [[UILabel alloc]initWithFrame:CGRectMake(11, _lineImg3.frame.origin.y+11, 200, 15)];
                CGSize size = [userName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:userLabel.font} context:nil].size;
                userLabel.text = userName;
                userLabel.font = [UIFont systemFontOfSize:12];
                userLabel.textColor = [BBSColor hexStringToColor:@"ff4d4d"];
                [self.backViewComment addSubview:userLabel];
                
                UIImageView *userImgView = [[UIImageView alloc]initWithFrame:CGRectMake(userLabel.frame.origin.x+size.width+3, userLabel.frame.origin.y+2, 65, 10)];
                [userImgView sd_setImageWithURL:[NSURL URLWithString:dataDic[@"grade3"]]];
                [self.backViewComment addSubview:userImgView];
                
                UILabel *timeCommentLabel = [[UILabel alloc]initWithFrame:CGRectMake(userImgView.frame.origin.x+65+7, userLabel.frame.origin.y, 80, 15)];
                timeCommentLabel.textAlignment = NSTextAlignmentRight;
                timeCommentLabel.text = dataDic[@"user_time"];
                timeCommentLabel.font = [UIFont systemFontOfSize:12];
                timeCommentLabel.textColor = [BBSColor hexStringToColor:@"666666"];
                [self.backViewComment addSubview:timeCommentLabel];
                
                UILabel *userCommentLabel = [[UILabel alloc]initWithFrame:CGRectMake(11, 102, SCREENWIDTH-22, 40)];
                userCommentLabel.font = [UIFont systemFontOfSize:12];
                userCommentLabel.numberOfLines = 2;
                userCommentLabel.lineBreakMode = NSLineBreakByWordWrapping;
                userCommentLabel.textColor = [BBSColor hexStringToColor:@"333333"];
                userCommentLabel.text = dataDic[@"user_msg"];
                [self.backViewComment addSubview:userCommentLabel];
                
                UIImageView *lineImg4 = [[UIImageView alloc]initWithFrame:CGRectMake(0, userCommentLabel.frame.origin.y+userCommentLabel.frame.size.height+10, SCREENWIDTH, 1)];
                lineImg4.backgroundColor = [BBSColor hexStringToColor:@"f2f2f2"];
                [self.backViewComment addSubview:lineImg4];
                
                UIButton  *moreCommentBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                moreCommentBtn.frame = CGRectMake(0, lineImg4.frame.origin.y+lineImg4.frame.size.height+3, SCREENWIDTH, 27);
                [moreCommentBtn setTintColor:[UIColor blackColor]];
                [moreCommentBtn addTarget:self action:@selector(moreCommentAction) forControlEvents:UIControlEventTouchUpInside];
                [self.backViewComment addSubview:moreCommentBtn];
                
                UILabel *moreComment = [[UILabel alloc]initWithFrame:CGRectMake(11, lineImg4.frame.origin.y+10, 120, 15)];
                moreComment.text = @"查看更多评论";
                moreComment.font = [UIFont systemFontOfSize:15];
                moreComment.textColor = [BBSColor hexStringToColor:@"666666"];
                [self.backViewComment addSubview:moreComment];
                
                UIImageView *arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-20, moreComment.frame.origin.y, 8, 14)];
                arrowImg.image = [UIImage imageNamed:@"img_store_arrowmyshow"];
                [self.backViewComment addSubview:arrowImg];
                self.backViewComment.frame =CGRectMake(0, self.detailBackView.frame.origin.y+self.detailBackView.frame.size.height+7, SCREENWIDTH, moreComment.frame.origin.y+25);
            }
            _bottomScrollView.contentSize =  CGSizeMake(SCREENWIDTH,self.backViewComment.frame.origin.y+self.backViewComment.frame.size.height+20);
            
        }else{
            [LoadingView stopOnTheViewController:self];
            [self showWrongNet];
        }
        
    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
        [self showWrongNet];
        
    }];
}
-(void)pushInGroupDetail{

    NSString *imgId = self.groupId;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:imgId,@"group_id", nil];
    PostBarNewGroupOnlyOneVC *postBarVC = [[PostBarNewGroupOnlyOneVC alloc]init];
    postBarVC.group_id = [imgId intValue];
    [self.navigationController pushViewController:postBarVC animated:YES];

}
#pragma mark 查看大图
-(void)lookDetailPic{
    
    [self.storePicArray removeAllObjects];
    for (int i = 0; i < _imgBigArray.count; i++) {
        MWPhoto *photo = [[MWPhoto alloc]initWithURL:[NSURL URLWithString:_imgBigArray[i]] info:nil];
        photo.img_info = @{@"description":[NSString stringWithFormat:@"%d/%lu",i+1,(unsigned long)_imgBigArray.count]};
        [self.storePicArray addObject:photo];
    }
    MWPhotoBrowser *broser = [[MWPhotoBrowser alloc]initWithDelegate:self];
    broser.displayActionButton = YES;//分享按钮默认是
    broser.displayNavArrows = NO;//左右分页切换默认否
    broser.displaySelectionButtons = NO;//是否显示选择按钮在图片上，默认否
    broser.zoomPhotosToFill = YES;//是否全屏，默认是
    broser.enableGrid = YES;//是否允许用网格查看所有图片,默认是
    broser.startOnGrid = NO;//是否第一张,默认否
    broser.needPlay = NO;
    broser.is_show_album = NO;
    broser.type = 10;
    broser.imgArr = self.storePicArray;
    [broser setCurrentPhotoIndex:0];
    BBSNavigationController *nav=[[BBSNavigationController alloc]initWithRootViewController:broser];
    [self presentViewController:nav animated:YES completion:nil];
    
}
#pragma mark - MWPhotoBrowserDelegate

-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    
    return _storePicArray.count;
    
}
-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    if (index < _storePicArray.count) {
        
        return [_storePicArray objectAtIndex:index];
        
    }
    
    return nil;
    
}
#pragma mark 分享商家
-(void)shareStoreMeg{
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",_imgBigArray[0]]];
    UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    NSData *basicImgData = UIImagePNGRepresentation(shareImg);
    if (basicImgData.length/1024>150) {
        shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
        
    }
    NSArray* imageArray = @[shareImg];
    NSString *urlString= [NSString stringWithFormat:@"%@business_id=%@",kStoreShare,self.business_id];
    NSString *content = [NSString stringWithFormat:@"%@",self.storeNameString];    //    NSLog(@"%@",urlString);return;
    
    
    
    [shareParams SSDKSetupShareParamsByText:content
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]
                                      title:content
                                       type:SSDKContentTypeAuto];
    
    //设置新浪微博
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",content,[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:content image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
    
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
#pragma mark 点击地图放大
-(void)clickMap{
    StoreMapViewController *storeMapVC = [[StoreMapViewController alloc]init];
    storeMapVC.storeName = self.storeNameString;
    storeMapVC.storeAddress = self.storeAddressString;
    storeMapVC.lat = self.lat;
    storeMapVC.log = self.log;
    storeMapVC.tencentLat = self.tencentLat;
    storeMapVC.tencentLog = self.tencentLog;
    [self.navigationController pushViewController:storeMapVC animated:NO];
    
    
}
#pragma mark alertView拨打电话提示
-(void)alertViewShow{
    NSString *telephone = [NSString stringWithFormat:@"确认拨打%@",_phoneString];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:telephone delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    [alert show];
    
}
#pragma mark alerviewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100) {
        if (buttonIndex==1) {
        }
        
    }else{
        if (buttonIndex == 1) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneString]]];
        }
    }
}
#pragma mark  点击立即抢购推出订单页面

-(void)pushSubmitOrder:(UIButton*)sender{
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
        
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
        return;
    }else{
        
        if (self.user_role == 1) {
            [BBSAlert showAlertWithContent:@"商家不可以下单" andDelegate:nil];
        }else{
            PayOrderNewVC *payOrder = [[PayOrderNewVC alloc]init];
            payOrder.longin_user_id = LOGIN_USER_ID;
            payOrder.business_id = self.business_id;
            payOrder.priceCombine = _packageArray[sender.tag];
            payOrder.payMent = _businessPaymentArray[sender.tag];
            [self.navigationController pushViewController:payOrder animated:YES];
            NSLog(@"_packageArray = %@,%@",payOrder.priceCombine,payOrder.payMent);
            
            
        }
    }
}
//查看更多评论
-(void)moreCommentAction{
    BusinessCommentListVC *businessCommentListVC = [[BusinessCommentListVC alloc]init];
    businessCommentListVC.businessId = self.business_id;
    businessCommentListVC.login_userId = LOGIN_USER_ID;
    [self.navigationController pushViewController:businessCommentListVC animated:YES];
    
    
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
    

}

#pragma mark 加载失败的页面
-(void)showWrongNet{
    _bottomScrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREENHEIGHT);
    
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
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getStoreData)];
    [imageView addGestureRecognizer:singleTap];
    
    
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
