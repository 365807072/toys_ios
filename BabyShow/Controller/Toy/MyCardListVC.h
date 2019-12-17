//
//  MyCardListVC.h
//  BabyShow
//
//  Created by 美美 on 2018/8/2.
//  Copyright © 2018年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^refreshInVCBlock) (BOOL isRefresh);


@interface MyCardListVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,copy)refreshInVCBlock refreshInVC;
@property(nonatomic,assign)BOOL isRefreshInVC;


@end
