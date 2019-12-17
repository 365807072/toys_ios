//
//  ImageScale.m
//  BabyShow
//
//  Created by Lau on 13-12-17.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ImageScale.h"

@implementation ImageScale


+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

-(UIImage *)getImageFromImage:(UIImage*) superImage subImageSize:(CGSize)subImageSize subImageRect:(CGRect)subImageRect {
//    CGSize subImageSize = CGSizeMake(WIDTH, HEIGHT); //定义裁剪的区域相对于原图片的位置
//    CGRect subImageRect = CGRectMake(START_X, START_Y, WIDTH, HEIGHT);
    CGImageRef imageRef = superImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subImageRect);
    UIGraphicsBeginImageContext(subImageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subImageRect, subImageRef);
    UIImage* returnImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext(); //返回裁剪的部分图像
    return returnImage;
}
@end
