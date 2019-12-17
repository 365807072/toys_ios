//
//  PostBarToolBarView.h
//  BabyShow
//
//  Created by Lau on 7/31/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PostBarToolBarViewStateNormal,
    PostBarToolBarViewStateUp,
} PostBarToolBarViewState;

typedef enum: NSUInteger {
    PostBarToolBarViewTypeNormal,
    PostBarToolBarViewTypeReply,
} PostBarToolBarViewType;

@protocol PostBarToolBarViewDelegate <NSObject>

-(void)takeAPhoto;
-(void)selectFromAlbum;
-(void)selectFromPhone;
-(void)addUrl;

-(void)selectGrow;
-(void)selectBabyLife;
-(void)selectOthers;

@end

@interface PostBarToolBarView : UIView

@property (nonatomic, assign) id<PostBarToolBarViewDelegate> delegate;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, assign) NSInteger state;
@property (nonatomic, strong) UIButton *linkBtn;

@property (nonatomic, strong) UIButton *lifeBtn;
@property (nonatomic, strong) UIButton *studyBtn;
@property (nonatomic, strong) UIButton *othersBtn;

-(id)initWithType:(NSInteger) type;

@end
