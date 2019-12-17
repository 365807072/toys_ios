//
//  SureOrCancleCell.m
//  BabyShow
//
//  Created by WMY on 16/9/24.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "SureOrCancleCell.h"

@implementation SureOrCancleCell

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
                self.sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.sureBtn.frame = CGRectMake(0, 0, 129, 50);
                [self.sureBtn setTitle:@"确定" forState:UIControlStateNormal];
                [self.sureBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
                [self.sureBtn setTitleColor:[BBSColor hexStringToColor:@"fd6363"] forState:UIControlStateNormal];
                [self.contentView addSubview:self.sureBtn];
        
               UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(130, 12, 0.5, 26)];
                lineView4.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
                [self.contentView addSubview:lineView4];
                self.cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                self.cancleBtn.frame = CGRectMake(131, 0, 129, 50);
                [self.cancleBtn setTitle:@"取消" forState:UIControlStateNormal];

                [self.cancleBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
                [self.cancleBtn setTitleColor:[BBSColor hexStringToColor:@"999999"] forState:UIControlStateNormal];
                [self.contentView addSubview:self.cancleBtn];
        
        
    }
    return self;
}

@end
