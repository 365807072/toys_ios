//
//  WorthBuyViewController.m
//  BabyShow
//
//  Created by Lau on 8/25/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "WorthBuyViewController.h"

#import "WorthBuyItem.h"
#import "WorthBuyImageItem.h"
#import "UserInfoManager.h"
#import "UIImageView+WebCache.h"
#import "UserInfoItem.h"
#import "PBHeaderViewItem.h"
#import "WebViewController.h"
#import "WorthBuyPublishViewController.h"
#import "BBSNavigationController.h"
#import "BBSNavigationControllerNotTurn.h"
#import "WorthBuyTodayItem.h"
#import "WorthBuyNewListItem.h"
#import "WorthBuyNewListCell.h"
#import "WorthBuyNewListImageItem.h"
#import "WorthBuyDetailListViewController.h"
#import "WorthBuyDetailListSegViewController.h"
//#import "WorthBuyDetailTableViewController.h"

#import "LoginHTMLVC.h"
#import "StoreDetailNewVC.h"




@interface WorthBuyViewController ()
{
    NSTimer *timer;                     //定时器，轮播图片
    NSTimer *requestTimer;              //请求换一组图的的定时器
    UIPageControl *pageControl;
    NSInteger currentPage;
}

@property (nonatomic, assign)BOOL isRefresh;
@property (nonatomic, assign)BOOL isGetMore;
@property (nonatomic, assign)BOOL isFinished;

@property (nonatomic, assign)NSInteger selectedIndex;
@property (nonatomic, assign)NSInteger post_class;

