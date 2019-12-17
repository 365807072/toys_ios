//
//  MessageCell.m
//  BabyShow
//
//  Created by Lau on 14-1-13.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect avatarFrame=CGRectMake(15, 15, 60, 60);
        CGRect nameFrame=CGRectMake(82, 13, 140, 30);
        CGRect messFrame=CGRectMake(82, 40, 180, 25);
        CGRect timeFrame=CGRectMake(82, 65, 70, 15);
        CGRect photoFrame=CGRectMake(SCREENWIDTH-90, 7, 75, 75);
        CGRect isReadViewFrame=CGRectMake(60, 14, 8, 8);
        
        UIFont *font=[UIFont systemFontOfSize:14];
        
        self.avatarView=[[UIImageView alloc]initWithFrame:avatarFrame];
        self.avatarView.layer.masksToBounds=YES;
        self.avatarView.layer.cornerRadius=30;
        [self.contentView addSubview:self.avatarView];
        
        self.avatarBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.avatarBtn.frame=avatarFrame;
        [self.avatarBtn addTarget:self action:@selector(avatarOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.avatarBtn];
        
        self.nameLabel=[[UILabel alloc]initWithFrame:nameFrame];
        self.nameLabel.text=@"name";
        self.nameLabel.font=font;
        [self.contentView addSubview:self.nameLabel];
        
        self.levelImageView = [[ClickImage alloc]initWithFrame:CGRectZero];
        self.levelImageView.backgroundColor = [UIColor clearColor];
        self.levelImageView.image = nil;
        self.levelImageView.canClick = YES;
        
        [self.contentView addSubview:self.levelImageView];

        
        self.messLabel=[[UILabel alloc]initWithFrame:messFrame];
        self.messLabel.text=@"mess";
        self.messLabel.font=font;
        [self.contentView addSubview:self.messLabel];
        
        self.timeLabel=[[UILabel alloc]initWithFrame:timeFrame];
        self.timeLabel.text=@"time";
        self.timeLabel.font=[UIFont systemFontOfSize:12];
        self.timeLabel.textColor=[BBSColor hexStringToColor:@"b7b7b7"];
        [self.contentView addSubview:self.timeLabel];
        
        self.photoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.photoBtn.frame=photoFrame;
        self.photoBtn.layer.masksToBounds = YES;
        self.photoBtn.layer.cornerRadius = 8;
        self.photoBtn.backgroundColor = [UIColor redColor];
        
        [self.photoBtn addTarget:self action:@selector(photoOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.photoBtn];
        
        self.isReadView=[[UIImageView alloc]initWithFrame:isReadViewFrame];
        self.isReadView.backgroundColor = [BBSColor hexStringToColor:@"ff6868"];
        self.isReadView.layer.cornerRadius = 4.5;
        self.isReadView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.isReadView];
        
        UIImageView *seperateView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 94, 320, 5)];
        seperateView.backgroundColor=[BBSColor hexStringToColor:@"f5f5f5"];
        [self.contentView addSubview:seperateView];
    }
    return self;
}

-(void)avatarOnClick:(UIButton *) btn{
    
    if ([self.delegate respondsToSelector:@selector(ClickOnAvatar:)]) {
        [self.delegate ClickOnAvatar:btn];
    }
    
}

-(void)photoOnClick:(UIButton *) btn{
    
    if ([self.delegate respondsToSelector:@selector(ClickOnPhoto:)]) {
        [self.delegate ClickOnPhoto:btn];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
