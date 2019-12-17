//
//  PostBarNewVC.m
//  BabyShow
//
//  Created by Monica on 10/21/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarNewVC.h"
#import "PostBarNewWithImageCell.h"
#import "PostBarNewWithOutImageCell.h"
#import "PostBarWithPhotoItem.h"
#import "PostBarWithOutPhotoItem.h"
#import "UserInfoItem.h"
#import "SVPullToRefresh.h"
#import "PostBarHeaderItem.h"
#import "UIImageView+WebCache.h"
#import "PostMyInterestCell.h"
#import "PostMyInterestItem.h"
#import "PostMyGroupDetailVController.h"
#import "PostBarSecondeVC.h"
#import "PostMyInterestV3Item.h"
#import "PostBarMoreViewController.h"
#import "WMYLabel.h"
#import "StoreMoreListVC.h"
#import "YLButton.h"
#import "LoginHTMLVC.h"
#import "PostBarNewDetialV1VC.h"
#import "BBSCommonNavigationController.h"
#import "BabyShowPlayerVC.h"
#import "StoreDetailNewVC.h"
#import "YLImageView.h"
#import "YLGIFImage.h"
#import "PostBarGroupNewVC.h"
#import "PostBarNewGroupOnlyOneVC.h"

@interface PostBarNewVC ()<UISearchBarDelegate>
{
    //搜索结果
    UITableView *searchResultsTableView;
    UISearchBar *theSearchBar;
    NSArray *searchResultsArray;
    
    UITableView *_tableView;
    UITableView *_categoryTableV;
    UIView *_headerView;
    UIScrollView *_headerScrollView;
    UIScrollView *_btnScrollView;
    UIButton *_selectBtn;
    UIButton *_FTBtn;
    UIView *_emptyView;
    UIButton *topBtn;
    
    BOOL _isRefresh;
    BOOL _isGetMore;
    BOOL _isFinished;
    BOOL _isHideCategory;//隐藏分类
    
    NSMutableArray *_dataArray;
    NSMutableArray *_fouceDataArray;
    NSArray *_headerViewArray;
    NSArray *_categoryArray;
    
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) BOOL isGetMore;
@property (nonatomic, assign) BOOL isFinished;
@property(nonatomic,strong)YLButton *button1;//我的兴趣
@property(nonatomic,strong)YLButton *button2;//成长记录
@property(nonatomic,strong)YLButton *button3;//育儿知识
@property(nonatomic,strong)YLButton *button4;//时尚情感
@property(nonatomic,strong)YLButton *button5;//辣妈厨房
@property(nonatomic,strong)YLButton *button6;//视频
@property(nonatomic,strong)NSArray *buttonsArray;//button按钮的数组
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)NSArray *imagesArray;
@property(nonatomic,strong)UIPageControl *topPageControl;
@property(nonatomic,strong)NSMutableArray *imgsForPushArray;//存放跳转数据
@property(nonatomic,strong)UIButton *tapButton;
@property(nonatomic,strong)UIImageView *imgStore1;
@property(nonatomic,strong)UIImageView *imgStore2;
@property(nonatomic,strong)UILabel *labelStoreBabyPrice1;
@property(nonatomic,strong)UILabel *labelStoreBabyPrice2;
@property(nonatomic,strong)UILabel *labelStoreprice1;
@property(nonatomic,strong)UILabel *labelStoreprice2;
@property(nonatomic,strong)WMYLabel *labelStoreName1;
@property(nonatomic,strong)UILabel *labelStoreName2;
@property(nonatomic,strong)NSMutableArray *storeArray;
@property(nonatomic,strong)NSString *imgId1;
@property(nonatomic,strong)NSString *imgId2;
@property(nonatomic,assign)BOOL is_bjCity;
@property(nonatomic,strong)UIView *backview;
@property(nonatomic,strong)BBSCommonNavigationController *bbsComNav;
@property (nonatomic,strong)YLImageView *ylIamgeView;

@end

@implementation PostBarNewVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil//1
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray=[NSMutableArray array];
        _categoryArray = [[NSArray alloc] init];
        _storeArray = [NSMutableArray array];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{//1
    
    [super viewWillAppear:animated];
    if (theSearchBar && [theSearchBar isHidden]) {
        [theSearchBar setHidden:NO];
    }
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_POSTMYINTEREST_GET_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_POSTMYINTEREST_GET_FAIL object:nil];
    
    
    //相册数据
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHeaderViewSucceed:) name:USER_POSTBAR_GET_HEADER_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getHeaderViewFail:) name:USER_POSTBAR_GET_HEADER_FAIL object:nil];
 
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(makeApostSucceed) name:USER_POSTBAR_NEW_MAKE_A_POST_SUCCEED object:nil];
    
  
     self.tabBarController.tabBar.hidden = YES;
    self.post_classes =0;
    if ([self.isFromMain isEqualToString:@"isFromMain"]) {
        self.bbsComNav.isNotGoBack = YES;
    }
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.isHaveUpLoadPost == YES) {
        _ylIamgeView = [[YLImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH-60,80, 39, 39)];
        _ylIamgeView.image = [YLGIFImage imageNamed:@"up_show.gif"];
        [self.view addSubview:_ylIamgeView];
        delegate.isHaveUpLoadPost = NO;
    }


}
-(void)makeApostSucceed{
    [_ylIamgeView removeFromSuperview];
    NSLog(@"这个通知为什么不走");

//    _isRefresh=1;
//    _isGetMore=NO;
//    _isFinished=NO;
//    _page = 1;
//    self.post_create_time = NULL;
//    [_dataArray removeAllObjects];
//    [self getDataWithButton];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.bbsComNav = (BBSCommonNavigationController*)self.navigationController;
    _isHideCategory = YES;
    self.page =1;
    self.post_classes = 0;
    self.automaticallyAdjustsScrollViewInsets=NO;
    if (self.type==POSTBARNEWTYPEDEFAULT) {
        [self setHeaderView];
        [self setLeftButton];
        [self setTableView];
        [self setSearchBtn];
        [self setRightButton];
        self.navigationItem.title = @"热点";
        
    }else{
        [self setLeftButton];
        [self setTableView];
        self.navigationItem.title=@"收藏";
    }
}

