//
//  ImageListScrollView.h
//  BabyShow
//
//  Created by Lau on 14-1-9.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LittleImageView.h"
#import "HotAndNewView.h"

#define ImgWidth   100

@protocol ImageDelegate <NSObject>
@optional
-(void)clickToCheckBigImage:(NSDictionary *)imageDict atIndex:(NSUInteger)indexOfObject;

//广场热门和最新
//查看参与活动的秀秀内容
- (void)clickToReviewActivityDetail:(NSDictionary *)imageDict;
//查看参与活动的人
- (void)clickToReviewUser:(NSString *)user_id;
@end

@interface ImageListScrollView : UIScrollView<CheckOriginImage,HotAndNewDelegate>
{

    //最高列高度(用于调整UIScrollView的contentSize)
    float highValue;
    //记录高(长)的那一列
    int lowNum;

}
@property (nonatomic)id<ImageDelegate>imageDelegate;
//图像对象数组
@property (nonatomic,strong)NSArray *arrayImage;
//三列视图
@property (nonatomic ,strong)UIView *leftView;
@property (nonatomic ,strong)UIView *centerView;
@property (nonatomic ,strong)UIView *rightView;


@property (nonatomic)int first_id;  //  当前添加的所有图片的第一张图片的id(上翻时)
@property (nonatomic)int last_id;// 当前添加的最后一张图片的id(下翻页)
@property (nonatomic)NSUInteger currentIndex;

@property (nonatomic)BOOL isEditing;
@property (nonatomic)BOOL is_show_album; //秀秀相册不显示描述
//初始化瀑布流，array图片对象数组
-(id)initWithImageArray:(NSArray*)array withFrame:(CGRect)rect is_show_album:(BOOL)is_show_album;

//刷新瀑布流
-(void)refreshView:(NSArray*)array;
//加载下一页瀑布流
-(void)loadNextPage:(NSMutableArray*)array firstIndex:(NSUInteger)index;

////////////////////////////////////////////////////////////////////
//广场活动
-(id)initWithImageArray:(NSArray*)array withFrame:(CGRect)rect;
-(void)refreshSquareView:(NSArray*)array;
-(void)loadSquareNextPage:(NSMutableArray*)array firstIndex:(NSUInteger)index;
@end
