//
//  BBSTabBarViewController.h
//  BabyShow
//
//  Created by 于 晓波 on 12/21/13.
//  Copyright (c) 2013 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSTabBarViewController : UITabBarController

{
    UIView *_tabbarView;
    NSMutableArray *_btnArray;
    NSArray *_backgroud;
    NSArray *_heightBackground;
    UILabel *_badgeValueLabel;
}
@property(nonatomic,strong)NSString *fromMyshow;
@property (nonatomic, strong) UIViewController *cacheViewController;
-(void)setbadgeValue:(NSString *) value;
-(void)setBBStabbarSelectedIndex:(NSInteger) index;
-(void)selectedTab:(UIButton *)button;



@end
