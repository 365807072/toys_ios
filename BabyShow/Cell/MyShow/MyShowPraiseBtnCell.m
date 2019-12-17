//
//  MyShowPraiseBtnCell.m
//  BabyShow
//
//  Created by Lau on 13-12-13.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyShowPraiseBtnCell.h"

@implementation MyShowPraiseBtnCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.praiseBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *praiseimg=[UIImage imageNamed:@"btn_praise.png"];
        [self.praiseBtn setBackgroundImage:praiseimg forState:UIControlStateNormal];
        self.praiseBtn.frame=CGRectMake(14, 0, 52, 24);
        [self.praiseBtn addTarget:self action:@selector(praiseBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.praiseBtn];
        
        self.reviewBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *reviewimg=[UIImage imageNamed:@"btn_review.png"];
        [self.reviewBtn setBackgroundImage:reviewimg forState:UIControlStateNormal];
        self.reviewBtn.frame=CGRectMake(75, 0, 52, 24);
        [self.reviewBtn addTarget:self action:@selector(reviewBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.reviewBtn];
        
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *shareImg = [UIImage imageNamed:@"btn_imageShare"];
        [self.shareBtn setBackgroundImage:shareImg forState:UIControlStateNormal];
        self.shareBtn.frame = CGRectMake(136, 0, 52, 24);
        [self.shareBtn addTarget:self action:@selector(shareBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        self.shareBtn.hidden = YES;
        [self.contentView addSubview:self.shareBtn];
        
        
        self.reportBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [self.reportBtn setBackgroundImage:[UIImage imageNamed:@"btn_myshow_report.png"] forState:UIControlStateNormal];
        self.reportBtn.frame=CGRectMake(268, 0, 47, 24);
        [self.reportBtn addTarget:self action:@selector(reportBtnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.reportBtn];
        
        UIView *seperateView=[[UIView alloc]initWithFrame:CGRectMake(0, 29, SCREENWIDTH, 5)];
        UIImage *seperateImage=[UIImage imageNamed:@"img_myshow_line"];
        seperateView.backgroundColor=[UIColor colorWithPatternImage:seperateImage];
        [self.contentView addSubview:seperateView];
    
    }
    return self;
}


-(void)praiseBtnOnClick:(UIButton *) button{
    if ([self.delegate respondsToSelector:@selector(pressPraiseBtn:)]) {
        [self.delegate pressPraiseBtn:button];
    }
}

-(void)reviewBtnOnClick:(UIButton *)button{

    if ([self.delegate respondsToSelector:@selector(pressReviewBtn:)]) {
        [self.delegate pressReviewBtn:button];

    }
}

-(void)shareBtnOnClick:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(pressShareBtn:)]) {
        [self.delegate pressShareBtn:button];
        
    }
 
}
-(void)reportBtnOnClick:(UIButton *)button{
    
    if ([self.delegate respondsToSelector:@selector(pressReportBtn:)]) {
        [self.delegate pressReportBtn:button];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
