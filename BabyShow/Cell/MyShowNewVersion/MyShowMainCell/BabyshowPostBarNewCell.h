//
//  BabyshowPostBarNewCell.h
//  BabyShow
//
//  Created by WMY on 16/9/1.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMYLabel.h"

@interface BabyshowPostBarNewCell : UITableViewCell
@property(nonatomic, strong) UIImageView *photoView;
@property(nonatomic,strong)UIImageView *videoView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic,strong)UILabel *reviewLabel;
@property(nonatomic,strong)UILabel *postLabel;
@property(nonatomic,strong)UILabel *descriptionLabel;
@property(nonatomic,strong)UIImageView *groupImageV;
@property(nonatomic,strong)WMYLabel *titleLabelS;
@property(nonatomic,strong)UILabel *label;


@end
