//
//  JingHuaVC.h
//  BabyShow
//
//  Created by WMY on 15/12/25.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JingHuaVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSString *login_user_id;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSString *last_id;
@property(nonatomic,assign)NSInteger goup_type;
@property(nonatomic,assign)NSInteger goupId;

@end
