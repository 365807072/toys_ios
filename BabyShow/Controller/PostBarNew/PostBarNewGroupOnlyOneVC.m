//
//  PostBarNewGroupOnlyOneVC.m
//  BabyShow
//
//  Created by WMY on 16/11/24.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarNewGroupOnlyOneVC.h"
#import "RefreshControl.h"
#import "WMYLabel.h"
#import "UIImageView+WebCache.h"
#import "LeftBestPostCell.h"
#import "SinglePhotoGroupCell.h"
#import "LoginHTMLVC.h"
#import "PostBarNewMakeAPost.h"
#import "SortManagementVC.h"
#import "StoreDetailNewVC.h"
#import "MyHomeNewVersionVC.h"
#import "BabyShowMainItem.h"
#import "PostBarFirstCell.h"
#import "PostBarNewDetialV1VC.h"
#import "BabyShowPlayerVC.h"
#import "EditHeadMessVC.h"
#import "PostBarManagementVC.h"
#import "SortClassItem.h"
#import "YLImageView.h"
#import "YLGIFImage.h"
#import "WebViewController.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "StoreMoreListVC.h"
#import "ToyLeaseNewVC.h"


@interface PostBarNewGroupOnlyOneVC ()<RefreshControlDelegate,UITableViewDataSource,UITableViewDelegate>{
    RefreshControl *_refreshControl;
    UITableView *_tableViewNew;
    NSMutableArray *tableArray;//数组
    //刷新
    NSString *postCreatTime;
    
    
}
@property(nonatomic,assign)BOOL isHideClassList;//是否隐藏列表分类
@property(nonatomic,strong)UIView *grayHeadView;//头部的图片
@property(nonatomic,strong)UITableView *classTableView;//分类的数据
@property(nonatomic,strong)UIImageView *headImgView;
@property(nonatomic,strong)YLButton *backBtn;
@property(nonatomic,strong)YLButton *editBtn;
@property(nonatomic,strong)UIButton *shareBtn;

@property(nonatomic,strong)UILabel *groupNameBtn;
@property(nonatomic,strong)YLButton *storeImgBtn;//后面的icon
@property(nonatomic,strong)WMYLabel *introduceLabel;//描述
@property(nonatomic,strong)YLButton *addFocusBtn;//加关注
@property(nonatomic,strong)UILabel *focusCountLabel; //关注人数
@property(nonatomic,strong)YLButton *makeAPostBtn;//发布帖子
@property(nonatomic,strong)UIView *grayView;//点击编辑的时候出来的编辑黑色底
@property(nonatomic,strong)NSString *business_id;//商家或用户的id
@property(nonatomic,strong)NSString *user_id;//群主id
@property(nonatomic,strong)NSString *is_idol;//关注的状态
@property(nonatomic,strong)NSString *idol_count;//关注数量
@property(nonatomic,strong)NSString *groupName;
@property(nonatomic,strong)NSString *desSub;
@property(nonatomic,strong)NSString *cover;
@property(nonatomic,strong)UITableView *indexTableView;
@property(nonatomic,strong)UIButton *allBtn;
@property(nonatomic,strong)NSMutableArray *classArray;
@property(nonatomic,strong)UIView *addView;//添加分类
@property(nonatomic,strong)NSString *group_class_id;//选定分类
@property(nonatomic,assign)float heightClassTableView;//分类的高
@property (nonatomic,strong)YLImageView *ylIamgeView;
@property(nonatomic,strong)UIButton *editBigbtn;//编辑按钮下面
@property(nonatomic,strong)NSString *recommend_title;//提示
@property(nonatomic,strong)NSString *color_index;//颜色的值

@property(nonatomic,strong)YLButton *diaryBtn;//成长记录
@property(nonatomic,strong)YLButton *albumBtn;//相册
@property(nonatomic,strong)YLButton *storeBtn;//商家列表
@property(nonatomic,strong)YLButton *toyListBtn;//玩具列表

@property(nonatomic,strong)UIView *lookMoreBackView;//查看更多的页面
@property(nonatomic,strong)UIButton *morePostBtn;//查看更多
@property(nonatomic,strong)UILabel *hotDataLabel;
@property(nonatomic,strong)NSString *is_business;//1展示商家列表
@property(nonatomic,strong)NSString *is_toys;//展示玩具列表
@property(nonatomic,strong)NSString *is_growth;//展示成长记录
@property(nonatomic,strong)NSString *is_album;//展示相册
@property(nonatomic,strong)NSString *cityId;

@end

@implementation PostBarNewGroupOnlyOneVC

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    //添加关注成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postIdolSucceed) name:USER_POSTBAR_NEW_POSTIDOLS_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postIdolFail) name:USER_POSTBAR_NEW_POSTIDOLS_FAIL object:nil];
    //取消关注
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPostIdolSucceed) name:USER_POSTBAR_NEW_CANCELPOSTIDOL_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPostIdolFail) name:USER_POSTBAR_NEW_CANCELPOSTIDOL_FAIL object:nil];
    [_tableViewNew addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeVideoSucceed) name:USER_POSTBAR_NEW_MAKE_A_GROUPPOST_SUCCEED object:nil];
    //编辑头部修改成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editGroupSucceed) name:EDITGROUPHEAD_SUCCEED object:nil];
    
    //如果有新的帖子的话刷新
    if (theAppDelegate.isHaveNewGroupPost == YES) {
        theAppDelegate.isHaveNewGroupPost = NO;
        [self makeApostSucceed];
    }
    if (theAppDelegate.isUpdateNow == YES) {
        theAppDelegate.isUpdateNow = NO;
        [self postingSuceed];
    }
    
    
}
-(void)makeVideoSucceed{
    if (theAppDelegate.isHaveNewGroupPost == YES) {
        theAppDelegate.isHaveNewGroupPost = NO;
        [self makeApostSucceed];
    }
    
}

-(void)postingSuceed{
    _ylIamgeView = [[YLImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH-60,SCREENHEIGHT-130, 39, 39)];
    _ylIamgeView.image = [YLGIFImage imageNamed:@"up_show.gif"];
    [self.view addSubview:_ylIamgeView];
    
}

