//
//  PraiseListCell.m
//  BabyShow
//
//  Created by Lau on 13-12-18.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PraiseListCell.h"

@implementation PraiseListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect avatarFrame=CGRectMake(5, 13, 33, 33);
        CGRect nameFrame=CGRectMake(40, 20, 200, 20);
        CGRect timeFrame=CGRectMake(240, 20, 65, 20);
        UIFont *font=[UIFont systemFontOfSize:14];
        
        self.avatarImageView=[[UIImageView alloc]initWithFrame:avatarFrame];
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarImageView.layer.cornerRadius = 16.5;
        [self.contentView addSubview:self.avatarImageView];
  
        self.nameLabel=[[UILabel alloc]initWithFrame:nameFrame];
        self.nameLabel.textColor=[BBSColor hexStringToColor:BACKCOLOR];
        self.nameLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
        [self.contentView addSubview:self.nameLabel];
        
        self.timeLabel=[[UILabel alloc]initWithFrame:timeFrame];
        self.timeLabel.textAlignment=NSTextAlignmentRight;
        self.timeLabel.font=font;
        [self.contentView addSubview:self.timeLabel];
        
        UIImageView *seperateView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 59.5, 320, 0.5)];
        seperateView.backgroundColor=[BBSColor hexStringToColor:@"b7b7b7"];
        [self.contentView addSubview:seperateView];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
