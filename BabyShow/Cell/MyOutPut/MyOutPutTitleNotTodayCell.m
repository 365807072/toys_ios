//
//  MyOutPutTitleNotTodayCell.m
//  BabyShow
//
//  Created by Monica on 9/17/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyOutPutTitleNotTodayCell.h"

@implementation MyOutPutTitleNotTodayCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect dayLabelFrame=CGRectMake(11, 2, 45, 38);
        CGRect monthLabelFrame=CGRectMake(56, 2, 60, 15);
        CGRect yearLabelFrame=CGRectMake(56, 21, 60, 15);
        CGRect imgViewFrame=CGRectMake(248, 0, 66, 29);

        self.dayLabel=[[UILabel alloc]initWithFrame:dayLabelFrame];
        self.dayLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:37];
        self.dayLabel.textColor=[BBSColor hexStringToColor:@"c6a37a"];
        [self.contentView addSubview:self.dayLabel];
        
        self.monthLabel=[[UILabel alloc]initWithFrame:monthLabelFrame];
        self.monthLabel.font=[UIFont systemFontOfSize:15];
        self.monthLabel.textColor=[BBSColor hexStringToColor:@"c6a37a"];
        [self.contentView addSubview:self.monthLabel];
        
        self.yearLabel=[[UILabel alloc]initWithFrame:yearLabelFrame];
        self.yearLabel.font=[UIFont systemFontOfSize:14];
        self.yearLabel.textColor=[BBSColor hexStringToColor:@"c6a37a"];
        [self.contentView addSubview:self.yearLabel];
        
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
