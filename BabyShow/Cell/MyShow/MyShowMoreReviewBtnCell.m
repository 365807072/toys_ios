//
//  MyShowMoreReviewBtnCell.m
//  BabyShow
//
//  Created by Lau on 13-12-13.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyShowMoreReviewBtnCell.h"

@implementation MyShowMoreReviewBtnCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIFont *font=[UIFont systemFontOfSize:14];
        self.reviewlistBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.reviewlistBtn.titleLabel.font=font;
        self.reviewlistBtn.frame=CGRectMake(38, 0, 280, 30);
        [self.reviewlistBtn setTitleColor:[BBSColor hexStringToColor:@"#AAAAAA"] forState:UIControlStateNormal];
        self.reviewlistBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
        [self.reviewlistBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.reviewlistBtn];
    }
    return self;
}

-(void)OnClick:(UIButton *) button{
    [self.delegate pressMoreReviewBtn:button];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
