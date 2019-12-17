//
//  LeftPictureNoTitleCell.h
//  BabyShow
//
//  Created by 美美 on 2017/7/21.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMYLabel.h"

@interface LeftPictureNoTitleCell : UITableViewCell
@property(nonatomic,strong)UIImageView *imgViewBig;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)WMYLabel *titleLabel;
@property(nonatomic,strong)WMYLabel *subuTitleLabel;
@property(nonatomic,strong)UIImageView *lookOrginBtn;
@property(nonatomic,strong)UILabel *hotDataLabel;

@end
