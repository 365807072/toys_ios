//
//  ToyAllListCell.m
//  BabyShow
//
//  Created by 美美 on 2018/2/1.
//  Copyright © 2018年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyAllListCell.h"

@implementation ToyAllListCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 1)];
        lineView1.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        //[self.contentView addSubview:lineView1];
        
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-1, 0, 1, 1.1*(SCREEN_WIDTH/2))];
        lineView2.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [self.contentView addSubview:lineView2];
        UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0,  1.1*(SCREEN_WIDTH/2)-1,SCREEN_WIDTH/2, 1)];
        lineView3.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [self.contentView addSubview:lineView3];


        self.picView = [[UIView alloc]initWithFrame:CGRectMake(0, 1, SCREEN_WIDTH/2-1, SCREEN_WIDTH/2*0.76)];
        self.picView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.picView];
        self.toyPicImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2-1, SCREEN_WIDTH/2*0.85)];
        self.toyPicImg.userInteractionEnabled = YES;
        self.toyPicImg.contentMode = UIViewContentModeScaleAspectFit;
        self.toyPicImg.clipsToBounds = YES;
        [self.picView addSubview:self.toyPicImg];
        
        self.toyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.picView.frame.size.height+5, SCREEN_WIDTH/2-16, 20)];
        self.toyNameLabel.textColor = RGBACOLOR(51, 51, 51, 1);
        self.toyNameLabel.textAlignment = NSTextAlignmentLeft;
        self.toyNameLabel.font = [UIFont systemFontOfSize:14];
        self.toyNameLabel.lineBreakMode = NSLineBreakByClipping;
        self.toyNameLabel.numberOfLines = 1;
        self.toyNameLabel.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.toyNameLabel];
        
        self.toyNameBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.toyNameBtn.frame = CGRectMake(10, self.picView.frame.size.height+5, SCREEN_WIDTH/2-18, 20);
        [self.toyNameBtn setTitleColor:RGBACOLOR(51, 51, 51, 1) forState:UIControlStateNormal];
        self.toyNameBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        self.toyNameBtn.titleLabel.lineBreakMode = NSLineBreakByClipping;
       // [self.contentView addSubview:self.toyNameBtn];
        
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, self.toyNameLabel.frame.origin.y+self.toyNameLabel.frame.size.height+7, 70, 17)];
        self.priceLabel.textColor = RGBACOLOR(253, 99, 99, 1);
        self.priceLabel.font = [UIFont systemFontOfSize:13];
        self.priceLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.priceLabel];
        
        self.markImg =  [[UIImageView alloc]initWithFrame:CGRectMake(62, self.priceLabel.frame.origin.y, 14, 14)];
        [self.contentView addSubview:self.markImg];
        
        self.ageLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, self.toyNameLabel.frame.origin.y+self.toyNameLabel.frame.size.height+8, 55, 15)];
        self.ageLabel.textColor = RGBACOLOR(102, 102,102, 1);
        self.ageLabel.font = [UIFont systemFontOfSize:10];
        self.ageLabel.textAlignment = NSTextAlignmentRight;
        //self.ageLabel.text = @"1-5岁";
        [self.contentView addSubview:self.ageLabel];
        

        
    }
    return self;
}

@end
