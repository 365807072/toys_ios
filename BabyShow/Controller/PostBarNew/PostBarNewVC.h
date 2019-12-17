//
//  PostBarNewVC.h
//  BabyShow
//
//  Created by Monica on 10/21/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostBarNewMakeAPost.h"
#import "PostMyInterestV3Cell.h"

typedef enum : NSUInteger {
    POSTBARNEWTYPEDEFAULT,  //话题列表
    POSTBARNEWTYPEMYFOUCUS, //收藏列表
} POSTBARNEWTYPE;

@interface PostBarNewVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic, strong) NSString *login_user_id;
@property (nonatomic, strong) NSString *post_create_time;
@property (nonatomic, strong) NSString *post_class;
@property (nonatomic, strong) NSString *create_time;
@property(nonatomic,assign)NSInteger page;
@property (nonatomic, assign) NSInteger type;
@property(nonatomic,assign)NSInteger post_classes;
@property(nonatomic,strong)NSString *isFromMain;
@property(nonatomic,strong)NSMutableDictionary *param;




@end
