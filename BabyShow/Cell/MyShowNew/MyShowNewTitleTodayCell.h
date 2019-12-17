//
//  MyShowNewTitleTodayCell.h
//  BabyShow
//
//  Created by Monica on 9/22/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"
#import "ClickImage.h"

@protocol MyShowNewTitleTodayCellDelegate <NSObject>

-(void)ClickOnTheAvatar:(btnWithIndexPath *) btn;

@end

@interface MyShowNewTitleTodayCell : UITableViewCell

@property (nonatomic, strong) btnWithIndexPath *avatarBtn;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *typeView;
@property (nonatomic ,strong) ClickImage *levelImageView;

@property (nonatomic, assign) id <MyShowNewTitleTodayCellDelegate> delegate;

-(void)setCellWithName:(NSString *) name AndLevelImage:(NSString *) imgUrl;

@end
