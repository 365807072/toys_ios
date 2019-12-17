//
//  EmailViewController.h
//  BabyShow
//
//  Created by Lau on 14-2-18.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *dataArray;
    
}

@end