-(void)viewWillDisappear:(BOOL)animated{//1
    
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    _isHideCategory = YES;
    
    self.bbsComNav.isNotGoBack = NO;

    [_categoryTableV setHidden:_isHideCategory];
    
    if ((_tableView.pullToRefreshView)&& [_tableView.pullToRefreshView state] ==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && [_tableView.infiniteScrollingView state]== SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    [LoadingView stopOnTheViewController:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.navigationController.navigationBarHidden = NO;
    if (searchResultsTableView) {
        [searchResultsTableView removeFromSuperview];
        searchResultsTableView = nil;
    }
    if (theSearchBar) {
        [theSearchBar removeFromSuperview];
        theSearchBar = nil;
    }
    [self removeDimBackground];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark UI

-(void)setHeaderView{
    float headerviewheight = SCREENWIDTH/3+90;
    float headerviewwidth = SCREENWIDTH;
    CGRect headerViewFrame = CGRectMake(0, 0, headerviewwidth, headerviewheight);
    CGRect headerScrollViewFrame = CGRectMake(0, 0, headerviewwidth, headerviewheight-2-90);
    
    _headerView = [[UIView alloc]initWithFrame:headerViewFrame];
    _headerView.backgroundColor = [UIColor clearColor];
    
    _headerScrollView = [[UIScrollView alloc]initWithFrame:headerScrollViewFrame];
    _headerScrollView.backgroundColor = [UIColor clearColor];
    _headerScrollView.pagingEnabled = YES;
    _headerScrollView.showsHorizontalScrollIndicator = NO;
    _headerScrollView.showsVerticalScrollIndicator = NO;
    _headerScrollView.bounces = YES;
    _headerScrollView.delegate = self;
    [_headerView addSubview:_headerScrollView];
    
    _btnScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, headerviewheight-2-90, SCREENWIDTH,87)];
    _btnScrollView.pagingEnabled = NO;
    _btnScrollView.showsHorizontalScrollIndicator = NO;
    _btnScrollView.showsVerticalScrollIndicator = NO;
    _btnScrollView.bounces = YES;
    _btnScrollView.delegate = self;
    _btnScrollView.contentSize = CGSizeMake(SCREENWIDTH, 87);
    
    [_headerView addSubview:_btnScrollView];
    
    UIImage *image1 = [UIImage imageNamed:@"btn_wodexingques"];
    UIImage *image2 = [UIImage imageNamed:@"btn_huodongs"];
    UIImage *image3 = [UIImage imageNamed:@"btn_zhishis"];
    UIImage *image4 = [UIImage imageNamed:@"btn_qinggans"];
    UIImage *image5 = [UIImage imageNamed:@"btn_chufangs"];
   // UIImage *image6 = [UIImage imageNamed:@"btn_vedios"];
    
    _imageArray = [[NSArray alloc]initWithObjects:image1,image2,image3,image4,image5, nil];
    UIImage *images1 = [UIImage imageNamed:@"btn_wodexingque"];
    UIImage *images2 = [UIImage imageNamed:@"btn_huodong"];
    UIImage *images3 = [UIImage imageNamed:@"btn_zhishi"];
    UIImage *images4 = [UIImage imageNamed:@"btn_qinggan"];
    UIImage *images5 = [UIImage imageNamed:@"btn_chufang"];
    //UIImage *images6 = [UIImage imageNamed:@"btn_vedio"];
    _imagesArray = [[NSArray alloc]initWithObjects:images1,images2,images3,images4,images5, nil];
    
    _button1 = [YLButton buttonEasyInitBackColor:nil frame:CGRectMake(12, 15, 40, 57) type:UIButtonTypeSystem backImage:[UIImage imageNamed:@"btn_wodexingques"] target:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _button1.tag = 300;
    [_btnScrollView addSubview:_button1];
    
    
    _button2 = [YLButton buttonEasyInitBackColor:nil frame:CGRectMake(_button1.frame.origin.x+40+24, _button1.frame.origin.y, 40, 57) type:UIButtonTypeSystem backImage:[UIImage imageNamed:@"btn_huodong"] target:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside tag:301];
    [_btnScrollView addSubview:_button2];
    
    _button3 = [YLButton buttonEasyInitBackColor:nil frame:CGRectMake(_button2.frame.origin.x+40+24, _button1.frame.origin.y, 40, 57) type:UIButtonTypeSystem backImage:[UIImage imageNamed:@"btn_zhishi"] target:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside tag:302];
    [_btnScrollView addSubview:_button3];
    
    _button4 = [YLButton buttonEasyInitBackColor:nil frame:CGRectMake(_button3.frame.origin.x+40+24, _button1.frame.origin.y, 40, 57) type:UIButtonTypeSystem backImage:[UIImage imageNamed:@"btn_qinggan"] target:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside tag:303];
    [_btnScrollView addSubview:_button4];
    

    
//    _button6 = [YLButton buttonEasyInitBackColor:nil frame:CGRectMake(_button4.frame.origin.x+40+24,_button1.frame.origin.y, 40, 57) type:UIButtonTypeSystem backImage:[UIImage imageNamed:@"btn_vedio"] target:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside tag:305];
//    [_btnScrollView addSubview:_button6];
    
    _button5 = [YLButton buttonEasyInitBackColor:nil frame:CGRectMake(_button4.frame.origin.x+40+24,_button1.frame.origin.y, 40, 57) type:UIButtonTypeSystem backImage:[UIImage imageNamed:@"btn_chufang"] target:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside tag:304];
    [_btnScrollView addSubview:_button5];

    
    
    _buttonsArray = [[NSArray alloc]initWithObjects:_button1,_button2,_button3,_button4,_button5, nil];
    self.topPageControl = [[UIPageControl alloc]initWithFrame:CGRectZero];
    self.topPageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
    self.topPageControl.currentPageIndicatorTintColor = [BBSColor hexStringToColor:@"ff5f5f"];
    [_headerView addSubview:self.topPageControl];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,headerviewheight-1, SCREENWIDTH, 1)];
    lineView.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
    [_headerView addSubview:lineView];
    
    [self getHeaderViewData];
    
    
}
-(void)buttonAction:(id)sender
{
    UIButton *buttons = sender;
    NSInteger a = buttons.tag-300;
    if (a == 0) {
//        _isRefresh = 1;
//        _isFinished = 0;
//        self.page =1;
//
//        [self getDataWithButton];
        
    }else{
        PostBarSecondeVC *secondVC = [[PostBarSecondeVC alloc]init];
        if (a == 1) {
            secondVC.titleString = @"成长活动";
        } else if (a== 2) {
            secondVC.titleString = @"育儿知识";
        } else if (a== 3) {
            secondVC.titleString = @"时尚情感";
        }if (a == 4) {
            secondVC.titleString = @"辣妈厨房";
        }
        secondVC.post_classes = a;
        secondVC.login_user_id = LOGIN_USER_ID;
        //这块需要判断是否刷新
        [self.navigationController pushViewController:secondVC animated:NO];
        
    }
}
-(void)setTableView{
    
    CGRect tableviewFrame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    _tableView=[[UITableView alloc]initWithFrame:tableviewFrame];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
    if (self.type == POSTBARNEWTYPEDEFAULT) {
        [self getDataWithButton];
        
    }else if(self.type == POSTBARNEWTYPEMYFOUCUS){
        [self getdata];
    }
    //类型是话题列表
    if (self.type==POSTBARNEWTYPEDEFAULT) {
    
        [_tableView setTableHeaderView:_headerView];
    }
    __weak PostBarNewVC *postBar=self;
    [_tableView addPullToRefreshWithActionHandler:^{
        postBar.isRefresh=YES;
        postBar.isFinished=NO;
        postBar.isGetMore=NO;
        postBar.post_create_time=NULL;
        postBar.create_time=NULL;
        postBar.page = 1;
        if (postBar.type == POSTBARNEWTYPEDEFAULT) {
            [postBar getDataWithButton];
            
        }else if(postBar.type == POSTBARNEWTYPEMYFOUCUS){
            [postBar getdata];
        }
        if (postBar.type==POSTBARNEWTYPEDEFAULT) {
            [postBar getHeaderViewData];
        }
        
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        
        if (!postBar.isFinished) {
            if (postBar.tableView.pullToRefreshView.state==SVInfiniteScrollingStateStopped) {
                if (self.type == POSTBARNEWTYPEDEFAULT) {
                    [postBar getDataWithButton];
                }else{
                    [postBar getdata];
                }

            }
        }else{
            if (postBar.tableView.infiniteScrollingView && postBar.tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
                [postBar.tableView.infiniteScrollingView stopAnimating];
            }
            
        }
        
    }];
    
}
-(void)setLeftButton{
//    
//    if (self.type == POSTBARNEWTYPEDEFAULT) {
//        
//    } else {
        CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
        
        UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.frame=backBtnFrame;
        UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
        self.navigationItem.leftBarButtonItem=left;
//    }
}
//搜索的按钮
- (void)setSearchBtn {
    UIButton *searchBtn =[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"btn_show_search"];
    searchBtn.frame=CGRectMake(0, 0, image.size.width, image.size.height);
    [searchBtn setBackgroundImage:image forState:UIControlStateNormal];
    [searchBtn addTarget:self action:@selector(showSearch:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBtn=[[UIBarButtonItem alloc]initWithCustomView:searchBtn];
    self.navigationItem.rightBarButtonItem=leftBtn;
    
}

-(void)setRightButton{
    
    _FTBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _FTBtn.frame=CGRectMake(SCREENWIDTH-53 , SCREENHEIGHT-64, 42, 42);;
   // [_FTBtn setTitle:@"发帖" forState:UIControlStateNormal];
    [_FTBtn addTarget:self action:@selector(makeAPost) forControlEvents:UIControlEventTouchUpInside];
    [_FTBtn setBackgroundImage:[UIImage imageNamed:@"img_myshow_newmakeashow"] forState:UIControlStateNormal];
    [self.view addSubview:_FTBtn];
    
}
- (void)addEmptyHintView {
    
    if (_emptyView) {
        return;
    }
    _emptyView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _emptyView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    
    UIImage *image=[UIImage imageNamed:@"img_myshow_empty_babyface"];
    UIImageView *imgView=[[UIImageView alloc]initWithImage:image];
    imgView.frame=CGRectMake(96.5, 100, 127, 127);
    [_emptyView addSubview:imgView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(50, 240, 220, 30)];
    label.font=[UIFont systemFontOfSize:17];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor = [BBSColor hexStringToColor:@"c3ad8f"];
    label.text=@"您还没有收藏过帖子哦";
    [_emptyView addSubview:label];
    
    [self.view addSubview:_emptyView];
    
}
#pragma mark 数据
//轮播图数据
-(void)getHeaderViewData{
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    NetAccess *net=[NetAccess sharedNetAccess];
    [net getDataWithStyle:NetStylePostAlbumList andParam:paramDic];
    [LoadingView startOntheView:_headerView];
    
}

-(void)getDataWithButton{
    
    //话题
    NetAccess *net=[NetAccess sharedNetAccess];
    if (self.post_classes==0 ) {
        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.post_create_time,@"post_create_time", nil];
        [net getDataWithStyle:NetStylePostMyInterestListV1 andParam:paramDic];
        [LoadingView startOnTheViewController:self];
        
        //收藏
    }
}

-(void)getdata{
    //        login_user_id	Int	是	登录的用户ID
    //        create_time	String	否	下一页，最后一条热点的收藏时间
    
    NetAccess *net=[NetAccess sharedNetAccess];
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",
                            self.create_time,@"create_time", nil];
    [net getDataWithStyle:NetStylePostBarNewSaveList andParam:paramDic];
    [LoadingView startOnTheViewController:self];
}
#pragma mark 系统通知

