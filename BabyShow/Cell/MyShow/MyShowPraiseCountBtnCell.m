//
//  MyShowPraiseCountBtnCell.m
//  BabyShow
//
//  Created by Lau on 13-12-13.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyShowPraiseCountBtnCell.h"

@implementation MyShowPraiseCountBtnCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIFont *font=[UIFont systemFontOfSize:14];
        
        self.praiseImageView=[[UIImageView alloc]initWithFrame:CGRectMake(14, 10, 12, 10)];
        UIImage *praiseimg=[UIImage imageNamed:@"img_praise.png"];
        self.praiseImageView.image=praiseimg;
        [self.contentView addSubview:self.praiseImageView];
        
        self.praiseListBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.praiseListBtn.frame=CGRectMake(26, 0, 80, 30);
        [self.praiseListBtn setTitleColor:[BBSColor hexStringToColor:BACKCOLOR] forState:UIControlStateNormal];
        self.praiseListBtn.titleLabel.font=font;
        [self.praiseListBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.praiseListBtn];
        
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(233, 0, 30, 30)];
        self.titleLabel.font=font;
        self.titleLabel.text=@"仅限";
        self.titleLabel.textColor=[BBSColor hexStringToColor:@"cdb190"];
        [self.contentView addSubview:self.titleLabel];
        
        self.groupImgView=[[UIImageView alloc]initWithFrame:CGRectMake(263, 6, 52, 18)];
        [self.contentView addSubview:self.groupImgView];
        
    }
    return self;
}

-(void)OnClick:(UIButton *) button{
    if ([self.delegate respondsToSelector:@selector(pressPraiseCountBtn:)]) {
        [self.delegate pressPraiseCountBtn:button];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
