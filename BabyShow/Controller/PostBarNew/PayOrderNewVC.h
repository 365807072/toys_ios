//
//  PayOrderNewVC.h
//  BabyShow
//
//  Created by WMY on 16/3/28.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayOrderNewVC : UIViewController
@property(nonatomic,strong)NSString *longin_user_id;
@property(nonatomic,strong)NSString *business_id;
@property(nonatomic,strong)NSString *priceCombine;
@property(nonatomic, strong)NSString *channel;
@property(nonatomic,strong)NSString *order_id;
@property(nonatomic,strong)NSString *order_role;
@property(nonatomic,assign)BOOL isVisible;
@property(nonatomic,strong)NSString *payMent;

@end
