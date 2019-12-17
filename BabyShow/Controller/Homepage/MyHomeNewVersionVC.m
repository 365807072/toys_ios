//
//  MyHomeNewVersionVC.m
//  BabyShow
//
//  Created by WMY on 15/11/13.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyHomeNewVersionVC.h"
#import "RegisterStep2ViewController.h"
#import "TA_AlbumListViewController.h"
#import "AlbumListViewController.h"
#import "MyOutPutViewController.h"
#import "MyFansListViewController.h"
#import "PhotoShareViewController.h"
#import "PostBarNewVC.h"
#import "ImageDetailViewController.h"
//#import "PostBarNewDetailVC.h"
#import "WebViewController.h"
#import "BBSNavigationController.h"
#import "ReportViewController.h"
#import "ClickViewController.h"

#import "MyOutPutBasicItem.h"
#import "UserInfoItem.h"
#import "MyOutPutTitleItem.h"
#import "MyOutPutTitleItemNotToday.h"
#import "MyOutPutDescribeItem.h"
#import "MyOutPutUrlItem.h"
#import "MyOutPutImgGroupItem.h"
#import "MyOutPutPraiseAndReviewItem.h"

#import "MyHomePageCell.h"
#import "MessageCell.h"
#import "MessageListRequestCell.h"
#import "MyOutPutTitleTodayCell.h"
#import "MyOutPutTitleNotTodayCell.h"
#import "MyOutPutDescribeCell.h"
#import "MyOutPutUrlCell.h"
#import "MyOutPutGroupImgCell.h"
#import "MyOutPutSingleImgCell.h"
#import "MyOutPutPraiseAndReviewCell.h"

#import "MWPhotoBrowser.h"
#import "SVPullToRefresh.h"
#import "SDWebImageManager.h"
#import "BBSEmojiInfo.h"
#import "MyOrdersViewController.h"
#import "StoreOrdersViewController.h"
#import "UIImageView+WebCache.h"
#import "MyMessageListVC.h"
#import "MyFriendMessListVC.h"
#import "RedBagListVC.h"
#import "ChangePhoneNumberVC.h"
#import "DairyFouceListVC.h"
#import "ChangePhoneNumber2VC.h"
#import "EnterCooperateVC.h"
#import "LoginHTMLVC.h"
#import "BBSCommonNavigationController.h"
#import "PostBarListNewVC.h"
#import "GetCashVC.h"
#import "ToyLeaseNewVC.h"


@interface MyHomeNewVersionVC ()
//添加关注/取消关注,区分header的按钮还是row里面的按钮
@property (nonatomic ,assign) BOOL focusHeader;
@property(nonatomic,strong)UIScrollView *backView;
@property(nonatomic,strong)UIView *avatarBackView;
@property(nonatomic,strong)UIImageView *avatarImgView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *userIdLabel;
@property(nonatomic,strong)UIView *childrenView;
@property(nonatomic,strong)UIView *myOrderView;
@property(nonatomic,strong)UIView *myPhoneNumberView;
@property(nonatomic,strong)UIView *myPhotoView;
@property(nonatomic,strong)UIView *myMessageView;
@property(nonatomic,strong)UIView *myfriendView;
@property(nonatomic,strong)UIView *myHomeSetView;
@property(nonatomic,strong)UIView *myEnterAppView;
@property(nonatomic,strong)UIImageView *photoImg;
@property(nonatomic,strong)UILabel *messCount;
@property(nonatomic,strong)UILabel *messFriend;
@property(nonatomic,strong)UILabel *messGrowthCount;
@property(nonatomic,strong)ClickImage *levelImageView;
@property(nonatomic,assign)BOOL isHavePhoneNumber;
@property(nonatomic,strong)UILabel *myPhoneLabel;
@property(nonatomic,strong)UILabel *phoneNumberLabel;
@property(nonatomic,strong)UIImageView *arrowImg;
@property(nonatomic,strong)NSString *phoneNumber;
@property(nonatomic,strong)UIView *moneyView;
@property(nonatomic,strong)UIView *otherView;
@end

