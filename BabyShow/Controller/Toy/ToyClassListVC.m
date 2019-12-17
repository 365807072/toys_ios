//
//  ToyClassListVC.m
//  BabyShow
//
//  Created by WMY on 17/1/10.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyClassListVC.h"
#import "RefreshControl.h"
#import "ToyLeaseItem.h"
#import "ToyLeaseListCell.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "ToyLeaseDetailVC.h"
#import "MakeAToyPostVC.h"
#import "NIAttributedLabel.h"
#import "ToyTransportVC.h"
#import "LoginHTMLVC.h"
#import "WebViewController.h"
#import "PurchaseCarAnimationTool.h"
#import "ToyCarVC.h"
#import "BookToysVC.h"
#import "ToyShareNewVC.h"
#import "ToySearchVC.h"
@interface ToyClassListVC ()<RefreshControlDelegate>{
    
    NSMutableArray *_dataArray;
    RefreshControl *_refreshControl;
    UIButton *rightBtn;
    UILabel *_badgeValueLabel;
    UIButton *searchBtn;
}
@property (nonatomic, strong) NSString *post_create_time;
@property(nonatomic,strong)UIButton *addCarBtn;//购物车
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)UIView *navSearchView;//搜索的页面
@end

@implementation ToyClassListVC

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray=[NSMutableArray array];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;

    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault]; [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    [self getToyCarCount];

}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [BBSColor hexStringToColor:NAVICOLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; [self.navigationController.navigationBar setShadowImage:nil];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
   
    self.view.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _post_create_time = NULL;
    [self setSearchBar];
    //[self setBackButton];
    [self setCollectionViewLay];
    [self refreshControlInit];
    //[self setRightBtn];
    [self setToyCar];
    //获取购物车里面的玩具数量

}
#pragma mark 搜素引擎
-(void)setSearchBar{
    self.navSearchView = [[UIView alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH, 44+12)];
    self.navSearchView.backgroundColor = [BBSColor hexStringToColor:@"ffffff" alpha:0];
    [self.view addSubview:self.navSearchView];
    CGRect backBtnFrame = CGRectMake(10, 12+18, 30, 17);
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.adjustsImageWhenHighlighted = NO;
    [backBtn setImage:[UIImage imageNamed:@"btn_toy_detail_back"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame=backBtnFrame;
    [self.navSearchView addSubview:backBtn];
    
    searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.navSearchView addSubview:searchBtn];
    [searchBtn setBackgroundImage:nil forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(33, 12+13, SCREENWIDTH-33-40, 25);
    searchBtn.backgroundColor = [BBSColor hexStringToColor:@"ededed" alpha:0.65];
    searchBtn.layer.masksToBounds = YES;
    searchBtn.layer.cornerRadius = 12;
    [searchBtn setTitle:@"" forState:UIControlStateNormal];
    [searchBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
    searchBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    //[searchBtn setImage:[UIImage imageNamed:@"btn_baby_show_search"] forState:UIControlStateNormal];
    searchBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [searchBtn setTitleEdgeInsets:UIEdgeInsetsMake(1, 10,1, 0)];
    [searchBtn addTarget:self action:@selector(pushSearchView) forControlEvents:UIControlEventTouchUpInside];
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [[HTTPClient sharedClient]getNewV1:@"GetToysIcon" params:@{@"login_user_id":LOGIN_USER_ID} success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = result[@"data"];
            NSString *img = data[@"icon_img"];
            NSURL *url = [NSURL URLWithString:img];
            UIImage* shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            
            [shareBtn setBackgroundImage:shareImg forState:UIControlStateNormal];
            CGFloat weight = shareImg.size.width/shareImg.size.height*40;
            shareBtn.frame = CGRectMake(SCREENWIDTH-weight, 17, weight, 40);
            [shareBtn addTarget:self action:@selector(getAskPage) forControlEvents:UIControlEventTouchUpInside];
            [self.navSearchView addSubview:shareBtn];
            
        }
    } failed:^(NSError *error) {
    }];

}
#pragma mark - UISearchBarDelegate Methods搜索
-(void)pushSearchView{
    ToySearchVC *toySearchVC = [[ToySearchVC alloc]init];
    [self.navigationController pushViewController:toySearchVC animated:NO];
}

#pragma mark 购物车
-(void)setToyCar{
    self.addCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addCarBtn.frame = CGRectMake(SCREENWIDTH-80, SCREENHEIGHT-80, 43, 43);
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
-(void)setRightBtn{
    
    UIView *iconBgView = [[UIView alloc]init];
    
    //= [[UIView alloc]initWithFrame:CGRectMake(0, -5, 15, 20)];

    rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [[HTTPClient sharedClient]getNewV1:@"GetToysIcon" params:@{@"login_user_id":LOGIN_USER_ID} success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = result[@"data"];
            NSString *img = data[@"icon_img"];
            NSURL *url = [NSURL URLWithString:img];
            UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            
            [rightBtn setBackgroundImage:shareImg forState:UIControlStateNormal];
            CGFloat weight = shareImg.size.width/shareImg.size.height*40;
            iconBgView.frame = CGRectMake(SCREENWIDTH-weight, 0, weight, 40);
            rightBtn.frame = CGRectMake(0, 0, weight, 40);
        }
    } failed:^(NSError *error) {
    }];

    [rightBtn addTarget:self action:@selector(getAskPage) forControlEvents:UIControlEventTouchUpInside];
    [iconBgView addSubview:rightBtn];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:iconBgView];
    self.navigationItem.rightBarButtonItem = right;
}
-(void)getAskPage{
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
        return;
    }else{
        ToyShareNewVC *toyShareVC = [[ToyShareNewVC alloc]init];
        [self.navigationController pushViewController:toyShareVC animated:YES];
    }
}
-(void)setBackButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 30, 17);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.adjustsImageWhenHighlighted = NO;
    [_backBtn setImage:[UIImage imageNamed:@"btn_toy_detail_back"] forState:UIControlStateNormal];
    [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];

    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)setCollectionViewLay{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    //设置headerView的尺寸大小
    layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    layout.minimumInteritemSpacing = 0;
    //layout.headerReferenceSize = CGSizeMake(self.view.frame.size.width, 100);
    //layout.itemSize = CGSizeMake(SCREEN_WIDTH/2, 1.19*SCREEN_WIDTH/2);
    CGRect userFram = CGRectMake(0, 56, SCREENWIDTH, SCREENHEIGHT-56);
    self.automaticallyAdjustsScrollViewInsets = NO;
    _collectionView = [[UICollectionView alloc]initWithFrame:userFram collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.hidden = NO;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_collectionView];
    [_collectionView registerClass:[ToyAllListCell class] forCellWithReuseIdentifier:@"ToyClassifyAllListCell"];
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
        [self getListData];
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
-(void)getListData{
         NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    if (self.businessId) {
        [param setObject:self.businessId forKey:@"category_id"];
    }
    if (_post_create_time) {
        [param setObject:_post_create_time forKey:@"post_create_time"];
    }
    UrlMaker *urlMark = [[UrlMaker alloc]initWithNewV1UrlStr:@"getSelectToysList" Method:NetMethodGet andParam:param];
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
            if (returnArray.count == 0) {
                //[self showHUDWithMessage:@"没有更多玩具啦！"];
                _refreshControl.bottomEnabled = NO;
            }
            if (_post_create_time == NULL) {
                [_dataArray removeAllObjects];
                _refreshControl.bottomEnabled = YES;
            }
            ToyLeaseItem *item = [returnArray lastObject];
            _post_create_time = item.post_create_time;
            [_dataArray addObjectsFromArray:returnArray];
            [CATransaction setDisableActions:YES];
            [_collectionView reloadData];
            [CATransaction commit];
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
#pragma mark 实现collectionview的代理方法
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return  [_dataArray count];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //注册cell
    //注册cell
    [collectionView registerClass:[ToyAllListCell class] forCellWithReuseIdentifier:@"ToyClassifyAllListCell"];
    ToyAllListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ToyClassifyAllListCell" forIndexPath:indexPath];
    ToyLeaseItem *item = [_dataArray objectAtIndex:indexPath.row];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    if (item.img_thumb.length >0) {
        [cell.toyPicImg sd_setImageWithURL:[NSURL URLWithString:item.img_thumb]];
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
    ToyLeaseItem *item = [_dataArray objectAtIndex:indexPath.row];
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

-(void)sureBookOrCancelToy:(BOOL)isBook  item:(ToyLeaseItem*)item row:(NSInteger)row{
        NSString *alertTitle;
        if (isBook == YES) {
            alertTitle = @"确定预约这个宝贝么";
        }else{
            alertTitle = @"确定不预约了么";
        }

            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:alertTitle preferredStyle:UIAlertControllerStyleAlert];
            __weak ToyClassListVC *babyVC = self;
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (isBook == YES) {
                    [babyVC addToyToAppointment:item row:row];
                }else{
                    [babyVC cancleAppointmentToy:item row:row];
                }
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
}
-(void)addToyToAppointment:(ToyLeaseItem*)item row:(NSInteger)row{
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",item.business_id,@"business_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"ToysUserAppointmentAdd" params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            item.is_order = @"2";
            NSString *alerting = @"预约成功！查看预约请到“订单-我的预约”";
            [self cancelOrPushBookToysList:alerting];
            [self refreshCellSection:0 row:row];
            
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您似乎与网络断开，检查一下吧" andDelegate:nil];
    }];
    

}
-(void)cancelOrPushBookToysList:(NSString*)alertTitle{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:alertTitle preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"去看看" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self pushMyBookingToys];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}
#pragma mark 进入我的预约
-(void)pushMyBookingToys{
    BookToysVC *book = [[BookToysVC alloc]init];
    [self.navigationController pushViewController:book animated:YES];
}

