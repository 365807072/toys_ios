//
//  PostBarDetailReviewUserItem.h
//  BabyShow
//
//  Created by WMY on 16/4/22.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarDetailNewBasicItem.h"

@interface PostBarDetailReviewUserItem : PostBarDetailNewBasicItem
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *avatar;
@property(nonatomic,strong)NSString *postTime;
@property(nonatomic,strong)NSString *postCreateTime;
@property(nonatomic,assign)NSInteger reviewCount;
@property(nonatomic,assign)NSInteger admireCount;
@property(nonatomic,assign)BOOL isAdmire;
@property(nonatomic,strong)NSString *review_id;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *imgId;

@end
