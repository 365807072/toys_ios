//
//  PostBarDetailPhotoCell.m
//  BabyShow
//
//  Created by Monica on 10/23/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarDetailPhotoCell.h"

@implementation PostBarDetailPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect photoViewFrame=CGRectMake(10*0.6, 5, 0, 0);
        self.imgBtn=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.imgBtn.frame=photoViewFrame;
        [self.imgBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.imgBtn];
        
    
    }
    return self;
}

-(void)OnClick:(btnWithIndexPath *) sender{
    
    if ([self.delegate respondsToSelector:@selector(showTheDetailOfThePhoto:)]) {
        [self.delegate showTheDetailOfThePhoto:sender];
    }
    
}

@end
