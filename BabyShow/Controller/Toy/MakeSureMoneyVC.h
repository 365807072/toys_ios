//
//  MakeSureMoneyVC.h
//  BabyShow
//
//  Created by WMY on 17/2/23.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MakeSureMoneyVC : UIViewController
@property(nonatomic,strong)NSString *combined_order_id;//批次订单号
@property(nonatomic,strong)NSString *fromWhere;//来自哪，0代表玩具详情，1代表购物车，2代表来着订单物流详情支付,3代表订单列表
@property(nonatomic,strong)NSString *invite_user_id;//邀请码

@end
