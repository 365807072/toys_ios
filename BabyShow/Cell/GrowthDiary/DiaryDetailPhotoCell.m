//
//  DiaryDetailPhotoCell.m
//  BabyShow
//
//  Created by Monica on 15-1-24.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "DiaryDetailPhotoCell.h"

@implementation DiaryDetailPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect photoViewFrame=CGRectMake(0, 0, 0, 0);
        self.imgBtn=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.imgBtn.frame=photoViewFrame;
        [self.imgBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.imgBtn];
        
        self.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.01
                              ];
        self.contentView.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.01];
        
    }
    return self;
}

-(void)OnClick:(btnWithIndexPath *) sender{
    
    if ([self.delegate respondsToSelector:@selector(showTheDetailOfThePhoto:)]) {
        [self.delegate showTheDetailOfThePhoto:sender];
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
