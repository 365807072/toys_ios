//
//  WorthBuyItem.h
//  BabyShow
//
//  Created by Lau on 8/22/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorthBuyItem : NSObject

@property (nonatomic, strong) NSString *good_id;        //商品ID
@property (nonatomic, strong) NSString *shopName;       //商城名称
@property (nonatomic, strong) NSArray *photoArray;
@property (nonatomic, strong) NSString *descript;
@property (nonatomic, strong) NSString *currentPrice;
@property (nonatomic, strong) NSString *originPrice;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *remainTime;     //剩余时间
@property (nonatomic, assign) BOOL isPostage;           //是否包邮
@property (nonatomic, assign) int  good_type;           //商品logo的类型
@property (nonatomic ,strong) NSString *urlstring;      //购物链接
@property (nonatomic ,strong) NSString *latestState;    //最新动态
@end
