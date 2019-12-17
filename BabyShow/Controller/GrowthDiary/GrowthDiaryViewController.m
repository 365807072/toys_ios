//
//  GrowthDiaryViewController.m
//  BabyShow
//
//  Created by Monica on 15-1-20.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//
#import <CoreGraphics/CoreGraphics.h>
#import <CoreLocation/CoreLocation.h>
#import "GrowthDiaryViewController.h"
#import "RegisterStep2ViewController.h"
#import "ELCImagePickerController.h"
#import "GrowthDetailViewController.h"
#import "CombineShareViewController.h"

#import "DiaryYearsCell.h"
#import "DiaryYearHalfCell.h"
#import "DiaryBornCell.h"
#import "DiaryBigNodeCell.h"

#import "GrowthDiaryBasicItem.h"

#import "SVPullToRefresh.h"
#import "DateFormatter.h"
#import "UIImageView+WebCache.h"
#import <ShareSDK/ShareSDK.h>
#import "ShowAlertView.h"
#import "FDActionSheet.h"
#import "AddBabyHeightAndWeightVC.h"
#import "GrowthDiaryHeightAndWeightItem.h"
#import "AddFouceGrowthDiaryVC.h"
#import "SynchroVC.h"
#import "LoginHTMLVC.h"
#import "RefreshControl.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>


#define maxNumberOfImages 20

#define ImportTag         1000
#define BabyIconTag       1001

typedef enum : NSUInteger {
    
    ActionSheetTypeImport,
    ActionSheetTypeBabyIcon,
    
} ActionSheetType;

@interface GrowthDiaryViewController ()<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,ELCImagePickerControllerDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,CLLocationManagerDelegate,FDActionSheetDelegate,RefreshControlDelegate>
{
    UIImageView *iconImageView;
    UILabel     *babyNameLabel;
    UIImageView *arrowImageView;
    UILabel     *babyBirthLabel;
    ActionSheetType actionSheetType;
    RefreshControl *_refreshControl;
    
}
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UITableView *babyTableView;

@property (nonatomic ,strong) NSMutableArray *babyListArray;
@property (nonatomic ,strong) NSMutableArray *albumListArray;

@property (nonatomic ,strong) NSString *loginUserID;
@property(nonatomic,assign)BOOL isInHeight;//是否在身高页面

/*!
 *  是否显示孩子列表
 */
@property (nonatomic ,assign) BOOL hideBabyList;
@property (nonatomic ,assign) NSInteger selectedBabyIndex;
@property (nonatomic ,assign) NSInteger selectedIndex;//选中的成长日记条
@property (nonatomic ,assign) int  page;        //当前翻页
@property (nonatomic ,assign) BOOL isFinished;  //没有下翻页就是YES
@property (nonatomic ,assign) BOOL isRefresh;

@property (nonatomic ,strong) CLLocationManager *locationManager;
@property (nonatomic ,strong) NSString *latitude;//拍照时当前手机的经纬度
@property (nonatomic ,strong) NSString *longitude;

//身高体重
@property(nonatomic,strong)UIImageView *imgToolHeight;
@property(nonatomic,strong)UILabel *labelHeight1;
@property(nonatomic,strong)UILabel *labelHeight2;
@property(nonatomic,strong)UILabel *labelHeight3;
@property(nonatomic,strong)UILabel *labelHeightPrecent;
@property(nonatomic,strong)UILabel *labelHeightCm;
@property(nonatomic,strong)UIButton *heightButton;
@property(nonatomic,strong)UIButton *weightButton;
@property(nonatomic,strong)UIButton *addBabyHeight;
@property(nonatomic,strong)UILabel *alertLabel;

@property(nonatomic,strong)NSString *height;
@property(nonatomic,strong)NSString *h50;
@property(nonatomic,strong)NSString *h_mid;
@property(nonatomic,strong)NSString *h950;
@property(nonatomic,strong)NSString *h_posi;
@property(nonatomic,strong)NSString *h_cal;
@property(nonatomic,strong)NSString *weight;
@property(nonatomic,strong)NSString *w50;
@property(nonatomic,strong)NSString *w_mid;
@property(nonatomic,strong)NSString *w950;
@property(nonatomic,strong)NSString *w_posi;
@property(nonatomic,strong)NSString *w_cal;
@property(nonatomic,strong)UIImageView *lineImg;
@property(nonatomic,strong)GrowthDiaryHeightAndWeightItem *item;
@property(nonatomic,assign)BOOL isViewWillApp;
@property(nonatomic,assign)BOOL isUser;
@property(nonatomic,strong)UIImageView*aView;//注册用户
@property(nonatomic,strong)UIImageView *visitorView;//游客


@end

