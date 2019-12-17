//
//  StoreMapViewController.h
//  BabyShow
//
//  Created by WMY on 15/10/26.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StoreMapViewController : UIViewController<UIActionSheetDelegate>
@property(nonatomic,strong)NSString *storeName;
@property(nonatomic,strong)NSString *storeAddress;
@property(nonatomic,strong)NSString *lat;
@property(nonatomic,strong)NSString *log;
@property(nonatomic,strong)NSString *tencentLat;
@property(nonatomic,strong)NSString *tencentLog;
@end
