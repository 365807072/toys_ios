//
//  MyOutPutPraiseAndReviewItem.h
//  BabyShow
//
//  Created by Monica on 9/17/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyOutPutBasicItem.h"

@interface MyOutPutPraiseAndReviewItem : MyOutPutBasicItem

@property (nonatomic, strong) NSString *praise_count;
@property (nonatomic, strong) NSString *review_count;
@property (nonatomic, assign) BOOL isPraised;
@property(nonatomic,strong)NSString *cate_name;
@property(nonatomic,assign)NSInteger cate_id;
@property(nonatomic,strong)NSString *videoUrl;

@end
