//
//  EditHeadMessVC.h
//  BabyShow
//
//  Created by WMY on 16/9/21.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditHeadMessVC : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UIActionSheet *_chooseAcs;
    UIImagePickerController *_imagePicker;

}
@property(nonatomic,strong)NSString *groupName;
@property(nonatomic,strong)NSString *desSub;
@property(nonatomic,strong)NSString *cover;
@property(nonatomic,assign)NSInteger groupId;
@property(nonatomic,strong)NSString *recommend_title;
@property(nonatomic,strong)NSString *color_index;

@end
