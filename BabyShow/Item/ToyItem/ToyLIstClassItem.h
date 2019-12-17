//
//  ToyLIstClassItem.h
//  BabyShow
//
//  Created by 美美 on 2018/1/31.
//  Copyright © 2018年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToyLIstClassItem : NSObject
@property(nonatomic,strong)NSString *business_id;
@property(nonatomic,strong)NSString *business_title;
@property(nonatomic,strong)NSString *sell_price;
@property(nonatomic,strong)NSString *source;//跳转方向（1：玩具详情；2:跳分类 3：外链；）
@property(nonatomic,strong)NSString *web_link;//外链地址
@property(nonatomic,strong)NSString *business_pic;
@property(nonatomic,strong)NSString *unit_name;
@property(nonatomic,strong)NSString *business_title_ios16;
@property(nonatomic,strong)NSString *business_title_ios14;




@end
