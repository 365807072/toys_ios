//
//  DiaryBigNodeCell.h
//  BabyShow
//
//  Created by Monica on 15-1-23.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  大节点
 */
@interface DiaryBigNodeCell : UITableViewCell

@property (nonatomic ,strong)UILabel *nodeNameLabel;
@property (nonatomic ,strong)UIImageView *coverImageView;
@property (nonatomic ,strong)UILabel *titleLabel;
@property (nonatomic ,strong)UILabel *countLabel;
@property (nonatomic ,strong)UIImageView *nodeImageView;//节点
@property (nonatomic ,strong)UILabel *tagLabel;//标签
@end
