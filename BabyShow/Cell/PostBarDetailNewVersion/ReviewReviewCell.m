//
//  ReviewReviewCell.m
//  BabyShow
//
//  Created by WMY on 16/11/16.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ReviewReviewCell.h"

@implementation ReviewReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        self.grayView = [[UIView alloc]initWithFrame:CGRectMake(15*0.6*2+32, 0, SCREENWIDTH-15*0.6*3-32, 30)];
        self.grayView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.contentView addSubview:self.grayView];
        
        self.describleLabel = [[NIAttributedLabel alloc]initWithFrame:CGRectMake(5, 5, SCREENWIDTH-15*0.6*3-32-10, 30)];
        self.describleLabel.font = [UIFont systemFontOfSize:12];
        self.describleLabel.numberOfLines = 0;
        self.describleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.grayView addSubview:self.describleLabel];
        
    }
    return self;
}
-(void)resetFrameWithContent:(NSString *)content{
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:12],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[content boundingRectWithSize:CGSizeMake(SCREENWIDTH-15*0.6*3-32-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float height=size.height;
    if (height < 16.707031) {
        height = 20;
    }
    self.grayView.frame = CGRectMake(15*0.6*2+32, 0, SCREENWIDTH-15*0.6*3-32, height+10);
    self.describleLabel.frame=CGRectMake(15*0.6*2+32, 2,SCREENWIDTH-15*0.6*3-32-10, height +10);
    
    
}

@end
