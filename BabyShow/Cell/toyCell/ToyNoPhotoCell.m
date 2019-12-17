//
//  ToyNoPhotoCell.m
//  BabyShow
//
//  Created by WMY on 16/12/12.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyNoPhotoCell.h"

@implementation ToyNoPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 27, 12, 12)];
        self.selectImgView.image = [UIImage imageNamed:@"toy_select_statu"];
        [self.contentView addSubview:self.selectImgView];
        
        self.btnStatu = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnStatu setBackgroundImage:[UIImage imageNamed:@"toy_left"] forState:UIControlStateNormal];
        self.btnStatu.frame = CGRectMake(32, 22, 74, 26);
        self.btnStatu.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.btnStatu];
        
        UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-16)/2, 55, 16, 11)];
        arrow.image = [UIImage imageNamed:@"toy_arrow"];
        [self.contentView addSubview:arrow];
        
    }
    return self;
}
@end
