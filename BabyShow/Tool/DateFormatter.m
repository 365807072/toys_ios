//
//  DateFormatter.m
//  xmpp-ios
//
//  Created by Lau on 14-1-5.
//  Copyright (c) 2014年 yuanyuanquanquan.com. All rights reserved.
//

#import "DateFormatter.h"

@implementation DateFormatter

+(NSString *)dateStringFromDate:(NSDate *)date formatter:(NSString *)formatter{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:formatter];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)dateFromDateString:(NSString *)dateString formatter:(NSString *)formatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    [dateFormatter setDateFormat:formatter];
    
    return [dateFormatter dateFromString:dateString];
}
@end