-(void)cancleAppointmentToy:(ToyLeaseItem*)item row:(NSInteger)row{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",item.business_id,@"business_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"ToysUserAppointmentDel" params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            item.is_order = @"1";
            NSString *alerting = @"已取消！查看预约请到“订单-我的预约”";
            [self cancelOrPushBookToysList:alerting];
            

          //  [BBSAlert showAlertWithContent:@"您已经取消预约！" andDelegate:self];
            [self refreshCellSection:0 row:row];
            
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您似乎与网络断开，检查一下吧" andDelegate:nil];
    }];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ToyLeaseItem *item = [_dataArray objectAtIndex:indexPath.row];
        ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
        toyDetailVC.business_id = item.business_id;
        [self.navigationController pushViewController:toyDetailVC animated:YES];
        
}
#pragma mark 加入购物车后cell的刷新
-(void)refreshCellSection:(NSInteger)section row:(NSInteger)row{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    NSArray<NSIndexPath*>*indexPathArray = @[indexPath];
   // [_tableView reloadRowsAtIndexPaths:indexPathArray withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(float)getTitleWidth:(NSString *)title fontSize:(NSInteger )fontSize{
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGSize nickSize = [title sizeWithAttributes:attributes];
    return nickSize.width+3;
    
}

//传入字符串，控件宽，字体，比较的高，最大的高，最小的高
-(CGFloat)getHeightByWidth:(CGFloat)width title:(NSString*)title font:(UIFont*)font{
    NIAttributedLabel *label = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
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
        [self.navigationController popViewControllerAnimated:YES];
}

//熊猫
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
