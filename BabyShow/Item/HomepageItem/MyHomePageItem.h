//
//  MyHomePageItem.h
//  BabyShow
//
//  Created by 于 晓波 on 1/5/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyHomePageItem : NSObject

@property (nonatomic, strong) NSString *showCount;
@property (nonatomic, strong) NSString *idolCount;
@property (nonatomic, strong) NSString *fansCount;
@property (nonatomic, strong) NSString *relation;
@property (nonatomic, strong) NSString *messCount;
@property (nonatomic, strong) NSString *sharemeCount;
@property (nonatomic, strong) NSString *myshareCount;
@property (nonatomic, strong) NSString *myPostSaveCount;

@property (nonatomic, strong) NSArray *babys;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *avatarStr;
@property (nonatomic, strong) NSString *registerUserName;
@property (nonatomic, strong) NSString *registerEmail;

@property (nonatomic ,strong) NSString *level_img;
@property(nonatomic,assign)NSInteger user_role;
@property(nonatomic,assign)NSInteger my_message_count;
@property(nonatomic,assign)NSInteger friends_message_count;
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,assign)NSInteger babys_idol_count;
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *isCount;//是否显示账户余额

@end
