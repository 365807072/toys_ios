//
//  PostBarSecondeVC.m
//  BabyShow
//
//  Created by WMY on 15/6/23.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarSecondeVC.h"

#import "PostBarNewMakeAPost.h"
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


#import "PostBarNewDetialV1VC.h"
#import "BabyShowPlayerVC.h"
#import "StoreDetailNewVC.h"

@interface PostBarSecondeVC ()
{
    
    UITableView *_tableView;
    UITableView *_categoryTableV;
    UIScrollView *_headerView;
    UIScrollView *_headerScrollView;
    UIView *_pageView;
    UIButton *_selectBtn;
    
    UIButton *_FTBtn;
    UIView *_emptyView;
    UIButton *topBtn;
    
    BOOL _isRefresh;
    BOOL _isGetMore;
    BOOL _isFinished;
    BOOL _isHideCategory;//隐藏分类
    
    NSMutableArray *_dataArray;
    NSArray *_headerViewArray;
    NSArray *_categoryArray;
    
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) BOOL isGetMore;
@property (nonatomic, assign) BOOL isFinished;
@property(nonatomic,strong)UIButton *button1;//我的兴趣
@property(nonatomic,strong)UIButton *button2;//成长记录
@property(nonatomic,strong)UIButton *button3;//育儿知识
@property(nonatomic,strong)UIButton *button4;//时尚情感
@property(nonatomic,strong)UIButton *button5;//辣妈厨房
@property(nonatomic,strong)UIButton *button6;//视频


@property(nonatomic,strong)NSArray *buttonsArray;//button按钮的数组
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)NSArray *imagesArray;
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *titleLabels;



@end

@implementation PostBarSecondeVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil//1
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray=[NSMutableArray array];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{//1
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_POSTLISTV5_GET_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_POSTLISTV5_GET_FAIL object:nil];
    //网络错误
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];

    self.tabBarController.tabBar.hidden = YES;
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.page =1;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self setHeaderView];
    self.navigationItem.title = self.titleString;
    [self setLeftButton];
    [self setTableView];
}
-(void)viewWillDisappear:(BOOL)animated{//1
    
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
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
}
#pragma mark UI
-(void)setTableView{
    
    CGRect tableviewFrame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    _tableView=[[UITableView alloc]initWithFrame:tableviewFrame];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
    
    [self getDataWithButton:self.post_classes];
    
    
    //类型是话题列表
    [_tableView setTableHeaderView:_headerView];
    
    __weak PostBarSecondeVC *postBar=self;
    [_tableView addPullToRefreshWithActionHandler:^{
        postBar.isRefresh=YES;
        postBar.isFinished=NO;
        postBar.isGetMore=NO;
        postBar.post_create_time=NULL;
        postBar.create_time=NULL;
        [postBar getDataWithButton:postBar.post_classes];
        
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        
        if (!postBar.isFinished) {
            if (postBar.tableView.pullToRefreshView.state==SVInfiniteScrollingStateStopped) {
                [postBar getDataWithButton:postBar.post_classes];
            }
        }else{
            if (postBar.tableView.infiniteScrollingView && postBar.tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
                [postBar.tableView.infiniteScrollingView stopAnimating];
            }
            
        }
        
    }];
    
}
-(void)setHeaderView

