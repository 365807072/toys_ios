//
//  PostMyInterestItem.h
//  BabyShow
//
//  Created by WMY on 15/6/12.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostMyInterestItem : NSObject
@property(nonatomic,strong)NSString *img;
@property(nonatomic,strong)NSString *img_thumb;
@property (nonatomic, strong) NSString *imgId;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *img_title;
@property (nonatomic, strong) NSString *describe;
@property (nonatomic, strong) NSString *post_create_time;
@property (nonatomic, strong) NSString *create_time;
@property(nonatomic,assign) NSInteger group_id;
@property(nonatomic,strong)NSString *group_name;
@property(nonatomic,assign)NSInteger is_group;
@property(nonatomic,assign)BOOL is_share;//是否分享
@property (nonatomic, strong)NSString  *postCount;//帖子数
@property (nonatomic, strong)NSString  *reviewCount;//评论的人数
@property(nonatomic,strong)NSString *business_market_price1;
@property(nonatomic,strong)NSString *business_babyshow_price1;
@property(nonatomic,strong)NSString *video_url;




@end
