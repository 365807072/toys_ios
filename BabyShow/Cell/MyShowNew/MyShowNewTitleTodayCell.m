//
//  MyShowNewTitleTodayCell.m
//  BabyShow
//
//  Created by Monica on 9/22/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyShowNewTitleTodayCell.h"

@implementation MyShowNewTitleTodayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect avatarFrame=CGRectMake(14, 5, 33, 33);
        UIFont *font=[UIFont systemFontOfSize:13];
        
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
        
        self.typeView=[[UIImageView alloc]initWithFrame:CGRectMake(190, 12.5, 52, 18)];
       // self.typeView.image=[UIImage imageNamed:@"img_myshow_group_friends"];
        self.typeView.hidden = YES;
        [self.contentView addSubview:self.typeView];
        
        self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(255, 6, 65, 30)];
        self.timeLabel.font=font;
        self.timeLabel.textColor=[BBSColor hexStringToColor:@"c7aa89"];
        [self.contentView addSubview:self.timeLabel];
        
        self.levelImageView = [[ClickImage alloc]initWithFrame:CGRectZero];
        self.levelImageView.backgroundColor = [UIColor clearColor];
        self.levelImageView.image = nil;
        self.levelImageView.canClick = YES;

        [self.contentView addSubview:self.levelImageView];
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
    
    }
    return self;
}

-(void)OnClick:(btnWithIndexPath *) btn{
    
    if ([self.delegate respondsToSelector:@selector(ClickOnTheAvatar:)]) {
        [self.delegate ClickOnTheAvatar:btn];
    }
    
}

@end
