//
//  SpecialDetailTVC.m
//  BabyShow
//
//  Created by WMY on 15/5/19.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "SpecialDetailTVC.h"
#import "SDWebImageManager.h"
#import "BBSTimeTool.h"
#import "UserInfoItem.h"

#import "MyOutPutTitleItem.h"
#import "MyOutPutDescribeItem.h"
#import "MyOutPutUrlItem.h"
#import "MyOutPutImgGroupItem.h"
#import "MyOutPutPraiseAndReviewItem.h"
#import "MyOutPutTitleItemNotToday.h"
#import "MyShowNewTitleItemToday.h"
#import "MyShowNewTitleItemNotToday.h"
#import "SpecialPartPeopleItem.h"

#import "MyShowNewPickedTitleFocusItem.h"
#import "MyShowNewPickedTitleTodayItem.h"
#import "MyShowNewPickedTitleNotTodayItem.h"

#import "SVPullToRefresh.h"
#import "ShowAlertView.h"

#import "WebViewController.h"
#import "MakeAShowViewController.h"
#import "ApplyToPlayViewController.h"
#import "MyHomeNewVersionVC.h"
//#import "PostBarNewDetailVC.h"
#import "PraiseAndReviewListViewController.h"
#import "PPTViewController.h"
#import "ReportViewController.h"
#import "BBSNavigationController.h"
#import "BBSNavigationControllerNotTurn.h"
#import "ClickViewController.h"
#import "GrowthDiaryLeadingView.h"
#import "SpecialAvatarsCell.h"
#import "UIImageView+WebCache.h"
#import "MakeAvtivityViewController.h"
#import "SpecialDetailGridCollectionViewCell.h"
#import "ImageDetailViewController.h"
#import "LoginHTMLVC.h"
#import "PostBarNewDetialV1VC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>



@interface SpecialDetailTVC ()<ClickLabelDelegate,UISearchBarDelegate>
{
    
    UIView           *_headerView;
    UIButton         *_playAvatarBtn;        //展播用户的头像
    UILabel          *_playNameLabel;        //展播用户的昵称
    UIImageView      *_playLogoImageV;       //展播的标志
    UIImageView      *_playImageView;         //要展播的图片
    UIImageView      *_playPlayImageV;        //播放的一个小图标
    UILabel          *_playAlbumLabel;        //相册名称
    UIButton         *_playApplyBtn;          //报名
    UIView           *_playSeperatorLine;     //分割线
    //搜索结果
    UITableView *searchResultsTableView;
    UISearchBar *theSearchBar;
    NSArray *searchResultsArray;
    UIButton *seachButton;
    BOOL _isSearch;
    //UICollectionView *collectionView;
    
}
@property (nonatomic ,assign) BOOL isFresh;
@property (nonatomic ,strong) UITableView *tableview;
@property(nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic ,assign) BOOL isFinished;
@property(nonatomic,assign)BOOL isGetMore;
@property(nonatomic,assign)BOOL isFreshInCollectionView;
@property(nonatomic,assign)BOOL isGetMoreInCollectionView;
@property(nonatomic,assign)BOOL isFinishedInCollectionView;
@property(nonatomic,strong)NSMutableArray *avaMutableArray;
@property(nonatomic,strong)UIButton *addTopicBtn;
@property(nonatomic,strong)UIButton *button1;
@property(nonatomic,strong)UIButton *button2;
@property(nonatomic,assign)NSInteger page_size;
@property(nonatomic,assign)BOOL isselect;//第二个按钮被点中否



@end

@implementation SpecialDetailTVC
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [[NetAccess sharedNetAccess].specialDetailRequests makeObjectsPerformSelector:@selector(cancel)];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _dataArray=[[NSMutableArray alloc]init];
        _PhotoArray=[[NSMutableArray alloc]init];
        _newDataArray = [[NSMutableArray alloc]init];
        
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    //网络错误
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_SPECIAL_ERROR object:nil];
    
    //请求数据成功与失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_MYSHOWSPECIALDETAIL_GET_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_MYSHOWSPECIALDETAIL_GET_FAIL object:nil];
    
    //请求数据成功与失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceedNew:) name:USER_MYSHOWSPECIALDETAILGRID_GET_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFailNew:) name:USER_MYSHOWSPECIALDETAILGRID_GET_FAIL object:nil];
    //赞成功与失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseSucceed) name:USER_MYSHOWPRAISE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseFail:) name:USER_MYSHOWPRAISE_FAIL object:nil];
    
    //取消赞成功与失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseSucceed) name:USER_MYSHOWCANCELPRAISE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseFail:) name:USER_MYSHOWCANCELPRAISE_FAIL object:nil];
    
    //删除秀秀
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteShowSucceed:) name:USER_DELETE_SHOW_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteShowFail:) name:USER_DELETE_SHOW_FAIL object:nil];
    
    //添加关注
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusSucceed) name:USER_FOCUS_ON_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusFail:) name:USER_FOCUS_ON_FAIL object:nil];
    [self.navigationController setNavigationBarHidden:NO];
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.login_user_id =LOGIN_USER_ID;
    _page = 0;
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 67+34, SCREENWIDTH,SCREENHEIGHT-101)];
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    layout.minimumInteritemSpacing = 8;
    CGRect userFram = CGRectMake(0, 101, SCREENWIDTH, SCREENHEIGHT-101);
    _collectionView = [[UICollectionView alloc]initWithFrame:userFram collectionViewLayout:layout];
    [self setButtons];
    [self setRight];
    [self setBackButton];
    if (_isFromMyShow == YES) {
        _isselect = YES;
        [self setCollectionViewOfSpecialDetailGrid];
    }else{
        _isselect = NO;
        [self setTableviewUI];
        
    }
    
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.hasNewReview==YES) {
        if (_isselect == NO ) {
            [self refreshReviewCountInSection:_reviewSection];
            delegate.hasNewReview=NO;
            
        }
    }
    
}


#pragma  mark UI
-(void)setButtons
{
    self.button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button1.frame = CGRectMake(0, 64, SCREENWIDTH/2, 34);
    
    self.button1.backgroundColor = [BBSColor hexStringToColor:@"f0f0f0"];
    [self.button1 addTarget:self action:@selector(button1Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button1];
    self.button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    self.button2.frame = CGRectMake(SCREENWIDTH/2, 64, SCREENWIDTH/2, 34);
    
    [self.button2 addTarget:self action:@selector(button2Action) forControlEvents:UIControlEventTouchUpInside];
    self.button2.backgroundColor = [BBSColor hexStringToColor:@"f0f0f0"];
    [self.view addSubview:self.button2];
    
    if (_isFromMyShow == YES) {
        [self.button1 setBackgroundImage:[UIImage imageNamed:@"btn_specialhot"] forState:UIControlStateNormal];
        [self.button2 setBackgroundImage:[UIImage imageNamed:@"btn_specialnews"] forState:UIControlStateNormal];
    }else{
        [self.button1 setBackgroundImage:[UIImage imageNamed:@"btn_specialhots"] forState:UIControlStateNormal];
        [self.button2 setBackgroundImage:[UIImage imageNamed:@"btn_specialnew"] forState:UIControlStateNormal];
    }
    
}

-(void)button1Action{
    _isselect = NO;
    
    [self.button1 setBackgroundImage:[UIImage imageNamed:@"btn_specialhots"] forState:UIControlStateNormal];
    [self.button2 setBackgroundImage:[UIImage imageNamed:@"btn_specialnew"] forState:UIControlStateNormal];
    [self setTableviewUI];
}
-(void)button2Action//1
{
    _isselect = YES;
    [self.button1 setBackgroundImage:[UIImage imageNamed:@"btn_specialhot"] forState:UIControlStateNormal];
    [self.button2 setBackgroundImage:[UIImage imageNamed:@"btn_specialnews"] forState:UIControlStateNormal];
    
    
    [self setCollectionViewOfSpecialDetailGrid];
    
}

-(void)setTableviewUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    seachButton.hidden = YES;
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.backgroundColor=[UIColor whiteColor];
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableview];
    [self getdataWithChanel];
    //下拉刷新
    __weak SpecialDetailTVC *myShow=self;
    [_tableview addPullToRefreshWithActionHandler:^{
        myShow.isFresh=1;
        myShow.last_id = NULL;
        myShow.isFinished = 0;
        [myShow getdataWithChanel];
    }];
    
    //上拉加载更多
    [_tableview addInfiniteScrollingWithActionHandler:^{
        if (myShow.tableview.pullToRefreshView.state==SVInfiniteScrollingStateStopped && !myShow.isFinished) {
            [myShow requestMoreData];
        }
    }];
}
//布局collectionview
-(void)setCollectionViewOfSpecialDetailGrid
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    seachButton.hidden = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.alwaysBounceVertical = YES;//解决collectionview未占满屏时刷新的问题
    [self.view addSubview:_collectionView];
    [self  getDataOfSpecialDetailGrid];
    __weak SpecialDetailTVC *specialVC = self;
    [_collectionView addPullToRefreshWithActionHandler:^{
        specialVC.isFinishedInCollectionView=0;
        specialVC.isGetMoreInCollectionView = 0;
        specialVC.isFreshInCollectionView=1;
        _page=0;
        [specialVC getDataOfSpecialDetailGrid];
    }];
    [_collectionView addInfiniteScrollingWithActionHandler:^{
        if (specialVC.collectionView.pullToRefreshView.state == SVInfiniteScrollingStateStopped &&!specialVC.isFinishedInCollectionView) {
            [specialVC requestMoreDataInColloctionView];
            
        }
    }];
}
#pragma mark 刷新加载

