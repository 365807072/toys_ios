//
//  GrowthEditViewController.h
//  BabyShow
//
//  Created by Monica on 15-1-28.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

//
//ios8:UITableViewCell->UITableViewCellContentView->UILabel
//ios7:UITableViewCell->UITableViewCellScrollView->UITableViewCellContentView->UILabel
//ios8又变为了iOS6之前的视图结构

@interface GrowthEditViewController : UIViewController

@property (nonatomic ,strong)NSString *babyID;
@property (nonatomic ,strong)NSString *nodeID;//album_id
@property (nonatomic ,strong)NSString *nodeName; //节点名称,显示在导航条
@property (nonatomic ,strong)NSString *nodeTitle;//节点标题,类似话题标题

//上传网络图数组
@property (nonatomic ,strong)NSArray *urlsArray;
@property (nonatomic ,assign)BOOL uploadUrls;//是否上传网络图片

@property (nonatomic, assign) BOOL ifPrivacy;
@property (nonatomic, strong) UIButton *privacyBtn;

@end
