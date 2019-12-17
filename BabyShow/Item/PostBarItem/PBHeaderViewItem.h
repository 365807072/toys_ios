//
//  PBHeaderViewItem.h
//  BabyShow
//
//  Created by Lau on 6/6/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBHeaderViewItem : NSObject

@property (nonatomic ,strong) NSString *shop_id;
//商店的图片
@property (nonatomic, strong) NSString *business_img;
//商店的链接
@property (nonatomic, strong) NSString *business_url;
@property(nonatomic,strong)NSString *business_id;

@end
