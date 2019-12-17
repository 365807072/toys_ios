//
//  WorthBuyTodayItem.h
//  BabyShow
//
//  Created by WMY on 15/6/1.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorthBuyTodayItem : NSObject
@property(nonatomic,strong)NSString *current_price;
@property(nonatomic,strong)NSString *buy_list;
@property(nonatomic,strong)NSMutableArray *imgs;
@property(nonatomic,strong)NSString *img_thumb;

@end
