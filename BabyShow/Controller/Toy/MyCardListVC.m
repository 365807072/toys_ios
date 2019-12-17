//
//  MyCardListVC.m
//  BabyShow
//
//  Created by 美美 on 2018/8/2.
//  Copyright © 2018年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyCardListVC.h"
#import "RefreshControl.h"
#import "ToyCardListItem.h"
#import "MyCardListCell.h"
#import "UIImageView+WebCache.h"
#import "ToyTransportVC.h"



@interface MyCardListVC ()<RefreshControlDelegate>{
    UITableView *_tableView;
    RefreshControl *_refreshControl;
    UIButton *_backBtn;
    UIView *_emptyView;
    UIImageView *_noToyImgView;
    NSMutableArray *_myCardDataArray;

}

@end

@implementation MyCardListVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _myCardDataArray = [NSMutableArray array];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.title = @"我的会员卡";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault]; [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationController.navigationBar.translucent = NO;


}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [BBSColor hexStringToColor:NAVICOLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; [self.navigationController.navigationBar setShadowImage:nil];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"我的会员卡";
   /// _post_create_carToy = NULL;
    [self setBackButton];
    [self setTableView];
    [self refreshControlInit];
    _isRefreshInVC = NO;
    //[self setRightBtn];
    // Do any additional setup after loading the view.
}
#pragma mark 添加返回
-(void)setBackButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 30, 17);
    _backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.adjustsImageWhenHighlighted = NO;
    [_backBtn setImage:[UIImage imageNamed:@"btn_toy_detail_back"] forState:UIControlStateNormal];
    [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
#pragma mark 返回
-(void)back{
    _isRefreshInVC = YES;
    self.refreshInVC(_isRefreshInVC);

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark tableview
-(void)setTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH, SCREENHEIGHT-64)];
    _tableView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
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
            //_post_create_carToy = NULL;
        }
    }
    [self getCardListData];
    
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
#pragma mark 获取会员卡的数据
-(void)getCardListData{
    NSDictionary *newParam = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",nil];
    UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:@"getToysOrderCardListV3" Method:NetMethodGet andParam:newParam];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:15];
    [request startAsynchronous];
    __weak ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:kBBSSuccess]boolValue] == YES) {
            NSArray *dataArray = [dic objectForKey:@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
            for (NSDictionary *mainDic in dataArray) {
                ToyCardListItem *item = [[ToyCardListItem alloc]init];
                item.business_pic = mainDic[@"business_pic"];
                item.card_info = mainDic[@"card_info"];
                item.status_name = mainDic[@"status_name"];
                item.card_id_title = mainDic[@"card_id_title"];
                item.order_id = mainDic[@"order_id"];
                [returnArray addObject:item];
            }
            if (returnArray.count == 0) {
                _refreshControl.bottomEnabled = NO;
            }
            [_myCardDataArray addObjectsFromArray:returnArray];
            [_tableView reloadData];

            if (_myCardDataArray.count == 0) {
                [self addEmptyHintView];
                _emptyView.hidden = NO;
            }else{
                _emptyView.hidden = YES;
            }
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
#pragma mark 无会员卡时
-(void)addEmptyHintView {
    if (_emptyView) {
        return;
    }else{
        _emptyView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _emptyView.backgroundColor=[BBSColor hexStringToColor:@"f5f5f5"];
        _emptyView.frame = CGRectMake(0,0, SCREENWIDTH, SCREENHEIGHT);
        UIImage *image = [UIImage imageNamed:@"noCard"];
        _noToyImgView =[[UIImageView alloc]initWithImage:image];
        _noToyImgView.frame=CGRectMake(15,90, SCREENWIDTH-30,(245/694)*(SCREENWIDTH-30));
        [_noToyImgView setContentMode:UIViewContentModeScaleAspectFill];
        //_noToyImgView.clipsToBounds = YES;
        [_emptyView addSubview:_noToyImgView];
        _noToyImgView.userInteractionEnabled = YES;
        
        _emptyView.userInteractionEnabled = YES;
        [self.view addSubview:_emptyView];
    }
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(15,90, SCREENWIDTH-30,(245/694)*(SCREENWIDTH-30));
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(goBackto) forControlEvents:UIControlEventTouchUpInside];
    // UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBackto)];
    [_noToyImgView addSubview:btn];

}

-(void)goBackto{
    NSLog(@"fffff");
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _myCardDataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableViewCell;
    ToyCardListItem *item = [_myCardDataArray objectAtIndex:indexPath.row];
    static NSString *identifier = @"myCardDataArray";
    MyCardListCell *cardListCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cardListCell == nil){
        cardListCell = [[MyCardListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

    }
    cardListCell.toyNameLabel.text = item.card_info;
    NSString *string = [NSString stringWithFormat:@"%@ %@",item.status_name,item.card_id_title];
    cardListCell.priceLabel.text = string;
    [cardListCell.cardImg  sd_setImageWithURL:[NSURL URLWithString:item.business_pic]];
    cardListCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cardListCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ToyCardListItem *item = [_myCardDataArray objectAtIndex:indexPath.row];
    ToyTransportVC *toyTransportVC = [[ToyTransportVC alloc]init];
    toyTransportVC.order_id = item.order_id;
    toyTransportVC.fromWhere = @"5";
    [self.navigationController pushViewController:toyTransportVC animated:YES];

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
