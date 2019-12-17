//
//  BBSHasLogIn.m
//  BabyShow
//
//  Created by Monica on 10/20/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "BBSHasLogIn.h"
#import "UserInfoManager.h"
#import "UserInfoItem.h"
#import <ShareSDK/ShareSDK.h>

@implementation BBSHasLogIn

+(BOOL)userHasLogIn{
    
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *currentUser=[manager currentUserInfo];
    
    if (currentUser.loginType==LOGINUSERTYPEBABYSHOWUSER) {
        
        if (currentUser.userId) {
            return YES;
        }
        
    }else if (currentUser.loginType==LOGINUSERTYPESINAWEIBOUSER){
        
      //  if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo] && currentUser.userId) {
            return YES;
      //  }
        
    }else if (currentUser.loginType==LOGINUSERTYPEWEIXINUSER){
        
       // if ([ShareSDK hasAuthorizedWithType:ShareTypeWeixiSession] && currentUser.userId) {
            return YES;
       // }
        
    }
    
    
    
    return NO;
    
}

@end
