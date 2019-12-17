//
//  StoreMainNewListVC.m
//  BabyShow
//
//  Created by WMY on 16/8/8.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "StoreMainNewListVC.h"
#import "StoreMoreListItem.h"
#import "UIImageView+WebCache.h"
#import "StoreMoreListCell.h"
#import "StoreDetailNewVC.h"
#import <MapKit/MapKit.h>
#import "RefreshControl.h"
@interface StoreMainNewListVC ()<RefreshControlDelegate>{
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    //当前定位的状态
    CLAuthorizationStatus status;
    RefreshControl *_refreshControl;

}
@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic,strong)NSString *cityId;
@property(nonatomic,assign)float latitude;//纬度
@property(nonatomic,assign)float longitude;//经度
@property(nonatomic,strong)CLLocationManager *locationManager;

@end

@implementation StoreMainNewListVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil//1
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{//1
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.cityId = @"0";
    _post_create_time = NULL;
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    [self setTableView];
    [self setLeftButton];
    [self refreshControlInit];
    
}
-(void)viewWillDisappear:(BOOL)animated{//1
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    [LoadingView stopOnTheViewController:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    
}
#pragma mark- refreshControl

-(void)refreshControlInit{
    _refreshControl                             = [[RefreshControl alloc] initWithScrollView:_tableView delegate:self];
    _refreshControl.topEnabled                  = YES;
    _refreshControl.bottomEnabled               = NO;
    [_refreshControl startRefreshingDirection:RefreshDirectionTop];
    
    
}
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    if (refreshControl == _refreshControl) {
        if (direction == RefreshDirectionTop) {
            _post_create_time                           = NULL;
        }
        [self getData];
    }
}
-(void)refreshComplete :(RefreshControl *)refreshControl{
    if (refreshControl.refreshingDirection==RefreshingDirectionTop)
    {
        [refreshControl finishRefreshingDirection:RefreshDirectionTop];
    }
    else if (refreshControl.refreshingDirection==RefreshingDirectionBottom)
    {
        [refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
    }
}
//返回按钮
-(void)setLeftButton{
    
    //返回按钮
        CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
        UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 31)];
        imagev.image = [UIImage imageNamed:@"btn_back1.png"];
        [_backBtn addSubview:imagev];
        UILabel *cateName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 190, 31)];
        cateName.textColor = [UIColor whiteColor];
        cateName.text = self.titleNav;
        [_backBtn addSubview:cateName];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.frame=backBtnFrame;
        UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
        self.navigationItem.leftBarButtonItem=left;
    
    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    moreBtn.frame = CGRectMake(0, -5, 30, 20);
    [moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreStore) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:moreBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