-(void)getDataSucceed:(NSNotification *) note{
    
    NSString *styleString=note.object;
    NetAccess *net=[NetAccess sharedNetAccess];
    NSArray *returnArray=[net getReturnDataWithNetStyle:[styleString intValue]];
    
    if (returnArray.count == 0) {
        _isFinished = YES;
        [self showHUDWithMessage:@"已没有更多数据"];
        
    }
    if (_isRefresh) {
        [_dataArray removeAllObjects];
        _isRefresh = NO;
    }
    [_dataArray addObjectsFromArray:returnArray];
    [_tableView reloadData];
    [LoadingView startOnTheViewController:self];
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    
    
    if (_dataArray.count) {
        if (self.type == POSTBARNEWTYPEDEFAULT) {
            PostMyInterestItem *item = [returnArray lastObject];
            self.post_create_time= item.post_create_time;
        }else
        {
        PostMyInterestItem *item = [returnArray lastObject];
        self.create_time = item.create_time;
        }
        
    }
    [LoadingView stopOnTheViewController:self];
    if (_dataArray.count == 0 && self.type == POSTBARNEWTYPEMYFOUCUS) {
        [self addEmptyHintView];
        topBtn.hidden = YES;
    } else {
        topBtn.hidden = NO;
        if (_emptyView) {
            [_emptyView removeFromSuperview];
            _emptyView = nil;
        }
        
        if (_tableView) {
            [_tableView reloadData];
        }
    }
    
}

