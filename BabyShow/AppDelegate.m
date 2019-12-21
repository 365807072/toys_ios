
//
//  AppDelegate.m
//  BabyShow
//
//  Created by Lau on 13-12-9.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "AppDelegate.h"
#import "BBSNavigationControllerNotTurn.h"
#import "UserInfoItem.h"
#import "BBSHasLogIn.h"
#import "LeadingViewController.h"
#import "APService.h"
#import <AlipaySDK/AlipaySDK.h>
#import "BBSAlert.h"
#import <QMapKit/QMapKit.h>
#import "FirstLanchAppVC.h"
#import <SMS_SDK/SMSSDK.h>
//#import <SMS_SDK/SMSSDK+AddressBookMethods.h>
#import "UIImageView+WebCache.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"
#import "WeiboSDK.h"
#import "PostBarNewDetialV1VC.h"
#import "StoreMoreListVC.h"
#import "BBSCommonNavigationController.h"
#import "BabyShowPlayerVC.h"
#import "PostBarListNewVC.h"
#import "StoreDetailNewVC.h"
#import "PostBarGroupNewVC.h"
#import "WebViewController.h"
#import "MyOrdersViewController.h"
#import "PostBarNewGroupOnlyOneVC.h"
#import "ToyTransportVC.h"
#import "ToyLeaseDetailVC.h"
#import "ToyLeaseNewVC.h"
#import "UIButton+WebCache.h"

#import "UMMobClick/MobClick.h"

@implementation AppDelegate
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;


#pragma mark UMAnalytics

- (void)umengTrack {
    //新的友盟对接
    UMConfigInstance.appKey = UMENG_APPKEY;
    UMConfigInstance.channelId = UMENG_CHANEL_ID;
    [MobClick startWithConfigure:UMConfigInstance];

    
    //    [MobClick setCrashReportEnabled:NO]; // 如果不需要捕捉异常，注释掉此行
    //    [MobClick setLogEnabled:YES];  // 打开友盟sdk调试，注意Release发布时需要注释掉此行,减少io消耗
    
    //   reportPolicy为枚举类型,可以为 REALTIME, BATCH,SENDDAILY,SENDWIFIONLY几种
    //   channelId 为NSString * 类型，channelId 为nil或@""时,默认会被被当作@"App Store"渠道
    
    //    [MobClick checkUpdate];   //自动更新检查, 如果需要自定义更新请使用下面的方法,需要接收一个(NSDictionary *)appInfo的参数
    //    [MobClick checkUpdateWithDelegate:self selector:@selector(updateMethod:)];
    
   // [MobClick updateOnlineConfig];  //在线参数配置
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
}

- (void)onlineConfigCallBack:(NSNotification *)note {
    
    //    NSLog(@"online config has fininshed and note = %@", note.userInfo);
}

-(void)setRefreshBoolNo{
    self.hasNewReview=NO;
    self.postbarHasNewReview=NO;
    self.postbarHasNewTopic=NO;
    self.worthbuyHasNewTopic=NO;
    self.worthbuyHasNewReview=NO;
    self.hasNewShow = NO;
    self.isHaveUpLoad = NO;
    
}

