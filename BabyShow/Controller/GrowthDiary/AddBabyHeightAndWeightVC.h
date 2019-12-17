//
//  AddBabyHeightAndWeightVC.h
//  BabyShow
//
//  Created by WMY on 15/11/28.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^refreshInGrowthVC)();

@interface AddBabyHeightAndWeightVC : UIViewController
@property(nonatomic,strong)NSString *babyId;
@property(nonatomic,strong)NSString *loginUserId;
@property(nonatomic,copy)refreshInGrowthVC refreshIngrowthVC;
@property(nonatomic,strong)NSString *babyHeightOld;
@property(nonatomic,strong)NSString *babyWeightOld;

@end
