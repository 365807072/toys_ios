//
//  PDGlobalCore.m
//  CSEJClient
//
//  Created by IvanLee on 14/12/11.
//  Copyright (c) 2014年 PHTData. All rights reserved.
//

#import "PDGlobalCore.h"

#import <objc/runtime.h>
#import <LocalAuthentication/LocalAuthentication.h>

// No-ops for non-retaining objects.
static const void* MBRetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void MBReleaseNoOp(CFAllocatorRef allocator, const void *value) { }

///////////////////////////////////////////////////////////////////////////////////////////////////
NSMutableArray* MBCreateNonRetainingArray() {
    CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
    callbacks.retain = MBRetainNoOp;
    callbacks.release = MBReleaseNoOp;
    return (NSMutableArray*)CFBridgingRelease(CFArrayCreateMutable(nil, 0, &callbacks));
}


///////////////////////////////////////////////////////////////////////////////////////////////////
NSMutableDictionary* MBCreateNonRetainingDictionary() {
    CFDictionaryKeyCallBacks keyCallbacks = kCFTypeDictionaryKeyCallBacks;
    CFDictionaryValueCallBacks callbacks = kCFTypeDictionaryValueCallBacks;
    callbacks.retain = MBRetainNoOp;
    callbacks.release = MBReleaseNoOp;
    return (NSMutableDictionary*)CFBridgingRelease(CFDictionaryCreateMutable(nil, 0, &keyCallbacks, &callbacks));
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL MBIsArrayWithItems(id object) {
    return [object isKindOfClass:[NSArray class]] && [(NSArray*)object count] > 0;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL MBIsSetWithItems(id object) {
    return [object isKindOfClass:[NSSet class]] && [(NSSet*)object count] > 0;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL MBIsStringWithAnyText(id object) {
    return [object isKindOfClass:[NSString class]] && [(NSString*)object length] > 0;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
void SwapMethods(Class cls, SEL originalSel, SEL newSel) {
    Method originalMethod = class_getInstanceMethod(cls, originalSel);
    Method newMethod = class_getInstanceMethod(cls, newSel);
    method_exchangeImplementations(originalMethod, newMethod);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* MBNonEmptyString(id obj){
    if (obj == nil || obj == [NSNull null] ||
        ([obj isKindOfClass:[NSString class]] && [obj length] == 0)) {
        return @"";
    } else if ([obj isKindOfClass:[NSNumber class]]) {

        return MBNonEmptyString([obj stringValue]);
    }
    return obj;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
BOOL MBIsStringContantDrop(id object){
    return [object isKindOfClass:[NSString class]] && [object rangeOfString:@"."].location != NSNotFound;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* MBStringForHttpRequest(NSString *value){
     return [value isEqualToString:@"长期"]?@"0":[value stringByReplacingOccurrencesOfString:@"-" withString:@""];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
NSString* MBFirstKeyForValueInDict(NSString* value,NSDictionary* dict){
    
    for (NSString* key in [dict allKeys]) {
        if([[dict valueForKey:key] isEqualToString:value]){
            return key;
        }
    }
    return @"";
    
}

///////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * 判断是否有中文
 */
BOOL MBIsContainChinese(NSString *value){
    BOOL flag = NO;
    for(int i = 0; i < [value length]; i++){
        
        int a = [value characterAtIndex:i];
        
        if( a >= 0x4e00 && a <= 0x9fa5)
        {
            flag = YES;
            break;
        }
    }
    
    return flag;
}

//------------拼接字符串-----
NSString * MBByAppendingString(id str1,id str2){
    return [MBNonEmptyString(str1) stringByAppendingString:MBNonEmptyString(str2)];
}
//获取当前时间 data
NSData *MBCurrentDate(){
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    return currentDate;
}
// 获取当前时间转换string
NSString *MBCurrentDateToString(NSString *format){
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString * naData= [df stringFromDate:MBCurrentDate()];
    return naData;
    
}
NSString *MBNoneReplace(NSString *noeStr,NSString *replace){
    return noeStr.length <= 0? replace: noeStr;
}

