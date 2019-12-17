//
//  RedBagListCell.h
//  BabyShow
//
//  Created by WMY on 15/12/8.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RedBagListItem.h"
@interface RedBagListCell : UITableViewCell
@property(nonatomic,strong)BaseImageView*backImg;
@property(nonatomic,strong)BaseLabel *moneySymbolLabel;

@property(nonatomic,strong)BaseLabel *moneyCountLabel;
@property(nonatomic,strong)BaseLabel *classifyLabel;
@property(nonatomic,strong)BaseLabel *ruleLabel;
@property(nonatomic,strong)UIImageView *lineImg;
@property(nonatomic,strong)BaseLabel *limitLabel;
@property(nonatomic,strong)BaseLabel *timeLabel;
@property(nonatomic,strong)RedBagListItem *redbagListItem;




@end
