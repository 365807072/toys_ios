//
//  SpecialHeaderListImagesView.m
//  BabyShow
//
//  Created by Monica on 15-5-12.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "SpecialHeaderListImagesView.h"
//#import "UIImageView+AFNetworking.h"
//#import "SpecialTableViewController.h"

@implementation SpecialHeaderListImagesView

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
        [self addScrollView];
       // SpecialTableViewController *specialTableView = [[SpecialTableViewController alloc]init];
        
    }
    return self;
}
-(void)setHomeTopArray:(NSArray *)homeTopArray
{
    if (_homeTopArray == homeTopArray) {
        return;
    }
    _homeTopArray = homeTopArray;
    
    for (UIView *view in topNewScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i< 3 ;i++) {
        _topNewInfoModel = (SpecialHeadListModel*)_homeTopArray[i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.frame.size.width*i, 0,self.frame.size.width, self.frame.size.height)];
       //[imageView setImageWithURL:[NSURL URLWithString:_topNewInfoModel.image] placeholderImage:[UIImage imageNamed:@"img_myshow_titleview@2x.png"]];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [topNewScrollView addSubview:imageView];
        imageView.tag = 100+i;
    }
    _topNewInfoModel = (SpecialHeadListModel*)_homeTopArray[0];
    //SpecialTableViewController *specialTableView = [[SpecialTableViewController alloc]init];
    
}

-(void)addScrollView
{//轮播图
    topNewScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    topNewScrollView.backgroundColor=[UIColor clearColor];
    topNewScrollView.bounces=NO;
    topNewScrollView.pagingEnabled=YES;
    topNewScrollView.showsHorizontalScrollIndicator=NO;  //控制是否显示水平方向的滚动条, 默认显示
    topNewScrollView.delegate=self;
    topNewScrollView.contentSize=CGSizeMake(SCREENWIDTH*4, topNewScrollView.frame.size.height);
    [self addSubview:topNewScrollView];
    //pagecontrol
    topPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.frame.size.width*1/3,self.frame.size.height-20,80,10)];
   // CGRectMake(SCREENWIDTH_FIT*140,self.headerScrollView.frame.size.height-20,80,10)
    topPageControl.numberOfPages = 3;
    topPageControl.currentPageIndicatorTintColor = [UIColor redColor];
    topPageControl.pageIndicatorTintColor = [UIColor whiteColor];
    
    [self addSubview:topPageControl];
}

#pragma mark 自动轮播的方法
-(void)cycleScroll
{
    currentPage = topNewScrollView.contentOffset.x/self.frame.size.width;
    topPageControl.currentPage = currentPage;
    if (currentPage == _homeTopArray.count) {
        currentPage = 0;
    }else
    {
        currentPage++;
    }
    
    _topNewInfoModel = (SpecialHeadListModel*)_homeTopArray[currentPage];
    topNewScrollView.contentOffset = CGPointMake(topNewScrollView.frame.size.width*currentPage, 0);
    
}
-(void)startAnimation
{
    [self stopAnimation];
    timer = [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(cycleScroll) userInfo:nil repeats:YES];
}
-(void)stopAnimation
{
    if (timer&&[timer isValid]) {
        [timer invalidate];
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    currentPage  =topNewScrollView.contentOffset.x/self.frame.size.width;
    topPageControl.currentPage = currentPage;
}


@end
