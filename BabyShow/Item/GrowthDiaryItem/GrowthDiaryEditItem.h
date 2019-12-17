//
//  GrowthDiaryEditItem.h
//  BabyShow
//
//  Created by Monica on 15-2-2.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrowthDiaryEditItem : NSObject

@property (nonatomic ,strong) NSString *img_id;
@property (nonatomic ,strong) NSString *img_title;//time
@property (nonatomic ,strong) NSString *img_description;
@property (nonatomic ,strong) NSString *img_thumb;
@property (nonatomic ,assign) CGFloat   img_thumb_width;
@property (nonatomic ,assign) CGFloat   img_thumb_height;

@end
