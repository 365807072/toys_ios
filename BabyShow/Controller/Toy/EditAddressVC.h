//
//  EditAddressVC.h
//  BabyShow
//
//  Created by WMY on 17/5/16.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^getDataBlock)(NSDictionary *dic);
@interface EditAddressVC : UIViewController
//用户信息
@property(nonatomic,copy)getDataBlock getDataBlock;



@end
