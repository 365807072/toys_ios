//
//  MyShowPickedBabyCell.h
//  BabyShow
//
//  Created by Monica on 9/28/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"
#import "ClickImage.h"

@protocol MyShowPickedBabyCellDelegate <NSObject>

-(void)PickedBabyClickOnTheAvatar:(btnWithIndexPath *) btn;

@end

@interface MyShowPickedBabyCell : UITableViewCell

@property (nonatomic, assign) id <MyShowPickedBabyCellDelegate> delegate;
@property (nonatomic, strong) btnWithIndexPath *avatarBtn;
@property (nonatomic, strong) ClickImage *pickedBabyView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic ,strong) ClickImage *levelImageView;
@property(nonatomic,strong)UIImageView *typeView;

@end
