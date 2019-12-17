//
//  BusinessCommentListVC.h
//  BabyShow
//
//  Created by WMY on 15/11/4.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessCommentListVC : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSString *businessId;
@property(nonatomic,strong)NSString *login_userId;

@end
