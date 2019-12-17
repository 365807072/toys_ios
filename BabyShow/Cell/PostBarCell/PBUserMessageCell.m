//
//  UserMessageCell.m
//  BabyShow
//
//  Created by Lau on 6/4/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PBUserMessageCell.h"

@implementation PBUserMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect avatarFrame=CGRectMake(5, 5, 30, 30);
        CGRect nameFrame=CGRectMake(40, 5, 165, 30);
        CGRect timeFrame=CGRectMake(205, 5, 100, 30);
        
        self.avatarBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.avatarBtn.frame=avatarFrame;
        self.avatarBtn.imageView.layer.masksToBounds = YES;
        self.avatarBtn.imageView.layer.cornerRadius = 15.0;
        
        [self.avatarBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.groundview addSubview:self.avatarBtn];
        
        self.nameLabel=[[UILabel alloc]initWithFrame:nameFrame];
        self.nameLabel.textColor=[BBSColor hexStringToColor:BACKCOLOR];
        self.nameLabel.font=[UIFont systemFontOfSize:15];
        [self.groundview addSubview:self.nameLabel];
        
        self.timeLabel=[[UILabel alloc]initWithFrame:timeFrame];
        self.timeLabel.textColor=[BBSColor hexStringToColor:@"#9c9c9c"];
        self.timeLabel.font=[UIFont systemFontOfSize:11];
        self.timeLabel.textAlignment=NSTextAlignmentRight;
        [self.groundview addSubview:self.timeLabel];
    
    }
    return self;
}

-(void)onClick:(UIButton *) avatar{
    
    if ([self.delegate respondsToSelector:@selector(clickOnTheAvatar:)]) {
        [self.delegate clickOnTheAvatar:avatar];
    }
    
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

@end
