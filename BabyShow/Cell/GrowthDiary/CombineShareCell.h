//
//  CombineShareCell.h
//  BabyShow
//
//  Created by Monica on 15-4-2.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"

@protocol CombineShareDelegate <NSObject>

@optional

//点击合并
- (void)combineUsers:(id)btn;
//点击头像
- (void)clickTheAvatar:(id)imgV;
@end

@interface CombineShareCell : UITableViewCell

@property (nonatomic ,strong) UIImageView           *iconImageV;
@property (nonatomic ,strong) UILabel               *babyNameLabel;
@property (nonatomic ,strong) UILabel               *userNameLabel;
@property (nonatomic ,strong) btnWithIndexPath      *combineBtn;
@property (nonatomic ,assign) id<CombineShareDelegate>delegate;

@end
