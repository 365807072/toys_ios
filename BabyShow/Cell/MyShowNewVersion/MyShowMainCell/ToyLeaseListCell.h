//
//  ToyLeaseListCell.h
//  BabyShow
//
//  Created by WMY on 16/12/6.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMYLabel.h"
typedef void (^addCars)(UIImageView *toyImg);
@interface ToyLeaseListCell : UITableViewCell
@property(nonatomic, strong) UIImageView *photoView;
@property(nonatomic, strong) WMYLabel *toyNameLabel;
@property(nonatomic, strong) UIImageView *userImg;
@property(nonatomic,strong)UILabel *userNameLabel;
@property(nonatomic,strong)UILabel *explainLabel;
@property(nonatomic,strong)UIImageView *toyImg;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UIButton *addCarBtn;
@property(strong,nonatomic)addCars addCars;
@property(nonatomic,strong)UIImageView *smallToyMark;

@end
