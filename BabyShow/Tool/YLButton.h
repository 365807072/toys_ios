//
//  YLButton.h
//
//  Created by 杨柳 on 15/7/30.
//  Copyright (c) 2015年 杨柳. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YLButton : UIButton

/**
 *  创建一个button(尺寸，类型，背景图，点击事件)
 *
 *  @param frame         尺寸
 *  @param type          类型
 *  @param image         背景图
 *  @param target        或许为代理
 *  @param action        方法
 *  @param controlEvents 点击触发类型
 *
 *  @return 一个button
 */
+ (id) buttonWithFrame:(CGRect)frame type:(UIButtonType)type backImage:(UIImage *)image target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;

/**
 *  创建一个button (尺寸，背景图，背景色，类型，点击事件)
 *
 *  @param color         背景颜色
 *  @param frame         尺寸
 *  @param type          类型
 *  @param image         背景图
 *  @param target        或许为代理
 *  @param action        方法
 *  @param controlEvents 点击事件类型
 *
 *  @return 一个button
 */
+ (id) buttonEasyInitBackColor:(UIColor *)color frame:(CGRect)frame type:(UIButtonType)type backImage:(UIImage *)image target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents;
+ (id) buttonEasyInitBackColor:(UIColor *)color frame:(CGRect)frame type:(UIButtonType)type backImage:(UIImage *)image target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents tag:(NSInteger)tag;

//@property (nonatomic, assign) CGRect frame;
//@property (nonatomic, assign) UIButtonType type;
//@property (nonatomic, strong) UIImage *image;
//@property (nonatomic, strong) id target;
//@property (nonatomic, assign) UIControlEvents controlEvents;

@end
