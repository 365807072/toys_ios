//
//  PostBarNewBasicItem.h
//  BabyShow
//
//  Created by Monica on 10/21/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PostBarNewBasicItem : NSObject

@property (nonatomic, strong) NSString *imgId;
@property (nonatomic, strong) NSString *post_create_time;
@property (nonatomic, strong) NSString *create_time;
@property (nonatomic, assign) BOOL isSaved;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, assign) BOOL  isAdmired;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *describe;
@property (nonatomic, strong) NSString *praiseCount;
@property (nonatomic, strong) NSString *reviewCount;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) BOOL isSigned;
@property(nonatomic,strong)NSString *videoUrl;

@end