-(void)makeApostSucceed{
    [_ylIamgeView removeFromSuperview];
    [self refresh];
}
-(void)refresh{
    [self getHeaderViewData];
    postCreatTime = NULL;
    [self getNewTableViewData];
    
}
-(void)editGroupSucceed{
    [self refresh];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [self removeTheViewFromWidow];
    [_tableViewNew removeObserver:self forKeyPath:@"contentOffset"];
    [self hideClassTableView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (!tableArray) {
        tableArray = [NSMutableArray array];
    }
    if (!_classArray) {
        _classArray = [NSMutableArray array];
    }
    self.heightClassTableView = 213;
    self.group_class_id = @"0";
    [self setHeadImgView];
    [self setTableView];
    [self setMakeApostBtnView];
    [self setLookMoreBack];
    [self refreshControlInit];
    _isHideClassList = YES;
    
    // Do any additional setup after loading the view.
}

#pragma mark UI
-(void) setHeadImgView{
    self.grayHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.55+44)];
    self.grayHeadView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    self.headImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.55)];
    self.headImgView.userInteractionEnabled = YES;
    [self.headImgView setContentMode:UIViewContentModeScaleAspectFill];
    self.headImgView.clipsToBounds = YES;
    [self.grayHeadView addSubview:self.headImgView];
    CGRect backBtnFrame = CGRectMake(10, 20, 32, 32);
    CGRect editBtnFrame = CGRectMake(SCREENWIDTH-43-50, 20, 33, 33);
    CGRect groupNameBtn = CGRectMake(100, 70, 50, 20);
    CGRect storeFrame = CGRectMake(155, 70, 25, 25);
    CGRect addFrame = CGRectMake(SCREENWIDTH-78, SCREENWIDTH*0.55-60,68, 32);
    CGRect focusFrame = CGRectMake(SCREENWIDTH-140,  SCREENWIDTH*0.55-20, 130, 15);
    
    self.backBtn = [YLButton buttonWithFrame:backBtnFrame type:UIButtonTypeCustom backImage:[UIImage imageNamed:@"post_bar_group_back"] target:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [self.headImgView addSubview:self.backBtn];
    
    self.editBtn = [YLButton buttonWithFrame:editBtnFrame type:UIButtonTypeCustom backImage:[UIImage imageNamed:@"post_bar_group_edit"] target:self action:@selector(editBaseMes) forControlEvents:UIControlEventTouchUpInside];
    [self.headImgView addSubview:self.editBtn];
    self.editBtn.hidden = YES;
    self.editBigbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editBigbtn.frame = CGRectMake(SCREENWIDTH-100, 20, 50, 40);
    [self.editBigbtn addTarget:self action:@selector(editBaseMes) forControlEvents:UIControlEventTouchUpInside];
    [self.headImgView addSubview:self.editBigbtn];
    self.editBigbtn.hidden = YES;
    
    
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.shareBtn.frame = CGRectMake(SCREENWIDTH-43, 20, 33,33);
    [self.shareBtn setBackgroundImage:[UIImage imageNamed:@"post_group_share"] forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(sharePostDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.headImgView addSubview:self.shareBtn];
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    //shareBtn.backgroundColor = [UIColor redColor];
    shareBtn.frame = CGRectMake(SCREENWIDTH-60, 20,60,50);
    [shareBtn addTarget:self action:@selector(sharePostDetail) forControlEvents:UIControlEventTouchUpInside];
    [self.headImgView addSubview:shareBtn];

    
    self.groupNameBtn = [YLButton buttonWithFrame:groupNameBtn type:UIButtonTypeCustom backImage:nil target:self action:nil forControlEvents:UIControlEventTouchUpInside];
    self.groupNameBtn = [[UILabel alloc]initWithFrame:groupNameBtn];
    self.groupNameBtn.textColor = [BBSColor hexStringToColor:@"333333"];
    
    [self.headImgView addSubview:self.groupNameBtn];
    
    self.storeImgBtn = [YLButton buttonWithFrame:storeFrame type:UIButtonTypeCustom backImage:[UIImage imageNamed:@"post_bar_group_store"] target:self action:nil forControlEvents:UIControlEventTouchUpInside];
    self.storeImgBtn.hidden = YES;
    [self.headImgView addSubview:self.storeImgBtn];
    
    self.introduceLabel = [[WMYLabel alloc]initWithFrame:CGRectMake(60, 100, SCREENWIDTH-120, 20)];
    self.introduceLabel.textColor = [BBSColor hexStringToColor:@"333333"];
    self.introduceLabel.textAlignment = NSTextAlignmentCenter;
    self.introduceLabel.font = [UIFont systemFontOfSize:13];
    self.introduceLabel.numberOfLines = 0;
    [self.headImgView addSubview:self.introduceLabel];
    
    self.addFocusBtn = [YLButton buttonWithFrame:addFrame type:UIButtonTypeCustom backImage:nil target:self action:@selector(addOrCancelFocusAction) forControlEvents:UIControlEventTouchUpInside];
    [self.headImgView addSubview:self.addFocusBtn];
    
    self.focusCountLabel = [[WMYLabel alloc]initWithFrame:focusFrame];
    self.focusCountLabel.font = [UIFont systemFontOfSize:13];
    self.focusCountLabel.textAlignment = NSTextAlignmentRight;
    [self.headImgView addSubview:self.focusCountLabel];
    
    self.hotDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(40,SCREENWIDTH*0.55+10, SCREENWIDTH-80, 19)];
    self.hotDataLabel.textAlignment = NSTextAlignmentCenter;
    self.hotDataLabel.font = [UIFont systemFontOfSize:17];
    self.hotDataLabel.textColor = [BBSColor hexStringToColor:@"999999"];
    [self.grayHeadView addSubview:self.hotDataLabel];

    
    
    //个人相册
    self.albumBtn = [YLButton buttonWithFrame:CGRectMake(SCREENWIDTH-150+75,SCREENWIDTH*0.55+8, 70, 28) type:UIButtonTypeCustom backImage:[UIImage imageNamed:@"btn_group_photo"] target:self action:nil forControlEvents:UIControlEventTouchUpInside];
    self.albumBtn.hidden = YES;
    [self.grayHeadView addSubview:self.albumBtn];
    //成长记录
    self.diaryBtn = [YLButton buttonWithFrame:CGRectMake(self.albumBtn.frame.origin.x-self.albumBtn.frame.size.width -5,SCREENWIDTH*0.55+8, 70, 28) type:UIButtonTypeCustom backImage:[UIImage imageNamed:@"btn_group_diary"] target:self action:nil forControlEvents:UIControlEventTouchUpInside];
    self.diaryBtn.hidden = YES;
    [self.grayHeadView addSubview:self.diaryBtn];
    
    //玩具列表
    self.toyListBtn = [YLButton buttonWithFrame:CGRectMake(self.diaryBtn.frame.origin.x-self.diaryBtn.frame.size.width -5,SCREENWIDTH*0.55+8, 70, 28) type:UIButtonTypeCustom backImage:[UIImage imageNamed:@"btn_toy_list"] target:self action:nil forControlEvents:UIControlEventTouchUpInside];
    self.toyListBtn.hidden = YES;
    [self.grayHeadView addSubview:self.toyListBtn];
    //商家列表
    self.storeBtn = [YLButton buttonWithFrame:CGRectMake(self.toyListBtn.frame.origin.x-self.toyListBtn.frame.size.width -5,SCREENWIDTH*0.55+8, 70, 28) type:UIButtonTypeCustom backImage:[UIImage imageNamed:@"btn_go_storelist"] target:self action:nil forControlEvents:UIControlEventTouchUpInside];
    self.storeBtn.hidden =YES;
    [self.grayHeadView addSubview:self.storeBtn];
    
 

}
-(void)sharePostDetail{
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray;
    UIImage *shareImg;
    if (self.cover.length > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.cover]];
        shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        NSData *basicImgData = UIImagePNGRepresentation(shareImg);
        if (basicImgData.length/1024>150) {
            shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
            
        }
        
    }else{
        shareImg = [UIImage imageNamed:@"img_default"];
        
    }
    NSString *urlString = [NSString stringWithFormat:@"%@login_user_id=%@&group_id=%ld",PostGroupShareUrl,LOGIN_USER_ID,(long)self.group_id];
    NSURL *shareUrl = [NSURL URLWithString:urlString];
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",self.groupName,shareUrl];
    //设置微博
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:self.groupName image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
    //设置微信好友
    [shareParams SSDKSetupWeChatParamsByText:self.groupName title:self.groupName url:shareUrl thumbImage:shareImg image:shareImg musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];
    
    //设置微信圈
    [shareParams SSDKSetupWeChatParamsByText:self.groupName title:self.groupName url:shareUrl thumbImage:shareImg image:nil musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil sourceFileExtension:nil sourceFileData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
    //设置qq
    
    [shareParams SSDKSetupQQParamsByText:self.groupName title:self.groupName url:shareUrl  thumbImage:shareImg image:shareImg type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQQFriend];
    //设置qq空间
    [shareParams SSDKSetupQQParamsByText:self.groupName title:self.groupName url:shareUrl  thumbImage:shareImg image:shareImg type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeQZone];
    //设置拷贝
    [shareParams SSDKSetupCopyParamsByText:self.groupName images:imageArray url:shareUrl type:SSDKContentTypeAuto];
    
    
    
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
                
                //                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                //                                                                    message:nil
                //                                                                   delegate:nil
                //                                                          cancelButtonTitle:@"确定"
                //                                                          otherButtonTitles:nil];
                //                [alertView show];
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
            }
            case SSDKResponseStateCancel:
            {
                //                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                //                                                                    message:nil
                //                                                                   delegate:nil
                //                                                          cancelButtonTitle:@"确定"
                //                                                          otherButtonTitles:nil];
                //                [alertView show];
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


-(void)setLookMoreBack{
    CGRect makeApostFrame = CGRectMake(0 , SCREENHEIGHT-44, SCREENWIDTH, 44);
    self.lookMoreBackView = [[UIView alloc]initWithFrame:makeApostFrame];
    self.lookMoreBackView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.view addSubview:self.lookMoreBackView];
    UIImageView *img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 44)];
    img.image = [UIImage imageNamed:@"group_more_post"];
    [self.lookMoreBackView addSubview:img];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeIcon)];
    img.userInteractionEnabled = YES;
    [img addGestureRecognizer:singleTap];
}
-(void)changeIcon{
    if (_isHideClassList == YES) {
        [self setClassTableView];
        
    }else{
        [self hideClassTableView];
    }
}
-(void)setClassTableView{
    _isHideClassList = NO;
    if (_classTableView) {
        _classTableView.hidden = NO;
        CGRect frame;
        if (_classArray.count == 0) {
            if ([self.user_id intValue] == [LOGIN_USER_ID intValue]) {
                //有添加分类的按钮
                frame = CGRectMake((SCREENWIDTH-86)/2, SCREENHEIGHT-35-30, 86,30);
                
            }else{
                //直接显示全部
                frame = CGRectMake((SCREENWIDTH-86)/2,SCREENHEIGHT-35-30, 86,30);
                
            }
        }else{
            if ([self.user_id intValue] == [LOGIN_USER_ID intValue]) {
                //有添加分类的按钮
                frame = CGRectMake((SCREENWIDTH-86)/2, SCREENHEIGHT-35-(_classArray.count*30+30+30), 86,_classArray.count*30+30+30);
                
            }else{
                //直接显示全部
                frame = CGRectMake((SCREENWIDTH-86)/2, SCREENHEIGHT-35-(_classArray.count*30+30), 86,_classArray.count*30+30);
                
            }
            
        }
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _classTableView.frame = frame;

        }completion:^(BOOL finished){
            
        }];

        [_classTableView reloadData];
        return;
    }
    CGRect frame;
    if (_classArray.count == 0) {
        if ([self.user_id intValue] == [LOGIN_USER_ID intValue]) {
            //有添加分类的按钮
            frame = CGRectMake((SCREENWIDTH-86)/2, SCREENHEIGHT-35-60, 86,60);
            
        }else{
            //直接显示全部
            frame = CGRectMake((SCREENWIDTH-86)/2, SCREENHEIGHT-35-30, 86,30);
            
        }
    }else{
        if ([self.user_id intValue] == [LOGIN_USER_ID intValue]) {
            //有添加分类的按钮
            frame = CGRectMake((SCREENWIDTH-86)/2, SCREENHEIGHT-35-(_classArray.count*30+30+30), 86,_classArray.count*30+30+30);
            
        }else{
            //直接显示全部
            frame = CGRectMake((SCREENWIDTH-86)/2, SCREENHEIGHT-35-(_classArray.count*30+30), 86,_classArray.count*30+30);
            
        }
        
    }
    
    _classTableView = [[UITableView alloc]init];
    _classTableView.frame= CGRectMake((SCREENWIDTH-86)/2,SCREENHEIGHT-35,86, 0);
    _classTableView.delegate = self;
    _classTableView.dataSource = self;
    _classTableView.backgroundColor = [UIColor whiteColor];
    [_classTableView   setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_classTableView];
    [self.view bringSubviewToFront:_classTableView];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        _classTableView.frame= frame;
    }completion:^(BOOL finished){
        
    }];

    
  //天天
}
-(void)hideClassTableView{
    _isHideClassList = YES;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
       // _classTableView.hidden = YES;
        _classTableView.frame = CGRectMake((SCREENWIDTH-86)/2, SCREENHEIGHT-35,86, 0);
    }completion:^(BOOL finished){
        
    }];
 }
