//
//  PostBarManagementCell.m
//  BabyShow
//
//  Created by WMY on 16/9/18.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarManagementCell.h"

@implementation PostBarManagementCell

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
        self.photoView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 56, 56)];
        [self.photoView setContentMode:UIViewContentModeScaleAspectFill];
        self.photoView.image = [UIImage imageNamed:@"img_message_photo"];
        self.photoView.clipsToBounds = YES;
        [self.contentView addSubview:self.photoView];
        
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(76, 17, 75, 18)];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.textColor = [BBSColor hexStringToColor:@"333333"];
        
        [self.contentView addSubview:self.titleLabel];
        
        self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(76, 17+18+10, 75, 18)];
        self.descriptionLabel.font = [UIFont systemFontOfSize:13];
        self.descriptionLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        [self.contentView addSubview:self.descriptionLabel];
        
        self.postBarModelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.postBarModelBtn.frame = CGRectMake(SCREENWIDTH-176, 24, 65, 24);
        [self.postBarModelBtn setBackgroundImage:[UIImage imageNamed:@"post_bar_management"] forState:UIControlStateNormal];
        [self.postBarModelBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [self.postBarModelBtn setTitleColor:[BBSColor hexStringToColor:@"8e909d"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.postBarModelBtn];
        
        self.postBarSortBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.postBarSortBtn.frame = CGRectMake(self.postBarModelBtn.frame.origin.x+self.postBarModelBtn.frame.size.width+8, 24, 65, 24);
        [self.postBarSortBtn setBackgroundImage:[UIImage imageNamed:@"post_bar_management"] forState:UIControlStateNormal];
        [self.postBarSortBtn setTitle:@"管理分类" forState:UIControlStateNormal];
        [self.postBarSortBtn.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [self.postBarSortBtn setTitleColor:[BBSColor hexStringToColor:@"8e909d"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.postBarSortBtn];
        
        self.deleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.deleBtn.frame = CGRectMake(self.postBarSortBtn.frame.origin.x+self.postBarSortBtn.frame.size.width+8, 24, 25, 25);
        [self.deleBtn setBackgroundImage:[UIImage imageNamed:@"post_bar_delete_sort"] forState:UIControlStateNormal];
        [self.contentView addSubview:self.deleBtn];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 72.5, SCREENWIDTH, 0.5)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.contentView addSubview:lineView];
        
    }
    return self;
}
@end
