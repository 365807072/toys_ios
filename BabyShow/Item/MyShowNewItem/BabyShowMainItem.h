//
//  BabyShowMainItem.h
//  BabyShow
//
//  Created by WMY on 16/4/7.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BabyShowMainItem : NSObject
@property(nonatomic,strong)NSString *imgTitle;
@property(nonatomic,strong)NSString *reviewCount;
@property(nonatomic,strong)NSString *postCount;
@property(nonatomic,strong)NSString *style;
@property(nonatomic,strong)NSArray *imgArray;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *postCreattime;
@property(nonatomic,strong)NSString *imgId;
@property(nonatomic,strong)NSString *imgThumb;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *currentPrice;
@property(nonatomic,strong)NSString *originalPrice;
@property(nonatomic,assign)NSInteger height;
@property(nonatomic,assign)NSInteger imgStyle;
@property(nonatomic,assign)NSInteger jump;
@property(nonatomic,assign)NSInteger cate_id;
@property(nonatomic,strong)NSString *video_url;
@property(nonatomic,assign)NSInteger tag_id; //标签的id
@property(nonatomic,strong)NSString *userName;//用户名，和标签名
@property(nonatomic,strong)NSString *show_post_create_time;//显示的时间
@property(nonatomic,strong)NSString *img_description;//视频的描述
@property(nonatomic,strong)NSString *hot_time_title;//热门题目
@property(nonatomic,strong)NSString *img_ids;
@property(nonatomic,strong)NSString *post_url;
@property(nonatomic,strong)NSString *business_id;
@property(nonatomic,strong)NSString *group_class_title;
@property(nonatomic,strong)NSString *essence_state;
@property(nonatomic,strong)NSString *color;
@end
