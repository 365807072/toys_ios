//
//  YLButton.m
//
//  Created by 杨柳 on 15/7/30.
//  Copyright (c) 2015年 杨柳. All rights reserved.
//

#import "YLButton.h"

@implementation YLButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
+ (id) buttonWithFrame:(CGRect)frame type:(UIButtonType)type backImage:(UIImage *)image target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (target != nil || action != nil) {
        [button addTarget:target action:action forControlEvents:controlEvents];
    }
    if (image != nil) {
        [button setImage:image forState:UIControlStateNormal];
    }
    button.adjustsImageWhenHighlighted = NO;
    return button;
}

+ (id) buttonEasyInitBackColor:(UIColor *)color frame:(CGRect)frame type:(UIButtonType)type backImage:(UIImage *)image target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (target != nil || action != nil) {
        [button addTarget:target action:action forControlEvents:controlEvents];
    }
    if (image != nil) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (color != nil) {
        button.backgroundColor = color;
    }
    button.adjustsImageWhenHighlighted = NO;
    return button;
}
+ (id) buttonEasyInitBackColor:(UIColor *)color frame:(CGRect)frame type:(UIButtonType)type backImage:(UIImage *)image target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents tag:(NSInteger)tag{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    if (target != nil || action != nil) {
        [button addTarget:target action:action forControlEvents:controlEvents];
    }
    if (image != nil) {
        [button setImage:image forState:UIControlStateNormal];
    }
    if (color != nil) {
        button.backgroundColor = color;
    }
    button.adjustsImageWhenHighlighted = NO;
    button.tag = tag;
    return button;
}

//+ (id) buttonWithType:(UIButtonType)buttonType frame:(CGRect)frame{
//    return;
//}

@end