-(void)requestMoreData{
    _isGetMore=1;
    _isFresh=0;
    [self getdataWithChanel];
}
-(void)requestMoreDataInColloctionView{
    
    _isGetMoreInCollectionView=1;
    _isFreshInCollectionView=0;
    if (_isFinishedInCollectionView==NO) {
        [self getDataOfSpecialDetailGrid];
    }
}

#pragma  mark data
-(void)getdataWithChanel//3
{
    NSDictionary *newParam;
    int netType ;
    netType = NetStyleSpecialDetail;
    // _tableview.frame = CGRectMake(0, 101, SCREENWIDTH,SCREENHEIGHT-101);
    newParam=[NSDictionary dictionaryWithObjectsAndKeys:
              LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%ld",  (long)self.cate_id],@"cate_id",self.last_id,@"last_id",nil];
    NetAccess *netAccess = [NetAccess sharedNetAccess];
    [netAccess getDataWithStyle:netType andParam:newParam];
    [LoadingView startOnTheViewController:self];
}

-(void)getDataOfSpecialDetailGrid
{
    if (!_isSearch) {
        NSLog(@"page = %ld",_page);
        
        NSDictionary *newParam1 = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%ld", (long)self.cate_id],@"cate_id",[NSString stringWithFormat:@"%ld",(long)_page],@"page", nil];
        NetAccess *netAccess = [NetAccess sharedNetAccess];
        [netAccess getDataWithStyle:NetsTyleSpecialDetailGridV andParam:newParam1];
        [LoadingView startOnTheViewController:self];
    }
    else{
        NSDictionary *newParam2 = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%ld", (long)self.cate_id],@"cate_id",[NSString stringWithFormat:@"%ld",(long)self.picture_id],@"user_id",[NSString stringWithFormat:@"%ld",(long)self.is_pic],@"is_pic", nil];
        NetAccess *netAcess = [NetAccess sharedNetAccess];
        [netAcess getDataWithStyle:NetsTyleSpecialDetailGridV andParam:newParam2];
        [LoadingView startOnTheViewController:self];
        _isSearch = NO;
        
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ((_tableview.pullToRefreshView)&& [_tableview.pullToRefreshView state] ==SVPullToRefreshStateLoading) {
        [_tableview.pullToRefreshView stopAnimating];
    }
    
    if (_tableview.infiniteScrollingView && [_tableview.infiniteScrollingView state]== SVInfiniteScrollingStateLoading) {
        [_tableview.infiniteScrollingView stopAnimating];
    }
    _tableview.frame =CGRectMake(0, 67+34, SCREENWIDTH,SCREENHEIGHT-101);
    [LoadingView stopOnTheViewController:self];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    self.tabBarController.tabBar.hidden = NO;
    
}



#pragma mark UI

-(void)setRight{
    UIButton *makeShowButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [makeShowButton setBackgroundImage:[UIImage imageNamed:@"btn_special_part"] forState:UIControlStateNormal];
    [makeShowButton addTarget:self  action:@selector(makeAShow) forControlEvents:UIControlEventTouchUpInside];
    makeShowButton.frame = CGRectMake(SCREENWIDTH-30, 2, 30, 15);
    seachButton = [UIButton buttonWithType:UIButtonTypeCustom];
    seachButton.hidden = YES;
    [seachButton setBackgroundImage:[UIImage imageNamed:@"btn_special_find"]  forState:UIControlStateNormal];
    [seachButton addTarget:self action:@selector(addSeacherBar) forControlEvents:UIControlEventTouchUpInside];
    seachButton.frame = CGRectMake(SCREENWIDTH-60, 2, 45, 15);
    UIBarButtonItem *makeItem = [[UIBarButtonItem alloc]initWithCustomView:makeShowButton];
    UIBarButtonItem *seachItem = [[UIBarButtonItem alloc]initWithCustomView:seachButton];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -5;
    
    NSArray *barArray = [NSArray arrayWithObjects:spaceItem,makeItem,seachItem ,nil];
    // NSArray *barArray = [NSArray arrayWithObjects:makeItem,seachItem, nil];
    self.navigationItem.rightBarButtonItems = barArray;
}
-(void)setBackButton{
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    _backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    _backBtn.adjustsImageWhenHighlighted = NO;
    UIBarButtonItem *onlyBack = [[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=onlyBack;
    
}
//添加搜索bar
-(void)addSeacherBar
{
    if (theSearchBar) {
        if (![theSearchBar isFirstResponder]) {
            [theSearchBar becomeFirstResponder];
        }
        return;
    }
    
    theSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(5, 0, SCREENWIDTH-5, 44)];
    theSearchBar.placeholder = @"用户名、序号";
    theSearchBar.tintColor=[BBSColor hexStringToColor:@"f9f3f3"];//光标的颜色
    theSearchBar.backgroundColor = [BBSColor hexStringToColor:NAVICOLOR ];
    theSearchBar.delegate = self;
    theSearchBar.tag = 2;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.navigationController.navigationBar addSubview:theSearchBar];
    [UIView commitAnimations];
    [theSearchBar becomeFirstResponder];
    
}


-(void)back
{
    
    //[self.navigationController popToRootViewControllerAnimated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)makeAShow{
    
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    
    if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
        
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
        return;
    }
    MakeAvtivityViewController *makeAShow=[[MakeAvtivityViewController alloc]init];
    makeAShow.Type=0;
    [makeAShow setHidesBottomBarWhenPushed:YES];
    makeAShow.refreshSpecialNewBlock = ^(NSString *login_user_id,NSInteger cateid){
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:APPNAME message:@"发帖成功请刷新" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alert show];
        [self button2Action];
    };
    
    makeAShow.cate_id = self.cate_id;
    [self.navigationController pushViewController:makeAShow animated:YES];
}
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 100) {
        if (buttonIndex==1) {
            AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate setStartViewController];
        }
    }
}


#pragma mark 实现collectionview的代理方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_newDataArray.count) {
        return _newDataArray.count;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //注册cell
    [collectionView registerClass:[SpecialDetailGridCollectionViewCell class] forCellWithReuseIdentifier:@"collectionView"];
    
    SpecialDetailGridCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionView" forIndexPath:indexPath];
    SpecialDetailGridItem *item = [_newDataArray objectAtIndex:indexPath.row];
    // item.rsort = 10000;
    if ( item.rsort >= 1000) {
        cell.numberLabel.font = [UIFont systemFontOfSize:12];
        
    }else if(item.rsort >=10000){
        cell.numberLabel.font = [UIFont systemFontOfSize:4];
    }
    cell.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)item.rsort];
    
    [cell.photoImage sd_setImageWithURL:[NSURL URLWithString:item.img_thumb]];
    self.navigationItem.title = item.cate_name;
    
    
    return cell;//为什么我的成长记录没有他们那种的红色标记
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((SCREENWIDTH-32)/3,(SCREENWIDTH-32)/3);
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SpecialDetailGridItem *item = [_newDataArray objectAtIndex:indexPath.row];
    ImageDetailViewController *detail = [[ImageDetailViewController alloc]init];
    detail.imgID = item.img_id;
    detail.userID = item.user_id;
    detail.thumbString = item.img_thumb;
    detail.rsort = item.rsort;
    detail.cateName = item.cate_name;
    detail.isPost = 0;
    detail.isSpecial = YES;
    detail.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detail animated:YES];
    
}

