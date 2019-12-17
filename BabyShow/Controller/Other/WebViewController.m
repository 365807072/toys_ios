//
//  WebViewController.m
//  BabyShow
//
//  Created by Lau on 8/1/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "WebViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "ShowAlertView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "LoginHTMLVC.h"
#import "ToyLeaseDetailVC.h"

@interface WebViewController ()
@property (nonatomic,weak) JSContext * context;
@property (nonatomic, strong)UIWebView *webview;
@property (nonatomic, strong) UIButton *refreshBtn;
@property(nonatomic,strong)NSString *shareImg;
@property(nonatomic,strong)NSString *shareUrl;
@property(nonatomic,strong)NSString *shareMainDes;
@property(nonatomic,strong)NSString *shareTitle;
@property(nonatomic,strong)NSString *sharePath;
@property(nonatomic,strong)NSString *hideTitle;
@property(nonatomic,strong)UIView *backview;
@property(nonatomic,strong)NSString *backgroupColor;//不显示头部的时候的按钮颜色
@end


@implementation WebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UISearchBarStyleDefault;
    self.tabBarController.tabBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets=NO;
    if (_hideTitle.length == 0   || [_hideTitle isEqualToString:@"1"]) {
        [self showTitle];
    }else{
        [self hiddenTitle];
    }

    
}
-(void)hiddenTitle{
    //隐藏头部
    if (ISIPhoneX) {
        _backview.frame = CGRectMake(0,0, SCREEN_WIDTH, 50);
    }else{
        _backview.frame = CGRectMake(0,0, SCREEN_WIDTH, 20);
    }
    _backview.backgroundColor = [BBSColor hexStringToColor:_backgroupColor];
    
    if (ISIPhoneX) {
        self.webview.frame =CGRectMake(0,_backview.frame.size.height, SCREEN_WIDTH, SCREENHEIGHT);
    }else{
        self.webview.frame =CGRectMake(0,_backview.frame.size.height, SCREEN_WIDTH, SCREENHEIGHT-20);
    }
    [UIApplication sharedApplication].statusBarStyle = UISearchBarStyleDefault;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    self.automaticallyAdjustsScrollViewInsets=NO;

    
}
//展示头部
-(void)showTitle{
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barTintColor = [BBSColor hexStringToColor:NAVICOLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:[self imageWithColor:[BBSColor hexStringToColor:NAVICOLOR] size:self.navigationController.navigationBar.bounds.size] forBarMetrics:UIBarMetricsDefault]; [self.navigationController.navigationBar setShadowImage:nil];
    if (ISIPhoneX) {
        self.webview.frame = CGRectMake(0, 84, SCREEN_WIDTH, SCREENHEIGHT-84-IPhoneXSafeHeight-10);
    }else{
        self.webview.frame = CGRectMake(0,64, SCREEN_WIDTH, SCREENHEIGHT-84);
    }

}
-(void)viewWillDisappear:(BOOL)animated{
   // [self.webview removeFromSuperview];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;

 // NSString *url = @"https://api.baobaoshowshow.com/H5/invite/ceshi.html";
   // self.urlStr =[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    _backview = [[UIView alloc]init];
    _backview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_backview];

    [self setBackBtn];
    [self setWebview];
    //[self markBuyUrl];
}

