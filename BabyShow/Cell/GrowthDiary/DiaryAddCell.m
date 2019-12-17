//
//  DiaryAddCell.m
//  BabyShow
//
//  Created by Monica on 15-2-2.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "DiaryAddCell.h"

@implementation DiaryAddCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect addPhotoFrame = CGRectMake(12, 9, 80, 80);
        UIImageView *addImageView = [[UIImageView alloc] initWithFrame:addPhotoFrame];
        addImageView.image = [UIImage imageNamed:@"btn_diary_add"];
        [self.contentView addSubview:addImageView];
        
        CGRect addLabelFrame = CGRectMake(95, 9, SCREENWIDTH - 95, 82);
        UILabel *addLabel = [[UILabel alloc] initWithFrame:addLabelFrame];
        addLabel.text = @"点击添加图片";
        addLabel.font = [UIFont systemFontOfSize:20];
        addLabel.textColor = [BBSColor hexStringToColor:@"fc5747"];
        addLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:addLabel];
        
        UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(10, 99.5, SCREENWIDTH-20, 0.5)];
        seperatorView.backgroundColor = [BBSColor hexStringToColor:@"cfcfcf"];
        [self.contentView addSubview:seperatorView];
        
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
