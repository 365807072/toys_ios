//
//  PostBarManagementCell.h
//  BabyShow
//
//  Created by WMY on 16/9/18.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostBarManagementCell : UITableViewCell
@property(nonatomic, strong) UIImageView *photoView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic,strong)UILabel *descriptionLabel;
@property(nonatomic,strong)UIButton *postBarModelBtn;//帖子类型
@property(nonatomic,strong)UIButton *postBarSortBtn;//帖子类型
@property(nonatomic,strong)UIButton *deleBtn;//删除




@end
