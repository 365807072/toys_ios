//
//  MessageListRequestItem.h
//  BabyShow
//
//  Created by 于 晓波 on 1/20/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageListRequestItem : NSObject

@property (nonatomic, strong) NSString *avatarStr;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSNumber *userid;
@property (nonatomic, strong) NSNumber *messId;
@property (nonatomic, strong) NSNumber *msgType;
@property (nonatomic, strong) NSNumber *isAgreed;
@property (nonatomic, strong) NSNumber *relation;
@property (nonatomic, strong) NSNumber *isRead;
@property(nonatomic,strong)NSString *root_imgid;
@property(nonatomic,strong)NSString *share_userid;
@property(nonatomic,strong)NSString *img_id;
@property(nonatomic,strong)NSString *point;
@property(nonatomic,strong)NSString *levelImg;
@property(nonatomic,strong)NSString *video_url;
@property(nonatomic,strong)NSString *img_width;
@property(nonatomic,strong)NSString *img_height;




@end
