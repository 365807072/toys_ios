//
//  StoreOrdersItem.h
//  BabyShow
//
//  Created by WMY on 15/9/23.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoreOrdersItem : NSObject
@property(nonatomic,strong)NSString *order_id;
@property(nonatomic,strong)NSString *orderNum;
@property(nonatomic,strong)NSString *postCreatTime;
@property(nonatomic,strong)NSString *package;
@property(nonatomic,strong)NSString *price;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *verification;
@property(nonatomic,strong)NSString *package_name;
@end
