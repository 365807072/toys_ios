//
//  WorthBuyCell.m
//  BabyShow
//
//  Created by Lau on 8/25/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "WorthBuyCell.h"

@implementation WorthBuyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect imgBtnFrame = CGRectMake(0, 0, 140, 140);
        CGRect logoImgVFrame = CGRectMake(0, 84.5, 60, 55.5);
        
        CGRect shopFrame = CGRectMake(143, 0, 90, 20);
        CGRect remainFrame = CGRectMake(233, 0, 87, 20);
        CGRect describeFrame = CGRectMake(143, 20, 177, 80);
        CGRect priceFrame   = CGRectMake(145, 105, 90, 20);
        CGRect originPriceFrame = CGRectMake(230, 105, 90, 20);
        CGRect latestStateFrame = CGRectMake(145, 124, 172, 15);
        CGRect seperateDownLineFrame = CGRectMake(10, 139.5, 320-20, 0.5);
        
        self.imgBtn = [BtnWithPhotos buttonWithType:UIButtonTypeCustom];
        self.imgBtn.frame = imgBtnFrame;
        [self.imgBtn setBackgroundColor:[BBSColor hexStringToColor:@"#d4d4d4"]];
        [self.imgBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.imgBtn];
        
        self.classLogoImgV = [[UIImageView alloc]initWithFrame:logoImgVFrame];
        self.classLogoImgV.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.classLogoImgV];
        
        self.shopLabel = [[UILabel alloc]initWithFrame:shopFrame];
        self.shopLabel.font = [UIFont systemFontOfSize:13];
        self.shopLabel.textColor = [BBSColor hexStringToColor:@"#797979"];
        [self.contentView addSubview:self.shopLabel];
        
        self.remainTimeLabel = [[UILabel alloc]initWithFrame:remainFrame];
        self.remainTimeLabel.font = [UIFont systemFontOfSize:12];
        self.remainTimeLabel.textAlignment = NSTextAlignmentRight;
        self.remainTimeLabel.textColor = [BBSColor hexStringToColor:@"#fe6560"];
        [self.contentView addSubview:self.remainTimeLabel];
        
        self.describeLabel = [[UILabel alloc]initWithFrame:describeFrame];
        self.describeLabel.font = [UIFont systemFontOfSize:14];
        self.describeLabel.textAlignment = NSTextAlignmentLeft;
        self.describeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.describeLabel.numberOfLines = 0;
        self.describeLabel.textColor = [BBSColor hexStringToColor:@"#000000"];
        [self.contentView addSubview:self.describeLabel];
        
        self.priceLabel = [[NIAttributedLabel alloc]initWithFrame:priceFrame];
        self.priceLabel.font = [UIFont boldSystemFontOfSize:15];
        self.priceLabel.textColor = [BBSColor hexStringToColor:@"#fe6560"];
        [self.contentView addSubview:self.priceLabel];
        
        self.originPriceLabel = [[DeleteLineLabel alloc]initWithFrame:originPriceFrame];
        self.originPriceLabel.font = [UIFont systemFontOfSize:12];
        self.originPriceLabel.textColor = [BBSColor hexStringToColor:@"#2a2a2a"];
        [self.contentView addSubview:self.originPriceLabel];
        
        self.latestStateLabel = [[UILabel alloc]initWithFrame:latestStateFrame];
        self.latestStateLabel.font = [UIFont systemFontOfSize:13];
        self.latestStateLabel.textColor = [BBSColor hexStringToColor:@"#7a7a7a"];
        [self.contentView addSubview:self.latestStateLabel];
        
        UIView *serperateDown=[[UIView alloc]initWithFrame:seperateDownLineFrame];
        serperateDown.backgroundColor=[BBSColor hexStringToColor:@"#d5d5d5"];
        [self.contentView addSubview:serperateDown];
        
    }
    return self;
}

-(void)btnOnClick:(UIButton *) btn{
    
    if (btn==self.imgBtn) {
        
        BtnWithPhotos *newBtn=(BtnWithPhotos *)btn;
        
        if ([self.delegate respondsToSelector:@selector(seeThePhotos:)]) {
            [self.delegate seeThePhotos:newBtn];
        }
        
    }
    
}

- (void)awakeFromNib
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
