//
//  MyOrdersViewController.h
//  BabyShow
//
//  Created by WMY on 15/9/16.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BBSTabBarViewController.h"

@interface MyOrdersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    UIView *_emptyView;
}
@property(nonatomic,strong)NSString *longUserId;
@property(nonatomic,strong)NSString *post_create_time;
@property(nonatomic,strong)NSString *fromPayOrder;
@property (nonatomic, strong) BBSTabBarViewController *tabbarcontroller;
@property (strong, nonatomic) UIWindow *window;
@end
