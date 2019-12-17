//
//  ImageListScrollView.m
//  BabyShow
//
//  Created by Lau on 14-1-9.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ImageListScrollView.h"

@implementation ImageListScrollView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
//图片列表
-(id)initWithImageArray:(NSArray *)array withFrame:(CGRect)rect is_show_album:(BOOL)is_show_album{
    self  = [super initWithFrame:rect];
    if (self) {
        self.arrayImage = array;
        self.isEditing = NO;
        self.is_show_album = is_show_album;
        //初始化参数
        [self initParameter];
    }
    
    return self;
}
// 三列
-(void)initParameter{
    //每一列的视图初始化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeEditState:) name:@"changeEditState" object:nil];
    
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(5, 0, ImgWidth, 0)];
    self.centerView = [[UIView alloc]initWithFrame:CGRectMake(110, 0, ImgWidth, 0)];
    self.rightView = [[UIView alloc]initWithFrame:CGRectMake(215 , 0, ImgWidth, 0)];
    
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
    
    [self setContentSize:CGSizeMake(ImgWidth, highValue)];
    [self addSubview:self.leftView];
    [self addSubview:self.centerView];
    [self addSubview:self.rightView];

}
-(int)addViews:(NSDictionary *)imageDict
{
    
    //要添加到列上的视图对象
    LittleImageView *littleImageView = nil;
    //视图的高度
    float imageHeight = 0;
    
    switch (lowNum) {
        case 1:{
            littleImageView = [[LittleImageView alloc]initWithImageInfo:imageDict y:self.leftView.frame.size.height is_show_album:self.is_show_album atIndex:self.currentIndex];
            imageHeight = littleImageView.frame.size.height;//获取添加视图的高度,加在列视图的高度上
            self.leftView.frame = CGRectMake(self.leftView.frame.origin.x, self.leftView.frame.origin.y, ImgWidth, self.leftView.frame.size.height + imageHeight);
            [self.leftView addSubview:littleImageView];
        }
            break;
        case 2:{
            littleImageView = [[LittleImageView alloc]initWithImageInfo:imageDict y:self.centerView.frame.size.height is_show_album:self.is_show_album atIndex:self.currentIndex];
            imageHeight = littleImageView.frame.size.height;
            self.centerView.frame = CGRectMake(self.centerView.frame.origin.x, self.centerView.frame.origin.y, ImgWidth, self.centerView.frame.size.height + imageHeight);
            [self.centerView addSubview:littleImageView];
        }
            break;
        case 3:{
            littleImageView = [[LittleImageView alloc]initWithImageInfo:imageDict y:self.rightView.frame.size.height is_show_album:self.is_show_album atIndex:self.currentIndex];
            imageHeight = littleImageView.frame.size.height;
            self.rightView.frame = CGRectMake(self.rightView.frame.origin.x, self.rightView.frame.origin.y, ImgWidth, self.rightView.frame.size.height + imageHeight);
            [self.rightView addSubview:littleImageView];
        }
            break;

        default:
            break;
    }
    
    
    littleImageView.bigImageDelegate = self;
//    return littleImageView.tag;
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
    [self setContentSize:CGSizeMake(ImgWidth, highValue)];
    
}

