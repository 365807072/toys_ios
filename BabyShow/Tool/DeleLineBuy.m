//
//  DeleLineBuy.m
//  BabyShow
//
//  Created by WMY on 15/11/19.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "DeleLineBuy.h"

@implementation DeleLineBuy

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)drawRect:(CGRect)rect {
    
    //调用super的目的,就是先把文字画上去
    [super drawRect:rect];
    
    //1获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //2.设置线条颜色就是标签的文字颜色
    CGContextSetStrokeColorWithColor(context, self.textColor.CGColor);
    CGContextSetLineWidth(context, 0.6);
    
    //3.画线的起点
    CGFloat y = rect.size.height * 0.4;
    CGContextMoveToPoint(context, 25, y);
    
    //4.短标题,根据字体确定宽度(即线条需要画多长)---不折行的
    CGSize size = [self.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName, nil]];
    
    //5.线条的终点(文字有多长就画多长)
    CGContextAddLineToPoint(context, 25+size.width, y);
    
    //6.最后,渲染到上下文中
    CGContextStrokePath(context);
}


@end
