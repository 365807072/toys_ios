//
//  PostBarNewDetialV1Cell.m
//  BabyShow
//
//  Created by WMY on 16/4/21.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarNewDetialV1Cell.h"
#import "btnWithIndexPath.h"

@implementation PostBarNewDetialV1Cell

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
        self.contentView.backgroundColor = [BBSColor hexStringToColor:@"deeaff"];
        self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREENWIDTH-40, 100)];
        self.descriptionLabel.font = [UIFont systemFontOfSize:19];
        self.descriptionLabel.textColor = [BBSColor hexStringToColor:@"333333"];
        [self.contentView addSubview:self.descriptionLabel];
    }
    return self;
}
-(NSInteger)resetFrameWithContent:(NSString *)content
{
    return 100;
}
-(NSInteger)resetLayOutSubviews:(NSInteger)imgCount{
    for (int i = 0; i < imgCount; i++) {
        btnWithIndexPath *imgBtn = [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        //imgBtn.frame = CGRectMake(20, self.descriptionLabel.frame.origin.y+self.descriptionLabel.frame.size.height+17.5, SCREENWIDTH-40, )
    }
    return 300;
}
@end
