//
//  PhotosViewController.h
//  BabyShow
//
//  Created by Lau on 14-1-6.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

/****相册列表****/
#import <UIKit/UIKit.h>
#import "AlbumBabyCell.h"

typedef enum : NSUInteger {
    AlbumListViewControllerTypeNormal,
    AlbumListViewControllerTypePostBar,
} AlbumListViewControllerType;

@interface  AlbumListViewController: UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,AlbumCellDelegate>
{
    
}

@property (nonatomic ,strong)NSDictionary *movingInfo;          //图片移动时的信息


@property (nonatomic,strong)UITableView *albumListTableView;    //相册列表
@property (nonatomic,strong)NSMutableArray *dataSourceArray;    //数据源
@property (nonatomic,strong)NSMutableArray *shareAlbumArray;
@property (nonatomic,assign)NSInteger type;
@end
