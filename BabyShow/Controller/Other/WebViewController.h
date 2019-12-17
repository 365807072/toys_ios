//
//  WebViewController.h
//  BabyShow
//
//  Created by Lau on 8/1/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WebViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic , strong) NSString *urlStr;    //已转码
@property (nonatomic , strong) NSString *descript;
@property (nonatomic , strong) NSString *imgThumb;
@property (nonatomic , strong) NSString *img_id;//值得买的ID
@property(nonatomic,strong)NSString *fromWhree;//从哪来的

@end
