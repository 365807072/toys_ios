//
//  StoreMoreListCell.h
//  BabyShow
//
//  Created by WMY on 15/9/2.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeleteLineLabel.h"
#import "NIAttributedLabel.h"

@interface StoreMoreListCell : UITableViewCell
@property(nonatomic,strong)UIImageView *imgBusinessPic;
@property(nonatomic,strong)UILabel *labelBusinessTitle;
@property(nonatomic,strong)UILabel  *labelSubtitle;
@property(nonatomic,strong)UILabel *labelPostCreatTime;
@property(nonatomic,strong)UILabel *labelPriceShow;//不用的秀秀价控件
@property(nonatomic,strong)UILabel *labelPriceShowNumber;
@property(nonatomic,strong)UILabel *laeblPriceDelete;//不用的原价控件
@property(nonatomic,strong)DeleteLineLabel *labelDeletePrice;
@property(nonatomic,strong)UILabel *buyPeopleCount;


@end
