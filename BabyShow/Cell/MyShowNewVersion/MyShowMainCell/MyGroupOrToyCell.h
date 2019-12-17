//
//  MyGroupOrToyCell.h
//  BabyShow
//
//  Created by WMY on 16/12/6.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMYLabel.h"


@interface MyGroupOrToyCell : UITableViewCell
@property(nonatomic,strong)UIView *backViewLeft;
@property(nonatomic,strong)UIView *backViewRight;
@property(nonatomic,strong)UIImageView *iconImgLeft;
@property(nonatomic,strong)UIImageView *iconImgRight;
@property(nonatomic,strong)UILabel *groupNameLabelLeft;
@property(nonatomic,strong)UILabel *groupNameLabelRight;
@property(nonatomic,strong)WMYLabel *groupDesLabelLeft;
@property(nonatomic,strong)WMYLabel *groupDesLabelRight;
@property(nonatomic,strong)UIImageView *moreImg;
@property(nonatomic,strong)UIView *backViewTop;







@end