-(void)getDataFail:(NSNotification *) note{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=note.object;

    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    
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

-(void)getHeaderViewSucceed:(NSNotification *) note{
    
    NSString *styleString = note.object;
    
    NetAccess *net = [NetAccess sharedNetAccess];
    
    _headerViewArray = [net getReturnDataWithNetStyle:[styleString intValue]];
    
    CGFloat width = _headerScrollView.frame.size.width;
    CGFloat height = _headerScrollView.frame.size.height;
    self.topPageControl.frame = CGRectMake(SCREENWIDTH/3, height-15, 100, 10);
    self.topPageControl.numberOfPages = _headerViewArray.count;
        
    _headerScrollView.contentSize = CGSizeMake(width*_headerViewArray.count, height);
    [_headerScrollView  setContentOffset:CGPointZero];
    for (UIView *view in _headerScrollView.subviews) {
        [view removeFromSuperview];
    }
    
    for (int i = 0; i < _headerViewArray.count; i++) {
        PostBarHeaderItem *item = [_headerViewArray objectAtIndex:i];
        
        CGRect imageFrame = CGRectMake(width*i, 0, width, height);
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageFrame];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 100 + i;
        [imageView sd_setImageWithURL:[NSURL URLWithString:item.img]];
        [_headerScrollView addSubview:imageView];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(clickToDetail:)];
        [imageView addGestureRecognizer:tapGes];
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(110+i*SCREENWIDTH, 30, 100, 40)];
        //titleLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.4];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont boldSystemFontOfSize:15];
        titleLabel.numberOfLines =0;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        if (item.is_group == 1) {
            titleLabel.text = item.groupName;
        }else{
            titleLabel.text = item.title;
        }
        _is_bjCity = item.is_bjCity;
        [_headerScrollView addSubview:titleLabel];
        UILabel *labelOf = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x-15, 30+20, 15, 15)];
        labelOf.text = @"#";
        labelOf.textAlignment = NSTextAlignmentRight;
        labelOf.textColor = [UIColor whiteColor];
        labelOf.font = [UIFont systemFontOfSize:14];
        
        UILabel *labelOfRight = [[UILabel alloc]initWithFrame:CGRectMake(titleLabel.frame.origin.x+100, 30+20, 15, 15)];
        labelOfRight.text = @"#";
        labelOfRight.textAlignment = NSTextAlignmentLeft;
        labelOfRight.textColor = [UIColor whiteColor];
        labelOfRight.font = [UIFont systemFontOfSize:14];
    }
    if (self.type==POSTBARNEWTYPEDEFAULT) {
        
//        if (_is_bjCity == 1) {
//            _headerView.frame = CGRectMake(0, 0, SCREENWIDTH,SCREENWIDTH/3+90+230);
//            _backview.hidden = NO;
//            [self getMyStoreData];
//        }
        [_tableView setTableHeaderView:_headerView];
    }
    [LoadingView stopOnTheView:_headerView];
    
}

-(void)getHeaderViewFail:(NSNotification *) note{
    
    [LoadingView stopOnTheView:_headerView];
    [BBSAlert showAlertWithContent:note.object andDelegate:self];
    
}

#pragma mark Private
- (void)showSearch:(UIButton *)sender {
    if (theSearchBar) {
        if (![theSearchBar isFirstResponder]) {
            [theSearchBar becomeFirstResponder];
        }
        return;
    }
    
    theSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(5, 0, SCREENWIDTH-10, 44)];
    theSearchBar.placeholder = @"搜索群名或帖子";
    UIView *imgView  = [theSearchBar.subviews objectAtIndex:0];
    
    UIImageView *bgImge = [[UIImageView alloc]initWithFrame:CGRectMake(8, 13, 15, 15)];
    bgImge.backgroundColor = [UIColor whiteColor];
    bgImge.image = [UIImage imageNamed:@"btn_show_searched"];
    [imgView addSubview:bgImge];
    
    theSearchBar.tintColor=[BBSColor hexStringToColor:@"f9f3f3"];//光标的颜色
    theSearchBar.backgroundColor = [BBSColor hexStringToColor:NAVICOLOR];
    theSearchBar.delegate = self;
    theSearchBar.tag = 2;
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.navigationController.navigationBar addSubview:theSearchBar];
    [UIView commitAnimations];
    
    [theSearchBar becomeFirstResponder];
}

