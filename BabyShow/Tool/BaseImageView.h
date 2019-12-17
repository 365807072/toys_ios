//
//  BaseImageView.h
//  BabyShow
//
//  Created by WMY on 15/12/9.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseImageView : UIImageView
+(id)imgViewWithFrame:(CGRect)frame backImg:(UIImage *)image userInterface:(BOOL)userInterface backgroupcolor:(NSString*)color;
@end
