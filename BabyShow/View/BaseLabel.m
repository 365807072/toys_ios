//
//  BaseLabel.m
//  BabyShow
//
//  Created by WMY on 15/12/8.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "BaseLabel.h"

@implementation BaseLabel
+(id)makeFrame:(CGRect)frame font:(CGFloat)font textColor:(NSString *)textColor textAlignment:(NSTextAlignment)textAlignment text:(NSString*)text{
    UILabel *baseLabel = [[UILabel alloc]initWithFrame:frame];
    baseLabel.font = [UIFont systemFontOfSize:font];

    if (textColor != nil) {
        baseLabel.textColor = [BBSColor hexStringToColor:textColor];
    }
    if (text != nil) {
        baseLabel.text = text;
    }
    baseLabel.textAlignment = textAlignment;
    return baseLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
