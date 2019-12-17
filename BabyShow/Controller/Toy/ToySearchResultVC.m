//
//  ToySearchResultVC.m
//  BabyShow
//
//  Created by 美美 on 2018/2/8.
//  Copyright © 2018年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToySearchResultVC.h"
#import "RefreshControl.h"
#import "ToyLeaseItem.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "ToyLeaseDetailVC.h"
#import "ToyCarVC.h"
#import "LoginHTMLVC.h"

@interface ToySearchResultVC ()<UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating,RefreshControlDelegate>{
    UIView *navigationView;
    UISearchBar *theSearchBar;
    NSMutableArray *searchResultUserArray;
     RefreshControl *_refreshControl;
    UIView *_emptyView;
    UIImageView *_noToyImgView;
    UILabel *_badgeValueLabel;


}
@property (nonatomic, strong) NSString *post_create_time;
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIButton *addCarBtn;//购物车

@end

@implementation ToySearchResultVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        searchResultUserArray=[NSMutableArray array];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    //获取购物车里面的玩具数量
    [self getToyCarCount];

}
#pragma mark 购物车里面的玩具数量
-(void)getToyCarCount{
    NSDictionary *param = [NSDictionary dictionaryWithObject:LOGIN_USER_ID forKey:@"login_user_id"];
    [[HTTPClient sharedClient]getNewV1:@"getToysCartNumber" params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = result[@"data"];
            NSString *toyCount = data[@"cart_number"];
            if ([toyCount isEqualToString:@"0"]) {
                _badgeValueLabel.hidden = YES;
            }else{
                _badgeValueLabel.hidden = NO;
                _badgeValueLabel.text = toyCount;
            }
            
        }
    } failed:^(NSError *error) {
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
     _post_create_time = NULL;
    // Do any additional setup after loading the view.
    [self setSearchBar];
    if (!searchResultUserArray) {
        searchResultUserArray = [NSMutableArray array];
    }
    [self setCollectionViewLay];
    [self refreshControlInit];
    [self setToyCar];
    self.view.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];

    

}
#pragma mark 购物车的位置
-(void)setToyCar{
    self.addCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addCarBtn.frame = CGRectMake(SCREENWIDTH-80, SCREENHEIGHT-100, 43, 43);
    [self.addCarBtn setBackgroundImage:[UIImage imageNamed:@"toy_car_list"] forState:UIControlStateNormal];
    [self.addCarBtn addTarget:self action:@selector(pushtoyCar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addCarBtn];
    //购物车的数量的label
    _badgeValueLabel=[[UILabel alloc]initWithFrame:CGRectMake(35, 0, 20, 20)];
    _badgeValueLabel.backgroundColor=[BBSColor hexStringToColor:@"FF7F7C"];
    _badgeValueLabel.textColor=[UIColor whiteColor];
    _badgeValueLabel.font=[UIFont systemFontOfSize:10];
    _badgeValueLabel.textAlignment=NSTextAlignmentCenter;
    _badgeValueLabel.layer.masksToBounds=YES;
    _badgeValueLabel.layer.cornerRadius=10;
    [self.addCarBtn addSubview:_badgeValueLabel];
    _badgeValueLabel.hidden = NO;
}
#pragma mark 进入购物车
-(void)pushtoyCar{
    if ([self isVisitor] == YES) {
        [self loginIn];
    }else{
        ToyCarVC *toyCarVC = [[ToyCarVC alloc]init];
        [self.navigationController pushViewController:toyCarVC animated:YES];
    }
}
#pragma mark 是否是用户登录还是游客
-(BOOL)isVisitor{
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    if ([userItem.isVisitor boolValue] == YES || LOGIN_USER_ID == NULL) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark 判断用户身份后的登录
-(void)loginIn{
    LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:^{
    }];
    return;
}

-(void)setSearchBar{
    navigationView = [[UIView alloc]init];//WithFrame:CGRectMake(0, 0, SCREENWIDTH, 56)];
    if (ISIPhoneX) {
        navigationView.frame = CGRectMake(0, 20, SCREENWIDTH, 56);
    }else{
        navigationView.frame =CGRectMake(0, 0, SCREENWIDTH, 56);
        
    }
    navigationView.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
    [self.view addSubview:navigationView];
    
    CGRect backBtnFrame = CGRectMake(0, 18, 40, 17+12);
    UIButton* backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.adjustsImageWhenHighlighted = NO;
    [backBtn setImage:[UIImage imageNamed:@"btn_toy_detail_back"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(12, 10, 0, 20)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame=backBtnFrame;
    //backBtn.backgroundColor = [UIColor redColor];
    [navigationView addSubview:backBtn];
    
    
    if (theSearchBar) {
        if (![theSearchBar isFirstResponder]) {
            [theSearchBar becomeFirstResponder];
        }
        return;
    }
    
    theSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(33, 25, SCREENWIDTH-50, 25)];
    theSearchBar.barTintColor = [BBSColor hexStringToColor:@"ededed"];
    theSearchBar.tintColor = [UIColor blackColor];
    theSearchBar.backgroundImage = [[UIImage alloc] init];
    theSearchBar.text = _businessId;
    
    UITextField *searchField = [theSearchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[BBSColor hexStringToColor:@"ededed"]];
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>= 11.0 ) {
            //searchField.layer.cornerRadius = 20;
            
        }else{
           // searchField.layer.cornerRadius = 13;
            
        }
        searchField.layer.masksToBounds = YES;
        searchField.font = [UIFont systemFontOfSize:13];
    }
    
    theSearchBar.layer.masksToBounds = YES;
    theSearchBar.layer.cornerRadius = 14.5;
    theSearchBar.tintColor=[BBSColor hexStringToColor:@"666666"];//光标的颜色
    theSearchBar.delegate = self;
    theSearchBar.tag = 2;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>= 9) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:@{NSForegroundColorAttributeName: [BBSColor hexStringToColor:@"666666"], NSFontAttributeName: [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];
        
    }else{
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[BBSColor hexStringToColor:@"666666"],NSForegroundColorAttributeName,[UIFont systemFontOfSize:12],NSFontAttributeName, nil] forState:UIControlStateNormal];
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [navigationView addSubview:theSearchBar];
    [UIView commitAnimations];
    
    
}
#pragma mark - UISearchBarDelegate Methods
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchUserWithWord:searchBar.text];
    [searchBar resignFirstResponder];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:12];
            [cancel setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
            
            cancel.frame = CGRectMake(235, -5, 35, 34);
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
    [searchBar resignFirstResponder];
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return  YES;
}
-(void)searchUserWithWord:(NSString*)keyWord{
    // [self setTableView];
    
    [theSearchBar resignFirstResponder];
    _businessId = keyWord;
    _post_create_time = NULL;
    [self getSearchListData];
    
}

