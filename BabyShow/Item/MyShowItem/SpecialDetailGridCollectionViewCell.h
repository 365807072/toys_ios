//
//  SpecialDetailGridCollectionViewCell.h
//  BabyShow
//
//  Created by WMY on 15/5/18.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialDetailGridItem.h"

@interface SpecialDetailGridCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)UIImageView *photoImage;
@property(nonatomic,strong)UILabel *numberLabel;
@property(nonatomic,strong)SpecialDetailGridItem *specialDetailGrid;


@end
