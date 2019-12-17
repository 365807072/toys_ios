//
//  PostBarMoreViewController.m
//  BabyShow
//
//  Created by WMY on 15/8/28.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarMoreViewController.h"
//#import "PostBarNewDetailVC.h"
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
#import "StoreDetailNewVC.h"
#import "PostBarGroupNewVC.h"
#import "PostBarNewGroupOnlyOneVC.h"


@interface PostBarMoreViewController ()
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
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)NSArray *imagesArray;
@property(nonatomic,strong)UIImageView *imageV;
@property(nonatomic,strong)UILabel *titleLabels;

@end

@implementation PostBarMoreViewController
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_POSTMYINTERESTLIST_GET_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_POSTMYINTERESTLIST_GET_FAIL object:nil];
    //网络错误
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    
    self.tabBarController.tabBar.hidden = YES;
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
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
    
    [self getData];
    
    __weak PostBarMoreViewController *postBar=self;
    [_tableView addPullToRefreshWithActionHandler:^{
        postBar.isRefresh=YES;
        postBar.isFinished=NO;
        postBar.isGetMore=NO;
        postBar.create_time=NULL;
        [postBar getData];
        
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        
        if (!postBar.isFinished) {
            if (postBar.tableView.pullToRefreshView.state==SVInfiniteScrollingStateStopped) {
                [postBar getData];
            }
        }else{
            if (postBar.tableView.infiniteScrollingView && postBar.tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
                [postBar.tableView.infiniteScrollingView stopAnimating];
            }
            
        }
        
    }];
    
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
-(void)getData{
    NetAccess *net=[NetAccess sharedNetAccess];
    if ([self.fromShow isEqualToString:@"YES"]) {
        NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.create_time,@"post_create_time", nil];
        [net getDataWithStyle:NetStylePostGetGroupList andParam:paramDic];

    }else{
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%ld", (long)self.interestType],@"interest_type",self.create_time,@"create_time", nil];
    [net getDataWithStyle:NetStylePostMyInterestList andParam:paramDic];
    }
    [LoadingView startOnTheViewController:self];

    
}
#pragma mark  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 78;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell的重用
    //如果是话题的话，cell的格式
    NSString *identifier = [NSString stringWithFormat:@"MYINTERESTSELST"];
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
    }
    if (item.is_group == 1) {
        CGFloat a;
        if ([self.fromShow isEqualToString:@"YES"]) {
            cell.groupImageV.frame = CGRectMake(0, 2, 0, 0);
            a = cell.titleLabel.frame.size.width ;
            cell.groupImageV.image = [UIImage imageNamed:@"img_group_logo"];
            cell.titleLabelS.frame = CGRectMake(1, 0, a, 23);
            cell.photoView.layer.masksToBounds = YES;
            cell.photoView.layer.cornerRadius = 30;
        }else{
        cell.groupImageV.frame = CGRectMake(0, 2, 20, 20);
         a = cell.titleLabel.frame.size.width -20;
        cell.groupImageV.image = [UIImage imageNamed:@"img_group_logo"];
        cell.titleLabelS.frame = CGRectMake(21, 0, a, 23);
        cell.photoView.layer.masksToBounds = YES;
        cell.photoView.layer.cornerRadius = 30;
        }
    }else  if(item.is_group == 2){
        cell.groupImageV.frame = CGRectMake(0, 2, 20, 20);
        cell.groupImageV.image = [UIImage imageNamed:@"img_post_store@2x"];
        CGFloat a = cell.titleLabel.frame.size.width -20;
        cell.titleLabelS.frame = CGRectMake(21, 0, a, 23);
        cell.photoView.layer.masksToBounds = NO;
        
        
    }else{
        CGFloat b = cell.titleLabel.frame.size.width;
        cell.groupImageV.frame = CGRectMake(0, 0, 0, 0);
        cell.titleLabelS.frame = CGRectMake(0, 0, b, 23);
        cell.photoView.layer.masksToBounds = NO;
        
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
                self.create_time = NULL;
                _isFinished = 0;
                [self getData];
                
                
            }
        };
        
        //detailVC.isSaved=item.isSaved;
        [detailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
        
    }else if(item.is_group == 1){
        NSString *groupId = [NSString stringWithFormat:@"%ld",item.group_id];
        [self pushPostMyGroupDetailVC:groupId];
        
        
    }else{
        StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
        storeVC.longin_user_id = self.login_user_id;
        storeVC.business_id = item.imgId;
        [self.navigationController pushViewController:storeVC animated:YES];
        
        
        
    }
    
}

#pragma mark 跳转群详情
-(void)pushPostMyGroupDetailVC:(NSString *)imgId{
    PostBarNewGroupOnlyOneVC *postBarVC = [[PostBarNewGroupOnlyOneVC alloc]init];
    postBarVC.group_id = [imgId intValue];
    [self.navigationController pushViewController:postBarVC animated:YES];

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
        PostMyInterestItem *item = [returnArray lastObject];
        self.create_time = item.post_create_time;
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
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }

    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    
}

#pragma mark Private

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
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    if (scrollView == _headerScrollView) {
//        int page = scrollView.contentOffset.x / scrollView.frame.size.width;
//        CGPoint center = _pageView.center;
//        center.x = (page + 1.0/2.0) *_pageView.frame.size.width; //(page+1) * _pageView.frame.size.width/2;
//        
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.2];
//        _pageView.center = center;
//        [UIView commitAnimations];
//    }
//}
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
