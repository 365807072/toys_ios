//
//  MyShowNewPickedTitleNotTodayCell.h
//  BabyShow
//
//  Created by Monica on 9/24/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"
#import "ClickImage.h"

@protocol MyShowNewPickedTitleNotTodayCellDelegate <NSObject>

-(void)PickedTitleNotTodayGotoTheUserPage:(btnWithIndexPath *)btn;

@end

@interface MyShowNewPickedTitleNotTodayCell : UITableViewCell

@property (nonatomic, assign) id<MyShowNewPickedTitleNotTodayCellDelegate> delegate;
@property (nonatomic, strong) btnWithIndexPath *avatarBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic ,strong) ClickImage *levelImageView;
@property(nonatomic,strong)UIImageView *typeView;

@end
