//
//  GrowthDiaryBasicItem.h
//  BabyShow
//
//  Created by Monica on 15-1-24.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GrowthDiaryBasicItem : NSObject

@property (nonatomic ,strong) NSString *nodeName;           //姓名
@property (nonatomic ,strong) NSString *nodeID;             //ID
@property (nonatomic ,assign) NSInteger nodePrivilege;      //成长日记的权限
@property (nonatomic ,strong) NSString *nodeDescription;    //成长日记的节点描述
@property (nonatomic ,assign) NSInteger nodeImageCount;     //该节点中图片的数量
@property (nonatomic ,strong) NSString *nodeThumbString;    //节点中图片的缩略图地址

/*!
 *   Tag_type=1     代表多少岁啦
 *   Tag_type=2     代表多少岁6个月
 *   Tag_type=3     代表出生啦
 *   Tag_type=4     代表重点标签
 *   Tag_type=0     代表没有标签的普通图片
 */
@property (nonatomic ,assign) NSInteger tag_type;           //节点的类型
@property (nonatomic ,strong) NSString *tag_name;           //节点的名称

@end
