//
//  PhotoShareViewController.h
//  BabyShow
//
//  Created by Lau on 14-2-11.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHPMyCareCell.h"
#import "ASIHTTPRequest.h"
#import "ShareItem.h"
#import "MoreBtnCell.h"

@interface PhotoShareViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MHPMyCareCellDelegate,UIActionSheetDelegate,UIAlertViewDelegate>

{
    
    UITableView *_tableView;
    NSMutableArray *dataArray;
    UILabel *_anouceLabel;
    BOOL _isGetMore;
    UIView *_emptyView;

    
}

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, assign) int       page;

@end
