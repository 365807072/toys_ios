//
//  CombineShareCell.m
//  BabyShow
//
//  Created by Monica on 15-4-2.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "CombineShareCell.h"

@implementation CombineShareCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect iconFrame = CGRectMake(10, 10, 47, 47);
        CGRect babyFrame = CGRectMake(67, 14.5, SCREENWIDTH - 61-60, 17);
        CGRect userFrame = CGRectMake(67, 35, SCREENWIDTH - 61-60, 17);
        CGRect combineFrame = CGRectMake(SCREENWIDTH - 63, 19.5, 50, 25);
        CGRect seperatorFrame = CGRectMake(0, 67-0.5, SCREENWIDTH, 0.5);
        
        _iconImageV = [[UIImageView alloc] initWithFrame:iconFrame];
        _iconImageV.layer.cornerRadius = 23.5;
        _iconImageV.layer.masksToBounds = YES;
        _iconImageV.userInteractionEnabled = YES;
        [self.contentView addSubview:_iconImageV];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickAvatar:)];
        [_iconImageV addGestureRecognizer:tapGes];
        
        _babyNameLabel = [[UILabel alloc] initWithFrame:babyFrame];
        _babyNameLabel.backgroundColor = [UIColor clearColor];
        _babyNameLabel.font = [UIFont systemFontOfSize:16];
        _babyNameLabel.textColor = [BBSColor hexStringToColor:@"483d3d"];
        [self.contentView addSubview:_babyNameLabel];
        
        _userNameLabel = [[UILabel alloc] initWithFrame:userFrame];
        _userNameLabel.backgroundColor = [UIColor clearColor];
        _userNameLabel.font = [UIFont systemFontOfSize:15];
        _userNameLabel.textColor = [BBSColor hexStringToColor:@"beb9b5"];
        [self.contentView addSubview:_userNameLabel];
        
        _combineBtn = [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        _combineBtn.frame = combineFrame;
        _combineBtn.backgroundColor = [BBSColor hexStringToColor:@"ff8585"];
        _combineBtn.layer.cornerRadius = 5.0;
        _combineBtn.layer.masksToBounds = YES;
        [_combineBtn setTitle:@"同步" forState:UIControlStateNormal];
        _combineBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_combineBtn addTarget:self action:@selector(clickCombine:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_combineBtn];
        
        UIView *seperatorLine = [[UIView alloc] initWithFrame:seperatorFrame];
        seperatorLine.backgroundColor = [BBSColor hexStringToColor:@"cfcfcf"];
        [self.contentView addSubview:seperatorLine];
        
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)clickAvatar:(UITapGestureRecognizer *)tapGes {
    UIImageView *imageV = (UIImageView *)tapGes.view;
    if ([self.delegate respondsToSelector:@selector(clickTheAvatar:)]) {
        [self.delegate clickTheAvatar:imageV];
    }
}
- (void)clickCombine:(UIButton *)btn {
    if ([self.delegate respondsToSelector:@selector(combineUsers:)]) {
        [self.delegate combineUsers:btn];
    }
}
@end