-(void)setShareSDK{
    
    [ShareSDK registerActivePlatforms:@[@(SSDKPlatformTypeSinaWeibo),
                                        @(SSDKPlatformTypeCopy),
                                        @(SSDKPlatformSubTypeWechatSession),
                                        @(SSDKPlatformSubTypeWechatTimeline),
                                        //@(SSDKPlatformTypeQQ)
                                        ] onImport:^(SSDKPlatformType platformType) {
                                            switch (platformType)
                                            {
                                                case SSDKPlatformTypeWechat:
                                                    [ShareSDKConnector connectWeChat:[WXApi class]];
                                                    break;
                                               /* case SSDKPlatformTypeQQ:
                                                    [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                                    break;*/
                                                case SSDKPlatformTypeSinaWeibo:
                                                    [ShareSDKConnector connectWeibo:[WeiboSDK class]];
                                                    break;
                                                default:
                                                    break;
                                            }
                                            
                                        } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                            switch (platformType) {
                                                case SSDKPlatformTypeSinaWeibo:
                                                    //设置新浪微博应用信息,其中authType设置为使用SSO＋Web形式授权
                                                    [appInfo SSDKSetupSinaWeiboByAppKey:@"1973070790"
                                                                              appSecret:@"da7b8a7b515269600ad5d7543e6f68a0"
                                                                            redirectUri:@"http://www.meimei.yihaoss.top"
                                                                               authType:SSDKAuthTypeBoth];
                                                    
                                                    break;
                                                case SSDKPlatformTypeWechat:
                                                    [appInfo SSDKSetupWeChatByAppId:WEIXINAPPKEY
                                                                          appSecret:WEIXINAPPSECRET];
                                                    break;
                                                 
                                               /* case SSDKPlatformTypeQQ:
                                                    [appInfo SSDKSetupQQByAppId:@"1101220810"
                                                                         appKey:@"kcbgpQz2MGhZGxBH"
                                                                       authType:SSDKAuthTypeBoth];
                                                    break;*/
                                                default:
                                                    break;
                                            }
                                            
                                        }];
    
    
}
//ios7推送
- (void)registerRemoteNotification:(UIApplication *)application {
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    
}
//ios8本地和推送
- (void)registerUserNotification:(UIApplication *)application {
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:
                                            UIUserNotificationTypeBadge |
                                            UIUserNotificationTypeSound |
                                            UIUserNotificationTypeAlert categories:nil];
    [application registerUserNotificationSettings:settings];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //最开始的请求微信支付的秘钥
    [self getAppWX];
    
    //1、获取经纬度
    [self getLocationLatAndLog];
    
    //程序休眠时间
   // [NSThread sleepForTimeInterval:1.0];
    
    
    //2、版本监测
    [self checkVersion];
    
    //3、友盟
    [self umengTrack];
    //4、接受本地通知和远程通知
    self.isAllowedToNoti = YES;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0) {
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
        [self registerUserNotification:application];//iOS8,无论是远程还是本地,都需要注册
    } else {
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
        
        //        [self registerRemoteNotification:application];//iOS7,注册remote notification,本地的不用注册,这里没用到远程,不用注册
    }
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
    
    [APService setupWithOption:launchOptions];
    
    //5、轻储存孩子的数据信息
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:USERBABYUPDATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //发布秀秀后监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeAShowSucceed:) name:USER_MAKEASHOW_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeAShowFailed:) name:USER_MAKEASHOW_FAIL object:nil];
    //发布话题后监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postSucceed:) name:USER_POSTBAR_NEW_MAKE_A_POST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postFailed:) name:USER_POSTBAR_NEW_MAKE_A_POST_FAIL object:nil];
    
    //游客身份的监听，游客身份成功后进入首页
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVisitorMessageSucceed:) name:USER_GET_VISITOR_MESSAGE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getVisitorMessageFail:) name:USER_GET_VISITOR_MESSAGE_FAIL object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(netError) name:USER_NETVISTOR_ERROR object:nil];
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidSetup:)
                          name:kJPFNetworkDidSetupNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidClose:)
                          name:kJPFNetworkDidCloseNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidRegister:)
                          name:kJPFNetworkDidRegisterNotification
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidLogin:)
                          name:kJPFNetworkDidLoginNotification
     
     
                        object:nil];
    [defaultCenter addObserver:self
                      selector:@selector(networkDidReceiveMessage:)
                          name:kJPFNetworkDidReceiveMessageNotification
                        object:nil];
    
    self.isNewLogin=1;
    [self setRefreshBoolNo];
    //6、注册shareSDK
    [self setShareSDK];
    
    /*
    //注册短信的SDK
    [SMSSDK registerApp:AppKeySMS withSecret:AppSecretSMS];
    [SMSSDK enableAppContactFriends:NO];
     */
    
    //7、腾讯地图appKey
    [QMapServices sharedServices].apiKey = @"2QTBZ-QFC24-D6AU5-DMELL-N33P6-LGFUE";
    
    //8、注册微信支付
   
    [WXApi registerApp:WEIXINAPPKEY enableMTA:NO];
     //[WXApi registerApp:WEIXINAPPKEY withDescription:@"demo 2.0"];
    
    self.messCount = @(0);
    [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(getMessageCount) userInfo:nil repeats:YES];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[UIViewController alloc]initWithNibName:nil bundle:nil];
    
    self.myCache=[[ASIDownloadCache alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    [self.myCache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"resource"]];
    [self.myCache setShouldRespectCacheControlHeaders:NO];
    
    if ([BBSHasLogIn userHasLogIn]){
        [self setBBSTabBarController];
    }else{
        [self setStartViewController];
    }
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    //  是否展示广告
    _isRequestActivity = YES;
    _isRequestActivityToy = YES;
   // [self isShowActivityView];


    
    return YES;
}

