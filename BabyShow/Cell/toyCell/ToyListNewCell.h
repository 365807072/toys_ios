//
//  ToyListNewCell.h
//  BabyShow
//
//  Created by WMY on 17/1/11.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMYLabel.h"

@interface ToyListNewCell : UITableViewCell
@property(nonatomic,strong)UIView *headView;

@property(nonatomic,strong)UILabel *selectLine;
@property(nonatomic,strong)UILabel *selectionName;
@property(nonatomic,strong)UIButton *moreButton;
@property(nonatomic,strong)UILabel *moreLabel;
@property(nonatomic,strong)UIImageView *arrowImg;

@property(nonatomic,strong)UIButton *toyView1;
@property(nonatomic,strong)UIImageView *storeImg1;
@property(nonatomic,strong)WMYLabel *toyNameLabel1;
@property(nonatomic,strong)UILabel *priceShow1;
@property(nonatomic,strong)UILabel *priceMarkt1;

@property(nonatomic,strong)UIImageView *smallToyMark1;

@property(nonatomic,strong)UIView *toyView2;
@property(nonatomic,strong)UIImageView *storeImg2;
@property(nonatomic,strong)WMYLabel *toyNameLabel2;
@property(nonatomic,strong)UILabel *priceShow2;
@property(nonatomic,strong)UILabel *priceMarkt2;
@property(nonatomic,strong)UIImageView *smallToyMark2;


@property(nonatomic,strong)UIView *toyView3;
@property(nonatomic,strong)UIImageView *storeImg3;
@property(nonatomic,strong)WMYLabel *toyNameLabel3;
@property(nonatomic,strong)UILabel *priceShow3;
@property(nonatomic,strong)UILabel *priceMarkt3;
@property(nonatomic,strong)UIImageView *smallToyMark3;



@end
