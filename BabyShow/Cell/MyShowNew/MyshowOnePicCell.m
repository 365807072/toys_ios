//
//  MyshowOnePicCell.m
//  BabyShow
//
//  Created by 美美 on 2018/5/10.
//  Copyright © 2018年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyshowOnePicCell.h"

@implementation MyshowOnePicCell

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
        self.OnePicView.frame = CGRectMake(0, 10, SCREENWIDTH,SCREENWIDTH*0.3);
        [self.OnePicView setContentMode:UIViewContentModeScaleToFill];
       self.OnePicView.clipsToBounds = YES;
        
        [self.contentView addSubview:self.OnePicView];
        self.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        
    }
    return self;
}


@end
