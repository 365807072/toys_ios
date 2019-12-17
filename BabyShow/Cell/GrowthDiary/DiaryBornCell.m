//
//  DiaryBornCell.m
//  BabyShow
//
//  Created by Monica on 15-2-7.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "DiaryBornCell.h"

@implementation DiaryBornCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [BBSColor hexStringToColor:@"e5e5e5"];
        self.contentView.backgroundColor = [BBSColor hexStringToColor:@"e5e5e5"];
        
        UIImageView *iconImageV = [[UIImageView alloc] initWithFrame:CGRectMake(70, 2.5, 59, 59)];
        iconImageV.image = [UIImage imageNamed:@"img_diary_bornbaby"];
        iconImageV.layer.masksToBounds = YES;
        iconImageV.layer.cornerRadius = 59/2;
        [self.contentView addSubview:iconImageV];
        
        self.bornLabel = [[UILabel alloc] initWithFrame:CGRectMake(143.5, 15.5, SCREENWIDTH - 143.5, 16)];
        self.bornLabel.font = [UIFont boldSystemFontOfSize:17];
        self.bornLabel.textColor = [BBSColor hexStringToColor:NAVICOLOR];
        [self.contentView addSubview:self.bornLabel];
        
        self.birthLabel = [[UILabel alloc] initWithFrame:CGRectMake(143.5, 33, SCREENWIDTH - 143.5, 16)];
        self.birthLabel.font = [UIFont boldSystemFontOfSize:15];
        self.birthLabel.textColor = [BBSColor hexStringToColor:NAVICOLOR];
        [self.contentView addSubview:self.birthLabel];
        
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
