//
//  MoreBtnCell.m
//  BabyShow
//
//  Created by Lau on 13-12-23.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MoreBtnCell.h"

@implementation MoreBtnCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.btn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.btn.frame=CGRectMake(0, 0, 320, 44);
        [self addSubview:self.btn];
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
