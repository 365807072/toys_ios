//
//  BBSAlert.m
//  BabyShow
//
//  Created by Lau on 13-12-10.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "BBSAlert.h"

@implementation BBSAlert
+(void)showAlertWithContent:(NSString *)Content andDelegate:(id)delegate{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:Content delegate:delegate cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [alert show];

    
}
+(void)showAlertWithContent:(NSString *)Content andDelegate:(id)delegate andDismissAnimated:(NSInteger)time{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:Content delegate:delegate cancelButtonTitle:@"好的" otherButtonTitles: nil];
    [alert show];
    [self performSelector:@selector(dimissAlert:) withObject:alert afterDelay:time];
}
+(void)dimissAlert:(UIAlertView *)alert{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}
-(void)addSubview{

}

@end
