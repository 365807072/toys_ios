//
//  EditingViewController.h
//  BabyShow
//
//  Created by Lau on 13-12-26.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditingAvatarItem.h"
#import "EditingNickNameItem.h"
#import "EditingRegisterUserNameItem.h"
#import "EditingRegiserEmailItem.h"
#import "UserInfoManager.h"
#import "MyHomePageItem.h"
#import "EditingBindItem.h"
#import "Reachability.h"

#define LOGOUT  1000
#define EDIT    2000


@interface EditingViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UITableView *_tableView;
    UIView *_editView;
    UITextField *_textField;
    
    NSString *_nickName;
    UIImage *_avatar;
    
    UIActionSheet *_chooseAcs;
    UIImagePickerController *_imagePicker;
    
    NSMutableArray *dataArray;
    NSMutableArray *sectionArray;
    
}
+(BOOL) isConnectionAvailable;//检查网络是否可用
@end
