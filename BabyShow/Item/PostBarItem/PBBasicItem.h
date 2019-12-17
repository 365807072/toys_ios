//
//  PBBasicItem.h
//  BabyShow
//
//  Created by Lau on 6/5/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PBBasicItem : NSObject

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) NSString *identify;
@property (nonatomic, strong) NSString *imgid;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, assign) BOOL isSaved;
@property (nonatomic, strong) NSString *timeForPage;

@end
