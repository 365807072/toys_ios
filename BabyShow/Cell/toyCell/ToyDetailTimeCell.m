//
//  ToyDetailTimeCell.m
//  BabyShow
//
//  Created by WMY on 17/2/10.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyDetailTimeCell.h"

@implementation ToyDetailTimeCell

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
        
        self.toyDaysLabel = [[WMYLabel alloc]initWithFrame:CGRectMake(10,15, SCREENWIDTH-190, 20)];
        self.toyDaysLabel.font = [UIFont systemFontOfSize:13];
        self.toyDaysLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        [self.contentView addSubview:self.toyDaysLabel];
        
        self.delelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.delelBtn.frame = CGRectMake(SCREENWIDTH-180, 10, 80, 30);
        [self.contentView addSubview:self.delelBtn];
        
        self.moreLeaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.moreLeaseBtn.frame = CGRectMake(SCREENWIDTH-90,10, 80, 30);
        [self.contentView addSubview:self.moreLeaseBtn];
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 20)];
        lineView1.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [self.contentView addSubview:lineView1];
        
 
    }
    return self;
}

@end
