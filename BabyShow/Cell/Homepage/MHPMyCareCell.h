//
//  MHPMyCareCell.h
//  BabyShow
//
//  Created by Lau on 14-1-2.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MHPMyCareCellDelegate <NSObject>

-(void)addToBeMyFocus:(UIButton *) btn;
-(void)ClickOnTheAvatar:(UIButton *) avatar;

@end

@interface MHPMyCareCell : UITableViewCell

@property (nonatomic ,strong) UIImageView *avatarView;
@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UIButton *Btn;
@property (nonatomic ,strong) UIButton *avatarBtn;

@property (nonatomic ,assign) id <MHPMyCareCellDelegate> delegate;

@end
