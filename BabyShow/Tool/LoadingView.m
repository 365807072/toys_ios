//
//  LoadingView.m
//  BabyShow
//
//  Created by Lau on 13-12-10.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "LoadingView.h"
#import "BaseImageView.h"

@implementation LoadingView

+(void)startUploadOnTheVc:(UIViewController *)UVC{
    UIView *backView=[[UIView alloc]initWithFrame:UVC.view.frame];
    backView.backgroundColor=[UIColor clearColor];

    BaseImageView *baseImg = [BaseImageView imgViewWithFrame:CGRectMake(SCREENWIDTH-60,60, 39, 39) backImg:[UIImage imageNamed:@"up_show.gif"] userInterface:NO backgroupcolor:@"333333"];
    [UVC.view addSubview:baseImg];
    
}
+(void)stopUploadOnTheVc:(UIViewController *)UVC{
    for (id obj in UVC.view.subviews) {
        if ([obj isKindOfClass:[UIView class]]) {
            UIView *newobj=(UIView *)obj;
            for (id subs in newobj.subviews) {
                if ([subs isKindOfClass:[BaseImageView class]]) {
                    NSLog(@"我什么不显示= %@",subs);
                    BaseImageView *loadingView=subs;
                    [loadingView removeFromSuperview];
                    
                    

                }
            }
        }
    }

}
+(void)startOnTheViewController:(UIViewController *)Uvc{
    
    UIView *backView=[[UIView alloc]initWithFrame:Uvc.view.frame];
    backView.backgroundColor=[UIColor clearColor];
    
   UIActivityIndicatorView *loadingView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadingView.frame=CGRectMake(Uvc.view.frame.size.width/2-60, Uvc.view.frame.size.height/2-75, 120, 100);
    loadingView.backgroundColor=[UIColor grayColor];
    loadingView.alpha=0.5;
    loadingView.layer.cornerRadius = 6;
    loadingView.layer.masksToBounds = YES;
    [backView addSubview:loadingView];
    [loadingView startAnimating];
    
    [Uvc.view addSubview:backView];
    
}

+(void)stopOnTheViewController:(UIViewController *)Uvc{
    
    for (id obj in Uvc.view.subviews) {
        
        if ([obj isKindOfClass:[UIView class]]) {
            
            UIView *newobj=(UIView *)obj;
            
            for (id subs in newobj.subviews) {
                
                if ([subs isKindOfClass:[UIActivityIndicatorView class]]) {
                    UIActivityIndicatorView *loadingView=subs;
                    [loadingView.superview removeFromSuperview];

//                    [loadingView removeFromSuperview];
                }
            }
        }
    }
}

+(void)startOntheView:(UIView *)view{
    
    UIActivityIndicatorView *loadingView=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    loadingView.center=CGPointMake(view.frame.size.width/2, view.frame.size.height/2);
    loadingView.backgroundColor=[UIColor clearColor];
    loadingView.alpha=0.5;
    loadingView.layer.cornerRadius = 6;
    loadingView.layer.masksToBounds = YES;
    [view addSubview:loadingView];
    [loadingView startAnimating];
    
}

+(void)stopOnTheView:(UIView *)view{
    
    for (id obj in view.subviews) {
        if ([obj isKindOfClass:[UIActivityIndicatorView class]]) {
            [obj removeFromSuperview];
        }
    }
    
}

@end
