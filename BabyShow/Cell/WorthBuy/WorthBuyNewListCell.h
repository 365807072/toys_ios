//
//  WorthBuyNewListCell.h
//  BabyShow
//
//  Created by WMY on 15/6/1.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeleLineBuy.h"
#import "NIAttributedLabel.h"

@interface WorthBuyNewListCell : UITableViewCell
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *moreLabel;
@property(nonatomic,strong)UIImageView *imageViewMore;
@property(nonatomic,strong)UIImageView *firstImageView;
@property(nonatomic,strong)UIImageView *secondimageView;
@property(nonatomic,strong)UIImageView *thirdImageView;
@property(nonatomic,strong)UILabel *firstNameLabel;
@property(nonatomic,strong)UILabel *secondNameLabel;
@property(nonatomic,strong)UILabel *thirdNameLabel;
@property(nonatomic,strong)UILabel *firstPriceLabel;//现价
@property(nonatomic,strong)DeleLineBuy *firstOriginLabel;//原价
@property(nonatomic,strong)UILabel *SPriceLabel;//现价
@property(nonatomic,strong)DeleLineBuy *SOriginLabel;//原价
@property(nonatomic,strong)UILabel *TPriceLabel;//现价
@property(nonatomic,strong)DeleLineBuy *TOriginLabel;//原价

@end
