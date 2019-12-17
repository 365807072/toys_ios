//
//  MyOutPutSingleImgCell.m
//  BabyShow
//
//  Created by Monica on 9/17/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyOutPutSingleImgCell.h"

@implementation MyOutPutSingleImgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect photoFrame=CGRectMake(0, 0, 200, 200);
        self.imgBtn=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.imgBtn.frame=photoFrame;
        [self.imgBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.imgBtn];
        
        self.backgroundColor =[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.01];
        self.contentView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.01];
        
    
    }
    return self;
}

-(void)OnClick:(btnWithIndexPath *) btn{
    if ([self.delegate respondsToSelector:@selector(SeeTheSingleImage:)]) {
        [self.delegate SeeTheSingleImage:btn];
    }
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
