//
//  StoreMoreListCell.m
//  BabyShow
//
//  Created by WMY on 15/9/2.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "StoreMoreListCell.h"

@implementation StoreMoreListCell

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
        
        self.imgBusinessPic = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 90, 90)];
        [self.contentView addSubview:self.imgBusinessPic];
        
        self.labelBusinessTitle = [[UILabel alloc]initWithFrame:CGRectMake(self.imgBusinessPic.frame.origin.x + 90+15, 15, 150, 16)];
        self.labelBusinessTitle.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.labelBusinessTitle];
        
        
        self.labelSubtitle = [[UILabel alloc]initWithFrame:CGRectMake(self.labelBusinessTitle.frame.origin.x, self.labelBusinessTitle.frame.origin.y+self.labelBusinessTitle.frame.size.height, 200, 35)];
        
        self.labelSubtitle.textColor = [BBSColor hexStringToColor:@"666666"];
        self.labelSubtitle.font = [UIFont systemFontOfSize:10];
    
        self.labelSubtitle.numberOfLines = 2;
        [self.contentView addSubview:self.labelSubtitle];
        
        self.labelPostCreatTime = [[UILabel alloc]initWithFrame:CGRectMake(self.labelBusinessTitle.frame.origin.x+150, self.labelBusinessTitle.frame.origin.y, 50, 16)];
        self.labelPostCreatTime.font = [UIFont systemFontOfSize:12];
        self.labelPostCreatTime.textAlignment = NSTextAlignmentRight;
        self.labelPostCreatTime.textColor = [BBSColor hexStringToColor:@"999999"];
        [self.contentView addSubview:self.labelPostCreatTime];
        
        self.labelPriceShow = [[UILabel alloc]initWithFrame:CGRectMake(self.labelSubtitle.frame.origin.x, self.labelSubtitle.frame.origin.y+self.labelSubtitle.frame.size.height+7, 60, 15)];
        self.labelPriceShow.font = [UIFont systemFontOfSize:14];
        self.labelPriceShow.text = @"秀秀价：";
        self.labelPriceShow.textColor = [BBSColor hexStringToColor:@"ff4242"];
        //[self.contentView addSubview:self.labelPriceShow];
        
        self.labelPriceShowNumber = [[UILabel alloc]initWithFrame:CGRectMake(self.labelSubtitle.frame.origin.x,self.labelSubtitle.frame.origin.y+self.labelSubtitle.frame.size.height+7,83, 15)];
        
        self.labelPriceShowNumber.textColor = [BBSColor hexStringToColor:@"ff4242"];
        self.labelPriceShowNumber.font = [UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.labelPriceShowNumber];
        
        
        self.labelDeletePrice = [[DeleteLineLabel alloc]initWithFrame:CGRectMake(self.labelPriceShowNumber.frame.origin.x+self.labelPriceShowNumber.frame.size.width-5, self.labelSubtitle.frame.origin.y+self.labelSubtitle.frame.size.height+9, 60, 12)];
                self.labelDeletePrice.textColor = [BBSColor hexStringToColor:@"999999"];
        self.labelDeletePrice.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:self.labelDeletePrice];
        
        self.buyPeopleCount = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-94, self.labelDeletePrice.frame.origin.y, 84, 15)];
        self.buyPeopleCount.textAlignment = NSTextAlignmentRight;
       
        self.buyPeopleCount.textColor = [BBSColor hexStringToColor:@"666666"];
        self.buyPeopleCount.font = [UIFont systemFontOfSize:10];
        [self.contentView addSubview:self.buyPeopleCount];
        
        UIImageView *gray = [[UIImageView alloc]initWithFrame:CGRectMake(0,99 , SCREENWIDTH, 1)];
        gray.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [self.contentView addSubview:gray];
        
        
        
    
        
            }
    return self;
}

@end
