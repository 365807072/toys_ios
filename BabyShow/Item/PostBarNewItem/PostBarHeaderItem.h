//
//  PostBarHeaderItem.h
//  BabyShow
//
//  Created by Monica on 14-12-30.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 *  话题Header
 */
@interface PostBarHeaderItem : NSObject

@property (nonatomic ,strong)NSString *img_id;
@property (nonatomic ,strong)NSString *img;
@property (nonatomic ,strong)NSString *user_id;
@property (nonatomic ,strong)NSString *title;
@property (nonatomic ,strong)NSString *itemID;
@property (nonatomic ,assign)BOOL is_saved;
@property(nonatomic,assign)NSInteger is_group;
@property(nonatomic,assign)NSInteger groupId;
@property(nonatomic,strong)NSString *groupName;
@property(nonatomic,assign)BOOL is_bjCity;

@end
