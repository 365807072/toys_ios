//
//  PostBarNewWithOutImageCell.m
//  BabyShow
//
//  Created by Monica on 10/20/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarNewWithOutImageCell.h"

@implementation PostBarNewWithOutImageCell

{
    
    UIImageView *_reviewImageView;
    UIView *_seperateView;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect signViewFrame=CGRectMake(SCREENWIDTH-32, 0, 32, 32);
        CGRect titleLabelFrame=CGRectMake(6, 5, 308, 20);
        CGRect nameLabelFrame=CGRectMake(6, 30, 155, 20);
        CGRect timeLabelFrame=CGRectMake(254, 30, 60, 20);
        CGRect describeLabelFrame=CGRectMake(6, 50, 308, 43);
        CGRect praiseImageViewFrame=CGRectMake(214, 93, 20, 20);
        CGRect praiseCountLabelFrame=CGRectMake(234, 93, 30, 20);
        CGRect reviewImageViewFrame=CGRectMake(264, 93, 20, 20);
        CGRect reviewCountLabelFrame=CGRectMake(284, 93, 30, 20);
        CGRect seperateViewFrame=CGRectMake(10, 107.5, 300, 0.5);
        
        self.signImageView=[[UIImageView alloc]initWithFrame:signViewFrame];
        self.signImageView.image=[UIImage imageNamed:@"img_postbar_new_sign"];
        [self.contentView addSubview:self.signImageView];
        
        self.titleLabel=[[UILabel alloc]initWithFrame:titleLabelFrame];
        self.titleLabel.textColor=[BBSColor hexStringToColor:@"#212121"];
        self.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:15];
        self.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        self.titleLabel.numberOfLines=1;
        [self.contentView addSubview:self.titleLabel];
                
        self.userNameLabel=[[UILabel alloc]initWithFrame:nameLabelFrame];
        self.userNameLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.userNameLabel];
        
        self.timeLabel=[[UILabel alloc]initWithFrame:timeLabelFrame];
        self.timeLabel.font=[UIFont systemFontOfSize:10];
        self.timeLabel.textColor=[BBSColor hexStringToColor:@"#959595"];
        self.timeLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLabel];
        
        self.describeLabel=[[UILabel alloc]initWithFrame:describeLabelFrame];
        self.describeLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        self.describeLabel.numberOfLines=3;
        self.describeLabel.font=[UIFont systemFontOfSize:13];
        self.describeLabel.textColor=[BBSColor hexStringToColor:@"#747373"];
        [self.contentView addSubview:self.describeLabel];
        
        _praiseImageView=[[UIImageView alloc]initWithFrame:praiseImageViewFrame];
        _praiseImageView.image=[UIImage imageNamed:@"btn_worthbuy_praise"];
        [self.contentView addSubview:_praiseImageView];
        
        self.praiseCountLabel=[[UILabel alloc]initWithFrame:praiseCountLabelFrame];
        self.praiseCountLabel.textColor=[BBSColor hexStringToColor:@"#959595"];
        self.praiseCountLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.praiseCountLabel];
        
        _reviewImageView=[[UIImageView alloc]initWithFrame:reviewImageViewFrame];
        _reviewImageView.image=[UIImage imageNamed:@"btn_worthbuy_review"];
        [self.contentView addSubview:_reviewImageView];
        
        self.reviewCountLabel=[[UILabel alloc]initWithFrame:reviewCountLabelFrame];
        self.reviewCountLabel.textColor=[BBSColor hexStringToColor:@"#959595"];
        self.reviewCountLabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.reviewCountLabel];
        
        _seperateView=[[UIView alloc]initWithFrame:seperateViewFrame];
        _seperateView.backgroundColor=[UIColor lightGrayColor];
        [self.contentView addSubview:_seperateView];
        
    }
    return self;
}

-(void)resetFrameWithDescribeContent:(NSString *)content{
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[content boundingRectWithSize:CGSizeMake(308, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float height=size.height;
    
    float originY = 50;
    if (size.height>43) {
        
        height=43;
        originY = 44;
    }

    self.describeLabel.frame=CGRectMake(6, originY, 308, height);
    _praiseImageView.frame=CGRectMake(214, originY+height, 20, 20);
    self.praiseCountLabel.frame=CGRectMake(234, originY+height, 30, 20);
    _reviewImageView.frame=CGRectMake(264, originY+height, 20, 20);
    self.reviewCountLabel.frame=CGRectMake(284, originY+height, 30, 20);
    _seperateView.frame=CGRectMake(10, originY+height+24.5, 300, 0.5);
    
}

@end
