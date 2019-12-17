//
//  PostBarNewReviewsDescribleCell.m
//  BabyShow
//
//  Created by WMY on 16/4/22.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarNewReviewsDescribleCell.h"

@implementation PostBarNewReviewsDescribleCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.describeLabel = [[NIAttributedLabel alloc]initWithFrame:CGRectMake(15*0.6*2+32, 5, SCREENWIDTH-15*0.6*3-32, 0)];
        self.describeLabel.font = [UIFont systemFontOfSize:14];
        self.describeLabel.numberOfLines = 0;
        self.describeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.describeLabel.textColor = [BBSColor hexStringToColor:@"494949"];
        [self.contentView addSubview:self.describeLabel];
    }
    return self;
}
-(void)resetFrameWithContent:(NSString *)content{
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[content boundingRectWithSize:CGSizeMake(SCREENWIDTH-15*0.6*3-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float height=size.height;
    if (height < 16.707031) {
        height = 20;
    }
   
    self.describeLabel.frame=CGRectMake(15*0.6*2+32, 2,SCREENWIDTH-15*0.6*3-32, height +10);


}
@end