-(void)moreStore{
    theAppDelegate.tabbarcontroller.selectedIndex = 0;
    theAppDelegate.window.rootViewController = theAppDelegate.tabbarcontroller;
    [theAppDelegate.tabbarcontroller setBBStabbarSelectedIndex:1];

    
}
-(void)setTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect tableviewFrame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    _tableView=[[UITableView alloc]initWithFrame:tableviewFrame];
    _tableView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
    
    
}
#pragma mark data 商家数据
-(void)getData{
    NSMutableDictionary *paramDic;
    NSUserDefaults *defaultlat = [NSUserDefaults standardUserDefaults];
    NSString *lat = [defaultlat valueForKey:@"latitude"];
    NSUserDefaults *defaultlog = [NSUserDefaults standardUserDefaults];
    NSString *longitude = [defaultlog valueForKey:@"longitude"];
    paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.cityId,@"city_id",[NSString stringWithFormat:@"%@,%@",lat,longitude],@"mapsign",_post_create_time,@"post_create_time",nil];
    [paramDic setObject:[NSString stringWithFormat:@"%ld",self.tag_id] forKey:@"tag_id"];
    [paramDic setObject:self.img_ids forKey:@"img_ids"];
    
    UrlMaker *urlMarker = [[UrlMaker alloc]initWithNewV1UrlStr:kGetBusinessListV3 Method:NetMethodGet andParam:paramDic];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMarker.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:20];
    [request startAsynchronous];
    __weak ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        _refreshControl.topEnabled = YES;
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:@"success"]integerValue ]==1) {
            NSArray *dataArray = dic[@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
            for (NSDictionary *dataDic in dataArray) {
                NSDictionary *imgDic = dataDic[@"img"];
                StoreMoreListItem *storeMoreListItem = [[StoreMoreListItem alloc]init];
                storeMoreListItem.businessId =  MBNonEmptyString(imgDic[@"business_id"]);
                storeMoreListItem.businessPic =  MBNonEmptyString(imgDic[@"business_pic"]);
                storeMoreListItem.businessTitle =  MBNonEmptyString(imgDic[@"business_title"]);
                storeMoreListItem.post_create_time =  MBNonEmptyString(imgDic[@"post_create_time"]);
                storeMoreListItem.subtitle =  MBNonEmptyString(imgDic[@"subtitle"]);
                storeMoreListItem.distance =  MBNonEmptyString(imgDic[@"distance"]);
                storeMoreListItem.business_babyshow_price1 =  MBNonEmptyString(imgDic[@"business_babyshow_price1"]);
                storeMoreListItem.business_market_price1 =  MBNonEmptyString(imgDic[@"business_market_price1"]);
                storeMoreListItem.order_count =  MBNonEmptyString(imgDic[@"order_count"]);
                [returnArray addObject:storeMoreListItem];
            }
            if (returnArray.count == 0) {
                _refreshControl.bottomEnabled = NO;
            }
            if (_post_create_time == NULL) {
                [_dataArray removeAllObjects];
                _refreshControl.bottomEnabled = YES;
            }
            StoreMoreListItem *item = [returnArray lastObject];
            _post_create_time = item.post_create_time;
            [_dataArray addObjectsFromArray:returnArray];
            [_tableView reloadData];
            [self refreshComplete:_refreshControl];
            
        }else{
            [self refreshComplete:_refreshControl];
            
            [BBSAlert showAlertWithContent:[dic objectForKey:kBBSReMsg] andDelegate:self];
        }
    }];
    [request setFailedBlock:^{
        [self refreshComplete:_refreshControl];
        
    }];
    
}
#pragma mark  UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"STOREMORELIST"];
    StoreMoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[StoreMoreListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    StoreMoreListItem *item = [_dataArray objectAtIndex:indexPath.row];
    if (!(item.businessPic.length <= 0)) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:item.businessPic] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            cell.imgBusinessPic.image = image;
        }];
        
    }
    cell.labelPriceShowNumber.text = [NSString stringWithFormat:@"¥%@",item.business_babyshow_price1];
    
    NSDictionary *attributes = @{NSFontAttributeName:cell.labelPriceShowNumber.font};
    CGSize size = [cell.labelPriceShowNumber.text sizeWithAttributes:attributes];
    
    cell.labelPriceShowNumber.frame = CGRectMake(cell.labelPriceShowNumber.frame.origin.x, cell.labelPriceShowNumber.frame.origin.y, size.width+10, 15);
    
    cell.labelDeletePrice.frame = CGRectMake(cell.labelPriceShowNumber.frame.origin.x+size.width+10, cell.labelDeletePrice.frame.origin.y, 60, 15);
    
    cell.labelDeletePrice.text = [NSString stringWithFormat:@"¥%@",item.business_market_price1];
    cell.labelBusinessTitle.text = item.businessTitle;
    cell.labelSubtitle.text = item.subtitle;
    cell.buyPeopleCount.text = [NSString stringWithFormat:@"%@人购买",item.order_count];
    if (item.distance.length >0) {
        cell.labelPostCreatTime.text = [NSString stringWithFormat:@"%@",item.distance];
        
    }else{
        cell.labelPostCreatTime.hidden = YES;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    StoreMoreListItem *item = [_dataArray objectAtIndex:indexPath.row];
    StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
    storeVC.longin_user_id = self.login_user_id;
    storeVC.business_id = item.businessId;
    [self.navigationController pushViewController:storeVC animated:YES];
    
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