-(void)setCollectionViewLay{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置headerView的尺寸大小
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    CGRect userFram = CGRectMake(0, navigationView.frame.origin.y+56, SCREENWIDTH, SCREENHEIGHT-56-navigationView.frame.origin.y);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _collectionView = [[UICollectionView alloc]initWithFrame:userFram collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.hidden = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[ToyAllListCell class] forCellWithReuseIdentifier:@"ToySearchResultListCell"];
}
#pragma mark- refreshControl
-(void)refreshControlInit{
    _refreshControl                             = [[RefreshControl alloc] initWithScrollView:_collectionView delegate:self];
    _refreshControl.topEnabled                  = YES;
    _refreshControl.bottomEnabled               = NO;
    [_refreshControl startRefreshingDirection:RefreshDirectionTop];
}
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    if (refreshControl == _refreshControl) {
        if (direction == RefreshDirectionTop) {
            _post_create_time                           = NULL;
        }
        [self getSearchListData];
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
#pragma mark ----------搜索数据---------
-(void)getSearchListData{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    [param setObject:[_businessId stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] forKey:@"search_title"];
    if (_post_create_time.length > 0) {
        [param setObject:_post_create_time forKey:@"post_create_time"];
    }
    UrlMaker *urlMark = [[UrlMaker alloc]initWithNewV1UrlStr:@"getToysListApp" Method:NetMethodGet andParam:param];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMark.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    __weak ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:@"success"]integerValue] == 1) {
            NSArray *dataArray = [dic objectForKey:@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
            for (NSDictionary *dataDic in dataArray) {
                ToyLeaseItem *item = [[ToyLeaseItem alloc]init];
                item.business_id = dataDic[@"business_id"];
                item.user_name = dataDic[@"user_name"];
                item.business_title = dataDic[@"business_title_ios"];
                item.way = dataDic[@"way"];
                item.img_thumb = dataDic[@"img_thumb"];
                item.is_support = dataDic[@"is_support"];
                item.sell_price = dataDic[@"sell_price"];
                item.is_order = dataDic[@"is_order"];
                item.post_create_time = dataDic[@"post_create_time"];
                item.avatar = dataDic[@"avatar"];
                item.support_name = dataDic[@"support_name"];
                item.is_jump = dataDic[@"is_jump"];
                item.is_cart = dataDic[@"is_cart"];
                item.size_img_thumb = dataDic[@"size_img_thumb"];
                item.age = dataDic[@"age"];
                item.unit_name = dataDic[@"unit_name"];
                
                [returnArray addObject:item];
            }
            if (returnArray.count == 0 && searchResultUserArray.count > 0) {
                //[self showHUDWithMessage:@"没有更多玩具啦！"];
                _refreshControl.bottomEnabled = NO;
            }
            if (_post_create_time == NULL) {
                [searchResultUserArray removeAllObjects];
                _refreshControl.bottomEnabled = YES;
            }
            ToyLeaseItem *item = [returnArray lastObject];
            _post_create_time = item.post_create_time;
            [searchResultUserArray addObjectsFromArray:returnArray];
            [CATransaction setDisableActions:YES];
            [_collectionView reloadData];
            [CATransaction commit];


            if (searchResultUserArray.count == 0) {
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
    [self.view bringSubviewToFront:self.addCarBtn];

    
}
#pragma mark 没有订单的时候显示无订单页面
-(void)addEmptyHintView {
    if (_emptyView) {
        return;
    }else{
    _emptyView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _emptyView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    _emptyView.frame = CGRectMake(0,56, SCREENWIDTH, SCREENHEIGHT-56);
    
    UIImage *image = [UIImage imageNamed:@"toy_no_result@3x"];
    _noToyImgView =[[UIImageView alloc]initWithImage:image];
    _noToyImgView.frame=CGRectMake((SCREENWIDTH-232)/2,(SCREENHEIGHT-56-232)/2, 232, 232);
    [_noToyImgView setContentMode:UIViewContentModeScaleAspectFill];
    _noToyImgView.clipsToBounds = YES;
    [_emptyView addSubview:_noToyImgView];
    _noToyImgView.userInteractionEnabled = YES;
    [self.view addSubview:_emptyView];
    }
    
    
}

#pragma mark 实现collectionview的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return  [searchResultUserArray count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //注册cell
    //注册cell
    [collectionView registerClass:[ToyAllListCell class] forCellWithReuseIdentifier:@"ToySearchResultListCell"];
    ToyAllListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ToySearchResultListCell" forIndexPath:indexPath];
    ToyLeaseItem *item = [searchResultUserArray objectAtIndex:indexPath.row];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    if (item.img_thumb.length >0) {
          [cell.toyPicImg sd_setImageWithURL:[NSURL URLWithString:item.img_thumb] placeholderImage:[[SDImageCache sharedImageCache] imageFromDiskCacheForKey:item.img_thumb]];
        //[cell.toyPicImg sd_setImageWithURL:[NSURL URLWithString:item.img_thumb]];
    }else{
        cell.toyPicImg.image = [UIImage imageNamed:@"img_message_photo"];
    }
    if (indexPath.row == 0 || indexPath.row == 1) {
        UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/2, 1)];
        lineView1.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        //[cell.contentView addSubview:lineView1];
        
    }

    cell.toyNameLabel.text = item.business_title;
    NSMutableAttributedString *makeString1 = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@%@",item.sell_price,item.unit_name]];
    [makeString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11] range:NSMakeRange(0, item.sell_price.length)];
    [makeString1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:9] range:NSMakeRange(item.sell_price.length, item.unit_name.length)];
    cell.priceLabel.attributedText = makeString1;

    NSString *string = [NSString stringWithFormat:@"%@%@",item.sell_price,item.unit_name];
    float widthPrice = [self getTitleWidth:string fontSize:11];

    cell.markImg.hidden = YES;
    if (item.size_img_thumb.length > 0) {
        cell.markImg.hidden = NO;
                cell.markImg.frame = CGRectMake(10+widthPrice, cell.priceLabel.frame.origin.y, 14, 14);
        [cell.markImg sd_setImageWithURL:[NSURL URLWithString:item.size_img_thumb]];

    }else{
        cell.markImg.hidden = YES;
    }
    cell.ageLabel.text = item.age;
    
    
    return cell;//为什么我的成长记录没有他们那种的红色标记
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    ToyLeaseItem *item = [searchResultUserArray objectAtIndex:indexPath.row];
    ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
    toyDetailVC.business_id = item.business_id;
    [self.navigationController pushViewController:toyDetailVC animated:YES];

    
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH/2,SCREEN_WIDTH/2*1.1);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
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

-(float)getTitleWidth:(NSString *)title fontSize:(NSInteger )fontSize{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize nickSize = [title sizeWithAttributes:attributes];
    return nickSize.width+3;
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:NO];
    
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
