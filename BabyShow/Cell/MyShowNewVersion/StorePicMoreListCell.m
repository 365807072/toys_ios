//
//  StorePicMoreListCell.m
//  BabyShow
//
//  Created by 美美 on 2018/5/10.
//  Copyright © 2018年 Yuanyuanquanquan.com. All rights reserved.
//

#import "StorePicMoreListCell.h"

@implementation StorePicMoreListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.OnePicView = [[UIImageView alloc]init];
        self.OnePicView.frame = CGRectMake(0, 0, SCREENWIDTH,112);
        [self.OnePicView setContentMode:UIViewContentModeScaleToFill];
        //self.OnePicView.clipsToBounds = YES;
        
        [self.contentView addSubview:self.OnePicView];

        self.contentView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    }
    return self;
}

@end
