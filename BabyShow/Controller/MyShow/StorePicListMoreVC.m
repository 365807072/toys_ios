//
//  StorePicListMoreVC.m
//  BabyShow
//
//  Created by 美美 on 2018/5/10.
//  Copyright © 2018年 Yuanyuanquanquan.com. All rights reserved.
//

#import "StorePicListMoreVC.h"
#import "StorePicMoreListCell.h"
#import "StoreMoreListItem.h"
#import "RefreshControl.h"
#import "StoreDetailNewVC.h"
#import "RefreshControl.h"
#import "UIImageView+WebCache.h"
#import "WebViewController.h"


@interface StorePicListMoreVC ()<RefreshControlDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    RefreshControl *_refreshControl;
    NSString *_post_create_time;
    
}
@property (nonatomic ,strong) UITableView *cityTableView;
@property(nonatomic,strong)NSMutableArray *cityListArray;
@property (nonatomic ,assign) BOOL hideCityList;//是否展示城市列表
@property(nonatomic,strong)UIImageView *bugleview;
@property(nonatomic,strong) UILabel *cateName;


@end

@implementation StorePicListMoreVC
-(void)viewWillAppear:(BOOL)animated{//1
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    _hideCityList = YES;
    [self  hiddenOrShow:_hideCityList];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _cityListArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _post_create_time = NULL;
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    
    [self setTableView];
    [self setLeftButton];
    [self refreshControlInit];
    [self getCityData];
    _hideCityList = YES;//隐藏


    // Do any additional setup after loading the view.
}
//返回按钮
-(void)setLeftButton{
    
    //返回按钮
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 31)];
    imagev.image = [UIImage imageNamed:@"btn_back1.png"];
    [_backBtn addSubview:imagev];
    _cateName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0,SCREENWIDTH-60, 31)];
    _cateName.textColor = [UIColor whiteColor];
    _cateName.text = self.imgTitle;
    _cateName.font = [UIFont systemFontOfSize:15];
    _cateName.textAlignment = NSTextAlignmentCenter;
    [_backBtn addSubview:_cateName];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
    //UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
   // rightBtn.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>)
    UIView *iconBgView = [[UIView alloc]initWithFrame:CGRectMake(0, -5, 15, 20)];

    UIButton *moreBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    moreBtn.frame = CGRectMake(0, 0, 15, 20);

    [moreBtn setBackgroundImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [moreBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [moreBtn addTarget:self action:@selector(moreStore) forControlEvents:UIControlEventTouchUpInside];
    [iconBgView addSubview:moreBtn];

    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:iconBgView];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    _bugleview = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-34, 36, 17, 12)];
    _bugleview.image = [UIImage imageNamed:@"bugle"];
    [self.navigationController.navigationBar addSubview:_bugleview];
    [self hiddenOrShow:YES];
    
    
}
-(void)hiddenOrShow:(BOOL)isHidden{
    if (isHidden == YES) {
        //隐藏
        _bugleview.hidden = YES;
        _cityTableView.hidden = YES;
        
    }else{
        //不隐藏
        _bugleview.hidden = NO;
        _cityTableView.hidden = NO;

    }
    
    
}
-(void)getCityData{
    NSDictionary *newparam = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"getOrderFunRegionList" params:newparam success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            _cityListArray = [result objectForKey:kBBSData];
        }
        
    } failed:^(NSError *error) {
        
    }];
}
-(void)moreStore{
    _hideCityList = !_hideCityList;

    if (_cityTableView) {
        [self hiddenOrShow:_hideCityList];

        [_cityTableView reloadData];
        return;
    }else{
       CGRect frame = CGRectMake( SCREENWIDTH-140, 64, 140, 45*_cityListArray.count);
       _cityTableView = [[UITableView alloc] initWithFrame:frame ];
        _cityTableView.delegate = self;
        _cityTableView.dataSource = self;
        _cityTableView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_cityTableView];
        [self.view bringSubviewToFront:_cityTableView];
        [_cityTableView reloadData];
        _cityTableView.separatorStyle = NO;//显示

    }
    [self hiddenOrShow:_hideCityList];

    
    
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
#pragma mark data 商家数据
-(void)getData{
    NSMutableDictionary *paramDic;
    paramDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.imgIds,@"city_id",_post_create_time,@"post_create_time",nil];
    if ([_post_create_time isEqualToString:@"0"]) {
        _refreshControl.bottomEnabled = NO;
        [self refreshComplete:_refreshControl];

        return;
    }
    [[HTTPClient sharedClient]getNewV1:@"getOrderFunRegionBusinessList" params:paramDic success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSLog(@"datadic = %@",result);
            NSArray *dataArray = result[@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
            for (NSDictionary *dataDic in dataArray) {
            StoreMoreListItem *storeMoreListItem = [[StoreMoreListItem alloc]init];
              storeMoreListItem.businessId = dataDic[@"business_id"];
              storeMoreListItem.businessPic =  dataDic[@"business_pic_new"];
              storeMoreListItem.post_create_time =  dataDic[@"post_create_time"];
                storeMoreListItem.is_last = dataDic[@"is_last"];
                storeMoreListItem.post_url = dataDic[@"post_url"];
                [returnArray addObject:storeMoreListItem];
                

            }
            if (returnArray.count == 0) {
                _refreshControl.bottomEnabled = NO;
            }
            if (_post_create_time == NULL  ) {
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

            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
        
    } failed:^(NSError *error) {
        [self refreshComplete:_refreshControl];

    }];


}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark  UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_cityTableView]) {
        return _cityListArray.count;
    }
    return [_dataArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_cityTableView]) {
        return 45;
    }
    StoreMoreListItem *item = [_dataArray objectAtIndex:indexPath.row];
    if ([item.is_last isEqualToString:@"1"]) {
                return 118+16;
    }else{
        return 118+16;
    };
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_cityTableView]) {
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        
        UILabel *nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(8, 13, 120,20)];
        nicknameLabel.backgroundColor = [UIColor clearColor];
        nicknameLabel.textAlignment = NSTextAlignmentLeft;
        nicknameLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        nicknameLabel.font = [UIFont systemFontOfSize:13];
        [cell.contentView addSubview:nicknameLabel];
        
        UIImageView *lineImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 45)];
        lineImg.image = [UIImage imageNamed:@"city_shadow"];
        [cell.contentView addSubview:lineImg];
        
        UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 44, 140, 1)];
        lineview.backgroundColor = [BBSColor hexStringToColor:@"E2E2E2"];
        [cell.contentView addSubview:lineview];
        NSDictionary *rowDict = [_cityListArray objectAtIndex:indexPath.row];
        nicknameLabel.text = [NSString stringWithFormat:@"%@",[rowDict objectForKey:@"city_name"]];
        return cell;

    }else{
    NSString *identifier = [NSString stringWithFormat:@"STOREMORELIST"];
    StorePicMoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[StorePicMoreListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    StoreMoreListItem *item = [_dataArray objectAtIndex:indexPath.row];
        if ([item.is_last isEqualToString:@"1"]) {
            cell.OnePicView.frame =  CGRectMake(0, 0, SCREENWIDTH,112+16);
        }else{
            cell.OnePicView.frame = CGRectMake(0, 0, SCREENWIDTH,112+16);
        }
    if (!(item.businessPic.length <= 0)) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:item.businessPic] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            cell.OnePicView.image = image;
        }];
        
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:_cityTableView]) {
        NSDictionary *rowDict = [_cityListArray objectAtIndex:indexPath.row];
        NSString *alertString = rowDict[@"title"];
        if ([rowDict[@"status"] isEqualToString:@"1"]) {
            self.imgIds = rowDict[@"city_id"];
            _post_create_time = rowDict[@"post_create_time"];
            self.imgTitle = rowDict[@"title_center"];

            [self getData];
            
            _cateName.text = self.imgTitle;
            _hideCityList = YES;
            [self hiddenOrShow:_hideCityList];

        }else{
            [BBSAlert showAlertWithContent:alertString andDelegate:self];
        }
    }else{
        
    StoreMoreListItem *item = [_dataArray objectAtIndex:indexPath.row];
        if ([item.is_last isEqualToString:@"1"]) {
        }else{
            if (item.post_url.length > 0) {
                WebViewController *webView=[[WebViewController alloc]init];
                NSString *urlString = item.post_url;
                webView.urlStr=[urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [webView setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:webView animated:YES];

            }else{
            StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
            storeVC.longin_user_id = LOGIN_USER_ID;
            storeVC.business_id = item.businessId;
            [self.navigationController pushViewController:storeVC animated:YES];
            }
        }

    }
    
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
