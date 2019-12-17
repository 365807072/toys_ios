//
//  StoreMoreListVC.m
//  BabyShow
//
//  Created by WMY on 15/9/2.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "StoreMoreListVC.h"
#import "SVPullToRefresh.h"
#import "StoreMoreListItem.h"
#import "UIImageView+WebCache.h"
#import "StoreMoreListCell.h"
#import "StoreDetailNewVC.h"
#import <MapKit/MapKit.h>
#import "RefreshControl.h"

@interface StoreMoreListVC ()<dropdownDelegate,RefreshControlDelegate,UISearchBarDelegate>
{
    
    UITableView *_tableView;
    BOOL _isRefresh;
    BOOL _isGetMore;
    BOOL _isFinished;
    NSMutableArray *_dataArray;
    UIView *_headerView;
    
    NSArray *_titleArray;
    NSMutableArray *_leftArray;
    NSMutableArray *_rightArray;
    //当前定位的状态
    CLAuthorizationStatus status;
    RefreshControl *_refreshControl;
    
    //搜索结果
    UITableView *searchResultsTableView;
    UISearchBar *theSearchBar;//搜索的bar
    NSArray *searchResultsArray;//搜素的结果

    
    
}

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) BOOL isGetMore;
@property (nonatomic, assign) BOOL isFinished;
@property(nonatomic,strong)UIButton *button1;//全部
@property(nonatomic,strong)UIButton *button2;//亲子游乐
@property(nonatomic,strong)UIButton *button3;//兴趣培养
@property(nonatomic,strong)UIButton *button4;//学习成长
@property(nonatomic,strong)NSArray *buttonsArray;//button按钮的数组
@property(nonatomic,strong)NSArray *imageArray;
@property(nonatomic,strong)NSArray *imagesArray;
@property(nonatomic,assign)NSInteger business_category;

@property(nonatomic,assign)float latitude;//纬度
@property(nonatomic,assign)float longitude;//经度
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,strong)UIView *seachView;
@property(nonatomic,strong)UIView *backView;//搜素和几个按钮的view
@property(nonatomic,strong)NSString *buisnessTitle;//搜索用的商家名



@end

@implementation StoreMoreListVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil//1
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{//1
    
    [super viewWillAppear:animated];
    if ([self.fromGroup isEqualToString:@"1"]) {
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
        self.tabBarController.tabBar.hidden = YES;

    }else{
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.tabBarController.tabBar.hidden = NO;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    UIFont *font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:font,NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.navigationItem.title = @"学与玩";
   
    _post_create_time = NULL;
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    [self setHeaderView];
    [self setTableView];
    [self setLeftButton];
    [self refreshControlInit];
    if ([self.fromGroup isEqualToString:@"1"]) {
        [self setBack];
    }else{
        self.cityId = @"0";
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{//1
    
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    [LoadingView stopOnTheViewController:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBar.barTintColor = [BBSColor hexStringToColor:NAVICOLOR];
    
}

#pragma mark UI
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
-(void)setBack{
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(cancelback) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;

}
-(void)cancelback{
    [self.navigationController popViewControllerAnimated:YES];
}
//返回按钮
-(void)setLeftButton{
    
    [self testData];
    
    _button = [[DropdownButton alloc]initDropdownButtonWithTitles:_titleArray];
    _button.delegate = self;
    _delegate = self;
    
    _button.frame = CGRectMake(SCREENWIDTH-60, 0, 60, 35);
    
    //_button.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_button];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:_button];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    //筛选的tableview
    _tableViewSelect = [[ConditionDoubleTableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH/2, SCREENHEIGHT/2) andLeftItems:_leftArray andRightItems:_rightArray];
    _tableViewSelect.delegate = self;
    [self.view addSubview:_tableViewSelect.view];
    [self initSelectedArray:_titleArray];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reduceBackgroundSize) name:@"hideMenu" object:nil];
    
}
//初始化筛选
- (void)initSelectedArray:(NSArray *)titles {
    _buttonIndexArray = [[NSMutableArray alloc] initWithCapacity:titles.count];
}
//button点击代理
- (void)showMenu:(NSInteger)index {
    if ([CLLocationManager locationServicesEnabled]) {
        //定位的button
        status = [CLLocationManager authorizationStatus];
        if (kCLAuthorizationStatusDenied == status||kCLAuthorizationStatusRestricted == status ) {
            UILabel *GPSLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, SCREENHEIGHT-120,SCREENWIDTH-60, 35)];
            GPSLabel.text = @"请在设置中打开“定位服务”来允许“自由环球租赁”获取您的位置";
            GPSLabel.numberOfLines = 0;
            GPSLabel.textAlignment = NSTextAlignmentCenter;
            [GPSLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
            
            GPSLabel.textColor = [UIColor whiteColor];
            [_tableViewSelect.view addSubview:GPSLabel];
            
        }else{
        }
    }else{
        
        UILabel *GPSLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, SCREENHEIGHT-120,SCREENWIDTH-60, 35)];
        GPSLabel.text = @"请在设置中打开“定位服务”来允许“自由环球租赁”获取您的位置";
        GPSLabel.numberOfLines = 0;
        GPSLabel.textAlignment = NSTextAlignmentCenter;
        [GPSLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        GPSLabel.textColor = [UIColor whiteColor];
        [_tableViewSelect.view addSubview:GPSLabel];
    }
    
    _lastIndex = index;
    [self.view setFrame:SCREEN_RECT];
    _buttonSelectedIndex = index - 10000;
    NSString *selected = @"0-0";
    if (_buttonIndexArray.count > _buttonSelectedIndex){
        selected = [_buttonIndexArray objectAtIndex:_buttonSelectedIndex];
    } else {
        [_buttonIndexArray addObject:selected];
    }
    NSArray *selectedArray = [selected componentsSeparatedByString:@"-"];
    NSString *left = [selectedArray objectAtIndex:0];
    NSString *right = [selectedArray objectAtIndex:1];
    [_tableViewSelect showTableView:_buttonSelectedIndex WithSelectedLeft:left Right:right];
}
- (void)hideMenu {
    [_tableViewSelect hideTableView];
}

