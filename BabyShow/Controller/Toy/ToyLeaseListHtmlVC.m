//
//  ToyLeaseListHtmlVC.m
//  BabyShow
//
//  Created by WMY on 17/1/10.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyLeaseListHtmlVC.h"
#import "RefreshControl.h"
#import "ToyLeaseItem.h"
#import "ToyLeaseListCell.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "ToyLeaseDetailVC.h"
#import "MakeAToyPostVC.h"
#import "ToyTransportVC.h"
#import "NIAttributedLabel.h"
#import "LoginHTMLVC.h"
#import "WebViewController.h"
#import "MyDepositVC.h"

@interface ToyLeaseListHtmlVC ()<UIWebViewDelegate>
@property (nonatomic,weak) JSContext * context;
@property (nonatomic, strong)UIWebView *webview;

@end

@implementation ToyLeaseListHtmlVC
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.tabBarController.tabBar.hidden = YES;

}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
     [self setWebview];
    
    // Do any additional setup after loading the view.
}
-(void)setWebview{
//    UIView *statusBarView = [[UIView alloc]initWithFrame:CGRectMake(0, -20,SCREENWIDTH, 50)];
//    statusBarView.backgroundColor = [BBSColor hexStringToColor:@"888888"];
//   // [self.view addSubview:statusBarView];
    self.webview=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    self.webview.scrollView.bounces = NO;
    self.webview.scalesPageToFit=YES;
    self.webview.autoresizesSubviews=NO;
    self.webview.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webview.delegate=self;
    [self.view addSubview:self.webview];
    NSString *urlStr = @"http://www.meimei.yihaoss.top/H5/toy/toy.html";
    NSURL *url=[NSURL URLWithString:urlStr];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
    NSLog(@"url = %@",url);
  
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _context[@"callMethodIsLogin"] = ^(){
        UserInfoManager *manager=[[UserInfoManager alloc]init];
        UserInfoItem *userItem=[manager currentUserInfo];
        if ([userItem.isVisitor boolValue] == YES || LOGIN_USER_ID == NULL) {
            return NO;
        }else{
            return YES;
        }
    };
    //弹出登录页面
    _context[@"callMethodToLoginPage"] = ^(){
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
 
    };
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
