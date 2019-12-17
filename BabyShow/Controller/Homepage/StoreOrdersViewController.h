//
//  StoreOrdersViewController.h
//  BabyShow
//
//  Created by WMY on 15/9/16.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreOrdersViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UIView *_emptyView;
}
@property(nonatomic,strong)NSString *longUserId;
@property(nonatomic,strong)NSString *post_create_time;

@end
