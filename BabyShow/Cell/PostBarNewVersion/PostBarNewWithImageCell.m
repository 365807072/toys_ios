//
//  PostBarNewWithImageCell.m
//  BabyShow
//
//  Created by Monica on 10/20/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarNewWithImageCell.h"

@implementation PostBarNewWithImageCell

{
    
    UIImageView *_reviewImageView;
    UIView *_seperateView;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //CELL的高度是133
        
        CGRect signViewFrame=CGRectMake(SCREENWIDTH-32, 0, 32, 32);
        CGRect titleLabelFrame=CGRectMake(6, 5, 308, 20);
        CGRect photoViewFrame=CGRectMake(6, 30, 88, 88);
        CGRect nameLabelFrame=CGRectMake(99, 30, 155, 20);
        CGRect timeLabelFrame=CGRectMake(254, 30, 60, 20);
        CGRect describeLabelFrame=CGRectMake(99, 50, 215, 0);
        CGRect praiseImageViewFrame=CGRectMake(214, 108, 20, 20);
        CGRect praiseCountLabelFrame=CGRectMake(234, 108, 30, 20);
        CGRect reviewImageViewFrame=CGRectMake(264, 108, 20, 20);
        CGRect reviewCountLabelFrame=CGRectMake(284, 108, 30, 20);
        CGRect seperateViewFrame=CGRectMake(10, 132.5, 300, 0.5);
        
        self.signImageView=[[UIImageView alloc]initWithFrame:signViewFrame];
        self.signImageView.image=[UIImage imageNamed:@"img_postbar_new_sign"];
        [self.contentView addSubview:self.signImageView];
        
        self.titleLabel=[[UILabel alloc]initWithFrame:titleLabelFrame];
        self.titleLabel.textColor=[BBSColor hexStringToColor:@"#212121"];
        self.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:15];
        self.titleLabel.lineBreakMode=NSLineBreakByTruncatingTail;
        self.titleLabel.numberOfLines=1;
        [self.contentView addSubview:self.titleLabel];
        
        self.photoView=[[UIImageView alloc]initWithFrame:photoViewFrame];
        [self.contentView addSubview:self.photoView];
        
        self.videoView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20,40, 40)];
        self.videoView.backgroundColor = [UIColor clearColor];
        self.videoView.image = [UIImage imageNamed:@"play_btn_make_show"];
        [self.photoView addSubview:self.videoView];

        
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

-(void)resetFrameWithContent:(NSString *)content{
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[content boundingRectWithSize:CGSizeMake(215, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float height=size.height;
    float originY = 50;
    if (height>58) {
        height=58;
        originY = 44;
    }
    self.describeLabel.frame=CGRectMake(99, originY, 215, height);
    
}

@end