@property (nonatomic ,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *CategoryView;
@property(nonatomic,strong)UIView *viewOfHeader;
@property(nonatomic,strong)UIView *recommendView;
@property(nonatomic,strong)UIButton *buttonBig;
@property(nonatomic,strong)UILabel *labelBig;
@property(nonatomic,strong)UIButton *buttonUP;
@property(nonatomic,strong)UILabel *labelUP;
@property(nonatomic,strong)UIButton *buttonDown;
@property(nonatomic,strong)UILabel *labelDown;
@property(nonatomic,strong)UIButton *button1;
@property(nonatomic,strong)UIButton *button2;
@property(nonatomic,strong)UIButton *button3;
@property(nonatomic,strong)UIButton *button4;
@property(nonatomic,strong)UIButton *button6;
@property(nonatomic,strong)UIButton *button5;
@property(nonatomic,strong)UIButton *button7;
@property(nonatomic,strong)UIButton *button8;


@end

@implementation WorthBuyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _addTopicBtn.enabled=YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    
    //值得买列表数据：
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_WORTHBUYNEWLIST_DATA_SUCCEED  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_WORTHBUYNEWLIST_DATA_FAIL object:nil];
    
    if (_tableView) {
        [_tableView setTableHeaderView:_viewOfHeader];
    }
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.worthbuyHasNewTopic==YES) {
        
        delegate.worthbuyHasNewTopic=NO;
        [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        _isRefresh=1;
        self.last_id=NULL;
        _isFinished=0;
        [self getDataWithChannel];
        
    }
    
//    //5秒钟轮播
//    timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(slideTheCover) userInfo:nil repeats:YES];
//    //5分钟刷新人气宝宝
//    requestTimer = [NSTimer scheduledTimerWithTimeInterval:60*1 target:self selector:@selector(getShopData) userInfo:nil repeats:YES];
    self.tabBarController.tabBar.hidden = YES;

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets =NO;
    
    //[self setRightBtn];
    _selectedIndex=0;
    _post_class = 4;
    [self setBackBtn];
    [self setViewOfHeader];
    [self setCategoryView];
    [self setTodayRecommendView];
    [self setTableView];
    [self setHeaderView];

    _dataArray=[NSMutableArray array];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;

    if ((_tableView.pullToRefreshView)&& [_tableView.pullToRefreshView state] ==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    
    if (_tableView.infiniteScrollingView && [_tableView.infiniteScrollingView state]== SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    [LoadingView stopOnTheViewController:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    [timer invalidate];
    [requestTimer invalidate];
}

#pragma mark UI

//返回按钮
-(void)setBackBtn{
    
    //返回按钮
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    self.navigationItem.title = @"值得买";
    
}
//右边的编辑商品链接
-(void)setRightBtn{
    
    _addTopicBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _addTopicBtn.frame=CGRectMake(0, 0, 23, 34);
    [_addTopicBtn setBackgroundImage:[UIImage imageNamed:@"btn_postbar_reply_new"] forState:UIControlStateNormal];
    [_addTopicBtn addTarget:self action:@selector(addTopic) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn=[[UIBarButtonItem alloc]initWithCustomView:_addTopicBtn];
    self.navigationItem.rightBarButtonItem=rightBtn;
    
}

//tableview的头部，包括有轮播图，分类图，今日推荐
-(void)setViewOfHeader
{
    _viewOfHeader = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 475-73)];
}

-(void)setCategoryView
{
    
    _CategoryView = [[UIView alloc]initWithFrame:CGRectMake(0, 22, self.view.frame.size.width, 167)];

    _button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button1.frame = CGRectMake(23, 10, 39, 39);
    [_button1 setBackgroundImage:[UIImage imageNamed:@"btn_0-1 32"]forState:UIControlStateNormal];
    [_button1 addTarget:self action:@selector(pushViewControllerSegVC:) forControlEvents:UIControlEventTouchUpInside];
    [_CategoryView addSubview:_button1];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(24, 52, 38, 30)];
    label1.text = @"0-1岁";
    label1.textAlignment = NSTextAlignmentCenter;
    label1.font =[UIFont systemFontOfSize:13];
    [_CategoryView addSubview:label1];
    
    
    _button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button2.frame = CGRectMake(101, 10, 39, 39);
    [_button2 setBackgroundImage:[UIImage imageNamed:@"btn_1-2 32"]forState:UIControlStateNormal];
    [_button2 addTarget:self action:@selector(pushViewControllerSegVC:) forControlEvents:UIControlEventTouchUpInside];
    [_CategoryView addSubview:_button2];
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(102, 52, 38, 30)];
    label2.text = @"1-3岁";
    label2.textAlignment = NSTextAlignmentCenter;
    label2.font =[UIFont systemFontOfSize:13];
    [_CategoryView addSubview:label2];
    
    
    _button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button3.frame = CGRectMake(180, 10, 39, 39);
    [_button3 setBackgroundImage:[UIImage imageNamed:@"btn_3-6 32 "]forState:UIControlStateNormal];
    // [button1 addTarget:self action:@selector(<#selector#>) forControlEvents:<#(UIControlEvents)#>]
        [_button3 addTarget:self action:@selector(pushViewControllerSegVC:) forControlEvents:UIControlEventTouchUpInside];
    [_CategoryView addSubview:_button3];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(181, 52, 38, 30)];
    label3.text = @"3-6岁";
    label3.textAlignment = NSTextAlignmentCenter;
    label3.font =[UIFont systemFontOfSize:13];
    [_CategoryView addSubview:label3];
    
    
    _button4 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button4.frame = CGRectMake(260, 10, 39, 39);
    [_button4 setBackgroundImage:[UIImage imageNamed:@"btn_6"]forState:UIControlStateNormal];
    [_button4 addTarget:self action:@selector(pushViewControllerSegVC:) forControlEvents:UIControlEventTouchUpInside];
    [_CategoryView addSubview:_button4];
    UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(259, 52, 45,30)];
    label4.text = @"6-12岁";
    label4.textAlignment = NSTextAlignmentCenter;
    label4.font =[UIFont systemFontOfSize:13];
    [_CategoryView addSubview:label4];
    
    
    _button5 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button5.frame = CGRectMake(23, 84, 39, 39);
    [_button5 setBackgroundImage:[UIImage imageNamed:@"btn_yunma 32"]forState:UIControlStateNormal];
     //[button5 addTarget:self action:@selector(<#selector#>) forControlEvents:<#(UIControlEvents)#>]
    [_button5 addTarget:self action:@selector(pushViewControllerVC:) forControlEvents:UIControlEventTouchUpInside];
    [_CategoryView addSubview:_button5];
    UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(24, 126, 38, 30)];
    label5.text = @"孕妈";
    label5.textAlignment = NSTextAlignmentCenter;
    label5.font =[UIFont systemFontOfSize:13];
    [_CategoryView addSubview:label5];
    
    
