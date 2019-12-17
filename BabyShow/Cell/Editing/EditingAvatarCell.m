//
//  EditingAvatarCell.m
//  BabyShow
//
//  Created by Lau on 13-12-26.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "EditingAvatarCell.h"

@implementation EditingAvatarCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.label=[[UILabel alloc]initWithFrame:CGRectMake(10, 15, 100, 30)];
        self.label.font=[UIFont systemFontOfSize:14];
        self.label.backgroundColor=[UIColor clearColor];
        self.label.text=@"头像";
        [self.contentView addSubview:self.label];
        
        self.avatarView=[[UIImageView alloc]initWithFrame:CGRectMake(240, 5, 50, 50)];
        self.avatarView.image=[UIImage imageNamed:@"img_myshow_section_avatar.png"];
        self.avatarView.layer.masksToBounds = YES;
        self.avatarView.layer.cornerRadius = 25;
        [self addSubview:self.avatarView];
        
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
