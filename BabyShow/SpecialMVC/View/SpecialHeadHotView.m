//
//  SpecialHeadHotView.m
//  BabyShow
//
//  Created by Monica on 15-5-14.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "SpecialHeadHotView.h"
//#import "UIImageView+AFNetworking.h"

@implementation SpecialHeadHotView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self) {
        [self addViews];
        
    }
    return self;

}
-(void)addViews

{
    UILabel *hotLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 3, 13)];
    hotLabel.backgroundColor = KColorRGB(252, 87, 89, 1);
    [self addSubview:hotLabel];
    
    UILabel *hotSpecialLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 7, 100, 17)];
    hotSpecialLabel.text = @"热门主题";
    hotSpecialLabel.textColor = [UIColor redColor];
    hotSpecialLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:hotSpecialLabel];
    
    
    self.imageButtonBig = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imageButtonBig.frame = CGRectMake(5, 27, (SCREENWIDTH-15)*2/3, (SCREENWIDTH-15)*2/3+4);
    [self addSubview:self.imageButtonBig];
    self.labelBig = [[UILabel alloc]initWithFrame:CGRectMake(0, (SCREENWIDTH-15)*2/3+2-20,(SCREENWIDTH-15)*2/3, 22)];
    self.labelBig.backgroundColor = KColorRGB(0,0,0,0.5);
    self.labelBig.font = [UIFont systemFontOfSize:13];
    self.labelBig.text = @"宝宝秀一下";
    self.labelBig.textColor = KColorRGB(251,251,249,1);
    self.labelBig.textAlignment = NSTextAlignmentCenter;
    [self.imageButtonBig addSubview:self.labelBig];
    
    
    
    self.imageButtonUp = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imageButtonUp.frame = CGRectMake((SCREENWIDTH-15)*2/3+10, 27,(SCREENWIDTH-15)/3-2, (SCREENWIDTH-15)/3);
    [self addSubview:self.imageButtonUp];
    
    self.labelUp = [[UILabel alloc]initWithFrame:CGRectMake(0, (SCREENWIDTH-15)/3-20, (SCREENWIDTH-15)/3-2, 20)];
    self.labelUp.backgroundColor = KColorRGB(0,0,0,0.5);
    self.labelUp.font = [UIFont systemFontOfSize:12];
    self.labelUp.text = @"宝宝秀一下";
    self.labelUp.textColor = KColorRGB(251, 251, 249, 1);
    self.labelUp.textAlignment = NSTextAlignmentCenter;
    [self.imageButtonUp addSubview:self.labelUp];

    
    self.imageButtonDown = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imageButtonDown.frame = CGRectMake((SCREENWIDTH-15)*2/3+10, 27+4+(SCREENWIDTH-15)/3,(SCREENWIDTH-15)/3, (SCREENWIDTH-15)/3-2);
    self.imageButtonDown.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.imageButtonDown];
    self.labelDown = [[UILabel alloc]initWithFrame:CGRectMake(0, (SCREENWIDTH-15)/3-20, (SCREENWIDTH-15)/3, 20)];
    self.labelDown.backgroundColor = KColorRGB(0,0,0,0.5);
    self.labelDown.font = [UIFont systemFontOfSize:12];
    self.labelDown.text = @"宝宝秀一下";
    self.labelDown.textColor = KColorRGB(251, 251, 249, 1);
    self.labelDown.textAlignment = NSTextAlignmentCenter;
    [self.imageButtonDown addSubview:self.labelDown];
}
-(void)setSpecialHeadHotModel:(SpecialHeadHotModel *)specialHeadHotModel
{
    if (_specialHeadHotModel == specialHeadHotModel) {
        return;
    }
    _specialHeadHotModel = specialHeadHotModel;
    self.labelBig.text = [NSString stringWithFormat:@"%@",specialHeadHotModel.cate_name];

}

@end
