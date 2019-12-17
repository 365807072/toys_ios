//
//  PostBarMoreViewController.h
//  BabyShow
//
//  Created by WMY on 15/8/28.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostBarMoreViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSString *login_user_id;
@property (nonatomic, strong) NSString *create_time;
@property(nonatomic,strong)NSString *titleString;
@property(nonatomic,assign)NSInteger interestType;
@property(nonatomic,strong)NSString *fromShow;


@end
