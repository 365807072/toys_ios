//
//  WorthBuyToolBarView.h
//  BabyShow
//
//  Created by Lau on 8/28/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    WorthBuyToolBarViewStateNormal,
    WorthBuyToolBarViewStateUp,
} WorthBuyToolBarViewState;

@protocol WorthBuyToolBarViewDelegate <NSObject>

-(void)takeAPhoto;
-(void)selectFromAlbum;
-(void)selectFromPhone;
-(void)addUrl;

-(void)selectLife;
-(void)selectStudy;
-(void)selectOthers;

@end

@interface WorthBuyToolBarView : UIView

@property (nonatomic, assign) id<WorthBuyToolBarViewDelegate> delegate;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) UIButton *linkBtn;

@property (nonatomic, strong) UIButton *lifeBtn;
@property (nonatomic, strong) UIButton *studyBtn;
@property (nonatomic, strong) UIButton *othersBtn;

@end
