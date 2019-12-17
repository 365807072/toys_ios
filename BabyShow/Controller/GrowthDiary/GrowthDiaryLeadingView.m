//
//  GrowthDiaryLeadingView.m
//  BabyShow
//
//  Created by 于 晓波 on 15/4/26.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "GrowthDiaryLeadingView.h"

@implementation GrowthDiaryLeadingView

-(instancetype)init{
    
    self=[super init];
    
    self.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    
    UIImage *image=[UIImage imageNamed:@"img_growthdiary_leading"];
    
    self.imageView=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-image.size.width-40, 60, image.size.width, image.size.height)];
    self.imageView.image=image;
    [self addSubview:self.imageView];
    
    self.backgroundColor=[UIColor colorWithWhite:1.0 alpha:0.0];
    
    UIButton *Btn=[UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame=CGRectMake(SCREENWIDTH-image.size.width-40, 30+image.size.height, 40, 40);
    [Btn addTarget:self action:@selector(disappear) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:Btn];

    return self;
    
}


-(void)disappear{
    
    [self removeFromSuperview];
    
}

@end
