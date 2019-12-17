//
//  MWPhotoBrowser.m
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MWCommon.h"
#import "MWPhotoBrowser.h"
#import "MWPhotoBrowserPrivate.h"
#import "SDImageCache.h"
#import "ShowAlertView.h"
#import "JSONKit.h"
#import "SVPullToRefresh.h"

#import "MakeAShowViewController.h"
#import "PPTViewController.h"
#import "BBSNavigationControllerNotTurn.h"



#define PADDING                  10
#define ACTION_SHEET_OLD_ACTIONS 2000
#define ACTION_SHEET_DOWNLOAD_ACTIONS 2001

@implementation MWPhotoBrowser

#pragma mark - Init

- (id)init {
    if ((self = [super init])) {
        [self _initialisation];
    }
    return self;
}

- (id)initWithDelegate:(id <MWPhotoBrowserDelegate>)delegate {
    if ((self = [self init])) {
        _delegate = delegate;
    }
    return self;
}

- (id)initWithPhotos:(NSArray *)photosArray {
    if ((self = [self init])) {
        _depreciatedPhotoData = photosArray;
        _imgArr = [[NSMutableArray alloc]init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if ((self = [super initWithCoder:decoder])) {
        [self _initialisation];
    }
    return self;
}

- (void)_initialisation {
    
    // Defaults
    NSNumber *isVCBasedStatusBarAppearanceNum = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"];
    if (isVCBasedStatusBarAppearanceNum) {
        _isVCBasedStatusBarAppearance = isVCBasedStatusBarAppearanceNum.boolValue;
    } else {
        _isVCBasedStatusBarAppearance = YES; // default
    }
    self.extendedLayoutIncludesOpaqueBars = YES;
    self.hidesBottomBarWhenPushed = YES;
    _photoCount = NSNotFound;
    _previousLayoutBounds = CGRectZero;
    _currentPageIndex = 0;
    _previousPageIndex = NSUIntegerMax;
    _displayActionButton = YES;
    _displayNavArrows = NO;
    _zoomPhotosToFill = YES;
    _performingLayout = NO; // Reset on view did appear
    _rotating = NO;
    _viewIsActive = NO;
    _enableGrid = YES;
    _startOnGrid = NO;
    _visiblePages = [[NSMutableSet alloc] init];
    _recycledPages = [[NSMutableSet alloc] init];
    _photos = [[NSMutableArray alloc] init];
    _thumbPhotos = [[NSMutableArray alloc] init];
    _currentGridContentOffset = CGPointMake(0, CGFLOAT_MAX);
    _didSavePreviousStateOfNavBar = NO;
    if ([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    // Listen for MWPhoto notifications
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleMWPhotoLoadingDidEndNotification:)
                                                 name:MWPHOTO_LOADING_DID_END_NOTIFICATION
                                               object:nil];
    
}

- (void)dealloc {
    _pagingScrollView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self releaseAllUnderlyingPhotos:NO];
    [[SDImageCache sharedImageCache] clearMemory]; // clear memory
}

- (void)releaseAllUnderlyingPhotos:(BOOL)preserveCurrent {
    // Create a copy in case this array is modified while we are looping through
    // Release photos
    NSArray *copy = [_photos copy];
    for (id p in copy) {
        if (p != [NSNull null]) {
            if (preserveCurrent && p == [self photoAtIndex:self.currentIndex]) {
                continue; // skip current
            }
            [p unloadUnderlyingImage];
        }
    }
    // Release thumbs
    copy = [_thumbPhotos copy];
    for (id p in copy) {
        if (p != [NSNull null]) {
            [p unloadUnderlyingImage];
        }
    }
}

- (void)didReceiveMemoryWarning {
    
    // Release any cached data, images, etc that aren't in use.
    [self releaseAllUnderlyingPhotos:YES];
    [_recycledPages removeAllObjects];
    
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
}

#pragma mark - View Loading

-(void)setBackButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateNormal];
    //    [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
    self.shareButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.frame = CGRectMake(0, 0, 49, 31);
    [self.shareButton setTitle:@"秀一下" forState:UIControlStateNormal];
    [self.shareButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.shareButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.shareButton addTarget:self action:@selector(shareImage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:self.shareButton];
    
    //我的
    if (self.type == 0 ) {
        //秀秀相册
        if (self.is_show_album) {
            self.navigationItem.rightBarButtonItem = nil;
        }else{
            self.navigationItem.rightBarButtonItem = right;
        }
    }else if(self.type == 1 || self.type == 2){
        self.navigationItem.rightBarButtonItem = nil;
    }else if (self.type==10){
        self.navigationItem.rightBarButtonItem = nil;
    }
}
-(void)back{
    //    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)toPlay:(UIButton *)button{
    PPTViewController *ppt=[[PPTViewController alloc]init];
    ppt.photosArray=self.imgArr;
    ppt.maxPlayNumOnce=3;
    BBSNavigationControllerNotTurn *nav=[[BBSNavigationControllerNotTurn alloc]initWithRootViewController:ppt];
    [self presentViewController:nav animated:YES completion:^{}];
    
}
- (void)viewDidLoad {
    
    self.navigationItem.title=@"";
    
    // Validate grid settings
    if (_startOnGrid) _enableGrid = YES;
    if (_enableGrid) {
        _enableGrid = [_delegate respondsToSelector:@selector(photoBrowser:thumbPhotoAtIndex:)];
    }
    if (!_enableGrid) _startOnGrid = NO;
    
    // View
    self.view.backgroundColor = [UIColor blackColor];
    self.view.clipsToBounds = YES;
    [self setBackButton];
    // Setup paging scrolling view
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    _pagingScrollView = [[UIScrollView alloc] initWithFrame:pagingScrollViewFrame];
    _pagingScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _pagingScrollView.pagingEnabled = YES;
    _pagingScrollView.delegate = self;
    _pagingScrollView.bounces = YES;
    _pagingScrollView.showsHorizontalScrollIndicator = NO;
    _pagingScrollView.showsVerticalScrollIndicator = NO;
    _pagingScrollView.backgroundColor = [UIColor blackColor];
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    [self.view addSubview:_pagingScrollView];
    //	[_pagingScrollView addInfiniteScrollingWithActionHandler:^{
    //        NSLog(@"滚动到底部了,方法不走");
    //    }];
    //我的相册0,我共享的他的相册2,均可下载,其他的相册不允许下载
    //我的秀秀、广场10，以后会做成可以下载的,11从成长日记进入
    if (self.type == 0 || self.type == 2 || self.type==1 ) {
        UILongPressGestureRecognizer *longPressGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(downloadPhoto:)];
        longPressGes.minimumPressDuration = 1;
        [_pagingScrollView addGestureRecognizer:longPressGes];
    }else {
        
    }
    // Toolbar
    _toolbar = [[UIToolbar alloc] initWithFrame:[self frameForToolbarAtOrientation:self.interfaceOrientation]];
    _toolbar.tintColor = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7") ? [UIColor clearColor] : nil;
    if ([_toolbar respondsToSelector:@selector(setBarTintColor:)]) {
        _toolbar.barTintColor =nil;//[UIColor clearColor];
    }
    if ([[UIToolbar class] respondsToSelector:@selector(appearance)]) {
        [_toolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        [_toolbar setBackgroundImage:nil forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsLandscapePhone];
    }
    _toolbar.barStyle = UIBarStyleDefault;
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    
    self.rotateButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.rotateButton.frame = CGRectMake(0, 0, 320/3, 44);
    [self.rotateButton setTitle:@"旋转" forState:UIControlStateNormal];
    [self.rotateButton setTitleColor:[BBSColor hexStringToColor:BACKCOLOR] forState:UIControlStateNormal];
    [self.rotateButton addTarget:self action:@selector(rotateImage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rotateBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.rotateButton];
    
    self.deleteButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.frame = CGRectMake(0, 0, 320/3+1, 44);
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[BBSColor hexStringToColor:BACKCOLOR] forState:UIControlStateNormal];
    [self.deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *deleteBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.deleteButton];
    
    self.renameButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.renameButton.frame = CGRectMake(0, 0, 320/3+1, 44);
    [self.renameButton setTitle:@"备注" forState:UIControlStateNormal];
    [self.renameButton setTitleColor:[BBSColor hexStringToColor:BACKCOLOR] forState:UIControlStateNormal];
    [self.renameButton addTarget:self action:@selector(renameImage:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *renameBarButton = [[UIBarButtonItem alloc]initWithCustomView:self.renameButton];
    
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpace.width = 32; // To balance action button
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [_toolbar setItems:@[rotateBarButton,flexSpace,deleteBarButton,flexSpace,renameBarButton]];
    UIView *separatorLine = [[UIView alloc]initWithFrame:[self frameForSeparatorAtOrientation:self.interfaceOrientation ]];
    [separatorLine setBackgroundColor:[BBSColor hexStringToColor:BACKCOLOR]];
    separatorLine.tag = 100;
    [_toolbar addSubview:separatorLine];
    
    if (self.type == 0 ) {
        if (self.is_show_album) {
            [_toolbar setHidden:YES];
        }else{
            [_toolbar setHidden:NO];
        }
    }else if(self.type == 1 || self.type == 2){
        [_toolbar setHidden:YES];
    }else if (self.type==10){
        
        [_toolbar setHidden:YES];
        
    }
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *playImage = [UIImage imageNamed:@"img_mw_play"];
    CGRect frame = [self frameForToolbarAtOrientation:self.interfaceOrientation];
    playBtn.frame = CGRectMake(frame.origin.x + 15, frame.origin.y-40, playImage.size.width, playImage.size.height);
    [playBtn setBackgroundImage:playImage forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(toPlay:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playBtn];
    [playBtn setHidden:!self.needPlay];
    
    // Update
    [self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshNaviTitle:) name:REFRESH_NAVI_TITLE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView:) name:REFRESH_MWPHOTO_BROWSER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAfterLoadMore:) name:NOTI_AFTER_LOAD_MORE object:nil];
    
    // Super
    [super viewDidLoad];
    
}
#pragma mark - 下载图片
-(void)downloadPhoto:(UILongPressGestureRecognizer *)longPressGes{
    
    //解决长按响应两次的问题
    if (longPressGes.state == UIGestureRecognizerStateEnded) {
        return;
    }else if(longPressGes.state == UIGestureRecognizerStateBegan){
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil
                                                                delegate:self
                                                       cancelButtonTitle:@"取消"
                                                  destructiveButtonTitle:nil
                                                       otherButtonTitles:@"保存到我的相册",@"保存到手机",nil];
        actionSheet.tag = ACTION_SHEET_DOWNLOAD_ACTIONS;
        [actionSheet showInView:self.view];
    }
}
#pragma mark - 旋转,分享 删除 备注
-(void)rotateImage:(id)sender{
    _pageIndexBeforeRotation=_currentPageIndex;
    
    id <MWPhoto> photo = nil;
    photo =[self photoAtIndex:self.currentIndex];
    UIImage *image=[photo underlyingImage];
    
    if (!image) {
        
        image=self.rotateImage;
        
    }
    
    if (image.imageOrientation==UIImageOrientationUp) {
        
        UIImage *newimage=[UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationLeft];
        UIGraphicsBeginImageContext(CGSizeMake(newimage.size.width, newimage.size.height));
        [newimage drawInRect:CGRectMake(0, 0, newimage.size.width, newimage.size.height)];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        MWPhoto *newPhoto=[[MWPhoto alloc]initWithImage:newimage info:photo.img_info];
        [_photos replaceObjectAtIndex:_currentPageIndex withObject:newPhoto];
        
        for (MWZoomingScrollView *page in _visiblePages) {
            if (page.index==_currentPageIndex) {
                
                page.photoImageView.image=newimage;
                self.rotateImage=newimage;
                [self performLayout];
                _currentPageIndex=_pageIndexBeforeRotation;
                [self jumpToPageAtIndex:_currentPageIndex animated:NO];
                
            }
        }
        
    }
    
}

