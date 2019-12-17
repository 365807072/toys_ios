//
//  GrowthDiaryViewController.h
//  BabyShow
//
//  Created by Monica on 15-1-20.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>

@interface GrowthDiaryViewController : UIViewController

@property (nonatomic,assign) BOOL needReload;//主要在详情删除全部后,返回需要删除该节点
@property (nonatomic ,assign) BOOL refresh;//第二个页面返回时是否刷新
@end
