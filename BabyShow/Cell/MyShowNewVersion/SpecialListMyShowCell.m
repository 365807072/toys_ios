//
//  SpecialListMyShowCell.m
//  BabyShow
//
//  Created by WMY on 15/11/13.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "SpecialListMyShowCell.h"

@implementation SpecialListMyShowCell

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
        self.contentView.backgroundColor = [BBSColor hexStringToColor:@"e6e6e6"];
        
        self.imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8, SCREENWIDTH, 45)];
        self.imgBack.image = [UIImage imageNamed:@"img_myshow_back"];
        [self.contentView addSubview:self.imgBack];
        
        self.selectLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 3, 17)];
        self.selectLine.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
        [self.imgBack addSubview:self.selectLine];
        
        self.selectionName = [[UILabel alloc]initWithFrame:CGRectMake(7, self.selectLine.frame.origin.y, 140, 16)];
        [self.selectionName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];

        self.selectionName.textColor = [BBSColor hexStringToColor:@"ffffff"];
        self.selectionName.text = @"附近值得去";
        [self.imgBack addSubview:self.selectionName];
        
        self.subLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, self.selectionName.frame.origin.y+self.selectionName.frame.size.height+3, 200, 10)];
        [self.subLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10]];
        self.subLabel.textColor = [BBSColor hexStringToColor:@"ffffff"];
        self.subLabel.text = @"汇集最全的商业新消息较大的看见啊颠覆了";
        [self.imgBack addSubview:self.subLabel];
        
        
        _arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-19,18, 8, 14)];
        _arrowImg.image = [UIImage imageNamed:@"img_myshow_arrowmyshow"];
        [self.imgBack addSubview:_arrowImg];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,  self.imgBack.frame.origin.y+self.imgBack.frame.size.height, SCREENWIDTH, 216-self.imgBack.frame.origin.y-self.imgBack.frame.size.height+2)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];

        
        
        _storeImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(6,0,152.5, 152.5)];
        _storeImg1 .userInteractionEnabled = YES;
        _storeImg1 .image = [UIImage imageNamed:@"img_message_photo"];
        [backView addSubview:_storeImg1];
        
        _storeImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(161,_storeImg1.frame.origin.y,152.5, 152.5)];
        _storeImg2 .userInteractionEnabled = YES;
        _storeImg2 .image = [UIImage imageNamed:@"img_message_photo"];
        [backView addSubview:_storeImg2];

        
        _priceBackView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 123,152.5 , 30)];
         _priceBackView1.image = [UIImage imageNamed:@"img_myshownew_backview"];
        [_storeImg1 addSubview:_priceBackView1];
        _priceBackView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 123,152.5 , 30)];
        _priceBackView2.image = [UIImage imageNamed:@"img_myshownew_backview"];
        [_storeImg2 addSubview:_priceBackView2];

        
        
        _SpecialName1= [[UILabel alloc]initWithFrame:CGRectMake(0,7, _storeImg1.frame.size.width, 20)];
        _SpecialName1.font = [UIFont systemFontOfSize:15];
        _SpecialName1.textAlignment = NSTextAlignmentCenter;
        _SpecialName1.text = @"我是萌宝宝";
        _SpecialName1.textColor = [UIColor whiteColor];
        [_priceBackView1 addSubview:_SpecialName1];
        
        _SpecialName2= [[UILabel alloc]initWithFrame:CGRectMake(0,7, _storeImg1.frame.size.width, 20)];
        _SpecialName2.font = [UIFont systemFontOfSize:15];
        _SpecialName2.textAlignment = NSTextAlignmentCenter;
        _SpecialName2.text = @"我是萌宝宝";
        _SpecialName2.textColor = [UIColor whiteColor];
        [_priceBackView2 addSubview:_SpecialName2];

        
        _imgUpBack= [[UIImageView alloc]initWithFrame:CGRectMake(0, 216+2, SCREENWIDTH, 6)];
        _imgUpBack.image = [UIImage imageNamed:@"img_myshow_upback"];
        [self.contentView addSubview:_imgUpBack];
    }
    
    return self;
}

@end
