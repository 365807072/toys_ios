//
//  UserMessageCell.h
//  BabyShow
//
//  Created by Lau on 6/4/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PBBasicCell.h"

@protocol PBUserMessageCellDelegate <NSObject>

-(void)clickOnTheAvatar:(UIButton*) avatar;

@end

@interface PBUserMessageCell :PBBasicCell

@property (nonatomic, strong) UIButton *avatarBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) id <PBUserMessageCellDelegate> delegate;

@end
