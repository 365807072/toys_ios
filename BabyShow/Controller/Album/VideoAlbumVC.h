//
//  VideoAlbumVC.h
//  BabyShow
//
//  Created by WMY on 16/7/7.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshControl.h"
#import "VideoItem.h"
#import "PlayVideoMyCell.h"

@interface VideoAlbumVC : UIViewController<UITableViewDataSource,UITableViewDelegate,RefreshControlDelegate>
@property(nonatomic,strong)UITableView *tableViewVideo;
@property(nonatomic,strong)NSMutableArray *dataArrayNew;
@property(nonatomic,strong)NSString *userId;

@end