#pragma mark UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:searchResultsTableView]) {
        return searchResultsArray.count;
    }
    
    if (_dataArray.count) {
        NSArray *singleArray=[_dataArray objectAtIndex:section];
        return singleArray.count;
    }
    
    return 0;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if ([tableView isEqual:searchResultsTableView]) {
        return 1;
    }
    
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView isEqual:searchResultsTableView]) {
        return 50;
    }
    NSArray *singleArray=[_dataArray objectAtIndex:indexPath.section];
    MyOutPutBasicItem *item=[singleArray objectAtIndex:indexPath.row];
    return item.height;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([tableView isEqual:searchResultsTableView]) {
        
        [theSearchBar setHidden:YES];
        
        NSDictionary *rowDict = [searchResultsArray objectAtIndex:indexPath.row];
        NSNumber *picture_id = [rowDict objectForKey:@"id"];
        NSInteger pictureid = [picture_id integerValue];
        NSNumber *is_picN = [rowDict objectForKey:@"is_pic"];
        NSInteger is_pic = [is_picN integerValue];
        self.picture_id = pictureid;
        self.is_pic = is_pic;
        [theSearchBar resignFirstResponder];
        [self removeDimBackground];
        [theSearchBar removeFromSuperview];
        theSearchBar = nil;
        if (searchResultsTableView) {
            [searchResultsTableView removeFromSuperview];
        }
        _isSearch = YES;
        _isFinishedInCollectionView=0;
        _isGetMoreInCollectionView = 0;
        _isFreshInCollectionView=1;
        _page=0;
        [self getDataOfSpecialDetailGrid];
    }
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:searchResultsTableView]) {
        static NSString *identifier = @"searchResultsTableView";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        
        UIImageView *avatarImgV = [[UIImageView alloc]initWithFrame:CGRectMake(8, 6, 38, 38)];
        avatarImgV.image = [UIImage imageNamed:@"img_message_avatar_100"];
        avatarImgV.layer.masksToBounds = YES;
        avatarImgV.layer.cornerRadius = 19.0;
        [cell.contentView addSubview:avatarImgV];
        
        UILabel *nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 250, 30)];
        nicknameLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:nicknameLabel];
        
        UIView *seperatorLine = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, SCREENWIDTH, 0.5)];
        seperatorLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line"]];
        [cell.contentView addSubview:seperatorLine];
        
        NSDictionary *rowDict = [searchResultsArray objectAtIndex:indexPath.row];
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",[rowDict objectForKey:@"avatar"]]];
        [[SDWebImageManager sharedManager]downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            avatarImgV.image = image;
            
        }];
        nicknameLabel.text = [NSString stringWithFormat:@"%@",[rowDict objectForKey:@"nick_name"]];
        
        return cell;
    }
    
    
    NSArray *singleArray=[_dataArray objectAtIndex:indexPath.section];
    MyShowNewBasicItem *item=[singleArray objectAtIndex:indexPath.row];
    UITableViewCell *cell;
    //精选，人气宝宝
    ClickViewController *clickVC = [[ClickViewController alloc] init];
    
    
    if ([item isKindOfClass:[MyShowNewTitleItemToday class]]) {
        
        MyShowNewTitleItemToday *titleItem=(MyShowNewTitleItemToday *)item;
        //
        MyShowNewTitleTodayCell *todayCell=[tableView dequeueReusableCellWithIdentifier:titleItem.identify];
        if (!todayCell) {
            todayCell=[[MyShowNewTitleTodayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleItem.identify];
        }
        
        todayCell.timeLabel.text=titleItem.time;
        todayCell.nameLabel.text=titleItem.username;
        SDWebImageManager *manager=[SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:titleItem.avatarStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [todayCell.avatarBtn setBackgroundImage:image forState:UIControlStateNormal];
        }];
        CGRect nameFrame = todayCell.nameLabel.frame;
        CGSize size = [titleItem.username boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:todayCell.nameLabel.font} context:nil].size;
        
        if (!(item.level_img.length<= 0)) {
            [manager downloadImageWithURL:[NSURL URLWithString:item.level_img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                todayCell.levelImageView.frame = CGRectMake(nameFrame.origin.x + size.width + 1, nameFrame.origin.y+5, image.size.width*0.8,image.size.height*0.8);
                todayCell.levelImageView.image = image;
                
            }];
        } else {
            todayCell.levelImageView.image = nil;
        }
        [todayCell.levelImageView setClickToViewController:clickVC];
        
        todayCell.avatarBtn.indexpath=indexPath;
        todayCell.delegate=self;
        cell=todayCell;
        
    }else if ([item isKindOfClass:[MyShowNewTitleItemNotToday class]]){
        
        MyShowNewTitleItemNotToday *titleItemNT=( MyShowNewTitleItemNotToday *)item;
        //
        MyShowNewTitleNotTodayCell *notTodayCell=[tableView dequeueReusableCellWithIdentifier:titleItemNT.identify];
        if (!notTodayCell) {
            notTodayCell=[[MyShowNewTitleNotTodayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleItemNT.identify];
        }
        
        notTodayCell.dayLabel.text=titleItemNT.day;
        notTodayCell.monthLabel.text=[NSString stringWithFormat:@"%@月",titleItemNT.month];
        notTodayCell.yearLabel.text=[NSString stringWithFormat:@"%@年",titleItemNT.year];
        notTodayCell.nameLabel.text=titleItemNT.username;
        SDWebImageManager *manager=[SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:titleItemNT.avatarStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [notTodayCell.avatarBtn setBackgroundImage:image forState:UIControlStateNormal];
        }];
        
        CGRect nameFrame = notTodayCell.nameLabel.frame;
        CGSize size = [titleItemNT.username boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:notTodayCell.nameLabel.font} context:nil].size;
        
        if (!(item.level_img.length<= 0)) {
            [manager downloadImageWithURL:[NSURL URLWithString:item.level_img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                notTodayCell.levelImageView.frame =CGRectMake(nameFrame.origin.x + size.width + 1, nameFrame.origin.y+5, image.size.width*0.8,image.size.height*0.8);;
                notTodayCell.levelImageView.image = image;
                
            }];
        } else {
            notTodayCell.levelImageView.image = nil;
        }
        [notTodayCell.levelImageView setClickToViewController:clickVC];
        
        notTodayCell.avatarBtn.indexpath=indexPath;
        notTodayCell.delegate=self;
        cell=notTodayCell;
        
    }else if ([item isKindOfClass:[MyShowNewPickedTitleFocusItem class]]){
        
        MyShowNewPickedTitleFocusItem *titleItem=(MyShowNewPickedTitleFocusItem *)item;
        //
        MyShowNewPickedTitleCell *titleCell=[tableView dequeueReusableCellWithIdentifier:titleItem.identify];
        if (!titleCell) {
            titleCell=[[MyShowNewPickedTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleItem.identify];
        }
        
        titleCell.nameLabel.text=titleItem.username;
        SDWebImageManager *manager=[SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:titleItem.avatarStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [titleCell.avatarBtn setBackgroundImage:image forState:UIControlStateNormal];
        }];
        
        CGRect nameFrame = titleCell.nameLabel.frame;
        CGSize size = [titleItem.username boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:titleCell.nameLabel.font} context:nil].size;
        
        if (!(item.level_img.length<= 0)) {
            [manager downloadImageWithURL:[NSURL URLWithString:item.level_img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                titleCell.levelImageView.frame = CGRectMake(nameFrame.origin.x + size.width + 1, nameFrame.origin.y+5, image.size.width*0.8,image.size.height*0.8);
                titleCell.levelImageView.image = image;
            }];
        } else {
            titleCell.levelImageView.image = nil;
        }
        [titleCell.levelImageView setClickToViewController:clickVC];
        
        titleCell.delegate=self;
        titleCell.avatarBtn.indexpath=indexPath;
        titleCell.addFriendsBtn.indexpath=indexPath;
        
        cell=titleCell;
        
    }else if ([item isKindOfClass:[MyShowNewPickedTitleTodayItem class]]){
        //
        MyShowNewPickedTitleTodayItem *titleItem=(MyShowNewPickedTitleTodayItem *)item;
        MyShowNewPickedTitleFriendsCell *titleCell=[tableView dequeueReusableCellWithIdentifier:titleItem.identify];
        if (!titleCell) {
            titleCell=[[MyShowNewPickedTitleFriendsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleItem.identify];
        }
        titleCell.nameLabel.text=titleItem.username;
        titleCell.timeLabel.text=titleItem.time;
        SDWebImageManager *manager=[SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:titleItem.avatarStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [titleCell.avatarBtn setBackgroundImage:image forState:UIControlStateNormal];
        }];
        CGRect nameFrame = titleCell.nameLabel.frame;
        CGSize size = [titleItem.username boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:titleCell.nameLabel.font} context:nil].size;
        
        if (!(item.level_img.length<= 0)) {
            [manager downloadImageWithURL:[NSURL URLWithString:item.level_img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                titleCell.levelImageView.frame = CGRectMake(nameFrame.origin.x + size.width + 1, nameFrame.origin.y+5,image.size.width*0.8,image.size.height*0.8);
                titleCell.levelImageView.image = image;
                
            }];
        } else {
            titleCell.levelImageView.image = nil;
        }
        [titleCell.levelImageView setClickToViewController:clickVC];
        
        titleCell.delegate=self;
        titleCell.avatarBtn.indexpath=indexPath;
        cell=titleCell;
        
    }else if ([item isKindOfClass:[MyShowNewPickedTitleNotTodayItem class]]){
        
        MyShowNewPickedTitleNotTodayItem *titleItem=(MyShowNewPickedTitleNotTodayItem *)item;
        //
        MyShowNewPickedTitleNotTodayCell *titleCell=[tableView dequeueReusableCellWithIdentifier:titleItem.identify];
        if (!titleCell) {
            titleCell=[[MyShowNewPickedTitleNotTodayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleItem.identify];
        }
        titleCell.nameLabel.text=titleItem.username;
        titleCell.dayLabel.text=titleItem.day;
        titleCell.monthLabel.text=[NSString stringWithFormat:@"%@月",titleItem.month];
        titleCell.yearLabel.text=[NSString stringWithFormat:@"%@年",titleItem.year];
        SDWebImageManager *manager=[SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:titleItem.avatarStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [titleCell.avatarBtn setBackgroundImage:image forState:UIControlStateNormal];
        }];
        
        CGRect nameFrame = titleCell.nameLabel.frame;
        CGSize size = [titleItem.username boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:titleCell.nameLabel.font} context:nil].size;
        
        if (!(item.level_img.length<= 0)) {
            [manager downloadImageWithURL:[NSURL URLWithString:item.level_img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                titleCell.levelImageView.frame = CGRectMake(nameFrame.origin.x + size.width + 1, nameFrame.origin.y+5, image.size.width*0.8,image.size.height*0.8);
                titleCell.levelImageView.image = image;
                
            }];
        } else {
            titleCell.levelImageView.image = nil;
        }
        [titleCell.levelImageView setClickToViewController:clickVC];
        
        titleCell.delegate=self;
        titleCell.avatarBtn.indexpath=indexPath;
        cell=titleCell;
        
    }else if ([item isKindOfClass:[MyOutPutDescribeItem class]]){
        
        MyOutPutDescribeItem *desItem=(MyOutPutDescribeItem *)item;
        
        MyShowNewDescribeCell *desCell=[tableView dequeueReusableCellWithIdentifier:desItem.identify];
        if (!desCell) {
            desCell=[[MyShowNewDescribeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:desItem.identify];
        }
        desCell.describeLabel.frame=CGRectMake(14, 5, 292, desItem.height);
        desCell.describeLabel.text=desItem.desContent;
        desCell.describeLabel.indexPath = nil;
        desCell.describeLabel.clickDelegate = nil;
        desCell.describeLabel.textColor = [BBSColor hexStringToColor:@"6e6550"];
        cell=desCell;
        
    }else  if ([item isKindOfClass:[MyOutPutImgGroupItem class]]){
        
        MyOutPutImgGroupItem *imgItem=(MyOutPutImgGroupItem *) item;
        
        if (imgItem.photosArray.count==1) {
            
            MyOutPutSingleImgCell *singleImgCell=[tableView dequeueReusableCellWithIdentifier:imgItem.identify];
            if (!singleImgCell) {
                singleImgCell=[[MyOutPutSingleImgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imgItem.identify];
            }
            [singleImgCell.imgBtn setBackgroundImage:nil forState:UIControlStateNormal];
            singleImgCell.imgBtn.indexpath=indexPath;
            singleImgCell.delegate=self;
            [LoadingView startOntheView:singleImgCell.imgBtn];
            singleImgCell.imgBtn.frame=imgItem.frame;
            
            MyShowImageItem *imgthing=[imgItem.photosArray firstObject];
            
            SDWebImageManager *manager=[SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:imgthing.imageStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [LoadingView stopOnTheView:singleImgCell.imgBtn];
                CATransition *animation = [CATransition animation];
                [animation setDuration:0.1];
                [animation setFillMode:kCAFillModeForwards];
                [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
                [singleImgCell.imgBtn.layer addAnimation:animation forKey:nil];
                
                if (singleImgCell.imgBtn.indexpath==indexPath) {
                    
                    [singleImgCell.imgBtn setBackgroundImage:image forState:UIControlStateNormal];
                    
                }
                
            }];
            
            cell=singleImgCell;
            
        }else{
            
            MyShowNewPhotoCell *imgGroupCell=[tableView dequeueReusableCellWithIdentifier:imgItem.identify];
            if (!imgGroupCell) {
                imgGroupCell=[[MyShowNewPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imgItem.identify];
            }
            
            for (btnWithIndexPath *btn in imgGroupCell.btnArry) {
                btn.hidden=YES;
                [btn setBackgroundImage:nil forState:UIControlStateNormal];
            }
            
            imgGroupCell.delegate=self;
            
            NSUInteger maxNum=imgItem.photosArray.count>2?2:imgItem.photosArray.count;
            
            for (int i=0;  i< maxNum; i++) {
                
                MyShowImageItem *imgThing=[imgItem.photosArray objectAtIndex:i];
                btnWithIndexPath *btn=[imgGroupCell.btnArry objectAtIndex:i];
                [btn setBackgroundImage:nil forState:UIControlStateNormal];
                btn.hidden=NO;
                [LoadingView startOntheView:btn];
                btn.indexpath=indexPath;
                SDWebImageManager *manager=[SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:imgThing.imageStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [LoadingView stopOnTheView:btn];
                    CATransition *animation = [CATransition animation];
                    [animation setDuration:0.1];
                    [animation setFillMode:kCAFillModeForwards];
                    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
                    [btn.layer addAnimation:animation forKey:nil];
                    if (btn.indexpath==indexPath) {
                        [btn setBackgroundImage:image forState:UIControlStateNormal];
                        
                    }
                    
                }];
                
            }
            imgGroupCell.imageview.hidden=YES;
            if (imgItem.photosArray.count>2) {
                imgGroupCell.countLabel.text=[NSString stringWithFormat:@"%lu张",(unsigned long)imgItem.photosArray.count];
                imgGroupCell.imageview.hidden=NO;
            }
            
            cell=imgGroupCell;
            
        }
        
    }else if ([item isKindOfClass:[MyOutPutPraiseAndReviewItem class]]){
        
        MyOutPutPraiseAndReviewItem *pItem=(MyOutPutPraiseAndReviewItem *)item;
        
        MyOutPutPraiseAndReviewCell *pCell=[tableView dequeueReusableCellWithIdentifier:pItem.identify];
        if (!pCell) {
            pCell=[[MyOutPutPraiseAndReviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pItem.identify];
        }
        [pCell.praiseBtn setTitle:[NSString stringWithFormat:@"%@",pItem.praise_count] forState:UIControlStateNormal];
        [pCell.reviewBtn setTitle:[NSString stringWithFormat:@"%@",pItem.review_count] forState:UIControlStateNormal];
        if (pItem.isPraised==YES) {
            [pCell.praiseBtn setBackgroundImage:[UIImage imageNamed:@"btn_myoutput_praised"] forState:UIControlStateNormal];
        }else{
            [pCell.praiseBtn setBackgroundImage:[UIImage imageNamed:@"btn_unlike"] forState:UIControlStateNormal];
        }
        pCell.delegate=self;
        
        [pCell.seperateView removeFromSuperview];
        pCell.shareButton.hidden = NO;
        pCell.shareButton.tag = indexPath.section;
        pCell.praiseBtn.tag=indexPath.section;
        pCell.reviewBtn.tag=indexPath.section;
        pCell.moreBtn.tag=indexPath.section;
        cell=pCell;
        
    }
    else if ([item isKindOfClass:[SpecialPartPeopleItem class]])
    {
        
        SpecialPartPeopleItem *partItem = (SpecialPartPeopleItem *)item;
        self.navigationItem.title = partItem.cate_name;
        self.cateName = partItem.cate_name;
        SpecialAvatarsCell *avatarCell = [tableView dequeueReusableCellWithIdentifier:partItem.identify];
        if (!avatarCell ) {
            avatarCell = [[SpecialAvatarsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:partItem.identify];
            
        }
        if (partItem.interation_count) {
            avatarCell.partLabel.text = [NSString stringWithFormat:@"有%@人看了TA",partItem.interation_count];
            
        }else{
            avatarCell.partLabel.text = [NSString stringWithFormat:@"有人看了TA"];
            
            
        }
        NSArray *avasArray = partItem.avatars;
        self.avaMutableArray = [NSMutableArray array];
        for (NSDictionary *avatarDic  in avasArray) {
            [self.avaMutableArray addObject:avatarDic[@"avatar"]];
        }
        if (self.avaMutableArray.count == 5) {
            [avatarCell.avatarImageView1 sd_setImageWithURL:[NSURL URLWithString:self.avaMutableArray[0]] placeholderImage:[UIImage imageNamed:@"img_my_home_page_header_132"]];
            [avatarCell.avatarImageView2 sd_setImageWithURL:[NSURL URLWithString:self.avaMutableArray[1]]placeholderImage:[UIImage imageNamed:@"img_my_home_page_header_132"]];
            [avatarCell.avatarImageView3 sd_setImageWithURL:[NSURL URLWithString:self.avaMutableArray[2]] placeholderImage:[UIImage imageNamed:@"img_my_home_page_header_132"]];
            [avatarCell.avatarImageView4 sd_setImageWithURL:[NSURL URLWithString:self.avaMutableArray[3]]placeholderImage:[UIImage imageNamed:@"img_my_home_page_header_132"]];
            [avatarCell.avatarImageView5 sd_setImageWithURL:[NSURL URLWithString:self.avaMutableArray[4]]placeholderImage:[UIImage imageNamed:@"img_my_home_page_header_132"]];
            
            
        }else if (self.avaMutableArray.count == 4){
            [avatarCell.avatarImageView1 sd_setImageWithURL:[NSURL URLWithString:self.avaMutableArray[0]] placeholderImage:[UIImage imageNamed:@"img_my_home_page_header_132"]];
            [avatarCell.avatarImageView2 sd_setImageWithURL:[NSURL URLWithString:self.avaMutableArray[1]]placeholderImage:[UIImage imageNamed:@"img_my_home_page_header_132"]];
            [avatarCell.avatarImageView3 sd_setImageWithURL:[NSURL URLWithString:self.avaMutableArray[2]] placeholderImage:[UIImage imageNamed:@"img_my_home_page_header_132"]];
            [avatarCell.avatarImageView4 sd_setImageWithURL:[NSURL URLWithString:self.avaMutableArray[3]]placeholderImage:[UIImage imageNamed:@"img_my_home_page_header_132"]];
            
            avatarCell.avatarImageView5.image = [UIImage imageNamed:@"img_my_home_page_header"];
            
        }else if (self.avaMutableArray.count == 3){
            [avatarCell.avatarImageView1 sd_setImageWithURL:[NSURL URLWithString:self.avaMutableArray[0]] placeholderImage:[UIImage imageNamed:@"img_my_home_page_header_132"]];
            [avatarCell.avatarImageView2 sd_setImageWithURL:[NSURL URLWithString:self.avaMutableArray[1]]placeholderImage:[UIImage imageNamed:@"img_my_home_page_header_132"]];
            [avatarCell.avatarImageView3 sd_setImageWithURL:[NSURL URLWithString:self.avaMutableArray[2]] placeholderImage:[UIImage imageNamed:@"img_my_home_page_header_132"]];
            avatarCell.avatarImageView4.image = [UIImage imageNamed:@"img_my_home_page_header"];
            avatarCell.avatarImageView5.image = [UIImage imageNamed:@"img_my_home_page_header"];
            
        }else if (self.avaMutableArray.count == 2){
            [avatarCell.avatarImageView1 sd_setImageWithURL:[NSURL URLWithString:self.avaMutableArray[0]] placeholderImage:[UIImage imageNamed:@"img_my_home_page_header_132"]];
            [avatarCell.avatarImageView2 sd_setImageWithURL:[NSURL URLWithString:self.avaMutableArray[1]]placeholderImage:[UIImage imageNamed:@"img_my_home_page_header_132"]];
            avatarCell.avatarImageView3.image = [UIImage imageNamed:@"img_my_home_page_header"];
            avatarCell.avatarImageView4.image = [UIImage imageNamed:@"img_my_home_page_header"];
            avatarCell.avatarImageView5.image = [UIImage imageNamed:@"img_my_home_page_header"];
            
        }
        
        
        //[avatarCell.avatarImageView1 sd_setImageWithURL:<#(NSURL *)#> placeholderImage:<#(UIImage *)#>
        cell = avatarCell;
    }
    //    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)refreshReviewCountInSection:(NSInteger) section{
    
    NSMutableArray *singleArray=[_dataArray objectAtIndex:section];
    MyShowNewBasicItem *item=[singleArray firstObject];
    
    NSDictionary *newParam=[NSDictionary dictionaryWithObjectsAndKeys:item.userid,@"user_id",
                            LOGIN_USER_ID,@"login_user_id",
                            @"1",@"is_new",
                            item.imgid,@"img_id",nil];
    UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kImgInfo Method:NetMethodGet andParam:newParam];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
    __weak ASIHTTPRequest *blockRequest = request;
    [request setCompletionBlock:^{
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:blockRequest.responseData options:0 error:nil];
        
        if ([[dic objectForKey:@"success"] integerValue]==1) {
            
            NSArray *dataArray=[dic objectForKey:@"data"];
            
            for (NSDictionary *dic in dataArray) {
                
                NSDictionary *imgDic=[dic objectForKey:kMyShowImg];
                NSInteger a = singleArray.count - 2;
                MyOutPutPraiseAndReviewItem *pItem=singleArray[a];
                pItem.review_count=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"review_count"]];
                
            }
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:singleArray.count-2 inSection:section];
            NSArray *indexArray=[NSArray arrayWithObjects:indexPath, nil];
            [_tableview reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
            
        }
        else{
            
        }
        
    }];
    [request startAsynchronous];
    
    [LoadingView stopOnTheViewController:self];
    
    
}
-(void)refreshTitleInSection:(NSInteger) section{
    
    NSMutableArray *singleArray=[_dataArray objectAtIndex:section];
    MyShowNewBasicItem *item=[singleArray firstObject];
    
    NSDictionary *newParam=[NSDictionary dictionaryWithObjectsAndKeys:item.userid,@"user_id",
                            LOGIN_USER_ID,@"login_user_id",
                            @"1",@"is_new",
                            item.imgid,@"img_id",nil];
    UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kImgInfo Method:NetMethodGet andParam:newParam];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
    __weak ASIHTTPRequest *blockRequest = request;
    [request setCompletionBlock:^{
        
        NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:blockRequest.responseData options:0 error:nil];
        
        if ([[dic objectForKey:@"success"] integerValue]==1) {
            
            NSArray *dataArray=[dic objectForKey:@"data"];
            
            for (NSDictionary *dic in dataArray) {
                
                NSDictionary *imgDic=[dic objectForKey:kMyShowImg];
                
                NSNumber *time=[imgDic objectForKey:kMyShowCreatTime];
                
                if ([[imgDic objectForKey:@"is_focus"] intValue]==0) {
                    
                    MyShowNewPickedTitleFocusItem *titleItem=[[MyShowNewPickedTitleFocusItem alloc]init];
                    titleItem.imgid=[imgDic objectForKey:kMyShowImgId];
                    titleItem.height=43;
                    titleItem.avatarStr=[imgDic objectForKey:@"avatar"];
                    titleItem.username=[imgDic objectForKey:@"user_name"];
                    titleItem.userid=[imgDic objectForKey:@"user_id"];
                    titleItem.identify=@"TITLEFOCUS";
                    [singleArray replaceObjectAtIndex:0 withObject:titleItem];
                    
                }else if ([BBSTimeTool isToday:time]==YES){
                    
                    MyShowNewPickedTitleTodayItem *titleItem=[[MyShowNewPickedTitleTodayItem alloc]init];
                    titleItem.imgid=[imgDic objectForKey:kMyShowImgId];
                    titleItem.time=[BBSTimeTool getTimeStrFromNow:time];
                    titleItem.height=43;
                    titleItem.avatarStr=[imgDic objectForKey:@"avatar"];
                    titleItem.username=[imgDic objectForKey:@"user_name"];
                    titleItem.userid=[imgDic objectForKey:@"user_id"];
                    titleItem.identify=@"PICKEDTITLETODAY";
                    [singleArray replaceObjectAtIndex:0 withObject:titleItem];
                    
                }else if ([BBSTimeTool isToday:time]==NO){
                    
                    MyShowNewPickedTitleNotTodayItem *titleItem=[[MyShowNewPickedTitleNotTodayItem alloc]init];
                    titleItem.imgid=[imgDic objectForKey:kMyShowImgId];
                    titleItem.avatarStr=[imgDic objectForKey:@"avatar"];
                    titleItem.username=[imgDic objectForKey:@"user_name"];
                    titleItem.userid=[imgDic objectForKey:@"user_id"];
                    NSDateComponents *components=[BBSTimeTool MyOutPutGetTime:time];
                    titleItem.day=[NSString stringWithFormat:@"%ld",(long)[components day]];
                    if (titleItem.day.length<2) {
                        titleItem.day=[NSString stringWithFormat:@"0%ld",(long)[components day]];
                    }
                    titleItem.month=[NSString stringWithFormat:@"%ld",(long)[components month]];
                    titleItem.year=[NSString stringWithFormat:@"%ld",(long)[components year]];
                    titleItem.height=42;
                    titleItem.identify=@"PICKEDTITLENOTTODAY";
                    [singleArray replaceObjectAtIndex:0 withObject:titleItem];
                    
                }
            }
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:section];
            NSArray *indexArray=[NSArray arrayWithObjects:indexPath, nil];
            [_tableview reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
            
        }
        else{
            
        }
        
        
    }];
    [request startAsynchronous];
    
    [LoadingView stopOnTheViewController:self];
    
}

