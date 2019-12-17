//
//  BaseLabel.h
//  BabyShow
//
//  Created by WMY on 15/12/8.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseLabel : UILabel
+(id)makeFrame:(CGRect)frame font:(CGFloat)font textColor:(NSString *)textColor textAlignment:(NSTextAlignment)textAlignment text:(NSString*)text;
@end
