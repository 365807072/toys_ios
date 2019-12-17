//
//  DiaryEditCell.m
//  BabyShow
//
//  Created by Monica on 15-2-2.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "DiaryEditCell.h"

@implementation DiaryEditCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        CGRect photoFrame = CGRectMake(12, 5, 80, 80);
        self.photoImageView = [[UIImageView alloc] initWithFrame:photoFrame];
        self.photoImageView.backgroundColor = [UIColor clearColor];
        self.photoImageView.image = [UIImage imageNamed:@"img_imgloding"];
        [self.contentView addSubview:self.photoImageView];
        
        CGRect timeFrame = CGRectMake(116, 5, 180, 20);
        self.timeLabel = [[UILabel alloc] initWithFrame:timeFrame];
        self.timeLabel.backgroundColor = [UIColor clearColor];
        self.timeLabel.textColor = [BBSColor hexStringToColor:@"3e3b3b"];
        self.timeLabel.font = [UIFont systemFontOfSize:14];
        self.timeLabel.textAlignment = NSTextAlignmentCenter;
        self.timeLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:self.timeLabel];
    
        UIImage *image = [UIImage imageNamed:@"img_diary_arrow1"];
        CGRect arrowFrame = CGRectMake(290, 8, image.size.width, image.size.height);
        self.arrowImageV = [[UIImageView alloc] initWithFrame:arrowFrame];
        self.arrowImageV.image = image;
        [self.contentView addSubview:self.arrowImageV];
        
        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(116, 25.5, 180, 0.5)];
        seperatorView.backgroundColor = [BBSColor hexStringToColor:@"cfcfcf"];
        [self.contentView addSubview:seperatorView];
        
        CGRect descFrame = CGRectMake(100, 30, SCREENWIDTH - 110 , 60);
        self.descTextView = [[UITextView alloc] initWithFrame:descFrame];
        self.descTextView.backgroundColor = [UIColor clearColor];
        self.descTextView.font = [UIFont systemFontOfSize:17];
        self.descTextView.textColor = [BBSColor hexStringToColor:@"919191"];
        [self.contentView addSubview:self.descTextView];
        
        CGRect hintFrame = CGRectMake(116, 48, 180 , 20);
        self.hintLabel = [[UILabel alloc] initWithFrame:hintFrame];
        self.hintLabel.text = @"点击添加图片描述";
        self.hintLabel.textColor = [BBSColor hexStringToColor:@"919191"];
        self.hintLabel.textAlignment = NSTextAlignmentCenter;
        self.hintLabel.font = [UIFont systemFontOfSize:15];
        self.hintLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.hintLabel];
        
        UIView *seperatorView1 = [[UIView alloc] initWithFrame:CGRectMake(10, 89.5, SCREENWIDTH - 20, 0.5)];
        seperatorView1.backgroundColor = [BBSColor hexStringToColor:@"cfcfcf"];
        [self.contentView addSubview:seperatorView1];
        
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
