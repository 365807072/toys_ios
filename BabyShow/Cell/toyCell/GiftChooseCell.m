//
//  GiftChooseCell.m
//  BabyShow
//
//  Created by WMY on 17/3/27.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "GiftChooseCell.h"

@implementation GiftChooseCell

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
        self.userImg = [[UIImageView alloc]initWithFrame:CGRectMake(10,5,65,47)];
        self.userImg.image = [UIImage imageNamed:@"img_message_photo"];
        [self.contentView  addSubview:self.userImg];
        CALayer *layer = [self.userImg layer];
        layer.borderColor = [[BBSColor hexStringToColor:@"e4e4e4"]CGColor];
        layer.borderWidth = 1.0f;
        
        self.userLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 5, 110, 17)];
        self.userLabel.textColor = [BBSColor hexStringToColor:@"66666"];
        self.userLabel.font = [UIFont systemFontOfSize:13];
        self.userLabel.numberOfLines = 0;
        self.userLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.userLabel];
        self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(80, 20, 110, 40)];
        self.alertLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        self.alertLabel.font = [UIFont systemFontOfSize:10];
        self.alertLabel.numberOfLines = 0;
        self.alertLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.alertLabel];
        
        
    }
    return self;
}

@end
