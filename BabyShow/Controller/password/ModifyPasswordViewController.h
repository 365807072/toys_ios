//
//  ModifyPasswordViewController.h
//  BabyShow
//
//  Created by Mayeon on 14-3-21.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface ModifyPasswordViewController : UIViewController<UITextFieldDelegate,ASIHTTPRequestDelegate>
{
    
}

@property (nonatomic ,strong)UITextField *theOldPwdTextField;
@property (nonatomic ,strong)UITextField *theNewPwdTextField;
@property (nonatomic ,strong)UITextField *confirmPwdTextField;

@end