-(void)shareImage:(id)sender{
    [MobClick event:UMEVENTSHARE];
    id <MWPhoto> photo = nil;
    photo =[self photoAtIndex:self.currentIndex];
    UIImage *image= [photo underlyingImage];
    
    MakeAShowViewController *makeAshow=[[MakeAShowViewController alloc]init];
    makeAshow.imageArray=[NSMutableArray arrayWithObjects:image, nil];
    makeAshow.Type=1;
    makeAshow.refreshMyBlock = ^(){
        
    };
    [self.navigationController pushViewController:makeAshow animated:YES];
    
}
-(void)deleteImage:(id)sender{
    NSString *message = @"是否删除?";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = DELETE_ALERTVIEW_TAG;
    [alertView show];
}
-(void)renameImage:(id)sender{
    NSString *message = @"修改备注";
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = RENAME_ALERTVIEW_TAG;
    alertView.alertViewStyle =UIAlertViewStylePlainTextInput;
    UITextField *tf = [alertView textFieldAtIndex:0];
    tf.placeholder = @"最多10个字";
    [alertView show];
}

#pragma mark - 修改备注刷新title ,删除图片刷新视图
-(void)refreshNaviTitle:(NSNotification *)noti{
    [self updateNavigation];
}
//删除后刷新,若删除后只剩了一张,则尝试请求更多
-(void)refreshView:(NSNotification *)noti{
    [self reloadData];
    NSUInteger numberOfPhotos= [self numberOfPhotos];
    if (numberOfPhotos <=1) {
        id<MWPhoto>photo = [self photoAtIndex:_currentPageIndex];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTI_TO_LOAD_MORE object:nil userInfo:photo.img_info];
    }
    
}
-(void)refreshAfterLoadMore:(NSNotification *)noti{
    //更新需要播放的数组
    self.imgArr = [noti.userInfo objectForKey:@"imgArr"];
    [self reloadData];
}
#pragma mark -
- (void)performLayout {
    
    // Setup
    _performingLayout = YES;
    NSUInteger numberOfPhotos = [self numberOfPhotos];
    
    // Setup pages
    [_visiblePages removeAllObjects];
    [_recycledPages removeAllObjects];
    
    if (numberOfPhotos <= 0) {
        [self back];
        return;
    }
    
    // Toolbar items
    UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixedSpace.width = 32; // To balance action button
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    
    BOOL hideToolbar = YES;
    for (UIBarButtonItem* item in _toolbar.items) {
        if (item != fixedSpace && item != flexSpace) {
            hideToolbar = NO;
            break;
        }
    }
    if (hideToolbar) {
        [_toolbar removeFromSuperview];
    } else {
        [self.view addSubview:_toolbar];
    }
    
    // Update nav
    [self updateNavigation];
    
    // Content offset
    _pagingScrollView.contentOffset = [self contentOffsetForPageAtIndex:_currentPageIndex];
    [self tilePages];
    _performingLayout = NO;
    
}

// Release any retained subviews of the main view.
- (void)viewDidUnload {
    _currentPageIndex = 0;
    _pagingScrollView = nil;
    _visiblePages = nil;
    _recycledPages = nil;
    _toolbar = nil;
    _previousButton = nil;
    _nextButton = nil;
    _progressHUD = nil;
    [super viewDidUnload];
}

- (BOOL)presentingViewControllerPrefersStatusBarHidden {
    UIViewController *presenting = self.presentingViewController;
    if (presenting) {
        if ([presenting isKindOfClass:[UINavigationController class]]) {
            presenting = [(UINavigationController *)presenting topViewController];
        }
    } else {
        // We're in a navigation controller so get previous one!
        if (self.navigationController && self.navigationController.viewControllers.count > 1) {
            presenting = [self.navigationController.viewControllers objectAtIndex:self.navigationController.viewControllers.count-2];
        }
    }
    if (presenting) {
        return [presenting prefersStatusBarHidden];
    } else {
        return NO;
    }
}

#pragma mark - Appearance

- (void)viewWillAppear:(BOOL)animated {
    
    // Super
    [super viewWillAppear:animated];
    
    // Status bar
    if ([UIViewController instancesRespondToSelector:@selector(prefersStatusBarHidden)]) {
        _leaveStatusBarAlone = [self presentingViewControllerPrefersStatusBarHidden];
    } else {
        _leaveStatusBarAlone = [UIApplication sharedApplication].statusBarHidden;
    }
    if (CGRectEqualToRect([[UIApplication sharedApplication] statusBarFrame], CGRectZero)) {
        // If the frame is zero then definitely leave it alone
        _leaveStatusBarAlone = YES;
    }
    if (!_leaveStatusBarAlone && self.extendedLayoutIncludesOpaqueBars && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        _previousStatusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:animated];
    }
    
    // Navigation bar appearance
    if (!_viewIsActive && [self.navigationController.viewControllers objectAtIndex:0] != self) {
        [self storePreviousNavBarAppearance];
    }
    [self setNavBarAppearance:animated];
    
    // Hide navigation controller's toolbar
    _previousNavToolbarHidden = self.navigationController.toolbarHidden;
    [self.navigationController setToolbarHidden:YES];
    
    // Update UI
    [self hideControlsAfterDelay];
    
    // Initial appearance
    if (!_viewHasAppearedInitially) {
        if (_startOnGrid) {
            [self showGrid:NO];
        }
        _viewHasAppearedInitially = YES;
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    // Check that we're being popped for good
    if ([self.navigationController.viewControllers objectAtIndex:0] != self &&
        ![self.navigationController.viewControllers containsObject:self]) {
        
        // State
        _viewIsActive = NO;
        
        // Bar state / appearance
        [self restorePreviousNavBarAppearance:animated];
        
    }
    
    // Controls
    [self.navigationController.navigationBar.layer removeAllAnimations]; // Stop all animations on nav bar
    [NSObject cancelPreviousPerformRequestsWithTarget:self]; // Cancel any pending toggles from taps
    [self setControlsHidden:NO animated:NO permanent:YES];
    
    // Status bar
    if (!_leaveStatusBarAlone && self.extendedLayoutIncludesOpaqueBars && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [[UIApplication sharedApplication] setStatusBarStyle:_previousStatusBarStyle animated:animated];
    }
    
    // Show navigation controller's toolbar
    [self.navigationController setToolbarHidden:_previousNavToolbarHidden];
    
    //移除更新title的标题
    [[NSNotificationCenter defaultCenter]removeObserver:self name:REFRESH_NAVI_TITLE object:nil];
    // Super
    [super viewWillDisappear:animated];
    
    //    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _viewIsActive = YES;
}

