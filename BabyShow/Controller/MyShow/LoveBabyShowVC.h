//
//  LoveBabyShowVC.h
//  BabyShow
//
//  Created by WMY on 16/4/11.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoveBabyShowVC : UIViewController<UIGestureRecognizerDelegate>
@property(nonatomic,strong)NSString *from;
@property(nonatomic,strong)UIButton *showBtn;
@property(nonatomic,strong)UIButton *babyBtn;
@property(nonatomic,assign)BOOL isBaby;
@property(nonatomic,strong)NSString *videoUrl;
@property(nonatomic,strong)NSMutableDictionary *param;
@property(nonatomic,strong)UIImageView *imgViewUpload;

@end
