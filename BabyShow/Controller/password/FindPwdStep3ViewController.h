//
//  FindPwdStep3ViewController.h
//  BabyShow
//
//  Created by Mayeon on 14-3-24.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface FindPwdStep3ViewController : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate>
{
    UITextField *theNewTextField;
    UITextField *confirmTextField;
}

@property (nonatomic ,strong)NSString *email;

@end
