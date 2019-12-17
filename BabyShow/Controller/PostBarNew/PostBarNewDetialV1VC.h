//
//  PostBarNewDetialV1VC.h
//  BabyShow
//
//  Created by WMY on 16/4/20.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshControl.h"
#import "ELCImagePickerController.h"
#import "PostBarDetailPhotoCell.h"
#import "MWPhotoBrowser.h"
#import "PostBarNewReviewsUserCell.h"
#import "PraiseAndReviewListViewController.h"
#import "PostBarNewReviewsPhotoCell.h"
#import "PostBarNewReplyView.h"
#import "AlbumListViewController.h"
typedef void(^refreshInVCBlock) (BOOL isRefresh);
@interface PostBarNewDetialV1VC : UIViewController<UITableViewDataSource,UITableViewDelegate,RefreshControlDelegate,ELCImagePickerControllerDelegate,PostBarDetailPhotoCellDelegate,MWPhotoBrowserDelegate,PostBarNewReviewsUserCellDelegate,PostBarNewReviewsPhotoCellDelegate,PostBarNewReplyViewDelegate,UIActionSheetDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate>
@property (nonatomic, strong) NSString *user_id;
@property (nonatomic, strong) NSString *login_user_id;
@property (nonatomic, strong) NSString *img_id;
@property(nonatomic,copy)refreshInVCBlock refreshInVC;
@property(nonatomic,assign)BOOL isRefreshInVC;
@property(nonatomic,strong)PostBarNewReplyView *toolBaView;




@end
