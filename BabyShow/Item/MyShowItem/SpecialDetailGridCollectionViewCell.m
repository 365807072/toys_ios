//
//  SpecialDetailGridCollectionViewCell.m
//  BabyShow
//
//  Created by WMY on 15/5/18.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "SpecialDetailGridCollectionViewCell.h"
//#import "UIImageView+AFNetworking.h"
#import "UIImageView+WebCache.h"

@implementation SpecialDetailGridCollectionViewCell
-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.photoImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,self.bounds.size.width, self.bounds.size.width)];
       
        [self.contentView addSubview:self.photoImage];
        
        self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(2, 2, 30, 30)];
        self.numberLabel.backgroundColor = KColorRGB(0,0,0,0.5);
        self.numberLabel.textColor = [UIColor whiteColor];
        self.numberLabel.font = [UIFont systemFontOfSize:15];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.layer.masksToBounds = YES;
        self.numberLabel.layer.cornerRadius = 16.5;
        
        [self.photoImage addSubview:self.numberLabel];
  self.contentView.backgroundColor = [UIColor clearColor];
        
        
        
        
    }
    return self;
}
-(void)setSpecialDetailGrid:(SpecialDetailGridItem *)specialDetailGrid
{
    if (_specialDetailGrid == specialDetailGrid) {
        return;
    }
    _specialDetailGrid = specialDetailGrid;
    self.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)specialDetailGrid.rsort];
[self.photoImage sd_setImageWithURL:[NSURL URLWithString:specialDetailGrid.img_thumb]];
    
}


@end
