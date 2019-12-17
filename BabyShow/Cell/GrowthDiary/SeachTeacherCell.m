//
//  SeachTeacherCell.m
//  BabyShow
//
//  Created by WMY on 15/12/15.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "SeachTeacherCell.h"

@implementation SeachTeacherCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.avatarImg = [BaseImageView imgViewWithFrame:CGRectMake(13, 10, 50, 50) backImg:nil userInterface:NO backgroupcolor:@"ff6b6b"];
        self.avatarImg.layer.masksToBounds = YES;
        self.avatarImg.layer.cornerRadius = 25;
        [self.contentView addSubview:self.avatarImg];
        
        self.userNameLabel = [BaseLabel makeFrame:CGRectMake(70, 14, 185, 20) font:20 textColor:@"333333" textAlignment:NSTextAlignmentLeft text:nil];
        [self.contentView addSubview:self.userNameLabel];
        
        self.babyNameLabel = [BaseLabel makeFrame:CGRectMake(70, 40, 185, 16) font:15 textColor:@"9b9b9b" textAlignment:NSTextAlignmentLeft text:nil];
        [self.contentView addSubview:self.babyNameLabel];
        
        self.fouceImg = [BaseImageView imgViewWithFrame:CGRectMake(SCREENWIDTH-97, 23, 86, 33) backImg:[UIImage imageNamed:@"img_diary_fouce"] userInterface:YES backgroupcolor:nil];
        [self.contentView addSubview:self.fouceImg];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 79, SCREENWIDTH, 1)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"efefef"];
        [self.contentView addSubview:lineView];
    }
    return self;
}
@end
