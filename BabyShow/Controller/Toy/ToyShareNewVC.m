//
//  ToyShareNewVC.m
//  BabyShow
//
//  Created by 美美 on 2018/9/7.
//  Copyright © 2018年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyShareNewVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "ToyLeaseDetailVC.h"
#import <ShareSDKExtension/ShareSDK+Extension.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>



@interface ToyShareNewVC ()
@property(nonatomic,strong)UIWebView *bookToysWebView;//首页玩具
@property(nonatomic,weak)JSContext *context;
@property(nonatomic,strong)NSURL *requestUrl;
@property(nonatomic,strong)NSString *shareImg;
@property(nonatomic,strong)NSString *shareUrl;
@property(nonatomic,strong)NSString *shareMainDes;
@property(nonatomic,strong)NSString *shareTitle;
@property(nonatomic,strong)NSString *sharePath;
@property(nonatomic,strong)NSString *barColor;



@end

@implementation ToyShareNewVC

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
    [[HTTPClient sharedClient]getNewV1:@"GetToysIcon" params:@{@"login_user_id":LOGIN_USER_ID} success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = result[@"data"];
            NSString *urlString = data[@"post_url"];
            _barColor = data[@"status_color"];
            
            NSString *urlEncoding = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            _requestUrl = [NSURL URLWithString:urlEncoding];
            [self setAllWebView];

        }
    } failed:^(NSError *error) {
    }];
    // Do any additional setup after loading the view.
}
//加载预约玩具页面
-(void)setAllWebView{
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *backview = [[UIView alloc]init];
    backview.backgroundColor = [BBSColor hexStringToColor:_barColor ];
    if (ISIPhoneX) {
        backview.frame = CGRectMake(0,0, SCREEN_WIDTH, StatusBar_HEIGHT);
    }else{
        backview.frame = CGRectMake(0,0, SCREEN_WIDTH, 20);
    }
    backview.userInteractionEnabled = YES;
    [self.view addSubview:backview];
    
    self.bookToysWebView = [[UIWebView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREENHEIGHT)];
    if (ISIPhoneX) {
        self.bookToysWebView.frame = CGRectMake(0, StatusBar_HEIGHT, SCREEN_WIDTH, SCREENHEIGHT-StatusBar_HEIGHT-34);
    }else{
        self.bookToysWebView.frame = CGRectMake(0, -StatusBar_HEIGHT, SCREENWIDTH, SCREENHEIGHT+StatusBar_HEIGHT);
    }

    [self.view addSubview:self.bookToysWebView];
    NSURLRequest *request = [NSURLRequest requestWithURL:_requestUrl cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:20.0];
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
    
    _context[@"callMethodHindTitle"] = ^(){
    };
    
    _context[@"callMethodFinish"] = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self back];
        });
    };
    
    //分享的参数
    _context[@"showSheredInfo"] = ^(){
        NSArray *args = [JSContext currentArguments];
        NSLog(@"分享数据分享数据 = %@",args);
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
}
- (void)shareToThird {
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSString *shareImgString = [NSString stringWithFormat:@"%@",_shareImg];
    UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareImgString]]];
    UIImage *weixinImg = shareImg;
    NSData *basicImgData = UIImagePNGRepresentation(shareImg);
    NSLog(@"bbbbbbasicimgdata  = %ld",basicImgData.length/1024);
    if (basicImgData.length/1024>150) {
        shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
        weixinImg = [self scaleToSize:weixinImg size:CGSizeMake(150, 120)];
        NSData *weixinImgData = UIImagePNGRepresentation(shareImg);

        NSLog(@"bbbbbbasicimgdata  = %ld",weixinImgData.length/1024);

        
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
