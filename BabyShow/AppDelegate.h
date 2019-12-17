//
//  AppDelegate.h
//  BabyShow
//
//  Created by Lau on 13-12-9.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.


#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ASIDownloadCache.h"
#import "BBSTabBarViewController.h"
//#import "WXApi.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,UITabBarControllerDelegate,UITabBarControllerDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate//WXApiDelegate,CLLocationManagerDelegate
>

{
    NSString *versionStr;
    //当前定位的状态
    CLAuthorizationStatus status;

}

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) BBSTabBarViewController *tabbarcontroller;
@property (nonatomic, strong) ASIDownloadCache *myCache;
@property (nonatomic ,assign) BOOL isNewLogin;
@property (nonatomic ,strong) NSNumber *messCount;
@property (nonatomic ,assign) BOOL isAllowedToNoti;     //是否获得给用户发送通知权限

@property (nonatomic, assign) BOOL hasNewReview;
@property(nonatomic,assign)BOOL hasNewShow;//是否有新秀秀

@property (nonatomic, assign) BOOL postbarHasNewReview;
@property (nonatomic, assign) BOOL postbarHasNewTopic;

@property (nonatomic, assign) BOOL worthbuyHasNewTopic;
@property (nonatomic, assign) BOOL worthbuyHasNewReview;

//发布秀秀页面需要保存的是否分享到微博微信的信息
@property (nonatomic ,strong)NSDictionary *showShareInfo;
//发布话题页面需要保存的是否分享到微博微信的信息自由环球租赁2.5+6+3
@property (nonatomic ,strong)NSDictionary *postShareInfo;
@property(nonatomic,assign)float latitude;//纬
@property(nonatomic,assign)float longitude;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)UIImageView *adImageView;//启动页广告页
@property(nonatomic,assign)BOOL isAdAppear;//根据网络状态去判断是否显示广告活动页，在低于4G的网络状态下，不显示广告页
@property(nonatomic,assign)BOOL isHaveUpLoad;//是否在传秀秀
@property(nonatomic,assign)BOOL isHaveUpLoadPost;//是否再传话题
@property(nonatomic,assign)BOOL isHaveUploadGroup;//是否在群里面发话题
@property(nonatomic,strong)NSString *appSecret;//微信秘钥
@property(nonatomic,assign)BOOL isHaveNewEditPost;//是否有新编辑的帖子
@property(nonatomic,assign)BOOL isHaveNewGroupPost;//群里面发帖
@property(nonatomic,assign)BOOL isUpdateNow;//正在上传视频

//  广告弹窗
@property(nonatomic,strong)NSString *post_urlActivity;
@property(nonatomic,strong)NSString *imgActivity;
@property(nonatomic,strong)NSString *typeActivity;

@property(nonatomic,strong)UIView *grayView;
@property(nonatomic,strong)UIButton *goToShareBtn;// 分享大按钮
@property(nonatomic,strong)UIButton *gotoCacelBtn;//取消分享按钮


@property(nonatomic,assign)BOOL isRequestActivity;
@property(nonatomic,assign)BOOL isRequestActivityToy;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (void)setBBSTabBarController;
- (void)setStartViewController;
- (void)setRefreshBoolNo;
- (void)setLeadingView;
-(void)setVistorLogin;

@end
