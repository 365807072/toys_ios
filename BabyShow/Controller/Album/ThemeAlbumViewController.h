//
//  ThemeAlbumViewController.h
//  BabyShow
//
//  Created by Mayeon on 14-4-8.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTViewController.h"
#import "MWPhotoBrowser.h"
#import "PhotosEditViewController.h"


@interface ThemeAlbumViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,MWPhotoBrowserDelegate>
/**
 *  从我的相册点主题相册进入的界面
 */
@property (nonatomic ,strong)NSString *user_id;
@property (nonatomic ,strong)NSDictionary *formerDict;           //  前一页传递的字典
@property (nonatomic ,assign)int type ; 

@property (nonatomic ,strong)NSMutableArray *dataArray;          //数据源
@property (nonatomic ,strong)NSMutableArray *mwphotosArray;

@property (nonatomic ,strong)UITableView *themeAlbumTableView;


@end