_button6 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button6.frame = CGRectMake(101, 84, 39, 39);
    [_button6 setBackgroundImage:[UIImage imageNamed:@"btn_lama32 "]forState:UIControlStateNormal];
    [_button6 addTarget:self action:@selector(pushViewControllerSegVC:) forControlEvents:UIControlEventTouchUpInside];
    
    [_CategoryView addSubview:_button6];
    UILabel *label6 = [[UILabel alloc]initWithFrame:CGRectMake(102, 126, 38, 30)];
    label6.text = @"辣妈";
    label6.textAlignment = NSTextAlignmentCenter;
    label6.font =[UIFont systemFontOfSize:13];
    [_CategoryView addSubview:label6];
    _button7 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button7.frame = CGRectMake(180, 84, 39, 39);
    [_button7 setBackgroundImage:[UIImage imageNamed:@"btn_haitao 32"]forState:UIControlStateNormal];
    // [button1 addTarget:self action:@selector(<#selector#>) forControlEvents:<#(UIControlEvents)#>]
    [_button7 addTarget:self action:@selector(pushViewControllerVC:) forControlEvents:UIControlEventTouchUpInside];
    [_CategoryView addSubview:_button7];
    UILabel *label7 = [[UILabel alloc]initWithFrame:CGRectMake(181, 126, 38, 30)];
    label7.text = @"海淘";
    label7.textAlignment = NSTextAlignmentCenter;
    label7.font =[UIFont systemFontOfSize:13];
    [_CategoryView addSubview:label7];
    
    _button8 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button8.frame = CGRectMake(260, 84, 39, 39);
    [_button8 setBackgroundImage:[UIImage imageNamed:@"btn_jiaju 32 "]forState:UIControlStateNormal];
    // [button1 addTarget:self action:@selector(<#selector#>) forControlEvents:<#(UIControlEvents)#>]
    [_button8 addTarget:self action:@selector(pushViewControllerVC:) forControlEvents:UIControlEventTouchUpInside];
    [_CategoryView addSubview:_button8];
    UILabel *label8 = [[UILabel alloc]initWithFrame:CGRectMake(259, 126, 38, 30)];
    label8.text = @"家居";
    label8.textAlignment = NSTextAlignmentCenter;
    label8.font =[UIFont systemFontOfSize:13];
    [_CategoryView addSubview:label8];
    UILabel *labelBar = [[UILabel alloc]initWithFrame:CGRectMake(0, 160, SCREENWIDTH, 6)];
    labelBar.backgroundColor = [BBSColor hexStringToColor:@"#f4f4f4"];
    [_CategoryView addSubview:labelBar];
    
    [_viewOfHeader addSubview:_CategoryView];
}

