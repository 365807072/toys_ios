//
//  SpecialHeadHotView.h
//  BabyShow
//
//  Created by Monica on 15-5-14.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialHeadHotModel.h"

@interface SpecialHeadHotView : UIView
@property(nonatomic,strong)UIButton *imageButtonBig;
@property(nonatomic,strong)UIButton *imageButtonUp;
@property(nonatomic,strong)UIButton *imageButtonDown;
@property(nonatomic,strong)UILabel *labelBig;
@property(nonatomic,strong)UILabel *labelUp;
@property(nonatomic,strong)UILabel *labelDown;
@property(nonatomic,strong)SpecialHeadHotModel *specialHeadHotModel;
@end
