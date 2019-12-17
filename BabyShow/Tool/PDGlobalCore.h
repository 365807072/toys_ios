//
//  PDGlobalCore.h
//  CSEJClient
//
//  Created by IvanLee on 14/12/11.
//  Copyright (c) 2014年 PHTData. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Creates a mutable array which does not retain references to the objects it contains.
 *
 * Typically used with arrays of delegates.
 */
NSMutableArray* MBCreateNonRetainingArray();

/**
 * Creates a mutable dictionary which does not retain references to the values it contains.
 *
 * Typically used with dictionaries of delegates.
 */
NSMutableDictionary* MBCreateNonRetainingDictionary();

/**
 * Tests if an object is an array which is not empty.
 */
BOOL MBIsArrayWithItems(id object);

/**
 * Tests if an object is a set which is not empty.
 */
BOOL MBIsSetWithItems(id object);

/**
 * Tests if an object is a string which is not empty.
 */
BOOL MBIsStringWithAnyText(id object);

/**
 * Swap the two method implementations on the given class.
 * Uses method_exchangeImplementations to accomplish this.
 */
void MBSwapMethods(Class cls, SEL originalSel, SEL newSel);

/**
 *  [NSNull null], nil, @"" to "-".
 *  NSNumber to NSString.
 *  true -> @"1" | false -> @"0".
 */
NSString* MBNonEmptyString(id obj);


/**
 *  If target string contant ".",return YES;
 *  else return NO;
 */
BOOL MBIsStringContantDrop(id object);

/**
 *  formate the identify date if value is long  return 0 else replace the @"-"
 */
NSString* MBStringForHttpRequest(NSString *value);

NSString* MBFirstKeyForValueInDict(NSString* value,NSDictionary* dict);
//根据屏幕宽度适配
CGFloat MBHeightAdatperByScreenWidth(CGFloat heightForIphone5);

/**
 * 本机touch Id指纹是否可用
 */
BOOL MBIsFingerPrintAvailable();

/**
 * 判断是否有中文
 */
BOOL MBIsContainChinese(NSString *value);

/**
 *  拼接字符串
 */
NSString * MBByAppendingString(id str1,id str2);
/**
 *  替换字符串 当字符串为空时替换成占位文字
 */
NSString *MBNoneReplace(NSString *noeStr,NSString *replace);

//获取当前时间 data
NSData *MBCurrentDate();
// 获取当前时间转换string
NSString *MBCurrentDateToString(NSString *format);