-(void)setMakeApostBtnView{
    CGRect makeApostFrame = CGRectMake(SCREENWIDTH-53 , SCREENHEIGHT-110, 42, 42);
    self.makeAPostBtn = [YLButton buttonWithFrame:makeApostFrame type:UIButtonTypeCustom backImage:[UIImage imageNamed:@"img_myshow_newmakeashow"] target:self action:@selector(makeAPost) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.makeAPostBtn];
    
}
//发帖
-(void)makeAPost{
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    
    if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
        return;
    }
    PostBarNewMakeAPost *makePostVC=[[PostBarNewMakeAPost alloc]init];
    makePostVC.group_id = self.group_id;
    makePostVC.isFromGroup = @"isfromGroup";
    makePostVC.update = ^(){
        
    };
    [makePostVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:makePostVC animated:YES];
}

-(void)back{
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
        NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults];
        [pushJudge setObject:@""forKey:@"push"];
        [pushJudge synchronize];//记得立即同步
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }else{
                if ([self.isFromMakeGroup isEqualToString:@"isFromMakeGroup"]) {
                    theAppDelegate.tabbarcontroller.selectedIndex = 0;
                    theAppDelegate.window.rootViewController = theAppDelegate.tabbarcontroller;
                    [theAppDelegate.tabbarcontroller setBBStabbarSelectedIndex:0];
                    [self dismissViewControllerAnimated:YES completion:^{
                        
                        
                    }];
        
        
                }else{
        [self.navigationController popViewControllerAnimated:YES];
                }
    }
}
//点击头部的编辑出来的页面，弹窗选择
-(void)editBaseMes{
    //点击编辑的时候的底图的展现
    if (!self.grayView) {
        //设置点击编辑的时候
        self.grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
        self.grayView.backgroundColor = [BBSColor hexStringToColor:@"333333" alpha:0.7];
        [self.view addSubview:self.grayView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeTheViewFromWidow)];
        [self.grayView addGestureRecognizer:tap];
        
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-150, SCREENWIDTH,150)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self.grayView addSubview:whiteView];
        
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 0.5)];
        lineView1.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [whiteView addSubview:lineView1];
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 101, SCREENWIDTH, 0.5)];
        lineView2.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [whiteView addSubview:lineView2];
        NSArray *titleArray = [NSArray arrayWithObjects:@"编辑头部",@"分类管理",@"帖子管理",nil];
        
        for (int i = 0; i < 3; i++) {
            YLButton *backBtn = [YLButton buttonWithFrame:CGRectMake(0, 50*i, SCREENWIDTH, 50) type:UIButtonTypeCustom backImage:nil target:self action:@selector(btnSet:) forControlEvents:UIControlEventTouchUpInside];
            backBtn.tag = 800+i;
            [whiteView addSubview:backBtn];
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"post_group_bar_manage%d",i]];
            YLButton *imgBtn = [YLButton buttonWithFrame:CGRectMake(10, 10, 28, 28) type:UIButtonTypeCustom backImage:img target:self action:nil forControlEvents:UIControlEventTouchUpInside];
            [backBtn addSubview:imgBtn];
            UILabel *textLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 14, 100, 20)];
            textLabel.text = titleArray[i];
            textLabel.textAlignment = NSTextAlignmentLeft;
            textLabel.font = [UIFont systemFontOfSize:18];
            textLabel.textColor = [BBSColor hexStringToColor:@"333333"];
            [backBtn addSubview:textLabel];
        }
    }else{
        self.grayView.hidden = NO;
    }
}

