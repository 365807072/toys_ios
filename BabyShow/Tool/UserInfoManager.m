//
//  UserInfoManager.m
//  BabyShow
//
//  Created by Lau on 5/28/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "UserInfoManager.h"

@implementation UserInfoManager


-(UserInfoItem *)currentUserInfo{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"usersList.plist"];
    NSDictionary* dic2 = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    UserInfoItem *userInfoItem=[[UserInfoItem alloc]init];

    userInfoItem.userId=dic2[@"UserId"];
    userInfoItem.userName=dic2[@"UserName"];
    userInfoItem.password=dic2[@"PassWord"];
    userInfoItem.nickname=dic2[@"NickName"];
    userInfoItem.email=dic2[@"Email"];
    userInfoItem.isVisitor=dic2[@"IsVisitor"];
    userInfoItem.loginType=[dic2[@"LoginType"]integerValue];
    userInfoItem.bindingType=[dic2[@"BindingType"]integerValue];;
    return userInfoItem;
    
}

-(void)saveUserInfo:(UserInfoItem *) userInfo{
    //登陆信息保留到plist文件
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [path objectAtIndex:0];
    NSString *plistPath = [documentsPath stringByAppendingPathComponent:@"usersList.plist"];
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc]init];
    NSLog(@"userinfoinfo = %@,%@,%@,%@,%@,%ld,%ld,%@",userInfo.userId,userInfo.userName,userInfo.password,userInfo.email,userInfo.isVisitor,userInfo.loginType,userInfo.bindingType,userInfo.nickname);
    //用户的id
    if (userInfo.userId) {
        [infoDic setObject:userInfo.userId forKey:@"UserId"];
    }
    //用户名
    if (userInfo.userName) {
        [infoDic setObject:userInfo.userName forKey:@"UserName"];

    }else{
        [infoDic setObject:@"" forKey:@"UserName"];
    }
    //用户密码
    if (userInfo.password) {
        [infoDic setObject:userInfo.password forKey:@"PassWord"];
    }else{
        [infoDic setObject:@"" forKey:@"PassWord"];

    }
    //用户邮箱
    if (userInfo.email) {
        [infoDic setObject:userInfo.email forKey:@"Email"];
    }else{
        [infoDic setObject:@"" forKey:@"Email"];

    }
    [infoDic setObject:[userInfo.isVisitor stringValue] forKey:@"IsVisitor"];
    [infoDic setObject:[NSString stringWithFormat:@"%ld",(long)userInfo.loginType] forKey:@"LoginType"];
    if (userInfo.bindingType) {
        [infoDic setObject:[NSString stringWithFormat:@"%ld",userInfo.bindingType] forKey:@"BindingType"];

    }else{
        [infoDic setObject:@"" forKey:@"BindingType"];
    }
    if (userInfo.nickname) {
        [infoDic setObject:userInfo.nickname forKey:@"NickName"];
    }else{
        [infoDic setObject:@"" forKey:@"NickName"];

    }
    [infoDic writeToFile:plistPath atomically:YES];

    
    
//    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
//    
//    [userDefault setObject:userInfo.userId forKey:USERID];//
//    [userDefault setObject:userInfo.userName forKey:USERNAME];//
//    [userDefault setObject:userInfo.password forKey:USERPASSWORD];//
//    [userDefault setObject:userInfo.nickname forKey:USERNICKNAME];//
//    [userDefault setObject:userInfo.email forKey:USEREMAIL];//
//    [userDefault setObject:userInfo.avatarStr forKey:USERAVATARSTR];
//    [userDefault setObject:userInfo.avatarStr forKey:USERAVATARORIGINSTR];
//    [userDefault setObject:userInfo.babys forKey:USERBABYSARRAY];
//    [userDefault setObject:userInfo.isVisitor forKey:USERISAVISIVOR];//
//    [userDefault setObject:[NSNumber numberWithInteger:userInfo.loginType] forKey:USERLOGINTYPE];//
//    [userDefault setObject:[NSNumber numberWithInteger:userInfo.bindingType] forKey:USERBINDINDTYPE];//

    
}

-(BOOL)isCurrentUserAVisitor{
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSNumber *isAVisitor=[userDefault objectForKey:USERISAVISIVOR];
    BOOL yesOrNo=[isAVisitor boolValue];
    return yesOrNo;
    
}

-(void)removeCurrentUserInfo{
    
    
}

-(void)replaceCurrentUserInfoWithNewUserInfo:(UserInfoItem *) newUserInfo{
    
    [self removeCurrentUserInfo];
    [self saveUserInfo:newUserInfo];
    
}

@end
