//
//  MyShowImgFrame.m
//  BabyShow
//
//  Created by Lau on 6/12/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyShowImgFrame.h"

static float longImageWidth=230;
static float wideImageWidth=320;

@implementation MyShowImgFrame

+(CGRect)getFrameWithTheImageWidth:(CGFloat)width AndHeight:(CGFloat)height{
    
    CGFloat scale;
    CGRect returnFrame;
    
    if (width>=height) {
        //横图
        scale=wideImageWidth/width;
        returnFrame=CGRectMake(0, 0, wideImageWidth, height*scale);
        
    }else{
        //竖图
        scale=longImageWidth/width;
        returnFrame=CGRectMake(SCREENWIDTH/2-longImageWidth/2, 0, longImageWidth, height*scale);

        
    }
    
    return returnFrame;
    
}

+(UIImage *)scaleSmallImage:(UIImage *) image{
    
    UIImage *returnImage;
    
//    NSLog(@"width:%f,height:%f",image.size.width,image.size.height);
    
    if (image.size.width>image.size.height) {
        //宽图
        
        float x=image.size.width/2-image.size.height/2;
        CGRect rect=CGRectMake(x, 0, image.size.height, image.size.height);
        
        CGImageRef imageRef = image.CGImage;
        CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
        returnImage = [UIImage imageWithCGImage:subImageRef];
        CGImageRelease(subImageRef);
//        CGSize size=CGSizeMake(image.size.height, image.size.height);
//        UIGraphicsBeginImageContext(size);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextDrawImage(context, rect, subImageRef);
//        UIGraphicsEndImageContext();

    }else if (image.size.width<=image.size.height){
        //长图
        
        float y=image.size.height/3-image.size.width/3;
        CGRect rect=CGRectMake(0, y, image.size.width, image.size.width);
        
        CGImageRef imageRef = image.CGImage;
        CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
        returnImage = [UIImage imageWithCGImage:subImageRef];
        CGImageRelease(subImageRef);

//        CGSize size=CGSizeMake(image.size.width, image.size.width);
//        UIGraphicsBeginImageContext(size);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        CGContextDrawImage(context, rect, subImageRef);
//        UIGraphicsEndImageContext();
        
    }
    
    return returnImage;
}


+(UIImage *)resizeImage:(UIImage *) image ToSize:(CGSize) size{
    
    float scale=size.height/size.width;
    CGRect rect=CGRectMake(0, 0, image.size.width, image.size.width*scale);
    
    CGImageRef imageRef = image.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
    image = [UIImage imageWithCGImage:subImageRef];
    CGImageRelease(subImageRef);
    
//    UIGraphicsBeginImageContext(size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextDrawImage(context, rect, subImageRef);
//    UIGraphicsEndImageContext();
    
    return image;
    
}

@end
