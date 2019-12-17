//
//  MyOutPutTitleTodayCell.m
//  BabyShow
//
//  Created by Monica on 9/17/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyOutPutTitleTodayCell.h"

@implementation MyOutPutTitleTodayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect timeLabelFrame=CGRectMake(11, 6, 60, 30);
        CGRect imgViewFrame=CGRectMake(248, 0, 66, 29);
        
        self.timeLabel=[[UILabel alloc]initWithFrame:timeLabelFrame];
        self.timeLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:29];
        self.timeLabel.textColor=[BBSColor hexStringToColor:@"c6a37a"];
        [self.contentView addSubview:self.timeLabel];
        
        self.sourceImgView=[[UIImageView alloc]initWithFrame:imgViewFrame];
        [self.contentView addSubview:self.sourceImgView];
        
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
        
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
