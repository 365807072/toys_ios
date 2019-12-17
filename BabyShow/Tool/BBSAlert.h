//
//  BBSAlert.h
//  BabyShow
//
//  Created by Lau on 13-12-10.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSAlert : NSObject
+(void)showAlertWithContent:(NSString *) Content andDelegate:(id) delegate;
+(void)showAlertWithContent:(NSString *)Content andDelegate:(id)delegate andDismissAnimated:(NSInteger)time;
+(void)dimissAlert:(UIAlertView *)alert;
@end
