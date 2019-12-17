//
//  ToyDepositCell.m
//  BabyShow
//
//  Created by WMY on 17/1/12.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyDepositCell.h"

@implementation ToyDepositCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    @property(nonatomic,strong)UIImageView *photoToyBookImgView;
//    @property(nonatomic,strong)UILabel *titleToyBookLabel;
//    @property(nonatomic,strong)UILabel *countBookLabel;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        self.photoImgView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.photoImgView.frame = CGRectMake(7, 10, (SCREENWIDTH-21)/2, 45);
        [self.photoImgView setBackgroundImage:[UIImage imageNamed:@"toy_deposit"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.photoImgView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(7+(SCREENWIDTH-21)/2-100, 10, 80 , 15)];
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        self.titleLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        [self.photoImgView addSubview:self.titleLabel];
        self.titleLabel.textAlignment = NSTextAlignmentRight;
        
        self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(7+(SCREENWIDTH-21)/2-100, 28, 80 , 15)];
        self.moneyLabel.font = [UIFont systemFontOfSize:13];
        self.moneyLabel.textColor = [BBSColor hexStringToColor:@"333333"];
        [self.photoImgView addSubview:self.moneyLabel];
        self.moneyLabel.textAlignment = NSTextAlignmentRight;
        
        
        //我的预约
        self.photoToyBookImgView = [UIButton buttonWithType:UIButtonTypeCustom];
        self.photoToyBookImgView.frame = CGRectMake(self.photoImgView.frame.origin.x+self.photoImgView.frame.size.width+7, 10, (SCREENWIDTH-21)/2, 45);
        [self.photoToyBookImgView setBackgroundImage:[UIImage imageNamed:@"toy_book_list"] forState:UIControlStateNormal];

        [self.contentView addSubview:self.photoToyBookImgView];
        
        self.titleToyBookLabel = [[UILabel alloc]initWithFrame:CGRectMake(7+(SCREENWIDTH-21)/2-100, 10, 80 , 15)];
        self.titleToyBookLabel.font = [UIFont systemFontOfSize:13];
        self.titleToyBookLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        [self.photoToyBookImgView addSubview:self.titleToyBookLabel];
        self.titleToyBookLabel.textAlignment = NSTextAlignmentRight;
        
        self.countBookLabel = [[UILabel alloc]initWithFrame:CGRectMake(7+(SCREENWIDTH-21)/2-100, 28, 80 , 15)];
        self.countBookLabel.font = [UIFont systemFontOfSize:13];
        self.countBookLabel.textColor = [BBSColor hexStringToColor:@"333333"];
        [self.photoToyBookImgView addSubview:self.countBookLabel];
        self.countBookLabel.textAlignment = NSTextAlignmentRight;
        
        

    }
    return self;
}
@end