@implementation MyHomeNewVersionVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _dataArray=[[NSMutableArray alloc]init];
        _PhotoArray=[[NSMutableArray alloc]init];
        
        self.messDic=[[NSDictionary alloc]init];
        self.userid=[[NSString alloc]init];
        self.message=[[NSString alloc]init];
        facesArray = [[NSArray alloc]initWithArray:[Emoji allEmoji]];
        facesDictionary = [[NSDictionary alloc]initWithDictionary:[Emoji allEmojiDictionary]];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusSucceed) name:USER_FOCUS_ON_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusFail:) name:USER_FOCUS_ON_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFocusSucceed) name:USER_CANCEL_FOCUS_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFocusFail:) name:USER_CANCEL_FOCUS_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginNewLayOut) name:USER_LOGIN_HTML_SUCCEED object:nil];
    
    if (self.Type == 0 || self.Type == 1) {
        self.tabBarController.tabBar.hidden = YES;
    }else{
        self.tabBarController.tabBar.hidden = NO;
    }
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    [self getDataUser];


}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (self.Type==0 || self.Type==3) {
        self.navigationItem.title=@"个人中心";
                //设置rightItem
                UIButton *rightBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame=CGRectMake(294, 9, 27, 27);
        [rightBtn setBackgroundImage:[UIImage imageNamed:@"btn_myhomepage_setting.png"] forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(setting) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (self.Type==0) {
            CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
            UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
            [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
            [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
            _backBtn.frame=backBtnFrame;
            UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
            self.navigationItem.leftBarButtonItem=left;
            
        }else if (self.Type==3){
            
            [self.navigationItem setHidesBackButton:YES];
            
        }
        
    }else{
        
        CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
        UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.frame=backBtnFrame;
        UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
        self.navigationItem.leftBarButtonItem=left;
        self.navigationItem.title=@"Ta的主页";
        
    }
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    CGRect frame = CGRectMake(0, 64, SCREENWIDTH , SCREENHEIGHT - 64- 49);
    if (self.Type != 3) {
        frame.size.height += 49;
    }

    [self setHeaderView];
    [self setInfoButtons];
        
    // Do any additional setup after loading the view.
}
-(void)loginNewLayOut{
    [self.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    [self setHeaderView];
    [self setInfoButtons];

}
#pragma mark UI
-(void)setHeaderView{
    self.backView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT+150)];
    [self.view addSubview:_backView];
    _backView.contentSize = CGSizeMake(0,1000);
    _backView.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
    
    _avatarBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 100)];
    _avatarBackView.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:_avatarBackView];
    
    //头像
    self.avatarImgView=[[UIImageView alloc]initWithFrame:CGRectMake(10, 21, 66, 66)];
    self.avatarImgView.layer.masksToBounds = YES;
    self.avatarImgView.layer.cornerRadius = 33;
    [_avatarBackView addSubview:self.avatarImgView];
    
    //名字
        self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(96, 10, 206, 20)];
    self.nameLabel.text=@"";
    self.nameLabel.font= [UIFont fontWithName:@"Helvetica-Bold" size:16];
    self.nameLabel.textColor=[BBSColor hexStringToColor:@"3e3e3e"];
    self.nameLabel.backgroundColor=[UIColor clearColor];
    [_avatarBackView addSubview:self.nameLabel];
    
    
    
    //等级
    _levelImageView = [[ClickImage alloc]initWithFrame:CGRectZero];
    _levelImageView.backgroundColor = [UIColor clearColor];
    _levelImageView.image = nil;
    _levelImageView.canClick = YES;
    [_avatarBackView addSubview:_levelImageView];
    
    _childrenView = [[UIView alloc]initWithFrame:CGRectMake(96, 35, 206, 10)];
    [_avatarBackView addSubview:_childrenView];
    
    //我还有一个宝宝
    self.addKidBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.addKidBtn.frame=CGRectMake(96, 45+10, 103, 23);
    if (self.Type==1) {
        [self.addKidBtn setBackgroundImage:[UIImage imageNamed:@"btn_myhomepage_puton_focus.png"] forState:UIControlStateNormal];
    }else{
    [self.addKidBtn setBackgroundImage:[UIImage imageNamed:@"btn_myhomepage_addababy"] forState:UIControlStateNormal];
        self.userIdLabel = [[UILabel alloc]initWithFrame:CGRectMake(96,33, 90, 15)];
        self.userIdLabel.font = [UIFont systemFontOfSize:13];
        self.userIdLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        [_avatarBackView addSubview:self.userIdLabel];

    }
    [_avatarBackView addSubview:self.addKidBtn];

    
}
-(void)setInfoButtons{
    
    if (self.Type == 1) {
        _myOrderView = [[UIView alloc]initWithFrame:CGRectMake(0,100, SCREENWIDTH, 0)];
        _myOrderView.backgroundColor = [UIColor whiteColor];
        [_backView addSubview:_myOrderView];
        _myPhotoView = [[UIView alloc]initWithFrame:CGRectMake(0,_myOrderView.frame.origin.y+_myOrderView.frame.size.height+10, SCREENWIDTH, 43*3)];
        _myPhotoView.backgroundColor = [UIColor whiteColor];
        [_backView addSubview:_myPhotoView];
        
        _photoImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 17.4, 17.4)];
        _photoImg.image = [UIImage imageNamed:@"img_myhome_photo"];
        [_myPhotoView addSubview:_photoImg];
        
        UIImageView *fabuImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13+43, 17.4, 17.4)];
        fabuImg.image = [UIImage imageNamed:@"img_myhome_myfabu"];
        [_myPhotoView addSubview:fabuImg];
        
        UIImageView *shoucangImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13+43+43, 17.4, 17.4)];
        shoucangImg.image = [UIImage imageNamed:@"img_myhome_shoucanggray"];
        [_myPhotoView addSubview:shoucangImg];
        
        
        UILabel *photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12, 80, 20)];
        photoLabel.text = @"相册";
        photoLabel.font = [UIFont systemFontOfSize:14];
        [_myPhotoView addSubview:photoLabel];
        
        UILabel *fabuLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12+43, 80, 20)];
        fabuLabel.text = @"Ta发布的";
        fabuLabel.font = [UIFont systemFontOfSize:14];
        [_myPhotoView addSubview:fabuLabel];
        
        
        UILabel *shoucangLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12+43+43, 80, 20)];
        shoucangLabel.text = @"收藏";
        shoucangLabel.font = [UIFont systemFontOfSize:14];
        [_myPhotoView addSubview:shoucangLabel];
        
        UIButton *albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        albumBtn.frame = CGRectMake(10,5 ,SCREENWIDTH-20,30);
        albumBtn.tag = 2001;
        [albumBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myPhotoView addSubview:albumBtn];
        
        UIButton *fabuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fabuBtn.frame = CGRectMake(10,5+43 ,SCREENWIDTH-20,30);
        fabuBtn.tag = 2002;
        [fabuBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myPhotoView addSubview:fabuBtn];
        
        UIButton *shoucangBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        shoucangBtn.frame = CGRectMake(10,5+43+43 ,SCREENWIDTH-20,30);
        shoucangBtn.tag = 2005;
        [shoucangBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myPhotoView addSubview:shoucangBtn];
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(40, 42, SCREENWIDTH-40, 1)];
        lineView1.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
        [_myPhotoView addSubview:lineView1];
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(40, 42+43, SCREENWIDTH-40, 1)];
        lineView2.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
        [_myPhotoView addSubview:lineView2];
        
        //消息
        _myMessageView = [[UIView alloc]initWithFrame:CGRectMake(0,_myPhotoView.frame.origin.y+_myPhotoView.frame.size.height+10, SCREENWIDTH, 43*2)];
        _myMessageView.backgroundColor = [UIColor whiteColor];
        [_backView addSubview:_myMessageView];
        UIImageView *messageImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 17.4, 17.4)];
        messageImg.image = [UIImage imageNamed:@"img_myhome_messagegray"];
        [_myMessageView addSubview:messageImg];
        
        UIImageView *friendImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13+43, 17.4, 17.4)];
        friendImg.image = [UIImage imageNamed:@"img_myhome_frienddongtaigray"];
        [_myMessageView addSubview:friendImg];
        
        
        UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12, 80, 20)];
        messageLabel.text = @"消息";
        messageLabel.font = [UIFont systemFontOfSize:14];
        [_myMessageView addSubview:messageLabel];
        
        UILabel *friendLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12+43, 80, 20)];
        friendLabel.text = @"好友动态";
        friendLabel.font = [UIFont systemFontOfSize:14];
        [_myMessageView addSubview:friendLabel];
        
        UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(40, 42, SCREENWIDTH-40, 1)];
        lineView3.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
        [_myMessageView addSubview:lineView3];
        
        
        UIButton *megBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        megBtn.frame = CGRectMake(10,5 ,SCREENWIDTH-20,30);
        //megBtn.tag = 2007;
        [megBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myMessageView addSubview:megBtn];
        
        UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        friendBtn.frame = CGRectMake(10,5+43 ,SCREENWIDTH-20,30);
        //friendBtn.tag = 2008;
        [friendBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myMessageView addSubview:friendBtn];
        
        //好友
        _myfriendView = [[UIView alloc]initWithFrame:CGRectMake(0,_myMessageView.frame.origin.y+_myMessageView.frame.size.height+10, SCREENWIDTH, 43*2)];
        _myfriendView.backgroundColor = [UIColor whiteColor];
        [_backView addSubview:_myfriendView];
        
        UIImageView *goodFriendImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 17.4, 17.4)];
        goodFriendImg.image = [UIImage imageNamed:@"img_myhome_friend"];
        [_myfriendView addSubview:goodFriendImg];
        
        UIImageView *shareImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13+43, 17.4, 17.4)];
        shareImg.image = [UIImage imageNamed:@"img_myhome_sharegray"];
        [_myfriendView addSubview:shareImg];
        UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(40, 42, SCREENWIDTH-40, 1)];
        lineView4.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
        [_myfriendView addSubview:lineView4];
        
        UILabel *goodFriendLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12, 80, 20)];
        goodFriendLabel.text = @"好友";
        goodFriendLabel.font = [UIFont systemFontOfSize:14];
        [_myfriendView addSubview:goodFriendLabel];
        
        UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12+43, 80, 20)];
        shareLabel.text = @"共享人";
        shareLabel.font = [UIFont systemFontOfSize:14];
        [_myfriendView addSubview:shareLabel];
        
        UIButton *goodFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        goodFriendBtn.frame = CGRectMake(10,5 ,SCREENWIDTH-20,30);
        goodFriendBtn.tag = 2003;
        [goodFriendBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myfriendView addSubview:goodFriendBtn];
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake(10,5+43 ,SCREENWIDTH-20,30);
        shareBtn.tag = 2004;
        [shareBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myfriendView addSubview:shareBtn];
        

    }else {
        _myOrderView = [[UIView alloc]initWithFrame:CGRectMake(0,100+10, SCREENWIDTH, 43*4)];
        _myOrderView.backgroundColor = [UIColor whiteColor];
        [_backView addSubview:_myOrderView];
        //我的账户余额
        self.moneyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 43)];
        [_myOrderView addSubview:self.moneyView];
        
        UIImageView *moneyImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 17.4, 17.4)];
        moneyImg.image = [UIImage imageNamed:@"img_myhome_money"];
        [self.moneyView addSubview:moneyImg];
        
        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12, 80, 20)];
        moneyLabel.text = @"账户余额";
        moneyLabel.font = [UIFont systemFontOfSize:14];
        [self.moneyView addSubview:moneyLabel];
        
        UIButton *moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        moneyBtn.frame = CGRectMake(10,5, SCREENWIDTH-20, 30);
        
        [moneyBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        moneyBtn.tag = 2015;
        [self.moneyView addSubview:moneyBtn];
        
        //分割线
        UIView *lineView15 = [[UIView alloc]initWithFrame:CGRectMake(40, 42, SCREENWIDTH-40, 1)];
        lineView15.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
        [self.moneyView addSubview:lineView15];
        
        self.otherView = [[UIView alloc]initWithFrame:CGRectMake(0,43, SCREENWIDTH, 43*3)];
        [_myOrderView addSubview:self.otherView];

        //我的玩具订单
        UIImageView *toyOrder = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 17.4, 17.4)];
        toyOrder.image = [UIImage imageNamed:@"img_myhome_toy"];
        [self.otherView addSubview:toyOrder];
        
        UILabel *toyLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12, 80, 20)];
        toyLabel.text = @"玩具订单";
        toyLabel.font = [UIFont systemFontOfSize:14];
        [self.otherView addSubview:toyLabel];
        
        UIButton *toyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        toyBtn.frame = CGRectMake(10,5, SCREENWIDTH-20, 30);
        
        [toyBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        toyBtn.tag = 2016;
        [self.otherView addSubview:toyBtn];
        //分割线
        UIView *lineView16 = [[UIView alloc]initWithFrame:CGRectMake(40, 42, SCREENWIDTH-40, 1)];
        lineView16.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
        [self.otherView addSubview:lineView16];


        //我的订单
        UIImageView *orderImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13+43, 17.4, 17.4)];
        orderImg.image = [UIImage imageNamed:@"img_myhome_order"];
        [self.otherView addSubview:orderImg];
        
        UILabel *orderLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12+43, 80, 20)];
        orderLabel.text = @"我的订单";
        orderLabel.font = [UIFont systemFontOfSize:14];
        [self.otherView addSubview:orderLabel];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        orderBtn.frame = CGRectMake(10,5+43, SCREENWIDTH-20, 30);
        
        [orderBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        orderBtn.tag = 2006;
        [self.otherView addSubview:orderBtn];
        //分割线
        UIView *lineView10 = [[UIView alloc]initWithFrame:CGRectMake(40, 42+43, SCREENWIDTH-40, 1)];
        lineView10.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
        [self.otherView addSubview:lineView10];
        
        //秀秀红包
        UIImageView *redBag = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13+43*2, 17.4, 17.4)];
        redBag.image = [UIImage imageNamed:@"img_myhome_myredbag"];
        [self.otherView addSubview:redBag];
        UILabel *redLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12+43*2, 80, 20)];
        redLabel.text = @"秀秀红包";
        redLabel.font = [UIFont systemFontOfSize:14];
        [self.otherView addSubview:redLabel];
        UIButton *redBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        redBtn.frame = CGRectMake(10,5+43*2 ,SCREENWIDTH-20,30);
        redBtn.tag = 2011;
        [redBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [self.otherView addSubview:redBtn];
        
        
        
        //绑定手机号
        _myPhoneNumberView = [[UIView alloc]initWithFrame:CGRectMake(0,_myOrderView.frame.origin.y+_myOrderView.frame.size.height+10, SCREENWIDTH, 43)];
        _myPhoneNumberView.backgroundColor = [UIColor whiteColor];
        [_backView addSubview:_myPhoneNumberView];
        UIImageView *myPhoneImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 17.4, 17.4)];
        myPhoneImg.image = [UIImage imageNamed:@"img_myhome_myphone"];
        [_myPhoneNumberView addSubview:myPhoneImg];
        
        _myPhoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12, 80, 20)];
        _myPhoneLabel.text = @"绑定手机号";
        _myPhoneLabel.font = [UIFont systemFontOfSize:14];
        [_myPhoneNumberView addSubview:_myPhoneLabel];
        
        _phoneNumberLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-110, 12, 90, 20)];
        _phoneNumberLabel.text = @"";
        _phoneNumberLabel.font = [UIFont systemFontOfSize:13];
        _phoneNumberLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        
        [_myPhoneNumberView addSubview:_phoneNumberLabel];
        _arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-20, 17, 6, 11)];
        _arrowImg.image = [UIImage imageNamed:@"img_myhome_arrow"];
        [_myPhoneNumberView addSubview:_arrowImg];
        
        UIButton *myPhoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        myPhoneBtn.frame = CGRectMake(10,5, SCREENWIDTH-20, 30);
        
        [myPhoneBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        myPhoneBtn.tag = 2012;
        [_myPhoneNumberView addSubview:myPhoneBtn];
        
        //
        _myPhotoView = [[UIView alloc]initWithFrame:CGRectMake(0,_myPhoneNumberView.frame.origin.y+_myPhoneNumberView.frame.size.height+10, SCREENWIDTH, 43*4)];
        _myPhotoView.backgroundColor = [UIColor whiteColor];
        [_backView addSubview:_myPhotoView];
        
        UIImageView *photoImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 17.4, 17.4)];
        photoImg.image = [UIImage imageNamed:@"img_myhome_photo"];
        [_myPhotoView addSubview:photoImg];
        
        UIImageView *fabuImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13+43, 17.4, 17.4)];
        fabuImg.image = [UIImage imageNamed:@"img_myhome_myfabu"];
        [_myPhotoView addSubview:fabuImg];
        
        UIImageView *shoucangImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13+43+43+43, 17.4, 17.4)];
        shoucangImg.image = [UIImage imageNamed:@"img_myhome_shoucang"];
        [_myPhotoView addSubview:shoucangImg];
        
        UIImageView *fouceImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13+43+43, 17.4, 17.4)];
        fouceImg.image = [UIImage imageNamed:@"img_myhome_fouce"];
        [_myPhotoView addSubview:fouceImg];

        
        
        
        
        UILabel *photoLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12, 80, 20)];
        photoLabel.text = @"相册";
        photoLabel.font = [UIFont systemFontOfSize:14];
        [_myPhotoView addSubview:photoLabel];
        
        UILabel *fabuLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12+43, 80, 20)];
        fabuLabel.text = @"我发布的";
        fabuLabel.font = [UIFont systemFontOfSize:14];
        [_myPhotoView addSubview:fabuLabel];
        
        UILabel *shoucangLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12+43+43+43, 80, 20)];
        shoucangLabel.text = @"收藏";
        shoucangLabel.font = [UIFont systemFontOfSize:14];
        [_myPhotoView addSubview:shoucangLabel];
        
        UILabel *fouceGroupLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12+43+43, 80, 20)];
        fouceGroupLabel.text = @"我关注的群";
        fouceGroupLabel.font = [UIFont systemFontOfSize:14];
        [_myPhotoView addSubview:fouceGroupLabel];

        
        //相册事件
        UIButton *albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        albumBtn.frame = CGRectMake(10,5 ,SCREENWIDTH-20,30);
        albumBtn.tag = 2001;
        [albumBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myPhotoView addSubview:albumBtn];
        //我发布的
        UIButton *fabuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fabuBtn.frame = CGRectMake(10,5+43 ,SCREENWIDTH-20,30);
        fabuBtn.tag = 2002;
        [fabuBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myPhotoView addSubview:fabuBtn];
        //收藏
        UIButton *shoucangBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        shoucangBtn.frame = CGRectMake(10,5+43+43+43 ,SCREENWIDTH-20,30);
        shoucangBtn.tag = 2005;
        [shoucangBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myPhotoView addSubview:shoucangBtn];
        //我关注的群
        UIButton *fouceBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        fouceBtn.frame = CGRectMake(10,5+43+43 ,SCREENWIDTH-20,30);
        fouceBtn.tag = 2014;
        [fouceBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myPhotoView addSubview:fouceBtn];

        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(40, 42, SCREENWIDTH-40, 1)];
        lineView1.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
        [_myPhotoView addSubview:lineView1];
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(40, 42+43, SCREENWIDTH-40, 1)];
        lineView2.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
        [_myPhotoView addSubview:lineView2];
        
        UIView *lineView13 = [[UIView alloc]initWithFrame:CGRectMake(40, 42+43+43, SCREENWIDTH-40, 1)];
        lineView13.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
        [_myPhotoView addSubview:lineView13];
        
        //消息
        _myMessageView = [[UIView alloc]initWithFrame:CGRectMake(0,_myPhotoView.frame.origin.y+_myPhotoView.frame.size.height+10, SCREENWIDTH, 43*2)];
        _myMessageView.backgroundColor = [UIColor whiteColor];
        [_backView addSubview:_myMessageView];
        UIImageView *messageImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 17.4, 17.4)];
        messageImg.image = [UIImage imageNamed:@"img_myhome_message"];
        [_myMessageView addSubview:messageImg];
        
        UIImageView *friendImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13+43, 17.4, 17.4)];
        friendImg.image = [UIImage imageNamed:@"img_myhome_frienddongtai"];
        [_myMessageView addSubview:friendImg];
        
        
        UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12, 80, 20)];
        messageLabel.text = @"消息";
        messageLabel.font = [UIFont systemFontOfSize:14];
        [_myMessageView addSubview:messageLabel];
        
        UILabel *friendLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12+43, 80, 20)];
        friendLabel.text = @"好友动态";
        friendLabel.font = [UIFont systemFontOfSize:14];
        [_myMessageView addSubview:friendLabel];
        _messCount = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-26, 13, 21.5, 21.5)];
        _messCount.backgroundColor=[UIColor redColor];
        _messCount.textColor=[UIColor whiteColor];
        _messCount.font=[UIFont systemFontOfSize:10];
        _messCount.textAlignment=NSTextAlignmentCenter;
        _messCount.text=@"";
        _messCount.layer.masksToBounds=YES;
        _messCount.layer.cornerRadius=11;
        _messCount.hidden = YES;
        [_myMessageView addSubview:_messCount];
        [_myMessageView addSubview:friendLabel];
        _messFriend = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-26, 13+43, 21.5, 21.5)];
        _messFriend.backgroundColor=[UIColor redColor];
        _messFriend.textColor=[UIColor whiteColor];
        _messFriend.font=[UIFont systemFontOfSize:10];
        _messFriend.textAlignment=NSTextAlignmentCenter;
        _messFriend.text=@"";
        _messFriend.layer.masksToBounds=YES;
        _messFriend.layer.cornerRadius=11;
        _messFriend.hidden = YES;
        [_myMessageView addSubview:_messFriend];
        
        
        UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(40, 42, SCREENWIDTH-40, 1)];
        lineView3.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
        [_myMessageView addSubview:lineView3];
        
        
        UIButton *megBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        megBtn.frame = CGRectMake(10,5 ,SCREENWIDTH-20,30);
        megBtn.tag = 2007;
        [megBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myMessageView addSubview:megBtn];
        
        UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        friendBtn.frame = CGRectMake(10,5+43 ,SCREENWIDTH-20,30);
        friendBtn.tag = 2008;
        [friendBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myMessageView addSubview:friendBtn];
        
        //好友
        _myfriendView = [[UIView alloc]initWithFrame:CGRectMake(0,_myMessageView.frame.origin.y+_myMessageView.frame.size.height+10, SCREENWIDTH, 43*3)];
        _myfriendView.backgroundColor = [UIColor whiteColor];
        [_backView addSubview:_myfriendView];
        
        UIImageView *goodFriendImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 17.4, 17.4)];
        goodFriendImg.image = [UIImage imageNamed:@"img_myhome_friend"];
        [_myfriendView addSubview:goodFriendImg];
        
        UIImageView *shareImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13+43, 17.4, 17.4)];
        shareImg.image = [UIImage imageNamed:@"img_myhome_share"];
        [_myfriendView addSubview:shareImg];
        
        UIImageView *dairyImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13+43+43, 17.4, 17.4)];
        dairyImg.image = [UIImage imageNamed:@"img_myhome_dairyfouce"];
        [_myfriendView addSubview:dairyImg];

        
        
        UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(40, 42, SCREENWIDTH-40, 1)];
        lineView4.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
        [_myfriendView addSubview:lineView4];
        
        UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(40, 42+43, SCREENWIDTH-40, 1)];
        lineView5.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
        [_myfriendView addSubview:lineView5];

        
        UILabel *goodFriendLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12, 80, 20)];
        goodFriendLabel.text = @"好友";
        goodFriendLabel.font = [UIFont systemFontOfSize:14];
        [_myfriendView addSubview:goodFriendLabel];
        
        UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12+43, 80, 20)];
        shareLabel.text = @"共享人";
        shareLabel.font = [UIFont systemFontOfSize:14];
        [_myfriendView addSubview:shareLabel];
        
        UILabel *dairyLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12+43+43, 120, 20)];
        dairyLabel.text = @"成长记录关注";
        dairyLabel.font = [UIFont systemFontOfSize:14];
        [_myfriendView addSubview:dairyLabel];
        _messGrowthCount = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-26, 13+43+43, 21.5, 21.5)];
        _messGrowthCount.backgroundColor=[UIColor redColor];
        _messGrowthCount.textColor=[UIColor whiteColor];
        _messGrowthCount.font=[UIFont systemFontOfSize:10];
        _messGrowthCount.textAlignment=NSTextAlignmentCenter;
        _messGrowthCount.text=@"";
        _messGrowthCount.layer.masksToBounds=YES;
        _messGrowthCount.layer.cornerRadius=11;
        _messGrowthCount.hidden = YES;
        [_myfriendView addSubview:_messGrowthCount];

        
        UIButton *goodFriendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        goodFriendBtn.frame = CGRectMake(10,5 ,SCREENWIDTH-20,30);
        goodFriendBtn.tag = 2003;
        [goodFriendBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myfriendView addSubview:goodFriendBtn];
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake(10,5+43 ,SCREENWIDTH-20,30);
        shareBtn.tag = 2004;
        [shareBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myfriendView addSubview:shareBtn];
        
        UIButton *dairyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        dairyBtn.frame = CGRectMake(10,5+43+43 ,SCREENWIDTH-20,30);
        dairyBtn.tag = 2010;
        [dairyBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myfriendView addSubview:dairyBtn];
        
        //我要入住
        
        _myEnterAppView = [[UIView alloc]initWithFrame:CGRectMake(0,_myfriendView.frame.origin.y+_myfriendView.frame.size.height+10, SCREENWIDTH, 43)];
        _myEnterAppView.backgroundColor = [UIColor whiteColor];
        [_backView addSubview:_myEnterAppView];
        
        UIImageView *enterImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 17.4, 17.4)];
        enterImg.image = [UIImage imageNamed:@"btn_myhome_cooperate"];
        [_myEnterAppView addSubview:enterImg];
        UILabel *enterLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12, 80, 20)];
        enterLabel.text = @"我要合作";
        enterLabel.font = [UIFont systemFontOfSize:14];
        [_myEnterAppView addSubview:enterLabel];
        UIButton *enterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        enterBtn.frame = CGRectMake(10,5 ,SCREENWIDTH-20,30);
        enterBtn.tag = 2013;
        [enterBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myEnterAppView addSubview:enterBtn];

        
        
        //设置
        _myHomeSetView = [[UIView alloc]initWithFrame:CGRectMake(0,_myEnterAppView.frame.origin.y+_myEnterAppView.frame.size.height+10, SCREENWIDTH, 43)];
        _myHomeSetView.backgroundColor = [UIColor whiteColor];
        [_backView addSubview:_myHomeSetView];
        
        UIImageView *setImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 13, 17.4, 17.4)];
        setImg.image = [UIImage imageNamed:@"img_myhome_setting"];
        [_myHomeSetView addSubview:setImg];
        UILabel *setLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 12, 80, 20)];
        setLabel.text = @"设置";
        setLabel.font = [UIFont systemFontOfSize:14];
        [_myHomeSetView addSubview:setLabel];
        UIButton *setBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        setBtn.frame = CGRectMake(10,5 ,SCREENWIDTH-20,30);
        setBtn.tag = 2009;
        [setBtn addTarget:self action:@selector(channelSelects:) forControlEvents:UIControlEventTouchUpInside];
        [_myHomeSetView addSubview:setBtn];
        
    }
    
    
}
#pragma mark  getDataUser
-(void)getDataUser{
    NSString *isidoled;
    //这需要改一下
    if (self.Type == 3||self.Type == 0) {
          isidoled = [NSString stringWithFormat:@"0"];
        self.userid = LOGIN_USER_ID;
        
    }else{
        isidoled = [NSString stringWithFormat:@"1"];

    }
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"user_id",self.userid,@"idol_id",isidoled,@"is_idoled", nil];
    
    UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewV1UrlStr:kUserInfo Method:NetMethodGet andParam:param];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
    __weak ASIHTTPRequest *blockRequest = request;
    AppDelegate *del = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [request setDownloadCache:del.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    [request setCompletionBlock:^{
        
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        
        if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
            NSDictionary *dataDic = [dic objectForKey:kBBSData];
            MyHomePageItem *MHPItem = [[MyHomePageItem alloc]init];
            MHPItem.relation = [dataDic objectForKey:@"relation"];
            MHPItem.userName = [dataDic objectForKey:@"nick_name"];
            MHPItem.avatarStr = [dataDic objectForKey:@"avatar"];
            MHPItem.babys = [dataDic objectForKey:@"signature"];
            MHPItem.registerUserName = [dataDic objectForKey:@"user_name"];
            MHPItem.registerEmail = [dataDic objectForKey:@"email"];
            MHPItem.level_img = [dataDic objectForKey:@"level_img"];
            MHPItem.user_role = [[dataDic objectForKey:@"user_role"]integerValue];
            MHPItem.babys_idol_count = [dataDic[@"babys_idol_count"]integerValue];//成长记录的数据
            MHPItem.my_message_count = [dataDic[@"my_message_count"]integerValue];
            MHPItem.friends_message_count = [dataDic[@"friends_message_count"]integerValue];
            MHPItem.user_id = dataDic[@"user_id"];
            MHPItem.mobile = dataDic[@"mobile"];
            MHPItem.isCount = dataDic[@"is_account"];
            _relation = [MHPItem.relation integerValue];
            NSInteger count = [MHPItem.babys count];
            [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:MHPItem.avatarStr]];
            UIFont *nameFont = [UIFont fontWithName:@"Helvetica-Bold" size:16];
            CGSize size = [MHPItem.userName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:nameFont} context:nil].size;
            self.nameLabel.text = MHPItem.userName;
            self.userIdLabel.text = [NSString stringWithFormat:@"ID:%@",MHPItem.user_id];
            if (self.Type == 1) {
                 _childrenView.frame =CGRectMake(96,30, 206, count*20);
            }else{
                _childrenView.frame =CGRectMake(96,50, 206, count*20);

            }
           
            _avatarImgView.center = CGPointMake(31+10, (count*20+68)/2+5);
            if (!(MHPItem.level_img.length <= 0)) {
                [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:MHPItem.level_img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    _levelImageView.frame =CGRectMake(_nameLabel.frame.origin.x + size.width + 1, _nameLabel.frame.origin.y, image.size.width*0.8,image.size.height*0.8);
                    _levelImageView.image = image;
                }];
                
            }
            _levelImageView.canClick = YES;
            ClickViewController *clickVC = [[ClickViewController alloc] init];
            [_levelImageView setClickToViewController:clickVC];
            for (UIView *view in [_childrenView subviews]) {
                [view removeFromSuperview];
            }
            
            for (int i=0; i<count; i++) {
                NSString *text=[MHPItem.babys objectAtIndex:i];
                UIFont *font=[UIFont systemFontOfSize:14];
                UILabel *kidLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, i*20 , 206, 20)];
                kidLabel.text=text;
                kidLabel.font=font;
                kidLabel.textColor=[BBSColor hexStringToColor:@"818181"];
                kidLabel.backgroundColor=[UIColor clearColor];
                [_childrenView addSubview:kidLabel];
            }
            _addKidBtn.frame = CGRectMake(96, _childrenView.frame.origin.y+_childrenView.frame.size.height+10, 103, 23);
            _avatarBackView.frame = CGRectMake(0, 0, SCREENWIDTH,_addKidBtn.frame.origin.y+23+10 );
            [self.addKidBtn addTarget:self action:@selector(addAChild) forControlEvents:UIControlEventTouchUpInside];
            if (self.Type == 1) {
                _myOrderView.frame = CGRectMake(0, _avatarBackView.frame.origin.y+_avatarBackView.frame.size.height, SCREENWIDTH, 0);
                _myPhotoView.frame = CGRectMake(0,_myOrderView.frame.origin.y+_myOrderView.frame.size.height+10, SCREENWIDTH, 43*3);
                _myMessageView.frame = CGRectMake(0,_myPhotoView.frame.origin.y+_myPhotoView.frame.size.height+10, SCREENWIDTH, 43*2);
                _myfriendView.frame =CGRectMake(0,_myMessageView.frame.origin.y+_myMessageView.frame.size.height+10, SCREENWIDTH, 43*2);
                _messFriend.hidden = YES;
                _messCount.hidden = YES;
                _messGrowthCount.hidden = YES;
                
            }else{
                if ([MHPItem.isCount isEqualToString:@"0"]) {
                _myOrderView.frame = CGRectMake(0, _avatarBackView.frame.origin.y+_avatarBackView.frame.size.height+10, SCREENWIDTH, 43*3);
                self.moneyView.hidden = YES;
                    self.otherView.frame = CGRectMake(0,0, SCREENWIDTH, 43*3);
                }else if ([MHPItem.isCount isEqualToString:@"1"]){
                _myOrderView.frame = CGRectMake(0, _avatarBackView.frame.origin.y+_avatarBackView.frame.size.height+10, SCREENWIDTH, 43*4);
                }
                
                _myPhoneNumberView.frame =CGRectMake(0,_myOrderView.frame.origin.y+_myOrderView.frame.size.height+10, SCREENWIDTH, 43);
                _myPhotoView.frame = CGRectMake(0,_myPhoneNumberView.frame.origin.y+_myPhoneNumberView.frame.size.height+10, SCREENWIDTH, 43*4);
                _myMessageView.frame = CGRectMake(0,_myPhotoView.frame.origin.y+_myPhotoView.frame.size.height+10, SCREENWIDTH, 43*2);
                _myfriendView.frame =CGRectMake(0,_myMessageView.frame.origin.y+_myMessageView.frame.size.height+10, SCREENWIDTH, 43*3);
                
                _myEnterAppView.frame = CGRectMake(0,_myfriendView.frame.origin.y+_myfriendView.frame.size.height+10, SCREENWIDTH, 43);
                _myHomeSetView.frame = CGRectMake(0,_myEnterAppView.frame.origin.y+_myEnterAppView.frame.size.height+10, SCREENWIDTH, 43);
                _backView.contentSize = CGSizeMake(0,_myHomeSetView.frame.origin.y+_myHomeSetView.frame.size.height+300);
                if (MHPItem.mobile.length > 0) {
                    _myPhoneLabel.text = @"更换手机号";
                    _phoneNumberLabel.hidden = NO;
                    _arrowImg.hidden = NO;
                    _phoneNumberLabel.text = MHPItem.mobile;
                    _isHavePhoneNumber = YES;
                    _phoneNumber = MHPItem.mobile;
                    
                }else{
                    _myPhoneLabel.text = @"绑定手机号";
                    _phoneNumberLabel.hidden =YES;
                    _arrowImg.hidden = YES;
                    _isHavePhoneNumber = NO;

                    
                }

                if (MHPItem.my_message_count > 0) {
                    _messCount.hidden = NO;
                    _messCount.text = [NSString stringWithFormat:@"%ld",MHPItem.my_message_count];
                    
                }else{
                    _messCount.hidden = YES;
                }
                if (MHPItem.friends_message_count > 0) {
                    _messFriend.hidden = NO;
                    _messFriend.text = [NSString stringWithFormat:@"%ld",MHPItem.friends_message_count];
                    
                }else{
                    _messFriend.hidden = YES;
                }
                if (MHPItem.babys_idol_count > 0) {
                    _messGrowthCount.hidden = NO;
                    _messGrowthCount.text = [NSString stringWithFormat:@"%ld",MHPItem.babys_idol_count];
                }else{
                    _messGrowthCount.hidden = YES;
                }
            }
            if (self.Type == 1) {
                if (_relation == 0) {
                    //陌生人，显示添加关注
                    [_addKidBtn setBackgroundImage:[UIImage imageNamed:@"btn_myhomepage_puton_focus.png"] forState:UIControlStateNormal];
                    _photoImg.image = [UIImage imageNamed:@"img_myhome_photogray"];
                }else if(_relation==3) {
                    
                    //粉丝，关注我，显示添加关注
                    [_addKidBtn setBackgroundImage:[UIImage imageNamed:@"btn_myhomepage_puton_focus.png"] forState:UIControlStateNormal];
                    
                }else if (_relation==1){
                    _photoImg.image = [UIImage imageNamed:@"img_myhome_photogray"];
                    //已经关注，显示取消关注
                    [_addKidBtn setBackgroundImage:[UIImage imageNamed:@"btn_myhomepage_cancel_focus.png"] forState:UIControlStateNormal];
                    
                }else if (_relation==2){
                    
                    //相互关注，显示取消关注
                    [_addKidBtn setBackgroundImage:[UIImage imageNamed:@"btn_myhomepage_cancel_focus.png"] forState:UIControlStateNormal];
                    
                }
                
            }else{
                [_addKidBtn setBackgroundImage:[UIImage imageNamed:@"btn_myhomepage_addababy"] forState:UIControlStateNormal];
                
            }
            
            
            [[NSUserDefaults standardUserDefaults] setObject:MHPItem.registerUserName forKey:USERNAME];
            [[NSUserDefaults standardUserDefaults] setObject:MHPItem.registerEmail forKey:USEREMAIL];
            
            self.item = MHPItem;
            
            
        }else{
            
            self.message = [dic objectForKey:kBBSReMsg];
            
        }
        
    }];
    
    
}
#pragma mark - MyHomePageHeaderViewDelegate

