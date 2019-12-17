//
//  MyShowSectionHeaderView.h
//  BabyShow
//
//  Created by Lau on 13-12-15.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol MyShowSectionHeaderViewDelegate <NSObject>

-(void)ClickOnTheAvatar:(UIButton *) avatar;

@end

@interface MyShowSectionHeaderView : UITableViewHeaderFooterView


@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIImageView *clockImageView;
@property (nonatomic, strong) UIButton *avatarBtn;

@property (nonatomic, assign) id <MyShowSectionHeaderViewDelegate> delegate;

@end
