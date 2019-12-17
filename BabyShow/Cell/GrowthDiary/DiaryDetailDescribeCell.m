//
//  DiaryDetailDescribeCell.m
//  BabyShow
//
//  Created by Monica on 15-1-24.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "DiaryDetailDescribeCell.h"

@implementation DiaryDetailDescribeCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect describeLabelFrame=CGRectMake(6, 0, SCREENWIDTH-12, 0);
        self.describeLabel=[[NIAttributedLabel alloc]initWithFrame:describeLabelFrame];
        self.describeLabel.font=[UIFont systemFontOfSize:16];
        self.describeLabel.numberOfLines=0;
        self.describeLabel.lineBreakMode=NSLineBreakByWordWrapping;
        self.describeLabel.textColor = [BBSColor hexStringToColor:@"494949"];
        [self.contentView addSubview:self.describeLabel];
        
    }
    return self;
}

-(void)resetLabelFrameWithContent:(NSString *)content{
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[content boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float height=size.height;
    if (height < 20) {
        height = 20;
    }
    
    self.describeLabel.frame=CGRectMake(6, 0, SCREENWIDTH-12, height + 4);
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
