//
//  ToyShareUserCell.m
//  BabyShow
//
//  Created by WMY on 17/3/27.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyShareUserCell.h"

@implementation ToyShareUserCell

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
        self.userImg = [[UIImageView alloc]initWithFrame:CGRectMake(45,5,36,36)];
        self.userImg.image = [UIImage imageNamed:@"img_message_photo"];
        self.userImg.layer.masksToBounds = YES;
        self.userImg.layer.cornerRadius = 18;
        [self.contentView  addSubview:self.userImg];
        
        self.userLabel = [[UILabel alloc]initWithFrame:CGRectMake(45+36+5, 5, 175, 15)];
        self.userLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        self.userLabel.font = [UIFont systemFontOfSize:10];
        self.userLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.userLabel];
        self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(45+36+5, 20, 175, 20)];
        self.alertLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        self.alertLabel.font = [UIFont systemFontOfSize:9];
        self.alertLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:self.alertLabel];
        
        self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareBtn.frame = CGRectMake(SCREENWIDTH-60-45,5, 69, 27);
        [self.contentView addSubview:self.shareBtn];

    }
    return self;
}
@end
