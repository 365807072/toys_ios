//
//  MakeSurePaySureVC.h
//  BabyShow
//
//  Created by WMY on 16/12/9.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MakeSurePaySureVC : UIViewController
@property(nonatomic,strong)NSString *businessId;//玩具的id
@property(nonatomic,strong)NSString *source;//来源 0单个玩具或卡【默认】、1购物车、2订单、3批次订单
@property(nonatomic,strong)NSString *orderIdOrderList;//来自订单列表里面的小订单的支付
@property(nonatomic,strong)NSString *combined_order_idOrderLst;//来自订单列表的批次订单支付
@property(nonatomic,strong)NSString *fromWhere;//来自哪，0代表玩具详情，1代表购物车，2代表来着订单物流详情支付,3代表订单列表,4代表非首页购物车

@end
