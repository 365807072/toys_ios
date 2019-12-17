//
//  UserInfoItem.h
//  BabyShow
//
//  Created by Lau on 13-12-11.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    LOGINUSERTYPEBABYSHOWUSER=0,
    LOGINUSERTYPESINAWEIBOUSER,//1
    LOGINUSERTYPEWEIXINUSER //2
} LOGINUSERTYPE;

@interface UserInfoItem : NSObject

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *avatarStr;
@property (nonatomic, strong) NSString *avatarOriginStr;
@property (nonatomic, strong) NSArray *babys;
@property (nonatomic, strong) NSNumber *isVisitor;
@property (nonatomic, assign) NSInteger loginType;
@property (nonatomic, assign) NSInteger bindingType;//绑定过的账户,1微博2微信,若二者皆绑定,取2微信
@property(nonatomic,strong)NSString *city;
@property(nonatomic,strong)NSString *isMobile;//是否有电话号码

@end