//新版图片列表
/**
-(void)initParameter{
    //每一列的视图初始化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeEditState:) name:@"changeEditState" object:nil];
    
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 0)];
    self.centerView = [[UIView alloc]initWithFrame:CGRectMake(160, 0, 160, 0)];
    
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
    
    [self setContentSize:CGSizeMake(160, highValue)];
    [self addSubview:self.leftView];
    [self addSubview:self.centerView];
    
}
-(int)addViews:(NSDictionary *)imageDict
{
    
    //要添加到列上的视图对象
    LittleImageView *littleImageView = nil;
    //视图的高度
    float imageHeight = 0;
    
    switch (lowNum) {
        case 1:{
            littleImageView = [[LittleImageView alloc]initWithImageInfo:imageDict x:11 y:self.leftView.frame.size.height is_show_album:self.is_show_album atIndex:self.currentIndex];
            imageHeight = littleImageView.frame.size.height;//获取添加视图的高度,加在列视图的高度上
            self.leftView.frame = CGRectMake(self.leftView.frame.origin.x, self.leftView.frame.origin.y, 160, self.leftView.frame.size.height + imageHeight);
            [self.leftView addSubview:littleImageView];
        }
            break;
        case 2:{
            littleImageView = [[LittleImageView alloc]initWithImageInfo:imageDict x:6 y:self.centerView.frame.size.height is_show_album:self.is_show_album atIndex:self.currentIndex];
            imageHeight = littleImageView.frame.size.height;
            self.centerView.frame = CGRectMake(self.centerView.frame.origin.x, self.centerView.frame.origin.y, 160, self.centerView.frame.size.height + imageHeight);
            [self.centerView addSubview:littleImageView];
        }
            break;
        default:
            break;
    }
    
    
    littleImageView.bigImageDelegate = self;
    //    return littleImageView.tag;
    return [[imageDict objectForKey:@"img_id"] integerValue];
    
}

//获取最高列的高度,方便调整UIScrollView的contentsize使用
-(void)setHigherAndLower
{
    float leftHeight = self.leftView.frame.size.height;
    float centerHeight = self.centerView.frame.size.height;
    //比较哪一列是最高的那列，并记录最高的值highValue,记录目前较低的那一列lowNum;
    if (leftHeight > highValue) {
        highValue = leftHeight;
        lowNum = 2;
    }else {
        highValue = centerHeight;
        lowNum = 1;
    }

}

//刷新瀑布流
-(void)refreshView:(NSArray*)array
{
    [self.leftView removeFromSuperview];
    [self.centerView removeFromSuperview];
    self.leftView = nil;
    self.centerView =nil;
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
    [self setContentSize:CGSizeMake(160, highValue)];
    
}
*/
-(void)changeEditState:(NSNotification *)noti{
//NSLog(@"%s--row:%d",__FUNCTION__,__LINE__);
    self.isEditing = [[[noti userInfo] objectForKey:@"editing"] boolValue];
    BOOL refresh = [[[noti userInfo] objectForKey:@"refresh"] boolValue];
    NSMutableArray *subViews  = [NSMutableArray arrayWithArray:[self.leftView subviews]];
    subViews = (NSMutableArray *)[subViews arrayByAddingObjectsFromArray:[self.centerView subviews]];
    subViews = (NSMutableArray *)[subViews arrayByAddingObjectsFromArray:[self.rightView subviews]];
    if (self.isEditing) {
        for (int i =0; i < [subViews count]; i++) {
            LittleImageView *littleImageView = (LittleImageView *)[subViews objectAtIndex:i];
            UIImageView *checkImageView = (UIImageView *)[littleImageView viewWithTag:littleImageView.tag +1];
            checkImageView.hidden = NO;
            UIView *backGroundView = (UIView *)[littleImageView viewWithTag:littleImageView.tag +3];
            backGroundView.hidden = NO;
            //上提显示更多(refresh==no)的时候保持之前的选择状态
            if (refresh == YES) {
                littleImageView.is_selected = NO;
                backGroundView.backgroundColor =[UIColor clearColor];
                checkImageView.image =[UIImage imageNamed:@"unselected"];
            }
        }
    }else{
        for (int i =0; i < [subViews count]; i++) {
            LittleImageView *littleImageView = (LittleImageView *)[subViews objectAtIndex:i];
            UIImageView *checkImageView = (UIImageView *)[littleImageView viewWithTag:littleImageView.tag +1];
            UIView *backGroundView = (UIView *)[littleImageView viewWithTag:littleImageView.tag +3];
            checkImageView.hidden = YES;
            backGroundView.hidden = YES;

        }
    }
}
//代理
-(void)clickOnImage:(NSDictionary *)imageDict atIndex:(NSInteger)tapindex
{
    //自己做处理
    [self.imageDelegate clickToCheckBigImage:imageDict atIndex:tapindex];
}
////////////////////////////////////////////////////////////***/
#pragma mark - 广场的热门以及最新的列表 Methods
#pragma mark -