#pragma mark  从推送链接跳转页面
-(void)goToPushVc:(NSDictionary *)megDic{
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:@"push"forKey:@"push"];
    [pushJudge synchronize];
    NSString *index = megDic[@"index"];
    if ([index isEqualToString:@"0"]) {
      //什么都不用跳
    }else if ([index isEqualToString:@"1"]){
        //图文帖子
        NSString *img_id = megDic[@"img_id"];
        PostBarNewDetialV1VC *detailVC = [[PostBarNewDetialV1VC alloc]init];
        detailVC.img_id=img_id;
        detailVC.login_user_id=LOGIN_USER_ID;
        detailVC.refreshInVC = ^(BOOL isRefresh){
        };
        BBSCommonNavigationController *nav = [[BBSCommonNavigationController alloc]initWithRootViewController:detailVC];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    }else if ([index isEqualToString:@"2"]){
        //视频帖子
        NSString *img_id = megDic[@"img_id"];
        NSString *isHv = megDic[@"isHV"];
        NSString *video_url = megDic[@"video_url"];
        BabyShowPlayerVC *babyShowPlayerVC = [[BabyShowPlayerVC alloc]init];
        babyShowPlayerVC.img_id = img_id;
        babyShowPlayerVC.videoUrl = video_url;
        babyShowPlayerVC.isHV = isHv;
        BBSCommonNavigationController *nav = [[BBSCommonNavigationController alloc]initWithRootViewController:babyShowPlayerVC];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        
    }else if ([index isEqualToString:@"3"]){
        //跳转标签列表
        NSString *img_id = megDic[@"img_ids"];
        NSString *tag_id = megDic[@"tag_id"];
        NSString *type = megDic[@"type"];
        NSString *title = megDic[@"title"];
        PostBarListNewVC *postBarListVC = [[PostBarListNewVC alloc]init];
        postBarListVC.tag_id = [tag_id integerValue];
        postBarListVC.img_ids = img_id;
        postBarListVC.type = type;
        postBarListVC.titleNav = title;
        BBSCommonNavigationController *nav = [[BBSCommonNavigationController alloc]initWithRootViewController:postBarListVC];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    }else if ([index isEqualToString:@"4"]){
        //商家列表
        //self.window.rootViewController = theAppDelegate.tabbarcontroller;
        [self.tabbarcontroller setBBStabbarSelectedIndex:0];
        self.tabbarcontroller.selectedIndex = 0;
    }else if ([index isEqualToString:@"5"]){
        //商家详情
         NSString *img_id = megDic[@"business_id"];
        StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
        storeVC.longin_user_id = LOGIN_USER_ID;
        storeVC.business_id = img_id;
        BBSCommonNavigationController *nav = [[BBSCommonNavigationController alloc]initWithRootViewController:storeVC];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];

    }else if ([index isEqualToString:@"6"]){
        //订单列表
        MyOrdersViewController *myOrderVC = [[MyOrdersViewController alloc]init];
        BBSCommonNavigationController *nav = [[BBSCommonNavigationController alloc]initWithRootViewController:myOrderVC];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        
        
    }else if ([index isEqualToString:@"7"]){
        //群详情
        NSString *img_id = megDic[@"group_id"];
        PostBarNewGroupOnlyOneVC *detailVC = [[PostBarNewGroupOnlyOneVC alloc]init];
        detailVC.group_id = [img_id intValue];
        BBSCommonNavigationController *nav = [[BBSCommonNavigationController alloc]initWithRootViewController:detailVC];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
    }else if([index isEqualToString:@"8"]){
        //web活动页
        NSString *webUrl = megDic[@"web_url"];
        WebViewController *webView=[[WebViewController alloc]init];
       // webView.img_id = self.imgID;
        webView.urlStr=[webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [webView setHidesBottomBarWhenPushed:YES];
        BBSCommonNavigationController *nav = [[BBSCommonNavigationController alloc]initWithRootViewController:webView];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];

    }else if([index isEqualToString:@"9"]){
        ToyLeaseNewVC *listVC = [[ToyLeaseNewVC alloc]init];
        listVC.inTheViewData = 2001;
        BBSCommonNavigationController *nav = [[BBSCommonNavigationController alloc]initWithRootViewController:listVC];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];
        
    }else if([index isEqualToString:@"10"]){
        NSString *img_id = megDic[@"img_id"];
        ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
        toyDetailVC.business_id = img_id;
        
        BBSCommonNavigationController *nav = [[BBSCommonNavigationController alloc]initWithRootViewController:toyDetailVC];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];

    }else if([index isEqualToString:@"11"]){
        NSString *img_id = megDic[@"img_id"];
        ToyTransportVC *toyTransportVC = [[ToyTransportVC alloc]init];
        toyTransportVC.order_id = img_id;
        BBSCommonNavigationController *nav = [[BBSCommonNavigationController alloc]initWithRootViewController:toyTransportVC];
        [self.window.rootViewController presentViewController:nav animated:YES completion:nil];

    }


    
}
-(void)getAppWX{
    
    [[HTTPClient sharedClient]getNewV1:@"WeChat" params:nil success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = [result objectForKey:@"data"];
            self.appSecret = [data objectForKey:@"wx_key"];
            [[NSUserDefaults standardUserDefaults]setObject:self.appSecret forKey:@"weiXinAppApi"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
    } failed:^(NSError *error) {

    }];
}
#pragma mark  注册游客身份的用户成功失败的各种方法
-(void)getVisitorMessageSucceed:(NSNotification *)not{
    
    [self setBBSTabBarController];
}
-(void)getVisitorMessageFail:(NSNotification *) not{
    
    [self setBBSTabBarController];
}
-(void)netError{
    [self setBBSTabBarController];
    
}

