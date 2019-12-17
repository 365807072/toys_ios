//
//  ChangeToySucceedVC.m
//  BabyShow
//
//  Created by 美美 on 2017/12/15.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ChangeToySucceedVC.h"

@interface ChangeToySucceedVC ()
@property(nonatomic,strong)UIWebView *bookToysWebView;//首页玩具


@end

@implementation ChangeToySucceedVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAllwebView];

    [self setBackButton];
    self.navigationItem.title = @"福利";
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"福利";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault]; [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.automaticallyAdjustsScrollViewInsets=NO;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [BBSColor hexStringToColor:NAVICOLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; [self.navigationController.navigationBar setShadowImage:nil];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
}

-(void)setAllwebView{
    _bookToysWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    _bookToysWebView.scrollView.bounces = NO;
    _bookToysWebView.scalesPageToFit=YES;
    _bookToysWebView.autoresizesSubviews=NO;
    _bookToysWebView.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _bookToysWebView.delegate=self;
    [self.view addSubview:_bookToysWebView];
    NSURL *url=[NSURL URLWithString:self.postUrl];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    [_bookToysWebView loadRequest:request];
    
}


-(void)setBackButton{
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
