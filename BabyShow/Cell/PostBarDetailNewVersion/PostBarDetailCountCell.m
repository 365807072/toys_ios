//
//  PostBarDetailCountCell.m
//  BabyShow
//
//  Created by Monica on 10/23/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarDetailCountCell.h"

@implementation PostBarDetailCountCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect praiseBtnFrame=CGRectMake(6, 2, 60, 26);
        CGRect reviewBtnFrame=CGRectMake(71, 2, 60, 26);
        CGRect moreBtnFrame=CGRectMake(SCREENWIDTH-6-60, 2, 60, 26);
        
        self.praiseBtn=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.praiseBtn.frame=praiseBtnFrame;
        [self.praiseBtn setBackgroundImage:[UIImage imageNamed:@"btn_unlike"] forState:UIControlStateNormal];
        [self.praiseBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.praiseBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        self.praiseBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [self.praiseBtn setTitleColor:KColorRGB(182, 182, 182, 1) forState:UIControlStateNormal];
        [self.contentView addSubview:self.praiseBtn];
        
        self.reviewBtn=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.reviewBtn.frame=reviewBtnFrame;
        [self.reviewBtn setBackgroundImage:[UIImage imageNamed:@"btn_review2"] forState:UIControlStateNormal];
        [self.reviewBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.reviewBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 0)];
        self.reviewBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [self.reviewBtn setTitleColor:KColorRGB(182, 182, 182, 1) forState:UIControlStateNormal];
        [self.contentView addSubview:self.reviewBtn];
        
        self.moreBtn=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.moreBtn.frame=moreBtnFrame;
        [self.moreBtn setBackgroundImage:[UIImage imageNamed:@"btn_myoutput_more"] forState:UIControlStateNormal];
        [self.moreBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.moreBtn];
        
        UIView *seperateView=[[UIView alloc]initWithFrame:CGRectMake(0, 29, SCREENWIDTH, 5)];
        UIImage *seperateImage=[UIImage imageNamed:@"img_myshow_line"];
        seperateView.backgroundColor=[UIColor colorWithPatternImage:seperateImage];
        [self.contentView addSubview:seperateView];

    
    }
    return self;
}

-(void)OnClick:(btnWithIndexPath *) sender{
    
    if (sender==self.praiseBtn) {

        if ([self.delegate respondsToSelector:@selector(praise:)]) {
            [self.delegate praise:sender];
        }
        
    }else if (sender==self.reviewBtn){
        
        if ([self.delegate respondsToSelector:@selector(review:)]) {
            [self.delegate review:sender];
        }
        
    }else if (sender==self.moreBtn){
        
        if ([self.delegate respondsToSelector:@selector(more:)]) {
            [self.delegate more:sender];
        }
        
    }
    
}

@end
