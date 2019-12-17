//
//  BasicCell.m
//  BabyShow
//
//  Created by Lau on 6/5/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PBBasicCell.h"


@implementation PBBasicCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect backGroundViewFrame=CGRectMake(5, 3, 310, self.contentView.frame.size.height);

        self.groundview=[[UIView alloc]initWithFrame:backGroundViewFrame];
        self.groundview.backgroundColor=[UIColor whiteColor];
        self.groundview.layer.borderWidth=0.5;
        self.groundview.layer.cornerRadius=3.0;
        self.groundview.layer.borderColor=[[BBSColor hexStringToColor:@"d2d2d2"] CGColor];
        [self.contentView addSubview:self.groundview];
        
        self.contentView.backgroundColor=[UIColor clearColor];
        self.backgroundColor=[UIColor clearColor];
        
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
