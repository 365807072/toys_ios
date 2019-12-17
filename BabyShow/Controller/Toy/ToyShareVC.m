//
//  ToyShareVC.m
//  BabyShow
//
//  Created by WMY on 17/3/24.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyShareVC.h"
#import "RefreshControl.h"
#import "SearchUserItem.h"
#import "ToyShareUserCell.h"
#import "UIImageView+WebCache.h"
#import "ToyRuleVC.h"
#import "GiftChooseCell.h"
#import "UIButton+WebCache.h"
#import "NIAttributedLabel.h"
#import "ToyShareUserItem.h"
#import "ToyGiftItem.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "ToyShareNoFriendCellTableViewCell.h"

@interface ToyShareVC ()<RefreshControlDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    RefreshControl *_refreshControl;
    UIView *_headrView;
    UITableView *_giftTableView;
    NSMutableArray *_giftDataArray;

}
@property(nonatomic,strong)UIView *ruleView;//细则页面
@property(nonatomic,strong)UILabel *lookRuleLabel;
@property(nonatomic,strong)UIImageView *lookRulwImg;

@property(nonatomic,strong)UIView *userView;//用户页面
@property(nonatomic,strong)UIImageView *avatarImgView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *userSuccessCountLabel;
@property(nonatomic,strong)UILabel *giftCountChoosedLabel;
@property(nonatomic,strong)UIButton *chooseGiftBtn;
@property(nonatomic,strong)UIButton *chooseMoreGiftBtn;

@property(nonatomic,strong)UIView *giftView;//选择礼品
@property(nonatomic,strong)UIScrollView *giftScrollView;//选择礼品
@property(nonatomic,strong)UIProgressView* progressView;
@property(nonatomic,strong)UIButton *acceptCountBtn;
@property(nonatomic,strong)UIImageView *iconImgView;

@property(nonatomic,strong)UIView *requestView;//邀请页面
@property(nonatomic,strong)UITextField *phoneNumberText;
@property(nonatomic,strong)UIButton *buttonRequest;
@property(nonatomic,strong)UIButton *buttonShare;
@property(nonatomic,strong)UILabel *ruleDetailLabel;

@property(nonatomic,strong)UIView *friendListHeadView;//朋友头部
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIButton *closeBtn;
//数据请求
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *avatar;
@property(nonatomic,strong)NSString *nick_name;
@property(nonatomic,strong)NSString *invitation_number_des;
@property(nonatomic,strong)NSString *toys_number_des;
@property(nonatomic,strong)NSString *invitation_number;
@property(nonatomic,strong)NSString *more_number;
@property(nonatomic,strong)NSString *invitation_description;
@property(nonatomic,strong)NSString *prize_id;
@property(nonatomic,strong)NSString *prize_title;
@property(nonatomic,strong)NSString *prize_description;
@property(nonatomic,strong)NSString *img;
@property(nonatomic,strong)NSMutableArray *giftSmallArray;
@property(nonatomic,strong)UIButton *shareBtn;//页面分享
@property(nonatomic,strong)NSString *shared_img;
@property(nonatomic,strong)NSString *shared_title;
@property(nonatomic,strong)NSString *shared_des;
//选择小玩具兑换
@property(nonatomic,strong)UIView *backViewSmall;
@property(nonatomic,strong)UIView *windowChangeGiftView;
@property(nonatomic,strong)UIImageView *giftImgViewSmall;
@property(nonatomic,strong)UIButton *changeGiftBtn;
@property(nonatomic,strong)UIButton *closeSmallBtn;
@property(nonatomic,strong)NSString *prize_idSmall;//奖品的id
@property(nonatomic,strong)NSString *loadWeb;//是否有新的web
@property(nonatomic,strong)UIWebView *shareWebView;//

@property(nonatomic,strong)NSString *shareImgMiniProgram;//小程序分享的图片
@property(nonatomic,strong)NSString *shareshare_path;//小程序的路径
@property(nonatomic,strong)NSString *shareNewUrl;//分享的新链接




@end
@implementation ToyShareVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    self.navigationController.navigationBar.barTintColor = [BBSColor hexStringToColor:NAVICOLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; [self.navigationController.navigationBar setShadowImage:nil];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.giftSmallArray = [NSMutableArray array];//小玩具的数组
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationItem.title = @"邀请";
    self.view.backgroundColor = [UIColor whiteColor];
    _dataArray = [NSMutableArray array];//邀请人的数组
    _giftDataArray = [NSMutableArray array];//大玩具的数组
    [self setHeaderView];
    [self setBackButton];
    [self setTableView];
    [self refreshControlInit];
    [self setChooseView];
    [self setRightButton];
    [self setSmallBackView];

}

