//
//  MessageListRequestCell.m
//  BabyShow
//
//  Created by 于 晓波 on 1/20/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MessageListRequestCell.h"

@implementation MessageListRequestCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect avatarFrame=CGRectMake(15, 15, 60, 60);
        CGRect nameFrame=CGRectMake(82, 13, 180, 30);
        CGRect messageFrame=CGRectMake(82, 40, 148, 25);
        CGRect btnFrame=CGRectMake(SCREENWIDTH-90, 27, 75, 30);
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
        self.nameLabel.font=font;
        [self.contentView addSubview:self.nameLabel];
        
        self.levelImageView = [[ClickImage alloc]initWithFrame:CGRectZero];
        self.levelImageView.backgroundColor = [UIColor clearColor];
        self.levelImageView.image = nil;
        self.levelImageView.canClick = YES;
        
        [self.contentView addSubview:self.levelImageView];
        
        self.messageLabel=[[UILabel alloc]initWithFrame:messageFrame];
        self.messageLabel.font=font;
        [self.contentView addSubview:self.messageLabel];
        
        self.Btn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.Btn.frame=btnFrame;
        [self.Btn.titleLabel setFont:font];
        [self.contentView addSubview:self.Btn];
        
        self.isReadView=[[UIImageView alloc]initWithFrame:isReadViewFrame];
        self.isReadView.image=[UIImage imageNamed:@"img_messlist_new_comming2.png"];
        [self.contentView addSubview:self.isReadView];
        
        UIImageView *seperateView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 94, 320, 5)];
        seperateView.backgroundColor=[BBSColor hexStringToColor:@"f5f5f5"];
        [self.contentView addSubview:seperateView];
    }
    return self;
}

-(void)avatarOnClick:(UIButton *)btn{
    
    if ([self.delegate respondsToSelector:@selector(MessageListRequestCellClickOnAvatar:)]) {
        [self.delegate MessageListRequestCellClickOnAvatar:btn];
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
