//
//  PBDetailImgeCell.m
//  BabyShow
//
//  Created by Lau on 8/6/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PBDetailImgeCell.h"

@implementation PBDetailImgeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect frame=CGRectMake(5, 5, 205, 205);
        self.imgView=[[UIImageView alloc]initWithFrame:frame];
        [self.contentView addSubview:self.imgView];
        
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