#pragma mark - Nav Bar Appearance

- (void)setNavBarAppearance:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    UINavigationBar *navBar = self.navigationController.navigationBar;
    navBar.tintColor = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7") ? [UIColor whiteColor] : nil;
    
    if ([navBar respondsToSelector:@selector(setBarTintColor:)]) {
        navBar.barTintColor=[BBSColor hexStringToColor:NAVICOLOR];
        
        navBar.shadowImage = nil;
    }
    navBar.translucent = YES;
    navBar.barStyle = UIBarStyleDefault;
    
}

- (void)storePreviousNavBarAppearance {
    _didSavePreviousStateOfNavBar = YES;
    if ([UINavigationBar instancesRespondToSelector:@selector(barTintColor)]) {
        _previousNavBarBarTintColor = self.navigationController.navigationBar.barTintColor;
    }
    _previousNavBarTranslucent = self.navigationController.navigationBar.translucent;
    _previousNavBarTintColor = self.navigationController.navigationBar.tintColor;
    _previousNavBarHidden = self.navigationController.navigationBarHidden;
    _previousNavBarStyle = self.navigationController.navigationBar.barStyle;
    if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
        _previousNavigationBarBackgroundImageDefault = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
        _previousNavigationBarBackgroundImageLandscapePhone = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsLandscapePhone];
    }
}

- (void)restorePreviousNavBarAppearance:(BOOL)animated {
    if (_didSavePreviousStateOfNavBar) {
        [self.navigationController setNavigationBarHidden:_previousNavBarHidden animated:animated];
        UINavigationBar *navBar = self.navigationController.navigationBar;
        navBar.tintColor = _previousNavBarTintColor;
        navBar.translucent = _previousNavBarTranslucent;
        if ([UINavigationBar instancesRespondToSelector:@selector(barTintColor)]) {
            navBar.barTintColor = _previousNavBarBarTintColor;
        }
        navBar.barStyle = _previousNavBarStyle;
        if ([[UINavigationBar class] respondsToSelector:@selector(appearance)]) {
            [navBar setBackgroundImage:_previousNavigationBarBackgroundImageDefault forBarMetrics:UIBarMetricsDefault];
            [navBar setBackgroundImage:_previousNavigationBarBackgroundImageLandscapePhone forBarMetrics:UIBarMetricsLandscapePhone];
        }
        // Restore back button if we need to
        if (_previousViewControllerBackButton) {
            UIViewController *previousViewController = [self.navigationController topViewController]; // We've disappeared so previous is now top
            previousViewController.navigationItem.backBarButtonItem = _previousViewControllerBackButton;
            _previousViewControllerBackButton = nil;
        }
    }
}

#pragma mark - Layout

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    [self layoutVisiblePages];
}

- (void)layoutVisiblePages {
    
    // Flag
    _performingLayout = YES;
    
    // Toolbar
    _toolbar.frame = [self frameForToolbarAtOrientation:self.interfaceOrientation];
    UIView *separatorLine = (UIView *)[_toolbar viewWithTag:100];
    separatorLine.frame = [self frameForSeparatorAtOrientation:self.interfaceOrientation];
    // Remember index
    NSUInteger indexPriorToLayout = _currentPageIndex;
    
    // Get paging scroll view frame to determine if anything needs changing
    CGRect pagingScrollViewFrame = [self frameForPagingScrollView];
    
    // Frame needs changing
    if (!_skipNextPagingScrollViewPositioning) {
        _pagingScrollView.frame = pagingScrollViewFrame;
    }
    _skipNextPagingScrollViewPositioning = NO;
    
    // Recalculate contentSize based on current orientation
    _pagingScrollView.contentSize = [self contentSizeForPagingScrollView];
    
    // Adjust frames and configuration of each visible page
    for (MWZoomingScrollView *page in _visiblePages) {
        NSUInteger index = page.index;
        page.frame = [self frameForPageAtIndex:index];
        
        if (page.captionView) {
            page.captionView.frame = [self frameForCaptionView:page.captionView atIndex:index];
        }
        if (page.selectedButton) {
            page.selectedButton.frame = [self frameForSelectedButton:page.selectedButton atIndex:index];
        }
        // Adjust scales if bounds has changed since last time
        if (!CGRectEqualToRect(_previousLayoutBounds, self.view.bounds)) {
            // Update zooms for new bounds
            [page setMaxMinZoomScalesForCurrentBounds];
            _previousLayoutBounds = self.view.bounds;
        }
        
    }
    
    // Adjust contentOffset to preserve page location based on values collected prior to location
    _pagingScrollView.contentOffset = [self contentOffsetForPageAtIndex:indexPriorToLayout];
    [self didStartViewingPageAtIndex:_currentPageIndex]; // initial
    
    // Reset
    _currentPageIndex = indexPriorToLayout;
    _performingLayout = NO;
    
}

#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskLandscapeRight;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Remember page index before rotation
    _pageIndexBeforeRotation = _currentPageIndex;
    _rotating = YES;
    
    // In iOS 7 the nav bar gets shown after rotation, but might as well do this for everything!
    if ([self areControlsHidden]) {
        // Force hidden
        self.navigationController.navigationBarHidden = YES;
    }
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Perform layout
    _currentPageIndex = _pageIndexBeforeRotation;
    
    // Delay control holding
    [self hideControlsAfterDelay];
    
    // Layout
    [self layoutVisiblePages];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    _rotating = NO;
    // Ensure nav bar isn't re-displayed
    if ([self areControlsHidden]) {
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.navigationBar.alpha = 0;
    }
}

#pragma mark - Data

- (NSUInteger)currentIndex {
    return _currentPageIndex;
}

- (void)reloadData {
    
    // Reset
    _photoCount = NSNotFound;
    
    // Get data
    NSUInteger numberOfPhotos = [self numberOfPhotos];
    [self releaseAllUnderlyingPhotos:YES];
    [_photos removeAllObjects];
    [_thumbPhotos removeAllObjects];
    for (int i = 0; i < numberOfPhotos; i++) {
        [_photos addObject:[NSNull null]];
        [_thumbPhotos addObject:[NSNull null]];
    }
    
    // Remove everything
    while (_pagingScrollView.subviews.count) {
        [[_pagingScrollView.subviews lastObject] removeFromSuperview];
    }
    
    // Update current page index
    _currentPageIndex = MAX(0, MIN(_currentPageIndex, numberOfPhotos - 1));
    
    // Update
    [self performLayout];
    
    // Layout
    [self.view setNeedsLayout];
    
}

- (NSUInteger)numberOfPhotos {
    if (_photoCount == NSNotFound) {
        if ([_delegate respondsToSelector:@selector(numberOfPhotosInPhotoBrowser:)]) {
            _photoCount = [_delegate numberOfPhotosInPhotoBrowser:self];
        } else if (_depreciatedPhotoData) {
            _photoCount = _depreciatedPhotoData.count;
        }
    }
    if (_photoCount == NSNotFound) _photoCount = 0;
    return _photoCount;
}

- (id<MWPhoto>)photoAtIndex:(NSUInteger)index {
    id <MWPhoto> photo = nil;
    
    if (index < _photos.count) {
        if ([_photos objectAtIndex:index] == [NSNull null]) {
            if ([_delegate respondsToSelector:@selector(photoBrowser:photoAtIndex:)]) {
                photo = [_delegate photoBrowser:self photoAtIndex:index];
            } else if (_depreciatedPhotoData && index < _depreciatedPhotoData.count) {
                photo = [_depreciatedPhotoData objectAtIndex:index];
            }
            if (photo) [_photos replaceObjectAtIndex:index withObject:photo];
        } else {
            photo = [_photos objectAtIndex:index];
        }
    }
    
    return photo;
}


