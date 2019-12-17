//
//  ImageViewWithBtn.m
//  BabyShow
//
//  Created by Monica on 11/4/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "ImageViewWithBtn.h"

@implementation ImageViewWithBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        self.deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.deleteBtn.frame=CGRectMake(0, 0, 32, 32);
        [self.deleteBtn setBackgroundImage:[UIImage imageNamed:@"btn_postbar_new_delete_photo"] forState:UIControlStateNormal];
        [self.deleteBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.deleteBtn];
        
        self.deleteBtn.center=CGPointMake(self.frame.size.width-10, 3);
        
        self.userInteractionEnabled=YES;
    
    }
    return self;
}

-(void)btnOnClick:(UIButton *) btn{
    
    if ([self.delegate respondsToSelector:@selector(DeleteOnClick:)]) {
        [self.delegate DeleteOnClick:btn];
    }
    
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
