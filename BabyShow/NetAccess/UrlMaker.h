//
//  UrlMaker.h
//  BabyShow
//
//  Created by Lau on 13-12-9.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UrlMaker : NSObject

@property (nonatomic, strong) NSURL *url;

-(id)initWithUrlStr:(NSString *)UrlStr Method:(NSInteger) Method andParam:(NSDictionary *)Param;
//新版，改成index.php?r=BabyShow/
-(id)initWithNewUrlStr:(NSString *)UrlStr Method:(NSInteger) Method andParam:(NSDictionary *)Param;
-(id)initWithPayUrlStr:(NSString *)UrlStr Method:(NSInteger) Method andParam:(NSDictionary *)Param;
- (id)initWithNewV1UrlStr:(NSString *)UrlStr Method:(NSInteger)Method andParam:(NSDictionary *)Param;


@end
