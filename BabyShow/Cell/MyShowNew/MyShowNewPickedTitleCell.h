//
//  MyShowNewPickedTitleCell.h
//  BabyShow
//
//  Created by Monica on 9/24/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"
#import "ClickImage.h"

@protocol MyShowNewPickedTitleCellDelegate <NSObject>

-(void)PickedTitleCellGotoTheUserPage:(btnWithIndexPath *) btn;
-(void)PickedTitleCellAddFocus:(btnWithIndexPath *)btn;

@end

@interface MyShowNewPickedTitleCell : UITableViewCell

@property (nonatomic, assign) id <MyShowNewPickedTitleCellDelegate> delegate;
@property (nonatomic, strong) btnWithIndexPath *avatarBtn;
@property (nonatomic, strong) btnWithIndexPath *addFriendsBtn;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic ,strong) ClickImage *levelImageView;

@end
