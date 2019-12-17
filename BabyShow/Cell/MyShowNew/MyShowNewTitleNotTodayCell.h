//
//  MyShowNewTitleNotTodayCell.h
//  BabyShow
//
//  Created by Monica on 9/22/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"
#import "ClickImage.h"

@protocol MyShowNewTitleNotTodayCellDelegate <NSObject>

-(void)ClickOnTheAvatarNotToday:(btnWithIndexPath *) btn;

@end

@interface MyShowNewTitleNotTodayCell : UITableViewCell

@property (nonatomic, strong) btnWithIndexPath *avatarBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *typeView;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic ,strong) ClickImage *levelImageView;

@property (nonatomic, assign) id <MyShowNewTitleNotTodayCellDelegate> delegate;

@end
