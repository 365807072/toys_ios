//
//  MyShowNewBasicItem.h
//  BabyShow
//
//  Created by Monica on 9/22/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyShowNewBasicItem : NSObject

@property (nonatomic, strong) NSString *identify;
@property (nonatomic, assign) CGFloat   height;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *imgid;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *avatarStr;
@property (nonatomic, strong) NSString *create_time;    //秀秀的创建时间
@property (nonatomic, assign) BOOL      is_recommend;        //是否是人气宝宝
@property (nonatomic ,strong) NSString *level_img;      //等级图片
@property(nonatomic,strong)NSString *img_cate;
@property(nonatomic,assign)NSInteger groupId;     //群id
@property(nonatomic,strong)NSString *groupName;   //群名
@property(nonatomic,assign)BOOL isHV;

@end
