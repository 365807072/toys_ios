//
//  AddNewSortCell.m
//  BabyShow
//
//  Created by WMY on 16/9/21.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "AddNewSortCell.h"

@implementation AddNewSortCell

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
        self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 25, SCREENWIDTH, 15)];
        self.alertLabel.textAlignment = NSTextAlignmentCenter;
        self.alertLabel.text = @"每个群最多可以添加10个分类哦~";
        self.alertLabel.font = [UIFont systemFontOfSize:13];
        self.alertLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        [self.contentView addSubview:self.alertLabel];
        
        self.addNewSortBtn = [YLButton buttonWithFrame:CGRectMake(15, 50, SCREENWIDTH-30, 38) type:UIButtonTypeCustom backImage:[UIImage imageNamed:@"post_addSort_btn"] target:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.addNewSortBtn];
    }
    return self;
}

@end
