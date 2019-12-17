//
//  ClickDescLabel.m
//  BabyShow
//
//  Created by Monica on 15-1-19.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ClickDescLabel.h"

@implementation ClickDescLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setUserInteractionEnabled:YES];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint points = [touch locationInView:self];
    if (points.x >= self.bounds.origin.x && points.y >= self.bounds.origin.x && points.x <= self.frame.size.width && points.y <= self.frame.size.height)
    {
        if ([_clickDelegate respondsToSelector:@selector(clickLabel:touchesWithIndexPath:)]) {
            [_clickDelegate clickLabel:self touchesWithIndexPath:self.indexPath];
        }
    }
}
@end