- (void)reduceBackgroundSize {
    // [self.view setFrame:CGRectMake(0, 0,0, 0)];
}
- (void)selectedFirstValue:(NSString *)first SecondValue:(NSString *)second{
    NSString *index = [NSString stringWithFormat:@"%@-%@", first, second];
    [_buttonIndexArray setObject:index atIndexedSubscript:_buttonSelectedIndex];
    [self returnSelectedLeftIndex:first RightIndex:second];
}
-(void)setSeachResult:(NSString*)businessTitle{
    _isFinished = NO;
    _isRefresh = YES;
    _post_create_time = NULL;
    self.buisnessTitle = businessTitle;
    [self getSearchData];
}
- (void)returnSelectedLeftIndex:(NSString *)left RightIndex:(NSString *)right {
    if (_delegate && [_delegate respondsToSelector:@selector(dropdownSelectedLeftIndex:RightIndex:)]) {
        [_delegate performSelector:@selector(dropdownSelectedLeftIndex:RightIndex:) withObject:left withObject:right];
    }else{
        
    }
}
//下拉菜单的数据
- (void)testData {
    [self testTitleArray];
    [self testLeftArray];
}

//每个下拉的标题
- (void) testTitleArray {
    _titleArray = @[@"筛选"];
}

//左边列表可为空，则为单下拉菜单，可以根据需要传参
- (void)testLeftArray {
    NSMutableArray *cityNameArray = [NSMutableArray array];
    NSMutableArray *cityAreaArrays = [NSMutableArray array];
    NSMutableArray *cityAreaIds = [NSMutableArray array];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    
    [[HTTPClient sharedClient]getNew:kBusinessCityList params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSArray *data = result[@"data"];
            
            for (NSDictionary *dataDic in data) {
                NSString *cityName = dataDic[@"city_name"];
                [cityNameArray addObject:cityName];
                NSArray *cityArray = dataDic[@"children"];
                NSMutableArray *cityAreaArray = [NSMutableArray array];
                NSMutableArray *cityAreaIdArray = [NSMutableArray array];
                for (NSDictionary *cityDic in cityArray) {
                    NSString *cityAreaName = cityDic[@"city_name"];
                    NSString *cityAreaId = cityDic[@"id"];
                    [cityAreaArray addObject:[NSString stringWithFormat:@"%@",cityAreaName]];
                    [cityAreaIdArray addObject:[NSString stringWithFormat:@"%@",cityAreaId]];
                }
                [cityAreaArrays addObject:cityAreaArray];
                [cityAreaIds addObject:cityAreaIdArray];
            }
            
        }
    } failed:^(NSError *error) {
        
    }];
    _leftArray = [[NSMutableArray alloc] initWithObjects:cityNameArray,cityAreaIds, nil];
    _rightArray = [[NSMutableArray alloc] initWithObjects:cityAreaArrays,  nil];
    
    
}


