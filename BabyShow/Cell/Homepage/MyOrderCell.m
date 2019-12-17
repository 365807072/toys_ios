//
//  MyOrderCell.m
//  BabyShow
//
//  Created by WMY on 15/9/16.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyOrderCell.h"

@implementation MyOrderCell

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
        
        self.imgStore = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 15.5, 14.5)];
        self.imgStore.image = [UIImage imageNamed:@"img_store_name"];
        [self.contentView addSubview:self.imgStore];
        
        self.buttonToStore = [UIButton buttonWithType:UIButtonTypeSystem];
        self.buttonToStore.frame = CGRectMake(35, 10, 200, 15);
        self.buttonToStore.titleLabel.font = [UIFont systemFontOfSize:13];
        self.buttonToStore.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.buttonToStore setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [self.contentView addSubview:self.buttonToStore];
        self.arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.arrowImg.image = [UIImage imageNamed:@"post_group_more_arrow"];
        [self.contentView addSubview:self.arrowImg];
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 33, SCREENWIDTH, 1)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.contentView addSubview:lineView];
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 66, SCREENWIDTH, 1)];
        lineView2.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.contentView addSubview:lineView2];
        //拨打电话按钮
        self.buttonPhoneNumber = [UIButton buttonWithType:UIButtonTypeSystem];
        self.buttonPhoneNumber.frame = CGRectMake(15, 10+33, 300, 15);
        self.buttonPhoneNumber.titleLabel.font = [UIFont systemFontOfSize:13];
        self.buttonPhoneNumber.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.buttonPhoneNumber setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.buttonPhoneNumber];
        self.arrayImgPhone = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.arrayImgPhone.image = [UIImage imageNamed:@"post_group_more_arrow"];
        [self.contentView addSubview:self.arrayImgPhone];
        
        self.labelTime = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH -10-95, 10, 100, 12)];
        self.labelTime.font = [UIFont systemFontOfSize:11];
        self.labelTime.textColor = [BBSColor hexStringToColor:@"666666"];
        //[self.contentView addSubview:self.labelTime];
        
        self.labelOrderNumber = [[UILabel alloc]initWithFrame:CGRectMake(15, 40+33, 65, 15)];
        self.labelOrderNumber.text = @"订单号：";
        self.labelOrderNumber.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.labelOrderNumber];
        
        self.labelOrderNUmbers = [[UILabel alloc]initWithFrame:CGRectMake(self.labelOrderNumber.frame.origin.x + self.labelOrderNumber.frame.size.width , self.labelOrderNumber.frame.origin.y, 150 , 12)];
        
        self.labelOrderNUmbers.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.labelOrderNUmbers];
        self.labelOrderState = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-15-40+5-30, self.labelOrderNumber.frame.origin.y, 40+30, 12)];
        self.labelOrderState.font = [UIFont systemFontOfSize:12];
        self.labelOrderState.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.labelOrderState];
        
        self.labelSureCode = [[UILabel alloc]initWithFrame:CGRectMake(self.labelOrderNumber.frame.origin.x, self.labelOrderNumber.frame.origin.y+10+self.labelOrderNumber.frame.size.height, 65, 15)];
        self.labelSureCode.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.labelSureCode];
        
        self.labelNumberCode = [[UILabel alloc]initWithFrame:CGRectMake(self.labelOrderNUmbers.frame.origin.x, self.labelSureCode.frame.origin.y-2, 75, 20)];
        self.labelNumberCode.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
        self.labelNumberCode.textAlignment = NSTextAlignmentCenter;
        self.labelNumberCode.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.labelNumberCode];
        
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
        
            
        UIView *grayView = [[UIView alloc]initWithFrame:CGRectMake(0, 95+33, SCREENWIDTH, 9)];
        grayView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [self.contentView addSubview:grayView];
        
        
        
        
        
        
        
        
        
    }
    return self;
}

@end
