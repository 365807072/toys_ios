//
//  ToyLeaseListCell.m
//  BabyShow
//
//  Created by WMY on 16/12/6.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyLeaseListCell.h"

@implementation ToyLeaseListCell

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
        self.photoView = [[UIImageView alloc]initWithFrame:CGRectMake(8, 10, 129, 103)];
        self.photoView.image = [UIImage imageNamed:@"img_message_photo"];
        [self.photoView setContentMode:UIViewContentModeScaleAspectFill];
        self.photoView.clipsToBounds = YES;
        
        [self.contentView addSubview:self.photoView];
        _smallToyMark = [[UIImageView alloc]initWithFrame:CGRectMake(129-34, 103-31,34, 31)];
        [self.photoView addSubview:_smallToyMark];

        
        self.toyNameLabel = [[WMYLabel alloc]initWithFrame:CGRectMake(self.photoView.frame.origin.x+self.photoView.frame.size.width+10, self.photoView.frame.origin.y, SCREENWIDTH-157, 20)];
        self.toyNameLabel.font = [UIFont systemFontOfSize:16];
        self.toyNameLabel.textColor = [BBSColor hexStringToColor:@"333333"];
        [self.contentView addSubview:self.toyNameLabel];
        self.toyNameLabel.numberOfLines = 3;
        [self.toyNameLabel setVerticalAlignment:VerticalAlignmentTop];
        
        self.userImg =  [[UIImageView alloc]initWithFrame:CGRectMake(self.toyNameLabel.frame.origin.x, self.toyNameLabel.frame.origin.y+self.toyNameLabel.frame.size.height+5, 15,15)];
        self.userImg.layer.masksToBounds = YES;
        self.userImg.layer.cornerRadius = 7.5;
        //[self.contentView addSubview:self.userImg];
        
        self.userNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.userImg.frame.origin.x+self.userImg.frame.size.width+5, self.userImg.frame.origin.y, 170, 15)];
        self.userNameLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        self.userNameLabel.font = [UIFont systemFontOfSize:10];
        //[self.contentView addSubview:self.userNameLabel];
        
        self.explainLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.toyNameLabel.frame.origin.x, 122-17-10-15-2, 170, 15)];
        self.explainLabel.font = [UIFont systemFontOfSize:10];
        self.explainLabel.textColor = [BBSColor hexStringToColor:@"666666"];
       //[self.contentView addSubview:self.explainLabel];
        
        
        self.priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.toyNameLabel.frame.origin.x, 122-17-15, 70, 20)];
        self.priceLabel.textColor = [BBSColor hexStringToColor:@"fd6363"];
        self.priceLabel.font = [UIFont systemFontOfSize:14];
        self.priceLabel.lineBreakMode = NSLineBreakByClipping;
        [self.contentView addSubview:self.priceLabel];
        
        self.toyImg = [[UIImageView alloc]initWithFrame:CGRectMake(self.priceLabel.frame.origin.x+self.priceLabel.frame.size.width-2, 122-19-13, 19, 19)];
        [self.toyImg setContentMode:UIViewContentModeScaleAspectFill];
        self.toyImg.clipsToBounds = YES;
        [self.contentView addSubview:self.toyImg];

        
        self.addCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.addCarBtn.frame = CGRectMake(SCREENWIDTH-50, 122-10-36, 40, 40);
        [self.addCarBtn setImageEdgeInsets:UIEdgeInsetsMake(9, 9, 9, 9)];
        [self.addCarBtn addTarget:self action:@selector(addToyToCar:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.addCarBtn];
        self.addCarBtn.adjustsImageWhenDisabled = NO;

        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 121.5, SCREENWIDTH, 0.5)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.contentView addSubview:lineView];
        
        
    }
    return self;
}
-(void)addToyToCar:(id)sender{
    if (_addCars) {
        _addCars(self.photoView);
    }
    
}
@end
