//
//  PostBarDetailNewUserItem.h
//  BabyShow
//
//  Created by Monica on 10/23/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarDetailNewBasicItem.h"

@interface PostBarDetailNewUserItem : PostBarDetailNewBasicItem

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *imgid;
@property (nonatomic, strong) NSString *avatarString;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *time;
@property(nonatomic,assign)BOOL is_type;
@property(nonatomic,strong)NSString *babys_idol_id;
@property(nonatomic,assign)NSInteger babysCount;
@property(nonatomic,strong)NSArray *babysArray;
@property(nonatomic,assign)BOOL isClick;
@property(nonatomic,strong)NSString *tag_name;

@end
