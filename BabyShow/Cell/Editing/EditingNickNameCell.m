//
//  EditingNickNameCell.m
//  BabyShow
//
//  Created by Lau on 13-12-27.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "EditingNickNameCell.h"

@implementation EditingNickNameCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.label=[[UILabel alloc]initWithFrame:CGRectMake(10, 7, 100, 30)];
        self.label.font=[UIFont systemFontOfSize:14];
        self.label.text=@"昵称";
        self.label.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.label];
        
        self.nicknameLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 7, 180, 30)];
        self.nicknameLabel.textAlignment=NSTextAlignmentRight;
        self.nicknameLabel.font=[UIFont systemFontOfSize:14];
        self.nicknameLabel.backgroundColor=[UIColor clearColor];
        [self addSubview:self.nicknameLabel];
        
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;

//
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
