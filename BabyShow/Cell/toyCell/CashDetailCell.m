//
//  CashDetailCell.m
//  BabyShow
//
//  Created by WMY on 17/1/9.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "CashDetailCell.h"

@implementation CashDetailCell

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
        self.labelYear = [[UILabel alloc]initWithFrame:CGRectMake(10, 10,100,20)];
        self.labelYear.font = [UIFont systemFontOfSize:14];
        self.labelYear.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.labelYear];
        self.labelYear.textAlignment = NSTextAlignmentLeft;
        self.labelYear.text = @"2017";
        
        self.labelData = [[UILabel alloc]initWithFrame:CGRectMake(10, 40,100,20)];
        self.labelData.font = [UIFont systemFontOfSize:13];
        self.labelData.textColor = [BBSColor hexStringToColor:@"999999"];
        [self.contentView addSubview:self.labelData];
        self.labelData.textAlignment = NSTextAlignmentLeft;
        self.labelData.text = @"01-04";
        
        self.labelMoney = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-300, 10,290,20)];
        self.labelMoney.font = [UIFont systemFontOfSize:14];
        self.labelMoney.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.labelMoney];
        self.labelMoney.textAlignment = NSTextAlignmentRight;
        self.labelMoney.text = @"+2000.00";
        
        self.labelDetail = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-300, 40,290,20)];
        self.labelDetail.font = [UIFont systemFontOfSize:13];
        self.labelDetail.textColor = [BBSColor hexStringToColor:@"999999"];
        [self.contentView addSubview:self.labelDetail];
        self.labelDetail.textAlignment = NSTextAlignmentRight;
        self.labelDetail.text = @"玩具押金转入";
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 69, SCREENWIDTH, 1)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.contentView addSubview:lineView];
        
    }
    return self;
}

@end
