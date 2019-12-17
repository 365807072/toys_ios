//
//  SpecailDetailModel.h
//  BabyShow
//
//  Created by WMY on 15/5/16.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecailDetailModel : NSObject
@property(nonatomic,strong)NSString *create_time;
@property(nonatomic,strong)NSString *img_id;
@property(nonatomic,strong)NSString *user_id;
@property(nonatomic,strong)NSString *img_description;
@property(nonatomic,strong)NSString *avatar;
@property(nonatomic,strong)NSString *nick_name;
@property(nonatomic,assign)BOOL is_admire;
@property(nonatomic,assign)BOOL is_focus;
@property(nonatomic,assign)NSInteger admire_count;
@property(nonatomic,assign)NSInteger review_count;
@property(nonatomic,assign)NSInteger interation_count;
@property(nonatomic,strong)NSString *level_img;
@property(nonatomic,assign)NSInteger recommend;
@property(nonatomic,strong)NSString *imgs;
@property(nonatomic,strong)NSString *avatars;




@end
