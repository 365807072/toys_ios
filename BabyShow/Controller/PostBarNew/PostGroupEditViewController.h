//
//  PostGroupEditViewController.h
//  BabyShow
//
//  Created by WMY on 15/7/22.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^refreshInPostMyGroupDetailBlock)(NSString *groudNameInGroup,BOOL isRefreshIntheVC);
@interface PostGroupEditViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (nonatomic, strong) NSString *login_user_id;
@property(nonatomic,assign)NSInteger group_id;
@property(nonatomic,strong)NSString *last_id;
@property(nonatomic,strong)NSString *groupName;
@property(nonatomic,copy)refreshInPostMyGroupDetailBlock refreshPostDetail;
@property(nonatomic,assign)BOOL isRefreshInOtherVC;
@end