//点击收回编辑页面
-(void)removeTheViewFromWidow{
    self.grayView.hidden = YES;
    
}
//点击编辑按钮的设置
-(void)btnSet:(id)sender{
    UIButton *button = (UIButton*)sender;
    if (button.tag == 800) {
        //跳转编辑头部
        EditHeadMessVC *editHeadMessVC = [[EditHeadMessVC alloc]init];
        editHeadMessVC.cover = self.cover;
        editHeadMessVC.groupName = self.groupName;
        editHeadMessVC.desSub = self.desSub;
        editHeadMessVC.groupId = self.group_id;
        editHeadMessVC.recommend_title = self.recommend_title;
        editHeadMessVC.color_index = self.color_index;
        [self.navigationController pushViewController:editHeadMessVC animated:YES];
    }else if (button.tag == 801){
        //跳转分类管理
        SortManagementVC *sortManagement = [[SortManagementVC alloc]init];
        sortManagement.groupId = self.group_id;
        [self.navigationController pushViewController:sortManagement animated:YES];
        
    }else{
        //跳转帖子管理
        PostBarManagementVC *postBarManagementVC = [[PostBarManagementVC alloc]init];
        postBarManagementVC.groupId = self.group_id;
        [self.navigationController pushViewController:postBarManagementVC animated:YES];
    }
    
}
-(void)addOrCancelFocusAction{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:LOGIN_USER_ID forKey:@"login_user_id"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)self.group_id]forKey:@"group_id"];
    NetAccess *net = [NetAccess sharedNetAccess];
    if ([self.is_idol isEqualToString:@"0"]) {
        [net getDataWithStyle:NetStylePostIdol andParam:param];
    }else{
        [net getDataWithStyle:NetStyleCancelPostIdol andParam:param];
    }
    
}
//添加关注成功的通知方法
-(void)postIdolSucceed{
    //
    [self getHeaderViewData];
}
//添加失败的通知方法
-(void)postIdolFail{
}

//取消关注通知方法
-(void)cancelPostIdolSucceed{
    [self getHeaderViewData];
}
-(void)cancelPostIdolFail{
    
}
-(void)setTableView{
    _tableViewNew = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-44)];
    _tableViewNew.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableViewNew.tableHeaderView = self.grayHeadView;
    _tableViewNew.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewNew.showsVerticalScrollIndicator = NO;
    _tableViewNew.delegate = self;
    _tableViewNew.dataSource = self;
    [self.view addSubview:_tableViewNew];
}
#pragma mark KVC回调
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"])
    {
        CGPoint offset = [change[NSKeyValueChangeNewKey] CGPointValue];
        self.heightClassTableView = 213-offset.y;
        if (_isHideClassList == NO) {
            [self hideClassTableView];
        }
    }
    
}

#pragma mark  刷新控件refreshControl
-(void)refreshControlInit{
    _refreshControl = [[RefreshControl alloc]initWithScrollView:_tableViewNew delegate:self];
    _refreshControl.delegate = self;
    _refreshControl.topEnabled = YES;
    _refreshControl.bottomEnabled = NO;
    [_refreshControl startRefreshingDirection:RefreshDirectionTop];
}
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    if (refreshControl == _refreshControl) {
        if (direction == RefreshDirectionTop) {
            [self getHeaderViewData];
            [self getClassListArray];
            postCreatTime = NULL;
            
        }
        [self getNewTableViewData];
    }
}

