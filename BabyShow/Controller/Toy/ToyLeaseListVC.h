//
//  ToyLeaseListVC.h
//  BabyShow
//
//  Created by WMY on 16/12/6.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToyLeaseListVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,assign)NSInteger inTheViewData;
-(void)changeData:(NSInteger)tag;
@end
