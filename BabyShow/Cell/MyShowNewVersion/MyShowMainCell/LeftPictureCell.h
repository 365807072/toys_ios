//
//  LeftPictureCell.h
//  BabyShow
//
//  Created by WMY on 16/8/1.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMYLabel.h"

@interface LeftPictureCell : UITableViewCell
@property(nonatomic,strong)UIImageView *imgViewBig;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)WMYLabel *titleLabel;
@property(nonatomic,strong)WMYLabel *subuTitleLabel;
@property(nonatomic,strong)UIImageView *lookOrginBtn;
@property(nonatomic,strong)UILabel *hotDataLabel;

@end
