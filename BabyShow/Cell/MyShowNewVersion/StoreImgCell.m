//
//  StoreImgCell.m
//  BabyShow
//
//  Created by WMY on 15/11/16.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "StoreImgCell.h"

@implementation StoreImgCell

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
        self.contentView.backgroundColor = [BBSColor hexStringToColor:@"e6e6e6"];
        self.storeImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 4, SCREENWIDTH, 52)];
        [self.contentView addSubview:self.storeImg];
        
        
        
    }
    
    return self;
}


@end
