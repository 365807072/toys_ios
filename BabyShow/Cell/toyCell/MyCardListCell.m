//
//  MyCardListCell.m
//  BabyShow
//
//  Created by 美美 on 2018/8/2.
//  Copyright © 2018年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyCardListCell.h"

@implementation MyCardListCell
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
        self.contentView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        self.cardImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, SCREENWIDTH-20, 90)];
        [self.contentView addSubview:self.cardImg];
        self.cardImg.contentMode =     UIViewContentModeScaleToFill;
        //self.cardImg.contentMode = UIViewContentModeTop;
        self.cardImg.layer.cornerRadius = 5.0;
        
        self.cardShadowImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.cardImg.frame.origin.x, self.cardImg.frame.origin.y, self.cardImg.frame.size.width, self.cardImg.frame.size.height)];
        self.cardShadowImg.backgroundColor = [BBSColor hexStringToColor:@"000000" alpha:0.5];
        [self.contentView addSubview:self.cardShadowImg];
        self.cardShadowImg.layer.cornerRadius = 5.0;
        
        self.toyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, SCREENWIDTH-70, 30)];
        self.toyNameLabel.textColor = [BBSColor hexStringToColor:@"ffffff"];
         [self.toyNameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:35]];
       // self.toyNameLabel.font = [UIFont systemFontOfSize:19];
        self.toyNameLabel.textAlignment = NSTextAlignmentLeft;
        [self.cardShadowImg addSubview:self.toyNameLabel];
        
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, SCREENWIDTH-70, 20)];
        self.priceLabel.textColor = [UIColor whiteColor];
        [self.priceLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        [self.cardShadowImg addSubview:self.priceLabel];
        
    }
    return self;
}


@end
