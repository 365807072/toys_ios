//
//  FindPwdStep1ViewController.h
//  BabyShow
//
//  Created by Mayeon on 14-3-24.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface FindPwdStep1ViewController : UIViewController<ASIHTTPRequestDelegate>
{
    UITextField *emailTextField;    //输入邮箱
}
@end
