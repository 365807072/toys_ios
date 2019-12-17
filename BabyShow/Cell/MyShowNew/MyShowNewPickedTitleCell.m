//
//  MyShowNewPickedTitleCell.m
//  BabyShow
//
//  Created by Monica on 9/24/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyShowNewPickedTitleCell.h"

@implementation MyShowNewPickedTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect avatarFrame=CGRectMake(14, 5, 33, 33);

        self.avatarBtn=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.avatarBtn.frame=avatarFrame;
        self.avatarBtn.layer.masksToBounds=YES;
        self.avatarBtn.layer.cornerRadius=16.5;
        [self.avatarBtn setBackgroundImage:[UIImage imageNamed:@"img_myshow_section_avatar.png"] forState:UIControlStateNormal];
        [self.avatarBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.avatarBtn];

        self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(52, 6, 140, 30)];
        self.nameLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:15];
        self.nameLabel.textColor=[BBSColor hexStringToColor:BACKCOLOR];
        [self.contentView addSubview:self.nameLabel];

        self.addFriendsBtn=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.addFriendsBtn.frame=CGRectMake(255, 9, 59.5, 24.5);
        [self.addFriendsBtn setBackgroundImage:[UIImage imageNamed:@"btn_myshownew_picked_add_focus" ] forState:UIControlStateNormal];
        [self.addFriendsBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.addFriendsBtn];
        
        self.levelImageView = [[ClickImage alloc]initWithFrame:CGRectZero];
        self.levelImageView.image = nil;
        self.levelImageView.canClick = YES;
       // self.levelImageView.backgroundColor = [UIColor redColor];
        //self.levelImageView.contentMode = UIViewContentModeLeft;
       // self.levelImageView.contentMode = UIViewContentModeScaleAspectFit;
//        self.levelImageView.contentMode = UIViewContentModeBottomLeft;
        
        [self.contentView addSubview:self.levelImageView];
                
        self.backgroundColor=[UIColor clearColor];

    }
    return self;
}

-(void)OnClick:(btnWithIndexPath *) btn{
    
    if (btn==self.avatarBtn) {
        if ([self.delegate respondsToSelector:@selector(PickedTitleCellGotoTheUserPage:)]) {
            [self.delegate PickedTitleCellGotoTheUserPage:btn];
        }
    }else if (btn==self.addFriendsBtn){
        if ([self.delegate respondsToSelector:@selector(PickedTitleCellAddFocus:)]) {
            [self.delegate PickedTitleCellAddFocus:btn];
        }
    }
    
}


@end