-(void)focusSucceed{
    
    [self refreshTitleInSection:_focusSection];
    
}

-(void)focusFail:(NSNotification *) note{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=note.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}

-(void)praiseSucceed{
    
    NSArray *singleArray=[_dataArray objectAtIndex:_praiseSection];
    for (MyOutPutBasicItem *item in singleArray) {
        
        if ([item isKindOfClass:[MyOutPutPraiseAndReviewItem class]]) {
            
            MyOutPutPraiseAndReviewItem *pItem= (MyOutPutPraiseAndReviewItem *) item;
            
            int count=[pItem.praise_count intValue];
            
            if (pItem.isPraised==YES) {
                pItem.isPraised=NO;
                count--;
                pItem.praise_count=[NSString stringWithFormat:@"%d",count];
            }else{
                pItem.isPraised=YES;
                count++;
                pItem.praise_count=[NSString stringWithFormat:@"%d",count];
            }
            
        }
        
    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:singleArray.count-2 inSection:_praiseSection];
    NSArray *array=[NSArray arrayWithObject:indexPath];
    
    [_tableview reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    
    [LoadingView stopOnTheViewController:self];
    
}

-(void)praiseFail:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}

-(void)netFail{
    
    [LoadingView stopOnTheViewController:self];
    if ((_tableview.pullToRefreshView)&& [_tableview.pullToRefreshView state] ==SVPullToRefreshStateLoading) {
        [_tableview.pullToRefreshView stopAnimating];
    }
    
    if (_tableview.infiniteScrollingView && [_tableview.infiniteScrollingView state]== SVInfiniteScrollingStateLoading) {
        [_tableview.infiniteScrollingView stopAnimating];
    }
    
    if ((_collectionView.pullToRefreshView)&& [_collectionView.pullToRefreshView state] ==SVPullToRefreshStateLoading) {
        [_collectionView.pullToRefreshView stopAnimating];
    }
    
    if (_collectionView.infiniteScrollingView && [_collectionView.infiniteScrollingView state]== SVInfiniteScrollingStateLoading) {
        [_collectionView.infiniteScrollingView stopAnimating];
    }

    
    
}
//提示菊花
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