//实现代理，返回选中的下标，若左边没有列表，则返回0
- (void)dropdownSelectedLeftIndex:(NSString *)left RightIndex:(NSString *)right {
    NSArray *array = _leftArray[1];
    NSInteger leftInt = [left integerValue];
    NSInteger rightInt = [right integerValue];
    NSArray *cityIDArray = array[leftInt];
    NSString *cityId = [NSString stringWithFormat:@"%@",cityIDArray[rightInt]];
    self.cityId = cityId;
    _isFinished = NO;
    _isRefresh = YES;
    _post_create_time = NULL;
    [self getData];
}


-(void)setTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect tableviewFrame=CGRectMake(0, 64+83, SCREENWIDTH, SCREENHEIGHT-64-83+7);
    _tableView=[[UITableView alloc]initWithFrame:tableviewFrame];
    _tableView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
    
    
}
-(void)setHeaderView

{
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH,83)];
    [self.view addSubview:self.backView];
    
    UIImage *image1 = [UIImage imageNamed:@"btn_store_all"];
    UIImage *image2 = [UIImage imageNamed:@"btn_store_chlld"];
    UIImage *image3 = [UIImage imageNamed:@"btn_store_interest"];
    UIImage *image4 = [UIImage imageNamed:@"btn_store_study"];
    _imageArray = [[NSArray alloc]initWithObjects:image1,image2,image3,image4, nil];
    UIImage *images1 = [UIImage imageNamed:@"btn_store_alls"];
    UIImage *images2 = [UIImage imageNamed:@"btn_store_childs"];
    UIImage *images3 = [UIImage imageNamed:@"btn_store_interests"];
    UIImage *images4 = [UIImage imageNamed:@"btn_store_studys"];
    _imagesArray = [[NSArray alloc]initWithObjects:images1,images2,images3,images4, nil];
    
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 83)];
    _headerView.backgroundColor = [UIColor whiteColor];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0,82, SCREENWIDTH, 1)];
    lineView.backgroundColor = [BBSColor hexStringToColor:@"f2f2f2"];
    [_headerView addSubview:lineView];
    
    _button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button1.frame = CGRectMake((SCREENWIDTH-160)/8,10, 40, 59) ;
    [_button1 setBackgroundImage:[UIImage imageNamed:@"btn_store_alls"]forState:UIControlStateNormal];
    [_button1 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _button1.tag = 500;
    [_headerView addSubview:_button1];
    
    _button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button2.frame = CGRectMake(_button1.frame.origin.x+40+(SCREENWIDTH-160)/4,10, 44, 59) ;
    [_button2 setBackgroundImage:[UIImage imageNamed:@"btn_store_chlld"]forState:UIControlStateNormal];
    [_button2 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _button2.tag = 501;
    [_headerView addSubview:_button2];
    
    _button3 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button3.frame = CGRectMake(_button2.frame.origin.x+40+(SCREENWIDTH-160)/4,10, 44, 59) ;
    [_button3 setBackgroundImage:[UIImage imageNamed:@"btn_store_interest"]forState:UIControlStateNormal];
    [_button3 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _button3.tag = 502;
    [_headerView addSubview:_button3];
    
    _button4 = [UIButton buttonWithType:UIButtonTypeSystem];
    _button4.frame = CGRectMake(_button3.frame.origin.x+40+(SCREENWIDTH-160)/4,10, 44, 59) ;
    [_button4 setBackgroundImage:[UIImage imageNamed:@"btn_store_study"]forState:UIControlStateNormal];
    [_button4 addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _button4.tag = 503;
    [_headerView addSubview:_button4];
    
    _buttonsArray = [[NSArray alloc]initWithObjects:_button1,_button2,_button3,_button4, nil];
    [self.backView addSubview:_headerView];
    
    
}
-(void)buttonAction:(id)sender{
    UIButton *button = sender;
    NSInteger a= button.tag-500;
    for (int i = 0; i < _imageArray.count; i++) {
        if (a==i) {
            UIImage *image = _imagesArray[i];
            [_buttonsArray[i] setBackgroundImage:image forState:UIControlStateNormal];
            
        }else{
            UIImage *image = _imageArray[i];
            [_buttonsArray[i] setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
    self.business_category = a;
    _isRefresh = YES;
    _isFinished = NO;
    _post_create_time = NULL;
    [self getData];
    
}



#pragma mark data 商家数据
-(void)getData{
    NSDictionary *paramDic;
    NSUserDefaults *defaultlat = [NSUserDefaults standardUserDefaults];
    NSString *lat = [defaultlat valueForKey:@"latitude"];
    NSUserDefaults *defaultlog = [NSUserDefaults standardUserDefaults];
    NSString *longitude = [defaultlog valueForKey:@"longitude"];
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%ld",(long)self.business_category],@"business_category",self.cityId,@"city_id",[NSString stringWithFormat:@"%@,%@",lat,longitude],@"mapsign",_post_create_time,@"post_create_time",nil];
    
    UrlMaker *urlMarker = [[UrlMaker alloc]initWithNewV1UrlStr:kGetBusinessListV3 Method:NetMethodGet andParam:paramDic];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMarker.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
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
                storeMoreListItem.businessId = imgDic[@"business_id"];
                storeMoreListItem.businessPic = imgDic[@"business_pic"];
                storeMoreListItem.businessTitle = imgDic[@"business_title"];
                storeMoreListItem.post_create_time = imgDic[@"post_create_time"];
                storeMoreListItem.subtitle = imgDic[@"subtitle"];
                storeMoreListItem.distance = imgDic[@"distance"];
                storeMoreListItem.business_babyshow_price1 = imgDic[@"business_babyshow_price1"];
                storeMoreListItem.business_market_price1 = imgDic[@"business_market_price1"];
                storeMoreListItem.order_count = imgDic[@"order_count"];
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
#pragma mark 商家搜索数据结果
-(void)getSearchData{
    NSDictionary *paramDic;
    NSUserDefaults *defaultlat = [NSUserDefaults standardUserDefaults];
    NSString *lat = [defaultlat valueForKey:@"latitude"];
    NSUserDefaults *defaultlog = [NSUserDefaults standardUserDefaults];
    NSString *longitude = [defaultlog valueForKey:@"longitude"];
    paramDic = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%@,%@",lat,longitude],@"mapsign",[self.buisnessTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],@"business_title",nil];
    UrlMaker *urlMarker = [[UrlMaker alloc]initWithNewV1UrlStr:kSearchBusinessListV1 Method:NetMethodGet andParam:paramDic];
    
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMarker.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    __weak ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:@"success"]integerValue ]==1) {
            NSArray *dataArray = dic[@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
            for (NSDictionary *dataDic in dataArray) {
                NSDictionary *imgDic = dataDic[@"img"];
                StoreMoreListItem *storeMoreListItem = [[StoreMoreListItem alloc]init];
                storeMoreListItem.businessId = imgDic[@"business_id"];
                storeMoreListItem.businessPic = imgDic[@"business_pic"];
                storeMoreListItem.businessTitle = imgDic[@"business_title"];
                storeMoreListItem.post_create_time = imgDic[@"post_create_time"];
                storeMoreListItem.subtitle = imgDic[@"subtitle"];
                storeMoreListItem.distance = imgDic[@"distance"];
                storeMoreListItem.business_babyshow_price1 = imgDic[@"business_babyshow_price1"];
                storeMoreListItem.business_market_price1 = imgDic[@"business_market_price1"];
                storeMoreListItem.order_count = imgDic[@"order_count"];

                [returnArray addObject:storeMoreListItem];
            }
            if (returnArray.count == 0) {
                [BBSAlert showAlertWithContent:@"没有找到相关商家" andDelegate:self andDismissAnimated:3];
            }
            [_dataArray removeAllObjects];
            [_dataArray addObjectsFromArray:returnArray];
            [_tableView reloadData];
            _refreshControl.bottomEnabled = NO;
            _refreshControl.topEnabled = NO;
        }else{
            _refreshControl.bottomEnabled = NO;
            [BBSAlert showAlertWithContent:[dic objectForKey:kBBSReMsg] andDelegate:self];
        }
    }];
    [request setFailedBlock:^{
        _refreshControl.bottomEnabled = NO;
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
    if (self.business_category != 0 || ![self.cityId isEqualToString:@"0"]) {
        self.cityId = @"0";
        UIImage *image = _imageArray[self.business_category];
        [_buttonsArray[self.business_category] setBackgroundImage:image forState:UIControlStateNormal];
        [_button1 setBackgroundImage:[UIImage imageNamed:@"btn_store_alls"]forState:UIControlStateNormal];
        self.business_category = 0;
        _isFinished = NO;
        _isRefresh = YES;
        _post_create_time = NULL;
        [self getData];
    }else if(_tableViewSelect.isHiddenInStoreList == NO){
        [_tableViewSelect hideTableView];
    }else{
    
        [self.navigationController popViewControllerAnimated:YES];
        
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
        _tableView.frame=CGRectMake(0, 83+64, SCREENWIDTH, SCREENHEIGHT-64+7);
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
        [UIView commitAnimations];
    }
    //up
    if (point.y-scrollView.contentOffset.y<-40) {
        if (searchResultsTableView) {
            
        }else{
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        _tableView.frame=CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT-20-42);
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
        [UIView commitAnimations];
        }
        
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
