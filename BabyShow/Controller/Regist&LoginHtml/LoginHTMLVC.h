//
//  LoginHTMLVC.h
//  BabyShow
//
//  Created by WMY on 16/3/10.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

@protocol LoginHTMLVCDelegate <NSObject>

- (void)loginViewControllerDimissDelegate;

@end


@interface LoginHTMLVC : UIViewController<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@property(nonatomic,strong)NSString *userName;
@property(nonatomic,strong)NSString *userPassWord;
@property(nonatomic,strong)NSString *userAvatar;
@property(nonatomic,strong)NSString *fromTabBar;
@property(nonatomic,weak)id<LoginHTMLVCDelegate>delegate;
-(void)callMethodFinish;
@end


