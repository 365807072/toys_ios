//
//  WorthBuyViewController.h
//  BabyShow
//
//  Created by Lau on 8/25/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"
#import "WorthBuyCell.h"
#import "MWPhotoBrowser.h"


@interface WorthBuyViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

{
    
    UIImageView *_headerView;
    NSMutableArray *_headerViewDataArray;
    NSMutableArray *_todayViewDataArray;

    UITableView *_tableView;
    UIButton *_addTopicBtn;
    NSMutableArray *_dataArray;
    
    UISegmentedControl *_seg;
    
    BOOL _isRefresh;
    BOOL _isGetMore;
    BOOL _isFinished;
    
    NSInteger _selectedIndex;
    NSInteger _refreshIndex;
    
    NSMutableArray *_PhotoArray;
    NSMutableArray *_channelViewArray;

}

@property (nonatomic, strong) NSString *timeForPage;
@property (nonatomic, strong) NSString *loginUserId;
@property(nonatomic,strong)NSString *last_id;

@end