#pragma mark 邀请页面分享
-(void)setRightButton{
     UIView *iconBgView = [[UIView alloc]initWithFrame:CGRectMake(0, -5, 15, 20)];
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.shareBtn.frame = CGRectMake(0, 0, 18, 18);
    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"btn_new_toy_share"] forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(shareStoreMeg) forControlEvents:UIControlEventTouchUpInside];
    [iconBgView addSubview:self.shareBtn];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:iconBgView];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
#pragma mark 头部用户信息
-(void)setHeaderView{
    _headrView = [[UIView alloc]initWithFrame:CGRectMake(0,0,SCREENWIDTH,0)];
    _headrView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    //细则页面
    _ruleView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 34)];
    _ruleView.backgroundColor = [BBSColor hexStringToColor:@"fff6dd"];
    [_headrView addSubview:_ruleView];
    UIImageView *iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(6, 8,16, 18)];
    iconImg.image =  [UIImage imageNamed:@"toy_share_rule"];
    [_ruleView addSubview:iconImg];
    
    _lookRuleLabel = [[UILabel alloc]initWithFrame:CGRectMake(28, 8, 100, 18)];
    _lookRuleLabel.textColor = [BBSColor hexStringToColor:@"ff914f"];
    _lookRuleLabel.font = [UIFont systemFontOfSize:11];
    _lookRuleLabel.text = @"点击查看活动规则";
    [_ruleView addSubview:_lookRuleLabel];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [_ruleView addGestureRecognizer:singleTap];
    _lookRulwImg = [[UIImageView alloc]initWithFrame:CGRectMake(_lookRuleLabel.frame.origin.x+_lookRuleLabel.frame.size.width, 14, 14, 7)];
    _lookRulwImg.image = [UIImage imageNamed:@"toy_share_rule_lookmore"];
    [_ruleView addSubview:_lookRulwImg];
    
    //用户信息
    _userView = [[UIView alloc]initWithFrame:CGRectMake(0,_ruleView.frame.origin.x+_ruleView.frame.size.height, SCREENWIDTH, 85)];
    _userView.backgroundColor = [UIColor whiteColor];
    [_headrView addSubview:_userView];
    self.avatarImgView=[[UIImageView alloc]initWithFrame:CGRectMake(6, 10, 66, 66)];
    self.avatarImgView.layer.masksToBounds = YES;
    self.avatarImgView.layer.cornerRadius = 33;
    [_userView addSubview:self.avatarImgView];
    self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(82, 10, 206, 20)];
    self.nameLabel.font= [UIFont systemFontOfSize:14];
    self.nameLabel.textColor=[BBSColor hexStringToColor:@"3e3e3e"];
    [_userView addSubview:self.nameLabel];
    
    self.userSuccessCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.frame.origin.x, self.nameLabel.frame.origin.y+self.nameLabel.frame.size.height+10, 200, 13)];
    self.userSuccessCountLabel.textColor = [BBSColor hexStringToColor:@"999999"];
    self.userSuccessCountLabel.font = [UIFont systemFontOfSize:11];
    [_userView addSubview:self.userSuccessCountLabel];
    
    self.giftCountChoosedLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.nameLabel.frame.origin.x, self.userSuccessCountLabel.frame.origin.y+self.userSuccessCountLabel.frame.size.height+2, 200, 13)];
    self.giftCountChoosedLabel.textColor = [BBSColor hexStringToColor:@"999999"];
    self.giftCountChoosedLabel.font = [UIFont systemFontOfSize:11];
    [_userView addSubview:self.giftCountChoosedLabel];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 84, SCREENWIDTH, 1)];
    lineView.backgroundColor = [BBSColor hexStringToColor:@"f4f4f4"];
    [_userView addSubview:lineView];
    
    self.chooseGiftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chooseGiftBtn.frame = CGRectMake(SCREENWIDTH-100, 20, 95, 29);
    self.chooseGiftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.chooseGiftBtn.backgroundColor = [BBSColor hexStringToColor:NAVICOLOR];
    self.chooseGiftBtn.layer.masksToBounds = YES;
    self.chooseGiftBtn.layer.cornerRadius = 2;
    [_userView addSubview:self.chooseGiftBtn];
    [self.chooseGiftBtn setImage:[UIImage imageNamed:@"toy_share_gift"] forState:UIControlStateNormal];
    [self.chooseGiftBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 79, 10, 8)];
    
    self.chooseMoreGiftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.chooseMoreGiftBtn.frame = CGRectMake(SCREENWIDTH-85,50, 80, 20);
    self.chooseMoreGiftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.chooseMoreGiftBtn setTitle:@"更多礼品" forState:UIControlStateNormal];
    [self.chooseMoreGiftBtn setTitleColor:[BBSColor hexStringToColor:NAVICOLOR] forState:UIControlStateNormal];
    self.chooseMoreGiftBtn.backgroundColor = [UIColor whiteColor];
    self.chooseMoreGiftBtn.layer.masksToBounds = YES;
    self.chooseMoreGiftBtn.layer.cornerRadius = 2;
    [_userView addSubview:self.chooseMoreGiftBtn];
    [self.chooseMoreGiftBtn setImage:[UIImage imageNamed:@"toy_more_gift"] forState:UIControlStateNormal];
    [self.chooseMoreGiftBtn setImageEdgeInsets:UIEdgeInsetsMake(5, 79, 5, 8)];

    
    
    
    //收集玩具进度
    _giftView = [[UIView alloc]initWithFrame:CGRectMake(0,_userView.frame.origin.y+_userView.frame.size.height, SCREEN_WIDTH, 108)];
    _giftView.backgroundColor = [UIColor whiteColor];
    [_headrView addSubview:_giftView];
    
    _giftScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 61)];
    _giftScrollView.backgroundColor = [UIColor whiteColor];
    _giftScrollView.bounces = NO;
    _giftScrollView.pagingEnabled = NO;
    _giftScrollView.showsVerticalScrollIndicator = NO;
    _giftScrollView.showsHorizontalScrollIndicator = NO;
    _giftScrollView.delegate = self;
    [_giftView addSubview:_giftScrollView];
    
    _progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(6,62,SCREENWIDTH-12,5)];
    _progressView.progressViewStyle = UIProgressViewStyleDefault;
    [_giftView addSubview:_progressView];
    _progressView.trackTintColor = [BBSColor hexStringToColor:@"fff3c9"];
    _progressView.progressTintColor = [BBSColor hexStringToColor:@"ff9862"];
    _iconImgView = [[UIImageView alloc]initWithFrame:CGRectMake(56, 59, 21, 7)];
    _iconImgView.image = [UIImage imageNamed:@"toy_share_toy_icon"];
    [_giftView addSubview:_iconImgView];
    
    _acceptCountBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _acceptCountBtn.frame = CGRectMake(SCREENWIDTH*0.3-46.5, _progressView.frame.origin.y+5+2, 93, 29);
    [_giftView addSubview:_acceptCountBtn];
    [_acceptCountBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _acceptCountBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [_acceptCountBtn setTitleEdgeInsets:UIEdgeInsetsMake(10, 0, 5, 0)];
    
    //邀请用户
    _requestView = [[UIView alloc]initWithFrame:CGRectMake(0,_giftView.frame.origin.y+_giftView.frame.size.height, SCREEN_WIDTH, 235)];
    _requestView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [_headrView addSubview:_requestView];
    _phoneNumberText =  [[UITextField alloc]initWithFrame:CGRectMake(45, 10,SCREENWIDTH-90, 36)];
    _phoneNumberText.placeholder = @"对方的手机号，邀请一周内有效";
    _phoneNumberText.font = [UIFont systemFontOfSize:12];
    _phoneNumberText.keyboardType = UIKeyboardTypeNumberPad;
    _phoneNumberText.layer.cornerRadius = 18;
    _phoneNumberText.layer.borderColor = [BBSColor hexStringToColor:@"e4e4e4"].CGColor;
    _phoneNumberText.delegate = self;
    _phoneNumberText.textAlignment = NSTextAlignmentCenter;
    _phoneNumberText.layer.borderWidth = 1.0f;
    _phoneNumberText.backgroundColor = [UIColor whiteColor];
    [_requestView addSubview:_phoneNumberText];
    
    _buttonRequest = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonRequest.frame = CGRectMake(45,8+36+8,SCREENWIDTH-90, 36);
    [_requestView addSubview:_buttonRequest];
    [_buttonRequest setTitle:@"邀请好友" forState:UIControlStateNormal];
    [_buttonRequest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _buttonRequest.titleLabel.font = [UIFont systemFontOfSize:12];
    _buttonRequest.layer.cornerRadius = 18;
    [_buttonRequest addTarget:self action:@selector(requestFriend) forControlEvents:UIControlEventTouchUpInside];
    _buttonRequest.backgroundColor = [BBSColor hexStringToColor:NAVICOLOR];
    
    _buttonShare = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonShare.frame = CGRectMake(45,8+36+8+36+28,SCREENWIDTH-90,36);
    [_requestView addSubview:_buttonShare];
    [_buttonShare setTitle:@"去邀请她（他）" forState:UIControlStateNormal];
    [_buttonShare setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _buttonShare.titleLabel.font = [UIFont systemFontOfSize:12];
    _buttonShare.layer.cornerRadius = 18;
    _buttonShare.backgroundColor = [BBSColor hexStringToColor:@"ff9862"];
    
    self.ruleDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(45, _buttonRequest.frame.origin.y+_buttonRequest.frame.size.height+5, SCREENWIDTH-90, 50)];
    self.ruleDetailLabel.textColor = [BBSColor hexStringToColor:@"999999"];
    self.ruleDetailLabel.numberOfLines = 0;
    self.ruleDetailLabel.font = [UIFont systemFontOfSize:11];
    [_requestView addSubview:self.ruleDetailLabel];
    
    _friendListHeadView =  [[UIView alloc]initWithFrame:CGRectMake(0,_requestView.frame.origin.y+_requestView.frame.size.height, SCREEN_WIDTH, 40)];
    _friendListHeadView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [_headrView addSubview:_friendListHeadView];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(45, 19, 50, 1)];
    lineView2.backgroundColor = [BBSColor hexStringToColor:@"d8d8d8"];
    [_friendListHeadView addSubview:lineView2];
    UILabel *titleLabel =  [[UILabel alloc]initWithFrame:CGRectMake(45,10, SCREENWIDTH-90, 20)];
    titleLabel.text = @"看看谁被邀请了";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:13];
    titleLabel.textColor = [BBSColor hexStringToColor:@"999999"];
    [_friendListHeadView addSubview:titleLabel];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH-95, 19, 50, 1)];
    lineView3.backgroundColor = [BBSColor hexStringToColor:@"d8d8d8"];
    [_friendListHeadView addSubview:lineView3];
    _headrView.frame = CGRectMake(0, 0, SCREENWIDTH, _friendListHeadView.frame.origin.y+40);
    
    UITapGestureRecognizer *singleTap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endEdit)];
    [_headrView addGestureRecognizer:singleTap1];
}
-(void)endEdit{
    [self.view endEditing:YES];
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer
{
    [self.view endEditing:YES];
    ToyRuleVC *toyRule = [[ToyRuleVC alloc]init];
    [self.navigationController pushViewController:toyRule animated:YES];
    
}

-(void)setTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect tableviewFrame=CGRectMake(0,64, SCREENWIDTH, SCREENHEIGHT-64);
    _tableView=[[UITableView alloc]initWithFrame:tableviewFrame];
    _tableView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
}