- (id<MWPhoto>)thumbPhotoAtIndex:(NSUInteger)index {
    id <MWPhoto> photo = nil;
    if (index < _thumbPhotos.count) {
        if ([_thumbPhotos objectAtIndex:index] == [NSNull null]) {
            if ([_delegate respondsToSelector:@selector(photoBrowser:thumbPhotoAtIndex:)]) {
                photo = [_delegate photoBrowser:self thumbPhotoAtIndex:index];
            }
            if (photo) [_thumbPhotos replaceObjectAtIndex:index withObject:photo];
        } else {
            photo = [_thumbPhotos objectAtIndex:index];
        }
    }
    return photo;
}

- (MWCaptionView *)captionViewForPhotoAtIndex:(NSUInteger)index {
    MWCaptionView *captionView = nil;
    if ([_delegate respondsToSelector:@selector(photoBrowser:captionViewForPhotoAtIndex:)]) {
        captionView = [_delegate photoBrowser:self captionViewForPhotoAtIndex:index];
    } else {
        id <MWPhoto> photo = [self photoAtIndex:index];
        if ([photo respondsToSelector:@selector(caption)]) {
            if ([photo caption]) captionView = [[MWCaptionView alloc] initWithPhoto:photo];
        }
    }
    captionView.alpha = [self areControlsHidden] ? 0 : 1; // Initial alpha
    return captionView;
}

- (BOOL)photoIsSelectedAtIndex:(NSUInteger)index {
    BOOL value = NO;
    if (_displaySelectionButtons) {
        if ([self.delegate respondsToSelector:@selector(photoBrowser:isPhotoSelectedAtIndex:)]) {
            value = [self.delegate photoBrowser:self isPhotoSelectedAtIndex:index];
        }
    }
    return value;
}

- (void)setPhotoSelected:(BOOL)selected atIndex:(NSUInteger)index {
    if (_displaySelectionButtons) {
        if ([self.delegate respondsToSelector:@selector(photoBrowser:photoAtIndex:selectedChanged:)]) {
            [self.delegate photoBrowser:self photoAtIndex:index selectedChanged:selected];
        }
    }
}

- (UIImage *)imageForPhoto:(id<MWPhoto>)photo {
    if (photo) {
        // Get image or obtain in background
        if ([photo underlyingImage]) {
            return [photo underlyingImage];
        } else {
            [photo loadUnderlyingImageAndNotify];
        }
    }
    return nil;
}

- (void)loadAdjacentPhotosIfNecessary:(id<MWPhoto>)photo {
    MWZoomingScrollView *page = [self pageDisplayingPhoto:photo];
    if (page) {
        // If page is current page then initiate loading of previous and next pages
        NSUInteger pageIndex = page.index;
        if (_currentPageIndex == pageIndex) {
            if (pageIndex > 0) {
                // Preload index - 1
                id <MWPhoto> photo = [self photoAtIndex:pageIndex-1];
                if (![photo underlyingImage]) {
                    [photo loadUnderlyingImageAndNotify];
                    MWLog(@"Pre-loading image at index %i", pageIndex-1);
                }
            }
            if (pageIndex < [self numberOfPhotos] - 1) {
                // Preload index + 1
                id <MWPhoto> photo = [self photoAtIndex:pageIndex+1];
                if (![photo underlyingImage]) {
                    [photo loadUnderlyingImageAndNotify];
                    MWLog(@"Pre-loading image at index %i", pageIndex+1);
                }
            }
        }
    }
}

#pragma mark - MWPhoto Loading Notification

- (void)handleMWPhotoLoadingDidEndNotification:(NSNotification *)notification {
    id <MWPhoto> photo = [notification object];
    MWZoomingScrollView *page = [self pageDisplayingPhoto:photo];
    if (page) {
        if ([photo underlyingImage]) {
            // Successful load
            [page displayImage];
            [self loadAdjacentPhotosIfNecessary:photo];
        } else {
            // Failed to load
            [page displayImageFailure];
        }
        // Update nav
        [self updateNavigation];
    }
}

#pragma mark - Paging

- (void)tilePages {
    
    // Calculate which pages should be visible
    // Ignore padding as paging bounces encroach on that
    // and lead to false page loads
    CGRect visibleBounds = _pagingScrollView.bounds;
    NSInteger iFirstIndex = (NSInteger)floorf((CGRectGetMinX(visibleBounds)+PADDING*2) / CGRectGetWidth(visibleBounds));
    NSInteger iLastIndex  = (NSInteger)floorf((CGRectGetMaxX(visibleBounds)-PADDING*2-1) / CGRectGetWidth(visibleBounds));
    if (iFirstIndex < 0) iFirstIndex = 0;
    if (iFirstIndex > [self numberOfPhotos] - 1) iFirstIndex = [self numberOfPhotos] - 1;
    if (iLastIndex < 0) iLastIndex = 0;
    if (iLastIndex > [self numberOfPhotos] - 1) iLastIndex = [self numberOfPhotos] - 1;
    
    // Recycle no longer needed pages
    NSInteger pageIndex;
    for (MWZoomingScrollView *page in _visiblePages) {
        pageIndex = page.index;
        if (pageIndex < (NSUInteger)iFirstIndex || pageIndex > (NSUInteger)iLastIndex) {
            [_recycledPages addObject:page];
            [page.captionView removeFromSuperview];
            [page.selectedButton removeFromSuperview];
            [page prepareForReuse];
            [page removeFromSuperview];
            MWLog(@"Removed page at index %i", PAGE_INDEX(page));
        }
    }
    [_visiblePages minusSet:_recycledPages];
    while (_recycledPages.count > 2) // Only keep 2 recycled pages
        [_recycledPages removeObject:[_recycledPages anyObject]];
    
    // Add missing pages
    for (NSUInteger index = (NSUInteger)iFirstIndex; index <= (NSUInteger)iLastIndex; index++) {
        if (![self isDisplayingPageForIndex:index]) {
            
            // Add new page
            MWZoomingScrollView *page = [self dequeueRecycledPage];
            if (!page) {
                page = [[MWZoomingScrollView alloc] initWithPhotoBrowser:self];
            }
            [_visiblePages addObject:page];
            [self configurePage:page forIndex:index];
            [_pagingScrollView addSubview:page];
            MWLog(@"Added page at index %i", index);
            
            // Add caption
            //            MWCaptionView *captionView = [self captionViewForPhotoAtIndex:index];
            //            if (captionView) {
            //                captionView.frame = [self frameForCaptionView:captionView atIndex:index];
            //                [_pagingScrollView addSubview:captionView];
            //                page.captionView = captionView;
            //            }
            
            /*           // Add selected button
             if (self.displaySelectionButtons) {
             UIButton *selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
             [selectedButton setImage:[UIImage imageNamed:@"MWPhotoBrowser.bundle/images/ImageSelectedOff.png"] forState:UIControlStateNormal];
             [selectedButton setImage:[UIImage imageNamed:@"MWPhotoBrowser.bundle/images/ImageSelectedOn.png"] forState:UIControlStateSelected];
             [selectedButton sizeToFit];
             selectedButton.adjustsImageWhenHighlighted = NO;
             [selectedButton addTarget:self action:@selector(selectedButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
             selectedButton.frame = [self frameForSelectedButton:selectedButton atIndex:index];
             [_pagingScrollView addSubview:selectedButton];
             page.selectedButton = selectedButton;
             selectedButton.selected = [self photoIsSelectedAtIndex:index];
             }
             */
            
        }
    }
    
}

- (void)updateVisiblePageStates {
    NSSet *copy = [_visiblePages copy];
    for (MWZoomingScrollView *page in copy) {
        
        // Update selection
        page.selectedButton.selected = [self photoIsSelectedAtIndex:page.index];
        
    }
}

- (BOOL)isDisplayingPageForIndex:(NSUInteger)index {
    for (MWZoomingScrollView *page in _visiblePages)
        if (page.index == index) return YES;
    return NO;
}

- (MWZoomingScrollView *)pageDisplayedAtIndex:(NSUInteger)index {
    MWZoomingScrollView *thePage = nil;
    for (MWZoomingScrollView *page in _visiblePages) {
        if (page.index == index) {
            thePage = page; break;
        }
    }
    return thePage;
}

- (MWZoomingScrollView *)pageDisplayingPhoto:(id<MWPhoto>)photo {
    MWZoomingScrollView *thePage = nil;
    for (MWZoomingScrollView *page in _visiblePages) {
        if (page.photo == photo) {
            thePage = page; break;
        }
    }
    return thePage;
}

- (void)configurePage:(MWZoomingScrollView *)page forIndex:(NSUInteger)index {
    page.frame = [self frameForPageAtIndex:index];
    page.index = index;
    page.photo = [self photoAtIndex:index];
}

