//
//  MyOutPutPraiseAndReviewCell.m
//  BabyShow
//
//  Created by Monica on 9/17/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyOutPutPraiseAndReviewCell.h"

@implementation MyOutPutPraiseAndReviewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect praiseFrame=CGRectMake(14, 7, 60, 26);
        CGRect reviewFrame=CGRectMake(79, 7, 60, 26);
        CGRect shareFrame = CGRectMake(145, 7, 25, 25);
        CGRect moreFrame=CGRectMake(260, 7, 60, 26);
        
        self.praiseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.praiseBtn.frame=praiseFrame;
        [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"btn_unlike"] forState:UIControlStateNormal];
        [self.praiseBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.praiseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        self.praiseBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [self.praiseBtn setTitleColor:KColorRGB(182, 182, 182, 1) forState:UIControlStateNormal];
        [self.contentView addSubview:self.praiseBtn];
        
        self.reviewBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.reviewBtn.frame=reviewFrame;
        [self.reviewBtn setBackgroundImage:[UIImage imageNamed:@"btn_review2"] forState:UIControlStateNormal];
        [self.reviewBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.reviewBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        self.reviewBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [self.reviewBtn setTitleColor:KColorRGB(182, 182, 182, 1) forState:UIControlStateNormal];
        [self.contentView addSubview:self.reviewBtn];
        
        self.typeView = [[UIImageView alloc]initWithFrame:CGRectMake(145, 14, 60, 15)];
        self.typeView.image = [UIImage imageNamed:@"img_myshow_friend"];
        self.typeView.hidden = YES;
        [self.contentView addSubview:self.typeView];
        
        
        self.shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareButton.frame = shareFrame;
        [self.shareButton setBackgroundImage:[UIImage imageNamed:@"btn_share"] forState:UIControlStateNormal];
        [self.shareButton addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.shareButton.hidden = YES;
        [self.contentView addSubview:self.shareButton];
        

        
        self.moreBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.moreBtn.frame=moreFrame;
        [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"btn_more2"] forState:UIControlStateNormal];
        [self.moreBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.moreBtn];
        
        self.seperateView =[[UIView alloc]initWithFrame:CGRectMake(0, 39, SCREENWIDTH, 5)];
        UIImage *seperateImage=[UIImage imageNamed:@"img_myshow_line"];
        _seperateView.backgroundColor=[UIColor colorWithPatternImage:seperateImage];
        
        [self.contentView addSubview:_seperateView];
        
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
    
    }
    return self;
}

-(void)OnClick:(UIButton *) btn{
    
    if (btn==self.praiseBtn) {
        if ([self.delegate respondsToSelector:@selector(praise:)]) {
            [self.delegate praise:btn];
        }
    }else if (btn==self.reviewBtn) {
        if ([self.delegate respondsToSelector:@selector(review:)]) {
            [self.delegate review:btn];
        }
    }else if (btn==self.moreBtn) {
        if ([self.delegate respondsToSelector:@selector(more:)]) {
            [self.delegate more:btn];
        }
    }else if (btn == self.shareButton){
        if ([self.delegate respondsToSelector:@selector(share:)]) {
           [self.delegate share:btn];
        }
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
