//
//  DiaryEditCell.h
//  BabyShow
//
//  Created by Monica on 15-2-2.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaryEditCell : UITableViewCell

@property (nonatomic ,strong) UIImageView *photoImageView;
@property (nonatomic ,strong) UILabel     *timeLabel;
@property (nonatomic ,strong) UITextView  *descTextView;
@property (nonatomic ,strong) UILabel     *hintLabel;
@property (nonatomic ,strong) UIImageView *arrowImageV;
@property (nonatomic ,strong) NSIndexPath *indexPath;


@end