- (MWZoomingScrollView *)dequeueRecycledPage {
    MWZoomingScrollView *page = [_recycledPages anyObject];
    if (page) {
        [_recycledPages removeObject:page];
    }
    return page;
}

// Handle page changes
- (void)didStartViewingPageAtIndex:(NSUInteger)index {
    
    if (![self numberOfPhotos]) {
        // Show controls
        [self setControlsHidden:NO animated:YES permanent:YES];
        return;
    }
    
    // Release images further away than +/-1
    NSUInteger i;
    if (index > 0) {
        // Release anything < index - 1
        for (i = 0; i < index-1; i++) {
            id photo = [_photos objectAtIndex:i];
            if (photo != [NSNull null]) {
                [photo unloadUnderlyingImage];
                [_photos replaceObjectAtIndex:i withObject:[NSNull null]];
                MWLog(@"Released underlying image at index %i", i);
            }
        }
    }
    if (index < [self numberOfPhotos] - 1) {
        // Release anything > index + 1
        for (i = index + 2; i < _photos.count; i++) {
            id photo = [_photos objectAtIndex:i];
            if (photo != [NSNull null]) {
                [photo unloadUnderlyingImage];
                [_photos replaceObjectAtIndex:i withObject:[NSNull null]];
                MWLog(@"Released underlying image at index %i", i);
            }
        }
    }
    
    // Load adjacent images if needed and the photo is already
    // loaded. Also called after photo has been loaded in background
    id <MWPhoto> currentPhoto = [self photoAtIndex:index];
    if ([currentPhoto underlyingImage]) {
        // photo loaded so load ajacent now
        [self loadAdjacentPhotosIfNecessary:currentPhoto];
    }
    
    // Notify delegate
    if (index != _previousPageIndex) {
        if ([_delegate respondsToSelector:@selector(photoBrowser:didDisplayPhotoAtIndex:)])
            [_delegate photoBrowser:self didDisplayPhotoAtIndex:index];
        _previousPageIndex = index;
    }
    
    // Update nav
    [self updateNavigation];
    
}

#pragma mark - Frame Calculations

- (CGRect)frameForPagingScrollView {
    //    {{-10, 0}, {340, 568}}
    CGRect frame = self.view.bounds;// [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return CGRectIntegral(frame);
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index {
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = _pagingScrollView.bounds;
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return CGRectIntegral(pageFrame);
}
//scrollview的contentsize
- (CGSize)contentSizeForPagingScrollView {
    // We have to use the paging scroll view's bounds to calculate the contentSize, for the same reason outlined above.
    CGRect bounds = _pagingScrollView.bounds;
    return CGSizeMake(bounds.size.width * [self numberOfPhotos], bounds.size.height);
}

- (CGPoint)contentOffsetForPageAtIndex:(NSUInteger)index {
    CGFloat pageWidth = _pagingScrollView.bounds.size.width;
    CGFloat newOffset = index * pageWidth;
    return CGPointMake(newOffset, 0);
}
//返回在设备水平和竖直状态下的toolbar的frame
- (CGRect)frameForToolbarAtOrientation:(UIInterfaceOrientation)orientation {
    CGFloat height = 44;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone &&
        UIInterfaceOrientationIsLandscape(orientation)) height = 32;
    //	NSLog(@"%@",NSStringFromCGRect(CGRectIntegral(CGRectMake(0, self.view.bounds.size.height - height, self.view.bounds.size.width, height))));
    return CGRectIntegral(CGRectMake(0, self.view.bounds.size.height - height, self.view.bounds.size.width, height));
}
- (CGRect)frameForSeparatorAtOrientation:(UIInterfaceOrientation)orientation {
    //    CGFloat height = 44;
    //    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone &&
    //        UIInterfaceOrientationIsLandscape(orientation)) height = 32;
    //	NSLog(@"%@",NSStringFromCGRect(CGRectIntegral(CGRectMake(0, self.view.bounds.size.height - height, self.view.bounds.size.width, height))));
    return CGRectIntegral(CGRectMake(0, _toolbar.bounds.origin.y, _toolbar.bounds.size.width, 1));
}
- (CGRect)frameForCaptionView:(MWCaptionView *)captionView atIndex:(NSUInteger)index {
    CGRect pageFrame = [self frameForPageAtIndex:index];
    CGSize captionSize = [captionView sizeThatFits:CGSizeMake(pageFrame.size.width, 0)];
    CGRect captionFrame = CGRectMake(pageFrame.origin.x,
                                     pageFrame.size.height - captionSize.height - (_toolbar.superview?_toolbar.frame.size.height:0),
                                     pageFrame.size.width,
                                     captionSize.height);
    return CGRectIntegral(captionFrame);
}

- (CGRect)frameForSelectedButton:(UIButton *)selectedButton atIndex:(NSUInteger)index {
    CGRect pageFrame = [self frameForPageAtIndex:index];
    CGFloat yOffset = 0;
    if (![self areControlsHidden]) {
        UINavigationBar *navBar = self.navigationController.navigationBar;
        yOffset = navBar.frame.origin.y + navBar.frame.size.height;
    }
    CGRect captionFrame = CGRectMake(pageFrame.origin.x + pageFrame.size.width - 20 - selectedButton.frame.size.width,
                                     20 + yOffset,
                                     selectedButton.frame.size.width,
                                     selectedButton.frame.size.height);
    return CGRectIntegral(captionFrame);
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // Checks
    if (!_viewIsActive || _performingLayout || _rotating) return;
    
    // Tile pages
    [self tilePages];
    
    // Calculate current page
    CGRect visibleBounds = _pagingScrollView.bounds;
    NSInteger index = (NSInteger)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    if (index < 0) index = 0;
    if (index > [self numberOfPhotos] - 1) index = [self numberOfPhotos] - 1;
    NSUInteger previousCurrentPage = _currentPageIndex;
    _currentPageIndex = index;
    if (_currentPageIndex != previousCurrentPage) {
        [self didStartViewingPageAtIndex:index];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // Hide controls when dragging begins
    [self setControlsHidden:YES animated:YES permanent:NO];
    self.test = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // Update nav when page changes
    [self updateNavigation];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //    NSLog(@"当前:%d,总数:%d",_currentPageIndex,[self numberOfPhotos]);
    if (self.needRefresh) {
        if (_currentPageIndex >=[self numberOfPhotos]-1) {//最后一页的时候加载更多
            id<MWPhoto> photo = [self photoAtIndex:_currentPageIndex];
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_TO_LOAD_MORE object:nil userInfo:photo.img_info];
            return;
        }
    }
    
}

#pragma mark - Navigation
//更新导航条的title
- (void)updateNavigation {
    
    // Title
    id <MWPhoto> photo = nil;
    photo =[self photoAtIndex:self.currentIndex];
    if (self.is_show_album) {
        //        self.title = @"";
        self.navigationItem.title=@"";
        if (self.showTitle) {
            self.navigationItem.title=[photo.img_info objectForKey:@"description"];
        }
    }else {
        
        self.navigationItem.title=[photo.img_info objectForKey:@"description"];
        //        self.title = [photo.img_info objectForKey:@"description"];
    }
    //    NSUInteger numberOfPhotos = [self numberOfPhotos];
    //    self.title = [NSString stringWithFormat:@"%lu of %lu", (unsigned long)(_currentPageIndex+1), (unsigned long)numberOfPhotos];
    /*
     if (_gridController) {
     if (_gridController.selectionMode) {
     self.title = NSLocalizedString(@"Select Photos", nil);
     } else {
     NSString *photosText;
     if (numberOfPhotos == 1) {
     photosText = NSLocalizedString(@"photo", @"Used in the context: '1 photo'");
     } else {
     photosText = NSLocalizedString(@"photos", @"Used in the context: '3 photos'");
     }
     self.title = [NSString stringWithFormat:@"%lu %@", (unsigned long)numberOfPhotos, photosText];
     }
     } else if (numberOfPhotos > 1) {
     self.title = [NSString stringWithFormat:@"%lu %@ %lu", (unsigned long)(_currentPageIndex+1), NSLocalizedString(@"of", @"Used in the context: 'Showing 1 of 3 items'"), (unsigned long)numberOfPhotos];
     } else {
     self.title = nil;
     }
     
     // Buttons
     _previousButton.enabled = (_currentPageIndex > 0);
     _nextButton.enabled = (_currentPageIndex < numberOfPhotos - 1);
     _actionButton.enabled = [[self photoAtIndex:_currentPageIndex] underlyingImage] != nil;
     */
}

- (void)jumpToPageAtIndex:(NSUInteger)index animated:(BOOL)animated {
    
    // Change page
    if (index < [self numberOfPhotos]) {
        CGRect pageFrame = [self frameForPageAtIndex:index];
        [_pagingScrollView setContentOffset:CGPointMake(pageFrame.origin.x - PADDING, 0) animated:animated];
        [self updateNavigation];
    }
    
    // Update timer to give more time
    [self hideControlsAfterDelay];
    
}

