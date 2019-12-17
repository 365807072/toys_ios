//
//  MWPhotoBrowser.h
//  MWPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MWPhoto.h"
#import "MWPhotoProtocol.h"
#import "MWCaptionView.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"


#define DELETE_ALERTVIEW_TAG 101
#define RENAME_ALERTVIEW_TAG 102
#define SHARE_ALERTVIEW_TAG 103
#define DOWNLOAD_ALERTVIEW_TAG  104

// Debug Logging
#if 0 // Set to 1 to enable debug logging
#define MWLog(x, ...) NSLog(x, ## __VA_ARGS__);
#else
#define MWLog(x, ...)
#endif

@class MWPhotoBrowser;

@protocol MWPhotoBrowserDelegate <NSObject>

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser;
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;

@optional

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index;
- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index;
- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index;
- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected;

@end

@interface MWPhotoBrowser : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate, MFMailComposeViewControllerDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>

@property (nonatomic, weak) IBOutlet id<MWPhotoBrowserDelegate> delegate;
@property (nonatomic) BOOL zoomPhotosToFill;
@property (nonatomic) BOOL displayNavArrows;
@property (nonatomic) BOOL displayActionButton;
@property (nonatomic) BOOL displaySelectionButtons;
@property (nonatomic) BOOL alwaysShowControls;
@property (nonatomic) BOOL enableGrid;
@property (nonatomic) BOOL startOnGrid;
@property (nonatomic, readonly) NSUInteger currentIndex;


/******自己填的东西**********/
@property (nonatomic ,strong)UIButton *shareButton;         //分享
@property (nonatomic ,strong)UIButton *deleteButton;        //删除
@property (nonatomic ,strong)UIButton *renameButton;        //重命名(导航条上的名字)
@property (nonatomic ,strong)UIButton *rotateButton;        //旋转
/**
 *  type:0我的,1其他人(与我无共享关系),2,我共享了他的相册的人 ,10:从我的秀秀进入
 */
@property (nonatomic) int type;                 //我的相册还是其他人的相册
@property (nonatomic) BOOL is_show_album;       //是否是秀秀相册
@property (nonatomic ,strong)NSString *user_id; //相册

//从我的秀秀进入
@property (nonatomic ,assign)BOOL   needPlay;   //是否有播放功能
@property (nonatomic ,strong)NSMutableArray *imgArr;

@property (nonatomic ,strong)NSString *remark;      //修改的备注
@property (nonatomic, strong)UILabel *titleLabel;
@property (nonatomic ,assign)BOOL needRefresh;
@property (nonatomic ,assign)BOOL showTitle;        //目前只用于从主题相册列表进入时显示i/j格式的title
/************************/

//YXB

@property (nonatomic, strong) NSString *imgstr;
@property (nonatomic ,assign) BOOL test;
@property (nonatomic ,strong) UIImage *rotateImage;


// Init
- (id)initWithPhotos:(NSArray *)photosArray  __attribute__((deprecated("Use initWithDelegate: instead"))); // Depreciated
- (id)initWithDelegate:(id <MWPhotoBrowserDelegate>)delegate;

// Reloads the photo browser and refetches data
- (void)reloadData;

// Set page that photo browser starts on
- (void)setCurrentPhotoIndex:(NSUInteger)index;
- (void)setInitialPageIndex:(NSUInteger)index  __attribute__((deprecated("Use setCurrentPhotoIndex: instead"))); // Depreciated

// Navigation
- (void)showNextPhotoAnimated:(BOOL)animated;
- (void)showPreviousPhotoAnimated:(BOOL)animated;

@end
