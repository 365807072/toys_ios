//
//  PostBarNewReview_ReviewUserItem.h
//  BabyShow
//
//  Created by WMY on 16/11/15.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PostBarDetailNewBasicItem.h"
//评论的评论
@interface PostBarNewReview_ReviewUserItem : PostBarDetailNewBasicItem
@property(nonatomic,strong)NSString *review_review_id;
@property(nonatomic,strong)NSString *demand;
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *user_name;
@property(nonatomic,strong)NSString *avatar;
@property(nonatomic,strong)NSString *level_img;
@property(nonatomic,strong)NSString *post_create_time;
@property(nonatomic,strong)NSString *review_id;


@end
