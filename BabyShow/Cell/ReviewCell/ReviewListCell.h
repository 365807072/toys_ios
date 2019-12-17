//
//  ReviewListCell.h
//  BabyShow
//
//  Created by Lau on 13-12-18.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NimbusAttributedLabel.h"

@protocol ReviewListCellDelegate <NSObject>

-(void)avatarOnClick:(UIButton *) Button;
-(void)cellOnLongPress:(UITableViewCell *) cell;

@end

@interface ReviewListCell : UITableViewCell

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NIAttributedLabel *contentLabel;
@property (nonatomic, strong) UIButton *btn;
@property (nonatomic, strong) UIButton *avatarBtn;
@property (nonatomic, strong) UIImageView *seperateView;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@property (nonatomic, assign) id <ReviewListCellDelegate> delegate;

@end
