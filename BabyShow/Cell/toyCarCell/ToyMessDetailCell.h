//
//  ToyMessDetailCell.h
//  BabyShow
//
//  Created by WMY on 17/2/17.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMYLabel.h"
#import "ClickImage.h"

@protocol ToyAddCarCellDelegate <NSObject>
-(void)addToyToCar:(UIButton *) btn;

@end

@interface ToyMessDetailCell : UITableViewCell
@property (nonatomic, assign) id <ToyAddCarCellDelegate> delegate;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIView *lineTopView;
@property(nonatomic,strong)UIView *lineLeftView;
@property(nonatomic,strong)UIView *lineRightView;
@property(nonatomic,strong)UIView *lineBottomView;
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic, strong)UIImageView *photoView;
@property(nonatomic, strong)WMYLabel *toyNameLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UIView *grayView;
@property(nonatomic,strong)UILabel *decLabel;
@property(nonatomic,strong)UIButton *vipImgview;

@end
