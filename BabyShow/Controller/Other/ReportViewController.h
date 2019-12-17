//
//  ReportViewController.h
//  BabyShow
//
//  Created by Lau on 14-1-10.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportViewController : UIViewController<UITextViewDelegate>


@property (nonatomic, strong) UITextView *contentView;
@property (nonatomic, strong) NSString *imgId;
@end
