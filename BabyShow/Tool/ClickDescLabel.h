//
//  ClickLabel.h
//  BabyShow
//
//  Created by Monica on 15-1-19.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "NIAttributedLabel.h"
@class ClickDescLabel;

@protocol ClickLabelDelegate <NSObject>
@optional
- (void)clickLabel:(ClickDescLabel *)label touchesWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface ClickDescLabel : NIAttributedLabel

@property (nonatomic ,strong)NSIndexPath *indexPath;
@property (nonatomic ,assign)id<ClickLabelDelegate>clickDelegate;


@end
