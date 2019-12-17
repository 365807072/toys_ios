//
//  JingXuanScrollView.h
//  BabyShow
//
//  Created by Mayeon on 14-5-5.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JingXuanView.h"

#define JingXuanWidth   105

@protocol JingXuanScrollViewDelegate <NSObject>

@optional
- (void)scrollViewOnClickImageInfo:(NSDictionary *)imageInfo;

@end

@interface JingXuanScrollView : UIScrollView<JingXuanViewDelegate>
{
    //最高列高度(用于调整UIScrollView的contentSize)
    float highValue;
    //记录高(长)的那一列
    int lowNum;
}
//图像对象数组
@property (nonatomic,strong)NSArray *arrayImage;
//三列视图
@property (nonatomic ,strong)UIView *leftView;
@property (nonatomic ,strong)UIView *centerView;
@property (nonatomic ,strong)UIView *rightView;
@property (nonatomic ,weak)id<JingXuanScrollViewDelegate>imageDelegate;

@property (nonatomic)int first_id;  //  当前添加的所有图片的第一张图片的id(上翻时)
@property (nonatomic)int last_id;// 当前添加的最后一张图片的id(下翻页)
@property (nonatomic)NSUInteger currentIndex;

//初始化瀑布流，array图片对象数组
-(id)initWithImageArray:(NSArray*)array withFrame:(CGRect)rect;

//刷新瀑布流
-(void)refreshView:(NSArray*)array;
//加载下一页瀑布流
-(void)loadNextPage:(NSMutableArray*)array firstIndex:(NSUInteger)index;


@end
