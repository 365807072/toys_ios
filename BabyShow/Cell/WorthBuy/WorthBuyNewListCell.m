//
//  WorthBuyNewListCell.m
//  BabyShow
//
//  Created by WMY on 15/6/1.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "WorthBuyNewListCell.h"

@implementation WorthBuyNewListCell

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
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 20)];
        self.nameLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.nameLabel];
        
        self.imageViewMore = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-10, 9, 8, 13)];
        self.imageViewMore.image = [UIImage imageNamed:@"img_special_more@2x.png"];
        [self.contentView addSubview:self.imageViewMore];
        
        self.moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-90, 8, 80, 15)];
        self.moreLabel.textAlignment = NSTextAlignmentRight;
        self.moreLabel.font = [UIFont systemFontOfSize:13];
        self.moreLabel.textColor = [BBSColor hexStringToColor:@"#9a9a9a"];
        self.moreLabel.text = @"查看更多";
        [self.contentView addSubview:self.moreLabel];
        
        self.firstImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 27, 100, 100)];
        [self.contentView addSubview:self.firstImageView];
        
        self.secondimageView = [[UIImageView alloc]initWithFrame:CGRectMake(110, 27, 100, 100)];
        [self.contentView addSubview:self.secondimageView];

        self.thirdImageView = [[UIImageView alloc]initWithFrame:CGRectMake(215, 27, 100, 100)];
        [self.contentView addSubview:self.thirdImageView];
        
        self.firstNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 130, 100, 15)];
        self.firstNameLabel.font = [UIFont systemFontOfSize:14];
       // [self.contentView addSubview:self.firstNameLabel];
        
        self.secondNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 130, 100, 15)];
        self.secondNameLabel.font = [UIFont systemFontOfSize:14];
       // [self.contentView addSubview:self.secondNameLabel];

        self.thirdNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(215, 130, 100, 15)];
        self.thirdNameLabel.font = [UIFont systemFontOfSize:14];
       // [self.contentView addSubview:self.thirdNameLabel];
        
        self.firstPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 130, 60, 15)];
        self.firstPriceLabel.font = [UIFont systemFontOfSize:15];
        self.firstPriceLabel.textColor = [BBSColor hexStringToColor:@"#fe6560"];
        [self.contentView addSubview:self.firstPriceLabel];
        
        self.firstOriginLabel = [[DeleLineBuy alloc]initWithFrame:CGRectMake(105-50, 130, 50, 14)];
        self.firstOriginLabel.font = [UIFont systemFontOfSize:12];
        self.firstOriginLabel.textAlignment = NSTextAlignmentRight;
        self.firstOriginLabel.textColor = [BBSColor hexStringToColor:@"#2a2a2a"];
       // self.firstOriginLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.firstOriginLabel];
        
        self.SPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(110, 130, 60, 15)];
        //self.SPriceLabel.backgroundColor = [UIColor redColor];
        self.SPriceLabel.font = [UIFont systemFontOfSize:15];
        self.SPriceLabel.textColor = [BBSColor hexStringToColor:@"#fe6560"];
        [self.contentView addSubview:self.SPriceLabel];
        
        self.SOriginLabel = [[DeleLineBuy alloc]initWithFrame:CGRectMake(210-50, 130, 50, 14)];
        self.SOriginLabel.font = [UIFont systemFontOfSize:12];
        self.SOriginLabel.textColor = [BBSColor hexStringToColor:@"#2a2a2a"];
        self.SOriginLabel.textAlignment = NSTextAlignmentRight;
        //self.SOriginLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.SOriginLabel];
        
        
        self.TPriceLabel = [[UILabel alloc]initWithFrame:CGRectMake(215, 130, 60, 15)];
        self.TPriceLabel.font = [UIFont systemFontOfSize:15];
        self.TPriceLabel.textColor = [BBSColor hexStringToColor:@"#fe6560"];
        [self.contentView addSubview:self.TPriceLabel];
        
        self.TOriginLabel = [[DeleLineBuy alloc]initWithFrame:CGRectMake(315-50, 130, 50, 14)];
        self.TOriginLabel.font = [UIFont systemFontOfSize:12];
        self.TOriginLabel.textColor = [BBSColor hexStringToColor:@"#2a2a2a"];
        self.TOriginLabel.textAlignment = NSTextAlignmentRight;
        //self.TOriginLabel.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:self.TOriginLabel];
        
        UILabel *grayBar = [[UILabel alloc]initWithFrame:CGRectMake(0, 169, SCREENWIDTH, 6)];
        grayBar.backgroundColor = [BBSColor hexStringToColor:@"#f4f4f4"];
        [self.contentView addSubview:grayBar];
        
        
    }
    return self;
}
@end
