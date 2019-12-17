//
//  PhotosEditTextField.m
//  BabyShow
//
//  Created by Lau on 5/9/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PhotosEditTextField.h"

@implementation PhotosEditTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawPlaceholderInRect:(CGRect)rect

{
    
    NSDictionary *attribute=[NSDictionary dictionaryWithObjectsAndKeys:self.font,NSFontAttributeName,self.textColor,NSForegroundColorAttributeName, nil];
    [[self placeholder] drawInRect:rect withAttributes:attribute];
    
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
