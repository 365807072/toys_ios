//
//  BaseImageView.m
//  BabyShow
//
//  Created by WMY on 15/12/9.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "BaseImageView.h"

@implementation BaseImageView
+(id)imgViewWithFrame:(CGRect)frame backImg:(UIImage *)image userInterface:(BOOL)userInterface backgroupcolor:(NSString*)color{
    UIImageView *img = [[UIImageView alloc]initWithFrame:frame];
    img.userInteractionEnabled = userInterface;
    if (color!= nil) {
        img.backgroundColor = [BBSColor hexStringToColor:color];
    }
    if (img!= nil) {
        img.image = image;
    }
    return img;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
