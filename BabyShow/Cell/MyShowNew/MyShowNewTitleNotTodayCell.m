//
//  MyShowNewTitleNotTodayCell.m
//  BabyShow
//
//  Created by Monica on 9/22/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyShowNewTitleNotTodayCell.h"

@implementation MyShowNewTitleNotTodayCell

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
        
        self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(52, 6, 130, 30)];
        self.nameLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:15];
        self.nameLabel.textColor=[BBSColor hexStringToColor:BACKCOLOR];
        [self.contentView addSubview:self.nameLabel];
        
        self.typeView=[[UIImageView alloc]initWithFrame:CGRectMake(190, 12.5, 52, 18)];
        //self.typeView.image=[UIImage imageNamed:@"img_myshow_group_friends"];
        self.typeView.hidden = YES;
        [self.contentView addSubview:self.typeView];
        
        self.dayLabel=[[UILabel alloc]initWithFrame:CGRectMake(255, 6, 25, 30)];
        self.dayLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:22];
        self.dayLabel.textColor=[BBSColor hexStringToColor:@"c7aa89"];
        [self.contentView addSubview:self.dayLabel];
        
        self.monthLabel=[[UILabel alloc]initWithFrame:CGRectMake(280, 11, 45, 10)];
        self.monthLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:10];
        self.monthLabel.textColor=[BBSColor hexStringToColor:@"c7aa89"];
        [self.contentView addSubview:self.monthLabel];
        
        self.yearLabel=[[UILabel alloc]initWithFrame:CGRectMake(280, 21, 45, 10)];
        self.yearLabel.font=[UIFont systemFontOfSize:10];
        self.yearLabel.textColor=[BBSColor hexStringToColor:@"c7aa89"];
        [self.contentView addSubview:self.yearLabel];

        self.levelImageView = [[ClickImage alloc]initWithFrame:CGRectZero];

        self.levelImageView.image = nil;
        self.levelImageView.contentMode =UIViewContentModeLeft;
        self.levelImageView.contentMode = UIViewContentModeScaleAspectFit;

        self.levelImageView.canClick = YES;
        [self.contentView addSubview:self.levelImageView];
        
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
       // self.contentView.backgroundColor = [UIColor greenColor];

    }
    return self;
}

-(void)OnClick:(btnWithIndexPath *) btn{
    
    if ([self.delegate respondsToSelector:@selector(ClickOnTheAvatarNotToday:)]) {
        [self.delegate ClickOnTheAvatarNotToday:btn];
    }
    
}

@end
