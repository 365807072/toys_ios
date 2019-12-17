//
//  DateAlertView.h
//  BabyShow
//
//  Created by Monica on 15-2-5.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DateAlertViewDelegate <NSObject>

- (void)getTimeInfo:(NSString *)dateString;

@end

/*!
 *  修改日期的视图,fuck
 */
@interface DateAlertView : UIView

@property (nonatomic ,strong) UITextField *yearTF;
@property (nonatomic ,strong) UITextField *monthTF;
@property (nonatomic ,strong) UITextField *dayTF;
@property (nonatomic ,strong) UISegmentedControl *segControl;

@property (nonatomic ,assign)id<DateAlertViewDelegate> delegate;

@end
