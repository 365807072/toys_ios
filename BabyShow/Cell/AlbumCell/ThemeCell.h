//
//  ThemeCell.h
//  BabyShow
//
//  Created by Mayeon on 14-4-3.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageView.h"

@interface ThemeCell : UITableViewCell
//主题相册的背景图片
@property (nonatomic ,strong)UIImageView *themeBackImageView;
//主题图片
@property (nonatomic ,strong)ImageView *themeImageView;

@end
