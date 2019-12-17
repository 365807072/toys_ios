//
//  DayOfDate.m
//  BabyShow
//
//  Created by Mayeon on 14-7-9.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "DayOfDate.h"

@implementation DayOfDate


+ (NSString *)chineseDayOfWeekWithType:(DayOfWeekType)dayOfWeekType {
    switch (dayOfWeekType) {
        case DayOfWeekMon:
            return @"星期一";
            break;
        case DayOfWeekTue:
            return @"星期二";
            break;
        case DayOfWeekWed:
            return @"星期三";
            break;
        case DayOfWeekThu:
            return @"星期四";
            break;
        case DayOfWeekFri:
            return @"星期五";
            break;
        case DayOfWeekSat:
            return @"星期六";
            break;
        case DayOfWeekSun:
            return @"星期日";
            break;
        case DayOfWeekUnknown:
            return @"未知";
            break;
        default:
            break;
    }
}

+ (DayOfWeekType )dayOfWeek:(NSString *)currentDayString {
    if (nil == currentDayString) {
        return  DayOfWeekUnknown;
    }
    
    if ([currentDayString hasPrefix:@"Mon"]) {
        return DayOfWeekMon;
    }
    if ([currentDayString hasPrefix:@"Tue"]) {
        return DayOfWeekTue;
    }
    if ([currentDayString hasPrefix:@"Wed"]) {
        return DayOfWeekWed;
    }
    if ([currentDayString hasPrefix:@"Thu"]) {
        return DayOfWeekThu;
    }
    if ([currentDayString hasPrefix:@"Fri"]) {
        return DayOfWeekFri;
    }
    if ([currentDayString hasPrefix:@"Sat"]) {
        return DayOfWeekSat;
    }
    if ([currentDayString hasPrefix:@"Sun"]) {
        return DayOfWeekSun;
    }
    
    return DayOfWeekUnknown;
}

+ (NSString *)chineseDayOfWeekWithString:(NSString *)currentDayString {
    if (nil == currentDayString) {
        return  @"未知";
    }
    
    if ([currentDayString hasPrefix:@"Mon"]) {
        return @"星期一";
    }
    if ([currentDayString hasPrefix:@"Tue"]) {
        return @"星期二";
    }
    if ([currentDayString hasPrefix:@"Wed"]) {
        return @"星期三";
    }
    if ([currentDayString hasPrefix:@"Thu"]) {
        return @"星期四";
    }
    if ([currentDayString hasPrefix:@"Fri"]) {
        return @"星期五";
    }
    if ([currentDayString hasPrefix:@"Sat"]) {
        return @"星期六";
    }
    if ([currentDayString hasPrefix:@"Sun"]) {
        return @"星期日";
    }
    
    return @"未知";
}
@end
