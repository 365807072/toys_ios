//
//  ToyShareNoFriendCellTableViewCell.m
//  BabyShow
//
//  Created by WMY on 17/3/29.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyShareNoFriendCellTableViewCell.h"

@implementation ToyShareNoFriendCellTableViewCell

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
        self.photoView = [[UIImageView alloc]initWithFrame:CGRectMake((SCREENWIDTH-126)/2,10,126,140)];
        self.photoView.image = [UIImage imageNamed:@"toy_share_no_friend"];
        [self.photoView setContentMode:UIViewContentModeScaleAspectFill];
        self.photoView.clipsToBounds = YES;
        [self.contentView addSubview:self.photoView];
        
    }
    return self;
}

@end
