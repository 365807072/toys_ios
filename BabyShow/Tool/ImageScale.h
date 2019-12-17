//
//  ImageScale.h
//  BabyShow
//
//  Created by Lau on 13-12-17.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageScale : UIImage

+(UIImage *)scale:(UIImage *)image toSize:(CGSize)size;

-(UIImage *)getImageFromImage:(UIImage*) superImage subImageSize:(CGSize)subImageSize subImageRect:(CGRect)subImageRect;

@end
