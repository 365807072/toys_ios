//
//  ToyLeftCell.m
//  BabyShow
//
//  Created by WMY on 16/12/12.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyLeftCell.h"

@implementation ToyLeftCell

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
        self.photoImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 88, 88)];
        [self.photoImgView setContentMode:UIViewContentModeScaleAspectFill];
        self.photoImgView.layer.masksToBounds = YES;
        self.photoImgView.layer.cornerRadius = 44;
        self.photoImgView.image = [UIImage imageNamed:@"img_message_photo"];
        self.photoImgView.clipsToBounds = YES;
        [self.contentView addSubview:self.photoImgView];
        
        self.selectImgView = [[UIImageView alloc]initWithFrame:CGRectMake(112, 48, 12, 12)];
        self.selectImgView.image = [UIImage imageNamed:@"toy_select_statu"];
        [self.contentView addSubview:self.selectImgView];
        
        self.btnStatu = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.btnStatu setBackgroundImage:[UIImage imageNamed:@"toy_left"] forState:UIControlStateNormal];
        self.btnStatu.titleLabel.font = [UIFont systemFontOfSize:14];
        self.btnStatu.frame = CGRectMake(134, 41, 74, 26);
        [self.contentView addSubview:self.btnStatu];
        
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.btnStatu.frame.origin.x, self.btnStatu.frame.origin.y+30, 200 , 20)];
        self.timeLabel.font = [UIFont systemFontOfSize:13];
        self.timeLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        [self.contentView addSubview:self.timeLabel];
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        UIImageView *arrow = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-16)/2,0, 16, 11)];
        arrow.image = [UIImage imageNamed:@"toy_arrow"];
        [self.contentView addSubview:arrow];
        
        UIImageView *arrow1 = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-16)/2,97, 16, 11)];
        arrow1.image = [UIImage imageNamed:@"toy_arrow"];
        [self.contentView addSubview:arrow1];




    }
    return self;
}

@end
