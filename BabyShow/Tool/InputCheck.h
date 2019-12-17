//
//  InputCheck.h
//  BabyShow
//
//  Created by Lau on 13-12-9.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InputCheck : NSObject
-(BOOL)emailChek:(NSString *) Email;
-(BOOL)phoneNumberCheck:(NSString *) PhoneNum;
-(BOOL)passwordCheck:(NSString *) Password;
-(BOOL)usernameCheck:(NSString *) UserName;
-(BOOL)passwordCompareCheck:(NSString *) Password withRePeat:(NSString *) RePeat;
-(BOOL)nicknameCheck:(NSString *) Nickname;
@end
