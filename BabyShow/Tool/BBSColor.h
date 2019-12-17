//
//  BBSColor.h
//  BabyShow
//
//  Created by Lau on 13-12-11.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSColor : UIColor
+(UIColor *) hexStringToColor: (NSString *) stringToConvert;
+(UIColor *) hexStringToColor:(NSString *)stringToConvert alpha:(float)alpha;
@end
