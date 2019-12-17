//
//  MyShowMessageCell.m
//  BabyShow
//
//  Created by Lau on 13-12-13.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyShowMessageCell.h"

@implementation MyShowMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIFont *font=[UIFont systemFontOfSize:15];
        
//        self.reviewImageView=[[UIImageView alloc]initWithFrame:CGRectMake(8, 0, 12, 10)];
//        UIImage *describeimg=[UIImage imageNamed:@"img_review.png"];
//        self.reviewImageView.image=describeimg;
//        [self.contentView addSubview:self.reviewImageView];
        
        self.reviewcontentLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
        [self.reviewcontentLabel setNumberOfLines:0];
        self.reviewcontentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.reviewcontentLabel.font=font;
        self.reviewcontentLabel.textColor=[BBSColor hexStringToColor:@"6e6550"];
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
