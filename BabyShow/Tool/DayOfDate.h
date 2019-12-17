//
//  DayOfDate.h
//  BabyShow
//
//  Created by Mayeon on 14-7-9.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

//周几的类型
typedef enum {
    DayOfWeekMon  = 0,
    DayOfWeekTue,
    DayOfWeekWed,
    DayOfWeekThu,
    DayOfWeekFri,
    DayOfWeekSat,
    DayOfWeekSun,
    DayOfWeekUnknown        //未知错误?
}DayOfWeekType;

@interface DayOfDate : NSObject


/**
 *  返回枚举值对应的中文
 *
 *  @param dayOfWeekType dayOfWeekType DayOfWeek type
 *
 *  @return eg:@"星期一"
 */
+ (NSString *)chineseDayOfWeekWithType:(DayOfWeekType )dayOfWeekType;

/**
 *  返回周几的枚举值
 *
 *  @param currentDayString egg:@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat",@"Sun"
 *
 *  @return DayOfWeek enum type
 */
+ (DayOfWeekType )dayOfWeek:(NSString *)currentDayString;

+ (NSString *)chineseDayOfWeekWithString:(NSString *)currentDayString;


@end
