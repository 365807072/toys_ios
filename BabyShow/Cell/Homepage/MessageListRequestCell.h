//
//  MessageListRequestCell.h
//  BabyShow
//
//  Created by 于 晓波 on 1/20/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClickImage.h"

@protocol MessageListRequestCellDelegate <NSObject>

-(void)MessageListRequestCellClickOnAvatar:(UIButton *) btn;

@end

@interface MessageListRequestCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *Btn;
@property (nonatomic, strong) UIButton *avatarBtn;
@property (nonatomic, strong) UIImageView *isReadView;
@property(nonatomic,strong)ClickImage *levelImageView;

@property (nonatomic, assign) id <MessageListRequestCellDelegate> delegate;

@end