@implementation GrowthDiaryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.loginUserID = LOGIN_USER_ID;
        _babyListArray = [[NSMutableArray alloc] init];
        _albumListArray = [[NSMutableArray alloc] init];
        _selectedBabyIndex = -1;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UserInfoManager *manager = [[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    if ([userItem.isVisitor boolValue] == YES || LOGIN_USER_ID == NULL) {
        [self layoutVisitor];//展示出游客身份的
    }else{
        [self userLoginLayout];//用户登录的页面
    }
    
}
#pragma mark 游客登陆的时候页面
-(void)layoutVisitor{
    self.view.backgroundColor=[UIColor whiteColor];
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.navigationController.navigationBar.hidden = YES;
    _visitorView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    _visitorView.image = [UIImage imageNamed:@"img_dairy_bottom_visitor"];
    _visitorView.userInteractionEnabled = YES;
    [self.view addSubview:_visitorView];

    
    UIImageView *anouceView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-40)];
    anouceView.image=[UIImage imageNamed:@"img_myshow_emptybaby"];
    [self.view addSubview:anouceView];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 227, 300, 30)];
    label.text=@"游客不能使用这里哟！";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:17];
    label.textColor=[BBSColor hexStringToColor:@"c6a886"];
    
    UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame=CGRectMake(SCREENWIDTH-232, SCREENHEIGHT-40-50, 144, 25);
    [loginBtn setImage:[UIImage imageNamed:@"btn_visitor_album_login"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(jumpToTheLoginView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
}
-(void)jumpToTheLoginView{
    
    LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:^{
    }];
    
    
}
#pragma mark 用户登陆的时候
-(void)userLoginLayout{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_diary_back"]];
    self.automaticallyAdjustsScrollViewInsets = NO;
    _isUser = YES;
    self.hideBabyList = YES;
    _isViewWillApp = YES;
    self.page = 1;
    self.isInHeight = 1;
    _selectedBabyIndex = -1;
    [self setHeadViewTool];
    [self setTableView];
    [self refreshControlInit];
    [self setViewHeader];
    [self setBabyTableView];
    self.latitude = @"";
    self.longitude = @"";
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UserInfoManager *manager = [[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    if ([userItem.isVisitor boolValue] == YES ||LOGIN_USER_ID == NULL) {
        
        
    }else{
        //如果是游客没登录之前点击这个模块，登录完了之后再次点击就不会走viewdidload这个方法，只会走这个，所以现在再次判断是否登录，登录状态的话就直接布局
        if (_isUser == NO) {
            [self userLoginLayout];
        }
        self.navigationController.navigationBarHidden = YES;
        self.tabBarController.tabBar.hidden = NO;
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:USERBABYUPDATE] intValue] == 1) {
            if (_isViewWillApp == YES) {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:USERBABYUPDATE];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }else{
                _selectedBabyIndex = -1;
                [self getBabyData];
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:USERBABYUPDATE];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
        
        if (self.needReload) {
            self.needReload = NO;
            if (_tableView) {
                [_albumListArray removeObjectAtIndex:_selectedIndex];
                [_tableView beginUpdates];
                [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [_tableView endUpdates];
            }
        }
        if (self.refresh) {
            self.refresh = NO;
            _isFinished = NO;
            _isRefresh = YES;
            _page = 1;
            NSLog(@"刷新方法里面走了一遍");
            [self getData];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importSucceed:) name:IMPORT_TO_DIARY_SUCCEED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importFailed:) name:IMPORT_TO_DIARY_FAIL object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBabyAvatarSucceed:) name:ADD_BABY_AVATAR_SUCCEED object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addBabyAvatarFailed:) name:ADD_BABY_AVATAR_FAIL object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed) name:USER_NET_ERROR object:nil];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    _isViewWillApp = NO;
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self hideBabyTableView];
    [LoadingView stopOnTheViewController:self];
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
            self.page = 1;
            [self getBabyData];
        }else{
            [self getData];
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

#pragma mark - View Methods
- (void)setRightBtn {
    UIButton *addBabyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBabyBtn.frame = CGRectMake(0, 0, 33, 33);
    [addBabyBtn setBackgroundImage:[UIImage imageNamed:@"btn_diary_addbaby"] forState:UIControlStateNormal];
    [addBabyBtn addTarget:self action:@selector(addAnotherBaby:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:addBabyBtn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10;
    self.navigationItem.rightBarButtonItems = @[spaceItem,rightBtn];
    
    
}
- (void)addNoBabyBack {
    _aView.backgroundColor = [UIColor clearColor];
    _aView.image = [UIImage imageNamed:@"img_dairy_bottom"];
    _aView.userInteractionEnabled = YES;
    UIImageView *anouceView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH ,SCREENHEIGHT-140)];
    anouceView.image=[UIImage imageNamed:@"img_myshow_emptybaby"];
    anouceView.tag = 1000;
    [self.view addSubview:anouceView];
    //[self showAlert];
    
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 242, 300, 30)];
    label.text=@"您还没有相关小孩信息哦,立马建立一个吧！";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:14];
    label.textColor=[BBSColor hexStringToColor:@"c6a886"];
    label.tag = 1001;
    
    UIButton *createBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    createBtn.frame=CGRectMake(0,80, SCREENWIDTH, SCREENHEIGHT-80-64);
    createBtn.backgroundColor = [UIColor clearColor];
        [createBtn addTarget:self action:@selector(addAnotherBaby:) forControlEvents:UIControlEventTouchUpInside];
    createBtn.tag = 1002;
    [self.view addSubview:createBtn];
}
- (void)setViewHeader {
    _aView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    _aView.backgroundColor = [BBSColor hexStringToColor:NAVICOLOR alpha:0.8];
    _aView.userInteractionEnabled = YES;
    
    UIImage *importImage = [UIImage imageNamed:@"btn_diary_addbaby"];
    UIButton *clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    clickBtn.frame = CGRectMake(SCREENWIDTH - importImage.size.width-2.5, (100-importImage.size.height)/2+10, importImage.size.width, importImage.size.height);
    [clickBtn setImage:importImage forState:UIControlStateNormal];
    [clickBtn addTarget:self action:@selector(oneKeyImport:) forControlEvents:UIControlEventTouchUpInside];
    clickBtn.tag = 9999;
    [_aView addSubview:clickBtn];
    
    UIImage *shareImage = [UIImage imageNamed:@"btn_diary_share"];
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(SCREENWIDTH - importImage.size.width-5 - shareImage.size.width , (100-shareImage.size.height)/2+10, shareImage.size.width, shareImage.size.height);
    [shareBtn setImage:shareImage forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(oneKeyShare:) forControlEvents:UIControlEventTouchUpInside];
    shareBtn.tag = 9998;
    [_aView addSubview:shareBtn];
    
    iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5.5, 15.5+10, 66.5, 66.5)];
    iconImageView.backgroundColor = [UIColor clearColor];
    iconImageView.image = [UIImage imageNamed:@"img_message_avatar_100"];
    iconImageView.layer.masksToBounds = YES;
    iconImageView.layer.cornerRadius = 66.5/2;
    iconImageView.userInteractionEnabled = YES;
    [_aView addSubview:iconImageView];
    
    UITapGestureRecognizer *addIconGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addorChangeIcon:)];
    [iconImageView addGestureRecognizer:addIconGes];
    
    babyNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 30+10, 40, 20)];
    babyNameLabel.text = @"宝贝";
    babyNameLabel.font = [UIFont boldSystemFontOfSize:18];
    babyNameLabel.textColor = [UIColor whiteColor];
    babyNameLabel.backgroundColor = [UIColor clearColor];
    babyNameLabel.userInteractionEnabled = YES;
    [_aView addSubview:babyNameLabel];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBaby:)];
    [babyNameLabel addGestureRecognizer:tapGes];
    
    UIImage *arrowImage = [UIImage imageNamed:@"img_diary_arrow"];
    arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(130, (100- arrowImage.size.height)/2, arrowImage.size.width, arrowImage.size.height)];
    arrowImageView.image = arrowImage;
    arrowImageView.userInteractionEnabled = YES;
    [_aView addSubview:arrowImageView];
    
    UITapGestureRecognizer *tapGes1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectBaby:)];
    [arrowImageView addGestureRecognizer:tapGes1];
    
    babyBirthLabel = [[UILabel alloc] initWithFrame:CGRectMake(85, 56.5+10, 205, 20)];
    babyBirthLabel.text = @"出生啦";
    babyBirthLabel.textColor = [UIColor whiteColor];
    babyBirthLabel.font = [UIFont boldSystemFontOfSize:16];
    babyBirthLabel.backgroundColor = [UIColor clearColor];
    [_aView addSubview:babyBirthLabel];
    
    
    [self.view addSubview:_aView];
}

