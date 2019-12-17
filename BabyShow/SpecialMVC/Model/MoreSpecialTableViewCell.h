//
//  MoreSpecialTableViewCell.h
//  BabyShow
//
//  Created by Monica on 15-5-14.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreSpecialModel.h"

@interface MoreSpecialTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *countOfPeopleLabel;
@property(nonatomic,strong)UIImageView *imageViewMore;
@property(nonatomic,strong)UIImageView *firstImageView;
@property(nonatomic,strong)UIImageView *secondImageView;
@property(nonatomic,strong)UIImageView *thirdImageView;
@property(nonatomic,strong)UIImageView *fourImageView;
@property(nonatomic,strong)MoreSpecialModel *moreSpecialModel;


@end
