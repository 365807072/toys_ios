//
//  FindPwdStep2ViewController.h
//  BabyShow
//
//  Created by Mayeon on 14-3-24.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface FindPwdStep2ViewController : UIViewController<ASIHTTPRequestDelegate>
{
    UITextField *verifyCodeTextField;
}
/**
 *  用户输入的邮箱
 */
@property (nonatomic ,strong)NSString *email;


@end
