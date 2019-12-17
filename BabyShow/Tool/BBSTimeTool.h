//
//  BBSTimeTool.h
//  BabyShow
//
//  Created by Monica on 9/25/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BBSTimeTool : NSObject

+ (BOOL)isToday:(NSNumber *)time;
+ (NSString *)stringFromTime:(NSNumber *)time;
+ (NSString *) compareCurrentTime:(NSDate*) compareDate;
+ (NSDateComponents *) MyOutPutGetTime:(NSNumber *) time;
+ (NSString *)getTimeStrFromNow:(NSNumber *) time;

@end
