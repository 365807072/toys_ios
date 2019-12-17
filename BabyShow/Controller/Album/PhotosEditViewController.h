//
//  PhotosEditViewController.h
//  BabyShow
//
//  Created by Lau on 5/7/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosEditCell.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "UIImage+Scale.h"

@interface PhotosEditViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,PhotosEditCellDelegate>

{
    
    UITableView *_tableView;
    ASIDownloadCache *_cache;
    UIDatePicker *pickerView;
    UIActionSheet *acs;
    
}

@property (nonatomic, strong) NSMutableArray *dataArray;

@end
