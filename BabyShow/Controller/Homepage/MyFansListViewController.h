//
//  MyFansListViewController.h
//  BabyShow
//
//  Created by 于 晓波 on 1/4/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MHPMyCareCell.h"
#import "IdolListItem.h"

@class NetAccess;
@interface MyFansListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MHPMyCareCellDelegate,UIActionSheetDelegate>
{
    NSMutableArray *_dataArray;
    
    NetAccess *netAccess;
    
    IdolListItem *_selectedItem;
        
    BOOL _isGetMore;
    UIView *_emptyView;
    
}
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, assign) int       page;
@end
