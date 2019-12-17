//
//  PostBarDetailNewPraiseItem.h
//  BabyShow
//
//  Created by Monica on 10/23/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarDetailNewBasicItem.h"

@interface PostBarDetailNewPraiseItem : PostBarDetailNewBasicItem

@property (nonatomic, assign) NSInteger praiseCount;
@property (nonatomic, assign) NSInteger reviewCount;
@property (nonatomic, strong) NSString *imgid;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, assign) BOOL isPraised;

@end
