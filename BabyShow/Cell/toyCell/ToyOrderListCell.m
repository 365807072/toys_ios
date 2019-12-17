//
//  ToyOrderListCell.m
//  BabyShow
//
//  Created by WMY on 17/1/12.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyOrderListCell.h"

@implementation ToyOrderListCell

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
        self.photoView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 77, 77)];
        self.photoView.image = [UIImage imageNamed:@"img_message_photo"];
        [self.photoView setContentMode:UIViewContentModeScaleAspectFill];
        self.photoView.clipsToBounds = YES;
        [self.contentView addSubview:self.photoView];
        _smallToyMark = [[UIImageView alloc]initWithFrame:CGRectMake(77-17, 77-17,17, 17)];
        [self.photoView addSubview:_smallToyMark];
        self.toyNameLabel = [[WMYLabel alloc]initWithFrame:CGRectMake(self.photoView.frame.origin.x+self.photoView.frame.size.width+10, self.photoView.frame.origin.y, SCREENWIDTH-157, 20)];
        self.toyNameLabel.font = [UIFont systemFontOfSize:14];
        self.toyNameLabel.textColor = [BBSColor hexStringToColor:@"333333"];
        [self.contentView addSubview:self.toyNameLabel];
        self.toyNameLabel.numberOfLines = 3;
        [self.toyNameLabel setVerticalAlignment:VerticalAlignmentTop];
        
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-70, self.toyNameLabel.frame.origin.y, 60, 20)];
        self.priceLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        self.priceLabel.font = [UIFont systemFontOfSize:11];
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.priceLabel];
        
        self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.toyNameLabel.frame.origin.x,40, 170, 15)];
        self.userNameLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        self.userNameLabel.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:self.userNameLabel];
        
        self.delelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.delelBtn.frame = CGRectMake(SCREENWIDTH-120, 62, 50, 30);
        [self.contentView addSubview:self.delelBtn];
        
        self.moreLeaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.moreLeaseBtn.frame = CGRectMake(SCREENWIDTH-60, 62, 50, 30);
        [self.contentView addSubview:self.moreLeaseBtn];
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 97, SCREENWIDTH, 1)];
        lineView1.backgroundColor = [BBSColor hexStringToColor:@"e8e8e8"];
        [self.contentView addSubview:lineView1];
//
//        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 98, SCREENWIDTH, 5)];
//        lineView2.backgroundColor = [UIColor redColor];
//        [self.contentView addSubview:lineView2];
    }
    return self;
}
@end
