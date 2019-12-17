//
//  BusinessCommentListCell.m
//  BabyShow
//
//  Created by WMY on 15/11/4.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "BusinessCommentListCell.h"

@implementation BusinessCommentListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.userLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 200, 15)];
        self.userLabel.text = @"泗水的流年呀怎么回事";
        self.userLabel.font = [UIFont systemFontOfSize:13];
        self.userLabel.textColor = [BBSColor hexStringToColor:@"333333"];
        [self.contentView addSubview:self.userLabel];
        
        self.timeCommentLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-92, self.userLabel.frame.origin.y, 80, 15)];
        self.timeCommentLabel.textAlignment = NSTextAlignmentRight;
        self.timeCommentLabel.text = @"2015-10-33";
        self.timeCommentLabel.font = [UIFont systemFontOfSize:13];
        self.timeCommentLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        [self.contentView addSubview:self.timeCommentLabel];
        
        self.userLevelLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.userLabel.frame.origin.y+self.userLabel.frame.size.height+10 , 115, 15)];
        self.userLevelLabel.text = @"小孩子喜欢程度:";
        self.userLevelLabel.font = [UIFont systemFontOfSize:13];
        self.userLevelLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        [self.contentView addSubview:self.userLevelLabel];
        
        self.userImgView = [[UIImageView alloc]initWithFrame:CGRectMake(self.userLevelLabel.frame.origin.x+self.userLevelLabel.frame.size.width+3, self.userLevelLabel.frame.origin.y+2, 65, 10)];
        self.userImgView.image = [UIImage imageNamed:@"img_star"];
        [self.contentView addSubview:self.userImgView];
        self.userCommentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, self.userLevelLabel.frame.origin.y+self.userLevelLabel.frame.size.height+10, SCREENWIDTH-22, 35)];
        self.userCommentLabel.font = [UIFont systemFontOfSize:15];
        self.userCommentLabel.numberOfLines = 0;
        self.userCommentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.userCommentLabel.textColor = [BBSColor hexStringToColor:@"333333"];
        self.userCommentLabel.text = @"不一样的烟火我及时问我我U型昂不一样的一部的烟火宴会";
        [self.contentView addSubview:self.userCommentLabel];
        self.lineView = [[UIView alloc]initWithFrame:CGRectZero];
        //self.lineView = [UIView alloc]initWithFrame:CGRectMake(0, self.contentVie, <#CGFloat width#>, <#CGFloat height#>)
        self.lineView.backgroundColor = [UIColor grayColor];
        [self.contentView addSubview:self.lineView];


    }
    return self;
}

@end
