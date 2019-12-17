//
//  SpecialAvatarsCell.m
//  BabyShow
//
//  Created by WMY on 15/5/18.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "SpecialAvatarsCell.h"

@implementation SpecialAvatarsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.avatarImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 25, 25)];
        self.avatarImageView1.layer.masksToBounds = YES;
        self.avatarImageView1.layer.cornerRadius = 12.5;

        [self.contentView addSubview: self.avatarImageView1];
        
        self.avatarImageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(39, 0, 25, 25)];
        self.avatarImageView2.layer.masksToBounds = YES;
        self.avatarImageView2.layer.cornerRadius = 12.5;

        [self.contentView addSubview: self.avatarImageView2];

        self.avatarImageView3 = [[UIImageView alloc]initWithFrame:CGRectMake(68, 0, 25, 25)];
        self.avatarImageView3.layer.masksToBounds = YES;
        self.avatarImageView3.layer.cornerRadius = 12.5;

        [self.contentView addSubview: self.avatarImageView3];

        self.avatarImageView4 = [[UIImageView alloc]initWithFrame:CGRectMake(98, 0, 25, 25)];
        self.avatarImageView4.layer.masksToBounds = YES;
        self.avatarImageView4.layer.cornerRadius = 12.5;
        [self.contentView addSubview: self.avatarImageView4];
        
        
        self.avatarImageView5 = [[UIImageView alloc]initWithFrame:CGRectMake(127, 0, 25, 25)];
        self.avatarImageView5.layer.masksToBounds = YES;
        self.avatarImageView5.layer.cornerRadius = 12.5;
        [self.contentView addSubview: self.avatarImageView5];
        
        self.partLabel = [[UILabel alloc]initWithFrame:CGRectMake(200, 5, SCREENWIDTH-204, 15)];
        self.partLabel.textAlignment = NSTextAlignmentRight;
        self.partLabel.font = [UIFont systemFontOfSize:14];
        self.partLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.partLabel];
        
        
        self.grayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 34, SCREENWIDTH, 6)];
        self.grayLabel.backgroundColor = KColorRGB(242, 242, 242, 1);
        [self.contentView addSubview:self.grayLabel];


        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
        
        
        
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