//轮播图的点击事件
- (void)clickToDetail:(UITapGestureRecognizer *)tapGes {
    
    _isHideCategory = YES;
    [_categoryTableV setHidden:_isHideCategory];
    UIImageView *imageView = (UIImageView *)tapGes.view;
    NSUInteger index = imageView.tag;
    PostBarHeaderItem *item = [_headerViewArray objectAtIndex:index-100];
    if (item.is_group == 0) {
        PostBarNewDetialV1VC *detailVC=[[PostBarNewDetialV1VC alloc]init];
        detailVC.img_id=item.img_id;
        detailVC.user_id=item.user_id;
        detailVC.login_user_id=LOGIN_USER_ID;
        detailVC.refreshInVC = ^(BOOL isRefresh){
            if (isRefresh == YES) {
                _isRefresh = 1;
                _isGetMore = NO;
                _isFinished = NO;
                _page = 1;
                self.post_create_time = NULL;
                [self getDataWithButton];
            }
        };
        
        //detailVC.isSaved=item.isSaved;
        [detailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
    }else if(item.is_group == 1){
        PostBarNewGroupOnlyOneVC *detailVC = [[PostBarNewGroupOnlyOneVC alloc]init];
        detailVC.group_id = item.groupId;
        [self.navigationController pushViewController:detailVC animated:YES];

    }else {
       StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
        storeVC.longin_user_id = LOGIN_USER_ID;
        storeVC.business_id = item.img_id;
        [self.navigationController pushViewController:storeVC animated:YES];
        
    }
    
    
    
    }
//发帖
-(void)makeAPost{
    
    _isHideCategory = YES;
    
    [_categoryTableV setHidden:_isHideCategory];
    
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    
    if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
        
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
        return;
    }
    
    PostBarNewMakeAPost *makePostVC=[[PostBarNewMakeAPost alloc]init];
 
    [makePostVC setHidesBottomBarWhenPushed:YES];
    makePostVC.update = ^{
        _isRefresh=1;
        _isGetMore=NO;
        _isFinished=NO;
        _page = 1;
        self.post_create_time = NULL;
        [self getDataWithButton];
        

    };
    [self.navigationController pushViewController:makePostVC animated:YES];
    
}
-(void)dimissAlert:(UIAlertView *)alert{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}