-(void)getDataSucceed:(NSNotification *) note{
    
    
    NSString *styleString=note.object;
    
    NetAccess *net=[NetAccess sharedNetAccess];
    NSArray *returnArray=[net getReturnDataWithNetStyle:[styleString intValue]];
    
    if (_isFresh==YES) {
        [_dataArray removeAllObjects];
        [_tableview scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        [_tableview reloadData];
        _isFresh=NO;
    }
    
    if (returnArray.count) {
        
        if (_selectedIndex == 0) {
            [_dataArray addObjectsFromArray:returnArray];
            
            [_tableview reloadData];
            
        }
    }else{
        
        _isFinished=1;
        // [self showHUDWithMessage:@"已没有更多数据"];
        
    }
    
    if (_dataArray.count) {
        NSArray *singleArray=[_dataArray lastObject];
        SpecialPartPeopleItem *pItem1 = [singleArray lastObject];
        self.last_id = pItem1.rank;
        
    }
    
    if ((_tableview.pullToRefreshView)&& [_tableview.pullToRefreshView state] ==SVPullToRefreshStateLoading) {
        [_tableview.pullToRefreshView stopAnimating];
    }
    
    if (_tableview.infiniteScrollingView && [_tableview.infiniteScrollingView state]== SVInfiniteScrollingStateLoading) {
        [_tableview.infiniteScrollingView stopAnimating];
    }
    
    [LoadingView stopOnTheViewController:self];
    
}


-(void)getDataFail:(NSNotification *) not{
    [_tableview.pullToRefreshView stopAnimating];
    [_tableview.infiniteScrollingView stopAnimating];
    
    [LoadingView stopOnTheViewController:self];
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}
-(void)getDataSucceedNew:(NSNotification *) note{
    
    NetAccess *net=[NetAccess sharedNetAccess];
    NSString *styleString=note.object;
    NSArray *returnArray=[net getReturnDataWithNetStyle:[styleString intValue]];
    
    if (returnArray.count) {
        
        if (_isFreshInCollectionView==YES) {
            [_newDataArray removeAllObjects];
            _isFreshInCollectionView=NO;
        }
        
        [_newDataArray addObjectsFromArray:returnArray];
        [_collectionView reloadData];
        
    }else{
        
        _isFinishedInCollectionView=1;
        // [self showHUDWithMessage:@"已没有更多数据"];
        
    }
    if (returnArray.count) {
        _page++;
    }
    
    if ((_collectionView.pullToRefreshView)&& [_collectionView.pullToRefreshView state] ==SVPullToRefreshStateLoading) {
        [_collectionView.pullToRefreshView stopAnimating];
    }
    
    if (_collectionView.infiniteScrollingView && [_collectionView.infiniteScrollingView state]== SVInfiniteScrollingStateLoading) {
        [_collectionView.infiniteScrollingView stopAnimating];
    }
    
    [LoadingView stopOnTheViewController:self];
    
}

-(void)getDataFailNew:(NSNotification *) not{
    
    if ((_collectionView.pullToRefreshView)&& [_collectionView.pullToRefreshView state] ==SVPullToRefreshStateLoading) {
        [_collectionView.pullToRefreshView stopAnimating];
    }
    
    if (_collectionView.infiniteScrollingView && [_collectionView.infiniteScrollingView state]== SVInfiniteScrollingStateLoading) {
        [_collectionView.infiniteScrollingView stopAnimating];
    }
    
    [LoadingView stopOnTheViewController:self];
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}


#pragma mark - UISearchBarDelegate Methods
//点击搜索栏
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    if (![self.view viewWithTag:3]) {
        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH,  SCREENHEIGHT-64-49)];
        aView.backgroundColor = [UIColor blackColor];
        aView.alpha = 0.5f;
        aView.tag = 3;
        [self.view addSubview:aView];
        //        [self.view bringSubviewToFront:aView];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeTableView:)];
        [aView addGestureRecognizer:tapGes];
        
    }
    
    return YES;
}
//结束编辑
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
//取消搜索方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self removeDimBackground];
    [theSearchBar removeFromSuperview];
    theSearchBar = nil;
    if (searchResultsTableView) {
        [searchResultsTableView removeFromSuperview];
    }
}
//编辑的时候的
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return  YES;
}
//移除掉搜索
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

