//
//  BBSTimeTool.m
//  BabyShow
//
//  Created by Monica on 9/25/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "BBSTimeTool.h"

@implementation BBSTimeTool

+ (NSString *)getTimeStrFromNow:(NSNumber *) time{
    
    NSTimeInterval nsTimeInterval = [time longLongValue]/1000;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    NSString *str=[self compareCurrentTime:date];
    return str;
}

+ (BOOL)isToday:(NSNumber *)time{
    
    NSTimeInterval nsTimeInterval = [time longLongValue]/1000;
    NSDate *oneDay = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *todayStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:todayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending || result == NSOrderedAscending) {
        return NO;
    }
    return YES;
}

+ (NSDateComponents *) MyOutPutGetTime:(NSNumber *) time{
    
    NSTimeInterval nsTimeInterval = [time longLongValue]/1000;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    return components;
    
}


+ (NSString *) compareCurrentTime:(NSDate*) compareDate

{
    
    NSTimeInterval  timeInterval = [compareDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        
        result = [NSString stringWithFormat:@"刚刚"];
        
    }
    
    else if((temp = timeInterval/60) <60){
        
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
        
    }
    
    else if((temp = temp/60) <24){
        
        result = [NSString stringWithFormat:@"%ld小时前",temp];
        
    }
    
    else if((temp = temp/24) <30){
        
        result = [NSString stringWithFormat:@"%ld天前",temp];
        
    }
    
    else if((temp = temp/30) <12){
        
        result = [NSString stringWithFormat:@"%ld月前",temp];
        
    }
    
    else{
        
        temp = temp/12;
        
        result = [NSString stringWithFormat:@"%ld年前",temp];
        
    }
    
    return  result;
    
}

+ (NSString *)stringFromTime:(NSNumber *)time{
    
    NSTimeInterval nsTimeInterval = [time longLongValue]/1000;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}


@end
