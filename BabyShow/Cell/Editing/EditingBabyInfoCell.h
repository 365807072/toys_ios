//
//  EditingBabyInfoCell.h
//  BabyShow
//
//  Created by 于 晓波 on 1/12/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditingBabyInfoCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UITextField *backTF;//隐式触发键盘用

@end