//添加身高体重图片
-(void)setHeadViewTool{
    self.imgToolHeight = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 160)];
    self.imgToolHeight.image = [UIImage imageNamed:@"img_diary_height"];
    self.imgToolHeight.userInteractionEnabled = YES;
    
    self.labelHeight1 = [[UILabel alloc]initWithFrame:CGRectMake(124, 24, 20, 10)];
    self.labelHeight1.font = [UIFont systemFontOfSize:8];
    self.labelHeight1.textAlignment = NSTextAlignmentCenter;
    self.labelHeight1.textColor = [BBSColor hexStringToColor:@"4b93d3"];
    [self.imgToolHeight addSubview:self.labelHeight1];
    
    self.labelHeight2 = [[UILabel alloc]initWithFrame:CGRectMake(124, 76, 20, 10)];
    self.labelHeight2.font = [UIFont systemFontOfSize:8];
    self.labelHeight2.backgroundColor = [UIColor clearColor];
    self.labelHeight2.textColor = [BBSColor hexStringToColor:@"4b93d3"];
    self.labelHeight2.textAlignment = NSTextAlignmentCenter;
    
    [self.imgToolHeight addSubview:self.labelHeight2];
    self.labelHeight3 = [[UILabel alloc]initWithFrame:CGRectMake(124, 120, 20, 10)];
    self.labelHeight3.font = [UIFont systemFontOfSize:8];
    self.labelHeight3.backgroundColor = [UIColor clearColor];
    self.labelHeight3.text = @"";
    self.labelHeight3.textAlignment = NSTextAlignmentCenter;
    
    self.labelHeight3.textColor = [BBSColor hexStringToColor:@"4b93d3"];
    [self.imgToolHeight addSubview:self.labelHeight3];
    
    self.labelHeightPrecent = [[UILabel alloc]initWithFrame:CGRectMake(208, 71, 27, 16)];
    self.labelHeightPrecent.font = [UIFont systemFontOfSize:19];
    self.labelHeightPrecent.backgroundColor = [UIColor clearColor];
    self.labelHeightPrecent.text = @"";
    self.labelHeightPrecent.textColor = [BBSColor hexStringToColor:@"fe6c6c"];
    [self.imgToolHeight addSubview:self.labelHeightPrecent];
    
    self.labelHeightCm = [[UILabel alloc]initWithFrame:CGRectMake(275, 90, 27, 10)];
    self.labelHeightCm.font = [UIFont systemFontOfSize:10];
    self.labelHeightCm.text = @"";
    
    self.labelHeightCm.textColor = [BBSColor hexStringToColor:@"4b93d3"];
    [self.imgToolHeight addSubview:self.labelHeightCm];
    
    self.heightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.heightButton setImage:[UIImage imageNamed:@"btn_diary_heighttolls"] forState:UIControlStateNormal];
    self.heightButton.frame = CGRectMake(110,140 , 47 , 19);
    [self.imgToolHeight addSubview:self.heightButton];
    [self.heightButton addTarget:self action:@selector(selectHeigtTool) forControlEvents:UIControlEventTouchUpInside];
    
    self.weightButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [self.weightButton setImage:[UIImage imageNamed:@"btn_diary_weighttoll"] forState:UIControlStateNormal];
    
    self.weightButton.frame = CGRectMake(118+47,140 ,47 , 19);
    [self.imgToolHeight addSubview:self.weightButton];
    [self.weightButton addTarget:self action:@selector(selectWeightTool) forControlEvents:UIControlEventTouchUpInside];
    
    self.addBabyHeight= [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addBabyHeight setImage:[UIImage imageNamed:@"btn_diary_addbabyheight"] forState:UIControlStateNormal];
    self.addBabyHeight.frame = CGRectMake(SCREENWIDTH-11-115,4 ,115 , 23);
    [self.imgToolHeight addSubview:self.addBabyHeight];
    [self.addBabyHeight addTarget:self action:@selector(addBabyHeightAndWeight) forControlEvents:UIControlEventTouchUpInside];
    self.lineImg = [[UIImageView alloc]initWithFrame:CGRectZero];
    self.lineImg.image = [UIImage imageNamed:@"img_diary_line_height"];
    [self.imgToolHeight addSubview:self.lineImg];
    
    self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(190, 30, 112, 13)];
    self.alertLabel.text = @"";
    self.alertLabel.font = [UIFont systemFontOfSize:12];
    self.alertLabel.textAlignment = NSTextAlignmentRight;
    self.alertLabel.textColor = [BBSColor hexStringToColor:@"d9d9d9"];
    [self. imgToolHeight addSubview:self.alertLabel];
    
}
- (void)setTableView {
    if (_tableView) {
        [_tableView reloadData];
    }
    
    CGRect frame = CGRectMake(0, 100, SCREENWIDTH, SCREENHEIGHT-100-42);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = self.imgToolHeight;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
}
- (void)setBabyTableView {
    if (_babyTableView) {
        [_babyTableView reloadData];
        return;
    }
    
    CGRect frame = CGRectMake(70, 70, 155, 90);
    _babyTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _babyTableView.delegate = self;
    _babyTableView.dataSource = self;
    _babyTableView.tableFooterView = [[UIView alloc] init];
    _babyTableView.backgroundColor = [BBSColor hexStringToColor:@"e9605b"];
    _babyTableView.separatorInset = UIEdgeInsetsMake(0, 5, 0, 5);
    _babyTableView.separatorColor = [BBSColor hexStringToColor:@"ce403b"];
    [self.view addSubview:_babyTableView];
    [self.view bringSubviewToFront:_babyTableView];
    _babyTableView.hidden = _hideBabyList;
}
#pragma mark -切换体重和身高
-(void)selectHeigtTool{
    self.isInHeight = YES;
    self.imgToolHeight.image = [UIImage imageNamed:@"img_diary_height"];
    [self.weightButton setImage:[UIImage imageNamed:@"btn_diary_weighttoll"] forState:UIControlStateNormal];
    [self.heightButton setImage:[UIImage imageNamed:@"btn_diary_heighttolls"] forState:UIControlStateNormal];
    self.labelHeight1.text = _item.h950;
    self.labelHeight2.text = _item.h_mid;
    self.labelHeight3.text = _item.h50;
    self.labelHeightPrecent.text = _item.h_cal;
    self.labelHeightCm.text = _item.height;
    float height = [_item.h_posi floatValue]*160;
    if (height > 0) {
        self.lineImg.frame = CGRectMake(108, height, 210, 1);
    }
}
-(void)selectWeightTool{
    self.isInHeight = NO;
    self.imgToolHeight.image = [UIImage imageNamed:@"img_diary_weight"];
    [self.weightButton setImage:[UIImage imageNamed:@"btn_diary_weighttolls"] forState:UIControlStateNormal];
    [self.heightButton setImage:[UIImage imageNamed:@"btn_diary_heighttoll"] forState:UIControlStateNormal];
    self.labelHeight1.text = _item.w950;
    self.labelHeight2.text = _item.w_mid;
    self.labelHeight3.text = _item.w50;
    self.labelHeightPrecent.text = _item.w_cal;
    self.labelHeightCm.text = _item.weight;
    float height = [_item.w_posi floatValue]*160;
    if (height > 0) {
        self.lineImg.frame = CGRectMake(108, height, 210, 1);
    }
    
}
-(void)addBabyHeightAndWeight{
    NSDictionary *babyInfo = [_babyListArray objectAtIndex:_selectedBabyIndex];
    AddBabyHeightAndWeightVC *addBabyHWVC = [[AddBabyHeightAndWeightVC alloc]init];
    addBabyHWVC.babyId = [babyInfo objectForKey:@"id"];
    addBabyHWVC.loginUserId = LOGIN_USER_ID;
    addBabyHWVC.babyHeightOld = _item.height;
    addBabyHWVC.babyWeightOld = _item.weight;
    addBabyHWVC.refreshIngrowthVC = ^(){
        [self getDataHeightAndWeightData];
    };
    [self.navigationController pushViewController:addBabyHWVC animated:YES];
    
}
#pragma mark data
-(void)getDataHeightAndWeightData{
    NSDictionary *babyInfo = [_babyListArray objectAtIndex:_selectedBabyIndex];
    NSString *babyId = [babyInfo objectForKey:@"id"];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",babyId, @"baby_id",nil];
    [[HTTPClient sharedClient]getNew:kGrowthList params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = result[@"data"];
            _item = [[GrowthDiaryHeightAndWeightItem alloc]init];
            _item.h950 = data[@"h950"];
            _item.h50 = data[@"h50"];
            _item.h_mid = data[@"h_mid"];
            _item.height = data[@"height"];
            _item.h_posi = data[@"h_posi"];
            _item.h_cal = data[@"h_cal"];
            _item.weight = data[@"weight"];
            _item.w50 = data[@"w50"];
            _item.w_mid = data[@"w_mid"];
            _item.w950 = data[@"w950"];
            _item.w_posi = data[@"w_posi"];
            _item.w_cal = data[@"w_cal"];
            _item.remind_info = data[@"remind_info"];
            if (_item.remind_info.length >0) {
                self.alertLabel.text= [NSString stringWithFormat:@"%@",_item.remind_info];
                self.alertLabel.hidden = NO;
            }else{
                self.alertLabel.hidden=YES;
                
            }
            if (self.isInHeight) {
                self.labelHeight1.text = _item.h950;
                self.labelHeight2.text = _item.h_mid;
                self.labelHeight3.text = _item.h50;
                self.labelHeightPrecent.text = _item.h_cal;
                self.labelHeightCm.text = _item.height;
                float height = [_item.h_posi floatValue]*160;
                if (height > 0) {
                    self.lineImg.frame = CGRectMake(108, height, 210, 1);
                }else{
                    self.lineImg.frame = CGRectMake(0, 0, 0, 0);
                }
                
            }else {
                self.labelHeight1.text = _item.w950;
                self.labelHeight2.text = _item.w_mid;
                self.labelHeight3.text = _item.w50;
                self.labelHeightPrecent.text = _item.w_cal;
                self.labelHeightCm.text = _item.weight;
                
                float height = [_item.w_posi floatValue]*160;
                if (height > 0) {
                    self.lineImg.frame = CGRectMake(108, height, 210, 1);
                }else{
                    self.lineImg.frame = CGRectMake(0, 0, 0, 0);
                }
                
            }
        }
    } failed:^(NSError *error) {
        
    }];
    
    
}
#pragma mark - Network Methods
- (void)getBabyData {
    
    
    NSDictionary *newparam = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"user_id", nil];
    
    [[HTTPClient sharedClient] getNew:kGetBabys params:newparam success:^(NSDictionary *result) {
        
        if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
            _babyListArray = [result objectForKey:kBBSData];
            
            if (_babyListArray.count) {
                NSDictionary *firstInfo ;
                if (_selectedBabyIndex < 0) {
                    firstInfo = [_babyListArray objectAtIndex:0];
                    _selectedBabyIndex = 0;
                    if ([[firstInfo objectForKey:@"idol_type"]integerValue] == 1) {
                        UIButton *addButton = [self.view viewWithTag:9999];
                        addButton.hidden = YES;
                        UIButton *shareButton = [self.view viewWithTag:9998];
                        shareButton.hidden = YES;
                        self.addBabyHeight.hidden = YES;
                        iconImageView.userInteractionEnabled = NO;
                    }else{
                        UIButton *addButton = [self.view viewWithTag:9999];
                        addButton.hidden = NO;
                        UIButton *shareButton = [self.view viewWithTag:9998];
                        shareButton.hidden = NO;
                        self.addBabyHeight.hidden = NO;
                        iconImageView.userInteractionEnabled = YES;
                        
                    }
                    
                } else {
                    firstInfo = [_babyListArray objectAtIndex:_selectedBabyIndex];
                }
                babyNameLabel.text = [NSString stringWithFormat:@"%@",[firstInfo objectForKey:@"baby_name"]];
                babyBirthLabel.text = [NSString stringWithFormat:@"%@",[firstInfo objectForKey:@"age"]];
                [iconImageView sd_setImageWithURL:[NSURL URLWithString:[firstInfo objectForKey:@"avatar"]]];
                //获取该孩子的成长相日记信息
                _page = 1;
                _isFinished = NO;
                _isRefresh = YES;
                if (_tableView.hidden == YES) {
                    [_tableView setHidden:NO];
                }
                CGRect frame =  _babyTableView.frame;
                frame.size.height = 30 * (_babyListArray.count + 3);
                _babyTableView.frame = frame ;
                [self getData];
                [self getDataHeightAndWeightData];
                _aView.backgroundColor = [BBSColor hexStringToColor:@"fd6363" alpha:0.8];
                _aView.image = nil;
                _aView.userInteractionEnabled = YES;

                
                
                if ([self.view viewWithTag:1000]) {
                    [[self.view viewWithTag:1000] removeFromSuperview];
                }
                if ([self.view viewWithTag:1001]) {
                    [[self.view viewWithTag:1001] removeFromSuperview];
                }
                if ([self.view viewWithTag:1002]) {
                    [[self.view viewWithTag:1002] removeFromSuperview];
                }
                
            } else {
                _selectedBabyIndex = -1;
                babyNameLabel.text = @"宝贝";
                babyBirthLabel.text = @"出生啦";
                iconImageView.image = [UIImage imageNamed:@"img_message_avatar_100"];
                
                [_tableView setHidden:YES];
                [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"haveBaby"];
                
                [self addNoBabyBack];
                
            }
            if (_babyTableView) {
                [_babyTableView reloadData];
            }
            [self adjustLabelAndImageFrameWithBabyName:babyNameLabel.text];
        } else {
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
        
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"网络连接错误请重试" andDelegate:nil];
    }];
}
- (void)getData {
    if (_selectedBabyIndex < 0) {
        return;
    }
    
    NSDictionary *babyInfo = [_babyListArray objectAtIndex:_selectedBabyIndex];
    NSLog(@"self.page = %d",self.page);
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"user_id",[[babyInfo objectForKey:@"id"] stringValue],@"baby_id",[NSString stringWithFormat:@"%d",self.page],@"page", nil];
    
    UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kDiaryAlbumList Method:NetMethodGet andParam:params];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    
    __weak ASIHTTPRequest *blockRequest = request;
    
    [request setCompletionBlock:^{
        
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        
        if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
            
            NSArray *dataArray = [dic objectForKey:kBBSData];
            NSMutableArray *returnArray = [NSMutableArray array];
            for (NSDictionary *dict in dataArray) {
                
                GrowthDiaryBasicItem *basicItem = [[GrowthDiaryBasicItem alloc] init];
                
                basicItem.nodeName = [dict objectForKey:@"album_name"];
                basicItem.tag_type = [[dict objectForKey:@"tag_type"] integerValue];
                if (basicItem.tag_type == 0 || basicItem.tag_type == 4) {
                    //0普通,4带标签
                    basicItem.nodeID = [dict objectForKey:@"album_id"];
                    basicItem.nodeDescription = [dict objectForKey:@"album_description"];
                    basicItem.nodeImageCount = [[dict objectForKey:@"img_count"] integerValue];
                    basicItem.tag_name = [dict objectForKey:@"tag_name"];
                    
                    NSDictionary *imgDict = [[dict objectForKey:@"img"] firstObject];
                    basicItem.nodeThumbString = [imgDict objectForKey:@"img_thumb"];
                }
                if (basicItem.tag_type == 3) {
                    basicItem.nodeDescription = [dict objectForKey:@"album_description"];
                }
                [returnArray addObject:basicItem];
            }
            if (returnArray.count == 0) {
                _refreshControl.bottomEnabled = NO;
            }
            if (self.page == 1) {
                [_albumListArray removeAllObjects];
                _refreshControl.bottomEnabled = YES;
            }
            self.page++;
            NSLog(@"self.page+++ = %d",self.page);
            
            [_albumListArray addObjectsFromArray:returnArray];
            [_tableView reloadData];
            [self refreshComplete:_refreshControl];
        }else{
            [self refreshComplete:_refreshControl];
            [BBSAlert showAlertWithContent:[dic objectForKey:kBBSReMsg] andDelegate:self];
        }
        
    }];
    
    [request setFailedBlock:^{
        
        [self refreshComplete:_refreshControl];
    }];
    
}
#pragma mark - Actions Methods
- (void)addorChangeIcon:(UITapGestureRecognizer *)tagGes {
    
    if (_hideBabyList == NO) {
        [self hideBabyTableView];
        return;
    }
    if (_selectedBabyIndex < 0) {
        [self showAlert];
        return;
    }
    UIActionSheet  *chooseAcs = [[UIActionSheet alloc] initWithTitle:nil
                                                            delegate:self
                                                   cancelButtonTitle:@"取消"
                                              destructiveButtonTitle:nil
                                                   otherButtonTitles:@"从手机相册",@"拍摄一张", nil];
    chooseAcs.tag = BabyIconTag;
    actionSheetType = ActionSheetTypeBabyIcon;
    [chooseAcs showInView:[UIApplication sharedApplication].keyWindow];
    
}
- (void)selectBaby:(UITapGestureRecognizer *)sender {
    if (_selectedBabyIndex < 0) {
        [self showAlert];
        return;
    }
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    arrowImageView.transform = CGAffineTransformRotate(arrowImageView.transform, M_PI);
    [UIView commitAnimations];
    
    _hideBabyList = !_hideBabyList;
    
    _babyTableView.hidden = _hideBabyList;
}
- (void)oneKeyShare:(UIButton *)button {
    
    if (_selectedBabyIndex < 0) {
        [self showAlert];
        return;
    }
    
    NSDictionary *rowDict = [_babyListArray objectAtIndex:_selectedBabyIndex];
    NSString *babyID = [rowDict objectForKey:@"id"];
    NSString *avatar = [rowDict objectForKey:@"avatar"];
    NSString *babyName = [rowDict objectForKey:@"baby_name"];
    NSString *age = [rowDict objectForKey:@"age"];
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray;
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",avatar]];
    UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    NSData *basicImgData = UIImagePNGRepresentation(shareImg);
    if (basicImgData.length/1024>150) {
        shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
    }

    imageArray = @[shareImg];
    NSString *titleName = [NSString stringWithFormat:@"%@成长记录",babyName];
    NSString *urlString = [NSString stringWithFormat:@"%@user_id=%@&baby_id=%@",DiaryShareUrl,LOGIN_USER_ID,babyID];
    NSString *content = [NSString stringWithFormat:@"%@现在%@了，自由环球租赁记录了%@的成长轨迹",babyName,age,babyName];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]
                                      title:titleName
                                       type:SSDKContentTypeAuto];
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",content,[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:titleName image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
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
                
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
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
//复制成长记录的链接
- (void)copyURL:(NSString *)string {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:string];
}
//添加成长记录的方法
- (void)oneKeyImport:(UIButton *)button {
    
    [self hideBabyTableView];
    
    if (_selectedBabyIndex < 0) {
        [self showAlert];
        return;
    }
    FDActionSheet *sheet = [[FDActionSheet alloc]initWithTitle:@"高清无损上传，请使用WiFi或3G" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"从手机相册",@"拍摄一张", nil];
    sheet.tag = ImportTag;
    [sheet show];
    actionSheetType = ActionSheetTypeImport;
    
}


