//
//  MyShowNewPickedTitleFriendsCell.h
//  BabyShow
//
//  Created by Monica on 9/24/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"
#import "ClickImage.h"

@protocol MyShowNewPickedTitleFriendsCellDelegate <NSObject>

-(void)PickedTitleFriendsCellGotoTheUserPage:(btnWithIndexPath *) btn;

@end

@interface MyShowNewPickedTitleFriendsCell : UITableViewCell

@property (nonatomic, assign) id <MyShowNewPickedTitleFriendsCellDelegate> delegate;

@property (nonatomic, strong) btnWithIndexPath *avatarBtn;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic ,strong) ClickImage *levelImageView;
@property(nonatomic,strong)UIImageView *typeView;

@end
