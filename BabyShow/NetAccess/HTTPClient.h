//
//  HTTPClient.h
//  BabyShow
//
//  Created by Mayeon on 14-6-13.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UrlMaker.h"
#import "JSONKit.h"
#import "ASIHTTPRequest.h"

@interface HTTPClient : NSObject<ASIHTTPRequestDelegate>
{
    UrlMaker *urlMaker;
}

+ (HTTPClient *)sharedClient;

/**
 *  GET请求
 *
 *  @param portName  接口名
 *  @param paramDict 参数
 *  @param success   成功后
 *  @param failed    失败后
 */
- (void)get:(NSString *)portName params:(NSDictionary *)paramDict success:(void (^)(NSDictionary *result))success failed:(void (^)(NSError *error))failed ;
//接口过渡
- (void)getNew:(NSString *)portName params:(NSDictionary *)paramDict success:(void (^)(NSDictionary *result))success failed:(void (^)(NSError *error))failed ;

//V1接口新的接口
- (void)getNewV1:(NSString *)portName params:(NSDictionary *)paramDict success:(void (^)(NSDictionary *result))success failed:(void (^)(NSError *error))failed ;
/**
 *  POST请求
 *
 *  @param portName  接口请求
 *  @param paramDict 参数
 *  @param success   成功后调用
 *  @param failed    失败后调用
 */
- (void)post:(NSString *)portName params:(NSDictionary *)paramDict success:(void (^)(NSDictionary *result))success failed:(void (^)(NSError *error))failed;
//接口过渡，
- (void)postNew:(NSString *)portName params:(NSDictionary *)paramDict success:(void (^)(NSDictionary *result))success failed:(void (^)(NSError *error))failed;
//V1接口新接口
- (void)postNewV1:(NSString *)portName params:(NSDictionary *)paramDict success:(void (^)(NSDictionary *result))success failed:(void (^)(NSError *error))failed;

/**
 *  POST请求(带有上传数据,egg:图片,音频等)
 *
 *  @param portName  接口请求
 *  @param paramDict 参数
 *  @param data      格式为key:value,例如:data:@{@"img1": image1,@"img2":image2}
 *  @param success   成功后调用
 *  @param failed    失败后调用
 */
- (void)post:(NSString *)portName params:(NSDictionary *)paramDict data:(NSDictionary *)dataDict success:(void (^)(NSDictionary *result))success failed:(void (^)(NSError *error))failed;
@end
