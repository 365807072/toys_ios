//
//  ToyMessDetailCell.m
//  BabyShow
//
//  Created by WMY on 17/2/17.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyMessDetailCell.h"

@implementation ToyMessDetailCell

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
        self.contentView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(8, 0, SCREEN_WIDTH-16, 70)];
        self.backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.backView];
        
        
        self.lineLeftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 1, 70)];
        self.lineLeftView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.backView addSubview:self.lineLeftView];
        
        self.lineRightView = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-17, 0, 1, 70)];
        self.lineRightView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.backView addSubview:self.lineRightView];
        
        self.lineTopView = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH-16, 1)];
        self.lineTopView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.backView addSubview:self.lineTopView];
        
        self.lineBottomView = [[UIView alloc]initWithFrame:CGRectMake(0, 69,SCREEN_WIDTH-16, 1)];
        self.lineBottomView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.backView addSubview:self.lineBottomView];
        
        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectBtn.frame = CGRectMake(1, 17, 42, 42);
        [self.selectBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
        [self.backView addSubview:self.selectBtn];
        [self.selectBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

        self.photoView = [[UIImageView alloc]initWithFrame:CGRectMake(44,10,50,50)];
        self.photoView.image = [UIImage imageNamed:@"img_message_photo"];
        [self.photoView setContentMode:UIViewContentModeScaleAspectFill];
        self.photoView.clipsToBounds = YES;
        [self.backView addSubview:self.photoView];
        
        self.toyNameLabel = [[WMYLabel alloc]initWithFrame:CGRectMake(self.photoView.frame.origin.x+self.photoView.frame.size.width+10, self.photoView.frame.origin.y,  SCREEN_WIDTH-16-44-50-10-105, 20)];
        self.toyNameLabel.font = [UIFont systemFontOfSize:13];
        self.toyNameLabel.textColor = [BBSColor hexStringToColor:@"333333"];
        [self.backView addSubview:self.toyNameLabel];
        self.toyNameLabel.numberOfLines = 3;
        [self.toyNameLabel setVerticalAlignment:VerticalAlignmentTop];
        
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-16-80, self.toyNameLabel.frame.origin.y-3, 75, 20)];
        self.priceLabel.textColor = [BBSColor hexStringToColor:@"333333"];
        self.priceLabel.font = [UIFont systemFontOfSize:14];
        self.priceLabel.textAlignment = NSTextAlignmentRight;
        [self.backView addSubview:self.priceLabel];
        
        self.decLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.photoView.frame.origin.x+self.photoView.frame.size.width+10, self.toyNameLabel.frame.origin.y+self.toyNameLabel.frame.size.height+5,  SCREEN_WIDTH-16-44-50-10-105, 20)];
        self.decLabel.textColor = [BBSColor hexStringToColor:@"333333"];
        self.decLabel.font = [UIFont systemFontOfSize:11];
        self.decLabel.textAlignment = NSTextAlignmentLeft;
        [self.backView addSubview:self.decLabel];
        
        self.vipImgview = [UIButton buttonWithType:UIButtonTypeCustom];
        self.vipImgview.frame = CGRectMake(SCREEN_WIDTH-16-21,39+11,20,19);
        [self.backView addSubview:self.vipImgview];
    }
    return self;
}
-(void)onClick:(UIButton *) btn{
    if ([self.delegate respondsToSelector:@selector(addToyToCar:)]) {
        [self.delegate addToyToCar:btn];
    }

}
@end