-(void)setTodayRecommendView
{
    _todayViewDataArray = [NSMutableArray array];
    _recommendView = [[UIView alloc]initWithFrame:CGRectMake(0, 262-73, SCREENWIDTH, 209)];
   // _recommendView.backgroundColor = [UIColor greenColor];
    UILabel *todayLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 100, 30)];
    todayLabel.text = @"今日推荐";
    todayLabel.font = [UIFont systemFontOfSize:15];
    [_recommendView addSubview:todayLabel];
    
    _buttonBig = [UIButton buttonWithType:UIButtonTypeSystem];
    _buttonBig.frame = CGRectMake(5, 31, 188, 173);
    [_buttonBig addTarget:self action:@selector(pushViewControllerVC:) forControlEvents:UIControlEventTouchUpInside];

    [_recommendView addSubview:_buttonBig];
    _labelBig = [[UILabel alloc]initWithFrame:CGRectMake(0, 148, 188, 25)];
    _labelBig.textAlignment = NSTextAlignmentCenter;
    _labelBig.text = @"值得买";
    _labelBig.textColor = [UIColor whiteColor];
    _labelBig.backgroundColor = KColorRGB(0,0,0,0.5);
    [_buttonBig addSubview:_labelBig];
    
    
    
    _buttonUP = [UIButton buttonWithType:UIButtonTypeSystem];
    _buttonUP.frame = CGRectMake(196, 31, 119, 85);
    [_recommendView addSubview:_buttonUP];
    _labelUP = [[UILabel alloc]initWithFrame:CGRectMake(0, 72, 119, 13)];
    _labelUP.text = @"值得买";
    _labelUP.textAlignment = NSTextAlignmentCenter;
    _labelUP.textColor = [UIColor whiteColor];
    _labelUP.font = [UIFont systemFontOfSize:13];
    _labelUP.backgroundColor =KColorRGB(0,0,0,0.5);
    [_buttonUP addSubview:_labelUP];
    [_buttonUP addTarget:self action:@selector(pushViewControllerVC:) forControlEvents:UIControlEventTouchUpInside];


    
    _buttonDown = [UIButton buttonWithType:UIButtonTypeSystem];
    _buttonDown.frame = CGRectMake(196, 119, 119, 85);
    [_recommendView addSubview:_buttonDown];
    _labelDown = [[UILabel alloc]initWithFrame:CGRectMake(0, 72, 119, 13)];
    _labelDown.text = @"值得买";
    _labelDown.textAlignment = NSTextAlignmentCenter;
    _labelDown.textColor = [UIColor whiteColor];
    _labelDown.font = [UIFont systemFontOfSize:13];
    _labelDown.backgroundColor =KColorRGB(0,0,0,0.5);
    [_buttonDown addSubview:_labelDown];
    
    [_buttonDown addTarget:self action:@selector(pushViewControllerVC:) forControlEvents:UIControlEventTouchUpInside];
    [_viewOfHeader addSubview:_recommendView];
    [self getDataTodayWorthBuy];
    
}


-(void)setHeaderView{
    
    _headerViewDataArray=[[NSMutableArray alloc]init];
    CGRect headerFrame=CGRectMake(0, 0, VIEWWIDTH, 22);
    _headerView=[[UIImageView alloc]initWithFrame:headerFrame];
    _headerView.backgroundColor=[BBSColor hexStringToColor:@"e6e6e6"];
    _headerView.image = [UIImage imageNamed:@"img_buy_banar"];
    [_viewOfHeader addSubview:_headerView];
    //请求商家信息
   // [self getShopData];
}

//-(void)resetHeaderView{
//    
//    CGSize size=CGSizeMake(VIEWWIDTH * _headerViewDataArray.count, 22);
//    _headerView.contentSize=size;
//    [_headerView setContentOffset:CGPointZero];
//    for (UIView *subView in _headerView.subviews) {
//        [subView removeFromSuperview];
//    }
//    
//    for (int i=0;i<_headerViewDataArray.count;i++) {
//        
//        CGRect frame=CGRectMake(i*VIEWWIDTH, 0, VIEWWIDTH, 22);
//        UIImageView *imageView=[[UIImageView alloc]initWithFrame:frame];
//        imageView.userInteractionEnabled = YES;
//        imageView.tag = i + 100;
//        [_headerView addSubview:imageView];
//        
//        PBHeaderViewItem *item=[_headerViewDataArray objectAtIndex:i];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:item.business_img]];
//        
////        if (item.business_url.length > 0) {
//            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToDetail:)];
//            [imageView addGestureRecognizer:tapGes];
////        }
//    }
//    
//    
//}
//- (void)slideTheCover {
//    if (_headerViewDataArray.count <= 1) {
//        return;
//    }
//    CGPoint currentPoint = _headerView.contentOffset;
//    currentPage = currentPoint.x / VIEWWIDTH;
//    if (currentPage >= _headerViewDataArray.count-1) {
//        //最后一页,滚回最前端
//        [_headerView scrollRectToVisible:CGRectMake(0, 0, VIEWWIDTH, 95) animated:YES];
//    } else {
//        CGRect rect = CGRectMake(VIEWWIDTH*(currentPage+1), 0, VIEWWIDTH, 95);
//        [_headerView scrollRectToVisible:rect animated:YES];
//    }
//}
/*!
 *  值得买顶部商家详情
 *
 */
