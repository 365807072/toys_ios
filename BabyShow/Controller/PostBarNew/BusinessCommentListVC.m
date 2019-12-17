//
//  BusinessCommentListVC.m
//  BabyShow
//
//  Created by WMY on 15/11/4.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "BusinessCommentListVC.h"
#import "SVPullToRefresh.h"
#import "BusinessCommentListItem.h"
#import "BusinessCommentListCell.h"
#import "UIImageView+WebCache.h"

@interface BusinessCommentListVC ()
{
    UITableView *_tableView;
    BOOL _isRefresh;
    BOOL _isGetMore;
    BOOL _isFinished;
    NSMutableArray *_dataArray;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) BOOL isGetMore;
@property (nonatomic, assign) BOOL isFinished;
@property(nonatomic,strong)NSString *postCreatTime;

@end

@implementation BusinessCommentListVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = [NSMutableArray array];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_ORDER_BUSINESS_GETCOMMENTLIST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_ORDER_BUSINESS_GETCOMMENTLIST_FAIL object:nil];
    //网络错误
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    
    self.tabBarController.tabBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setTableViewBussinessList];
    [self setLeftButton];
    // Do any additional setup after loading the view.
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
    
}

#pragma mark UI
//返回按钮
-(void)setLeftButton{
    
    //返回按钮
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 31)];
    imagev.image = [UIImage imageNamed:@"btn_back1.png"];
    [_backBtn addSubview:imagev];
    UILabel *cateName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 31)];
    cateName.textColor = [UIColor whiteColor];
    cateName.text = @"更多评论";
    [_backBtn addSubview:cateName];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)setTableViewBussinessList{
    
    CGRect tableviewFrame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    _tableView=[[UITableView alloc]initWithFrame:tableviewFrame];
    _tableView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
    [self getData];
    
    __weak BusinessCommentListVC *storeMoreList=self;
    [_tableView addPullToRefreshWithActionHandler:^{
        storeMoreList.isRefresh=YES;
        storeMoreList.isFinished=NO;
        storeMoreList.isGetMore=NO;
        storeMoreList.postCreatTime=NULL;
        [storeMoreList getData];
        
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        
        if (!storeMoreList.isFinished) {
            if (storeMoreList.tableView.pullToRefreshView.state==SVInfiniteScrollingStateStopped) {
                [storeMoreList getData];
            }
        }else{
            if (storeMoreList.tableView.infiniteScrollingView && storeMoreList.tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
                [storeMoreList.tableView.infiniteScrollingView stopAnimating];
            }
            
        }
        
    }];
    
}
#pragma mark data数据
-(void)getData{
    NetAccess *net=[NetAccess sharedNetAccess];
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.businessId,@"business_id",self.postCreatTime,@"post_create_time",nil];
    [net getDataWithStyle:NetStyleBusinessCommentList andParam:paramDic];
    [LoadingView startOnTheViewController:self];

    
}
#pragma mark  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BusinessCommentListItem *item = [_dataArray objectAtIndex:indexPath.row];
    return item.height+70;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [NSString stringWithFormat:@"BUSINESSLIST"];
    BusinessCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[BusinessCommentListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    BusinessCommentListItem *item = [_dataArray objectAtIndex:indexPath.row];
    cell.userLabel.text = item.userName;
    cell.timeCommentLabel.text = item.userTime;
    [cell.userImgView sd_setImageWithURL:[NSURL URLWithString:item.grade3]];
    cell.userCommentLabel.text = item.userMsg;
    cell.userCommentLabel.frame = CGRectMake(15, cell.userLevelLabel.frame.origin.y+cell.userLevelLabel.frame.size.height+10, SCREENWIDTH-22, item.height);
    cell.lineView.frame = CGRectMake(0, item.height+69, SCREENWIDTH, 0.5);
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
#pragma mark 系统通知
-(void)getDataSucceed:(NSNotification *) note{
    
    NSString *styleString=note.object;
    NetAccess *net=[NetAccess sharedNetAccess];
    NSArray *returnArray=[net getReturnDataWithNetStyle:[styleString intValue]];
    
    if (returnArray.count == 0) {
        _isFinished = YES;
        [self showHUDWithMessage:@"没有更多评价"];
        
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
        BusinessCommentListItem *item = [returnArray lastObject];
        self.postCreatTime = item.postCreatetime;
    }
    [LoadingView stopOnTheViewController:self];
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
    
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state == 2) {
        [_tableView.infiniteScrollingView stopAnimating];
        
    }
    [LoadingView stopOnTheViewController:self];
    
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark 当滚动的时候隐藏和显示导航条

CGPoint point;

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    point=scrollView.contentOffset;
    
}

-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
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
