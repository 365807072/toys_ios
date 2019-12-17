//
//  ImageView.m
//  BabyShow
//
//  Created by Mayeon on 14-3-3.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ImageView.h"

@implementation ImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.imageInfo = [[NSDictionary alloc]init];
        
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
