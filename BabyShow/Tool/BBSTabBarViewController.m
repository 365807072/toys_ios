//
//  BBSTabBarViewController.m
//  BabyShow
//
//  Created by 于 晓波 on 12/21/13.
//  Copyright (c) 2013 Yuanyuanquanquan.com. All rights reserved.
//

#import "BBSTabBarViewController.h"
#import "PostBarNewVC.h"
#import "WorthBuyViewController.h"
#import "GrowthDiaryViewController.h"
#import "BBSCommonNavigationController.h"
#import "VisitorAlbumViewController.h"
#import "UserInfoItem.h"
#import "MyHomeNewVersionVC.h"
#import "LoginHTMLVC.h"
#import "BabyMainNewVC.h"
#import "PostBarNewMakeAPost.h"
#import "StoreMoreListVC.h"
#import "PostBarGroupNewVC.h"
#import "ToyLeaseNewVC.h"


@interface BBSTabBarViewController ()<LoginHTMLVCDelegate>
@property(nonatomic,strong)    MyHomeNewVersionVC *myVHomePag;
@end

@implementation BBSTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    if ([[[UIDevice currentDevice] systemVersion]floatValue] >= 7.0) {
        
            [self _initViewController];//初始化UITabBarController中的控制器
     //   }
        [self _initTabbarView];
        
    }else{}
    
}
-(BOOL)shouldAutorotate{
    return NO;
}

-(void)_initVisitorController{
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *userid=LOGIN_USER_ID;
    //新版开始
   // BabyShowNewMainVC *newMyShow=[[BabyShowNewMainVC alloc]init];
    //newMyShow.navigationItem.title=@"秀秀";
    BabyMainNewVC *newMyShow = [[BabyMainNewVC alloc]init];
    BBSCommonNavigationController *myshowNV=[[BBSCommonNavigationController alloc]initWithRootViewController:newMyShow];
    //相册
    VisitorAlbumViewController *visitorVC=[[VisitorAlbumViewController alloc]init];
    visitorVC.navigationItem.title=@"成长记录";
    BBSCommonNavigationController *visitorNC=[[BBSCommonNavigationController alloc]initWithRootViewController:visitorVC];
    //游客
    _myVHomePag=[[MyHomeNewVersionVC alloc]init];
    _myVHomePag.navigationItem.title=@"游客主页";
    _myVHomePag.Type=3;
    _myVHomePag.userid=userid;
    BBSCommonNavigationController *myHomePageNV=[[BBSCommonNavigationController alloc]initWithRootViewController:_myVHomePag];
    
    

    NSArray *nvArray=[NSArray arrayWithObjects:myshowNV,visitorNC,myHomePageNV, nil];
    
    self.viewControllers = nvArray;
    
}

-(void)_initViewController {
    
    UserInfoManager *manager = [[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    NSString *userid = userItem.userId ;
    
    BabyMainNewVC *babyShow = [[BabyMainNewVC alloc]init];
    
    BBSCommonNavigationController *babyShowNV = [[BBSCommonNavigationController alloc]initWithRootViewController:babyShow];
    /**
     之后开掉
     */
    //相册
    GrowthDiaryViewController *photoVC=[[GrowthDiaryViewController alloc]init];
    photoVC.navigationItem.title=@"成长记录";
    BBSCommonNavigationController *photoNC=[[BBSCommonNavigationController alloc]initWithRootViewController:photoVC];
    
    
    
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.navigationItem.title=@"登陆完主页";
    myHomePage.Type=3;
    myHomePage.userid=userid;
    BBSCommonNavigationController *myHomePageNV=[[BBSCommonNavigationController alloc]initWithRootViewController:myHomePage];
    
    //玩具世界
    ToyLeaseNewVC *toyLeaseNew = [[ToyLeaseNewVC alloc]init];
    toyLeaseNew.fromMain = @"main";
    
    BBSCommonNavigationController *toyLeaseNewVC = [[BBSCommonNavigationController alloc]initWithRootViewController:toyLeaseNew];
    
    //商家页面
    StoreMoreListVC *storeListVC = [[StoreMoreListVC alloc]init];
    BBSCommonNavigationController *storeVC = [[BBSCommonNavigationController alloc]initWithRootViewController:storeListVC];
    
    
    NSArray *nvArray=[NSArray arrayWithObjects:babyShowNV,toyLeaseNewVC,photoNC,myHomePageNV, nil];
    self.viewControllers = nvArray;
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    CGRect frame = self.tabBar.frame;
    frame.size.height = TabbarHeight;
    frame.origin.y = [UIScreen mainScreen].bounds.size.height - TabbarHeight;
    self.tabBar.frame = frame;
    self.tabBar.backgroundColor = [UIColor whiteColor];
}


- (void)_initTabbarView {
    _tabbarView = [[UIView alloc]init];
    if (ISIPhoneX == YES) {
        NSLog(@"我是xxx");
        _tabbarView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 50);
        _tabbarView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREEN_WIDTH, 34)];
        whiteView.backgroundColor = [BBSColor hexStringToColor:@"f3f3f3" alpha:0.5];
        [self.tabBar addSubview:whiteView];
    }else{
        _tabbarView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 42);
