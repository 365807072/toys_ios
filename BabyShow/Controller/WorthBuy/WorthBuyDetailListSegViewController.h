//
//  WorthBuyDetailListSegViewController.h
//  BabyShow
//
//  Created by WMY on 15/6/2.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVPullToRefresh.h"
#import "WorthBuyCell.h"
#import "MWPhotoBrowser.h"


@interface WorthBuyDetailListSegViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,WorthBuyCellDelegate,MWPhotoBrowserDelegate>
{
    
    UIScrollView *_headerView;
    NSMutableArray *_headerViewDataArray;
    
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
@property(nonatomic,assign)NSInteger buy_class;
@property(nonatomic,assign)NSInteger buy_type;


@end
