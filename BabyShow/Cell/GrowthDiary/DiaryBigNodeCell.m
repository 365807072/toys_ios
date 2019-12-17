//
//  DiaryBigNodeCell.m
//  BabyShow
//
//  Created by Monica on 15-1-23.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "DiaryBigNodeCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation DiaryBigNodeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        CGRect nodeFrame = CGRectMake(17, 38.5, 15, 15);
        self.nodeImageView = [[UIImageView alloc] initWithFrame:nodeFrame];
        self.nodeImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.nodeImageView];
        
        CGRect nameFrame = CGRectMake(124, 25, SCREENWIDTH -150, 20);
        self.nodeNameLabel = [[UILabel alloc] initWithFrame:nameFrame];
        self.nodeNameLabel.backgroundColor = [UIColor clearColor];
        self.nodeNameLabel.font = [UIFont systemFontOfSize:15];
        self.nodeNameLabel.textColor = [BBSColor hexStringToColor:@"838383"];
        [self.contentView addSubview:self.nodeNameLabel];
        
        CGRect tagFrame = CGRectMake(124, 6, 0, 18);
        self.tagLabel = [[UILabel alloc] initWithFrame:tagFrame];
        self.tagLabel.backgroundColor = [BBSColor hexStringToColor:@"ff6767"];
        self.tagLabel.layer.cornerRadius = 9;
        self.tagLabel.layer.masksToBounds = YES;
        self.tagLabel.font = [UIFont systemFontOfSize:13];
        self.tagLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.tagLabel];
        
        CGRect imageFrame = CGRectMake(37.5, 9, 80, 80);
        self.coverImageView = [[UIImageView alloc] initWithFrame:imageFrame];
        self.coverImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.coverImageView];
        
        CGRect titleFrame = CGRectMake(124, 50, SCREENWIDTH-150, 40);
        self.titleLabel = [[UILabel alloc]initWithFrame:titleFrame];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = [BBSColor hexStringToColor:@"000000"];
        [self.contentView addSubview:self.titleLabel];
        
        CGRect countFrame = CGRectMake(38.5, 72.5, 40, 15);
        self.countLabel = [[UILabel alloc] initWithFrame:countFrame];
        self.countLabel.backgroundColor = [BBSColor hexStringToColor:@"000000" alpha:0.5];
        self.countLabel.textColor = [UIColor whiteColor];
        self.countLabel.font = [UIFont systemFontOfSize:13];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.layer.cornerRadius = 7.5;
        self.countLabel.layer.masksToBounds = YES;
        [self.contentView addSubview:self.countLabel];

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