_tabbarView.backgroundColor = [UIColor whiteColor];
        NSLog(@"我bu是xxx");
    }
   // _tabbarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 42)];//49为tabBar的高度
    // _tabbarView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_tabbar.png"]];//设置tabBar的背景颜色
    //_tabbarView.backgroundColor = [UIColor whiteColor];
    
    [self.tabBar addSubview:_tabbarView];
    
    _backgroud = @[@"tab_myshow",@"tab_toy_world",@"tab_diary",@"tab_home"];//tabBarItem中的按钮
    
    _heightBackground = @[@"tab_myshow_selected",@"tab_toy_world",@"tab_diary_selected",@"tab_home_selected"];
    //tabBarItem中高亮时候的按钮
    //将按钮添加到自定义的_tabbarView中，并为按钮设置tag（tag从0开始）
    
    _btnArray=[[NSMutableArray alloc]init];
    
    for (int i=0; i<_backgroud.count; i++) {
        NSString *backImage = _backgroud[i];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        if (ISIPhoneX == YES) {
            button.frame = CGRectMake(i*(SCREEN_WIDTH/4), 0, SCREEN_WIDTH/4, 50);

        }else{
            button.frame = CGRectMake(i*(SCREEN_WIDTH/4), 0, SCREEN_WIDTH/4, 42);

        }
        
        button.tag = i;
        [button setImage:[UIImage imageNamed:backImage] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(selectedTab:) forControlEvents:UIControlEventTouchUpInside];
        [_tabbarView addSubview:button];
        button.adjustsImageWhenHighlighted = NO;
        [_btnArray addObject:button];
    }
    
    _badgeValueLabel=[[UILabel alloc]initWithFrame:CGRectMake(290, 0, 20, 20)];
    _badgeValueLabel.backgroundColor=[UIColor redColor];
    _badgeValueLabel.textColor=[UIColor whiteColor];
    _badgeValueLabel.font=[UIFont systemFontOfSize:10];
    _badgeValueLabel.textAlignment=NSTextAlignmentCenter;
    _badgeValueLabel.text=@"";
    _badgeValueLabel.layer.masksToBounds=YES;
    _badgeValueLabel.layer.cornerRadius=10;
    //[_tabbarView addSubview:_badgeValueLabel];
    [_badgeValueLabel setHidden:YES];
    
    [self selectedTab:[_btnArray objectAtIndex:0]];
}

//点击按钮后显示哪个控制器界面
- (void)selectedTab:(UIButton *)button {
    
    for (UIButton *btn in _btnArray) {
        if (btn==button) {
            [btn setImage:[UIImage imageNamed:[_heightBackground objectAtIndex:btn.tag]] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:[_backgroud objectAtIndex:btn.tag]] forState:UIControlStateNormal];
        }
    }
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    self.selectedIndex = button.tag;
    
    if (self.selectedIndex == 3) {
        if ([userItem.isVisitor boolValue] == YES ||userItem.userId == NULL) {
            [self loginIn];
        }
    }
    
    
}
-(void)makeAPostPresent{
    PostBarNewMakeAPost *postBarNewMakeApost = [[PostBarNewMakeAPost alloc]init];
    postBarNewMakeApost.isFromMain = @"isFromMain";
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"CheckGroup" params:dic success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = [result objectForKey:@"data"];
            NSString *groupId = data[@"group_id"];
            if (groupId.length>0) {
                postBarNewMakeApost.groupId = data[@"group_id"];
                postBarNewMakeApost.groupName = data[@"group_name"];
                postBarNewMakeApost.isHiddenGroup = NO;
            }else{
                postBarNewMakeApost.isHiddenGroup = YES;

            }
            BBSCommonNavigationController *nav = [[BBSCommonNavigationController alloc]initWithRootViewController:postBarNewMakeApost];
            [self performSelector:@selector(preVC:) withObject:nav afterDelay:0.3];

        }
    } failed:^(NSError *error) {
        BBSCommonNavigationController *nav = [[BBSCommonNavigationController alloc]initWithRootViewController:postBarNewMakeApost];
        [self performSelector:@selector(preVC:) withObject:nav afterDelay:0.3];

    }];


}
#pragma mark 
-(void)preVC:(BBSCommonNavigationController*)nav{
    [self presentViewController:nav animated:YES completion:NULL];
 
}
//登陆
-(void)loginIn{
    
    [self loginIn:YES];
}
//登陆是取消还是正常
-(void)loginIn:(BOOL)cancel{
    LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
    loginVC.fromTabBar = @"fromTabBar";
    loginVC.delegate = self;
    BBSCommonNavigationController *nav = [[BBSCommonNavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:NULL];
    
}
-(void)setBBStabbarSelectedIndex:(NSInteger)index{
    
    for (UIButton *btn in _btnArray) {
        if (btn.tag==index) {
            [btn setImage:[UIImage imageNamed:[_heightBackground objectAtIndex:btn.tag]] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:[_backgroud objectAtIndex:btn.tag]] forState:UIControlStateNormal];
        }
    }
    self.selectedIndex = index;
    
}
-(void)setHidesBottomBarWhenPushed:(BOOL)hidesBottomBarWhenPushed{
    
    [_tabbarView setHidden:hidesBottomBarWhenPushed];
    self.tabBar.hidden=NO;
    
}

-(void)setbadgeValue:(NSString *)value{
    
    if (value && value.length) {
        _badgeValueLabel.text=value;
        [_badgeValueLabel setHidden:NO];
    }else{
        [_badgeValueLabel setHidden:YES];
    }
    
}
-(void)loginViewControllerDimissDelegate{
    if (self.selectedIndex == 2) {
        [self setBBStabbarSelectedIndex:1];

    }else if(self.selectedIndex == 3){
    }
    self.selectedIndex = 0;
    [self setBBStabbarSelectedIndex:0];
}
@end
