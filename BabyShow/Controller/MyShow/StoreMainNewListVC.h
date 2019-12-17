//
//  StoreMainNewListVC.h
//  BabyShow
//
//  Created by WMY on 16/8/8.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface StoreMainNewListVC : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate>
@property (nonatomic, strong) NSString *login_user_id;
@property (nonatomic, strong) NSString *post_create_time;
@property(nonatomic,assign) NSInteger tag_id;
@property(nonatomic,strong)NSString *img_ids;
@property(nonatomic,strong)NSString *titleNav;
@end