#pragma mark 玩具大分类的选择
-(void)setChooseView{
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _backView.backgroundColor = [BBSColor hexStringToColor:@"000000" alpha:0.3];
    [self.view addSubview:_backView];
    _backView.hidden = YES;
    
    CGRect tableviewFrame=CGRectMake(60,85+64, 200, 270);
    _giftTableView = [[UITableView alloc]initWithFrame:tableviewFrame];
    _giftTableView.backgroundColor = [UIColor whiteColor];
    _giftTableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _giftTableView.showsVerticalScrollIndicator=NO;
    _giftTableView.layer.cornerRadius = 5;
    _giftTableView.layer.masksToBounds = YES;
    _giftTableView.delegate = self;
    _giftTableView.dataSource = self;
    [_backView addSubview:_giftTableView];
    
    self.closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeBtn.frame = CGRectMake((SCREENWIDTH-50)/2, 440, 50, 50);
    [_backView addSubview:self.closeBtn];
    [self.closeBtn addTarget:self action:@selector(dissmissChooseGiftView) forControlEvents:UIControlEventTouchUpInside];
    [self.closeBtn setImage:[UIImage imageNamed:@"toy_share_close_btn"] forState:UIControlStateNormal];
}
#pragma mark 兑换玩具弹窗
-(void)setSmallBackView{
    _backViewSmall = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _backViewSmall.backgroundColor = [BBSColor hexStringToColor:@"000000" alpha:0.3];
    [self.view addSubview:_backViewSmall];
    _backViewSmall.hidden = YES;
    _windowChangeGiftView = [[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-178)/2, 138+64, 178, 173)];
    _windowChangeGiftView.backgroundColor = [UIColor whiteColor];
    [_backViewSmall addSubview:_windowChangeGiftView];
    _windowChangeGiftView.layer.cornerRadius = 10;
    
    self.giftImgViewSmall=[[UIImageView alloc]initWithFrame:CGRectMake(27, 20, 124,88)];
    [_windowChangeGiftView addSubview:self.giftImgViewSmall];
    
    self.changeGiftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.changeGiftBtn.frame = CGRectMake(27, 123, 124, 34);
    [_windowChangeGiftView addSubview:self.changeGiftBtn];
    self.changeGiftBtn.backgroundColor = [BBSColor hexStringToColor:NAVICOLOR];
    self.changeGiftBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    self.changeGiftBtn.layer.cornerRadius = 8;
    self.changeGiftBtn.layer.masksToBounds = YES;
    [self.changeGiftBtn setTitle:@"兑换礼品" forState:UIControlStateNormal];
    
    self.closeSmallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.closeSmallBtn.frame = CGRectMake((SCREENWIDTH-50)/2, 420, 50, 50);
    [_backViewSmall addSubview:self.closeSmallBtn];
    [self.closeSmallBtn addTarget:self action:@selector(dissmissBackSmall) forControlEvents:UIControlEventTouchUpInside];
    [self.closeSmallBtn setImage:[UIImage imageNamed:@"toy_share_close_btn"] forState:UIControlStateNormal];
    
}
#pragma mark 兑换礼品的页面消失
-(void)dissmissBackSmall{
    _backViewSmall.hidden = YES;
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
        }
        [self getFriendListData];
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
#pragma mark 数据请求
-(void)getFriendListData{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    NSString *url;
    url = @"getPrizeUserInfo";
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
            //1、分享相关数据
            self.shared_img = dataDic[@"share_img"];
            self.shared_title = dataDic[@"shared_title"];
            self.shared_des = dataDic[@"shared_des"];
            self.shareImgMiniProgram = dataDic[@"share_img"];
            self.shareshare_path = dataDic[@"share_path"];
            [_buttonShare addTarget:self action:@selector(shareStoreMeg) forControlEvents:UIControlEventTouchUpInside];
            self.loadWeb = dataDic[@"loadWeb"];
            self.shareNewUrl = dataDic[@"loadWeb_new"];
            if (self.loadWeb.length >0) {
                [self setAllWebView];
                
            }else{
            //2、用户信息
            self.avatar = dataDic[@"avatar"];
            [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:self.avatar] placeholderImage:[UIImage imageNamed:@"img_myshow_section_avatar"]];
            self.nick_name = dataDic[@"nick_name"];
            self.nameLabel.text = self.nick_name;
            self.userSuccessCountLabel.text = dataDic[@"invitation_number_des"];
            self.giftCountChoosedLabel.text = dataDic[@"toys_number_des"];
            //3、玩具选择器
            self.prize_title = dataDic[@"prize_title"];
            self.prize_id = dataDic[@"prize_id"];
            [self.chooseGiftBtn setTitle:self.prize_title forState:UIControlStateNormal];
            [self.chooseGiftBtn addTarget:self action:@selector(chooseGift) forControlEvents:UIControlEventTouchUpInside];
            [self.chooseMoreGiftBtn addTarget:self action:@selector(chooseGift) forControlEvents:UIControlEventTouchUpInside];
            //4、下面的小玩具的显示
            NSArray *dataArray = dataDic[@"prizeList"];
            [self getGiftSmall:dataArray];
            //5、邀请人和受邀请人
            self.more_number = dataDic[@"more_number"];
            self.invitation_number = dataDic[@"invitation_number"];
            NSString *acceptString = [NSString stringWithFormat:@"成功邀请：%@人",self.invitation_number];
            [_acceptCountBtn setTitle:acceptString forState:UIControlStateNormal];
            _progressView.progress = [self.invitation_number floatValue]/[self.more_number floatValue] ;
            _iconImgView.frame = CGRectMake(SCREENWIDTH*_progressView.progress, 60, 21, 6);
            if (_progressView.progress >= 0.5) {
                [_acceptCountBtn setBackgroundImage:[UIImage imageNamed:@"toy_share_acceptRight"] forState:UIControlStateNormal];
                _acceptCountBtn.frame = CGRectMake(SCREENWIDTH*_progressView.progress+6-93, _progressView.frame.origin.y+5+2, 93, 29);
            }else{
            [_acceptCountBtn setBackgroundImage:[UIImage imageNamed:@"toy_share_accept"] forState:UIControlStateNormal];
            _acceptCountBtn.frame = CGRectMake(SCREENWIDTH*_progressView.progress+6, _progressView.frame.origin.y+5+2, 93, 29);
            }
            //6、邀请信息规则
            self.invitation_description = dataDic[@"invitation_description"];
            CGFloat height = [self getHeightByWidth:SCREENWIDTH-90 title:self.invitation_description font:[UIFont systemFontOfSize:10]];
            
            self.ruleDetailLabel.text =  self.invitation_description;
            self.ruleDetailLabel.frame = CGRectMake(self.ruleDetailLabel.frame.origin.x, 24+78, SCREENWIDTH-90, height);
            _buttonShare.frame = CGRectMake(45,self.ruleDetailLabel.frame.origin.y+self.ruleDetailLabel.frame.size.height+10,SCREENWIDTH-90,36);
            _requestView.frame = CGRectMake(_requestView.frame.origin.x, _requestView.frame.origin.y, SCREENWIDTH, self.buttonShare.frame.origin.y+36);
            _friendListHeadView.frame =  CGRectMake(0,_requestView.frame.origin.y+_requestView.frame.size.height, SCREEN_WIDTH, 40);
            _headrView.frame = CGRectMake(0, 0, SCREENWIDTH, _friendListHeadView.frame.origin.y+40);
            _tableView.tableHeaderView = _headrView;
            //7、邀请人的列表
            [_dataArray removeAllObjects];
            for (NSDictionary *dic in dataDic[@"invitationList"]) {
                ToyShareUserItem *item = [[ToyShareUserItem alloc]init];
                item.invitation_id = dic[@"invitation_id"];
                 item.user_id = dic[@"user_id"];
                 item.avatar = dic[@"avatar"];
                 item.nick_name = dic[@"nick_name"];
                 item.status = dic[@"status"];
                 item.status_title = dic[@"status_title"];
                 item.inv_description = dic[@"inv_description"];
                item.inv_button = dic[@"inv_button"];
                [_dataArray addObject:item];
            }
            _refreshControl.bottomEnabled = NO;
            [_tableView reloadData];
            }
            
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
#pragma mark 提交邀请朋友的电话号码
-(void)requestFriend{
    [self.view endEditing:YES];
    if (_phoneNumberText.text.length != 11) {
        //手机号码不正确
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                        message:NSLocalizedString(@"手机号格式有误，请重新输入", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"知道了", nil)
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;

    }else{
        NSString *phoneNumber = _phoneNumberText.text;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",phoneNumber,@"mobile", nil];
        [[HTTPClient sharedClient]postNewV1:@"addToysPrize" params:params success:^(NSDictionary *result) {
            if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                [BBSAlert showAlertWithContent:@"提交成功，快去告诉她（他）吧！" andDelegate:self];
                [self dissmissBackSmall];
                [self getFriendListData];
                _phoneNumberText.text = @"";
            }else{
                [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
            }
        } failed:^(NSError *error) {
             [BBSAlert showAlertWithContent:@"网络问题" andDelegate:nil];
        }];

    }
}
#pragma mark 加载邀请好友的web页面
-(void)setAllWebView{
    
    self.shareWebView = [[UIWebView alloc]init];
    if (ISIPhoneX) {
        self.shareWebView.frame  = CGRectMake(0,64, SCREEN_WIDTH, SCREENHEIGHT-30);
    }else{
        self.shareWebView.frame  = CGRectMake(0,64, SCREEN_WIDTH, SCREENHEIGHT-64);

    }
    [self.view addSubview:self.shareWebView];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *urlString = self.loadWeb;
    NSString *urlEncoding = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    
    [self.shareWebView loadRequest:request];
    self.shareWebView.scrollView.bounces = NO;
    self.shareWebView.scalesPageToFit = NO;
    self.shareWebView.autoresizesSubviews = NO;
    self.shareWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.shareWebView.delegate = self;
    
}
-(void)againRequestWebUrl{
    NSString *urlString = self.loadWeb;
    NSString *urlEncoding = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    [self.shareWebView loadRequest:request];

}
#pragma mark 玩具选择下面的布局
-(void)getGiftSmall:(NSArray*)dataArray{
    [_giftSmallArray removeAllObjects];
    for (NSDictionary *giftDic in dataArray) {
        ToyGiftItem *item = [[ToyGiftItem alloc]init];
        item.prize_id = giftDic[@"prize_id"];
        item.prize_title = giftDic[@"prize_title"];
        item.prize_description = giftDic[@"prize_description"];
        item.img = giftDic[@"img"];
        item.is_click = giftDic[@"is_click"];
        item.prize_number = giftDic[@"prize_number"];
        [_giftSmallArray addObject:item];
    }
    NSInteger count = self.giftSmallArray.count;
    for (UIView *view in _giftScrollView.subviews) {
        [view removeFromSuperview];
    }
        for (int i = 0; i < count; i++) {
            //SCREENWIDTH-12
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            if (count == 1) {
//                button.frame = CGRectMake((SCREENWIDTH-12-52)/2+6, 15, 52, 34);
//                _giftScrollView.contentSize = CGSizeMake(SCREENWIDTH, _giftScrollView.frame.size.height);
//            }else if(count >1 && count <6){
//                button.frame = CGRectMake(i*(SCREENWIDTH-12-52)/(count-1)+6, 15, 52, 34);
//                _giftScrollView.contentSize = CGSizeMake(SCREENWIDTH, _giftScrollView.frame.size.height);
//
//            }else{
                button.frame = CGRectMake(i*(52+10)+6, 15, 52, 34);
                _giftScrollView.contentSize = CGSizeMake(count*62+6, _giftScrollView.frame.size.height);
//
//            }
            button.layer.masksToBounds = YES;
            button.layer.cornerRadius = 5;
            button.layer.borderColor = [[BBSColor hexStringToColor:@"ff9d6a"]CGColor];
            button.layer.borderWidth = 1.0f;
            [_giftScrollView addSubview:button];
            ToyGiftItem *item = self.giftSmallArray[i];
            NSString *imgString = item.img;
            [button sd_setImageWithURL:[NSURL URLWithString:imgString] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
            if ([item.prize_number isEqualToString:@"0"]) {
                button.tag = 6000+i;
                [button addTarget:self action:@selector(sureSmallToy:) forControlEvents:UIControlEventTouchUpInside];
 
            }else{
                UIButton *grayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                grayBtn.backgroundColor = [BBSColor hexStringToColor:@"000000" alpha:0.3];
                grayBtn.frame = CGRectMake(0, 0, 52, 34);
                grayBtn.layer.cornerRadius = 5;
                NSString *string = [NSString stringWithFormat:@"×%@",item.prize_number];
                [grayBtn setTitle:string forState:UIControlStateNormal];
                grayBtn.titleLabel.font = [UIFont systemFontOfSize:14];
                [grayBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [button addSubview:grayBtn];
                grayBtn.tag = 6000+i;
                [grayBtn addTarget:self action:@selector(sureSmallToy:) forControlEvents:UIControlEventTouchUpInside];

            }
        }

   }
#pragma mark 选择小玩具兑换礼品
-(void)sureSmallToy:(UIButton*)sender{
    [self.view endEditing:YES];
    NSInteger buttonIndex = sender.tag - 6000;
    ToyGiftItem *item = self.giftSmallArray[buttonIndex];
    [self.giftImgViewSmall sd_setImageWithURL:[NSURL URLWithString:item.img]];
    _backViewSmall.hidden = NO;
    _prize_idSmall = item.prize_id;
    [self.changeGiftBtn addTarget:self action:@selector(makeSureChangeGift) forControlEvents:UIControlEventTouchUpInside];

}
#pragma mark 点击兑换礼品按钮
-(void)makeSureChangeGift{
    [self.view endEditing:YES];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", _prize_idSmall,@"prize_id",nil];
    [[HTTPClient sharedClient]getNewV1:@"AddPrize" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            [BBSAlert showAlertWithContent:@"兑换成功" andDelegate:self];
            [self dissmissBackSmall];
            [self getFriendListData];
        }else{
         
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
        }
    } failed:^(NSError *error) {
    }];

}

#pragma mark delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:_giftTableView]) {
        return _giftDataArray.count;
    }else{
        if (_dataArray.count <= 0) {
            return 1;
        }else{
            return _dataArray.count;
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_giftTableView]) {
        if (indexPath.row == 0) {
            return 67;
        }
        return 57;
    }else{
        if (_dataArray.count <= 0) {
            return 140+40;
        }else{
            return 53;
        }
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_giftTableView]) {
         static NSString *identifer = @"GIFTCHOOSECELL";
        ToyGiftItem *item = [_giftDataArray objectAtIndex:indexPath.row];
        GiftChooseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
        if (cell == nil) {
            cell = [[GiftChooseCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
        }
        CGFloat heightUser;
        CGFloat heightAlert;
        if (item.prize_title.length > 8) {
            heightUser = 35;
            heightAlert = 15;
        }else{
            heightUser = 17;
            heightAlert = 33;
 
        }
        if (indexPath.row == 0) {
            cell.userImg.frame = CGRectMake(10,15,65,47);
            cell.alertLabel.frame = CGRectMake(80, 15+heightUser, 110, heightAlert);
            cell.userLabel.frame = CGRectMake(80, 15, 110, heightUser);
        }else{
            cell.userImg.frame = CGRectMake(10,5,65,47);
            cell.alertLabel.frame = CGRectMake(80, 5+heightUser, 110, heightAlert);
            cell.userLabel.frame = CGRectMake(80, 5, 110, heightUser);
        }
        cell.userLabel.text = item.prize_title;
        cell.alertLabel.text = item.prize_description;
        [cell.userImg sd_setImageWithURL:[NSURL URLWithString:item.img]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;
    }else{
        if (_dataArray.count <= 0) {
            //没有好友的时候
           static NSString *identifer = @"TOYSHARECELLNO";
            ToyShareNoFriendCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
            if (cell == nil) {
                cell = [[ToyShareNoFriendCellTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
    static NSString *identifer = @"TOYSHARECELL";
    ToyShareUserItem *item = [_dataArray objectAtIndex:indexPath.row];
    ToyShareUserCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (cell == nil) {
        cell = [[ToyShareUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    [cell.userImg sd_setImageWithURL:[NSURL URLWithString:item.avatar]];
    cell.userLabel.text = item.nick_name;
    cell.alertLabel.text = item.inv_description;
            if ([item.inv_button isEqualToString:@"0"]) {
                //按钮红色
                [cell.shareBtn setBackgroundImage:[UIImage imageNamed:@"toy_share_accepted"] forState:UIControlStateNormal];
                [cell.shareBtn setTitleColor:[BBSColor hexStringToColor:NAVICOLOR] forState:UIControlStateNormal];
 
            }else{
                //按钮灰色
                [cell.shareBtn setBackgroundImage:[UIImage imageNamed:@"toy_share_noaccept"] forState:UIControlStateNormal];
                [cell.shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
 
            }
    [cell.shareBtn setTitle:item.status_title forState:UIControlStateNormal];
    cell.shareBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
      
        }
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_giftTableView]) {
        ToyGiftItem *item = [_giftDataArray objectAtIndex:indexPath.row];
        [self.chooseGiftBtn setTitle:item.prize_title forState:UIControlStateNormal];
        

        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", item.prize_id,@"prize_id",nil];
        [[HTTPClient sharedClient]getNewV1:@"getToysPrizeList" params:params success:^(NSDictionary *result) {
            if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                NSArray *dataArray = result[@"data"];
                 [_giftSmallArray removeAllObjects];
                _backView.hidden = YES;
                [self getGiftSmall:dataArray];
            }else{
                [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
            }
        } failed:^(NSError *error) {
        }];
    }else{
        //如果没有好友，点击分享
        if (_dataArray.count <= 0) {
            [self shareStoreMeg];
        }
    }
}
#pragma mark 选择礼品页面出现
-(void)chooseGift{
    [self.view endEditing:YES];
    [_giftDataArray removeAllObjects];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"getToysPrizeList" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSArray *dataArray = result[@"data"];
            for (NSDictionary *giftDic in dataArray) {
                ToyGiftItem *item = [[ToyGiftItem alloc]init];
                item.prize_id = giftDic[@"prize_id"];
                item.prize_title = giftDic[@"prize_title"];
                item.prize_description = giftDic[@"prize_description"];
                item.img = giftDic[@"img"];
                item.is_click = giftDic[@"is_click"];
                item.prize_number = giftDic[@"prize_number"];
                [_giftDataArray addObject:item];
            }
            [_giftTableView reloadData];
            _backView.hidden = NO;
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
        }
        
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您的网络出现错误" andDelegate:self];

    }];
    
}
#pragma mark 选择礼品页面消失
-(void)dissmissChooseGiftView{
    _backView.hidden = YES;
}
#pragma mark邀请页面分享
-(void)shareStoreMeg{
    [self.view endEditing:YES];
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.shared_img]]];
    UIImage *weixinImg = shareImg;
    NSData *basicImgData = UIImagePNGRepresentation(shareImg);
    if (basicImgData.length/1024>150) {
        shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
          weixinImg = [self scaleToSize:weixinImg size:CGSizeMake(150, 120)];
        
    }
    NSArray* imageArray = @[shareImg];
    NSString *shareURl = _shareNewUrl;
    NSString *urlString= [NSString stringWithFormat:@"%@",shareURl];
    //NSString *content = [NSString stringWithFormat:@"%@-%@",_toyNameString,self.priceLabel.text];    //    NSLog(@"%@",urlString);return;
    [shareParams SSDKSetupShareParamsByText:self.shared_des
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]
                                      title:self.shared_title
                                       type:SSDKContentTypeAuto];
    
    //设置新浪微博
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",self.shared_des,[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:self.shared_title image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
    
    
    
    [shareParams SSDKSetupWeChatMiniProgramShareParamsByTitle:self.shared_title description:self.shared_des webpageUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] path:self.shareshare_path thumbImage:shareImg hdThumbImage:weixinImg userName:@"gh_740dc1537e7c" withShareTicket:NO miniProgramType:0 forPlatformSubType:SSDKPlatformSubTypeWechatSession];

    
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
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",nil];
                [[HTTPClient sharedClient]getNewV1:@"shareActivitytimes" params:params success:^(NSDictionary *result) {
                    NSLog(@"fengxxxxxxx = %@",result);
                     [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
                    [self  againRequestWebUrl];
                } failed:^(NSError *error) {
                    
                }];
                
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

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger length = textField.text.length;
    //如果没有这个删除不了
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (length >= 11) {
        return NO;
    }
    return YES;
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
