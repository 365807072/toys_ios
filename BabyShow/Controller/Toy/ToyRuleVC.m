//
//  ToyRuleVC.m
//  BabyShow
//
//  Created by WMY on 17/3/27.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyRuleVC.h"

@interface ToyRuleVC ()
@property (nonatomic, strong)UIWebView *webview;

@end

@implementation ToyRuleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBackBtn];
    [self setWebview];

    // Do any additional setup after loading the view.
}
-(void)setBackBtn{
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
-(void)back{
        [self.navigationController popViewControllerAnimated:YES];
}
-(void)setWebview{
    //    UIView *statusBarView = [[UIView alloc]initWithFrame:CGRectMake(0, -20,SCREENWIDTH, 50)];
    //    statusBarView.backgroundColor = [BBSColor hexStringToColor:@"888888"];
    //   // [self.view addSubview:statusBarView];
    self.webview=[[UIWebView alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH, SCREENHEIGHT+60)];
    self.webview.scrollView.bounces = NO;
    self.webview.scalesPageToFit=YES;
    self.webview.autoresizesSubviews=NO;
    self.webview.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webview.delegate=self;
    [self.view addSubview:self.webview];
    NSString *urlStr = @"https://api.meimei.yihaoss.top/H5/invite/active_aules.html";
    NSString *urlShare = [NSString stringWithFormat:@"%@?login_user_id=%@",urlStr,LOGIN_USER_ID];
    NSURL *url=[NSURL URLWithString:urlShare];
    NSURLRequest *request = [NSMutableURLRequest
                                requestWithURL:url
                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                                timeoutInterval:60.0f];
    [self.webview loadRequest:request];
    NSLog(@"url = %@",url);
    
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
