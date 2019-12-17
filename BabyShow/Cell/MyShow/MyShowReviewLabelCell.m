//
//  MyShowReviewLabelCell.m
//  BabyShow
//
//  Created by Lau on 13-12-13.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyShowReviewLabelCell.h"

@implementation MyShowReviewLabelCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIFont *font=[UIFont systemFontOfSize:14];
        
        self.reviewImageView=[[UIImageView alloc]initWithFrame:CGRectMake(14, 6, 12, 10)];
        UIImage *reviewimg=[UIImage imageNamed:@"img_review.png"];
        self.reviewImageView.image=reviewimg;
        [self.contentView addSubview:self.reviewImageView];
        
        self.reviewcontentLabel=[[NIAttributedLabel alloc]initWithFrame:CGRectMake(26, 0, 289, 0)];
        self.reviewcontentLabel.textColor=[BBSColor hexStringToColor:@"#555555"];
        self.reviewcontentLabel.font=font;
        self.reviewcontentLabel.numberOfLines = 0;
        self.reviewcontentLabel.verticalTextAlignment =NIVerticalTextAlignmentMiddle;
        self.reviewcontentLabel.autoDetectLinks = NO;
        [self.contentView addSubview:self.reviewcontentLabel];
    
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
