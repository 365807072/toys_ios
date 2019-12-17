//
//  RegisterStep2ViewController.h
//  BabyShow
//
//  Created by Lau on 13-12-10.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface RegisterStep2ViewController : UIViewController<UITextFieldDelegate,UIActionSheetDelegate,UITabBarControllerDelegate>
{
    UIScrollView *_scrollView;
    UIButton *_addChildBtn;
    UIButton *_submitBtn;
    UIActionSheet *acs;
    UIDatePicker *pickerView;
    
    UIButton *_btnBack;
    UIButton *_btnIgnore;
    
    BOOL isFirst;
    int Count;
    
    UITextField *_textField;
    NSMutableArray *_babyArray;
    NSMutableArray *_babyTextFieldArray;
}
/*!
 *  0:注册
 *  1:主页或成长日记添加孩子
 */
@property (nonatomic, assign) NSInteger Type;
@end
