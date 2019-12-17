//
//  MessageItem.h
//  BabyShow
//
//  Created by Lau on 14-1-13.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageItem : NSObject

@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *avatarStr;
@property (nonatomic, strong) NSNumber *messId;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *photoStr;
@property (nonatomic, strong) NSString *imgId;
@property (nonatomic, strong) NSString *rootImgId;
@property (nonatomic, strong) NSNumber *isRead;
@property (nonatomic, strong) NSString *target;
@property (nonatomic, assign) BOOL isPost;
@property (nonatomic ,assign) BOOL isSave;//动态进话题详情的时候是否收藏过
@property (nonatomic, strong) NSNumber *msgType;//动态用msgType标识是否是升级消息(被评为周人气宝宝)
@property(nonatomic,strong)NSString *point;
@property(nonatomic,strong)NSString *levelImg;
@property(nonatomic,strong)NSString *video_url;
@property(nonatomic,strong)NSString *img_width;
@property(nonatomic,strong)NSString *img_height;

@end
