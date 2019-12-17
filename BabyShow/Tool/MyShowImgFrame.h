//
//  MyShowImgFrame.h
//  BabyShow
//
//  Created by Lau on 6/12/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyShowImgFrame : NSObject

+(CGRect )getFrameWithTheImageWidth:(CGFloat) width AndHeight:(CGFloat) height;
+(UIImage *)scaleSmallImage:(UIImage *) image;
+(UIImage *)resizeImage:(UIImage *) image ToSize:(CGSize) size;

@end
