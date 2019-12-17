//
//  RedBagListCell.m
//  BabyShow
//
//  Created by WMY on 15/12/8.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "RedBagListCell.h"

@implementation RedBagListCell

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
        self.backImg = [BaseImageView imgViewWithFrame:CGRectMake(9, 5, SCREENWIDTH-18, 102) backImg:[UIImage imageNamed:@"img_myhome_redbag"] userInterface:NO backgroupcolor:nil];
        [self.contentView addSubview:self.backImg];
        
        
       self.moneySymbolLabel = [BaseLabel makeFrame:CGRectMake(15, 36, 12, 23) font:22 textColor:@"fe5a4b" textAlignment:NSTextAlignmentLeft text:@"¥"];
        [self.backImg addSubview:self.moneySymbolLabel];
        
        self.moneyCountLabel = [BaseLabel makeFrame:CGRectMake(self.moneySymbolLabel.frame.origin.x+self.moneySymbolLabel.frame.size.width, 25, 80, 32) font:43 textColor:@"fe5a4b" textAlignment:NSTextAlignmentCenter text:@""];
        [self.backImg addSubview:self.moneyCountLabel];
        
        self.classifyLabel = [BaseLabel makeFrame:CGRectMake(self.moneyCountLabel.frame.origin.x+self.moneyCountLabel.frame.size.width+5, 23, 80, 16) font:14 textColor:@"333333" textAlignment:NSTextAlignmentLeft text:@"通用红包"];

        [self.backImg addSubview:self.classifyLabel];
        
        self.ruleLabel =[BaseLabel makeFrame:CGRectMake(self.moneyCountLabel.frame.origin.x+self.moneyCountLabel.frame.size.width+5, 43, 190, 16) font:11 textColor: @"333333" textAlignment:NSTextAlignmentLeft text:@"秀秀内商家下单使用，在线支付专享"];
        [self.backImg addSubview:self.ruleLabel];
        
        self.lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 73,SCREENWIDTH-18 , 1)];
        self.lineImg.backgroundColor = [BBSColor hexStringToColor:@"e1e1e1"];
        [self.backImg addSubview:self.lineImg];
        
        self.limitLabel = [BaseLabel makeFrame:CGRectMake(8, self.lineImg.frame.origin.y+1+7, 70, 13) font:11 textColor: @"999999" textAlignment:NSTextAlignmentLeft text:@""];
        [self.backImg addSubview:self.limitLabel];
        
        self.timeLabel = [BaseLabel makeFrame:CGRectMake(SCREENWIDTH-120-18, self.lineImg.frame.origin.y+1+7, 127, 13) font:11 textColor: @"999999" textAlignment:NSTextAlignmentLeft text:@""];
        [self.backImg addSubview:self.timeLabel];
    }
    return self;
}
-(void)setRedbagListItem:(RedBagListItem *)redbagListItem{
    if (self.redbagListItem == redbagListItem) {
        return;
    }
    _redbagListItem = redbagListItem;
    self.moneyCountLabel.text = [NSString stringWithFormat:@"%@",redbagListItem.packet_price];
    self.classifyLabel.text = redbagListItem.packet_type;
    self.ruleLabel.text = redbagListItem.packet_msg;
    self.limitLabel.text = redbagListItem.expiration;
    self.timeLabel.text = redbagListItem.ExpiryDate;
    
}
@end
