//
//  SpecialDetailTableViewCell.h
//  BabyShow
//
//  Created by WMY on 15/5/16.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"
#import "ClickImage.h"


@interface SpecialDetailTableViewCell : UITableViewCell
@property (nonatomic, strong) btnWithIndexPath *avatarBtn;
@property (nonatomic, strong) btnWithIndexPath *addFriendsBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic ,strong) ClickImage *levelImageView;



@end