#pragma mark - 搜索用户 Methods
- (void)searchUserWithWord:(NSString *)keyWord{
    
    [LoadingView startOnTheViewController:self];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,kFindPartUserLogin_user_id,[keyWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],kFindPartUserSearch_word,[NSString stringWithFormat:@"%ld",(long)self.cate_id],@"cate_id",nil];
    [[HTTPClient sharedClient] getNew:kFindSpecialUser params:param success:^(NSDictionary *result) {
        [LoadingView stopOnTheViewController:self];
        if ([[result objectForKey:kBBSSuccess]intValue] == 1) {
            searchResultsArray = [result objectForKey:kBBSData];
            if (searchResultsArray==nil|| [searchResultsArray isKindOfClass:[NSNull class]]||searchResultsArray.count == 0){
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

#pragma mark cell_delegate

-(void)PickedBabyClickOnTheAvatar:(btnWithIndexPath *)btn{
    
    NSArray *singleArray=[_dataArray objectAtIndex:btn.indexpath.section];
    MyShowNewBasicItem *item=[singleArray objectAtIndex:btn.indexpath.row];
    
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.userid=[NSString stringWithFormat:@"%@",item.userid];
    myHomePage.hidesBottomBarWhenPushed=YES;
    
    if ([item.userid intValue]==[LOGIN_USER_ID intValue]) {
        
        myHomePage.Type=0;
        
    }else{
        
        myHomePage.Type=1;
        
    }
    
    [self.navigationController pushViewController:myHomePage animated:YES];
    
}

-(void)PickedTitleNotTodayGotoTheUserPage:(btnWithIndexPath *)btn{
    
    NSArray *singleArray=[_dataArray objectAtIndex:btn.indexpath.section];
    MyShowNewBasicItem *item=[singleArray objectAtIndex:btn.indexpath.row];
    
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.userid=[NSString stringWithFormat:@"%@",item.userid];
    myHomePage.hidesBottomBarWhenPushed=YES;
    
    if ([item.userid intValue]==[LOGIN_USER_ID intValue]) {
        
        myHomePage.Type=0;
        
    }else{
        
        myHomePage.Type=1;
        
    }
    
    [self.navigationController pushViewController:myHomePage animated:YES];
    
    
}

-(void)PickedTitleFriendsCellGotoTheUserPage:(btnWithIndexPath *)btn{
    NSArray *singleArray=[_dataArray objectAtIndex:btn.indexpath.section];
    MyShowNewBasicItem *item=[singleArray objectAtIndex:btn.indexpath.row];
    
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.userid=[NSString stringWithFormat:@"%@",item.userid];
    myHomePage.hidesBottomBarWhenPushed=YES;
    
    if ([item.userid intValue]==[LOGIN_USER_ID intValue]) {
        
        myHomePage.Type=0;
        
    }else{
        
        myHomePage.Type=1;
        
    }
    
    [self.navigationController pushViewController:myHomePage animated:YES];
    
}

-(void)PickedTitleCellGotoTheUserPage:(btnWithIndexPath *)btn{
    NSArray *singleArray=[_dataArray objectAtIndex:btn.indexpath.section];
    MyShowNewBasicItem *item=[singleArray objectAtIndex:btn.indexpath.row];
    
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.userid=[NSString stringWithFormat:@"%@",item.userid];
    myHomePage.hidesBottomBarWhenPushed=YES;
    
    if ([item.userid intValue]==[LOGIN_USER_ID intValue]) {
        
        myHomePage.Type=0;
        
    }else{
        
        myHomePage.Type=1;
        
    }
    
    [self.navigationController pushViewController:myHomePage animated:YES];
    
}

-(void)PickedTitleCellAddFocus:(btnWithIndexPath *)btn{
    
    _focusSection=btn.indexpath.section;
    
    NSArray *singleArray=[_dataArray objectAtIndex:btn.indexpath.section];
    MyShowNewBasicItem *item=[singleArray objectAtIndex:btn.indexpath.row];
    
    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
    [param setObject:item.userid forKey:@"idol_id"];
    [param setObject:LOGIN_USER_ID forKey:@"user_id"];
    
    NetAccess *net=[NetAccess sharedNetAccess];
    [net getDataWithStyle:NetStyleFocusOn andParam:param];
    [LoadingView startOnTheViewController:self];
    
}

-(void)ClickOnTheAvatar:(btnWithIndexPath *)btn{
    
    NSArray *singleArray=[_dataArray objectAtIndex:btn.indexpath.section];
    MyShowNewTitleItemToday *item=[singleArray objectAtIndex:btn.indexpath.row];
    
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.userid=[NSString stringWithFormat:@"%@",item.userid];
    myHomePage.hidesBottomBarWhenPushed=YES;
    
    if ([item.userid intValue]==[LOGIN_USER_ID intValue]) {
        
        myHomePage.Type=0;
        
    }else{
        
        myHomePage.Type=1;
        
    }
    
    [self.navigationController pushViewController:myHomePage animated:YES];
    
}

-(void)ClickOnTheAvatarNotToday:(btnWithIndexPath *)btn{
    
    NSArray *singleArray=[_dataArray objectAtIndex:btn.indexpath.section];
    MyShowNewTitleItemToday *item=[singleArray objectAtIndex:btn.indexpath.row];
    
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.userid=[NSString stringWithFormat:@"%@",item.userid];
    myHomePage.hidesBottomBarWhenPushed=YES;
    
    if ([item.userid intValue]==[LOGIN_USER_ID intValue]) {
        
        myHomePage.Type=0;
        
    }else{
        
        myHomePage.Type=1;
        
    }
    
    [self.navigationController pushViewController:myHomePage animated:YES];
}

-(void)jumpToTheWebView:(btnWithIndexPath *)btn{
    
    NSArray *singleArray=[_dataArray objectAtIndex:btn.indexpath.section];
    MyOutPutUrlItem *urlItem=[singleArray objectAtIndex:btn.indexpath.row];
    
    WebViewController *webVC=[[WebViewController alloc]init];
    webVC.urlStr=urlItem.url_string;
    [webVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:webVC animated:YES];
    
}

//点击图片进入图片详情

-(void)gotoTheDetail:(btnWithIndexPath *)btn{
    [_PhotoArray removeAllObjects];
    
    NSArray *singleArray=[_dataArray objectAtIndex:btn.indexpath.section];
    MyOutPutImgGroupItem *photoItem=[singleArray objectAtIndex:btn.indexpath.row];
    
    NSMutableArray *imgArr = [[NSMutableArray alloc]init];
    int i = 0;
    for (MyShowImageItem *imgItem in photoItem.photosArray) {
        
        NSMutableDictionary *imgDic=[[NSMutableDictionary alloc]init];
        [imgDic setObject:imgItem.imageClearStr forKey:kMyShowImg];
        //[imgDic setObject:imgItem.img_down forKey:kMyShowImgDown];
        [imgDic setObject:imgItem.img_width forKey:kMyShowImgWidth];
        [imgDic setObject:imgItem.img_height forKey:kMyShowImgHeight];
        [imgDic setObject:imgItem.imageStr forKey:kMyShowImgThumb];
        [imgDic setObject:imgItem.img_thumb_width forKey:kMyShowImgThumbWidth];
        [imgDic setObject:imgItem.img_thumb_height forKey:kMyShowImgThumbHeight];
        [imgArr addObject:imgDic];
        MWPhoto *photo=[[MWPhoto alloc]initWithURL:[NSURL URLWithString:imgItem.imageClearStr] info:nil];
        photo.img_info =@{@"description": [NSString stringWithFormat:@"%d/%lu",i+1,(unsigned long)photoItem.photosArray.count]};
        [_PhotoArray addObject:photo];
        i++;
        
    }
    
    MWPhotoBrowser *browser =[[ MWPhotoBrowser alloc]initWithDelegate:self];
    //    browser.imgstr=imgItem.imageStr;
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    [browser setCurrentPhotoIndex:btn.tag];
    browser.type = 10;
    browser.needPlay = YES;     //需要播放
    browser.imgArr = imgArr;    //播放需要的东西
    browser.is_show_album =NO;
    browser.user_id =LOGIN_USER_ID;
    
    BBSNavigationController *nav=[[BBSNavigationController alloc]initWithRootViewController:browser];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)clickLabel:(ClickDescLabel *)label touchesWithIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *singleArray = [_dataArray objectAtIndex:indexPath.section];
    MyShowNewBasicItem *item = [singleArray objectAtIndex:0];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            LOGIN_USER_ID,@"login_user_id",
                            item.userid,@"user_id",
                            item.imgid,@"img_id",
                            item.create_time,@"create_time", nil];
    [LoadingView startOnTheViewController:self];
    __block SpecialDetailTVC *blockSelf = self;
    [[HTTPClient sharedClient] getNew:kGoToPost params:params success:^(NSDictionary *result) {
        [LoadingView stopOnTheViewController:self];
        if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
            NSDictionary *dict = [result objectForKey:kBBSData];
            PostBarNewDetialV1VC *detailVC=[[PostBarNewDetialV1VC alloc]init];
            detailVC.img_id = [dict objectForKey:@"img_id"];
            detailVC.user_id = item.userid;
            detailVC.login_user_id = LOGIN_USER_ID;
            detailVC.refreshInVC = ^(BOOL isRefresh){
                
            };
            [detailVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:detailVC animated:YES];
            
        } else {
            
        }
    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
    }];
    
}

//点击单张图片
-(void)SeeTheSingleImage:(btnWithIndexPath *)btn{
    
    [_PhotoArray removeAllObjects];
    
    NSArray *singleArray=[_dataArray objectAtIndex:btn.indexpath.section];
    MyOutPutImgGroupItem *photoItem=[singleArray objectAtIndex:btn.indexpath.row];
    
    NSMutableArray *imgArr = [[NSMutableArray alloc]init];
    int i = 0;
    for (MyShowImageItem *imgItem in photoItem.photosArray) {
        
        
        NSMutableDictionary *imgDic=[[NSMutableDictionary alloc]init];
        [imgDic setObject:imgItem.imageClearStr forKey:kMyShowImg];
        //[imgDic setObject:imgItem.img_down forKey:kMyShowImgDown];
        NSLog(@"imgDic = %@",imgDic);
        [imgDic setObject:imgItem.img_width forKey:kMyShowImgWidth];
        [imgDic setObject:imgItem.img_height forKey:kMyShowImgHeight];
        [imgDic setObject:imgItem.imageStr forKey:kMyShowImgThumb];
        [imgDic setObject:imgItem.img_thumb_width forKey:kMyShowImgThumbWidth];
        [imgDic setObject:imgItem.img_thumb_height forKey:kMyShowImgThumbHeight];
        [imgArr addObject:imgDic];
        MWPhoto *photo=[[MWPhoto alloc]initWithURL:[NSURL URLWithString:imgItem.imageClearStr] info:nil];
        photo.img_info =@{@"description": [NSString stringWithFormat:@"1/1"]};
        [_PhotoArray addObject:photo];
        i++;
        
    }
    
    MWPhotoBrowser *browser =[[ MWPhotoBrowser alloc]initWithDelegate:self];
    //    browser.imgstr=imgItem.imageStr;
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    [browser setCurrentPhotoIndex:btn.tag];
    browser.type = 10;
    browser.needPlay = NO;     //需要播放
    browser.imgArr = imgArr;    //播放需要的东西
    browser.is_show_album =NO;
    //  browser.user_id =self.userid;
    
    BBSNavigationController *nav=[[BBSNavigationController alloc]initWithRootViewController:browser];
    [self presentViewController:nav animated:YES completion:nil];
    
}

-(void)praise:(UIButton *)btn{
    
    _praiseSection=btn.tag;
    
    NetAccess *net=[NetAccess sharedNetAccess];
    
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:LOGIN_USER_ID forKey:kAdmireUserId];
    
    NSArray *singleArray=[_dataArray objectAtIndex:btn.tag];
    for (MyOutPutBasicItem *item in singleArray) {
        
        if ([item isKindOfClass:[MyOutPutPraiseAndReviewItem class]]) {
            
            MyOutPutPraiseAndReviewItem *pItem= (MyOutPutPraiseAndReviewItem *) item;
            [paramDic setObject:pItem.userid forKey:kAdmireAdmireId];
            [paramDic setObject:pItem.imgid forKey:kAdmireImgId];
            
            if (pItem.isPraised==YES) {
                [net getDataWithStyle:NetStyleCancelAdmire andParam:paramDic];
            }else{
                [net getDataWithStyle:NetStyleAdmire andParam:paramDic];
            }
            
        }
        
    }
    
    [LoadingView startOnTheViewController:self];
    
}

