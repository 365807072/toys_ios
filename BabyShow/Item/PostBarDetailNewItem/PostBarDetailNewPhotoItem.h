//
//  PostBarDetailNewPhotoItem.h
//  BabyShow
//
//  Created by Monica on 10/23/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarDetailNewBasicItem.h"

@interface PostBarDetailNewPhotoItem : PostBarDetailNewBasicItem

@property (nonatomic, strong) NSString *thumbString;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) NSArray *clearPhotosArray;
@property (nonatomic, assign) NSInteger index;

@end
