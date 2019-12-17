//
//  DiaryYearHalfCell.m
//  BabyShow
//
//  Created by Monica on 15-1-23.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "DiaryYearHalfCell.h"

@implementation DiaryYearHalfCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIImage *image = [UIImage imageNamed:@"img_diary_year_half_back"];
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(25, (40-image.size.height)/2, image.size.width, image.size.height)];
        backView.backgroundColor = [UIColor colorWithPatternImage:image];
        [self.contentView addSubview:backView];
        
        self.yearsHalfLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.yearsHalfLabel.backgroundColor = [UIColor clearColor];
        self.yearsHalfLabel.font = [UIFont systemFontOfSize:16];
        self.yearsHalfLabel.textColor = [BBSColor hexStringToColor:@"c0c0c0"];
        [self.contentView addSubview:self.yearsHalfLabel];
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
