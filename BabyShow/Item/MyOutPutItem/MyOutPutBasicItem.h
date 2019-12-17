//
//  MyOutPutBasicItem.h
//  BabyShow
//
//  Created by Monica on 9/17/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyOutPutBasicItem : NSObject

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSString *identify;
@property (nonatomic, strong) NSString *imgid;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *create_time;    //秀秀的创建时间
@property(nonatomic,strong)NSString *img_cate;
@property(nonatomic,assign)NSInteger groupId;
@property(nonatomic,strong)NSString *groupName;

@end