-(void)setRefreshBtn{
    
    self.refreshBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.refreshBtn.frame=CGRectMake(277, 5, 33, 33);
    [self.refreshBtn setBackgroundImage:[UIImage imageNamed:@"btn_diary_share"] forState:UIControlStateNormal];
    
    [self.refreshBtn addTarget:self action:@selector(refresh) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *refresh=[[UIBarButtonItem alloc]initWithCustomView:_refreshBtn];
    self.navigationItem.rightBarButtonItem=refresh;
    self.refreshBtn.hidden = YES;
    
}

-(void)setWebview{
    
    self.webview = [[UIWebView alloc]init];
    self.webview.frame = CGRectMake(0,64, SCREEN_WIDTH, SCREENHEIGHT-64);
    self.webview.scrollView.bounces = NO;
    self.webview.scalesPageToFit=NO;
    self.webview.autoresizesSubviews=NO;
    self.webview.autoresizingMask=UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.webview.delegate=self;
    [self.view addSubview:self.webview];
    
    NSURL *url=[NSURL URLWithString:self.urlStr];
    NSLog(@"urlurl = %@",url);
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    [self.webview loadRequest:request];
    _context = [self.webview valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    NSLog(@"url = %@",url);
    //是否展示头部和页面的frame
    _hideTitle = @"";
    _context[@"callMethodHindTitle"] = ^(){
        NSArray *args = [JSContext currentArguments];
        _hideTitle = [NSString stringWithFormat:@"%@",args[0]];
        _backgroupColor = [NSString stringWithFormat:@"%@",args[1]];
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([_hideTitle isEqualToString:@"0"]) {
                [self hiddenTitle];
            }else{
                //不隐藏头部
                [self showTitle];
            }

        });

      
    };
    if (_hideTitle.length == 0   || [_hideTitle isEqualToString:@"1"]) {
        //展示
        [self showTitle];
    }
    //跳转返回
    _context[@"callMethodFinish"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self back];
            
        });
    };
    
    //弹出登录页面
    _context[@"callMethodToLoginPage"] = ^(){
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
    };
    //登录与否
    _context[@"callMethodIsLogin"] = ^(){
        UserInfoManager *manager=[[UserInfoManager alloc]init];
        UserInfoItem *userItem=[manager currentUserInfo];
        if ([userItem.isVisitor boolValue] == YES || LOGIN_USER_ID == NULL) {
            return NO;
        }else{
            return YES;
        }
    };
    //用户的ID
    _context[@"callMethodGetLoginUserId"] = ^(){
        NSString *loginId = LOGIN_USER_ID;
        NSLog(@"longin  =%@",loginId);
        return loginId;
    };
    //分享的参数
    _context[@"showSheredInfo"] = ^(){
        NSArray *args = [JSContext currentArguments];
        _shareImg = args[0];
        _shareMainDes = args[1];
        _shareTitle = args[2];
        _sharePath = args[3];
        _shareUrl = args[4];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self shareToThird];
        });
    };
    //进入玩具详情
    _context[@"callMethodToToysDetail"] = ^(){
        NSArray *args = [JSContext currentArguments];
        NSString *toyId = args[0];
        NSLog(@"跳转玩具详情");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self pushDetailToyPage:toyId];
        });
        
    };


   // [LoadingView startOnTheViewController:self];
}
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)markBuyUrl {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.img_id,@"img_id", nil];
    [[HTTPClient sharedClient] postNew:kMarkBuyUrl params:params success:^(NSDictionary *result) {
    } failed:^(NSError *error) {
        
    }];
    
}
-(void)refresh{
    [self shareToThird];
    
}
- (void)shareToThird {
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSString *shareImgString = [NSString stringWithFormat:@"%@",_shareImg];
    UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImgString]]];
    UIImage *weixinImg = shareImg;
    NSData *basicImgData = UIImagePNGRepresentation(shareImg);
    if (basicImgData.length/1024>150) {
        shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
        weixinImg = [self scaleToSize:weixinImg size:CGSizeMake(150, 120)];
        
    }
    NSArray* imageArray = @[shareImg];
    NSString *urlString = self.shareUrl;//[NSString stringWithFormat:@"%@%@",BuyShareUrl,self.urlStr];
    [shareParams SSDKSetupShareParamsByText:_shareMainDes
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]
                                      title:_shareTitle
                                       type:SSDKContentTypeAuto];
    //设置新浪微博
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",_shareMainDes,[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:_shareTitle image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
    [shareParams SSDKSetupWeChatMiniProgramShareParamsByTitle:_shareTitle description:_shareMainDes webpageUrl:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] path:_sharePath thumbImage:shareImg hdThumbImage:weixinImg userName:@"gh_740dc1537e7c" withShareTicket:NO miniProgramType:0 forPlatformSubType:SSDKPlatformSubTypeWechatSession];

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
#pragma mark 跳转玩具详情
-(void)pushDetailToyPage:(NSString *)toyID{
    ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
    toyDetailVC.business_id = toyID;
    [self.navigationController pushViewController:toyDetailVC animated:YES];
}

- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (void)copyURL:(NSString *)string {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:string];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark UIWebViewDelegate