{
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
    
    
    _headerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 73)];
    _headerView.backgroundColor = [UIColor clearColor];
    _headerView.contentSize = CGSizeMake(SCREENWIDTH, 73);
    _headerView.showsHorizontalScrollIndicator = NO;
    _headerView.showsVerticalScrollIndicator = NO;
    
    _button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button1.frame = CGRectMake(12,10, 40, 57) ;
    [_button1 setBackgroundImage:[UIImage imageNamed:@"btn_wodexingque"]forState:UIControlStateNormal];
    [_button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _button1.tag = 300;
    
    [_headerView addSubview:_button1];
    
    _button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button2.frame = CGRectMake(_button1.frame.origin.x+40+24,10, 40, 57) ;
    [_button2 setBackgroundImage:[UIImage imageNamed:@"btn_huodong"]forState:UIControlStateNormal];
    [_button2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _button2.tag = 301;
    
    
    
    [_headerView addSubview:_button2];
    
    _button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button3.frame = CGRectMake(_button2.frame.origin.x+40+24,10, 40, 57) ;
    [_button3 setBackgroundImage:[UIImage imageNamed:@"btn_zhishi"]forState:UIControlStateNormal];
    [_button3 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _button3.tag = 302;
    
    [_headerView addSubview:_button3];
    
    _button4 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button4.frame = CGRectMake(_button3.frame.origin.x+40+24,10, 40, 57) ;
    [_button4 setBackgroundImage:[UIImage imageNamed:@"btn_qinggan"]forState:UIControlStateNormal];
    [_button4 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _button4.tag = 303;
    
    [_headerView addSubview:_button4];
    
//    _button6 = [UIButton buttonWithType:UIButtonTypeSystem];
//    _button6.frame = CGRectMake(_button4.frame.origin.x+40+24,10, 40, 57) ;
//    [_button6 setBackgroundImage:[UIImage imageNamed:@"btn_vedio"]forState:UIControlStateNormal];
//    [_button6 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
//    _button6.tag = 305;
//    
//    [_headerView addSubview:_button6];

    _button5 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button5.frame = CGRectMake(_button4.frame.origin.x+40+24,10, 40, 57) ;
    [_button5 setBackgroundImage:[UIImage imageNamed:@"btn_chufang"]forState:UIControlStateNormal];
    [_button5 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _button5.tag = 304;
    
    [_headerView addSubview:_button5];
    
    _buttonsArray = [[NSArray alloc]initWithObjects:_button1,_button2,_button3,_button4,_button5,_button6, nil];
    if (self.post_classes == 1) {
        [_button2 setBackgroundImage:[UIImage imageNamed:@"btn_huodongs"]forState:UIControlStateNormal];
        
    }else if(self.post_classes == 2) {
        [_button3 setBackgroundImage:[UIImage imageNamed:@"btn_zhishis"]forState:UIControlStateNormal];
        
    }else if(self.post_classes == 3) {
        [_button4 setBackgroundImage:[UIImage imageNamed:@"btn_qinggans"]forState:UIControlStateNormal];
        
    }else if(self.post_classes == 4) {
        [_button5 setBackgroundImage:[UIImage imageNamed:@"btn_chufangs"]forState:UIControlStateNormal];
        
    }
    _pageView = [[UIView alloc]initWithFrame:CGRectZero];
    _pageView.backgroundColor = [BBSColor hexStringToColor:BACKCOLOR];
    [_headerView addSubview:_pageView];
    
}
-(void)buttonAction:(id)sender
{
    
    UIButton *buttons = sender;
    NSInteger a = buttons.tag-300;
    if (a== 0) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        self.post_classes = a;
        for (int i = 0 ; i < _imageArray.count; i++) {
            if (a == i) {
                UIImage *image = _imageArray[i];
                [_buttonsArray[i] setBackgroundImage:image forState:UIControlStateNormal];
                
            }else{
                UIImage *image = _imagesArray[i];
                [_buttonsArray[i] setBackgroundImage:image forState:UIControlStateNormal];
            }
            
        }
        if (self.post_classes==1) {
            self.navigationItem.title = @"成长活动";
        }else if(self.post_classes==2) {
            self.navigationItem.title = @"育儿知识";
        }else if(self.post_classes==3) {
            self.navigationItem.title = @"时尚情感";
        }else if(self.post_classes==4) {
            self.navigationItem.title = @"辣妈厨房";
        }else if(self.post_classes==5) {
            self.navigationItem.title = @"视频";
        }

        _isRefresh = 1;
        self.post_create_time = NULL;
        _isFinished = 0;
        [self getDataWithButton:self.post_classes];
    }
}
//返回按钮
-(void)setLeftButton{
    
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
#pragma mark data
-(void)getDataWithButton:(NSInteger)postclasses{
    NetAccess *net=[NetAccess sharedNetAccess];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%ld", (long)self.post_classes],@"post_class",self.post_create_time,@"post_create_time", nil];
    [net getDataWithStyle:NetStylePostListV5 andParam:paramDic];
    [LoadingView startOnTheViewController:self];
}


#pragma mark  UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return _headerView;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return 78;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell的重用
    //如果是话题的话，cell的格式
    NSString *identifier = [NSString stringWithFormat:@"MYINTERESTSECOND"];
    PostMyInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PostMyInterestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    cell.label.frame = CGRectMake(0, 77, SCREENWIDTH, 1);
    PostMyInterestItem *item = [_dataArray objectAtIndex:indexPath.row];
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
        
        
    }else{
        cell.photoView.frame = CGRectMake(0, 0, 0, 0);
        cell.videoView.frame = CGRectMake(0, 0, 0, 0);
        cell.titleLabel.frame = CGRectMake(10, 8, 250, 20);
        cell.reviewLabel.frame = CGRectMake(10, 35, 200, 18);
        cell.descriptionLabel.frame = CGRectMake(10, 57, 213, 17);
    }
    if (item.is_group == 1 ) {
        cell.groupImageV.frame = CGRectMake(0, 2, 40, 18);
        CGFloat a = cell.titleLabel.frame.size.width -25;
        cell.groupImageV.image = [UIImage imageNamed:@"img_group_logo"];
        cell.titleLabelS.frame = CGRectMake(41, 0, a, 40);
        cell.photoView.layer.masksToBounds = YES;
        cell.photoView.layer.cornerRadius = 30;
        cell.videoView.frame = CGRectMake(0, 0, 0, 0);
        
    }else if(item.is_group == 2){
        cell.groupImageV.frame = CGRectMake(0, 2, 20, 20);
        cell.groupImageV.image = [UIImage imageNamed:@"img_post_store@2x"];
        CGFloat a = cell.titleLabel.frame.size.width -20;
        cell.titleLabelS.frame = CGRectMake(21, 0, a, 23);
        cell.photoView.layer.masksToBounds = NO;
        cell.videoView.frame = CGRectMake(0, 0, 0, 0);
        
    }else if(item.is_group == 5&&!(item.img.length <= 0)){
        CGFloat b = cell.titleLabel.frame.size.width;
        cell.groupImageV.frame = CGRectMake(0, 0, 0, 0);
        cell.titleLabelS.frame = CGRectMake(0, 0, b, 23);
        cell.photoView.layer.masksToBounds = NO;
        cell.videoView.frame = CGRectMake(20, 22, 67*0.5, 67*0.5);
    }
    else{
        CGFloat b = cell.titleLabel.frame.size.width;
        cell.groupImageV.frame = CGRectMake(0, 0, 0, 0);
        cell.titleLabelS.frame = CGRectMake(0, 0, b, 23);
        cell.photoView.layer.masksToBounds = NO;
        cell.videoView.frame = CGRectMake(0, 0, 0, 0);
        
    }
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
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    PostMyInterestItem *item=[_dataArray objectAtIndex:indexPath.row];
    if (item.is_group == 0) {
        PostBarNewDetialV1VC *detailVC=[[PostBarNewDetialV1VC alloc]init];
        detailVC.img_id=item.imgId;
        detailVC.user_id=item.userid;
        detailVC.login_user_id=self.login_user_id;
        detailVC.refreshInVC = ^(BOOL isRefresh){
            if (isRefresh == YES) {
                _isRefresh = 1;
                self.post_create_time = NULL;
                _isFinished = 0;
                [self getDataWithButton:self.post_classes];

                
            }
        };
        [detailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if(item.is_group == 1){
        PostMyGroupDetailVController*detailVC = [[PostMyGroupDetailVController alloc]init];
        detailVC.login_user_id = self.login_user_id;
        detailVC.group_id = item.group_id;
        detailVC.post_class = self.post_classes;
        detailVC.refreshBlock = ^(BOOL isRefresh){
            if (isRefresh == YES) {
                _isRefresh = 1;
                self.post_create_time = NULL;
                _isFinished = 0;
                [self getDataWithButton:self.post_classes];
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
        storeVC.longin_user_id = self.login_user_id;
        storeVC.business_id = item.imgId;
        [self.navigationController pushViewController:storeVC animated:YES];
        
    }
    
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
        if (self.post_classes == 0) {
            self.page++;
        }
        PostMyInterestItem *item = [returnArray lastObject];
        self.post_create_time = item.post_create_time;
        self.create_time = item.create_time;
        
        
    }
    [LoadingView stopOnTheViewController:self];
    topBtn.hidden = NO;
    if (_tableView) {
        [_tableView reloadData];
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

#pragma mark Private

- (void)selectCategory:(UIButton *)button {
    if (_isHideCategory) {
        _isHideCategory = NO;
    } else {
        _isHideCategory = YES;
    }
    _categoryTableV.hidden = _isHideCategory;
}
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        //up
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
        int page = scrollView.contentOffset.x / scrollView.frame.size.width;
        CGPoint center = _pageView.center;
        center.x = (page + 1.0/2.0) *_pageView.frame.size.width; //(page+1) * _pageView.frame.size.width/2;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.2];
        _pageView.center = center;
        [UIView commitAnimations];
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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
