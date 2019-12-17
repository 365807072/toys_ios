//
//  NSString+NSString_MD5.m
//  BabyShow
//
//  Created by Lau on 13-12-11.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "NSString+NSString_MD5.h"
#import<CommonCrypto/CommonDigest.h> 

@implementation NSString (NSString_MD5)
- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr),result );
    NSMutableString *hash =[NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash uppercaseString];
}
@end
