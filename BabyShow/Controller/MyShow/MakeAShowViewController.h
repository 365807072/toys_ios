//
//  MakeAShowViewController.h
//  BabyShow
//
//  Created by Lau on 13-12-13.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageScale.h"
#import "ELCImagePickerController.h"
#import "ALRadialMenu.h"
typedef void(^refreshMyShowBlock)();



static int maxNumberOfImages = 9;

@interface MakeAShowViewController : UIViewController<UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ELCImagePickerControllerDelegate,ALRadialMenuDelegate>

{
    
    UIScrollView *_scrollView;
    UIButton *_sendBtn;
    UIImageView *_photoView;
    UIImage *_addPhotoImg;
    UIImagePickerController *imagePicker;
    NSMutableArray *_imageViewArray;
    ALRadialMenu *_menu;
    UIView *_clearView;
    
}

@property (nonatomic, strong) UIImage *photo;
@property(nonatomic,strong)NSString *backType;

/**
 //现在好像Type值只有0和1
    秀一下：type=0；          没有返回按钮、秀一下有权限选择。
    相册秀一下：type=1;       有返回按钮、秀一下有权限选择。
    广场参与活动：type=2;      有返回按钮、秀一下没有权限选择。
    贴吧发帖：type=3;         有返回按钮、秀一下没有权限选择、有是否同时发布到我的秀秀的按钮。
**/

@property (nonatomic, assign) int Type;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (nonatomic, strong) NSMutableArray *pickedImagesArray;
@property (nonatomic, strong) UITextView *describeField;
@property(nonatomic,copy)refreshMyShowBlock refreshMyBlock;
@property(nonatomic,strong)NSString *tag_id;//从宝宝萌萌哒有标签id上传来的


/*
    0：秀一下——没有返回按钮
    1：相册分享——有返回按钮
 */
-(void)makeImageViewWithPickedImagesArray:(NSArray *) imageArray;
@property(nonatomic,strong)NSString *videoUrl;//视频的url

@end