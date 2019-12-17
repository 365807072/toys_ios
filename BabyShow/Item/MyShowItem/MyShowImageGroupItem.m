//
//  MyShowImageGroupItem.m
//  BabyShow
//
//  Created by Lau on 3/26/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyShowImageGroupItem.h"

@implementation MyShowImageGroupItem

-(id)init{
    
    self=[super init];
    if (self) {
        self.photosArray=[[NSMutableArray alloc]init];
    }
    return self;
    
}

@end
