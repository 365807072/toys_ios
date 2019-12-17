//
//  PostBarNewMakeAPost.h
//  BabyShow
//
//  Created by Monica on 10/28/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerController.h"
#import "ALRadialMenu.h"


typedef void (^refrensh)();

@interface PostBarNewMakeAPost : UIViewController<UITextViewDelegate,UIActionSheetDelegate,ELCImagePickerControllerDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate>
{
    ALRadialMenu *_menu;

}

@property (nonatomic ,strong) NSMutableArray *pickedImagesArray;
@property (nonatomic ,assign) NSInteger shareType;
@property (nonatomic ,strong) NSString *urlStr;
@property(nonatomic,assign)NSInteger post_class;
@property(nonatomic,assign)NSInteger group_id;
@property(nonatomic,copy)refrensh update;
@property(nonatomic,strong)NSString *isFromMain;//是否在主页上发帖
@property(nonatomic,strong)NSString *isFromGroup;//来着群的发帖
@property(nonatomic,strong)NSString *groupId;//是否有群
@property(nonatomic,strong)NSString *groupName;//如果有群的话，有个人群名
@property(nonatomic,assign)BOOL isHiddenGroup;//是否隐藏默认群yes是隐藏


-(void)showImagesWithPhotosArray:(NSArray *) photosArray;
-(void)removeImageViews;


@end
