//
//  ToyTransportVC.h
//  BabyShow
//
//  Created by WMY on 16/12/12.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ToyTransportVC : UIViewController<UIWebViewDelegate>
@property(nonatomic,strong)NSString *order_id;
@property(nonatomic,strong)NSString *fromWhere;//1从付款页面成功后来的
@property(nonatomic,strong)NSString *businessId;
@property(nonatomic,assign)BOOL isHaveShare;//是否有分享页面
@end
