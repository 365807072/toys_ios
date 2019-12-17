//
//  PostMyGroupDetailVController.h
//  BabyShow
//
//  Created by WMY on 15/6/16.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostBarNewMakeAPost.h"
#import "PostGroupEditViewController.h"
typedef void(^refreshInTheVCBlock) (BOOL isRefreshInthePostBar);

@interface PostMyGroupDetailVController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSString *login_user_id;
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,assign)NSInteger group_id;
@property(nonatomic,strong)NSString *last_id;
@property(nonatomic,assign)NSInteger post_class;
@property(nonatomic,assign)BOOL isShare;

@property(nonatomic,assign)BOOL isRefreshIntheVC;
@property(nonatomic,copy)refreshInTheVCBlock  refreshBlock;

@end
