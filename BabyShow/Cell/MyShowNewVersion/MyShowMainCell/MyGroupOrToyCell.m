//
//  MyGroupOrToyCell.m
//  BabyShow
//
//  Created by WMY on 16/12/6.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyGroupOrToyCell.h"

@implementation MyGroupOrToyCell

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
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.backViewLeft = [[UIView alloc]initWithFrame:CGRectMake(5, 6.4, (SCREENWIDTH-15)/2, 73)];
        [self.contentView addSubview:self.backViewLeft];
        self.iconImgLeft = [[UIImageView alloc]initWithFrame:CGRectMake(8.5, 15, 43, 43)];
        self.iconImgLeft.layer.masksToBounds = YES;
        self.iconImgLeft.layer.cornerRadius = 21.5;
        self.iconImgLeft.userInteractionEnabled = YES;
        
        self.iconImgLeft.image = [UIImage imageNamed:@"icon-40"];
        [self.backViewLeft addSubview:self.iconImgLeft];
        self.groupNameLabelLeft = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImgLeft.frame.origin.x+self.iconImgLeft.frame.size.width+8.5, self.iconImgLeft.frame.origin.y, self.backViewLeft.frame.size.width-8.5-43-8.5, 17)];
        self.groupNameLabelLeft.font = [UIFont systemFontOfSize:13];
        self.groupNameLabelLeft.textColor = [BBSColor hexStringToColor:@"333333"];
        [self.backViewLeft addSubview:self.groupNameLabelLeft];
        
        self.groupDesLabelLeft = [[WMYLabel alloc]initWithFrame:CGRectMake(self.groupNameLabelLeft.frame.origin.x, self.groupNameLabelLeft.frame.origin.y+self.groupNameLabelLeft.frame.size.height+6.5, 90, 30)];

        self.groupDesLabelLeft.numberOfLines = 0;
        [self.groupDesLabelLeft setVerticalAlignment:VerticalAlignmentTop];
        self.groupDesLabelLeft.font = [UIFont systemFontOfSize:10];
        self.groupDesLabelLeft.textColor = [BBSColor hexStringToColor:@"999999"];
        [self.backViewLeft addSubview:self.groupDesLabelLeft];
        
        self.backViewRight = [[UIView alloc]initWithFrame:CGRectMake(10+self.backViewLeft.frame.size.width, 6.4, (SCREENWIDTH-15)/2, 73)];
        [self.contentView addSubview:self.backViewRight];
        self.iconImgRight = [[UIImageView alloc]initWithFrame:CGRectMake(8.5, 15, 43, 43)];
        self.iconImgRight.layer.masksToBounds = YES;
        self.iconImgRight.layer.cornerRadius = 21.5;
        self.iconImgRight.image = [UIImage imageNamed:@"icon-40"];
        [self.backViewRight addSubview:self.iconImgRight];
        self.iconImgRight.userInteractionEnabled = YES;
        self.groupNameLabelRight = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImgLeft.frame.origin.x+self.iconImgLeft.frame.size.width+8.5, self.iconImgLeft.frame.origin.y, self.backViewLeft.frame.size.width-8.5-43-8.5, 17)];
        self.groupNameLabelRight.font = [UIFont systemFontOfSize:13];
        self.groupNameLabelRight.textColor = [BBSColor hexStringToColor:@"333333"];
        [self.backViewRight addSubview:self.groupNameLabelRight];
        
        self.groupDesLabelRight = [[WMYLabel alloc]initWithFrame:CGRectMake(self.groupNameLabelLeft.frame.origin.x, self.groupNameLabelLeft.frame.origin.y+self.groupNameLabelLeft.frame.size.height+6.5, 90, 30)];
        self.groupDesLabelRight.numberOfLines = 0;
        [self.groupDesLabelRight setVerticalAlignment:VerticalAlignmentTop];
        self.groupDesLabelRight.font = [UIFont systemFontOfSize:10];
        self.groupDesLabelRight.textColor = [BBSColor hexStringToColor:@"999999"];
        [self.backViewRight addSubview:self.groupDesLabelRight];
        
        self.backViewTop = [[UIView alloc]initWithFrame:CGRectMake(0, self.backViewLeft.frame.origin.y+self.backViewLeft.frame.size.height, SCREENWIDTH, 30)];
        [self.contentView addSubview:self.backViewTop];
        
        self.moreImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-52, 10, 42, 12)];;
        self.moreImg.image = [UIImage imageNamed:@"more_group_main"];
        self.moreImg.userInteractionEnabled = YES;
        [self.backViewTop addSubview:self.moreImg];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, self.backViewTop.frame.origin.y+self.backViewTop.frame.size.height+1, SCREENWIDTH, 0.5)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.contentView addSubview:lineView];
        
    }
    return self;
}
@end
