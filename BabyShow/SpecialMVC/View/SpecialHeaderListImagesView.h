//
//  SpecialHeaderListImagesView.h
//  BabyShow
//
//  Created by Monica on 15-5-12.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialHeadListModel.h"

@interface SpecialHeaderListImagesView : UIView<UIScrollViewDelegate>
{
    UIScrollView *topNewScrollView;
    UIPageControl *topPageControl;
    NSInteger currentPage;
    NSTimer *timer;
    
}
@property(nonatomic,strong)NSArray *homeTopArray;
@property(nonatomic,strong)SpecialHeadListModel *topNewInfoModel;

-(void)startAnimation;
-(void)stopAnimation;


@end
