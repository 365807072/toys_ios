//
//  DiaryDetailUserCell.h
//  BabyShow
//
//  Created by Monica on 15-1-24.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaryDetailUserCell : UITableViewCell
{
    BOOL isClick;
}
- (void)setChecked:(BOOL)checked;

@property (nonatomic, strong) UIImageView *avatarView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property(nonatomic,strong)UIImageView *synchroImg;


@end
