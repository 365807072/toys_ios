//
//  PBTopCell.m
//  BabyShow
//
//  Created by Lau on 6/5/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PBTopCell.h"

@implementation PBTopCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect seperateFrame=CGRectMake(5, 0, 310, 0.5);
        CGRect topViewFrame=CGRectMake(5, 15, 29, 20);
        CGRect titleFrame=CGRectMake(39, 5, 271, 40);
        
        self.seperateView=[[UIView alloc]initWithFrame:seperateFrame];
        self.seperateView.backgroundColor=[BBSColor hexStringToColor:@"e2e2e2"];
        [self.contentView addSubview:self.seperateView];
        
        self.topView=[[UIImageView alloc]initWithFrame:topViewFrame];
        self.topView.image=[UIImage imageNamed:@"img_postbar_top.png"];
        [self.contentView addSubview:self.topView];
    
        self.titleLabel=[[UILabel alloc]initWithFrame:titleFrame];
        self.titleLabel.textColor=[BBSColor hexStringToColor:@"#262626"];
        self.titleLabel.font=[UIFont systemFontOfSize:14];
        self.titleLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleLabel];
        
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
