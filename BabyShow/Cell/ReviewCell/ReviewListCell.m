//
//  ReviewListCell.m
//  BabyShow
//
//  Created by Lau on 13-12-18.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ReviewListCell.h"

@implementation ReviewListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect avatarFrame=CGRectMake(5, 13, 33, 33);
        CGRect nameFrame=CGRectMake(40, 10, 170, 20);
        CGRect timeFrame=CGRectMake(235, 10, 80, 20);
        CGRect contentFrame=CGRectMake(40, 30, 270, 50);
        UIFont *font=[UIFont systemFontOfSize:14];
        
        self.avatarImageView=[[UIImageView alloc]initWithFrame:avatarFrame];
        self.avatarImageView.layer.masksToBounds = YES;
        self.avatarImageView.layer.cornerRadius = 16.5;
        [self.contentView addSubview:self.avatarImageView];
        
        self.avatarBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.avatarBtn.frame = avatarFrame;
        [self.avatarBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.avatarBtn];
        
        self.nameLabel=[[UILabel alloc]initWithFrame:nameFrame];
        self.nameLabel.textColor=[BBSColor hexStringToColor:BACKCOLOR];
        self.nameLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:14];
        [self.contentView addSubview:self.nameLabel];
        
        self.timeLabel=[[UILabel alloc]initWithFrame:timeFrame];
        self.timeLabel.font=font;
        self.timeLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLabel];
        
        self.contentLabel=[[NIAttributedLabel alloc]initWithFrame:contentFrame];
        self.contentLabel.font=font;
        self.contentLabel.verticalTextAlignment = NIVerticalTextAlignmentMiddle;
        self.contentLabel.lineBreakMode=NSLineBreakByWordWrapping;
        self.contentLabel.numberOfLines=0;
        self.contentLabel.backgroundColor =[UIColor clearColor];
        self.contentLabel.autoDetectLinks = NO;
        [self.contentView addSubview:self.contentLabel];
        
        self.seperateView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 59.5, 320, 0.5)];
        self.seperateView.backgroundColor=[BBSColor hexStringToColor:@"b7b7b7"];
        [self.contentView addSubview:self.seperateView];
        
        self.btn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame=nameFrame;
        [self.contentView addSubview:self.btn];
        
        self.longPress=[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        self.longPress.minimumPressDuration=1;
        [self addGestureRecognizer:self.longPress];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)btnOnClick:(UIButton *) btn{
    
    if ([self.delegate respondsToSelector:@selector(avatarOnClick:)]){
        [self.delegate avatarOnClick:btn];
    }
    
}

-(void)longPress:(UITableViewCell *)cell{
    
    if (self.longPress.state==UIGestureRecognizerStateBegan) {
    
        if ([self.delegate respondsToSelector:@selector(cellOnLongPress:)]) {
            
            [self.delegate cellOnLongPress:self];
            
        }
    }
    
}

@end
