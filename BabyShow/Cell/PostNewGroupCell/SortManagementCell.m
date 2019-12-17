//
//  SortManagementCell.m
//  BabyShow
//
//  Created by WMY on 16/9/18.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "SortManagementCell.h"

@implementation SortManagementCell

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
        self.rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 19.5,23, 17)];
        self.rankLabel.font = [UIFont systemFontOfSize:17];
        self.rankLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        [self.contentView addSubview:self.rankLabel];
        
        self.sortLabel = [[UILabel alloc]initWithFrame:CGRectMake(10+17+10, 18, 200, 20)];
        self.sortLabel.font = [UIFont systemFontOfSize:18];
        self.sortLabel.textColor = [BBSColor hexStringToColor:@"333333"];
        [self.contentView addSubview:self.sortLabel];
        
        //编辑
       // self.editBtn = [YLButton buttonWithFrame:CGRectMake(SCREENWIDTH-75, 14, 25, 25) type:UIButtonTypeCustom backImage:[UIImage imageNamed:@"post_sort_edit"] target:self action:nil forControlEvents:UIControlEventTouchUpInside];
        self.editBtn = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-75, 14, 25, 25)];
        self.editBtn.image = [UIImage imageNamed:@"post_sort_edit"];
        self.editBtn.userInteractionEnabled = YES;
        [self.contentView addSubview:self.editBtn];
        
        //删除
        self.deleBtn = [YLButton buttonWithFrame:CGRectMake(SCREENWIDTH-40, 5, 35, 40) type:UIButtonTypeCustom backImage:nil target:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.deleBtn];
        self.smallDeleBtn = [YLButton buttonWithFrame:CGRectMake(SCREENWIDTH-35, 14, 25, 25) type:UIButtonTypeCustom backImage:[UIImage imageNamed:@"post_bar_delete_sort"] target:self action:nil forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.smallDeleBtn];
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 52.5, SCREENWIDTH, 0.4)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.contentView addSubview:lineView];
    }
    return self;
}
@end
