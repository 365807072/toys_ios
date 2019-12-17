//
//  MyOutPutUrlCell.m
//  BabyShow
//
//  Created by Monica on 9/17/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyOutPutUrlCell.h"

@implementation MyOutPutUrlCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect backGroundViewFrame=CGRectMake(14, 6, 292, 58);
        CGRect photoViewFrame=CGRectMake(17, 9, 57, 52);
        CGRect urlLabelFrame=CGRectMake(79, 9, 217, 52);
        
        self.backGroundBtn=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.backGroundBtn.frame=backGroundViewFrame;
        self.backGroundBtn.backgroundColor=[BBSColor hexStringToColor:@"#d9c1a5"];
        self.backGroundBtn.alpha=0.35;
        [self.backGroundBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.backGroundBtn];
        
        self.photoView=[[UIImageView alloc]initWithFrame:photoViewFrame];
        self.photoView.backgroundColor=[UIColor lightGrayColor];
        [self.contentView addSubview:self.photoView];
        
        self.titleLabel=[[UILabel alloc]initWithFrame:urlLabelFrame];
        self.titleLabel.textColor=[BBSColor hexStringToColor:@"#b08b61"];
        self.titleLabel.font=[UIFont systemFontOfSize:13];
        self.titleLabel.lineBreakMode=NSLineBreakByWordWrapping;
        self.titleLabel.numberOfLines=2;
        [self.contentView addSubview:self.titleLabel];
        
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
    
    }
    return self;
}

-(void)OnClick:(btnWithIndexPath *) btn{
    if ([self.delegate respondsToSelector:@selector(jumpToTheWebView:)]) {
        [self.delegate jumpToTheWebView:btn];
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
