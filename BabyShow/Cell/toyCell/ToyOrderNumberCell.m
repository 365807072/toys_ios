//
//  ToyOrderNumberCell.m
//  BabyShow
//
//  Created by WMY on 17/2/10.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyOrderNumberCell.h"

@implementation ToyOrderNumberCell

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
        self.toyNumberLabel = [[WMYLabel alloc]initWithFrame:CGRectMake(10, 10, 300, 18)];
        self.toyNumberLabel.font = [UIFont systemFontOfSize:13];
        self.toyNumberLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        [self.contentView addSubview:self.toyNumberLabel];
        
        self.vipBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.vipBtn.frame = CGRectMake(190, 10, 23, 19);
        [self.vipBtn setImage:[UIImage imageNamed:@"vip_icon"] forState:UIControlStateNormal];
        //[self.contentView addSubview:self.vipBtn];
        
        
        
        
    }
    return self;
}
@end
