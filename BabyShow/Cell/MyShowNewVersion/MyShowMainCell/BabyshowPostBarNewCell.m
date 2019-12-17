//
//  BabyshowPostBarNewCell.m
//  BabyShow
//
//  Created by WMY on 16/9/1.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "BabyshowPostBarNewCell.h"

@implementation BabyshowPostBarNewCell

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
        //左边大图
        //self.photoView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 75, 75 )];
        self.photoView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.photoView];
        
        self.videoView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8,60, 60)];
        self.videoView.backgroundColor = [UIColor clearColor];
        self.videoView.image = [UIImage imageNamed:@"play_btn_make_show"];
        [self.contentView addSubview:self.videoView];
        
        //群标和群名
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        
        [self.contentView addSubview:self.titleLabel];
        
        //参与人数和评论人数
        self.reviewLabel = [[UILabel alloc]init];
        // [self.reviewLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        self.reviewLabel.font = [UIFont systemFontOfSize:14.5];
        self.reviewLabel.textColor = [BBSColor hexStringToColor:@"#878787"];
        [self.contentView addSubview:self.reviewLabel];
        //群标识
        self.groupImageV = [[UIImageView alloc]init];
        
        [self.titleLabel addSubview:self.groupImageV];
        //群名
        self.titleLabelS = [[WMYLabel alloc]init];
        [self.titleLabelS setVerticalAlignment:VerticalAlignmentTop];
        self.titleLabelS.lineBreakMode = 1;
        //[self.titleLabelS setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        self.titleLabelS.font = [UIFont systemFontOfSize:16];
        
        [self.titleLabel addSubview:self.titleLabelS];
        //描述
        //self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(94, 65, 213, 18)];
        self.descriptionLabel = [[UILabel alloc]init];
        //[self.descriptionLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        self.descriptionLabel.font = [UIFont systemFontOfSize:13];
        //self.descriptionLabel.backgroundColor = [UIColor redColor];
        self.descriptionLabel.textColor = [BBSColor hexStringToColor:@"#a1a1a1"];
        [self.contentView addSubview:self.descriptionLabel];
        
        self.label = [[UILabel alloc]init];
        self.label.backgroundColor = [BBSColor hexStringToColor:@"#f4f4f4"];
        [self.contentView addSubview:self.label];

        
        
        
        
    }
    return self;
}


@end