- (void)gotoPreviousPage {
    [self showPreviousPhotoAnimated:NO];
}
- (void)gotoNextPage {
    [self showNextPhotoAnimated:NO];
}

- (void)showPreviousPhotoAnimated:(BOOL)animated {
    [self jumpToPageAtIndex:_currentPageIndex-1 animated:animated];
}

- (void)showNextPhotoAnimated:(BOOL)animated {
    [self jumpToPageAtIndex:_currentPageIndex+1 animated:animated];
}

#pragma mark - Interactions

- (void)selectedButtonTapped:(id)sender {
    UIButton *selectedButton = (UIButton *)sender;
    selectedButton.selected = !selectedButton.selected;
    NSUInteger index = NSUIntegerMax;
    for (MWZoomingScrollView *page in _visiblePages) {
        if (page.selectedButton == selectedButton) {
            index = page.index;
            break;
        }
    }
    if (index != NSUIntegerMax) {
        [self setPhotoSelected:selectedButton.selected atIndex:index];
    }
}

#pragma mark - Grid

- (void)showGridAnimated {
    [self showGrid:YES];
}

- (void)showGrid:(BOOL)animated {
    
    if (_gridController) return;
    
    // Init grid controller
    _gridController = [[MWGridViewController alloc] init];
    _gridController.initialContentOffset = _currentGridContentOffset;
    _gridController.browser = self;
    _gridController.selectionMode = _displaySelectionButtons;
    _gridController.view.frame = self.view.bounds;
    _gridController.view.frame = CGRectOffset(_gridController.view.frame, 0, self.view.bounds.size.height);
    
    // Stop specific layout being triggered
    _skipNextPagingScrollViewPositioning = YES;
    
    // Add as a child view controller
    [self addChildViewController:_gridController];
    [self.view addSubview:_gridController.view];
    
    // Hide action button on nav bar if it exists
    if (self.navigationItem.rightBarButtonItem == _actionButton) {
        _gridPreviousRightNavItem = _actionButton;
        [self.navigationItem setRightBarButtonItem:nil animated:YES];
    } else {
        _gridPreviousRightNavItem = nil;
    }
    
    // Update
    [self updateNavigation];
    [self setControlsHidden:NO animated:YES permanent:YES];
    
    // Animate grid in and photo scroller out
    [UIView animateWithDuration:animated ? 0.3 : 0 animations:^(void) {
        _gridController.view.frame = self.view.bounds;
        CGRect newPagingFrame = [self frameForPagingScrollView];
        newPagingFrame = CGRectOffset(newPagingFrame, 0, -newPagingFrame.size.height);
        _pagingScrollView.frame = newPagingFrame;
    } completion:^(BOOL finished) {
        [_gridController didMoveToParentViewController:self];
    }];
    
}

- (void)hideGrid {
    
    if (!_gridController) return;
    
    // Remember previous content offset
    _currentGridContentOffset = _gridController.collectionView.contentOffset;
    
    // Restore action button if it was removed
    if (_gridPreviousRightNavItem == _actionButton && _actionButton) {
        [self.navigationItem setRightBarButtonItem:_gridPreviousRightNavItem animated:YES];
    }
    
    // Position prior to hide animation
    CGRect newPagingFrame = [self frameForPagingScrollView];
    newPagingFrame = CGRectOffset(newPagingFrame, 0, -newPagingFrame.size.height);
    _pagingScrollView.frame = newPagingFrame;
    
    // Remember and remove controller now so things can detect a nil grid controller
    MWGridViewController *tmpGridController = _gridController;
    _gridController = nil;
    
    // Update
    [self updateNavigation];
    [self updateVisiblePageStates];
    
    // Animate, hide grid and show paging scroll view
    [UIView animateWithDuration:0.3 animations:^{
        tmpGridController.view.frame = CGRectOffset(self.view.bounds, 0, self.view.bounds.size.height);
        _pagingScrollView.frame = [self frameForPagingScrollView];
    } completion:^(BOOL finished) {
        [tmpGridController willMoveToParentViewController:nil];
        [tmpGridController.view removeFromSuperview];
        [tmpGridController removeFromParentViewController];
        [self setControlsHidden:NO animated:YES permanent:NO]; // retrigger timer
    }];
    
}

#pragma mark - Control Hiding / Showing

// If permanent then we don't set timers to hide again
// Fades all controls on iOS 5 & 6, and iOS 7 controls slide and fade
- (void)setControlsHidden:(BOOL)hidden animated:(BOOL)animated permanent:(BOOL)permanent {
    
    // Force visible
    if (![self numberOfPhotos] || _gridController || _alwaysShowControls){
        hidden = NO;
        //////////
    }
    // Cancel any timers
    [self cancelControlHiding];
    
    // Animations & positions
    BOOL slideAndFade = SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7");
    CGFloat animatonOffset = 20;
    CGFloat animationDuration = (animated ? 0.35 : 0);
    
    //    MWZoomingScrollView *page = [self pageDisplayedAtIndex:_currentPageIndex];
    //    [UIView beginAnimations:nil context:nil];
    //    [UIView setAnimationDuration:0.35];
    //    page.tapView.backgroundColor = hidden?[UIColor blackColor]:[UIColor whiteColor];
    //    [UIView commitAnimations];
    
    // Status bar
    if (!_leaveStatusBarAlone) {
        if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
            
            // Hide status bar
            if (!_isVCBasedStatusBarAppearance) {
                
                // Non-view controller based
                [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:animated ? UIStatusBarAnimationSlide : UIStatusBarAnimationNone];
                
            } else {
                
                // View controller based so animate away
                _statusBarShouldBeHidden = hidden;
                [UIView animateWithDuration:animationDuration animations:^(void) {
                    [self setNeedsStatusBarAppearanceUpdate];
                } completion:^(BOOL finished) {}];
                
            }
            
        } else {
            
            // Status bar and nav bar positioning
            if (self.extendedLayoutIncludesOpaqueBars) {
                
                // Need to get heights and set nav bar position to overcome display issues
                
                // Get status bar height if visible
                CGFloat statusBarHeight = 0;
                if (![UIApplication sharedApplication].statusBarHidden) {
                    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
                    statusBarHeight = MIN(statusBarFrame.size.height, statusBarFrame.size.width);
                }
                
                // Status Bar
                [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:animated?UIStatusBarAnimationFade:UIStatusBarAnimationNone];
                
                // Get status bar height if visible
                if (![UIApplication sharedApplication].statusBarHidden) {
                    CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
                    statusBarHeight = MIN(statusBarFrame.size.height, statusBarFrame.size.width);
                }
                
                // Set navigation bar frame
                CGRect navBarFrame = self.navigationController.navigationBar.frame;
                navBarFrame.origin.y = statusBarHeight;
                self.navigationController.navigationBar.frame = navBarFrame;
                
            }
            
        }
    }
    
    // Toolbar, nav bar and captions
    // Pre-appear animation positions for iOS 7 sliding
    if (slideAndFade && [self areControlsHidden] && !hidden && animated) {
        
        // Toolbar
        _toolbar.frame = CGRectOffset([self frameForToolbarAtOrientation:self.interfaceOrientation], 0, animatonOffset);
        
        // Captions
        for (MWZoomingScrollView *page in _visiblePages) {
            if (page.captionView) {
                MWCaptionView *v = page.captionView;
                // Pass any index, all we're interested in is the Y
                CGRect captionFrame = [self frameForCaptionView:v atIndex:0];
                captionFrame.origin.x = v.frame.origin.x; // Reset X
                v.frame = CGRectOffset(captionFrame, 0, animatonOffset);
            }
        }
        
    }
    [UIView animateWithDuration:animationDuration animations:^(void) {
        
        CGFloat alpha = hidden ? 0 : 1;
        
        // Nav bar slides up on it's own on iOS 7
        [self.navigationController.navigationBar setAlpha:alpha];
        
        // Toolbar
        if (slideAndFade) {
            _toolbar.frame = [self frameForToolbarAtOrientation:self.interfaceOrientation];
            if (hidden) _toolbar.frame = CGRectOffset(_toolbar.frame, 0, animatonOffset);
        }
        _toolbar.alpha = alpha;
        // Captions
        for (MWZoomingScrollView *page in _visiblePages) {
            if (page.captionView) {
                MWCaptionView *v = page.captionView;
                if (slideAndFade) {
                    // Pass any index, all we're interested in is the Y
                    CGRect captionFrame = [self frameForCaptionView:v atIndex:0];
                    captionFrame.origin.x = v.frame.origin.x; // Reset X
                    if (hidden) captionFrame = CGRectOffset(captionFrame, 0, animatonOffset);
                    v.frame = captionFrame;
                }
                v.alpha = alpha;
            }
        }
        
        // Selected buttons
        for (MWZoomingScrollView *page in _visiblePages) {
            if (page.selectedButton) {
                UIButton *v = page.selectedButton;
                CGRect newFrame = [self frameForSelectedButton:v atIndex:0];
                newFrame.origin.x = v.frame.origin.x;
                v.frame = newFrame;
            }
        }
        
    } completion:^(BOOL finished) {}];
    
    // Control hiding timer
    // Will cancel existing timer but only begin hiding if
    // they are visible
    if (!permanent) [self hideControlsAfterDelay];
    
}

