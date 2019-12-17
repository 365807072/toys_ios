//
//  SinglePhotoGroupCell.m
//  BabyShow
//
//  Created by WMY on 16/9/13.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "SinglePhotoGroupCell.h"

@implementation SinglePhotoGroupCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, 201-10, 40)];
        self.titleLabel.textColor = [BBSColor hexStringToColor:@"212121"];
        self.titleLabel.lineBreakMode = 1;
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];
        
        self.praiseCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 90-22,  191, 12)];
        self.praiseCountLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        self.praiseCountLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.praiseCountLabel];
        
        self.essImgView =[[UIImageView alloc]initWithFrame:CGRectMake(5,90-22, 5, 5)];
        self.essImgView.image = [UIImage imageNamed:@"btn_essence_state"];
        self.essImgView.hidden = YES;
        [self.contentView addSubview:self.essImgView];
        
        self.photoView = [[UIImageView alloc]initWithFrame:CGRectMake(201, 7, 109, 75)];
        [self.photoView setContentMode:UIViewContentModeScaleAspectFill];
        self.photoView.image = [UIImage imageNamed:@"img_message_photo"];
        self.photoView.clipsToBounds = YES;
        [self.contentView addSubview:self.photoView];
        
        self.videoView =[[UIImageView alloc]initWithFrame:CGRectMake(236, 27, 67*0.5, 67*0.5)];
        self.videoView.image = [UIImage imageNamed:@"play_btn_make_show"];
        [self.contentView addSubview:self.videoView];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0,89.5, SCREENWIDTH, 0.5)];
        self.lineView.backgroundColor = [BBSColor hexStringToColor:@"e8e8e8"];
        [self.contentView addSubview:self.lineView];
    }
    return self;
}

@end
