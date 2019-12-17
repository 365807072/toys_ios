//
//  EditBabyViewController.h
//  BabyShow
//
//  Created by 于 晓波 on 1/12/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditBabyViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

{
    UITableView *_tableView;
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSNumber *babyId;

@end
