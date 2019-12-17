//
//  MyCardListH5VC.h
//  BabyShow
//
//  Created by 美美 on 2018/8/4.
//  Copyright © 2018年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>
typedef void(^refreshInVCBlock) (BOOL isRefresh);


@interface MyCardListH5VC : UIViewController<UIWebViewDelegate>
@property(nonatomic,copy)refreshInVCBlock refreshInVC;
@property(nonatomic,assign)BOOL isRefreshInVC;

@end
