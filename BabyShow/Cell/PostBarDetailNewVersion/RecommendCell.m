//
//  RecommendCell.m
//  BabyShow
//
//  Created by WMY on 16/9/28.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "RecommendCell.h"

@implementation RecommendCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [BBSColor hexStringToColor:@"f8f8f8"];
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, SCREENWIDTH-20, 45)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteView];
        
        self.lineTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH-20, 1)];
        self.lineTopView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [whiteView addSubview:self.lineTopView];
        self.lineTopView.hidden = YES;
        
        self.lineBottomView = [[UIView alloc]initWithFrame:CGRectMake(0,44, SCREENWIDTH-20, 1)];
        self.lineBottomView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [whiteView addSubview:self.lineBottomView];
        self.lineBottomView.hidden = YES;
        
        UIView *leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 45)];
        leftView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [whiteView addSubview:leftView];
        
        UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH-19,0, 1, 45)];
        rightView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [whiteView addSubview:rightView];
        

        
        self.recommedTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, SCREENWIDTH-40, 25)];
        self.recommedTitleLabel.textAlignment = NSTextAlignmentLeft;
        self.recommedTitleLabel.textColor = [UIColor blackColor];
        self.recommedTitleLabel.font = [UIFont systemFontOfSize:14];
        [whiteView addSubview:self.recommedTitleLabel];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(10, 44, SCREENWIDTH-40, 1)];
        self.lineView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [whiteView addSubview:self.lineView];

        
    }
    return self;
}

@end
