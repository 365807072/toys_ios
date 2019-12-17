//
//  MyShowNewDescribeCell.m
//  BabyShow
//
//  Created by Monica on 15-1-19.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyShowNewDescribeCell.h"

@implementation MyShowNewDescribeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect describeLabelFrame=CGRectMake(14, 3, 292, 42);
        self.describeLabel=[[ClickDescLabel alloc]initWithFrame:describeLabelFrame];
        self.describeLabel.font=[UIFont systemFontOfSize:16];
        self.describeLabel.textColor=[BBSColor hexStringToColor:@"6e6550"];
        self.describeLabel.numberOfLines=0;
        //self.describeLabel.lineBreakMode=NSLineBreakByCharWrapping;
        [self.contentView addSubview:self.describeLabel];
        
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
    
        
        
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

@end
