//
//  LineViewCell.m
//  BabyShow
//
//  Created by WMY on 17/2/17.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "LineViewCell.h"

@implementation LineViewCell

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
        self.lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
        self.lineView1.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.contentView addSubview:self.lineView1];
        

        
    }
    return self;
    
}

@end
