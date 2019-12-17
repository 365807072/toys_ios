//
//  HotAndNewView.h
//  BabyShow
//
//  Created by Mayeon on 14-5-8.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HotAndNewDelegate;

/**
 *  热门和最新的视图
 */
@interface HotAndNewView : UIView

@property (nonatomic) id<HotAndNewDelegate>delegate;

@property (nonatomic,strong)NSDictionary *imageDict;

-(id)initWithImageInfo:(NSDictionary*)imageInfo x:(float)x y:(float)y;

@end

@protocol HotAndNewDelegate <NSObject>

@optional
/**
 *  点击图片
 *
 *  @param imageDict 图片
 */
- (void)clickOnTheImageView:(NSDictionary *)imageDict;
/**
 *  点击头像
 *
 *  @param his_user_id 他的user_id
 */
- (void)clickOnTheAvatar:(NSString *)his_user_id;

@end