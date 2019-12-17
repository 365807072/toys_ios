//
//  UrlMaker.m
//  BabyShow
//
//  Created by Lau on 13-12-9.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "UrlMaker.h"

@implementation UrlMaker

-(id)initWithUrlStr:(NSString *)UrlStr Method:(NSInteger) Method andParam:(NSDictionary *)Param{
    
    if (self=[super init]) {
        
        if (Method == NetMethodGet) {
            
            NSMutableString *basicUrlStr=[NSMutableString stringWithFormat:kBasicUrlStr];
            [basicUrlStr appendString:UrlStr];
            for (NSString *str in [Param allKeys]) {
                NSString *appendStr=[NSString stringWithFormat:@"&%@=%@",str,[Param objectForKey:str]];
                [basicUrlStr appendString:appendStr];
            }
            
            NSLog(@"oldURL:%@",basicUrlStr);
            self.url=[NSURL URLWithString:basicUrlStr];
            
        }else if(Method == NetMethodPost){
            
            NSMutableString *basicUrlStr=[NSMutableString stringWithFormat:kBasicUrlStr];
            [basicUrlStr appendString:UrlStr];
            self.url=[NSURL URLWithString:basicUrlStr];
            NSLog(@"oldURL:%@",basicUrlStr);
            
            for (NSString *key in [Param allKeys]) {
                
                NSLog(@"oldkey:%@,   value:%@",key,[Param objectForKey:key]);
                
            }
        }
    }
    return self;
}
- (id)initWithNewUrlStr:(NSString *)UrlStr Method:(NSInteger)Method andParam:(NSDictionary *)Param{
    
    if (self=[super init]) {
        
        if (Method == NetMethodGet) {
            
            NSMutableString *basicUrlStr=[NSMutableString stringWithFormat:kNewBasicUrl];
            [basicUrlStr appendString:UrlStr];
            for (NSString *str in [Param allKeys]) {
                NSString *appendStr=[NSString stringWithFormat:@"&%@=%@",str,[Param objectForKey:str]];
                [basicUrlStr appendString:appendStr];
            }
            self.url=[NSURL URLWithString:basicUrlStr];
            NSLog(@"NewURL = %@",self.url);
            
        }else if(Method == NetMethodPost){
            
            NSMutableString *basicUrlStr=[NSMutableString stringWithFormat:kNewBasicUrl];
        
            [basicUrlStr appendString:UrlStr];
            self.url=[NSURL URLWithString:basicUrlStr];
            NSLog(@"NewURLpost = %@",self.url);
           
            
            for (NSString *key in [Param allKeys]) {
                
                NSLog(@"Newkey:%@,   value:%@",key,[Param objectForKey:key]);
                
            }
        }
    }
    return self;
}

- (id)initWithNewV1UrlStr:(NSString *)UrlStr Method:(NSInteger)Method andParam:(NSDictionary *)Param{
    
    if (self=[super init]) {
        
        if (Method == NetMethodGet) {
            NSMutableString *basicUrlStr=[NSMutableString stringWithFormat:kBasicUrlV1];
            [basicUrlStr appendString:UrlStr];
            for (NSString *str in [Param allKeys]) {
                NSString *appendStr=[NSString stringWithFormat:@"&%@=%@",str,[Param objectForKey:str]];
                [basicUrlStr appendString:appendStr];
            }
            self.url=[NSURL URLWithString:basicUrlStr];
            NSLog(@"NewURL = %@",self.url);
            
        }else if(Method == NetMethodPost){
            
            NSMutableString *basicUrlStr=[NSMutableString stringWithFormat:kBasicUrlV1];
            
            [basicUrlStr appendString:UrlStr];
            self.url=[NSURL URLWithString:basicUrlStr];
            NSLog(@"NewURLpost = %@",self.url);
            
            
            for (NSString *key in [Param allKeys]) {
                
                NSLog(@"Newkey:%@,   value:%@",key,[Param objectForKey:key]);
                
            }
        }
    }
    return self;
}

- (id)initWithPayUrlStr:(NSString *)UrlStr Method:(NSInteger)Method andParam:(NSDictionary *)Param{
    
    if (self=[super init]) {
        
        if (Method == NetMethodGet) {
            
            NSMutableString *basicUrlStr=[NSMutableString stringWithFormat:kPayUrl];
            [basicUrlStr appendString:UrlStr];
            for (NSString *str in [Param allKeys]) {
                NSString *appendStr=[NSString stringWithFormat:@"&%@=%@",str,[Param objectForKey:str]];
                [basicUrlStr appendString:appendStr];
            }
            
            
            self.url=[NSURL URLWithString:basicUrlStr];
            NSLog(@"NewURL = %@",self.url);
            
        }else if(Method == NetMethodPost){
            
            NSMutableString *basicUrlStr=[NSMutableString stringWithFormat:kPayUrl];
            
            [basicUrlStr appendString:UrlStr];
            self.url=[NSURL URLWithString:basicUrlStr];
            NSLog(@"NewURLpost = %@",self.url);
            
            
            for (NSString *key in [Param allKeys]) {
                
                NSLog(@"Newkey:%@,   value:%@",key,[Param objectForKey:key]);
                
            }
        }
    }
    return self;
}

@end
