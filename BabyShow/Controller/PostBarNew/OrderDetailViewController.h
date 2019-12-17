//
//  OrderDetailViewController.h
//  BabyShow
//
//  Created by WMY on 15/9/21.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMYLabel.h"
//订单是否刷新
typedef void (^refreshInOrderList)();
@interface OrderDetailViewController : UIViewController<UIAlertViewDelegate>
@property(nonatomic,strong)UILabel *labelStoreName;
@property(nonatomic,strong)UILabel *labelTime;
@property(nonatomic,strong)UIImageView *imageStore;
@property(nonatomic,strong)UIImageView *imageAddress;
@property(nonatomic,strong)WMYLabel *labelAddress;
@property(nonatomic,strong)UIButton *btnReturnBackMoney;
@property(nonatomic,strong)NSString *order_id;
@property(nonatomic,strong)NSString *longin_user_id;
@property(nonatomic,assign)BOOL isStore;
@property(nonatomic,copy)refreshInOrderList refreshInOrderList;


@end