//定位信息的获取
-(void)getLocationLatAndLog{
    
    if ([CLLocationManager locationServicesEnabled]) {
        //1、获取经纬度
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        self.locationManager.distanceFilter = 1000.0f;
        [self.locationManager setDesiredAccuracy:kCLLocationAccuracyBest];
        
        if ([[[UIDevice currentDevice]systemVersion]doubleValue] > 8.0) {
            [self.locationManager requestWhenInUseAuthorization];
        }
        [self.locationManager startUpdatingLocation];
        status = [CLLocationManager authorizationStatus];
        if (kCLAuthorizationStatusDenied == status || kCLAuthorizationStatusRestricted == status) {
            NSUserDefaults *defaullat = [NSUserDefaults standardUserDefaults];
            [defaullat setValue:[NSString stringWithFormat:@"0.00"]forKey:@"latitude"];
            NSUserDefaults *defaultlong = [NSUserDefaults standardUserDefaults];
            [defaultlong setValue:[NSString stringWithFormat:@"0.00"]forKey:@"longitude"];
            
        }
        
    }
    
}

#pragma  mark -CLLocationManagerDelegate
//定位失败的方法
-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations

{
    
    CLLocation *currLocation = [locations lastObject];
    self.latitude = currLocation.coordinate.latitude;
    self.longitude = currLocation.coordinate.longitude;
    NSUserDefaults *defaullat = [NSUserDefaults standardUserDefaults];
    [defaullat setValue:[NSString stringWithFormat:@"%f",self.latitude]forKey:@"latitude"];
    NSUserDefaults *defaultlong = [NSUserDefaults standardUserDefaults];
    [defaultlong setValue:[NSString stringWithFormat:@"%f",self.longitude]forKey:@"longitude"];
    
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [APService registerDeviceToken:deviceToken];
}
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
}

//获取用户发送通知权限
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    if (notificationSettings.types) {
        //获取通知权限
        NSLog(@"获取通知权限");
        self.isAllowedToNoti = YES;
    } else {
        //没有获取权限
        NSLog(@"没有通知权限");
        self.isAllowedToNoti = NO;
    }
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    
    // 取得 APNs 标准信息内容
    NSDictionary *aps = [userInfo valueForKey:@"aps"];
    NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    NSInteger badge = [[aps valueForKey:@"badge"] integerValue]; //badge数量
    NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    
    // 取得自定义字段内容
    NSString *customizeField1 = [userInfo valueForKey:@"customizeField1"]; //自定义参数，key是自己定义的
    NSLog(@"content =[%@], badge=[%ld], sound=[%@], customize field =[%@]",content,(long)badge,sound,customizeField1);
    
    [APService handleRemoteNotification:userInfo];
}