- (id)initWithImageArray:(NSArray *)array withFrame:(CGRect)rect{
    self = [super initWithFrame:rect];
    if (self) {
        self.arrayImage = array;
        [self initSquareParameter];
    }
    return  self;
}
-(void)initSquareParameter{
    //每一列的视图初始化
    
    self.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 160, 0)];
    self.centerView = [[UIView alloc]initWithFrame:CGRectMake(160, 0, 160, 0)];
    
    highValue =lowNum  = 1;
    self.currentIndex = 0;
    for (int i = 0; i<self.arrayImage.count; i++) {
        
        NSDictionary *dict = [self.arrayImage objectAtIndex:i];
        self.currentIndex = i;
        //添加视图
        self.last_id = [self addSquareViews:dict];
        //重新设置最高和最低view
        [self setSquareHigherAndLower];
    }
    
    [self setContentSize:CGSizeMake(160, highValue)];
    [self addSubview:self.leftView];
    [self addSubview:self.centerView];
    
}
-(int)addSquareViews:(NSDictionary *)imageDict
{
    
    //要添加到列上的视图对象
    HotAndNewView *hotAndNewView = nil;
    //视图的高度
    float imageHeight = 0;
    
    switch (lowNum) {
        case 1:{
            hotAndNewView = [[HotAndNewView alloc]initWithImageInfo:imageDict x:6 y:self.leftView.frame.size.height ];
            imageHeight = hotAndNewView.frame.size.height;//获取添加视图的高度,加在列视图的高度上
            self.leftView.frame = CGRectMake(self.leftView.frame.origin.x, self.leftView.frame.origin.y, 160, self.leftView.frame.size.height + imageHeight);
            [self.leftView addSubview:hotAndNewView];
        }
            break;
        case 2:{
            hotAndNewView = [[HotAndNewView alloc]initWithImageInfo:imageDict x:4 y:self.centerView.frame.size.height];
            imageHeight = hotAndNewView.frame.size.height;
            self.centerView.frame = CGRectMake(self.centerView.frame.origin.x, self.centerView.frame.origin.y, 160, self.centerView.frame.size.height + imageHeight);
            [self.centerView addSubview:hotAndNewView];
        }
            break;
        default:
            break;
    }
    
    
    hotAndNewView.delegate = self;
    return [[imageDict objectForKey:@"img_id"] intValue];
    
}

//获取最高列的高度,方便调整UIScrollView的contentsize使用
-(void)setSquareHigherAndLower
{
    float leftHeight = self.leftView.frame.size.height;
    float centerHeight = self.centerView.frame.size.height;
    //比较哪一列是最高的那列，并记录最高的值highValue,记录目前较低的那一列lowNum;
    if (leftHeight > highValue) {
        highValue = leftHeight;
        lowNum = 2;
    }else {
        highValue = centerHeight;
        lowNum = 1;
    }
    
}

//刷新瀑布流
-(void)refreshSquareView:(NSArray*)array
{
    [self.leftView removeFromSuperview];
    [self.centerView removeFromSuperview];
    self.leftView = nil;
    self.centerView =nil;
    self.arrayImage = array;
    [self initSquareParameter];
    
}
//加载下一页瀑布流
-(void)loadSquareNextPage:(NSMutableArray*)array firstIndex:(NSUInteger)index
{
    for (int i = 0; i<array.count; i++) {
        self.currentIndex = index + i;
        NSDictionary *data =[array objectAtIndex:i];
        //添加视图
        self.last_id = [self addSquareViews:data];
        //重新设置最高和最低view
        [self setSquareHigherAndLower];
    }
    [self setContentSize:CGSizeMake(160, highValue)];
    
}
#pragma mark - 热门和最新的点击 Methods
#pragma mark -
- (void)clickOnTheImageView:(NSDictionary *)imageDict{
    if ([self.imageDelegate respondsToSelector:@selector(clickToReviewActivityDetail:)]) {
        [self.imageDelegate clickToReviewActivityDetail:imageDict];
    }
}
-(void)clickOnTheAvatar:(NSString *)his_user_id{
    if ([self.imageDelegate respondsToSelector:@selector(clickToReviewUser:)]) {
        [self.imageDelegate clickToReviewUser:his_user_id];
    }
}
@end