- (void)clickToDetail:(UITapGestureRecognizer *)tapGes {
    UIImageView *imageView = (UIImageView *)tapGes.view;
    NSUInteger index = imageView.tag;
    PBHeaderViewItem *item = [_headerViewDataArray objectAtIndex:index-100];
    NSString *business_img = item.business_img;
    NSString *business_url = item.business_url;
    NSString *business_id  = item.business_id;
    NSLog(@"_hearray = %@",_headerViewDataArray);
    
    if ([business_id isEqualToString:@"0" ]) {
        WebViewController *webView=[[WebViewController alloc]init];
        webView.urlStr=[business_url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        webView.imgThumb = business_img;
        webView.descript = @"";
        webView.img_id = item.shop_id;
        [webView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:webView animated:YES];

    }else{
        StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
        storeVC.business_id = business_id;
        storeVC.longin_user_id = LOGIN_USER_ID;
        [self.navigationController pushViewController:storeVC animated:YES];

    }
}

-(void)setTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];

    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.scrollsToTop=YES;
    [self.view addSubview:_tableView];

    [_tableView setTableHeaderView:_viewOfHeader];
    [self getDataWithChannel];
    
    __weak WorthBuyViewController *worthBuy=self;
    [_tableView addPullToRefreshWithActionHandler:^{
        
        worthBuy.isRefresh=1;
        worthBuy.last_id=NULL;
        worthBuy.isFinished=0;
        [worthBuy getDataWithChannel];
        [worthBuy getDataTodayWorthBuy];
        [worthBuy getShopData];
        
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        if (!worthBuy.isFinished) {
            if (worthBuy.tableView.pullToRefreshView.state==SVInfiniteScrollingStateStopped) {
                [worthBuy getDataWithChannel];
            }
        }else{
            if (worthBuy.tableView.infiniteScrollingView && worthBuy.tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
                [worthBuy.tableView.infiniteScrollingView stopAnimating];
            }
            
        }
        
    }];
    
}


#pragma mark Data
- (void)getShopData {
    [LoadingView startOntheView:_headerView];
    
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    
    [[HTTPClient sharedClient] getNew:kBusinessListV6 params:param success:^(NSDictionary *result) {
        [LoadingView stopOnTheView:_headerView];
        if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
            NSArray *data = [result objectForKey:kBBSData];
            [_headerViewDataArray removeAllObjects];
            for (NSDictionary *item in data) {
                PBHeaderViewItem *headerItem = [[PBHeaderViewItem alloc]init];
                headerItem.shop_id = [item objectForKey:@"img_id"];
                headerItem.business_img = [item objectForKey:@"album_img"];
                headerItem.business_url = [item objectForKey:@"business_url"];
                headerItem.business_id = [item objectForKey:@"business_id"];
                [_headerViewDataArray addObject:headerItem];
                
            }
           // [self resetHeaderView];
            
        } else {
            
        }
    } failed:^(NSError *error) {
        [LoadingView stopOnTheView:_headerView];
    }];
}
//今日推荐
-(void)getDataTodayWorthBuy
{
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    [[HTTPClient sharedClient]getNew:kShowBuyNewList params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue]==YES) {
            NSArray *data = [result objectForKey:kBBSData];
            [_todayViewDataArray removeAllObjects];
            NSMutableArray *imgsArray = [NSMutableArray array];

            for (NSDictionary *item in data) {
                WorthBuyTodayItem *todayItem = [[WorthBuyTodayItem alloc]init];
                todayItem.current_price = [item objectForKey:@"current_price"];
                [_todayViewDataArray addObject:todayItem.current_price];
                
                NSArray *imgArray = item[@"imgs"];
                NSDictionary *imgDic = imgArray[0];
                todayItem.img_thumb = imgDic[@"img_thumb"];
                [imgsArray addObject:todayItem.img_thumb];

            }
            
            SDWebImageManager *manager=[SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:imgsArray[0]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [_buttonBig setBackgroundImage:image forState:UIControlStateNormal];

            }];
            _labelBig.text = [NSString stringWithFormat:@"现价¥%@",_todayViewDataArray[0]];
            
            [manager downloadImageWithURL:[NSURL URLWithString:imgsArray[1]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [_buttonUP setBackgroundImage:image forState:UIControlStateNormal];
            }];
            _labelUP.text = [NSString stringWithFormat:@"现价¥%@",_todayViewDataArray[1]];
            
            [manager downloadImageWithURL:[NSURL URLWithString:imgsArray[2]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [_buttonDown setBackgroundImage:image forState:UIControlStateNormal];

            }];
            _labelDown.text = [NSString stringWithFormat:@"现价¥%@",_todayViewDataArray[2]];
           
        }
    } failed:^(NSError *error) {
        
    }];
    
}
//tableview的数据
-(void)getDataWithChannel{
    
    _addTopicBtn.enabled=NO;
    
    NetAccess *net=[NetAccess sharedNetAccess];
    
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.last_id,@"last_id", nil];
    [net getDataWithStyle:NetStyleBuyNewList andParam:param];
    
    [LoadingView startOnTheViewController:self];
    
}


