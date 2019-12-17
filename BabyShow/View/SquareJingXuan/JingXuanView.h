//
//  JingXuanView.h
//  BabyShow
//
//  Created by Mayeon on 14-5-5.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JingXuanViewDelegate <NSObject>

@optional
-(void)onClickImageInfo:(NSDictionary *)imageInfo;

@end

@interface JingXuanView : UIView

@property (nonatomic) id<JingXuanViewDelegate>delegate;
@property (nonatomic,strong)NSDictionary *imageDict;
-(id)initWithImageInfo:(NSDictionary*)imageInfo x:(float)x y:(float)y;



@end
