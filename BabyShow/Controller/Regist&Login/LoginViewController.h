//
//  LoginViewController.h
//  BabyShow
//
//  Created by Lau on 13-12-9.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    TYPE_LOGIN,         //登录
    TYPE_BINDING,       //绑定
    TYPE_NORMAL,        //绑定成功后进入
} LOGINTYPE;

@interface LoginViewController : UIViewController<UITextFieldDelegate,UITabBarControllerDelegate>
{
    
}
//这个页面的类型,登录,或者绑定
@property (nonatomic,assign)LOGINTYPE loginType;

@end
