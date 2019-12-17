//
//  MoreSpecialModel.m
//  BabyShow
//
//  Created by Monica on 15-5-14.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MoreSpecialModel.h"
#import "CKMacros.h"

@implementation MoreSpecialModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
-(id)initWithAttributes:(NSDictionary *)attributes
{
    self = [super init];
    if (self &&attributes) {
        self.imgs = $safe([attributes valueForKey:@"imgs"]);
        self.img_thumb = $safe([attributes valueForKey:@"img_thumb"]);
        self.cate_name = $safe([attributes valueForKey:@"cate_name"]);
        
    }
    return  self;
}
@end
