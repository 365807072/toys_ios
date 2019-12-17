//
//  MyShowImageGroupItem.h
//  BabyShow
//
//  Created by Lau on 3/26/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyShowItem.h"

@interface MyShowImageGroupItem : MyShowItem

@property (nonatomic ,strong) NSMutableArray *photosArray;
@property (nonatomic, strong) NSString *imgId;
@property (nonatomic, assign) float width;
@property (nonatomic, assign) CGRect frame;

@end