- (void)selectCategory:(UIButton *)button {
    if (_isHideCategory) {
        _isHideCategory = NO;
    } else {
        _isHideCategory = YES;
    }
    _categoryTableV.hidden = _isHideCategory;
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
#pragma mark UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _categoryTableV) {
        return _categoryArray.count;
    }else if([tableView isEqual:searchResultsTableView]){
        return searchResultsArray.count;
    }
    if (self.type == POSTBARNEWTYPEDEFAULT) {
        return [_dataArray count];

    }else{
        return _dataArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:searchResultsTableView]) {
        return 50;
    } else if(self.type == POSTBARNEWTYPEDEFAULT){
    return 78;
    }else{
        PostBarNewBasicItem *item = [_dataArray objectAtIndex:indexPath.row];
        return item.height;
        
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell的重用
    //如果是话题的话，cell的格式
    if ([tableView isEqual:searchResultsTableView]) {
        [theSearchBar setHidden:YES];
        NSDictionary *rowDict = [searchResultsArray objectAtIndex:indexPath.row];
        static NSString *identifierOfSeachGruop = @"identifierOfSeachGruop";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierOfSeachGruop];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierOfSeachGruop];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        UIImageView *groupImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 30, 30)];
        [cell.contentView addSubview:groupImage];
        
        UILabel *groupNameLabel =[[UILabel alloc]initWithFrame:CGRectMake(groupImage.frame.size.width+20, 15, 250, 20)];
        groupNameLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        [cell.contentView addSubview:groupNameLabel];
        
        UIView *seperatorLine = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, SCREENWIDTH, 0.5)];
        seperatorLine.backgroundColor = [BBSColor hexStringToColor:@"999999"];
        [cell.contentView addSubview:seperatorLine];
    
        groupNameLabel.text = [NSString stringWithFormat:@"%@",rowDict[@"group_name"]];
        NSInteger isgroup  = [rowDict[@"is_group"]integerValue];
        if (isgroup == 1) {
            groupImage.image = [UIImage imageNamed:@"img_group_seach"];
        }else if(isgroup == 0){
            groupImage.image = [UIImage imageNamed:@"img_post_search"];
        }else{
            
        }
        return cell;
        //漫步
        
    }
    if (self.type == POSTBARNEWTYPEDEFAULT) {
        NSString *identifier = [NSString stringWithFormat:@"MYINTERESTV3"];
        PostMyInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PostMyInterestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        cell.label.frame = CGRectMake(0, 77, SCREENWIDTH, 1);
        PostMyInterestItem *item = [_dataArray objectAtIndex:indexPath.row];
        //NSLog(@"item.img.length = %lu",(unsigned long)item.img.length);
        if (!(item.img.length <= 0)) {
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:item.img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                cell.photoView.frame = CGRectMake(10, 10, 60, 60);
                cell.photoView.image = image;
                
            }];
            cell.titleLabel.frame = CGRectMake(80, 8, 220, 20);
            cell.reviewLabel.frame = CGRectMake(80, 33, 200, 18);
            cell.descriptionLabel.frame = CGRectMake(80, 57, 213, 17);
            
            
        }else
        {
            cell.photoView.frame = CGRectMake(0, 0, 0, 0);
            cell.titleLabel.frame = CGRectMake(10, 8, 250, 20);
            cell.reviewLabel.frame = CGRectMake(10, 35, 200, 18);
            cell.descriptionLabel.frame = CGRectMake(10, 57, 213, 17);
            cell.videoView.frame = CGRectMake(0, 0, 0, 0);
        }
        if (item.is_group == 1) {
            cell.groupImageV.frame = CGRectMake(0, 2, 20, 20);
            CGFloat a = cell.titleLabel.frame.size.width -20;
            cell.groupImageV.image = [UIImage imageNamed:@"img_group_logo 30"];
            cell.titleLabelS.frame = CGRectMake(21, 0, a, 23);
            cell.photoView.layer.masksToBounds = YES;
            cell.photoView.layer.cornerRadius = 30;
            cell.videoView.frame = CGRectMake(0, 0, 0, 0);
        }else  if(item.is_group == 2){
            cell.groupImageV.frame = CGRectMake(0, 2, 20, 20);
            cell.groupImageV.image = [UIImage imageNamed:@"img_post_store@2x"];
            CGFloat a = cell.titleLabel.frame.size.width -20;
            cell.titleLabelS.frame = CGRectMake(21, 0, a, 23);
            cell.photoView.layer.masksToBounds = NO;
            cell.videoView.frame = CGRectMake(0, 0, 0, 0);
            
        }else if (item.is_group == 5 && !(item.img.length <= 0)){
            CGFloat b = cell.titleLabel.frame.size.width;
            cell.groupImageV.frame = CGRectMake(0, 0, 0, 0);
            cell.titleLabelS.frame = CGRectMake(0, 0, b, 23);
            cell.photoView.layer.masksToBounds = NO;
            cell.videoView.frame = CGRectMake(20, 22, 67*0.5, 67*0.5);

        }else{
            CGFloat b = cell.titleLabel.frame.size.width;
            cell.groupImageV.frame = CGRectMake(0, 0, 0, 0);
            cell.titleLabelS.frame = CGRectMake(0, 0, b, 23);
            cell.photoView.layer.masksToBounds = NO;
            cell.videoView.frame = CGRectMake(0, 0, 0, 0);
            
        }
        //判断title
        //判断title
        if (item.is_group == 1) {
            cell.titleLabelS.text = item.group_name;
            cell.reviewLabel.text = [NSString stringWithFormat:@"参与%@人  帖子%@个",item.reviewCount,item.postCount];
            cell.descriptionLabel.text = nil;
            
        } else if(item.is_group == 0){
            cell.titleLabelS.text = item.img_title;
            cell.reviewLabel.text = [NSString stringWithFormat:@"参与%@人  观看%@人",item.reviewCount,item.postCount];
            cell.descriptionLabel.text = item.describe;
            cell.descriptionLabel.textColor = [BBSColor hexStringToColor:@"#878787"];
        }else{
            cell.titleLabelS.text = item.img_title;
            cell.reviewLabel.text = [NSString stringWithFormat:@"参与%@人  观看%@人",item.reviewCount,item.postCount];
            cell.descriptionLabel.text = item.describe;
            cell.descriptionLabel.textColor = [BBSColor hexStringToColor:@"#878787"];
            
        }
        [cell.photoView setContentMode:UIViewContentModeScaleAspectFill];
        cell.photoView.clipsToBounds = YES;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    //r如果是收藏的话是什么样的cell
    UITableViewCell *returnCell;
    
    id obj=[_dataArray objectAtIndex:indexPath.row];
    
    if ([obj isKindOfClass:[PostBarWithPhotoItem class]]) {
        PostBarWithPhotoItem *Item=(PostBarWithPhotoItem *) obj;
        PostBarNewWithImageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"WITHPHOTO"];
        if (!cell) {
            cell=[[PostBarNewWithImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WITHPHOTO"];
        }
       cell.titleLabel.text=Item.title;
        cell.userNameLabel.text=[NSString stringWithFormat:@"by：%@",Item.username];
        cell.timeLabel.text=Item.time;
        cell.describeLabel.text=Item.describe;
        cell.praiseCountLabel.text=Item.praiseCount;
        cell.reviewCountLabel.text=Item.reviewCount;
        [cell resetFrameWithContent:Item.describe];
        cell.photoView.image=nil;
        [cell.photoView sd_setImageWithURL:[NSURL URLWithString:Item.photoURLString]];
        if (Item.videoUrl.length >0) {
            cell.videoView.hidden = NO;
        }else{
            cell.videoView.hidden = YES;
        }
        
        if (Item.isSigned==YES) {
            cell.signImageView.hidden=NO;
        }else{
            cell.signImageView.hidden=YES;
        }
        if (Item.isAdmired) {
            cell.praiseImageView.image = [UIImage imageNamed:@"btn_worthbuy_praised"];
        } else {
            cell.praiseImageView.image = [UIImage imageNamed:@"btn_worthbuy_praise"];
        }
        returnCell=cell;
        
    }else if([PostBarWithOutPhotoItem class]){
        
        PostBarWithOutPhotoItem *Item=(PostBarWithOutPhotoItem *) obj;
        
        PostBarNewWithOutImageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"WITHOUTPHOTO"];
        if (!cell) {
            cell=[[PostBarNewWithOutImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"WITHOUTPHOTO"];
        }
        
        cell.titleLabel.text=Item.title;
        cell.userNameLabel.text=[NSString stringWithFormat:@"by：%@",Item.username];
        cell.timeLabel.text=Item.time;
        cell.describeLabel.text=Item.describe;
        [cell resetFrameWithDescribeContent:Item.describe];
        cell.praiseCountLabel.text=Item.praiseCount;
        cell.reviewCountLabel.text=Item.reviewCount;
        
        if (Item.isSigned==YES) {
            cell.signImageView.hidden=NO;
        }else{
            cell.signImageView.hidden=YES;
        }
        if (Item.isAdmired) {
            cell.praiseImageView.image = [UIImage imageNamed:@"btn_worthbuy_praised"];
        } else {
            cell.praiseImageView.image = [UIImage imageNamed:@"btn_worthbuy_praise"];
        }
        returnCell=cell;
        
    }
    
    returnCell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return returnCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:searchResultsTableView]) {
        [theSearchBar setHidden:YES];
        NSDictionary *rowDic = [searchResultsArray objectAtIndex:indexPath.row];
        if ([rowDic[@"is_group"]integerValue] == 1) {
            PostMyGroupDetailVController *detailVC = [[PostMyGroupDetailVController alloc]init];
            detailVC.login_user_id = LOGIN_USER_ID;
            detailVC.group_id = [rowDic[@"group_id"] integerValue];
            
            [detailVC setHidesBottomBarWhenPushed:YES];
            detailVC.refreshBlock = ^(BOOL isRefresh){
                if (searchResultsTableView) {
                    [searchResultsTableView removeFromSuperview];
                    searchResultsTableView = nil;
                }
                if (theSearchBar) {
                    [theSearchBar removeFromSuperview];
                    theSearchBar = nil;
                }
                [self removeDimBackground];
                
            };
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }else {
            PostBarNewDetialV1VC *detailVC=[[PostBarNewDetialV1VC alloc]init];
            detailVC.img_id = rowDic[@"group_id"];
            detailVC.login_user_id=LOGIN_USER_ID;
            [detailVC setHidesBottomBarWhenPushed:YES];
            detailVC.refreshInVC = ^(BOOL isRefresh){
                if (searchResultsTableView) {
                    [searchResultsTableView removeFromSuperview];
                    searchResultsTableView = nil;
                }
                if (theSearchBar) {
                    [theSearchBar removeFromSuperview];
                    theSearchBar = nil;
                }
                [self removeDimBackground];
            };
            [self.navigationController pushViewController:detailVC animated:YES];
         
        }
    }else  if (self.type == POSTBARNEWTYPEDEFAULT) {
        PostMyInterestItem *item=[_dataArray objectAtIndex:indexPath.row];
        if (item.is_group == 0) {
            PostBarNewDetialV1VC *detailVC=[[PostBarNewDetialV1VC alloc]init];
            detailVC.img_id=item.imgId;
            detailVC.user_id=item.userid;
            detailVC.login_user_id=LOGIN_USER_ID;
            detailVC.refreshInVC = ^(BOOL isRefresh){
                if (isRefresh == YES) {
                    _isRefresh = 1;
                    self.create_time = NULL;
                    self.post_create_time = NULL;
                    _isFinished = 0;
                    [self getDataWithButton];
                }
            };
            
            [detailVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }else if(item.is_group == 1){
            PostMyGroupDetailVController*detailVC = [[PostMyGroupDetailVController alloc]init];
            detailVC.login_user_id = LOGIN_USER_ID;
            detailVC.group_id = item.group_id;
            // detailVC.post_class = self.post_classes;
            detailVC.refreshBlock = ^(BOOL isRefresh){
                if (isRefresh == YES) {
                    _isRefresh = 1;
                    self.create_time = NULL;
                    _isFinished = 0;
                    self.post_create_time = NULL;
                    [self getDataWithButton];
                    
                }
            };
            
            [detailVC setHidesBottomBarWhenPushed:YES];
            detailVC.navigationController.navigationBar.hidden = NO;
            [self.navigationController pushViewController:detailVC animated:YES];
            
        }else if (item.is_group == 5){
            BabyShowPlayerVC *babyShowPlayVC = [[BabyShowPlayerVC alloc]init];
            babyShowPlayVC.videoUrl = item.video_url;
            babyShowPlayVC.img_id = item.imgId;
            [self.navigationController pushViewController:babyShowPlayVC animated:YES];
            
        }else{
            StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
            storeVC.longin_user_id = LOGIN_USER_ID;
            storeVC.business_id = item.imgId;
            [self.navigationController pushViewController:storeVC animated:YES];
        }

    }else{
        PostBarNewBasicItem *item=[_dataArray objectAtIndex:indexPath.row];
        if (item.videoUrl.length >0) {
            
            BabyShowPlayerVC *babyShowPlayerVc = [[BabyShowPlayerVC alloc]init];
            babyShowPlayerVc.videoUrl = item.videoUrl;
            babyShowPlayerVc.img_id =item.imgId;
            [self.navigationController pushViewController:babyShowPlayerVc animated:YES];

            
        }else{
            PostBarNewDetialV1VC *detailVC=[[PostBarNewDetialV1VC alloc]init];
            detailVC.img_id=item.imgId;
            detailVC.user_id=item.userid;
            detailVC.login_user_id=LOGIN_USER_ID;
            detailVC.refreshInVC = ^(BOOL isRefresh){
                if (isRefresh == YES) {
                    _isRefresh=1;
                    _isGetMore=NO;
                    _isFinished=NO;
                    self.post_create_time = NULL;
                    self.create_time = NULL;
                    _page = 1;
                    [self getdata];
                    
                }
                
            };
            [detailVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:detailVC animated:YES];

        }
    }
    
}

