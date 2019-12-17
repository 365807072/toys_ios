//
//  UserInfoManager.h
//  BabyShow
//
//  Created by Lau on 5/28/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfoItem.h"

@interface UserInfoManager : NSObject

-(void)saveUserInfo:(UserInfoItem *) userInfo;
-(BOOL)isCurrentUserAVisitor;
-(void)removeCurrentUserInfo;
-(void)replaceCurrentUserInfoWithNewUserInfo:(UserInfoItem *) newUserInfo;
-(UserInfoItem *)currentUserInfo;

@end
