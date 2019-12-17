//
//  PostMyInterestV3Cell.m
//  BabyShow
//
//  Created by WMY on 15/8/18.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostMyInterestV3Cell.h"

@implementation PostMyInterestV3Cell

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
        self.labelSectionLine = [[UILabel alloc]initWithFrame:CGRectMake(10, 17, 3, 13)];
        self.labelSectionLine.backgroundColor = KColorRGB(252, 87, 89, 1);
        self.labelSectionName = [[UILabel alloc]initWithFrame:CGRectMake(18, 15, 85, 16)];
        self.labelSectionName.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:self.labelSectionName];
        [self.contentView addSubview: self.labelSectionLine];
        
        self.imgGroup1 = [[UIImageView alloc]initWithFrame:CGRectMake(10+0*(95+8), 50, 95, 95)];
        self.imgGroup1.tag = 4000;
        [self.contentView addSubview:self.imgGroup1];
        self.imgGroup2 = [[UIImageView alloc]initWithFrame:CGRectMake(10+1*(95+8), 50, 95, 95)];
        self.imgGroup2.tag = 4001;
        [self.contentView addSubview:self.imgGroup2];

        self.imgGroup3 = [[UIImageView alloc]initWithFrame:CGRectMake(10+2*(95+8), 50, 95, 95)];
        self.imgGroup3.tag = 4002;
        [self.contentView addSubview:self.imgGroup3];
        
        self.imgBackGroup1 = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 42, 23)];
        self.imgBackGroup1.alpha = 0.7;
        self.imgBackGroup1.image = [UIImage imageNamed:@"img_qun_Backgroup"];
        [self.imgGroup1 addSubview:self.imgBackGroup1];
        
        self.imgBackGroup2 = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 42, 23)];
        self.imgBackGroup2.alpha = 0.7;
        self.imgBackGroup2.image = [UIImage imageNamed:@"img_qun_Backgroup"];
        [self.imgGroup2 addSubview:self.imgBackGroup2];
        self.imgBackGroup3 = [[UIImageView alloc]initWithFrame:CGRectMake(7, 7, 42, 23)];
        self.imgBackGroup3.alpha = 0.7;
        self.imgBackGroup3.image = [UIImage imageNamed:@"img_qun_Backgroup"];
        [self.imgGroup3 addSubview:self.imgBackGroup3];
        
        self.labelGroup1 = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, 16, 14)];
        self.labelGroup1.textColor = [UIColor whiteColor];
        self.labelGroup1.font = [UIFont systemFontOfSize:14];
        self.labelGroup1.tag = 5000+0;
        [self.imgBackGroup1 addSubview:self.labelGroup1];
        
        self.labelGroup2 = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, 16, 14)];
        self.labelGroup2.textColor = [UIColor whiteColor];
        self.labelGroup2.font = [UIFont systemFontOfSize:14];
        self.labelGroup2.tag = 5000+1;
        [self.imgBackGroup2 addSubview:self.labelGroup2];
        self.labelGroup3 = [[UILabel alloc]initWithFrame:CGRectMake(12, 5, 16, 14)];
        self.labelGroup3.textColor = [UIColor whiteColor];
        self.labelGroup3.font = [UIFont systemFontOfSize:14];
        self.labelGroup3.tag = 5000+2;
        [self.imgBackGroup3 addSubview:self.labelGroup3];
        
        self.labelGroupName1 = [[WMYLabel alloc]initWithFrame:CGRectMake(self.imgGroup1.frame.origin.x, self.imgGroup1.frame.origin.y+100, 100, 32)];
        self.labelGroupName1.font = [UIFont systemFontOfSize:12];
        self.labelGroupName1.textAlignment = NSTextAlignmentLeft;
        [self.labelGroupName1 setVerticalAlignment:VerticalAlignmentTop];
        self.labelGroupName1.numberOfLines = 2;
        self.labelGroupName1.tag = 6000+0;
        self.labelGroupName1.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.labelGroupName1];
        self.labelGroupName2 = [[WMYLabel alloc]initWithFrame:CGRectMake(self.imgGroup2.frame.origin.x, self.imgGroup2.frame.origin.y+100, 100, 32)];
        self.labelGroupName2.font = [UIFont systemFontOfSize:12];
        self.labelGroupName2.textAlignment = NSTextAlignmentLeft;
        [self.labelGroupName2 setVerticalAlignment:VerticalAlignmentTop];
        self.labelGroupName2.numberOfLines = 2;
        self.labelGroupName2.tag = 6000+1;
        self.labelGroupName2.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.labelGroupName2];
        self.labelGroupName3 = [[WMYLabel alloc]initWithFrame:CGRectMake(self.imgGroup3.frame.origin.x, self.imgGroup3.frame.origin.y+100, 100, 32)];
        self.labelGroupName3.font = [UIFont systemFontOfSize:12];
        self.labelGroupName3.textAlignment = NSTextAlignmentLeft;
        [self.labelGroupName3 setVerticalAlignment:VerticalAlignmentTop];
        self.labelGroupName3.numberOfLines = 2;
        self.labelGroupName3.tag = 6000+2;
        self.labelGroupName3.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.labelGroupName3];
        self.imgFouce1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.labelGroupName1.frame.origin.x, self.labelGroupName1.frame.origin.y+32+5, 22, 22)];
        self.imgFouce1.image = [UIImage imageNamed:@"img_qun_fouce"];
        [self.contentView addSubview:self.imgFouce1];
        self.imgFouce2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.labelGroupName2.frame.origin.x, self.labelGroupName2.frame.origin.y+32+5, 22, 22)];
        self.imgFouce2.image = [UIImage imageNamed:@"img_qun_fouce"];
        [self.contentView addSubview:self.imgFouce2];
        self.imgFouce3 = [[UIImageView alloc]initWithFrame:CGRectMake(self.labelGroupName3.frame.origin.x, self.labelGroupName3.frame.origin.y+32+5, 22, 22)];
        self.imgFouce3.image = [UIImage imageNamed:@"img_qun_fouce"];
        [self.contentView addSubview:self.imgFouce3];
        
        self.labelFouceCount1 = [[UILabel alloc]initWithFrame:CGRectMake(self.imgFouce1.frame.origin.x+22+6,self.imgFouce1.frame.origin.y, 70, 20)];
        self.labelFouceCount1.textColor = [BBSColor hexStringToColor:@"666666"];
        self.labelFouceCount1.font = [UIFont systemFontOfSize:13];
        self.labelFouceCount1.tag = 7000+0;
        [self.contentView addSubview:self.labelFouceCount1];
        self.labelFouceCount2 = [[UILabel alloc]initWithFrame:CGRectMake(self.imgFouce2.frame.origin.x+22+6,self.imgFouce2.frame.origin.y, 70, 20)];
        self.labelFouceCount2.textColor = [BBSColor hexStringToColor:@"666666"];
        self.labelFouceCount2.font = [UIFont systemFontOfSize:13];
        self.labelFouceCount2.tag = 7000+1;
        [self.contentView addSubview:self.labelFouceCount2];
        self.labelFouceCount3 = [[UILabel alloc]initWithFrame:CGRectMake(self.imgFouce3.frame.origin.x+22+6,self.imgFouce3.frame.origin.y, 70, 20)];
        self.labelFouceCount3.textColor = [BBSColor hexStringToColor:@"666666"];
        self.labelFouceCount3.font = [UIFont systemFontOfSize:13];
        self.labelFouceCount3.tag = 7000+2;
        [self.contentView addSubview:self.labelFouceCount3];
        
        self.imgPart1 = [[UIImageView alloc]initWithFrame:CGRectMake(self.imgFouce1.frame.origin.x, self.imgFouce1.frame.origin.y+20+7, 22, 22)];
        self.imgPart1.image = [UIImage imageNamed:@"img_qun_part"];
        [self.contentView addSubview:self.imgPart1];
        self.imgPart2 = [[UIImageView alloc]initWithFrame:CGRectMake(self.imgFouce2.frame.origin.x, self.imgFouce2.frame.origin.y+20+7, 22, 22)];
        self.imgPart2.image = [UIImage imageNamed:@"img_qun_part"];
        [self.contentView addSubview:self.imgPart2];

        self.imgPart3 = [[UIImageView alloc]initWithFrame:CGRectMake(self.imgFouce3.frame.origin.x, self.imgFouce3.frame.origin.y+20+7, 22, 22)];
        self.imgPart3.image = [UIImage imageNamed:@"img_qun_part"];
        [self.contentView addSubview:self.imgPart3];
        
        self.labelPartCount1 = [[UILabel alloc]initWithFrame:CGRectMake(self.labelFouceCount1.frame.origin.x, self.imgPart1.frame.origin.y, 70, 20)];
        self.labelPartCount1.textColor = [BBSColor hexStringToColor:@"666666"];
        self.labelPartCount1.font = [UIFont systemFontOfSize:13];
        self.labelPartCount1.tag = 8000+0;
        [self.contentView addSubview:self.labelPartCount1];
        
        self.labelPartCount2 = [[UILabel alloc]initWithFrame:CGRectMake(self.labelFouceCount2.frame.origin.x, self.imgPart2.frame.origin.y, 70, 20)];
        self.labelPartCount2.textColor = [BBSColor hexStringToColor:@"666666"];
        self.labelPartCount2.font = [UIFont systemFontOfSize:13];
        self.labelPartCount2.tag = 8000+1;
        [self.contentView addSubview:self.labelPartCount2];

        self.labelPartCount3 = [[UILabel alloc]initWithFrame:CGRectMake(self.labelFouceCount3.frame.origin.x, self.imgPart3.frame.origin.y, 70, 20)];
        self.labelPartCount3.textColor = [BBSColor hexStringToColor:@"666666"];
        self.labelPartCount3.font = [UIFont systemFontOfSize:13];
        self.labelPartCount3.tag = 8000+2;
        [self.contentView addSubview:self.labelPartCount3];


        UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,252, SCREENWIDTH, 1)];
        lineLabel.backgroundColor = [BBSColor hexStringToColor:@"e6e6e6"];
        [self.contentView addSubview:lineLabel];
        
        self.buttonMoreGroup = [[UIButton alloc]initWithFrame:CGRectMake(SCREENWIDTH-60,15, 50, 16)];
        self.buttonMoreGroup.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.buttonMoreGroup.titleLabel.font = [ UIFont systemFontOfSize:15];
        [self.buttonMoreGroup setTitleColor:[BBSColor hexStringToColor:@"000000"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.buttonMoreGroup];
        UIImageView *arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.buttonMoreGroup.frame.origin.x+self.buttonMoreGroup.frame.size.width-8, self.buttonMoreGroup.frame.origin.y+2, 8, 12)];
        arrowImg.image = [UIImage imageNamed:@"img_store_arrow"];
        [self.contentView addSubview:arrowImg];
        
        
  
        
    }
    return self;
}
@end
