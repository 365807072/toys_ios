//
//  MyShowSectionHeaderView.m
//  BabyShow
//
//  Created by Lau on 13-12-15.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyShowSectionHeaderView.h"

@implementation MyShowSectionHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        CGRect avatarFrame=CGRectMake(5, 5, 33, 33);
        UIFont *font=[UIFont systemFontOfSize:14];
        
        self.avatarImageView=[[UIImageView alloc]initWithFrame:avatarFrame];
        self.avatarImageView.image=[UIImage imageNamed:@"img_myshow_section_avatar.png"];
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarImageView.layer.cornerRadius = 16.5;
        [self addSubview:self.avatarImageView];
        
        self.avatarBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.avatarBtn.frame=CGRectMake(0, 0, SCREENWIDTH, 40);
        [self.avatarBtn addTarget:self action:@selector(avatarOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.avatarBtn];
        
        self.nameLabel=[[UILabel alloc]initWithFrame:CGRectMake(43, 6, 140, 30)];
        self.nameLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
        self.nameLabel.textColor=[BBSColor hexStringToColor:BACKCOLOR];
        [self addSubview:self.nameLabel];
        
        self.clockImageView=[[UIImageView alloc]initWithFrame:CGRectMake(245, 16, 10, 10)];
        UIImage *clockimg=[UIImage imageNamed:@"img_time.png"];
        self.clockImageView.image=clockimg;
        [self addSubview:self.clockImageView];
        
        self.timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(260, 6, 60, 30)];
        self.timeLabel.font=font;
        self.timeLabel.textColor=[BBSColor hexStringToColor:@"c7aa89"];
        [self addSubview:self.timeLabel];
        
        self.contentView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_tableview_background.png"]];

        // Initialization code
    }
    return self;
}


-(void)avatarOnClick:(UIButton *) avatarBtn{
    
    if ([self.delegate respondsToSelector:@selector(ClickOnTheAvatar:)]) {
        
        [self.delegate ClickOnTheAvatar:avatarBtn];
        
    }
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