-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    NSString *urlString0 = @"wxcf183faac658e9c5://pay/?returnKey=";
    NSURL *url0 = [NSURL URLWithString:urlString0];
    
    if ([url isEqual:url0]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return nil;
    
}


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSString *url2 = [NSString stringWithFormat:@"%@",url];
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    
    if ([url2 hasPrefix:@"wxcf183faac658e9c5://pay/?returnKey=" ]){
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        return nil;
    }
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    NSLog(@"urlurl = %@",url);
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    if ([[NSString stringWithFormat:@"%@",url] rangeOfString:[NSString stringWithFormat:@"wxcf183faac658e9c5://pay"]].location != NSNotFound) {
        return  [WXApi handleOpenURL:url delegate:self];
        //不是上面的情况的话，就正常用shareSDK调起相应的分享页面
    }else{
        return  nil;
    }

    return YES;
}

-(void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    NSLog(@"userInfo = %@",userInfo);
    if (application.applicationState == UIApplicationStateActive) {
       //这里写APP正在运行时，推送过来消息的处理
    }else if(application.applicationState == UIApplicationStateInactive){
        //APP在后台运行，推送过来消息的处理
         [self goToPushVc:userInfo];
        
    }else if (application.applicationState == UIApplicationStateBackground){
        [self goToPushVc:userInfo];
    }
    
    
}
- (void)applicationWillResignActive:(UIApplication *)application

{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    
    [dateFormatter setDateFormat:@"HH:mm:ss:SSSSSS"];
    
    NSString *str = [dateFormatter stringFromDate:[NSDate date]];
    NSLog(@"现在的时间 applicationWillResignActive= %@",str);
    
    
    
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if (self.messCount.integerValue <= 0) {
        if (self.isAllowedToNoti) {
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
    }else{
        
    }
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application

{
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=9.0 &&[[[UIDevice currentDevice]systemVersion]floatValue]<10.0) {
        [[NSNotificationCenter defaultCenter]postNotificationName:USER_ISPAY object:nil];

    }
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}
//获取当前屏幕显示的viewcontroller
- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
    
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BabyShow" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BabyShow.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//#pragma mark UITabBarControllerDelegate:
//
//-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
//
//    for (UINavigationController *nav in tabBarController.viewControllers) {
//        [nav popToRootViewControllerAnimated:YES];
//    }
//
//}

#pragma mark - Private


-(void)getMessageCount{
    
    NSString *loginUserId=LOGIN_USER_ID;
    
    if (loginUserId) {
        
        NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"user_id", nil];
        
        UrlMaker *_urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kMessCount Method:NetMethodGet andParam:param];
        ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:_urlMaker.url];
        request.delegate=self;
        [request startAsynchronous];
        
    }
    
}

-(void)checkVersion
{
    
    ASIHTTPRequest* request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:APP_URL]];
    [request setDelegate:self];
    request.tag=1000;
    [request startAsynchronous];
    
}

#pragma mark - ASIHttpRequestDelegate

-(void)requestFinished:(ASIHTTPRequest *)request{
    
    if (request.tag==1000) {
        
       /* NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        NSArray *resultArray=[dic objectForKey:@"results"];
        NSDictionary *resultDic=[resultArray objectAtIndex:0];
        versionStr=[resultDic objectForKey:@"version"];
        NSLog(@"version in App Store:%@",versionStr);
        
        NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
        NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
        NSLog(@"currentVersion:%@",currentVersion);
        if ( versionStr &&([versionStr floatValue] > [currentVersion floatValue]) && currentVersion) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"自由环球租赁" message:@"自由环球租赁出新版本啦，更多精彩功能，快来更新吧" delegate:self cancelButtonTitle:@"稍后再说" otherButtonTitles:@"马上更新", nil];
            [alert show];
            
        }*/
    }else{
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:request.responseData options:0 error:nil];
        if ([[dic objectForKey:@"success"]intValue]==1) {
            
            NSDictionary *dataDic=[dic objectForKey:@"data"];
            NSNumber *newCount = @(0);
            if(dataDic){
                newCount=[dataDic objectForKey:@"latest_total_count"];
                NSLog(@"messCount:%@",newCount);
                
            }
            if (![newCount isEqualToNumber:self.messCount]) {
                self.messCount = newCount;
                if ([self.messCount intValue] == 0) {
                    [self.tabbarcontroller setbadgeValue:NULL];
                } else {
                    [self.tabbarcontroller setbadgeValue:[NSString stringWithFormat:@"%@",self.messCount]];
                }
                if (self.isAllowedToNoti) {
                    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[self.messCount integerValue]];
                }
            }
        }
    }
    
}

#pragma mark - 设置引导页为rootController

-(void)setLeadingView{
    
    LeadingViewController *leadVC=[[LeadingViewController alloc]init];
    self.window.rootViewController=leadVC;
}