-(void)addAChild{
    
    if(self.Type==0 || self.Type==3 ){
        
        //添加宝贝
        UserInfoManager *manager=[[UserInfoManager alloc]init];
        UserInfoItem *userItem=[manager currentUserInfo];
        
        if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
            LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
            
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
            [self presentViewController:nav animated:YES completion:^{
            }];
            return;
  
            
        }else{
            
            RegisterStep2ViewController *addKidVC=[[RegisterStep2ViewController alloc]init];
            addKidVC.Type=1;
            addKidVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:addKidVC animated:YES];
            
        }
        
    }else if (self.Type==1){
        
        NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
        [param setObject:self.userid forKey:@"idol_id"];
        [param setObject:LOGIN_USER_ID forKey:@"user_id"];
        _focusHeader = YES;
        if (_relation == 0 || _relation == 3) {
            //添加关注
            NetAccess *net=[NetAccess sharedNetAccess];
            [net getDataWithStyle:NetStyleFocusOn andParam:param];
            [LoadingView startOnTheViewController:self];
        }else if(_relation ==1 || _relation==2){
            //取消关注
            NetAccess *net=[NetAccess sharedNetAccess];
            [net getDataWithStyle:NetStyleCancelFocus andParam:param];
            [LoadingView startOnTheViewController:self];
        }
        
    }
    
}
- (void)channelSelects:(id)sender {
    UIButton *button = (UIButton*)sender;
    NSInteger tag = button.tag - 2000;
    switch (tag) {
        case 1: {
            if (self.Type==1) {
                //Ta的相册
                if ((_relation==2 || _relation==3)) {
                    TA_AlbumListViewController *albumListVC = [[TA_AlbumListViewController alloc] init];
                    albumListVC.title = [self.messDic objectForKey:@"username"];
                    albumListVC.ta_user_id = self.userid;
                    albumListVC.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:albumListVC animated:YES];
                } else {
                    return;
                }
            }else{
                //我的相册
                AlbumListViewController *albumListViewController = [[AlbumListViewController alloc] init];
                albumListViewController.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:albumListViewController animated:YES];
            }
            break;
        }
        case 2: {
            //我/他发布的
            MyOutPutViewController *myOutPutVC=[[MyOutPutViewController alloc]init];
            NSString *loginUserId=[NSString stringWithFormat:@"%@",LOGIN_USER_ID];
            myOutPutVC.loginUserid=loginUserId;
            myOutPutVC.userid=[NSString stringWithFormat:@"%@",self.userid];//这个主页的用户ID,有可能是我,有可能是其他
            [myOutPutVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:myOutPutVC animated:YES];
            
            break;
        }
        case 3: {
            MyFansListViewController *myFans=[[MyFansListViewController alloc]init];
            myFans.userid=self.userid;
            myFans.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:myFans animated:YES];
            break;
        }
        case 4: {
            if (self.Type == 1) {
                return;
            }
            //我的共享
            PhotoShareViewController *photoShare=[[PhotoShareViewController alloc]init];
            photoShare.userId=self.userid;
            [photoShare setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:photoShare animated:YES];
            
            
            break;
        }
        case 5: {
            if (self.Type == 1) {
                return;
            }
            //我的收藏
            PostBarNewVC *postbarVC=[[PostBarNewVC alloc]init];
            postbarVC.login_user_id=self.userid;
            postbarVC.post_create_time=NULL;
            postbarVC.type=POSTBARNEWTYPEMYFOUCUS;
            [postbarVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:postbarVC animated:YES];
            break;
        }
        case 6: {
            if (self.Type == 1) {
                return;
            }
            if (self.item.user_role == 1) {
                StoreOrdersViewController *storeVC = [[StoreOrdersViewController alloc]init];
                [self.navigationController pushViewController:storeVC animated:YES];
                
            }else {
                MyOrdersViewController *myOrderVC = [[MyOrdersViewController alloc]init];
                [self.navigationController pushViewController:myOrderVC animated:YES];
            }
            
            break;
        }
        case 7:{
            MyMessageListVC *myMessageListVC = [[MyMessageListVC alloc]init];
            myMessageListVC.userid = self.userid;
            _messCount.hidden = YES;
            [self.navigationController pushViewController:myMessageListVC animated:YES];
            break;
        
        }
        case 8 :{
            MyFriendMessListVC *myFriendVC = [[MyFriendMessListVC alloc]init];
            myFriendVC.userid = self.userid;
            _messFriend.hidden = YES;
            [self.navigationController pushViewController:myFriendVC animated:YES];
            break;
        }
        case 9:{
            [self setting];
            break;
        }
        case 10:{
            [self pushDairyFouceListVC];
            break;
            
        }
        case 11:{
            [self pushRedBagVCList];
            break;

        }
        case 12:{
            [self changePhoneNumber];
            break;
        }
        case 13:{
            [self enterMyCooperate];
            
            break;
        }
        case 14:{
            [self enterMyFouceGroupList];
            
            break;
        }
        case 15:{
            [self pushGetCash];
            
            break;
        }
        case 16:{
            [self pushToyList];
            
            break;
        }

            

            
        default:
            break;
    }
}
#pragma mark 账户余额提现
-(void)pushGetCash{
    GetCashVC *getCashVc = [[GetCashVC alloc]init];
    [self.navigationController pushViewController:getCashVc animated:YES];
    
    
}
#pragma mark 玩具订单
-(void)pushToyList{
    ToyLeaseNewVC *toyLeaseListVc = [[ToyLeaseNewVC alloc]init];
    toyLeaseListVc.inTheViewData =  2003;
    [self.navigationController pushViewController:toyLeaseListVc animated:YES];
    
}
#pragma mark -添加关注和取消关注的通知方法
-(void)focusSucceed{
    _relation = 1;
    [_addKidBtn setBackgroundImage:[UIImage imageNamed:@"btn_myhomepage_cancel_focus.png"] forState:UIControlStateNormal];
    [LoadingView stopOnTheViewController:self];
}
-(void)focusFail:(NSNotification *) not{
    
    NSString *errorString=not.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    [LoadingView stopOnTheViewController:self];
}
-(void)cancelFocusSucceed{
        _relation=0;
        [_addKidBtn setBackgroundImage:[UIImage imageNamed:@"btn_myhomepage_puton_focus.png"] forState:UIControlStateNormal];
         [LoadingView stopOnTheViewController:self];
}

