//
//  LoadingView.h
//  BabyShow
//
//  Created by Lau on 13-12-10.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadingView : NSObject

@property (nonatomic, strong) UIActivityIndicatorView *loadingView;
+(void)startUploadOnTheVc:(UIViewController*)UVC;
+(void)stopUploadOnTheVc:(UIViewController*)UVC;

+(void)startOnTheViewController:(UIViewController *) Uvc;
+(void)stopOnTheViewController:(UIViewController *) Uvc;

+(void)startOntheView:(UIView *) view;
+(void)stopOnTheView:(UIView *) view;
@end
