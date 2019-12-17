//
//  PostBarDetailMoreReviewCell.m
//  BabyShow
//
//  Created by Monica on 10/23/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarDetailMoreReviewCell.h"

@implementation PostBarDetailMoreReviewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect moreReviewBtnFrame=CGRectMake(6, 0, SCREENWIDTH-12, 20);
        self.moreReviewBtn=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.moreReviewBtn.frame=moreReviewBtnFrame;
        self.moreReviewBtn.titleLabel.font=[UIFont systemFontOfSize:13];
        [self.moreReviewBtn setTitleColor:[BBSColor hexStringToColor:BACKCOLOR] forState:UIControlStateNormal];
        [self.moreReviewBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.moreReviewBtn];
    
    }
    
    return self;
    
}

-(void)OnClick:(btnWithIndexPath *) sender{
    
    if ([self.delegate respondsToSelector:@selector(moreReviews:)]) {
        [self.delegate moreReviews:sender];
    }
    
}

@end