-(void)cancelFocusFail:(NSNotification *) not{
    
    NSString *errorString=not.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    [LoadingView stopOnTheViewController:self];
}


#pragma mark - Private
//返回
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//设置
-(void)setting{
    
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    
    if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID==NULL) {
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
        return;
    }else{
        
        EditingViewController *edtVC=[[EditingViewController alloc]init];
        edtVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:edtVC animated:YES];
        
    }
    
}
//加关注页面
-(void)pushDairyFouceListVC{
    DairyFouceListVC *dairyVC = [[DairyFouceListVC alloc]init];
    dairyVC.login_user_id = self.userid;
    [self.navigationController pushViewController:dairyVC animated:YES];
}
//更改手机号页面
-(void)changePhoneNumber{
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    
    if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID ==NULL) {
        
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
        
        loginVC.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:loginVC action:@selector(dissmissLoginHTMLVC)];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
        return;
        
    }else{

    if (_isHavePhoneNumber == YES) {
        ChangePhoneNumberVC *changeVC = [[ChangePhoneNumberVC alloc]init];
        changeVC.phoneNumber = _phoneNumberLabel.text;
        [self.navigationController pushViewController:changeVC animated:YES];

    }else{
        ChangePhoneNumber2VC *change2VC = [[ChangePhoneNumber2VC alloc]init];
        change2VC.typeChangeOrBing = 1;//之前没有手机号现在绑定
        [self.navigationController pushViewController:change2VC animated:YES];
        
    }
    }
    
}
-(void)pushRedBagVCList{
    RedBagListVC *redBagList = [[RedBagListVC alloc]init];
    redBagList.longinUserId = self.userid;
    [self.navigationController pushViewController:redBagList animated:YES];
    
}
-(void)enterMyCooperate{
    EnterCooperateVC *enterCooperateVC = [[EnterCooperateVC alloc]init];
    enterCooperateVC.loginUserId = self.userid;
    [self.navigationController pushViewController:enterCooperateVC animated:YES];
}
-(void)enterMyFouceGroupList{
    PostBarListNewVC *postBarListVC = [[PostBarListNewVC alloc]init];
    postBarListVC.titleNav = @"我关注的群";
    postBarListVC.fromFouce = @"myFouce";
    [self.navigationController pushViewController:postBarListVC animated:YES];
    
}
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==1){
        if (alertView.tag < 0) {
            AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate setStartViewController];
            return;
            
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