#pragma mark - 创建搜索结果的TableView Methods
- (void)setSearchResultsTableView{
    if (searchResultsTableView) {
        [searchResultsTableView removeFromSuperview];
        searchResultsTableView = nil;
    }
    
    searchResultsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-100) style:UITableViewStylePlain];
    searchResultsTableView.delegate = self;
    searchResultsTableView.dataSource = self;
    searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    searchResultsTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchResultsTableView];
}
#pragma mark - 搜索群 Methods
- (void)searchUserWithWord:(NSString *)keyWord{
    
    [LoadingView startOnTheViewController:self];
    
    NSString *userid = LOGIN_USER_ID;
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:userid,kFindPartUserLogin_user_id,[keyWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],kFindPartUserSearch_word, nil];
    [[HTTPClient sharedClient] getNew:kSearchGroup params:param success:^(NSDictionary *result) {
        [LoadingView stopOnTheViewController:self];
        if ([[result objectForKey:kBBSSuccess]intValue] == 1) {
            searchResultsArray = [result objectForKey:kBBSData];
            if (searchResultsArray==nil || [searchResultsArray isKindOfClass:[NSNull class]]||searchResultsArray.count == 0){
                [BBSAlert showAlertWithContent:@"未找到相关内容" andDelegate:nil];
                
            } else {
                [self setSearchResultsTableView];
            }
        }else {
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
            
        }
    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
        [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
    }];
    
}
#pragma mark -cellDelegate