-(void)review:(UIButton *)btn{
    _reviewSection=btn.tag;
    NSArray *singleArray=[_dataArray objectAtIndex:btn.tag];
    MyOutPutPraiseAndReviewItem *pItem=singleArray[0];
    
    PraiseAndReviewListViewController *reviewsListVC=[[PraiseAndReviewListViewController alloc]init];
    // reviewsListVC.useridBePraised=self.userid;
    reviewsListVC.ownerId = pItem.userid;
    reviewsListVC.imgID=pItem.imgid;
    reviewsListVC.isPost=NO;
    reviewsListVC.isWorthBuy=NO;
    reviewsListVC.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:reviewsListVC animated:YES];
    
}

-(void)more:(UIButton *)btn{
    
    NSArray *singleArray=[_dataArray objectAtIndex:btn.tag];
    MyOutPutPraiseAndReviewItem *pItem= singleArray[2];
    NSArray *superUser = [BABYSHOWSUPERGRANTUSER componentsSeparatedByString:@","];
    BOOL isSuperGrant = NO;
    for (int i = 0 ; i < superUser.count; i++) {
        NSString *user = [superUser objectAtIndex:i];
        if ([LOGIN_USER_ID integerValue] == [user integerValue] )  {
            isSuperGrant = YES;
            break;
        }
    }
    
    NSString *message ;
    if ([pItem.userid intValue]==[LOGIN_USER_ID intValue] || isSuperGrant) {
        message = @"删除";
    }else{
        message = @"举报";
    }
    _deleteSection = btn.tag;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >=8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self shareToThird];
        }];
        [alertController addAction:[UIAlertAction actionWithTitle:message style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self deleteOrReport];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    } else {
        UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享",message,nil];
        action.tag=btn.tag;
        action.destructiveButtonIndex = action.numberOfButtons - 2;
        [action showFromTabBar:self.tabBarController.tabBar];
    }
    
}

