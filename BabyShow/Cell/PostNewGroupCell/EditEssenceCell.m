//
//  EditEssenceCell.m
//  BabyShow
//
//  Created by WMY on 16/9/23.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "EditEssenceCell.h"

@implementation EditEssenceCell

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
        self.classLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 15, 200, 21)];
        self.classLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:self.classLabel];
        
        self.classImg = [[UIImageView alloc]initWithFrame:CGRectMake(260-30, 15, 18.5, 18.5)];
        [self.contentView addSubview:self.classImg];
        self.classImg.userInteractionEnabled = YES;
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, 260, 0.5)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.contentView addSubview:lineView];

        
    }
    return self;
}

@end
