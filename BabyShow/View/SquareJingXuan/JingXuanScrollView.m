//
//  JingXuanScrollView.m
//  BabyShow
//
//  Created by Mayeon on 14-5-5.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "JingXuanScrollView.h"

@implementation JingXuanScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithImageArray:(NSArray *)array withFrame:(CGRect)rect{
    self = [super initWithFrame:rect];
    if (self) {
        self.arrayImage = array;
        [self initParameter];
    }
    return self;
}
-(void)initParameter{
    //每一列的视图初始化
    
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 2.5, JingXuanWidth, 0)];
    self.centerView = [[UIView alloc]initWithFrame:CGRectMake(107.5, 2.5, JingXuanWidth, 0)];
    self.rightView = [[UIView alloc]initWithFrame:CGRectMake(215 , 2.5, JingXuanWidth, 0)];
    
    highValue =lowNum  = 1;
    self.currentIndex = 0;
    for (int i = 0; i<self.arrayImage.count; i++) {
        
        NSDictionary *dict = [self.arrayImage objectAtIndex:i];
        self.currentIndex = i;
        //添加视图
        self.last_id = [self addViews:dict];
        //重新设置最高和最低view
        [self setHigherAndLower];
    }
    
    [self setContentSize:CGSizeMake(JingXuanWidth, highValue)];
    [self addSubview:self.leftView];
    [self addSubview:self.centerView];
    [self addSubview:self.rightView];
    
}
-(int)addViews:(NSDictionary *)imageDict
{
    
    //要添加到列上的视图对象
    JingXuanView *littleImageView = nil;
    //视图的高度
    float imageHeight = 0;
    
    switch (lowNum) {
        case 1:{
            littleImageView = [[JingXuanView alloc]initWithImageInfo:imageDict x:0 y:self.leftView.frame.size.height];
            imageHeight = littleImageView.frame.size.height;//获取添加视图的高度,加在列视图的高度上
            self.leftView.frame = CGRectMake(self.leftView.frame.origin.x, self.leftView.frame.origin.y, JingXuanWidth, self.leftView.frame.size.height + imageHeight + 2.5);
            [self.leftView addSubview:littleImageView];
        }
            break;
        case 2:{
            littleImageView = [[JingXuanView alloc]initWithImageInfo:imageDict x:0 y:self.centerView.frame.size.height ];
            imageHeight = littleImageView.frame.size.height;
            self.centerView.frame = CGRectMake(self.centerView.frame.origin.x, self.centerView.frame.origin.y, JingXuanWidth, self.centerView.frame.size.height + imageHeight+ 2.5);
            [self.centerView addSubview:littleImageView];
        }
            break;
        case 3:{
            littleImageView = [[JingXuanView alloc]initWithImageInfo:imageDict x:0 y:self.rightView.frame.size.height];
            imageHeight = littleImageView.frame.size.height;
            self.rightView.frame = CGRectMake(self.rightView.frame.origin.x, self.rightView.frame.origin.y, JingXuanWidth, self.rightView.frame.size.height + imageHeight+ 2.5);
            [self.rightView addSubview:littleImageView];
        }
            break;
            
        default:
            break;
    }
    littleImageView.delegate = self;

    return [[imageDict objectForKey:@"img_id"] intValue];
    
}

//获取最高列的高度,方便调整UIScrollView的contentsize使用
-(void)setHigherAndLower
{
    float leftHeight = self.leftView.frame.size.height;
    float centerHeight = self.centerView.frame.size.height;
    float rightHeight = self.rightView.frame.size.height;
    //比较哪一列是最高的那列，并记录最高的值highValue,记录目前较低的那一列lowNum;
    if (leftHeight > highValue) {
        highValue = leftHeight;
    }else if (centerHeight > highValue){
        highValue = centerHeight;
    }else if(rightHeight > highValue ){
        highValue = rightHeight;
    }
    
    //找了最低列
    if (leftHeight <= centerHeight) {
        if (leftHeight <= rightHeight) {
            lowNum = 1;
        }else {
            lowNum = 3;
        }
    }else{
        if (centerHeight <= rightHeight) {
            lowNum = 2;
        }else{
            lowNum = 3;
        }
    }
    
}

//刷新瀑布流
-(void)refreshView:(NSArray*)array
{
    [self.leftView removeFromSuperview];
    [self.centerView removeFromSuperview];
    [self.rightView removeFromSuperview];
    self.leftView = nil;
    self.centerView =nil;
    self.rightView = nil;
    self.arrayImage = array;
    [self initParameter];
    
}
//加载下一页瀑布流
-(void)loadNextPage:(NSMutableArray*)array firstIndex:(NSUInteger)index
{
    for (int i = 0; i<array.count; i++) {
        self.currentIndex = index + i;
        NSDictionary *data =[array objectAtIndex:i];
        //添加视图
        self.last_id = [self addViews:data];
        //重新设置最高和最低view
        [self setHigherAndLower];
    }
    [self setContentSize:CGSizeMake(JingXuanWidth, highValue)];
    
}
#pragma mark - 点击代理 Methods
- (void)onClickImageInfo:(NSDictionary *)imageInfo{
    if ([self.imageDelegate respondsToSelector:@selector(scrollViewOnClickImageInfo:)]) {
        [self.imageDelegate scrollViewOnClickImageInfo:imageInfo];
    }
}
@end