- (BOOL)prefersStatusBarHidden {
    if (!_leaveStatusBarAlone) {
        return _statusBarShouldBeHidden;
    } else {
        return [self presentingViewControllerPrefersStatusBarHidden];
    }
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (void)cancelControlHiding {
    // If a timer exists then cancel and release
    if (_controlVisibilityTimer) {
        [_controlVisibilityTimer invalidate];
        _controlVisibilityTimer = nil;
    }
}

// Enable/disable control visiblity timer
- (void)hideControlsAfterDelay {
    if (![self areControlsHidden]) {
        [self cancelControlHiding];
        _controlVisibilityTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(hideControls) userInfo:nil repeats:NO];
    }
}

- (BOOL)areControlsHidden {
    return (_toolbar.alpha == 0);
}
- (void)hideControls {
    [self setControlsHidden:YES animated:YES permanent:NO];
}
- (void)toggleControls {
    [self setControlsHidden:![self areControlsHidden] animated:YES permanent:NO];
}

#pragma mark - Properties

// Handle depreciated method
- (void)setInitialPageIndex:(NSUInteger)index {
    [self setCurrentPhotoIndex:index];
}

- (void)setCurrentPhotoIndex:(NSUInteger)index {
    // Validate
    if (index >= [self numberOfPhotos])
        index = [self numberOfPhotos]-1;
    _currentPageIndex = index;
    if ([self isViewLoaded]) {
        [self jumpToPageAtIndex:index animated:NO];
        if (!_viewIsActive)
            [self tilePages]; // Force tiling if view is not visible
    }
}

#pragma mark - Misc

- (void)doneButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Actions

- (void)actionButtonPressed:(id)sender {
    if (_actionsSheet) {
        
        // Dismiss
        [_actionsSheet dismissWithClickedButtonIndex:_actionsSheet.cancelButtonIndex animated:YES];
        
    } else {
        
        // Only react when image has loaded
        id <MWPhoto> photo = [self photoAtIndex:_currentPageIndex];
        if ([self numberOfPhotos] > 0 && [photo underlyingImage]) {
            
            // If they have defined a delegate method then just message them
            if ([self.delegate respondsToSelector:@selector(photoBrowser:actionButtonPressedForPhotoAtIndex:)]) {
                
                // Let delegate handle things
                [self.delegate photoBrowser:self actionButtonPressedForPhotoAtIndex:_currentPageIndex];
                
            } else {
                
                // Handle default actions
                if (SYSTEM_VERSION_LESS_THAN(@"6")) {
                    
                    // Old handling of activities with action sheet
                    if ([MFMailComposeViewController canSendMail]) {
                        _actionsSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil
                                                           otherButtonTitles:NSLocalizedString(@"Save", nil), NSLocalizedString(@"Copy", nil), NSLocalizedString(@"Email", nil), nil];
                    } else {
                        _actionsSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self
                                                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil
                                                           otherButtonTitles:NSLocalizedString(@"Save", nil), NSLocalizedString(@"Copy", nil), nil];
                    }
                    _actionsSheet.tag = ACTION_SHEET_OLD_ACTIONS;
                    _actionsSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                        [_actionsSheet showFromBarButtonItem:sender animated:YES];
                    } else {
                        [_actionsSheet showInView:self.view];
                    }
                    
                } else {
                    
                    // Show activity view controller
                    NSMutableArray *items = [NSMutableArray arrayWithObject:[photo underlyingImage]];
                    if (photo.caption) {
                        [items addObject:photo.caption];
                    }
                    self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
                    
                    // Show loading spinner after a couple of seconds
                    double delayInSeconds = 2.0;
                    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                        if (self.activityViewController) {
                            [self showProgressHUDWithMessage:nil];
                        }
                    });
                    
                    // Show
                    typeof(self) __weak weakSelf = self;
                    [self.activityViewController setCompletionHandler:^(NSString *activityType, BOOL completed) {
                        weakSelf.activityViewController = nil;
                        [weakSelf hideControlsAfterDelay];
                        [weakSelf hideProgressHUD:YES];
                    }];
                    [self presentViewController:self.activityViewController animated:YES completion:nil];
                    
                }
                
            }
            
            // Keep controls hidden
            [self setControlsHidden:NO animated:YES permanent:YES];
            
        }
    }
}

#pragma mark - Action Sheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == ACTION_SHEET_DOWNLOAD_ACTIONS) {
        if (buttonIndex == actionSheet.firstOtherButtonIndex+1) {//保存到手机
            if (self.type==10 || self.type == 1) {
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"自由环球租赁" message:@"这里下载的是缩略图，要下载高清图片，请请求用户分享，到共享相册里面去下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
                [alert show];
                
            }else{
                //保存
                [self savePhoto];
                return;
            }
            
        }else if (buttonIndex == actionSheet.firstOtherButtonIndex){//保存到我的相册
            if (self.type==10 || self.type == 1) {
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"自由环球租赁" message:@"这里下载的是缩略图，要下载高清图片，请请求用户分享，到共享相册里面去下载" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
                alert.tag = DOWNLOAD_ALERTVIEW_TAG;
                [alert show];
                
            }else{
                //下载
                [self saveToMyAlbum];
                return;
            }
        }
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == ACTION_SHEET_OLD_ACTIONS) {
        // Old Actions
        _actionsSheet = nil;
        if (buttonIndex != actionSheet.cancelButtonIndex) {
            if (buttonIndex == actionSheet.firstOtherButtonIndex) {
                [self savePhoto]; return;
            } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 1) {
                [self copyPhoto]; return;
            } else if (buttonIndex == actionSheet.firstOtherButtonIndex + 2) {
                [self emailPhoto]; return;
            }
        }
    }
    [self hideControlsAfterDelay]; // Continue as normal...
}
#pragma mark - UIAlertView Delegate methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (self.type==10 || self.type == 1) {
        
        if (buttonIndex==1) {
            if (alertView.tag == DOWNLOAD_ALERTVIEW_TAG) {
                [self saveToMyAlbum];
            } else {
                [self savePhoto];
            }
        }
        
    }else{
        
        id <MWPhoto>photo = [self photoAtIndex:self.currentIndex];
        //    NSLog(@"%@",photo.img_info);
        
        NSString *img_id = [photo.img_info objectForKey:@"img_id"];
        NSString* user_id = LOGIN_USER_ID ;
        
        if (buttonIndex == 1) {
            if (alertView.tag == DELETE_ALERTVIEW_TAG) {
                
                [LoadingView startOnTheViewController:self];
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:user_id,kDoImgUser_id,img_id,kDoImgImg_id,@"1",kDoImgDo_type, nil];
                [[HTTPClient sharedClient] postNew:kDoImg params:params success:^(NSDictionary *result) {
                    [LoadingView stopOnTheViewController:self];
                    
                    if ([[result objectForKey:kBBSSuccess] integerValue] ==1) {
                        //删除成功,发送监听
                        id<MWPhoto> photo = [self photoAtIndex:_currentPageIndex];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:DELETE_IMAGE_SUCCEED object:nil userInfo:photo.img_info];
                    }else{
                        [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
                    }
                    
                } failed:^(NSError *error) {
                    [LoadingView stopOnTheViewController:self];
                    [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
                }];
                
            }else if (alertView.tag == RENAME_ALERTVIEW_TAG){
                self.remark = [[alertView textFieldAtIndex:0] text];
                if (self.remark.length <= 0) {
                    [ShowAlertView showAlertViewWithTitle:@"提示" message:@"备注不能为空" cancelTitle:@"知道了"];
                    return;
                } if(self.remark.length >10){
                    [ShowAlertView showAlertViewWithTitle:@"提示" message:@"备注最多10个字" cancelTitle:@"知道了"];
                    return;
                }
                
                [LoadingView startOnTheViewController:self];
                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:user_id,kDoImgUser_id,img_id,kDoImgImg_id,self.remark,kDoImgImg_name,@"0",kDoImgDo_type, nil];
                [[HTTPClient sharedClient] postNew:kDoImg params:params success:^(NSDictionary *result) {
                    [LoadingView stopOnTheViewController:self];
                    
                    if ([[result objectForKey:kBBSSuccess] integerValue] == 1) {
                        id<MWPhoto> photo = [self photoAtIndex:_currentPageIndex];
                        
                        NSDictionary *userInfo = [[NSDictionary alloc]initWithObjectsAndKeys:self.remark,@"remark",photo.img_info,@"img_info", nil];
                        //修改成功,发送监听,更新title
                        [[NSNotificationCenter defaultCenter] postNotificationName:RENAME_REMARK_SUCCEED object:nil userInfo:userInfo];
                        
                    }else {
                        [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
                    }
                    
                } failed:^(NSError *error) {
                    [LoadingView stopOnTheViewController:self];
                    [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
                }];
                
            }
            
        }else{
            
        }
        
    }
    
}
#pragma mark - Action  MBProgressHUD

