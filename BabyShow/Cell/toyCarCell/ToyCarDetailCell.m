//
//  ToyCarDetailCell.m
//  BabyShow
//
//  Created by WMY on 17/2/16.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyCarDetailCell.h"

@implementation ToyCarDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifie{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifie];
    if (self) {
        self.contentView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-16, 25)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        
        self.lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 25)];
        self.lineView2.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.backView addSubview:self.lineView2];
        
        self.lineView3 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-17, 0, 1, 25)];
        self.lineView3.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.backView addSubview:self.lineView3];
        
        self.toyVipImg = [[UIImageView alloc]initWithFrame:CGRectMake(6, 10, 23, 19)];
        self.toyVipImg.image = [UIImage imageNamed:@"vip_icon"];
        [self.backView addSubview:self.toyVipImg];

        self.toyName = [[UILabel alloc]initWithFrame:CGRectMake(6, 10, 3, 16)];
        self.toyName.font = [UIFont systemFontOfSize:12];
        self.toyName.textColor = [BBSColor hexStringToColor:@"666666"];
        self.toyName.numberOfLines = 0;
        [self.backView addSubview:self.toyName];
        
        
    }
    return self;
    
}

@end
