//
//  ImageViewWithBtn.h
//  BabyShow
//
//  Created by Monica on 11/4/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageViewWithBtnDelegate <NSObject>

-(void)DeleteOnClick:(UIButton *) btn;

@end

@interface ImageViewWithBtn : UIImageView

@property (nonatomic, assign) id <ImageViewWithBtnDelegate> delegate;

@property (nonatomic, strong) UIButton *deleteBtn;

@end