-(void)getDataSucceed:(NSNotification *) not{
    
    _addTopicBtn.enabled=YES;
    
    [LoadingView stopOnTheViewController:self];
    
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    
    if (_isRefresh==1) {
        [_dataArray removeAllObjects];
        [_tableView reloadData];
        _isRefresh=0;
    }
    
    NSString *styleString=not.object;
    
    NetAccess *net=[NetAccess sharedNetAccess];
    
    NSArray *returnArray=[net getReturnDataWithNetStyle:[styleString intValue]];
    
    if (returnArray.count) {

        [_dataArray addObjectsFromArray:returnArray];
        [_tableView reloadData];
        WorthBuyNewListItem *item = [returnArray lastObject];
        self.last_id=[NSString stringWithFormat:@"%ld",(long)item.buy_List] ;
        
        
    }else{
        
        _isFinished=1;
        if (self.last_id) {
            [self showHUDWithMessage:@"已没有更多数据"];
        }else{
            [self showHUDWithMessage:@"还没有数据哦"];
        }
        
    }
    
}


-(void)getDataFail:(NSNotification *)not{
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }

    _addTopicBtn.enabled=YES;
    
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    
}

#pragma mark UITableViewDelegate



-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 175;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"WORTHBUYLIST";
    
    WorthBuyNewListCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[WorthBuyNewListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    WorthBuyNewListItem *item = [_dataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text = item.cate_name;
    WorthBuyNewListImageItem *imgItem1 = [item.imgs objectAtIndex:0];
    cell.firstNameLabel.text= imgItem1.img_description;

    cell.firstPriceLabel.text = [NSString stringWithFormat:@"¥%@",imgItem1.current_price];
    
    if (imgItem1.original_price.length <= 0) {
        cell.firstOriginLabel.text = nil;
    }else{
        NSDictionary *attibutes = @{NSFontAttributeName:cell.firstPriceLabel.font};
        CGSize size = [cell.firstPriceLabel.text sizeWithAttributes:attibutes];
        CGRect originFrame = cell.firstOriginLabel.frame;
        originFrame.origin.x = cell.firstPriceLabel.frame.origin.x+size.width+5;
        cell.firstOriginLabel.frame = CGRectMake(105-50, 130, 50, 14);
        cell.firstOriginLabel.text = [NSString stringWithFormat:@"¥%@", imgItem1.original_price];

        
    }
    
   SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:imgItem1.img_thumb] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        cell.firstImageView.image = image;

    }];
    WorthBuyNewListImageItem *imgItem2 = [item.imgs objectAtIndex:1];
    cell.secondNameLabel.text= imgItem2.img_description;
    cell.SPriceLabel.text = [NSString stringWithFormat:@"¥%@",imgItem2.current_price];
    
    if (imgItem2.original_price.length <= 0) {
        cell.SOriginLabel.text = nil;
    }else{
        NSDictionary *attibutes = @{NSFontAttributeName:cell.SPriceLabel.font};
        CGSize size = [cell.SPriceLabel.text sizeWithAttributes:attibutes];
        CGRect originFrame = cell.SOriginLabel.frame;
        originFrame.origin.x = cell.SPriceLabel.frame.origin.x+size.width+5;
        cell.SOriginLabel.frame = CGRectMake(210-50, 130, 50, 14);
            cell.SOriginLabel.text =[NSString stringWithFormat:@"¥%@", imgItem2.original_price];
        
        
    }
    [manager downloadImageWithURL:[NSURL URLWithString:imgItem2.img_thumb] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        cell.secondimageView.image = image;
    }];

    WorthBuyNewListImageItem *imgItem3 = [item.imgs objectAtIndex:2];
    cell.thirdNameLabel.text= imgItem3.img_description;
    cell.TPriceLabel.text = [NSString stringWithFormat:@"¥%@",imgItem3.current_price];
    
    if (imgItem3.original_price.length <= 0) {
        cell.TOriginLabel.text = nil;
    }else{
        NSDictionary *attibutes = @{NSFontAttributeName:cell.TPriceLabel.font};
        CGSize size = [cell.TPriceLabel.text sizeWithAttributes:attibutes];
        CGRect originFrame = cell.TOriginLabel.frame;
        originFrame.origin.x = cell.TPriceLabel.frame.origin.x+size.width+5;
        cell.TOriginLabel.frame = CGRectMake(315-50, 130, 50, 14);
        cell.TOriginLabel.text =[NSString stringWithFormat:@"¥%@", imgItem3.original_price];

        
    }

    [manager downloadImageWithURL:[NSURL URLWithString:imgItem3.img_thumb] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        cell.thirdImageView.image = image;
    }];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WorthBuyNewListItem *item=[_dataArray objectAtIndex:indexPath.row];
    
    WorthBuyDetailListViewController *detailVC = [[WorthBuyDetailListViewController alloc]init];
    detailVC.buy_list = item.buy_List;
    detailVC.title = item.cate_name;
    detailVC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:detailVC animated:YES];
    
}

