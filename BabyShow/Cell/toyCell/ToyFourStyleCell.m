//
//  ToyFourStyleCell.m
//  BabyShow
//
//  Created by 美美 on 2018/1/30.
//  Copyright © 2018年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyFourStyleCell.h"

@implementation ToyFourStyleCell

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
        self.storeImg =  [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 118)];
        self.storeImg.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.storeImg];
    }
    return self;
}
@end
