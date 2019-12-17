//
//  MyShowBuyCell.h
//  BabyShow
//
//  Created by WMY on 15/11/18.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeleteLineLabel.h"

@interface MyShowBuyCell : UITableViewCell
@property(nonatomic,strong)UILabel *selectLine;
@property(nonatomic,strong)UILabel *selectionName;
@property(nonatomic,strong)UIButton *moreButton;
@property(nonatomic,strong)UIImageView *arrowImg;
@property(nonatomic,strong)UIImageView *storeImg1;
@property(nonatomic,strong)UIImageView *storeImg2;
@property(nonatomic,strong)UIImageView *priceBackView1;
@property(nonatomic,strong)UILabel *priceShow1;
@property(nonatomic,strong)UILabel *priceBaby1;
@property(nonatomic,strong)UILabel *priceMarkt1;

@property(nonatomic,strong)UIImageView *priceBackView2;
@property(nonatomic,strong)UILabel *priceShow2;
@property(nonatomic,strong)UILabel *priceBaby2;
@property(nonatomic,strong)UILabel *priceMarkt2;

@property(nonatomic,strong)DeleteLineLabel *priceMarkD1;
@property(nonatomic,strong)DeleteLineLabel *priceMarkD2;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIImageView *imgBack;
@property(nonatomic,strong)UILabel *subLabel;
@property(nonatomic,strong)UIImageView *imgUpBack;

@end
