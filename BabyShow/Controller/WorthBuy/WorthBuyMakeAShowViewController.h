//
//  WorthBuyMakeAShowViewController.h
//  BabyShow
//
//  Created by Lau on 8/28/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WorthBuyToolBarView.h"
#import "ELCImagePickerController.h"
//老板发布值得买不用了
enum WORTHBUYADDATOPICTYPE{
    WORTHBUYADDATOPICDEFAULT=0,
    WORTHBUYADDATOPICWORTHBUY,
};

@protocol WorthBuyMakeAShowViewControllerDelegate <NSObject>

-(void)changeRefreshChannel:(NSString *) channel;

@end

@interface WorthBuyMakeAShowViewController : UIViewController<UITextViewDelegate,
WorthBuyToolBarViewDelegate,
ELCImagePickerControllerDelegate,
UIImagePickerControllerDelegate,
UIAlertViewDelegate>

@property (nonatomic, strong) NSMutableArray *photoArray;
@property (nonatomic, strong) NSString *rootImgId;
@property (nonatomic, strong) NSString *buy_class;
@property (nonatomic, assign) int type;
@property (nonatomic, assign) id <WorthBuyMakeAShowViewControllerDelegate> delegate;

-(void)makeImageViewsWithPhotosArray:(NSArray *) PhotoArray;

@end
