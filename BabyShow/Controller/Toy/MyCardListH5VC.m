//
//  MyCardListH5VC.m
//  BabyShow
//
//  Created by 美美 on 2018/8/4.
//  Copyright © 2018年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyCardListH5VC.h"
#import "ToyTransportVC.h"

@interface MyCardListH5VC ()
@property(nonatomic,strong)UIWebView *cardToysWebView;//首页玩具
@property(nonatomic,weak)JSContext *context;


@end

@implementation MyCardListH5VC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setAllWebView];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UISearchBarStyleDefault;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    
}
//加载预约玩具页面
-(void)setAllWebView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.cardToysWebView = [[UIWebView alloc]init];//WithFrame:CGRectMake(0,20, SCREEN_WIDTH, SCREENHEIGHT-20)];
    UIView *backview = [[UIView alloc]init];
    backview.backgroundColor = [UIColor whiteColor];
    if (ISIPhoneX) {
        backview.frame = CGRectMake(0,0, SCREEN_WIDTH, 50);
    }else{
        backview.frame = CGRectMake(0,0, SCREEN_WIDTH, 20);
    }

    
    [self.view addSubview:backview];
    self.cardToysWebView.frame = CGRectMake(0,backview.frame.size.height, SCREEN_WIDTH, SCREENHEIGHT);
    if (ISIPhoneX) {
        self.cardToysWebView.frame =CGRectMake(0,backview.frame.size.height, SCREEN_WIDTH, SCREENHEIGHT);
    }else{
        self.cardToysWebView.frame =CGRectMake(0,backview.frame.size.height, SCREEN_WIDTH, SCREENHEIGHT-20);
    }


    [self.view addSubview:self.cardToysWebView];
    NSString *urlString = [NSString stringWithFormat:@"https://api.meimei.yihaoss.top/H5/toy_count/cardList.html?login_user_id=%@",LOGIN_USER_ID];
    NSLog(@"预约页面的功能 = %@",urlString);
    NSString *urlEncoding = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *url = [NSURL URLWithString:urlEncoding];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    [self.cardToysWebView loadRequest:request];
    self.cardToysWebView.scrollView.bounces = NO;
    self.cardToysWebView.scalesPageToFit = NO;
    self.cardToysWebView.autoresizesSubviews = NO;
    self.cardToysWebView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    self.cardToysWebView.delegate = self;
    _context = [self.cardToysWebView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
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
    _context[@"callMethodToOrderDetail"] = ^(){
        NSArray *args = [JSContext currentArguments];
        NSString *toyId = args[0];
        NSLog(@"跳转订单详情");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self pushDetailToyPage:toyId];
        });
        
    };
    //添加会员卡
    _context[@"callMethodToToysMain"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            _isRefreshInVC = YES;
            NSLog(@"添加会员卡");
                   self.refreshInVC(_isRefreshInVC);

            [self.navigationController popViewControllerAnimated:YES];
        });


    };
    
    
}

#pragma mark 跳转玩具详情
-(void)pushDetailToyPage:(NSString *)toyID{
    ToyTransportVC *toyTransportVC = [[ToyTransportVC alloc]init];
    toyTransportVC.order_id = toyID;
    toyTransportVC.fromWhere = @"5";
    [self.navigationController pushViewController:toyTransportVC animated:YES];
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
