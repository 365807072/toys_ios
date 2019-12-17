//
//  BBSCommonViewController.h
//  BabyShow
//
//  Created by Lau on 4/3/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBSCommonNavigationController : UINavigationController<UIGestureRecognizerDelegate>
@property (nonatomic,assign) BOOL canDragBack;
@property(nonatomic,assign)BOOL isNotGoBack;

@end
