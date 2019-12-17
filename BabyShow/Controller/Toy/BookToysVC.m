//
//  BookToysVC.m
//  BabyShow
//
//  Created by 美美 on 2017/10/10.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "BookToysVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "ToyLeaseDetailVC.h"

@interface BookToysVC ()
@property(nonatomic,strong)UIWebView *bookToysWebView;//首页玩具
@property(nonatomic,weak)JSContext *context;


@end

@implementation BookToysVC

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UISearchBarStyleDefault;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAllWebView];
    // Do any additional setup after loading the view.
}
//加载预约玩具页面
-(void)setAllWebView{
    UIView *backview = [[UIView alloc]init];
    backview.backgroundColor = [UIColor whiteColor];
    if (ISIPhoneX) {
        backview.frame = CGRectMake(0,0, SCREEN_WIDTH, 50);
    }else{
        backview.frame = CGRectMake(0,0, SCREEN_WIDTH, 20);
    }
    [self.view addSubview:backview];

    self.bookToysWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0,backview.frame.size.height, SCREEN_WIDTH, SCREENHEIGHT)];
    if (ISIPhoneX) {
        self.bookToysWebView.frame =CGRectMake(0,backview.frame.size.height, SCREEN_WIDTH, SCREENHEIGHT);
    }else{
        self.bookToysWebView.frame =CGRectMake(0,backview.frame.size.height, SCREEN_WIDTH, SCREENHEIGHT-20);
    }
    

    [self.view addSubview:self.bookToysWebView];
    NSString *urlString = [NSString stringWithFormat:@"https://api.meimei.yihaoss.top/H5/toy_count/bespeak.html?login_user_id=%@",LOGIN_USER_ID];
    NSLog(@"预约页面的功能 = %@",urlString);
    NSString *urlEncoding = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    [self.bookToysWebView loadRequest:request];
    self.bookToysWebView.scrollView.bounces = NO;
    self.bookToysWebView.scalesPageToFit = NO;
    self.bookToysWebView.autoresizesSubviews = NO;
    self.bookToysWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.bookToysWebView.delegate = self;
    _context = [self.bookToysWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _context[@"callMethodGetLoginUserId"] = ^(){
        NSString *loginId = LOGIN_USER_ID;
        return loginId;
    };
    
    
    _context[@"callMethodFinish"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self back];
            
        });
    };
    
    //4.进入玩具详情
    _context[@"callMethodToToysDetail"] = ^(){
        NSArray *args = [JSContext currentArguments];
        NSString *toyId = args[0];
        NSLog(@"跳转玩具详情");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self pushDetailToyPage:toyId];
        });
        
    };

    
}

#pragma mark 跳转玩具详情
-(void)pushDetailToyPage:(NSString *)toyID{
    ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
    toyDetailVC.business_id = toyID;
    [self.navigationController pushViewController:toyDetailVC animated:YES];
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    //7.获取用户的现在的loginid
    
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
