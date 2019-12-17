//
//  PostBarSecondeVC.h
//  BabyShow
//
//  Created by WMY on 15/6/23.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostBarSecondeVC :UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic, strong) NSString *login_user_id;
@property (nonatomic, strong) NSString *post_create_time;
@property (nonatomic, strong) NSString *post_class;
@property (nonatomic, strong) NSString *create_time;
@property(nonatomic,assign)NSInteger page;
@property (nonatomic, assign) NSInteger type;
@property(nonatomic,assign)NSInteger post_classes;
@property(nonatomic,strong)NSString *titleString;
@property(nonatomic,assign)NSInteger interestType;
@end
