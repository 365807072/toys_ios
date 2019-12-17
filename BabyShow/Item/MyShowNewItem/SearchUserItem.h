//
//  SearchUserItem.h
//  BabyShow
//
//  Created by WMY on 16/8/8.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchUserItem : NSObject
@property(nonatomic,strong)NSString *search_id;
@property(nonatomic,strong)NSString *search_word;
@property(nonatomic,strong)NSString *img_description;
@property(nonatomic,strong)NSString *img_thumb;
@property(nonatomic,strong)NSString *is_group;
@property(nonatomic,strong)NSString *distance;
@property(nonatomic,strong)NSString *order_count;
@property(nonatomic,strong)NSString *market_price;
@property(nonatomic,strong)NSString *babyshow_price;
@property(nonatomic,strong)NSString *review_count;
@property(nonatomic,strong)NSString *post_count;
@property(nonatomic,strong)NSString *video_url;


@end
