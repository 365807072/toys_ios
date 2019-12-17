//
//  MyOutPutImgGroupItem.h
//  BabyShow
//
//  Created by Monica on 9/17/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyOutPutBasicItem.h"

@interface MyOutPutImgGroupItem : MyOutPutBasicItem

@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, assign) CGRect frame;
@property(nonatomic,strong)NSString *video_url;
@property(nonatomic,strong)NSString *desecontent;

@end
