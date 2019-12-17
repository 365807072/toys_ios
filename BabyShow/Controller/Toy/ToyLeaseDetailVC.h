//
//  ToyLeaseDetailVC.h
//  BabyShow
//
//  Created by WMY on 16/12/7.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface ToyLeaseDetailVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,MWPhotoBrowserDelegate,UIWebViewDelegate>
@property(nonatomic,strong)NSString *business_id;
@property(nonatomic,strong)NSString *isToyWeb;//是否是URL链接或是原生页面

@end