-(void)pushViewControllerVC:(id)sender
{
        WorthBuyDetailListViewController *detailVC = [[WorthBuyDetailListViewController alloc]init];
    UIButton *button = sender;
    if (button == _button5) {
        detailVC.buy_list = 6;
        detailVC.title = @"孕妈";
    }else if(button == _button7)
    {
        detailVC.buy_list = 7;
        detailVC.title = @"海淘";
        
    }
    else if(button == _button8)
    {
        detailVC.buy_list = 5;
        detailVC.title = @"家居";
    }
    else{
        detailVC.buy_list =1;
    
    detailVC.title = @"今日推荐";
    }
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
-(void)pushViewControllerSegVC:(id)sender
{
    WorthBuyDetailListSegViewController *detailSegVC = [[WorthBuyDetailListSegViewController alloc]init];
    if (sender == _button1) {
        detailSegVC.buy_type = 1;
        detailSegVC.title = @"0-1岁";
    }
    else  if (sender == _button2) {
        detailSegVC.buy_type = 2;
        detailSegVC.title = @"1-3岁";
    }else  if (sender == _button3) {
        detailSegVC.buy_type = 3;
        detailSegVC.title = @"3-6岁";
    }else  if (sender == _button4) {
        detailSegVC.buy_type = 4;
        detailSegVC.title = @"6-12岁";
    }else if(sender == _button6)
    {
        detailSegVC.buy_type = 5;
        detailSegVC.title = @"辣妈";
    }
    detailSegVC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:detailSegVC animated:YES];
    
}


#pragma mark private

-(void)addTopic{
    
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    
    if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
        
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];

        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
        return;
    }
    
    WorthBuyPublishViewController *post = [[WorthBuyPublishViewController alloc]init];
    BBSNavigationControllerNotTurn *nav=[[BBSNavigationControllerNotTurn alloc]initWithRootViewController:post];
    [self presentViewController:nav animated:YES completion:^{}];
    
}




#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 100) {
        if (buttonIndex==1) {
            
            AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate setStartViewController];
            
        }
    }
    
    
}
#pragma mark HUD

-(void)showHUDWithMessage:(NSString *)message{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60,64+20+50+50+50+5 , 200, 30)];
    label.backgroundColor = [UIColor darkGrayColor];
    label.layer.cornerRadius = 3.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:13];
    label.alpha=0.5;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [self.view addSubview:label];
    [UIView commitAnimations];
    [self performSelector:@selector(remove:) withObject:label afterDelay:1.5];
    
}
-(void)remove:(UILabel *)label{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [label removeFromSuperview];
    [UIView commitAnimations];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)netFail{
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }

    [LoadingView stopOnTheViewController:self];
    
}


@end
