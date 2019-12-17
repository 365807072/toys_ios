//
//  PostGroupSpecialCell.m
//  BabyShow
//
//  Created by WMY on 15/12/24.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostGroupSpecialCell.h"

@implementation PostGroupSpecialCell

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
        _imgType = [BaseImageView imgViewWithFrame:CGRectMake(13, 11, 14, 14.5) backImg:[UIImage imageNamed:@"img_postbar_gonggao"] userInterface:NO backgroupcolor:nil];
        [self.contentView addSubview:_imgType];
        
        _labelGongGao = [BaseLabel makeFrame:CGRectMake(30, 10, 40, 18) font:16 textColor:@"779dfe" textAlignment:NSTextAlignmentLeft text:@"公告:"];
        [self.contentView addSubview:_labelGongGao];
        
        _labelName = [BaseLabel makeFrame:CGRectMake(78, 10, 210, 18) font:16 textColor:@"333333" textAlignment:NSTextAlignmentLeft text:@"重要通告大家注意"];
        [self.contentView addSubview:_labelName];
        
        
        _imgArrow = [BaseImageView imgViewWithFrame:CGRectMake(SCREENWIDTH-23, 9, 11, 20) backImg:[UIImage imageNamed:@"img_postbar_grouparrow"] userInterface:YES backgroupcolor:nil];
        [self.contentView addSubview:_imgArrow];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 38, SCREENWIDTH, 1)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"#f4f4f4"];
        [self.contentView addSubview:lineView];
        
        
        
    }
    return self;
}

@end
