//
//  RedBagListItem.h
//  BabyShow
//
//  Created by WMY on 15/12/9.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedBagListItem : NSObject
@property(nonatomic,strong)NSNumber *packet_price;
@property(nonatomic,strong)NSString *packet_type;
@property(nonatomic,strong)NSString *packet_msg;
@property(nonatomic,strong)NSString *expiration;
@property(nonatomic,strong)NSString *ExpiryDate;
@property(nonatomic,strong)NSNumber *post_create_time;

@end
