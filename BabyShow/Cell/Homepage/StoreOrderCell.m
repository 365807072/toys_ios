//
//  StoreOrderCell.m
//  BabyShow
//
//  Created by WMY on 15/9/16.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "StoreOrderCell.h"

@implementation StoreOrderCell

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
        
        
        self.labelOrderNumber = [[UILabel alloc]initWithFrame:CGRectMake(15, 13, 55, 15)];
        self.labelOrderNumber.text = @"订单号：";
        self.labelOrderNumber.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.labelOrderNumber];
        
        self.labelOrderNUmbers = [[UILabel alloc]initWithFrame:CGRectMake(self.labelOrderNumber.frame.origin.x + self.labelOrderNumber.frame.size.width , self.labelOrderNumber.frame.origin.y, 150 , 12)];
        self.labelOrderNUmbers.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.labelOrderNUmbers];
        
        
        self.labelSureCode = [[UILabel alloc]initWithFrame:CGRectMake(self.labelOrderNumber.frame.origin.x, self.labelOrderNumber.frame.origin.y+13+self.labelOrderNumber.frame.size.height, 75, 15)];
        self.labelSureCode.text = @"验证码：";
        self.labelSureCode.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.labelSureCode];
        
        self.btnSureCode = [UIButton buttonWithType:UIButtonTypeSystem];
        self.btnSureCode.frame =CGRectMake(self.labelOrderNUmbers.frame.origin.x, self.labelSureCode.frame.origin.y-2, 75, 20);
        self.btnSureCode.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
        [self.contentView addSubview:self.btnSureCode];
        
        self.imgPriceCombine = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-120, self.labelSureCode.frame.origin.y-2, 56.5, 20)];
        self.imgPriceCombine.image = [UIImage imageNamed:@"img_order_taocan"];
        [self.contentView addSubview:self.imgPriceCombine];
        
        self.labelPriceCombine = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.imgPriceCombine.frame.size.width, self.imgPriceCombine.frame.size.height)];
        self.labelPriceCombine.text = @"";
        self.labelPriceCombine.textColor = [UIColor whiteColor];
        self.labelPriceCombine.textAlignment = NSTextAlignmentCenter;
        self.labelPriceCombine.font = [UIFont systemFontOfSize:12];
        [self.imgPriceCombine addSubview:self.labelPriceCombine];
        
        self.labelPrice = [[UILabel alloc]initWithFrame:CGRectMake(self.imgPriceCombine.frame.origin.x+self.imgPriceCombine.frame.size.width+5, self.labelSureCode.frame.origin.y+2, 55, 12)];
        self.labelPrice.textColor = [BBSColor hexStringToColor:@"feac78"];
        self.labelPrice.font = [UIFont systemFontOfSize:13];
        self.labelPrice.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.labelPrice];
        self.labelOrderState = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-15-60+5, self.labelOrderNumber.frame.origin.y, 60, 12)];
        self.labelOrderState.textAlignment = NSTextAlignmentRight;
        self.labelOrderState.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.labelOrderState];

        
        UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 68, SCREENWIDTH, 9)];
        grayView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [self.contentView addSubview:grayView];
        
        
        
        
        
        
        
        
        
    }
    return self;
}


@end
