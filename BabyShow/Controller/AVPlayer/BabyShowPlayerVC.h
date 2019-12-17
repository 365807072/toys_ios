//
//  BabyShowPlayerVC.h
//  BabyShow
//
//  Created by WMY on 16/5/6.
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

@interface BabyShowPlayerVC : UIViewController<UITableViewDataSource,UITableViewDelegate,RefreshControlDelegate,ELCImagePickerControllerDelegate,PostBarDetailPhotoCellDelegate,MWPhotoBrowserDelegate,PostBarNewReviewsUserCellDelegate,PostBarNewReviewsPhotoCellDelegate,PostBarNewReplyViewDelegate,UIActionSheetDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,strong)NSDictionary *videoDic;
@property (nonatomic, strong) NSString *img_id;
@property(nonatomic,strong)NSString *videoUrl;
@property(nonatomic,strong)PostBarNewReplyView *toolBaView;
@property(nonatomic,assign)BOOL isHV;//视频是横屏还是竖屏的，YES表示横屏的

@end
