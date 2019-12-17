//
//  ToyCarHeadCell.m
//  BabyShow
//
//  Created by WMY on 17/2/16.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyCarHeadCell.h"

@implementation ToyCarHeadCell

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
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 36)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        
        self.selectLine = [[UILabel alloc]initWithFrame:CGRectMake(6, 10, 3, 16)];
        self.selectLine.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
        [self.backView addSubview:self.selectLine];
        
        self.selectionName = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 300, 16)];
        self.selectionName.textColor = [BBSColor hexStringToColor:@"666666"];
        self.selectionName.font = [UIFont systemFontOfSize:13];
        self.selectionName.numberOfLines = 0;
        [self.backView addSubview:self.selectionName];
//        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 36, SCREENWIDTH, 1)];
//        self.lineView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
//        [self.backView addSubview:self.lineView];
        
        
    }
    return self;

}
@end
