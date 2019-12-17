//
//  PostBarManagementVC.h
//  BabyShow
//
//  Created by WMY on 16/9/22.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshControl.h"
#import "EditEssenceVC.h"

@interface PostBarManagementVC : UIViewController<EditEssenceDelegate,RefreshControlDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,assign)NSInteger groupId;


@end
