//
//  PostBarManagementItem.h
//  BabyShow
//
//  Created by WMY on 16/9/22.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostBarManagementItem : NSObject
@property(nonatomic,strong)NSString *img_title;
@property(nonatomic,strong)NSString *img_description;
@property(nonatomic,strong)NSString *img_id;
@property(nonatomic,strong)NSString *is_group;
@property(nonatomic,strong)NSString *post_create_time;
@property(nonatomic,strong)NSArray *essence;
@property(nonatomic,strong)NSArray *group_class;
@property(nonatomic,strong)NSArray *imgArray;
@property(nonatomic,strong)NSString *show_essence_name;

@end
