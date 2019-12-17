//
//  MessageCell.h
//  BabyShow
//
//  Created by Lau on 14-1-13.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickImage.h"

@protocol MessageCellDelegate <NSObject>

-(void)ClickOnAvatar:(UIButton *)btn;

-(void)ClickOnPhoto:(UIButton *)btn;

@end

@interface MessageCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *messLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *avatarBtn;
@property(nonatomic,strong)UIImageView *photoView;
@property (nonatomic, strong) UIButton *photoBtn;
@property (nonatomic, strong) UIImageView *isReadView;
@property(nonatomic,strong)ClickImage *levelImageView;

@property (nonatomic, assign) id <MessageCellDelegate> delegate;

@end
