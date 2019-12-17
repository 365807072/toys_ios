//
//  ThemeCell.m
//  BabyShow
//
//  Created by Mayeon on 14-4-3.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ThemeCell.h"

@implementation ThemeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //全屏,44的差值不知道怎么回事
        CGRect backRect = (is4Inch == YES)?(CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)):(CGRectMake(0, 44, SCREENWIDTH, SCREENHEIGHT));
        
        self.themeImageView = [[ImageView alloc]initWithFrame:CGRectZero];
        self.themeImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.themeImageView];

        self.themeBackImageView = [[UIImageView alloc]initWithFrame:backRect];
        self.themeBackImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.themeBackImageView];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
