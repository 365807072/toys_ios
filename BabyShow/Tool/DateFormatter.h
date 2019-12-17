//
//  DateFormatter.h
//  xmpp-ios
//
//  Created by Lau on 14-1-5.
//  Copyright (c) 2014年 yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateFormatter : NSObject


+(NSString *)dateStringFromDate:(NSDate *)date formatter:(NSString *)formatter;

+(NSDate *)dateFromDateString:(NSString *)dateString formatter:(NSString *)formatter;

@end
