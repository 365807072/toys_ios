//
//  DiaryDetailReviewCell.m
//  BabyShow
//
//  Created by Monica on 15-1-24.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "DiaryDetailReviewCell.h"

@implementation DiaryDetailReviewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect reviewLabelFrame=CGRectMake(6, 2, SCREENWIDTH-12, 40);
        self.reviewLabel=[[NIAttributedLabel alloc]initWithFrame:reviewLabelFrame];
        self.reviewLabel.font=[UIFont systemFontOfSize:14];
        self.reviewLabel.numberOfLines=0;
        self.reviewLabel.lineBreakMode=NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.reviewLabel];
        
    }
    return self;
}

-(void)resetLabelFrameWithContent:(NSString *)content{
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[content boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    float height=size.height;
    
    if (height < 20) {
        height = 20;
    }
    self.reviewLabel.frame=CGRectMake(6, 2, SCREENWIDTH-12, height + 5);
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
