//
//  PraiseAndReviewCell.m
//  BabyShow
//
//  Created by Lau on 6/4/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PBPraiseAndReviewCell.h"

@implementation PBPraiseAndReviewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect praiseImgFrame=CGRectMake(196, 10, 20, 20);
        CGRect reviewImgFrame=CGRectMake(253, 10, 20, 20);
        
        CGRect praiseLabelFrame=CGRectMake(216, 10, 37, 20);
        CGRect reviewLabelFrame=CGRectMake(273, 10, 37, 20);
        
        self.praiseImgView=[[UIImageView alloc]initWithFrame:praiseImgFrame];
        self.praiseImgView.image=[UIImage imageNamed:@"img_postbar_praise"];
        [self.groundview addSubview:self.praiseImgView];
        
        self.reviewImgView=[[UIImageView alloc]initWithFrame:reviewImgFrame];
        self.reviewImgView.image=[UIImage imageNamed:@"img_postbar_review"];
        [self.groundview addSubview:self.reviewImgView];
        
        self.praiseLabel=[[UILabel alloc]initWithFrame:praiseLabelFrame];
        self.praiseLabel.font=[UIFont systemFontOfSize:14];
        self.praiseLabel.textColor=[UIColor lightGrayColor];
        [self.groundview addSubview:self.praiseLabel];
        
        self.reviewLabel=[[UILabel alloc]initWithFrame:reviewLabelFrame];
        self.reviewLabel.font=[UIFont systemFontOfSize:14];
        self.reviewLabel.textColor=[UIColor lightGrayColor];
        [self.groundview addSubview:self.reviewLabel];
        
        
    }
    return self;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