-(void)refreshComplete :(RefreshControl *)refreshControl{
    if (refreshControl.refreshingDirection==RefreshingDirectionTop)
    {
        [refreshControl finishRefreshingDirection:RefreshDirectionTop];
    }
    else if (refreshControl.refreshingDirection==RefreshingDirectionBottom)
    {
        [refreshControl finishRefreshingDirection:RefreshDirectionBottom];
    }
}
#pragma mark 获取头部的data
-(void)getClassListArray{
    [_classArray removeAllObjects];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%ld",(long)self.group_id],@"group_id", nil];
    UrlMaker *urlMark = [[UrlMaker alloc]initWithNewV1UrlStr:kgetGroupCategoryV1 Method:NetMethodGet andParam:params];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMark.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    __weak ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:@"success"]integerValue] == 1) {
            NSArray *dataArray = [dic objectForKey:@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
            for (NSDictionary *dataDic in dataArray) {
                SortClassItem *item = [[SortClassItem alloc]init];
                item.group_class_id = MBNonEmptyString(dataDic[@"group_class_id"]);
                item.title = MBNonEmptyString(dataDic[@"title"]);
                [returnArray addObject:item];
            }
            [_classArray addObjectsFromArray:returnArray];
        }
        
    }];
    [request setFailedBlock:^{
        
    }];
}
-(void)getHeaderViewData{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%ld",(long)self.group_id],@"group_id",nil];
    [[HTTPClient sharedClient]getNewV1:kgroupHeadInfo params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *infoDic = result[@"data"];
            [self.headImgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",infoDic[@"cover"]]]];
            self.cover =[NSString stringWithFormat:@"%@",infoDic[@"cover"]];
            NSString *nickName = infoDic[@"group_name"];
            self.groupName  = nickName;
            
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:20]};
            CGSize nickSize = [nickName sizeWithAttributes:attributes];
            NSString *groupState = infoDic[@"group_state"];
            
            self.business_id = infoDic[@"business_id"];
            self.user_id = infoDic[@"user_id"];
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]init];
            [self.headImgView addGestureRecognizer:singleTap];
            self.groupNameBtn.font = [UIFont systemFontOfSize:20];
            
            self.is_business = infoDic[@"is_business"];
            self.cityId = infoDic[@"city_id"];
            self.is_toys = infoDic[@"is_toys"];
            self.is_growth = infoDic[@"is_growth"];
            self.is_album = infoDic[@"is_album"];
            
            //是否展示相册.个人成长记录
            if ([self.is_album isEqualToString:@"1"]) {
                self.albumBtn.hidden = NO;
                self.albumBtn.frame = CGRectMake(SCREENWIDTH-150+75,SCREENWIDTH*0.55+8, 70, 28);
                [self.albumBtn addTarget:self action:@selector(pushAlbum) forControlEvents:UIControlEventTouchUpInside];

            }else{
                self.albumBtn.hidden = NO;
                self.albumBtn.frame = CGRectMake(SCREENWIDTH-150+75+5,SCREENWIDTH*0.55+8,0,0);

            }
            if ([self.is_growth isEqualToString:@"1"]) {
                 self.diaryBtn.hidden = NO;
                self.diaryBtn.frame = CGRectMake(self.albumBtn.frame.origin.x-self.albumBtn.frame.size.width -5,SCREENWIDTH*0.55+8, 70, 28);
                [self.diaryBtn addTarget:self action:@selector(pushDiary) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                self.diaryBtn.hidden = NO;
                self.diaryBtn.frame = CGRectMake(self.albumBtn.frame.origin.x-self.albumBtn.frame.size.width,SCREENWIDTH*0.55+8, 0,0);
            }
            if ([self.is_toys isEqualToString:@"1"]) {
                self.toyListBtn.hidden = NO;
                self.toyListBtn.frame = CGRectMake(self.diaryBtn.frame.origin.x-self.diaryBtn.frame.size.width -5,SCREENWIDTH*0.55+8, 70, 28) ;
                [self.toyListBtn addTarget:self action:@selector(pushToyList) forControlEvents:UIControlEventTouchUpInside];

            }else{
                self.toyListBtn.hidden = NO;
                   self.toyListBtn.frame = CGRectMake(self.diaryBtn.frame.origin.x-self.diaryBtn.frame.size.width ,SCREENWIDTH*0.55+8, 0, 0) ;
                
            }
            if ([self.is_business isEqualToString:@"1"]) {
                self.storeBtn.hidden =NO;
                self.storeBtn.frame = CGRectMake(self.toyListBtn.frame.origin.x-self.toyListBtn.frame.size.width -5,SCREENWIDTH*0.55+8, 70, 28);
                [self.storeBtn addTarget:self action:@selector(goToStoreList) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                 self.storeBtn.hidden =NO;
                self.storeBtn.frame = CGRectMake(self.toyListBtn.frame.origin.x-self.toyListBtn.frame.size.width ,SCREENWIDTH*0.55+8, 0, 0);
            }
            self.hotDataLabel.hidden = YES;
            //如果是用户
            if ([groupState isEqualToString:@"0"]) {
                self.groupNameBtn.frame = CGRectMake((SCREENWIDTH-nickSize.width)/2, 60, nickSize.width, 30);
                self.storeImgBtn.hidden = YES;
                [singleTap addTarget:self action:@selector(goToGroupMess)];
                
            }else{
                self.groupNameBtn.frame = CGRectMake((SCREENWIDTH-35-nickSize.width)/2+3, 60, nickSize.width+10,30);
                self.storeImgBtn.hidden = NO;
                self.storeImgBtn.frame = CGRectMake(self.groupNameBtn.frame.origin.x+self.groupNameBtn.frame.size.width, 58, 25, 25);
                
                [singleTap addTarget:self action:@selector(goToStoreDetail)];
            }
            self.groupNameBtn.text = nickName;
            if([infoDic[@"idol_count"] isKindOfClass:[NSNull class]] ){
            }else{
                NSString *review_count = infoDic[@"idol_count"];
                self.focusCountLabel.text = [NSString stringWithFormat:@"%@人关注",review_count];
            }
            NSString *introduceString = infoDic[@"description"];
            CGFloat height =  [self resetFrameWithTitle:introduceString width:self.introduceLabel.frame.size.width font:13];
            self.introduceLabel.frame = CGRectMake(60, 90, SCREENWIDTH-120, height);
            self.introduceLabel.lineBreakMode = 1;
            self.introduceLabel.text = introduceString;
            self.desSub = introduceString;
            self.is_idol = infoDic[@"is_idol"];
            self.color_index = infoDic[@"color_index"];
            self.recommend_title = infoDic[@"recommend_title"];
            self.hotDataLabel.text = self.recommend_title;

            if ([infoDic[@"color_index"] isEqualToString:@"1"]) {
                self.groupNameBtn.textColor = [BBSColor hexStringToColor:@"ff625f"];
                self.introduceLabel.textColor = [BBSColor hexStringToColor:@"ff625f"];
                self.focusCountLabel.textColor = [BBSColor hexStringToColor:@"ff625f"];
                
            }else if ([infoDic[@"color_index"] isEqualToString:@"2"]){
                self.groupNameBtn.textColor = [BBSColor hexStringToColor:@"fefa56"];
                self.introduceLabel.textColor = [BBSColor hexStringToColor:@"fefa56"];
                self.focusCountLabel.textColor = [BBSColor hexStringToColor:@"fefa56"];
            }else if ([infoDic[@"color_index"] isEqualToString:@"5"]){
                self.groupNameBtn.textColor = [BBSColor hexStringToColor:@"7a8eff"];
                self.introduceLabel.textColor = [BBSColor hexStringToColor:@"7a8eff"];
                self.focusCountLabel.textColor = [BBSColor hexStringToColor:@"7a8eff"];
            }else if ([infoDic[@"color_index"] isEqualToString:@"4"]){
                self.groupNameBtn.textColor = [BBSColor hexStringToColor:@"333333"];
                self.introduceLabel.textColor = [BBSColor hexStringToColor:@"333333"];
                self.focusCountLabel.textColor = [BBSColor hexStringToColor:@"333333"];
            }else if ([infoDic[@"color_index"] isEqualToString:@"3"]){
                self.groupNameBtn.textColor = [BBSColor hexStringToColor:@"f5f5f5"];
                self.introduceLabel.textColor = [BBSColor hexStringToColor:@"f5f5f5"];
                self.focusCountLabel.textColor = [BBSColor hexStringToColor:@"f5f5f5"];
                
            }
            
            if ([self.user_id intValue] == [LOGIN_USER_ID intValue]) {
                self.editBigbtn.hidden = NO;
                self.editBtn.hidden = NO;
            }else{
                self.editBigbtn.hidden = YES;
                self.editBtn.hidden = YES;
                
            }
            
            if ([self.user_id intValue]==[LOGIN_USER_ID intValue]) {
                self.addFocusBtn.hidden = NO;
                self.addFocusBtn.enabled = NO;
                [self.addFocusBtn setBackgroundImage:[UIImage imageNamed:@"post_bar_group_cancle_fouce"] forState:UIControlStateNormal];
            }else{
                self.addFocusBtn.hidden = NO;
                self.addFocusBtn.enabled = YES;

                if ([self.is_idol isEqualToString:@"0"]) {
                    //没关注过
                    [self.addFocusBtn setBackgroundImage:[UIImage imageNamed:@"post_bar_group_add_fouce"] forState:UIControlStateNormal];
                }else{
                    [self.addFocusBtn setBackgroundImage:[UIImage imageNamed:@"post_bar_group_cancle_fouce"] forState:UIControlStateNormal];
                }
                
            }
            
            //[infoDic objectForKey:@"group_name"];
        }
    } failed:^(NSError *error) {
        // [BBSAlert showAlertWithContent:@"网络连接错误请重试" andDelegate:nil];
        
    }];
}
#pragma mark 列表下面的数据
-(void)getNewTableViewData{
    [self hideClassTableView];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%ld",self.group_id],@"group_id",self.group_class_id,@"group_class_id",postCreatTime,@"post_create_time",nil];
    
    UrlMaker *urlMark = [[UrlMaker alloc]initWithNewV1UrlStr:@"webGroupListingPage" Method:NetMethodGet andParam:params];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMark.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    __weak ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:@"success"]integerValue] == 1) {
            NSArray *dataArray = [dic objectForKey:@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
            for (NSDictionary *dataDic in dataArray) {
                BabyShowMainItem *item = [[BabyShowMainItem alloc]init];
                item.imgTitle = MBNonEmptyString(dataDic[@"img_title"]);
                item.img_description = MBNonEmptyString(dataDic[@"img_description"]);
                item.hot_time_title = MBNonEmptyString(dataDic[@"hot_time_title"]);
                item.postCount = MBNonEmptyString(dataDic[@"post_count"]);
                item.style = MBNonEmptyString(dataDic[@"style"]);
                item.imgStyle = [MBNonEmptyString(dataDic[@"img_style"])integerValue];
                item.video_url = MBNonEmptyString(dataDic[@"video_url"]);
                item.tag_id = [MBNonEmptyString(dataDic[@"tag_id"])integerValue];
                item.userName = MBNonEmptyString(dataDic[@"user_name"]);
                item.type = MBNonEmptyString(dataDic[@"type"]);
                item.postCreattime = MBNonEmptyString(dataDic[@"post_create_time"]);
                item.show_post_create_time = MBNonEmptyString(dataDic[@"show_post_create_time"]);
                item.imgArray = dataDic[@"img"];
                item.post_url = MBNonEmptyString(dataDic[@"post_url"]);
                //item.business_id = MBNonEmptyString(dataDic[@"business_id"]);
                item.group_class_title = MBNonEmptyString(dataDic[@"group_class_title"]);
                item.essence_state =MBNonEmptyString(dataDic[@"essence_state"]);
                
                if (item.imgStyle == 8) {
                    //单图
                    item.height = 223;
                    
                }else if (item.imgStyle == 5){
                    
                    item.height = [self resetFrameWithTitle:item.imgTitle width:SCREENWIDTH-10];
                    
                    //纯文字
                }else if (item.imgStyle == 6 || item.imgStyle == 7){
                    //单图加文字
                    item.height = [self resetFrameWithTitle:item.imgTitle width:SCREENWIDTH-104-20];
                    
                }
                [returnArray addObject:item];
            }
            if (returnArray.count == 0) {
                _refreshControl.bottomEnabled = NO;
                
            }
            if (postCreatTime == NULL) {
                [tableArray removeAllObjects];
                _refreshControl.bottomEnabled = YES;
            }
            BabyShowMainItem *item = [returnArray lastObject];
            postCreatTime = item.postCreattime;
            
            [tableArray addObjectsFromArray:returnArray];
            if (tableArray.count == 0) {
                [BBSAlert showAlertWithContent:@"暂时没有相关分类" andDelegate:self];
            }
            [_tableViewNew reloadData];
            [self refreshComplete:_refreshControl];
        }
        
    }];
    [request setFailedBlock:^{
        [self refreshComplete:_refreshControl];
    }];
    
}
//进入商家详情
-(void)goToStoreDetail{
    StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
    storeVC.longin_user_id = LOGIN_USER_ID;
    storeVC.business_id = self.business_id;
    [self.navigationController pushViewController:storeVC animated:YES];
    
}
//进入个人中心
-(void)goToGroupMess{
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.userid=[NSString stringWithFormat:@"%@",self.business_id];
    myHomePage.hidesBottomBarWhenPushed=YES;
    
    if ([self.user_id intValue]==[LOGIN_USER_ID intValue]) {
        myHomePage.Type=0;
    }else{
        
        myHomePage.Type=1;
        
    }
    
    [self.navigationController pushViewController:myHomePage animated:YES];
    
}
#pragma mark 判断控件的高度
//传入宽度和题目之后的高度
-(CGFloat)resetFrameWithTitle:(NSString*)title width:(CGFloat)width{
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float height = 0.0;
    
    if (title.length>0) {
        if (size.height >17.900391) {
            height = 40;
        }else{
            height = 20;
        }
        
    }else{
        height = 0;
    }
    
    return height;
    
}

