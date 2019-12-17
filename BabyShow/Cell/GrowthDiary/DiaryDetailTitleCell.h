//
//  DiaryDetailTitleCell.h
//  BabyShow
//
//  Created by Monica on 15-1-24.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiaryDetailTitleCell : UITableViewCell

-(void)resetFrameWithContent:(NSString *) content;

@property (nonatomic, strong) UILabel *titleLabel;


@end