#pragma mark - UIActionsheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    _deleteSection=actionSheet.tag;
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:NO];
    
    if (buttonIndex == 0) {
        
        //分享
        //如果actionsheet没有完全消失就调用分享列表会崩溃
        if (!actionSheet.isVisible) {
            [self shareToThird];
        }
        
    } else if (buttonIndex==1) {
        [self deleteOrReport];
    }//
    
}



-(void)share:(UIButton *)btn
{
    _deleteSection = btn.tag;
    [self shareToThird];
}

- (void)shareToThird {
    
    NSArray *singleArray=[_dataArray objectAtIndex:_deleteSection];
    NSString *userID,*imgID,*desc,*thumbString,*cate_name;
    NSInteger rsort;
    
    MyShowNewBasicItem *item = singleArray[0];
    userID = item.userid;
    imgID = item.imgid;
    
    SpecialPartPeopleItem *item1 = [singleArray lastObject];
    
    rsort = item1.rsort;
    cate_name = self.cateName;
    
    
    for (int i = 0; i < singleArray.count; i++) {
        
        if ([singleArray[i] isKindOfClass:[MyOutPutImgGroupItem class]]) {
            MyOutPutImgGroupItem *photoItem = singleArray[i];
            MyShowImageItem *imageItem = [photoItem.photosArray firstObject];
            thumbString = imageItem.imageStr;
            continue;
        }
        if ([singleArray[i] isKindOfClass:[MyOutPutDescribeItem class]]) {
            MyOutPutDescribeItem *descItem = singleArray[i];
            desc = [NSString stringWithFormat:@"我在自由环球租赁参与了【%@】活动，我是%ld号，请大家帮我投一票吧！爱你呦",cate_name,(long)rsort];
            NSLog(@"des = %@",desc);
            if ([desc hasPrefix:@"//来自☆话题//"]) {
                desc = [desc substringFromIndex:[desc rangeOfString:@"//来自☆话题//"].length];
            }
            break;
        }
    }
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray;
    NSString *titleStr = [NSString stringWithFormat:@"我在自由环球租赁参与了【%@】活动",cate_name];
    
    if (thumbString.length > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",thumbString]];
        UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        NSData *basicImgData = UIImagePNGRepresentation(shareImg);
        if (basicImgData.length/1024>150) {
            shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
            
        }
        
        imageArray = @[shareImg];
    }else{
        imageArray = @[[UIImage imageNamed:@"img_default"]];
        
    }
    NSString *urlString = [NSString stringWithFormat:@"%@img_id=%@&user_id=%@",AppShareUrl,imgID,userID];
    [shareParams SSDKSetupShareParamsByText:desc
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]
                                      title:titleStr
                                       type:SSDKContentTypeAuto];
    //设置新浪微博
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",desc,[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:titleStr image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
    
    //分享
    [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateBegin:
            {
                //  [storeVC showLoadingView:YES];
                break;
            }
            case SSDKResponseStateSuccess:
            {
                //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
                break;
            }
            case SSDKResponseStateCancel:
            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
                break;
            }
                
            default:
                break;
        }
    }];
    
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)copyURL:(NSString *)string {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:string];
}

- (void)deleteOrReport
{
    NSArray *singleArray=[_dataArray objectAtIndex:_deleteSection];
    MyOutPutPraiseAndReviewItem *pItem=singleArray[2];
    
    NSArray *superUser = [BABYSHOWSUPERGRANTUSER componentsSeparatedByString:@","];
    BOOL isSuperGrant = NO;
    for (int i = 0 ; i < superUser.count; i++) {
        NSString *user = [superUser objectAtIndex:i];
        if ([LOGIN_USER_ID integerValue] == [user integerValue] )  {
            isSuperGrant = YES;
            break;
        }
    }
    
    if ([pItem.userid intValue]==[LOGIN_USER_ID intValue] || isSuperGrant) {
        
        //删除
        [LoadingView startOnTheViewController:self];
        
        NetAccess *net=[NetAccess sharedNetAccess];
        NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
        [paramDic setObject:LOGIN_USER_ID forKey:@"user_id"];
        [paramDic setObject:pItem.imgid forKey:@"img_ids"];
        
        [net getDataWithStyle:NetStyleDelSpecial andParam:paramDic];
        
    }else{
        
        //举报
        ReportViewController *report=[[ReportViewController alloc]init];
        report.imgId=pItem.imgid;
        report.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:report animated:YES];
        
    }
    
}
#pragma mark 删除秀秀

-(void)deleteShowSucceed:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];
    
    NSIndexSet *set=[[NSIndexSet alloc]initWithIndex:_deleteSection];
    
    NSArray *itemsArray=[_dataArray objectAtIndex:_deleteSection];
    NSMutableArray *indexPathsArray=[[NSMutableArray alloc]init];
    
    for (int i=0;i<itemsArray.count;i++) {
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:_deleteSection];
        [indexPathsArray addObject:indexPath];
        
    }
    
    [_dataArray removeObjectAtIndex:_deleteSection];
    
    [_tableview beginUpdates];
    
    [_tableview deleteRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationFade];
    [_tableview deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
    
    [_tableview endUpdates];
    
    [_tableview reloadData];
}

-(void)deleteShowFail:(NSNotification *)not{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}

#pragma mark - MWPhotoBrowserDelegate

-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    
    return _PhotoArray.count;
    
}
-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    if (index < _PhotoArray.count) {
        
        return [_PhotoArray objectAtIndex:index];
        
    }
    
    return nil;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