//传入宽度和题目之后的高度
-(CGFloat)resetFrameWithTitle:(NSString*)title width:(CGFloat)width font:(CGFloat)font{
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:font],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float height = 0.0;
    
    if (title.length>0) {
        if (size.height >15.509) {
            height = 40;
        }else{
            height = 20;
        }
        
    }else{
        height = 0;
    }
    
    return height;
    
}
#pragma mark  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:_classTableView]) {
        if (_classArray.count == 0) {
            if ([self.user_id intValue] == [LOGIN_USER_ID intValue]) {
                return 2;
            }else{
                return 1;
            }
        }else{
            if ([self.user_id intValue] == [LOGIN_USER_ID intValue]) {
                return _classArray.count+2;
            }else{
                return _classArray.count+1;
            }
            
            
        }
    }
    return tableArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_classTableView]) {
        return 30;
    }else{
        BabyShowMainItem *item = [tableArray objectAtIndex:indexPath.row];
        if (item.imgStyle == 8) {
            return 200;
            
        }else if (item.imgStyle == 7 || item.imgStyle == 6){
            return 90;
        }else if (item.imgStyle == 5){
            if (item.height == 0) {
                return 12+12+12;
            }else{
                return 12+item.height+12+12+12;
                
            }
        }
    }
    return 0;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *returnCell;
    if ([tableView isEqual:_classTableView]) {
        static NSString *identifier = @"identifierAdd";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor whiteColor];
            
        }
        
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        UILabel *nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 86, 30)];
        nicknameLabel.backgroundColor = [UIColor clearColor];
        nicknameLabel.textAlignment = NSTextAlignmentCenter;
        nicknameLabel.textColor = [BBSColor hexStringToColor:@"ff646a"];
        nicknameLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:nicknameLabel];
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 31, 86, 1)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"ff646a"];
        [cell.contentView addSubview:lineView];
        
        UIImageView *lineViewLeft = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 30)];
        lineViewLeft.backgroundColor = [BBSColor hexStringToColor:@"ff646a"];
        [cell.contentView addSubview:lineViewLeft];
        UIImageView *lineViewRight = [[UIImageView alloc]initWithFrame:CGRectMake(85, 0, 1, 30)];
        lineViewRight.backgroundColor = [BBSColor hexStringToColor:@"ff646a"];
        [cell.contentView addSubview:lineViewRight];

        
        
        if (_classArray.count == 0) {
            if ([self.user_id intValue] == [LOGIN_USER_ID intValue]) {
                if (indexPath.row == 0) {
                    UIImageView *lineViewTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 86, 1)];
                    lineViewTop.backgroundColor = [BBSColor hexStringToColor:@"ff646a"];
                    [cell.contentView addSubview:lineViewTop];

                    nicknameLabel.text = @"全部";
                }else{
                    nicknameLabel.text = @"+添加分类";
                }
            }else{
                if (indexPath.row == 0) {
                    UIImageView *lineViewTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 86, 1)];
                    lineViewTop.backgroundColor = [BBSColor hexStringToColor:@"ff646a"];
                    [cell.contentView addSubview:lineViewTop];

                    nicknameLabel.text = @"全部";
                }
                
            }
        }else{
            if ([self.user_id intValue] == [LOGIN_USER_ID intValue]) {
                if (indexPath.row == 0) {
                    UIImageView *lineViewTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 86, 1)];
                    lineViewTop.backgroundColor = [BBSColor hexStringToColor:@"ff646a"];
                    [cell.contentView addSubview:lineViewTop];

                    nicknameLabel.text = @"全部";
                }else if (indexPath.row == _classArray.count+1) {
                    nicknameLabel.text = @"+添加分类";
                }else{
                    SortClassItem *item = [_classArray objectAtIndex:indexPath.row-1];
                    nicknameLabel.text = [NSString stringWithFormat:@"%@",item.title];
                }
            }else{
                if (indexPath.row == 0) {
                    UIImageView *lineViewTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 86, 1)];
                    lineViewTop.backgroundColor = [BBSColor hexStringToColor:@"ff646a"];
                    [cell.contentView addSubview:lineViewTop];

                    nicknameLabel.text = @"全部";
                }else{
                    SortClassItem *item = [_classArray objectAtIndex:indexPath.row-1];
                    nicknameLabel.text = [NSString stringWithFormat:@"%@",item.title];
                }
            }
            
        }
        returnCell = cell;
        
        
    }else{
        BabyShowMainItem *item = [tableArray objectAtIndex:indexPath.row];
        if (item.imgStyle == 8) {
            static NSString *identifier = @"LEFTBESTPOSTCELL";
            LeftBestPostCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[LeftBestPostCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            NSString *imgTitle;
            NSDictionary *imgDic1;
            
            if (item.imgArray) {
                imgDic1 = item.imgArray[0];
                imgTitle = MBNonEmptyString(imgDic1[@"img_thumb"]);
                
            }
            if (imgTitle.length > 0) {
                [cell.imgViewBig sd_setImageWithURL:[NSURL URLWithString:imgTitle]];
            }
            cell.hotDataLabel.text = item.userName;
            cell.titleLabel.text = item.imgTitle;
            cell.subuTitleLabel.text = item.img_description;
            cell.hotDataLabel.text = [NSString stringWithFormat:@"-  %@  -",item.hot_time_title];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            returnCell = cell;
            
        }else if (item.imgStyle == 5){
            //纯文字
            NSString *identifier = [NSString stringWithFormat:@"POSTBARFIRSTCELL"];
            PostBarFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[PostBarFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.describleLabel.text = item.imgTitle;
            if (item.userName.length >0 && item.postCount.length > 0) {
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@   %@",item.userName,item.group_class_title];
            }else if (item.userName.length >0 && item.postCount.length <= 0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@",item.userName];
            }else if (item.userName.length <=0 && item.postCount.length >0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@",item.group_class_title];
            }
            if ([item.essence_state isEqualToString:@"1"]) {
                [cell resetFrameWithDescribeContent:item.imgTitle isHide:NO];
            }else{
            [cell resetFrameWithDescribeContent:item.imgTitle ];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            returnCell = cell;
            
            
        }else if(item.imgStyle == 7 || item.imgStyle == 6) {
            static NSString *identifier = @"SINGLEPHOTOGROUPCELL";
            SinglePhotoGroupCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (cell == nil) {
                cell = [[SinglePhotoGroupCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            cell.titleLabel.text = item.imgTitle;
            NSString *imgTitle;
            NSDictionary *imgDic1;
            if (item.imgArray) {
                imgDic1 = item.imgArray[0];
                imgTitle = MBNonEmptyString(imgDic1[@"img_thumb"]);
                
            }
            if (imgTitle.length > 0) {
                [cell.photoView sd_setImageWithURL:[NSURL URLWithString:imgTitle]];
            }
            if (item.userName.length >0 && item.postCount.length > 0) {
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@   %@",item.userName,item.group_class_title];
            }else if (item.userName.length >0 && item.postCount.length <= 0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@",item.userName];
            }else if (item.userName.length <=0 && item.postCount.length >0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@",item.group_class_title];
            }
            if (item.video_url.length>0) {
                cell.videoView.frame = CGRectMake(213+30, 30, 67*0.5, 67*0.5);
            }else{
                cell.videoView.frame = CGRectMake(0, 0, 0, 0);
                
            }
            if ([item.essence_state isEqualToString:@"1"]) {
                cell.praiseCountLabel.frame = CGRectMake(30, 90-22, 191, 12);
                cell.essImgView.frame = CGRectMake(5, 90-25, 20, 17);
                cell.essImgView.hidden = NO;

            }else{
                cell.praiseCountLabel.frame = CGRectMake(5, 90-22, 191, 12);
                cell.essImgView.hidden = YES;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            returnCell = cell;
            
        }
    }
    return returnCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_classTableView]) {
        if (_classArray.count == 0) {
            if ([self.user_id intValue] == [LOGIN_USER_ID intValue]) {
                if (indexPath.row == 1) {
                    //跳转分类管理
                    SortManagementVC *sortManagement = [[SortManagementVC alloc]init];
                    sortManagement.groupId = self.group_id;
                    [self.navigationController pushViewController:sortManagement animated:YES];
                    
                }else{
                    [self hideClassTableView];
                }
            }else{
                //不用操作
                [self hideClassTableView];
            }
        }else{
            if ([self.user_id intValue] == [LOGIN_USER_ID intValue]) {
                if (indexPath.row == 0) {
                    
                    self.group_class_id = @"0";
                    postCreatTime = NULL;
                    [self getNewTableViewData];
                    
                }else if (indexPath.row == _classArray.count+1){
                    SortManagementVC *sortManagement = [[SortManagementVC alloc]init];
                    sortManagement.groupId = self.group_id;
                    [self.navigationController pushViewController:sortManagement animated:YES];
                }else{
                    SortClassItem *item = [_classArray objectAtIndex:indexPath.row-1];
                    self.group_class_id = item.group_class_id;
                    postCreatTime = NULL;
                    [self getNewTableViewData];
                }
                
            }else{
                if (indexPath.row == 0) {
                    self.group_class_id = @"0";
                    postCreatTime = NULL;
                    [self getNewTableViewData];
                    
                }else{
                    SortClassItem *item = [_classArray objectAtIndex:indexPath.row-1];
                    self.group_class_id = item.group_class_id;
                    postCreatTime = NULL;
                    [self getNewTableViewData];
                    
                }
                
            }
        }
        
    }else{
        [self hideClassTableView];
        BabyShowMainItem *item = [tableArray objectAtIndex:indexPath.row];
        NSString *imgId;
        NSString *userId ;
        NSString *imgIds;//跳列表时用的标示
        NSString *type;
        BOOL isHV;
        if (item.imgArray) {
            imgId  = item.imgArray[0][@"img_id"];
            userId = item.imgArray[0][@"user_id"];
            float height = [item.imgArray[0][@"img_thumb_height"] floatValue];
            float weight = [item.imgArray[0][@"img_thumb_width"] floatValue];
            if (height > weight) {
                isHV = NO;//横屏
            }else{
                isHV = YES;
            }
            
            
        }
        imgIds = item.img_ids;
        type = item.type;
        if ([item.type isEqualToString:@"2"]){
            //某个帖
            [self pushPostNewDetialVC:imgId userId:userId];
            
        }else if ([item.type isEqualToString:@"3"]){
            //视频帖
            [self pushBabyShowPlayer:item.video_url imgId:imgId isHV:isHV];
            
        }else if ([item.type isEqualToString:@"22"]){
            //某一个商家
            [self pushStoreDetialNewVC:imgId];

        }else if ([item.type isEqualToString:@"41"]){
            //外链
            [self pushImgid:item.imgId webUrl:item.post_url];
            
        }
    }
    
}
#pragma mark 跳转成长记录
-(void)pushDiary{
    BBSTabBarViewController *tabVC = [[BBSTabBarViewController alloc]init];
    theAppDelegate.window.rootViewController = tabVC;
    [tabVC setBBStabbarSelectedIndex:2];
    tabVC.selectedIndex = 2;
    
}
#pragma mark 跳转个人相册
-(void)pushAlbum{
    //我的相册
    AlbumListViewController *albumListViewController = [[AlbumListViewController alloc] init];
    albumListViewController.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:albumListViewController animated:YES];
    
}
#pragma mark 跳转商家列表
-(void)goToStoreList{
    StoreMoreListVC *storeListVC = [[StoreMoreListVC alloc]init];
    storeListVC.cityId = self.cityId;
    storeListVC.login_user_id = LOGIN_USER_ID;
    storeListVC.fromGroup = @"1";
    
    [self.navigationController pushViewController:storeListVC animated:YES];
    
}

#pragma mark 跳转玩具列表
-(void)pushToyList{
    ToyLeaseNewVC *toyVC = [[ToyLeaseNewVC alloc]init];
    [self.navigationController pushViewController:toyVC animated:YES];
}


#pragma mark 跳转商家详情
-(void)pushStoreDetialNewVC:(NSString*)imgId{
    StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
    storeVC.longin_user_id = LOGIN_USER_ID;
    storeVC.business_id = imgId;
    [self.navigationController pushViewController:storeVC animated:YES];
}
#pragma mark 跳转外链
-(void)pushImgid:(NSString*)imgId webUrl:(NSString*)webUrl{
    WebViewController *webView=[[WebViewController alloc]init];
    webView.img_id = imgId;
    webView.urlStr=[webUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [webView setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webView animated:YES];

}
#pragma mark 跳转帖子详情
-(void)pushPostNewDetialVC:(NSString *)imgId userId:(NSString*)userId {
    //跳转帖子详情
    PostBarNewDetialV1VC *detailVC = [[PostBarNewDetialV1VC alloc]init];
    detailVC.img_id=[NSString stringWithFormat:@"%@",imgId];
    detailVC.user_id=userId;
    detailVC.login_user_id=LOGIN_USER_ID;
    detailVC.refreshInVC = ^(BOOL isRefresh){
    };
    [detailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
#pragma mark 跳转群详情
-(void)pushGroupDetail{
    
}
#pragma mark 跳转视频帖子
-(void)pushBabyShowPlayer:(NSString *)video_url imgId:(NSString*)imgId   isHV:(BOOL)isHV{
    BabyShowPlayerVC *babyShowPlayerVC = [[BabyShowPlayerVC alloc]init];
    babyShowPlayerVC.img_id = imgId;
    babyShowPlayerVC.videoUrl = video_url;
    babyShowPlayerVC.isHV = isHV;
    [self.navigationController pushViewController:babyShowPlayerVC animated:YES];
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
