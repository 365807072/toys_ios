//
//  PostBarNewMakeSecondVC.h
//  BabyShow
//
//  Created by WMY on 16/8/10.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"
typedef void (^refreshInPostBarVC)();

@interface PostBarNewMakeSecondVC : UIViewController<UITextViewDelegate,UIActionSheetDelegate,ELCImagePickerControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate>

@property (nonatomic ,strong) NSMutableArray *pickedImagesArray;
@property(nonatomic,strong)NSString *img_id;
@property(nonatomic,strong)NSString *make_groupId;
@property(nonatomic,strong)NSString *isFromGroup;//是否来自群
@property(nonatomic,copy)refreshInPostBarVC updataYes;
-(void)showImagesWithPhotosArray:(NSArray *) photosArray;

//-(void)removeImageViews;

@end
