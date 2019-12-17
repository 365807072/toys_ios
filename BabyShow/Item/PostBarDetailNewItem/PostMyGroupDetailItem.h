//
//  PostMyGroupDetailItem.h
//  BabyShow
//
//  Created by WMY on 15/6/16.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostMyGroupDetailItem : NSObject
@property(nonatomic,strong)NSString *img;
@property (nonatomic, strong) NSString *imgId;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *img_title;
@property (nonatomic, strong) NSString *describe;
@property (nonatomic, strong) NSString *post_create_time;
@property (nonatomic, strong) NSString *create_time;
@property(nonatomic,assign)BOOL is_recommend;
@property (nonatomic, strong)NSString  *postCount;//帖子数
@property (nonatomic, strong)NSString  *reviewCount;//评论的人数
@property(nonatomic,assign)BOOL is_top;//是否置顶
@property(nonatomic,assign)NSInteger is_group;
@property(nonatomic,assign)BOOL isNotice;//是否是公告
@property(nonatomic,assign)BOOL isEssence;//是否精华
@property(nonatomic,strong)NSString *distinguish;
@property(nonatomic,strong)NSString *videoUrl;//视频的URL
@property (nonatomic, strong) NSString *img_thumb_height;
@property (nonatomic, strong) NSString *img_thumb_width;



@end
