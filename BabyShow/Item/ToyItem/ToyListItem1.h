//
//  ToyListItem1.h
//  BabyShow
//
//  Created by WMY on 17/1/11.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToyListItem1 : NSObject
@property(nonatomic,strong)NSString *class_title;//分类标题
@property(nonatomic,strong)NSString *category_id; //分类id
@property(nonatomic,strong)NSString *class_more_title;//更多分类标题
@property(nonatomic,strong)NSString *show_type;//展示样式（1：一张图  2：三张并列 3：一拖三 4:四张两行）
@property(nonatomic,strong)NSMutableArray *business_info;//数组
@property(nonatomic,strong)NSString *post_create_time;

@end
