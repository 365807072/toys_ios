//
//  ToyOrderListCell.h
//  BabyShow
//
//  Created by WMY on 17/1/12.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMYLabel.h"
@interface ToyOrderListCell : UITableViewCell
@property(nonatomic, strong) UIImageView *photoView;
@property(nonatomic, strong) WMYLabel *toyNameLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UILabel *userNameLabel;
@property(nonatomic,strong)UIButton *delelBtn;
@property(nonatomic,strong)UIButton *moreLeaseBtn;
@property(nonatomic,strong)UIImageView *smallToyMark;




@end
