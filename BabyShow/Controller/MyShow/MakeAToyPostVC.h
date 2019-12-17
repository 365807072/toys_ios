//
//  MakeAToyPostVC.h
//  BabyShow
//
//  Created by WMY on 16/12/8.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^refreshInGrowthVC)();

@interface MakeAToyPostVC : UIViewController
@property (nonatomic ,strong) NSMutableArray *pickedImagesArray;
@property(nonatomic,copy)refreshInGrowthVC refreshIngrowthVC;


@end
