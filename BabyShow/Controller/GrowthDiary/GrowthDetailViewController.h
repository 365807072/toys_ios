//
//  GrowthDetailViewController.h
//  BabyShow
//
//  Created by Monica on 15-1-24.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GrowthDetailViewController : UIViewController

@property (nonatomic ,strong)NSString *babyID;
@property (nonatomic ,strong)NSString *nodeID;//album_id
@property (nonatomic ,strong)NSString *nodeName;//导航

@property (nonatomic ,assign)BOOL      refresh;


@end
