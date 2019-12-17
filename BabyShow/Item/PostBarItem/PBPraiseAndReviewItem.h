//
//  PBPraiseAndReviewItem.h
//  BabyShow
//
//  Created by Lau on 6/5/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PBBasicItem.h"

@interface PBPraiseAndReviewItem : PBBasicItem

@property (nonatomic, strong) NSString *praiseCount;
@property (nonatomic, strong) NSString *reviewCount;
@property (nonatomic, assign) BOOL isPraised;

@end
