//
//  DiaryYearsCell.m
//  BabyShow
//
//  Created by Monica on 15-2-7.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "DiaryYearsCell.h"

@implementation DiaryYearsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        UIImage *image = [UIImage imageNamed:@"img_diary_year_back"];
        
        image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(1, 0, 1, 0)];
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(25, 2.5, SCREENWIDTH - 25, 30)];
        imageV.image = image;
        [self.contentView addSubview:imageV];
        
        self.yearsLabel = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(25, 0, SCREENWIDTH - 50, 35)];
        self.yearsLabel.textAlignment = NSTextAlignmentCenter;
        self.yearsLabel.font = [UIFont systemFontOfSize:17];
        self.yearsLabel.textColor = [BBSColor hexStringToColor:@"9b9b9b"];
        [self.contentView addSubview:self.yearsLabel];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