#pragma mark - 设置tabbar为rootController

-(void)setBBSTabBarController{
    self.isNewLogin=1;
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:USERBABYUPDATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.tabbarcontroller=[[BBSTabBarViewController alloc]init];
//    self.tabbarcontroller.delegate=self;
    self.window.rootViewController=self.tabbarcontroller;
    
    if (LOGIN_USER_ID != NULL) {
        [[HTTPClient sharedClient]postNew:kRecordLoginTime params:@{@"login_user_id":LOGIN_USER_ID} success:^(NSDictionary *result) {
        } failed:^(NSError *error) {
        }];
        
    }
}

#pragma mark 设置开始页面为rootController
-(void)setStartViewController{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    if (![[userDefaults objectForKey:@"firstLaunch"]isEqualToString:@"1"] ) {
        //用户第一次登陆的时候引导页，在立即体验的时候请求注册生成游客，在游客的成功方法里面跳转首页
        FirstLanchAppVC *firstVC = [[FirstLanchAppVC alloc]init];
        BBSNavigationControllerNotTurn *startNv=[[BBSNavigationControllerNotTurn alloc]initWithRootViewController:firstVC];
        [startNv setNavigationBarHidden:YES];
        self.window.rootViewController=startNv;
        [userDefaults setObject:@"1" forKey:@"firstLaunch"];
        [userDefaults synchronize];
    }else{
        [self setVistorLogin];
    }
}
#pragma mark 游客登录
-(void)setVistorLogin{
    self.isNewLogin=1;//新用户登录
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    NetAccess *net=[NetAccess sharedNetAccess];
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:identifierForVendor,@"imin",[NSString stringWithFormat:@"%f,%f",self.latitude,self.longitude],@"mapsign",nil];
    [net getDataWithStyle:NetStyleVisitorRegist andParam:param];
    
    
}
#pragma mark -
- (void)makeAShowSucceed:(NSNotification *)noti {
    BOOL shareToWeixin = [[self.showShareInfo objectForKey:@"weixin"] boolValue];
    BOOL shareToWeibo = [[self.showShareInfo objectForKey:@"weibo"] boolValue];
    NSLog(@"self.show = %@",noti.object);
    if (shareToWeixin || shareToWeibo) {
        NSMutableDictionary *dataDict = noti.object;
        [self sendShowToThirdParty:dataDict];
    }
    self.hasNewShow = YES;
}
- (void)makeAShowFailed:(NSNotification *)noti {

        [BBSAlert showAlertWithContent:noti.object andDelegate:nil];
}
#pragma mark -
- (void)postSucceed:(NSNotification *)noti {
  
    BOOL shareToWeixin = [[self.postShareInfo objectForKey:@"weixin"] boolValue];
    BOOL shareToWeibo = [[self.postShareInfo objectForKey:@"weibo"] boolValue];
    
    if (shareToWeixin || shareToWeibo) {
        NSDictionary *dataDict = noti.object;
        [self sendPostToThirdParty:dataDict];
    }
    
    
}
- (void)postFailed:(NSNotification *)noti {
    
    [BBSAlert showAlertWithContent:noti.object andDelegate:nil];
}

#pragma mark - 分享到第三方

