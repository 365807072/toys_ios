//
//  HTTPClient.m
//  BabyShow
//
//  Created by Mayeon on 14-6-13.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "HTTPClient.h"

static HTTPClient *httpClient = nil;

@implementation HTTPClient

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}
- (AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

+ (HTTPClient *)sharedClient{
    if (httpClient == nil) {
        return [[HTTPClient alloc]init];
    }
    
    return httpClient;
}

- (void)get:(NSString *)portName params:(NSDictionary *)paramDict success:(void (^)(NSDictionary *))success failed:(void (^)(NSError *))failed {

    urlMaker=[[UrlMaker alloc]initWithUrlStr:portName Method:NetMethodGet andParam:paramDict];
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
    [request setDownloadCache:[self appDelegate].myCache];
    //缓存策略:有网时请求网络是否有新数据,无网络时使用缓存数据
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setSecondsToCache:60*60*24*30];
    [request startAsynchronous];

    __weak ASIHTTPRequest *blockRequest = request;
    
    [request setCompletionBlock:^{
        NSDictionary *result = [blockRequest.responseString objectFromJSONString];
        success(result);
    }];
    
    [request setFailedBlock:^{
        NSError *error = [blockRequest error];
        failed(error);
    }];

}
- (void)getNew:(NSString *)portName params:(NSDictionary *)paramDict success:(void (^)(NSDictionary *))success failed:(void (^)(NSError *))failed {
    //向新接口过渡
    urlMaker=[[UrlMaker alloc]initWithNewUrlStr:portName Method:NetMethodGet andParam:paramDict];

    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
    [request setDownloadCache:[self appDelegate].myCache];
    //缓存策略:有网时请求网络是否有新数据,无网络时使用缓存数据
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setSecondsToCache:60*60*24*30];
    [request startAsynchronous];
    
    __weak ASIHTTPRequest *blockRequest = request;
    
    [request setCompletionBlock:^{
        NSDictionary *result = [blockRequest.responseString objectFromJSONString];
        success(result);
    }];
    
    [request setFailedBlock:^{
        NSError *error = [blockRequest error];
        failed(error);
    }];
}
//V1接口上的
- (void)getNewV1:(NSString *)portName params:(NSDictionary *)paramDict success:(void (^)(NSDictionary *result))success failed:(void (^)(NSError *error))failed{
    //向新接口过渡
    urlMaker = [[UrlMaker alloc]initWithNewV1UrlStr:portName Method:NetMethodGet andParam:paramDict];
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
    [request setDownloadCache:[self appDelegate].myCache];
    //缓存策略:有网时请求网络是否有新数据,无网络时使用缓存数据
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setSecondsToCache:60*60*24*30];
    [request startAsynchronous];
    
    __weak ASIHTTPRequest *blockRequest = request;
    
    [request setCompletionBlock:^{
        NSDictionary *result = [blockRequest.responseString objectFromJSONString];
        success(result);
    }];
    
    [request setFailedBlock:^{
        NSError *error = [blockRequest error];
        failed(error);
    }];

    
    
}

- (void)postNewV1:(NSString *)portName params:(NSDictionary *)paramDict success:(void (^)(NSDictionary *result))success failed:(void (^)(NSError *error))failed{
    urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:portName Method:NetMethodPost andParam:paramDict];
    
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
    
    for (NSString *key in [paramDict allKeys]) {
        id obj=[paramDict objectForKey:key];
        [request setPostValue:obj forKey:key];
        
    }
    
    [request startAsynchronous];
    
    __weak ASIFormDataRequest *blockRequest = request;
    
    [request setCompletionBlock:^{
        NSDictionary *result = [blockRequest.responseString objectFromJSONString];
        success(result);
    }];
    
    [request setFailedBlock:^{
        NSError *error = [blockRequest error];
        failed(error);
    }];

    
}


- (void)post:(NSString *)portName params:(NSDictionary *)paramDict success:(void (^)(NSDictionary *))success failed:(void (^)(NSError *))failed {
    urlMaker=[[UrlMaker alloc]initWithUrlStr:portName Method:NetMethodPost andParam:paramDict];
    
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
    
    for (NSString *key in [paramDict allKeys]) {
        id obj=[paramDict objectForKey:key];
        [request setPostValue:obj forKey:key];
        
    }
    
    [request startAsynchronous];
    
    __weak ASIFormDataRequest *blockRequest = request;
    
    [request setCompletionBlock:^{
        NSDictionary *result = [blockRequest.responseString objectFromJSONString];
        success(result);
    }];
    
    [request setFailedBlock:^{
        NSError *error = [blockRequest error];
        failed(error);
    }];
    
}
- (void)postNew:(NSString *)portName params:(NSDictionary *)paramDict success:(void (^)(NSDictionary *))success failed:(void (^)(NSError *))failed {
    urlMaker=[[UrlMaker alloc]initWithNewUrlStr:portName Method:NetMethodPost andParam:paramDict];
    
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
    
    for (NSString *key in [paramDict allKeys]) {
        id obj=[paramDict objectForKey:key];
        [request setPostValue:obj forKey:key];
        
    }
    
    [request startAsynchronous];
    
    __weak ASIFormDataRequest *blockRequest = request;
    
    [request setCompletionBlock:^{
        NSDictionary *result = [blockRequest.responseString objectFromJSONString];
        success(result);
    }];
    
    [request setFailedBlock:^{
        NSError *error = [blockRequest error];
        failed(error);
    }];
    
}
- (void)post:(NSString *)portName params:(NSDictionary *)paramDict data:(NSDictionary *)dataDict success:(void (^)(NSDictionary *))success failed:(void (^)(NSError *))failed{
    
    urlMaker=[[UrlMaker alloc]initWithUrlStr:portName Method:NetMethodPost andParam:paramDict];

    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
    
    for (NSString *key in [paramDict allKeys]) {
        id obj=[paramDict objectForKey:key];
        [request setPostValue:obj forKey:key];
        
    }
    
    for (NSString *key in [dataDict allKeys]) {
        UIImage *image  = [dataDict objectForKey:key];
        [request setData:UIImageJPEGRepresentation(image, 0.75) withFileName:@"image.png" andContentType:@"image/png" forKey:key];
    }
    
    [request startAsynchronous];
    
    __weak ASIFormDataRequest *blockRequest = request;
    
    [request setCompletionBlock:^{
        NSDictionary *result = [blockRequest.responseString objectFromJSONString];
        success(result);
    }];
    
    [request setFailedBlock:^{
        NSError *error = [blockRequest error];
        failed(error);
    }];
}

@end
