//
//  MyHomePageCell.m
//  BabyShow
//
//  Created by 于 晓波 on 1/4/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyHomePageCell.h"

@implementation MyHomePageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect signFrame=CGRectMake(12, 14, 32, 32);
        CGRect titleFrame=CGRectMake(51, 18, 142, 24);
        CGRect countFrame=CGRectMake(200, 18, 80, 24);
        CGRect messFrame=CGRectMake(265, 24, 25, 11);
//        CGRect arrowFrame=CGRectMake(300, 13, 10, 33);
        UIFont *font=[UIFont systemFontOfSize:14];
        
        self.signImgView=[[UIImageView alloc]initWithFrame:signFrame];
        [self.contentView addSubview:self.signImgView];
        
        self.titleLabel=[[UILabel alloc]initWithFrame:titleFrame];
        self.titleLabel.font=font;
        [self.contentView addSubview:self.titleLabel];
        
        self.countLabel=[[UILabel alloc]initWithFrame:countFrame];
        self.countLabel.font=font;
        self.countLabel.textAlignment=NSTextAlignmentRight;
        self.countLabel.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:self.countLabel];
        
        self.messView=[[UIImageView alloc]initWithFrame:messFrame];
        self.messView.image=[UIImage imageNamed:@"img_myhomepage_news_notice.png"];
        [self.contentView addSubview:self.messView];
        
        UIImageView *seperateView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 59.5, 320, 0.5)];
        seperateView.backgroundColor=[BBSColor hexStringToColor:@"b7b7b7"];
        [self.contentView addSubview:seperateView];
    
        self.anouceLabel=[[UILabel alloc]initWithFrame:CGRectMake(43, 45, 320, 15)];
        self.anouceLabel.text=@"Ta还没有关注你，不能看TA的相册哦";
        self.anouceLabel.font=[UIFont systemFontOfSize:10];
        self.anouceLabel.textColor=[UIColor lightGrayColor];
        [self.contentView addSubview:self.anouceLabel];
    
         
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
