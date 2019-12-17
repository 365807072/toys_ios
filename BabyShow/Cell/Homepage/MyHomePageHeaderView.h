//
//  MyHomePageHeaderView.h
//  BabyShow
//
//  Created by Lau on 14-1-2.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyHomePageHeaderViewDelegate <NSObject>

-(void)addAChild;
- (void)channelSelect:(NSInteger )tag;

@end


@interface MyHomePageHeaderView : UITableViewHeaderFooterView


@property (nonatomic, strong) UIImageView *avatarImgView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *kidsMesLabel;
@property (nonatomic, strong) UIButton *addKidBtn;

@property (nonatomic, strong) UIView *seperateView2;

@property (nonatomic, assign) id <MyHomePageHeaderViewDelegate> delegate;

-(id)initWithDetails:(NSDictionary *) Detail;

@end