-(void)pushPostDetailVC:(UIButton*)tapBtn
{
    PostMyInterestV3Item *item1 = [_dataArray objectAtIndex:tapBtn.tag];
    PostMyInterestItem *item = item1.imgsArray[tapBtn.superview.tag-4000];
    if (item.is_group == 0) {
        PostBarNewDetialV1VC *detailVC=[[PostBarNewDetialV1VC alloc]init];
        detailVC.img_id=item.imgId;
        detailVC.user_id=item.userid;
        detailVC.login_user_id=LOGIN_USER_ID;
        detailVC.refreshInVC = ^(BOOL isRefresh){
            if (isRefresh == YES) {
                _isRefresh = 1;
                _isGetMore = NO;
                _isFinished = NO;
                _page = 1;
                self.post_create_time = NULL;
                [self getDataWithButton];
            }
        };
        [detailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if(item.is_group == 1){
        PostMyGroupDetailVController*detailVC = [[PostMyGroupDetailVController alloc]init];
        detailVC.login_user_id = LOGIN_USER_ID;
        detailVC.group_id = item.group_id;
        detailVC.post_class = self.post_classes;
        detailVC.refreshBlock = ^(BOOL isRefresh){
            if (isRefresh == YES) {
                _isRefresh = 1;
                _isGetMore = NO;
                _isFinished = NO;
                _page = 1;
                self.post_create_time = NULL;
                [self getDataWithButton];
                
            }
        };
        
        [detailVC setHidesBottomBarWhenPushed:YES];
        detailVC.navigationController.navigationBar.hidden = NO;
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else {
        StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
        storeVC.longin_user_id = LOGIN_USER_ID;
        storeVC.business_id = item.imgId;
        [self.navigationController pushViewController:storeVC animated:YES];

    }
    
}
-(void)pushMorePostDetailVC:(UIButton *)btn{
    PostMyInterestV3Item *itemV3 = [_dataArray objectAtIndex:btn.tag];
    if (itemV3.interest_type == 2) {
        StoreMoreListVC *storeList = [[StoreMoreListVC alloc]init];
        storeList.login_user_id = LOGIN_USER_ID;
        [self.navigationController pushViewController:storeList animated:YES];
    }else{
    PostBarMoreViewController *postMoreVC = [[PostBarMoreViewController alloc]init];
    postMoreVC.interestType = itemV3.interest_type;
    postMoreVC.login_user_id = LOGIN_USER_ID;
    postMoreVC.titleString = itemV3.titleInSection;
    [self.navigationController pushViewController:postMoreVC animated:YES];
    }
}
-(void)pushMostStoreList{
    StoreMoreListVC *storeList = [[StoreMoreListVC alloc]init];
    storeList.login_user_id = LOGIN_USER_ID;
    [self.navigationController pushViewController:storeList animated:YES];
}
#pragma mark 点击附近的动作
-(void)pushStoreDetail:(UITapGestureRecognizer *)sender{

    StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
    storeVC.longin_user_id = LOGIN_USER_ID;
    PostMyInterestItem *myItem = [[PostMyInterestItem alloc]init];
    myItem = _storeArray[sender.view.tag-800];
    storeVC.business_id = myItem.imgId;
    [self.navigationController pushViewController:storeVC animated:YES];

    
}
#pragma mark - UISearchBarDelegate Methods
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    if (![self.view viewWithTag:3]) {
        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH,  SCREENHEIGHT-64-49)];
        aView.backgroundColor = [UIColor blackColor];
        aView.alpha = 0.5f;
        aView.tag = 3;
        [self.view addSubview:aView];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeTableView:)];
        [aView addGestureRecognizer:tapGes];
    }
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    //    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    [self searchUserWithWord:searchBar.text];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self removeDimBackground];
    [theSearchBar removeFromSuperview];
    theSearchBar = nil;
    if (searchResultsTableView) {
        [searchResultsTableView removeFromSuperview];
    }
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return  YES;
}
- (void)removeDimBackground{
    
    if ([self.view viewWithTag:3]) {
        UIView *aView = [self.view viewWithTag:3];
        [aView removeFromSuperview];
    }
    
}
- (void)removeTableView:(UITapGestureRecognizer *)tapGes{
    if (searchResultsTableView) {
        [searchResultsTableView removeFromSuperview];
    }
    if (theSearchBar && [theSearchBar isFirstResponder]) {
        theSearchBar.text = @"";
        [theSearchBar resignFirstResponder];
    }
    UIView *aView = (UIView *)tapGes.view;
    [aView removeFromSuperview];
    
    [theSearchBar removeFromSuperview];
    theSearchBar = nil;
    
}

#pragma mark 当滚动的时候隐藏和显示导航条

CGPoint point;

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if (![scrollView isEqual:_categoryTableV]) {
        point=scrollView.contentOffset;
        _isHideCategory = YES;
        _categoryTableV.hidden = _isHideCategory;
    }
    
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    if (![scrollView isEqual:_categoryTableV]) {
        
        //down
        if (point.y-scrollView.contentOffset.y>40) {
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            _tableView.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
            [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
            [UIView commitAnimations];
        }
        //u哈哈
        if (point.y-scrollView.contentOffset.y<-40) {
            
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:0.25];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            _tableView.frame=CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT-20);
            [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
            [UIView commitAnimations];
            
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == _headerScrollView) {
        self.topPageControl.currentPage = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
}
-(void)showHUDWithMessage:(NSString *)message{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60,64+20+50+50+50+5 , 200, 30)];
    label.backgroundColor = [UIColor darkGrayColor];
    label.layer.cornerRadius = 3.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:14];
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
    self.bbsComNav.isNotGoBack = NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

@end
