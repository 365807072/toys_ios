//
//  StoreDetailNewVC.h
//  BabyShow
//
//  Created by WMY on 16/6/2.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface StoreDetailNewVC : UIViewController<MWPhotoBrowserDelegate,UIAlertViewDelegate>
@property(nonatomic,strong)NSString *longin_user_id;
@property(nonatomic,strong)NSString *business_id;

@end