-(void)webViewDidStartLoad:(UIWebView *)webView{
    
    self.refreshBtn.enabled=NO;
//    if ([self.urlStr rangeOfString:@"tmall"].location != NSNotFound) {
//        //天猫
//        [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('app-download-popup smally show')[0].remove();"];
//        [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('app-download-popup-inner')[0].remove();"];
//        [self.webview stringByEvaluatingJavaScriptFromString: @"document.getElementById('detail-smart-banner').style.visibility='hidden';document.getElementById('detail-smart-banner').style.display='none';"];
//        [self.webview stringByEvaluatingJavaScriptFromString: @"document.getElementById('detail-base-smart-banner')[0].remove();"];
//        [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('mui-sb-box')[0].remove();"];
//        [self.webview stringByEvaluatingJavaScriptFromString:@"document.activeElement.blur();"];
//    }
    
    
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
   // [_webview stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"LoginSucessMassage('%@'）;",LOGIN_USER_ID]];
    
    
//    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
//    [[NSUserDefaults standardUserDefaults] synchronize];
//
//    self.refreshBtn.enabled=YES;
//        [LoadingView stopOnTheViewController:self];
//    NSLog(@"加载成功了");
//    if ([self.urlStr rangeOfString:@"tmall"].location != NSNotFound) {
//
//        //天猫
//        [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('app-download-popup smally show')[0].style.display = 'none';"];
//        [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('mui-sb-box')[0].style.display = 'none';"];
//        [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementById('detail-base-smart-banner')[0].style.display = 'none';"];
//        //天猫
//        [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('app-download-popup smally show')[0].remove();"];
//        [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('app-download-popup-inner')[0].remove();"];
//        [self.webview stringByEvaluatingJavaScriptFromString: @"document.getElementById('detail-base-smart-banner')[0].remove();"];
//        [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('mui-sb-box')[0].remove();"];
//        [self.webview stringByEvaluatingJavaScriptFromString:@"document.activeElement.blur();"];
//
//    }else if([self.urlStr rangeOfString:@"taobao"].location != NSNotFound){
//        //淘宝
//        [self.webview stringByEvaluatingJavaScriptFromString:@"var a = document.createElement('style');a.innerHTML = '[id][class][style=\"display: block;\"]{display:none!important;}body{padding-top:0!important;}';document.body.appendChild(a);"];
//        [self.webview stringByEvaluatingJavaScriptFromString:@"var a = document.createElement('style');a.innerHTML = '[id][class][style=\"display: block; position: relative; z-index: 0;\"]{display:none!important;}body{padding-top:0!important;}';document.body.appendChild(a);"];
//        NSLog(@"淘宝淘宝是淘宝的");
//
//    }else if([self.urlStr rangeOfString:@"jd"].location != NSNotFound){
//        // 京东
//        [self.webview stringByEvaluatingJavaScriptFromString: @"document.getElementsByClassName('tryme')[0].remove();"];
//        [self.webview stringByEvaluatingJavaScriptFromString: @"document.getElementsByClassName('download-con')[0].remove();"];
//        NSLog(@"是京东的是京东的");
//
//    }else{
//        NSLog(@"其他的其他的");
//
//        //蜜芽网下载链接删除
//        [self.webview stringByEvaluatingJavaScriptFromString: @"document.getElementsByClassName('app_down appdtop_wrap')[0].remove();"];
//        [self.webview stringByEvaluatingJavaScriptFromString:@"var a = document.createElement('style');a.innerHTML = '[id][class][style=\"display: block; -webkit-transform-origin: 0px 0px 0px; opacity: 1; -webkit-transform: scale(1, 1);\"]{display:none!important;}body{padding-top:0!important;}';document.body.appendChild(a);"];
//        [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementsByClassName('pop-content i2app-pop')[0].remove();"];
//
//    }
    
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [LoadingView stopOnTheViewController:self];
    
}

-(void)showHUDWithMessage:(NSString *)message{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60,64+20+50+50+50+5 , 200, 30)];
    label.backgroundColor = [UIColor darkGrayColor];
    label.layer.cornerRadius = 3.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:14];
    label.alpha=0.5;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [self.view addSubview:label];
    [UIView commitAnimations];
    [self performSelector:@selector(remove:) withObject:label afterDelay:1.5];
    
}
-(void)remove:(UILabel *)label{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [label removeFromSuperview];
    [UIView commitAnimations];
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

@end
