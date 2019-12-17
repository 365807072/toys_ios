//
//  VerficationVC.h
//  BabyShow
//
//  Created by WMY on 16/2/26.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^refreshInStoreVC)();

@interface VerficationVC : UIViewController
//商家验证时需要获取的数据
@property(nonatomic,strong)NSString *orderIdVeri;
@property(nonatomic,strong)NSString *orderNumVeri;
@property(nonatomic,strong)NSString *verificationVeri;
@property(nonatomic,strong)NSString *priceVeri;
@property(nonatomic,strong)NSString *businessPackageVeri;
@property(nonatomic,copy)refreshInStoreVC refreshInStoreVC;


@end
