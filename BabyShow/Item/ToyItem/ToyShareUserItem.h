//
//  ToyShareUserItem.h
//  BabyShow
//
//  Created by WMY on 17/3/28.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToyShareUserItem : NSObject
@property(nonatomic,strong)NSString *invitation_id;
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *avatar;
@property(nonatomic,strong)NSString *nick_name;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *status_title;
@property(nonatomic,strong)NSString *inv_description;
@property(nonatomic,strong)NSString *inv_button;

@end