- (void)sendShowToThirdParty:(NSMutableDictionary *)dict{
    
    BOOL shareToWeixin = [[self.showShareInfo objectForKey:@"weixin"] boolValue];
    BOOL shareToWeibo = [[self.showShareInfo objectForKey:@"weibo"] boolValue];
    NSString *user_id = [dict objectForKey:@"user_id"];
    NSString *img_id = [dict objectForKey:@"img_id"];
    NSString *imgUrl = [dict objectForKey:@"img"];
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
   // [shareParams SSDKEnableUseClientShare];
    NSArray* imageArray;
    if (imgUrl.length>0) {
        NSString *imgStr = [NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgUrl];
        NSLog(@"imgstr = %@",imgStr);
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imgStr]];
        NSLog(@"imgstrurl = %@",url);

        UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        NSLog(@"imgstrurlimg = %@",shareImg);

        NSData *basicImgData = UIImagePNGRepresentation(shareImg);
        if (basicImgData.length/1024>150) {
            shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
            
        }

        imageArray = @[shareImg];
    }else{
        imageArray = @[[UIImage imageNamed:@"img_default"]];

    }
    //分享的链接和内容
    NSString *shareStr;
    NSLog(@"diccisvideo = %@",dict[@"isVideo"]);
    if ([dict[@"isVideo"] isEqualToString:@"1"]) {
        shareStr = [NSString stringWithFormat:@"%@&img_id=%@&user_id=%@",VideoShareUrl,img_id,user_id];
  
    }else{
    shareStr = [NSString stringWithFormat:@"%@&img_id=%@&user_id=%@",PostShareUrl,img_id,user_id];
     }
    NSURL *shareUrl = [NSURL URLWithString:shareStr];
    NSLog(@"sharesssssssssss = %@",shareUrl);
    
    NSString *contentText = [NSString stringWithFormat:@"晒晒我家宝宝的最新萌萌照|最美的宝宝成长记录@自由环球租赁-最有人气的亲子社区【%@】",shareUrl];

    if (imageArray) {
        if (shareToWeixin) {
            [shareParams SSDKSetupShareParamsByText:nil
                                             images:imageArray
                                                url:shareUrl
                                              title:@"晒晒我家宝宝的最新萌萌照|最美的宝宝成长记录"
                                               type:SSDKContentTypeAuto];
            [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                switch (state) {
                    case SSDKResponseStateSuccess:
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                            message:nil
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil];
                        [alertView show];
                        break;
                    }
                    case SSDKResponseStateFail:
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                            message:[NSString stringWithFormat:@"%@", error]
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil];
                        [alertView show];
                        break;
                    }
                    case SSDKResponseStateCancel:
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"微信分享已取消"
                                                                            message:nil
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil];
                        [alertView show];
                        break;
                    }
                        
                        
                    default:
                        break;
                }
            }];
            
        }
        if (shareToWeibo) {
            [shareParams SSDKSetupShareParamsByText:contentText
                                             images:imageArray
                                                url:nil
                                              title:nil
                                               type:SSDKContentTypeAuto];
            NSString *contentSina = [NSString stringWithFormat:@"%@%@",contentText,shareUrl];
            [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:nil image:imageArray url:nil latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];

            [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
                switch (state) {
                    case SSDKResponseStateSuccess:
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                            message:nil
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil];
                        [alertView show];
                        break;
                    }
                    case SSDKResponseStateFail:
                    {
                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"微博分享失败"
                                                                            message:[NSString stringWithFormat:@"%@", error]
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"确定"
                                                                  otherButtonTitles:nil];
                        [alertView show];
                        break;
                    }
                    case SSDKResponseStateCancel:
                    {
//                        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"微博分享已取消"
//                                                                            message:nil
//                                                                           delegate:nil
//                                                                  cancelButtonTitle:@"确定"
//                                                                  otherButtonTitles:nil];
//                        [alertView show];
                        break;
                    }
                    default:
                        break;
                }
                
            }];
            
        }
    }
    
    
    
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (void)sendPostToThirdParty:(NSDictionary *)dict{
    
    BOOL shareToWeixin = [[self.postShareInfo objectForKey:@"weixin"] boolValue];
    BOOL shareToWeibo = [[self.postShareInfo objectForKey:@"weibo"] boolValue];
    
    NSString *user_id = [dict objectForKey:@"user_id"];
    NSString *img_id = [dict objectForKey:@"img_id"];
    NSString *imgUrl = [dict objectForKey:@"img"];
    NSString *img_title = [dict objectForKey:@"img_title"];
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray;
    if (imgUrl.length>0) {
        NSString *imgStr = [NSString stringWithFormat:@"%@%@",kImageBaseUrl,imgUrl];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",imgStr]];
        
        UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        NSData *basicImgData = UIImagePNGRepresentation(shareImg);
        if (basicImgData.length/1024>150) {
            shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
            
        }

        imageArray = @[shareImg];
    }else{
        imageArray = @[[UIImage imageNamed:@"img_default"]];
        
    }
    //分享的链接和内容
    NSString *shareStr = [NSString stringWithFormat:@"%@&img_id=%@&user_id=%@",PostShareUrl,img_id,user_id];
    NSURL *shareUrl = [NSURL URLWithString:shareStr];
    NSString *contentText = [NSString stringWithFormat:@"%@@自由环球租赁-最有人气的亲子社区【%@】",img_title,shareUrl];
    if (shareToWeixin) {
        [shareParams SSDKSetupShareParamsByText:nil
                                         images:imageArray
                                            url:shareUrl
                                          title:img_title
                                           type:SSDKContentTypeAuto];
        [ShareSDK share:SSDKPlatformSubTypeWechatTimeline parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            switch (state) {
                case SSDKResponseStateSuccess:
                {
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                        message:nil
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"确定"
//                                                              otherButtonTitles:nil];
//                    [alertView show];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                        message:[NSString stringWithFormat:@"%@", error]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateCancel:
                {
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                        message:nil
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"确定"
//                                                              otherButtonTitles:nil];
//                    [alertView show];
                    break;
                }
                    
                    
                default:
                    break;
            }
        }];
        
    }
    if (shareToWeibo) {
//        [shareParams SSDKSetupShareParamsByText:contentText
//                                         images:imageArray
//                                            url:shareUrl
//                                          title:img_title
//                                           type:SSDKContentTypeAuto];
        NSString *contentSina = [NSString stringWithFormat:@"%@%@",contentText,shareUrl];
        [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:img_title image:imageArray url:nil latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
        
        [ShareSDK share:SSDKPlatformTypeSinaWeibo parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            switch (state) {
                case SSDKResponseStateSuccess:
                {
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                        message:nil
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"确定"
//                                                              otherButtonTitles:nil];
//                    [alertView show];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                        message:[NSString stringWithFormat:@"%@", error]
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateCancel:
                {
//                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                        message:nil
//                                                                       delegate:nil
//                                                              cancelButtonTitle:@"确定"
//                                                              otherButtonTitles:nil];
//                    [alertView show];
                    break;
                }
                default:
                    break;
            }
            
        }];
    }
    
    
    
}

#pragma mark 微信支付代理
-(void) onReq:(BaseReq*)req
{
    if([req isKindOfClass:[GetMessageFromWXReq class]])
    {
        // 微信请求App提供内容， 需要app提供内容后使用sendRsp返回
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App提供内容"];
        NSString *strMsg = @"微信请求App提供内容，App要调用sendResp:GetMessageFromWXResp返回给微信";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag = 1000;
        [alert show];
    }
    else if([req isKindOfClass:[ShowMessageFromWXReq class]])
    {
        ShowMessageFromWXReq* temp = (ShowMessageFromWXReq*)req;
        WXMediaMessage *msg = temp.message;
        
        //显示微信传过来的内容
        WXAppExtendObject *obj = msg.mediaObject;
        
        NSString *strTitle = [NSString stringWithFormat:@"微信请求App显示内容"];
        NSString *strMsg = [NSString stringWithFormat:@"标题：%@ \n内容：%@ \n附带信息：%@ \n缩略图:%lu bytes\n\n", msg.title, msg.description, obj.extInfo, (unsigned long)msg.thumbData.length];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if([req isKindOfClass:[LaunchFromWXReq class]])
    {
        //从微信启动App
        NSString *strTitle = [NSString stringWithFormat:@"从微信启动"];
        NSString *strMsg = @"这是从微信启动的消息";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

-(void) onResp:(BaseResp*)resp
{
    NSString *strTitle;
    
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        strTitle = [NSString stringWithFormat:@"发送媒体消息结果"];
    }
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        
        switch (resp.errCode) {
            case WXSuccess:
                [BBSAlert showAlertWithContent:@"支付成功" andDelegate:self andDismissAnimated:2];
                [[NSNotificationCenter defaultCenter]postNotificationName:USER_WEIXINPAY_SUCCEED object:self];
                break;
            case -2:
                [BBSAlert showAlertWithContent:@"用户取消支付" andDelegate:self];
                [[NSNotificationCenter defaultCenter]postNotificationName:USER_WEIXINPAY_FAIL object:self];
                break;
            default:
                [BBSAlert showAlertWithContent:@"支付失败" andDelegate:self];
                [[NSNotificationCenter defaultCenter]postNotificationName:USER_WEIXINPAY_FAIL object:self];
                break;
                
        }
    }
    
}

#pragma mark 前往app store进行更新
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        UIApplication *app=[UIApplication sharedApplication];
        [app openURL:[NSURL URLWithString:@"https://itunes.apple.com/us/app/bao-bao-xiu-xiu/id789847552?mt=8&uo=4"]];
        
    }
    
}
#pragma mark 推送状态
- (void)networkDidSetup:(NSNotification *)notification {
}

- (void)networkDidClose:(NSNotification *)notification {
}

- (void)networkDidRegister:(NSNotification *)notification {
}

- (void)networkDidLogin:(NSNotification *)notification {
    
    if ([APService registrationID]) {
    }
}

- (void)networkDidReceiveMessage:(NSNotification *)notification {

}

@end
