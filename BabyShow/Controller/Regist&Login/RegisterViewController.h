//
//  RegisterViewController.h
//  BabyShow
//
//  Created by Lau on 13-12-9.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

{
    UIButton *_imageBtn;
    UIImageView *_imageView;

    UITextField *_passwordTextField;
    UITextField *_emailTextField;
    UITextField *_nickNameTextField;
    UIScrollView *_scrollView;
    
    UIButton *_btnBack;
    UIButton *_btnDone;

    UIImagePickerController *_imagePicker;
    
    NSInteger isUploadAvar;
    
}
@end