- (void)addAnotherBaby:(UIButton *)button {
    
    [self hideBabyTableView];
    
    //添加宝贝
    RegisterStep2ViewController *addKidVC=[[RegisterStep2ViewController alloc]init];
    addKidVC.Type=1;
    addKidVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:addKidVC animated:YES];
    
}
#pragma mark - private Methods
//没有孩子的时候的提醒
- (void)showAlert {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您还没有建立孩子信息哦,立马创建一个吧!" delegate:self cancelButtonTitle:@"稍后" otherButtonTitles:@"立马生一个", nil];
    alertView.tag = 10;
    [alertView show];
}
- (void)hideBabyTableView {
    if (_hideBabyList == NO) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        arrowImageView.transform = CGAffineTransformRotate(arrowImageView.transform, M_PI);
        [UIView commitAnimations];
        _hideBabyList = YES;
        _babyTableView.hidden = _hideBabyList;
    }
    
}
- (void)adjustLabelAndImageFrameWithBabyName:(NSString *)babyName {
    
    CGSize size = [babyName sizeWithAttributes:@{NSFontAttributeName:babyNameLabel.font}];
    
    CGRect nameFrame = babyNameLabel.frame;
    
    nameFrame.size.width = size.width;
    babyNameLabel.frame = nameFrame;
    
    CGRect imageFrame = arrowImageView.frame;
    imageFrame.origin.x = size.width + nameFrame.origin.x + 3;
    arrowImageView.frame = imageFrame;
    
}
- (void)uploadWithImageArray:(NSArray *)imgArr dateDict:(NSDictionary *)dateDict {
    
    NSDictionary *dict = [_babyListArray objectAtIndex:_selectedBabyIndex];
    NSString *baby_id = [dict objectForKey:@"id"];
    // NSString *dateJsonString = [dateDict JSONString];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dateDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *dateJsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:imgArr,@"photos",baby_id,@"baby_id",LOGIN_USER_ID,@"user_id",dateJsonString,@"imgs",[NSString stringWithFormat:@"%ld",(long)imgArr.count],@"file_count", nil];
    
    [[NetAccess sharedNetAccess] getDataWithStyle:NetStyleImportToDiary andParam:params];
    
    [LoadingView startOnTheViewController:self];
}
#pragma mark - UIAlertViewDelegat Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 10) {
        if (buttonIndex == 1) {
            //添加宝贝
            RegisterStep2ViewController *addKidVC=[[RegisterStep2ViewController alloc]init];
            addKidVC.Type=1;
            addKidVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:addKidVC animated:YES];
            
        } else {
            //稍后创建
        }
    }
}
#pragma mark - UIActionSheetDelegate Methods
-(void)actionSheet:(FDActionSheet *)sheet clickedButtonIndex:(NSInteger)buttonIndex
{
    if (sheet.tag == ImportTag) {
        if (buttonIndex == 0) {
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            elcPicker.maximumImagesCount = maxNumberOfImages;
            elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
            elcPicker.imagePickerDelegate = self;
            [self presentViewController:elcPicker animated:YES completion:nil];
            
        }else if (buttonIndex == 1){
            //拍摄
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
                
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate=self;
                imagePicker.allowsEditing=YES;
                imagePicker.videoQuality=UIImagePickerControllerQualityType640x480;
                [self presentViewController:imagePicker animated:YES completion:^{}];
                
            }else{
                
                [BBSAlert showAlertWithContent:@"相机设备不可用，请到 设置->隐私->相机选项卡 打开自由环球租赁的开关" andDelegate:self];
                
            }
        } else {
            [sheet  hide];
            
        }
    } else if (sheet.tag == BabyIconTag) {
        if (buttonIndex == 0) {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] ){
                
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate=self;
                imagePicker.allowsEditing=YES;
                [self presentViewController:imagePicker animated:YES completion:^{}];
                
            }else{
                
                [BBSAlert showAlertWithContent:@"照片不可用，请到 设置->隐私->照片选项卡 打开自由环球租赁的开关" andDelegate:self];
                
            }
            
        }else if (buttonIndex == 1){
            //拍摄
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
                
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate=self;
                imagePicker.allowsEditing=YES;
                imagePicker.videoQuality=UIImagePickerControllerQualityType640x480;
                [self presentViewController:imagePicker animated:YES completion:^{}];
                
            }else{
                
                [BBSAlert showAlertWithContent:@"相机设备不可用，请到手机 设置->隐私->相机选项卡 打开自由环球租赁的开关" andDelegate:self];
                
            }
        } else {
            [sheet hide];
            
        }
    }
    
    
    
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (actionSheet.tag == ImportTag) {
        if (buttonIndex == 0) {
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            elcPicker.maximumImagesCount = maxNumberOfImages;
            elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
            elcPicker.imagePickerDelegate = self;
            [self presentViewController:elcPicker animated:YES completion:nil];
            
        }else if (buttonIndex == 1){
            //拍摄
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
                
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate=self;
                imagePicker.allowsEditing=YES;
                imagePicker.videoQuality=UIImagePickerControllerQualityType640x480;
                [self presentViewController:imagePicker animated:YES completion:^{}];
                
            }else{
                
                [BBSAlert showAlertWithContent:@"相机设备不可用，请到 设置->隐私->相机选项卡 打开自由环球租赁的开关" andDelegate:self];
                
            }
        } else {
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            
        }
    } else if (actionSheet.tag == BabyIconTag) {
        if (buttonIndex == 0) {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] ){
                
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.delegate=self;
                imagePicker.allowsEditing=YES;
                [self presentViewController:imagePicker animated:YES completion:^{}];
                
            }else{
                
                [BBSAlert showAlertWithContent:@"照片不可用，请到 设置->隐私->照片选项卡 打开自由环球租赁的开关" andDelegate:self];
                
            }
            
        }else if (buttonIndex == 1){
            //拍摄
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
                
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate=self;
                imagePicker.allowsEditing=YES;
                imagePicker.videoQuality=UIImagePickerControllerQualityType640x480;
                [self presentViewController:imagePicker animated:YES completion:^{}];
                
            }else{
                
                [BBSAlert showAlertWithContent:@"相机设备不可用，请到手机 设置->隐私->相机选项卡 打开自由环球租赁的开关" andDelegate:self];
                
            }
        } else {
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            
        }
    }
    
}
#pragma mark - ImagePickerDelegate Methods
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    
    if (info.count <= 0) {
        [BBSAlert showAlertWithContent:@"请至少选择一张图片" andDelegate:nil];
        return;
    }
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *dateDict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < info.count; i++) {
        NSDictionary *singleInfo = info[i];
        CLLocation *location = [singleInfo objectForKey:ALAssetPropertyLocation];
        CLLocationCoordinate2D coordinate = location.coordinate;
        //        NSLog(@"%f,%f",coordinate.latitude,coordinate.longitude);
        NSDate *dateTime = [singleInfo objectForKey:ALAssetPropertyDate];
        UIImage *image = [singleInfo objectForKey:UIImagePickerControllerOriginalImage];
        [imageArray addObject:image];
        NSString *dateString = [DateFormatter dateStringFromDate:dateTime formatter:@"yyyy-MM-dd HH:mm:ss"];
        
        NSString *lat = @"";
        if (coordinate.latitude > 0) {
            lat = [NSString stringWithFormat:@"%f",coordinate.latitude];
        }
        NSString *lng = @"";
        if (coordinate.longitude > 0) {
            lng = [NSString stringWithFormat:@"%f",coordinate.longitude];
        }
        
        NSDictionary *imgsInfo = [NSDictionary dictionaryWithObjectsAndKeys:dateString,@"times",lat,@"lat",lng,@"lng", nil];
        
        [dateDict setObject:imgsInfo forKey:[NSString stringWithFormat:@"img%d",i+1]];
    }
    //    NSLog(@"%@",[dateDict JSONString]);
    //    return;
    [self uploadWithImageArray:imageArray dateDict:dateDict];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (actionSheetType == ActionSheetTypeImport) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        
        NSDictionary *dict = [info objectForKey:UIImagePickerControllerMediaMetadata];
        NSDictionary *tiffDict = [dict objectForKey:@"{TIFF}"];
        NSString *dateTime = [tiffDict objectForKey:@"DateTime"];
        
        dateTime = [dateTime stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"-"];
        dateTime = [dateTime stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:@"-"];
        NSArray *imageArray = [[NSArray alloc]initWithObjects:image, nil];
        NSDictionary *imgsInfo = [NSDictionary dictionaryWithObjectsAndKeys:dateTime,@"times",self.latitude,@"lat",self.longitude,@"lng", nil];
        
        NSDictionary *dateDict = [NSDictionary dictionaryWithObjectsAndKeys:imgsInfo,@"img1", nil];
        
        [self uploadWithImageArray:imageArray dateDict:dateDict];
    } else {
        
        [LoadingView startOnTheViewController:self];
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        iconImageView.image = image;
        NSDictionary *dict = [_babyListArray objectAtIndex:_selectedBabyIndex];
        NSString *baby_id = [dict objectForKey:@"id"];
        
        NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:
                             LOGIN_USER_ID,@"user_id",
                             image,@"avatar",
                             baby_id,@"baby_id",nil];
        [[NetAccess sharedNetAccess] getDataWithStyle:NetStyleAddBabyAvatar andParam:param];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - UITableViewDataSource Methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_babyTableView]) {
        return 30;
    }
    GrowthDiaryBasicItem *item = [_albumListArray objectAtIndex:indexPath.row];
    if (item.tag_type ==0 || item.tag_type == 4) {
        return 92;
    } else {
        if (item.tag_type == 1) {
            //xx岁啦
            return 35;
        } else if (item.tag_type == 2) {
            //xx岁6个月,包含空隙
            return 40;
        } else {
            //出生啦
            return 64;
            
        }
        
    }
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([tableView isEqual:_babyTableView]) {
        return _babyListArray.count + 3 ;
    }
    return _albumListArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([tableView isEqual:_babyTableView]) {
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [BBSColor hexStringToColor:@"e9605b"];
            
        }
        
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        
        UILabel *nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 155, 30)];
        nicknameLabel.backgroundColor = [UIColor clearColor];
        nicknameLabel.textAlignment = NSTextAlignmentCenter;
        nicknameLabel.textColor = [UIColor whiteColor];
        nicknameLabel.font = [UIFont systemFontOfSize:15];
        [cell.contentView addSubview:nicknameLabel];
        
        if (indexPath.row == _babyListArray.count) {
            
            nicknameLabel.text = @"添加宝宝";
            
        } else if (indexPath.row == _babyListArray.count +1){
            
            nicknameLabel.text = @"和另外一成长记录同步";
            
        }else if (indexPath.row == _babyListArray.count +2){
            
            nicknameLabel.text = @"添加关注";
            
        } else {
            
            NSDictionary *rowDict = [_babyListArray objectAtIndex:indexPath.row];
            nicknameLabel.text = [NSString stringWithFormat:@"%@",[rowDict objectForKey:@"baby_name"]];
        }
        return cell;
    }
    
    static NSString *bigIdentifier = @"BigNode";//0,4
    static NSString *yearsIdentifier = @"yearsIdentifier";//1
    static NSString *yearsHalfIdentifier = @"yearsHalfIdentifier";//2
    static NSString *bornIdentifier = @"bornIdentifier";//3
    
    UITableViewCell *cell;
    GrowthDiaryBasicItem *item = [_albumListArray objectAtIndex:indexPath.row];
    if (item.tag_type == 0 || item.tag_type == 4) {
        
        DiaryBigNodeCell *bcell = (DiaryBigNodeCell *)[tableView dequeueReusableCellWithIdentifier:bigIdentifier];
        if (bcell == nil) {
            bcell = [[DiaryBigNodeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bigIdentifier];
        }
        bcell.nodeNameLabel.text = item.nodeName;
        [bcell.coverImageView sd_setImageWithURL:[NSURL URLWithString:item.nodeThumbString]];
        bcell.titleLabel.text = item.nodeDescription;
        bcell.countLabel.text = [NSString stringWithFormat:@"%ld张",(long)item.nodeImageCount];
        UIImage *image = nil;
        if (item.tag_type == 0) {
            //小节点
            image = [UIImage imageNamed:@"img_diary_small_node"];
            bcell.tagLabel.hidden = YES;
        } else {
            //大节点
            image = [UIImage imageNamed:@"img_diary_big_node"];
            bcell.tagLabel.hidden = NO;
            bcell.tagLabel.text = [NSString stringWithFormat:@"  %@  ",item.tag_name];
            CGSize size = [bcell.tagLabel.text boundingRectWithSize:CGSizeMake(SCREENWIDTH, 15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:bcell.tagLabel.font} context:nil].size;
            CGRect frame = bcell.tagLabel.frame;
            frame.size.width = size.width;
            bcell.tagLabel.frame = frame;
            
        }
        bcell.nodeImageView.image = image;
        
        cell = bcell;
    } else if (item.tag_type == 1) {
        DiaryYearsCell *yearsCell = (DiaryYearsCell *)[tableView dequeueReusableCellWithIdentifier:yearsIdentifier];
        if (yearsCell == nil) {
            yearsCell = [[DiaryYearsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yearsIdentifier];
        }
        yearsCell.yearsLabel.text = [NSString stringWithFormat:@" %@ ",item.nodeName];
        CGSize size = [yearsCell.yearsLabel.text boundingRectWithSize:CGSizeMake(SCREENWIDTH, 35) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:yearsCell.yearsLabel.font} context:nil].size;
        yearsCell.yearsLabel.frame = CGRectMake( (SCREENWIDTH - 25 - size.width)/2 + 12.5, (35-size.height)/2, size.width + 20, size.height);
        [yearsCell.yearsLabel insertImage:[UIImage imageNamed:@"img_diary_star"] atIndex:0 margins:UIEdgeInsetsMake((size.height - 9)/2, 0, (size.height - 9)/2, 0)];
        [yearsCell.yearsLabel insertImage:[UIImage imageNamed:@"img_diary_star"] atIndex:yearsCell.yearsLabel.text.length margins:UIEdgeInsetsMake((size.height - 9)/2, 0, (size.height - 9)/2, 0)];
        cell = yearsCell;
    } else if (item.tag_type == 2) {
        DiaryYearHalfCell *yearsHalfCell = (DiaryYearHalfCell *)[tableView dequeueReusableCellWithIdentifier:yearsHalfIdentifier];
        if (yearsHalfCell == nil) {
            yearsHalfCell = [[DiaryYearHalfCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:yearsHalfIdentifier];
        }
        yearsHalfCell.yearsHalfLabel.text = item.nodeName;
        CGSize size = [item.nodeName boundingRectWithSize:CGSizeMake(SCREENWIDTH, 40) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:yearsHalfCell.yearsHalfLabel.font} context:nil].size;
        yearsHalfCell.yearsHalfLabel.frame = CGRectMake((SCREENWIDTH - 25 - size.width)/2 + 23, (40-size.height)/2, size.width, size.height);
        cell = yearsHalfCell;
    } else {
        DiaryBornCell *bornCell = (DiaryBornCell *)[tableView dequeueReusableCellWithIdentifier:bornIdentifier];
        if (bornCell == nil) {
            bornCell = [[DiaryBornCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:bornIdentifier];
        }
        bornCell.bornLabel.text = item.nodeName;
        bornCell.birthLabel.text = item.nodeDescription;
        cell = bornCell;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:_babyTableView]) {
        
        if (indexPath.row == _babyListArray.count) {
            
            [self addAnotherBaby:nil];
            
        } else if (indexPath.row == _babyListArray.count +1){
            
            NSDictionary *babyInfo = [_babyListArray objectAtIndex:_selectedBabyIndex];
            
            //to CombineShareviewcontroller
            CombineShareViewController *viewController = [[CombineShareViewController alloc] init];
            viewController.baby_id = [babyInfo objectForKey:@"id"];
            viewController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:viewController animated:YES];
            
        }else if (indexPath.row == _babyListArray.count +2){
            
            AddFouceGrowthDiaryVC *addFouceGrowthDiaryVC = [[AddFouceGrowthDiaryVC alloc]init];
            addFouceGrowthDiaryVC.loginUserid = LOGIN_USER_ID;
            
            [self.navigationController pushViewController:addFouceGrowthDiaryVC animated:YES];
            
            
        }else {
            [self hideBabyTableView];
            
            if (_selectedBabyIndex != indexPath.row) {
                NSDictionary *rowDict = [_babyListArray objectAtIndex:indexPath.row];
                
                
                babyNameLabel.text = [NSString stringWithFormat:@"%@",[rowDict objectForKey:@"baby_name"]];
                babyBirthLabel.text = [NSString stringWithFormat:@"%@",[rowDict objectForKey:@"age"]];
                [iconImageView sd_setImageWithURL:[NSURL URLWithString:[rowDict objectForKey:@"avatar"]]];
                _selectedBabyIndex = indexPath.row;
                if ([[rowDict objectForKey:@"idol_type"]boolValue] == YES) {//孩子是自己的还是同步其他人的，如果是自己的功能都在，否则隐藏
                    UIButton *addButton = [self.view viewWithTag:9999];
                    addButton.hidden = YES;
                    UIButton *shareButton = [self.view viewWithTag:9998];
                    shareButton.hidden = YES;
                    self.addBabyHeight.hidden = YES;
                    iconImageView.userInteractionEnabled = NO;
                }else{
                    UIButton *addButton = [self.view viewWithTag:9999];
                    addButton.hidden = NO;
                    UIButton *shareButton = [self.view viewWithTag:9998];
                    shareButton.hidden = NO;
                    self.addBabyHeight.hidden = NO;
                    iconImageView.userInteractionEnabled = YES;
                    
                    
                }
                [self adjustLabelAndImageFrameWithBabyName:babyNameLabel.text];
                _page = 1;
                _isFinished =NO;
                _isRefresh = YES;
                
                [self getDataHeightAndWeightData];
                [self getData];
            }
        }
    } else if ([tableView isEqual:_tableView]) {
        GrowthDiaryBasicItem *item = [_albumListArray objectAtIndex:indexPath.row];
        if (item.tag_type == 0 || item.tag_type == 4) {
            _selectedIndex = indexPath.row;
            NSDictionary *babyInfo = [_babyListArray objectAtIndex:_selectedBabyIndex];
            if ([[babyInfo objectForKey:@"idol_type"]boolValue] == YES) {//孩子是自己的去成长记录详情页面，不是自己的去同步页面
                SynchroVC *synchroVC = [[SynchroVC alloc]init];
                synchroVC.babyID = [babyInfo objectForKey:@"id"];
                synchroVC.nodeID = item.nodeID;
                synchroVC.nodeName = item.nodeName;
                synchroVC.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:synchroVC animated:YES];
            }else{
                GrowthDetailViewController *viewController = [[GrowthDetailViewController alloc] init];
                viewController.babyID = [babyInfo objectForKey:@"id"];
                viewController.nodeID = item.nodeID;
                viewController.nodeName = item.nodeName;
                viewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:viewController animated:YES];
                
            }
            
            
        }
        
    }
}
#pragma mark - CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *location in locations) {
        self.latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
        self.longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    self.latitude = @"";
    self.longitude = @"";
}
#pragma mark - Notification Methods
- (void)importSucceed:(NSNotification *)noti {
    
    [LoadingView stopOnTheViewController:self];
    self.page = 1;
    _isFinished = NO;
    _isRefresh = YES;
    NSLog(@"上传成功的方法里面走了一遍");
    [self getData];
    
}
- (void)importFailed:(NSNotification *)noti {
    [LoadingView stopOnTheViewController:self];
    NSString *message = noti.object;
    [BBSAlert showAlertWithContent:message andDelegate:nil];
}
- (void)addBabyAvatarSucceed:(NSNotification *)noti {
    [LoadingView stopOnTheViewController:self];
    [self getBabyData];
    
}
- (void)addBabyAvatarFailed:(NSNotification *)noti {
    [LoadingView stopOnTheViewController:self];
    
    iconImageView.image = [UIImage imageNamed:@"img_message_avatar_100"];
    NSString *message = noti.object;
    [BBSAlert showAlertWithContent:message andDelegate:nil];
    
}

- (void)netFailed {
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:nil];
}

@end
