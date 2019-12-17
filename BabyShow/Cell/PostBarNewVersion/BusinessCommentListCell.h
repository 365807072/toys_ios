//
//  BusinessCommentListCell.h
//  BabyShow
//
//  Created by WMY on 15/11/4.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessCommentListCell : UITableViewCell
@property(nonatomic,strong)UILabel *userLabel;
@property(nonatomic,strong)UILabel *userLevelLabel;
@property(nonatomic,strong)UIImageView *userImgView;
@property(nonatomic,strong)UILabel *userCommentLabel;
@property(nonatomic,strong)UILabel *timeCommentLabel;
@property(nonatomic,strong)UIView *lineView;


@end