- (MBProgressHUD *)progressHUD {
    if (!_progressHUD) {
        _progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
        _progressHUD.minSize = CGSizeMake(120, 120);
        _progressHUD.minShowTime = 1;
        // The sample image is based on the
        // work by: http://www.pixelpressicons.com
        // licence: http://creativecommons.org/licenses/by/2.5/ca/
        self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MWPhotoBrowser.bundle/images/Checkmark.png"]];
        [self.view addSubview:_progressHUD];
    }
    return _progressHUD;
}

- (void)showProgressHUDWithMessage:(NSString *)message {
    self.progressHUD.labelText = message;
    self.progressHUD.mode = MBProgressHUDModeIndeterminate;
    [self.progressHUD show:YES];
    self.navigationController.navigationBar.userInteractionEnabled = NO;
}

- (void)hideProgressHUD:(BOOL)animated {
    [self.progressHUD hide:animated];
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}

- (void)showProgressHUDCompleteMessage:(NSString *)message {
    if (message) {
        if (self.progressHUD.isHidden) [self.progressHUD show:YES];
        self.progressHUD.labelText = message;
        self.progressHUD.mode = MBProgressHUDModeCustomView;
        [self.progressHUD hide:YES afterDelay:1.5];
    } else {
        [self.progressHUD hide:YES];
    }
    self.navigationController.navigationBar.userInteractionEnabled = YES;
}

#pragma mark - Actions
/**
 *  保存到我的应用里的相册
 */
- (void)saveToMyAlbum{
    id <MWPhoto> photo = [self photoAtIndex:_currentPageIndex];
    NSString *img_url = nil;
    if (self.type == 1) {
        //缩略图
        img_url = [NSString stringWithFormat:@"%@",[photo.img_info objectForKey:@"img_thumb"]];
    } else if (self.type == 0 || self.type == 2) {
        //原图
        img_url = [NSString stringWithFormat:@"%@",[photo.img_info objectForKey:@"img_down"]];
    }
    NSString *user_id = LOGIN_USER_ID;
    
    [LoadingView startOnTheViewController:self];
    NSDictionary *paramsDict = [NSDictionary dictionaryWithObjectsAndKeys:user_id,kDownloadImgUser_id,img_url,kDownloadImgImg_url, nil];
    [[HTTPClient sharedClient]postNew:kDownloadImg params:paramsDict success:^(NSDictionary *result) {
        [LoadingView stopOnTheViewController:self];
        if ([[result objectForKey:kBBSSuccess]intValue] == 1) {
            [ShowAlertView showAlertViewWithTitle:@"保存成功" message:@"请到相册-其他-下载查看" cancelTitle:@"好的"];
        } else {
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
        [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
    }];
    
}
//保存图片(下载图片)到手机
- (void)savePhoto {
    __weak id<MWPhoto>photo = [self photoAtIndex:_currentPageIndex];
    if (self.type==10) {
        
        __weak ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:self.imgstr]];
        [request startAsynchronous];
        [request setCompletionBlock:^{
            
            UIImage *photo=[UIImage imageWithData:request.responseData];
            [self showProgressHUDWithMessage:[NSString stringWithFormat:@"%@\u2026" , NSLocalizedString(@"正在保存", @"正在保存")]];
            [self performSelector:@selector(actuallySavePhoto:) withObject:photo afterDelay:0];
            
        }];
    }else{
        //1.普通好友,已经准备好缩略图 或者0or2我或者共享好友,并且已经准备好原图
        if ((self.type == 1 && photo.downThumbImage) || ( self.type != 1 && photo.downOriginImage)) {
            [self showProgressHUDWithMessage:[NSString stringWithFormat:@"%@\u2026" , NSLocalizedString(@"正在保存", @"正在保存")]];
            [self performSelector:@selector(actuallySavePhoto:) withObject:photo afterDelay:0];
        } else {
            NSURL *url = nil;
            if (self.type == 1){
                url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",[photo.img_info objectForKey:@"img_thumb"]]];
                photo.downThumbImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                NSLog(@"缩略图");
                
            }else{
                url =[NSURL URLWithString:[NSString stringWithFormat:@"%@",[photo.img_info objectForKey:@"img_down"]]];
                photo.downOriginImage = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
                NSLog(@"原图");
                
            }
            [self showProgressHUDWithMessage:[NSString stringWithFormat:@"%@\u2026" , NSLocalizedString(@"正在保存", @"正在保存")]];
            [self performSelector:@selector(actuallySavePhoto:) withObject:photo afterDelay:0];
            
            
        }
    }
    
    //    }else{
    //        [BBSAlert showAlertWithContent:@"请允许自由环球租赁访问你的相册" andDelegate:nil];
    //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    //
    //        });
    //
    //
    //    }
    
}

- (void)actuallySavePhoto:(id<MWPhoto>)photo {
    
    /**
     *  type:0我的,1其他人(与我无共享关系),2,我共享了他的相册的人 ,10:从我的秀秀进入
     */
    
    
    if (self.type==10) {
        
        UIImageWriteToSavedPhotosAlbum((UIImage *)photo, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
    }else if(self.type == 1){
        if ([photo downThumbImage]) {
            //下载缩略图
            UIImageWriteToSavedPhotosAlbum([photo downThumbImage], self,
                                           @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        
    }else {
        if ([photo downOriginImage]) {
            //下载原图
            UIImageWriteToSavedPhotosAlbum([photo downOriginImage], self,
                                           @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        
    }
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    [self showProgressHUDCompleteMessage: error ? NSLocalizedString(@"保存失败", @"保存失败") : NSLocalizedString(@"已保存", @"已保存")];
    [self hideControlsAfterDelay]; // Continue as normal...
}
//复制
- (void)copyPhoto {
    id <MWPhoto> photo = [self photoAtIndex:_currentPageIndex];
    if ([photo underlyingImage]) {
        [self showProgressHUDWithMessage:[NSString stringWithFormat:@"%@\u2026" , NSLocalizedString(@"Copying", @"Displayed with ellipsis as 'Copying...' when an item is in the process of being copied")]];
        [self performSelector:@selector(actuallyCopyPhoto:) withObject:photo afterDelay:0];
    }
}

- (void)actuallyCopyPhoto:(id<MWPhoto>)photo {
    if ([photo underlyingImage]) {
        [[UIPasteboard generalPasteboard] setData:UIImagePNGRepresentation([photo underlyingImage])
                                forPasteboardType:@"public.png"];
        [self showProgressHUDCompleteMessage:NSLocalizedString(@"Copied", @"Informing the user an item has finished copying")];
        [self hideControlsAfterDelay]; // Continue as normal...
    }
}
//邮件
- (void)emailPhoto {
    id <MWPhoto> photo = [self photoAtIndex:_currentPageIndex];
    if ([photo underlyingImage]) {
        [self showProgressHUDWithMessage:[NSString stringWithFormat:@"%@\u2026" , NSLocalizedString(@"Preparing", @"Displayed with ellipsis as 'Preparing...' when an item is in the process of being prepared")]];
        //        [self performSelector:@selector(actuallyEmailPhoto:) withObject:photo afterDelay:0];
    }
}

//- (void)actuallyEmailPhoto:(id<MWPhoto>)photo {
//    if ([photo underlyingImage]) {
//        MFMailComposeViewController *emailer = [[MFMailComposeViewController alloc] init];
//        emailer.mailComposeDelegate = self;
//        [emailer setSubject:NSLocalizedString(@"Photo", nil)];
//        [emailer addAttachmentData:UIImagePNGRepresentation([photo underlyingImage]) mimeType:@"png" fileName:@"Photo.png"];
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            emailer.modalPresentationStyle = UIModalPresentationPageSheet;
//        }
//        [self presentModalViewController:emailer animated:YES];
//        [self hideProgressHUD:NO];
//    }
//}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    if (result == MFMailComposeResultFailed) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Email", nil)
                                                        message:NSLocalizedString(@"Email failed to send. Please try again.", nil)
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Dismiss", nil) otherButtonTitles:nil];
        [alert show];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
