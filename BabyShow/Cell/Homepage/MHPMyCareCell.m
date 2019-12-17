//
//  MHPMyCareCell.m
//  BabyShow
//
//  Created by Lau on 14-1-2.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MHPMyCareCell.h"

@implementation MHPMyCareCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor=[BBSColor hexStringToColor:@"f3f3f3"];
        
        CGRect avatarFrame=CGRectMake(5, 11, 38, 38);
        CGRect nameFrame=CGRectMake(62, 15, 168, 30);
        CGRect btnFrame=CGRectMake(235, 16, 80, 28);
        UIFont *font=[UIFont systemFontOfSize:14];
        
        self.avatarView=[[UIImageView alloc]initWithFrame:avatarFrame];
        self.avatarView.layer.masksToBounds = YES;
        self.avatarView.layer.cornerRadius = 19;
        self.avatarView.image=[UIImage imageNamed:@"img_myshow_section_avatar.png"];
        [self.contentView addSubview:self.avatarView];
        
        self.avatarBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.avatarBtn.frame=avatarFrame;
        [self.avatarBtn addTarget:self action:@selector(avatarOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.avatarBtn];
        
        self.nameLabel=[[UILabel alloc]initWithFrame:nameFrame];
        self.nameLabel.text=@"name";
        self.nameLabel.font=font;
        self.nameLabel.textColor=[BBSColor hexStringToColor:@"000000"];
        self.nameLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.nameLabel];
        
        self.Btn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.Btn.frame=btnFrame;
        [self.Btn setTitle:@"已关注" forState:UIControlStateNormal];
        self.Btn.titleLabel.font=font;
        [self.Btn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.Btn setBackgroundColor:[BBSColor hexStringToColor:BACKCOLOR]];
        [self.contentView addSubview:self.Btn];
        
        UIImageView *seperateView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 59.5, 320, 0.5)];
        seperateView.backgroundColor=[BBSColor hexStringToColor:@"b7b7b7"];
        [self.contentView addSubview:seperateView];
    
    }
    return self;
}

-(void)OnClick:(UIButton *) btn{
    if ([self.delegate respondsToSelector:@selector(addToBeMyFocus:)]) {
        [self.delegate addToBeMyFocus:btn];
    }
}

-(void)avatarOnClick:(UIButton *) avatar{
    
    if ([self.delegate respondsToSelector:@selector(ClickOnTheAvatar:)]) {
        [self.delegate ClickOnTheAvatar:avatar];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
