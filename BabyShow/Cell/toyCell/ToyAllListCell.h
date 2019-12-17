//
//  ToyAllListCell.h
//  BabyShow
//
//  Created by 美美 on 2018/2/1.
//  Copyright © 2018年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToyAllListCell : UICollectionViewCell
@property(nonatomic,strong)UIView *picView;
@property(nonatomic,strong)UIImageView *toyPicImg;
@property(nonatomic,strong)UILabel *toyNameLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UIImageView *markImg;
@property(nonatomic,strong)UILabel *ageLabel;
@property(nonatomic,strong)UIButton *toyNameBtn;


@end
