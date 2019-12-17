//
//  MyShowNewVersionItem.h
//  BabyShow
//
//  Created by WMY on 15/11/16.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyShowNewVersionItem : NSObject
@property(nonatomic,strong)NSString *special_name;
@property(nonatomic,strong)NSString *special_type;
@property(nonatomic,strong)NSString *more_special;
@property(nonatomic,strong)NSMutableArray *imgArray;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,assign)BOOL isClick;
@property(nonatomic,assign)NSInteger cateId;
@property(nonatomic,strong)NSString *cateName;
@property(nonatomic,assign)NSInteger img_id;
@property(nonatomic,strong)NSString *businessUrl;
@property(nonatomic,assign)NSInteger group_id;
@property(nonatomic,strong)NSString *groupName;
@property(nonatomic,assign)NSString *businessId;
@property(nonatomic,strong)NSString *businessName;
@property(nonatomic,strong)NSString *vice_special_name;


@end
