//
//  DairyFouceCell.m
//  BabyShow
//
//  Created by WMY on 15/12/15.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "DairyFouceCell.h"

@implementation DairyFouceCell

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
        
        //self.fouceImg = [YLButton buttonEasyInitBackColor:nil frame:CGRectMake(SCREENWIDTH-97, 23, 86, 33) type:UIButtonTypeSystem backImage:[UIImage imageNamed:@"btn_diary_cancelfouce"] target:self action:nil forControlEvents:UIControlEventTouchUpInside];
        self.fouceImg = [UIButton buttonWithType:UIButtonTypeSystem];
        self.fouceImg.frame = CGRectMake(SCREENWIDTH-97, 23, 86, 33);
       // [self.fouceImg setBackgroundImage:[UIImage imageNamed:@"btn_diary_cancelfouce"]  forState:UIControlStateNormal];
        [self.contentView addSubview:self.fouceImg];
        
        
        [self.contentView addSubview:self.fouceImg];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 77, SCREENWIDTH, 1)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"efefef"];
        [self.contentView addSubview:lineView];
    }
    return self;
}

@end
