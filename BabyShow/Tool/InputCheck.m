//
//  InputCheck.m
//  BabyShow
//
//  Created by Lau on 13-12-9.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "InputCheck.h"

@implementation InputCheck

-(BOOL)phoneNumberCheck:(NSString *)PhoneNum{
    
    NSString* MOBILE= @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     * 中国移动：China Mobile
     * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     */
    
    NSString* CM= @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     * 中国联通：China Unicom
     * 130,131,132,152,155,156,185,186
     */
    
    NSString* CU= @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     * 中国电信：China Telecom
     * 133,1349,153,180,189
     */
    
    NSString* CT= @"^1((33|53|8[09])[0-9]|349)\\d{7}$";

    NSPredicate*regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
    NSPredicate*regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM];
    NSPredicate*regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU];
    NSPredicate*regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT];
    
    if(([regextestmobile evaluateWithObject:PhoneNum] == YES)
       || ([regextestcm evaluateWithObject:PhoneNum] == YES)
       || ([regextestct evaluateWithObject:PhoneNum] == YES)
       || ([regextestcu evaluateWithObject:PhoneNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

-(BOOL)emailChek:(NSString *)Email{
    NSString *str=@"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicateEmail=[NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    return [predicateEmail evaluateWithObject:Email];
}

-(BOOL)passwordCheck:(NSString *)Password{
    if (Password.length==0) {
        return NO;
    }
    if (Password.length<6) {
        return NO;
    }
    if(Password.length>16){
        return NO;
    }
    else{
//        NSString *str=@"^[A-Za-z0-9]+$";      //英文+字母，以字母开头
        NSString *str=@"[^\u4e00-\u9fa5]+$";    //不能包含汉字
        NSPredicate *regextestPSW= [NSPredicate predicateWithFormat:@"SELF MATCHES %@" ,str];
        if (![regextestPSW evaluateWithObject:Password]) {
            return NO;
        }
    }
    return YES;
}

-(BOOL)usernameCheck:(NSString *)UserName{
    if (UserName.length<4) {
        return NO;
    }
    if (UserName.length>12) {
        return NO;
    }
    NSString *str=@"^[A-Za-z0-9]+$";
    NSPredicate *usernamePre=[NSPredicate predicateWithFormat:@"SELF MATCHES %@",str];
    return [usernamePre evaluateWithObject:UserName];
}

-(BOOL)passwordCompareCheck:(NSString *)Password withRePeat:(NSString *)RePeat{
    if ([Password isEqualToString:RePeat]) {
        return YES;
    }else{
        return NO;
    }
}

-(BOOL)nicknameCheck:(NSString *)Nickname{
    if (Nickname.length==0){
        return NO;
    }else if (Nickname.length>10){
        return NO;
    }else{
        NSString *str=@"[\u4e00-\u9fa5a-zA-Z0-9]*";
        NSPredicate *nickNamePre=[NSPredicate predicateWithFormat:@"SELF MATCHES %@" ,str];
        if (![nickNamePre evaluateWithObject:Nickname]) {
            return NO;
        }
    }
    return YES;
}

@end
