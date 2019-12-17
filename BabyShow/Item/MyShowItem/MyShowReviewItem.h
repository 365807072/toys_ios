//
//  MyShowPreviewItem.h
//  BabyShow
//
//  Created by Lau on 13-12-16.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyShowItem.h"

@interface MyShowReviewItem : MyShowItem

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *avatarStr;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSNumber *reviewId;
@property (nonatomic, strong) NSString *reviewUser;
@property (nonatomic, assign) CGFloat height;


@property(nonatomic,strong)NSString *postCreatTime;

@end
