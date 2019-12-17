//
//  ShowAlertView.m
//  BabyShow
//
//  Created by Lau on 14-1-15.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ShowAlertView.h"

@implementation ShowAlertView

+(void)showAlertViewWithTitle:(NSString *)title message:(NSString *)message cancelTitle:(NSString *)cancelTitle{
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:title
                                                       message:message
                                                      delegate:nil
                                             cancelButtonTitle:cancelTitle
                                             otherButtonTitles:nil, nil];
    
    [alertView show];
}
@end
