//
//  WorthBuyDetailListViewController.m
//  BabyShow
//
//  Created by WMY on 15/6/2.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "WorthBuyDetailListViewController.h"
#import "WorthBuyItem.h"
#import "WorthBuyImageItem.h"
#import "UserInfoManager.h"
#import "UIImageView+WebCache.h"
#import "UserInfoItem.h"
#import "PBHeaderViewItem.h"
#import "WebViewController.h"
#import "WorthBuyPublishViewController.h"
#import "BBSNavigationController.h"
#import "BBSNavigationControllerNotTurn.h"

@interface WorthBuyDetailListViewController ()
@property (nonatomic, assign)BOOL isRefresh;
@property (nonatomic, assign)BOOL isGetMore;
@property (nonatomic, assign)BOOL isFinished;

@property (nonatomic, assign)NSInteger selectedIndex;
@property (nonatomic, assign)NSInteger post_class;

@property (nonatomic ,strong)UITableView *tableView;


@end

@implementation WorthBuyDetailListViewController


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    
    //值得买列表数据：
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_WORTHBUY_DATA_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_WORTHBUY_DATA_FAIL object:nil];
  
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (delegate.worthbuyHasNewTopic==YES) {
        
        delegate.worthbuyHasNewTopic=NO;
        [_tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
        _isRefresh=1;
        self.timeForPage=NULL;
        _isFinished=0;
 
        
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.loginUserId =LOGIN_USER_ID;
    self.automaticallyAdjustsScrollViewInsets=NO;

    [self setLeftBtn];
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];

    [self setTableView];
    _dataArray=[NSMutableArray array];

    
}
-(void)viewWillDisappear:(BOOL)animated{
    
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

-(void)setLeftBtn{
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)setTableView{
    

    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.scrollsToTop=YES;
    [self.view addSubview:_tableView];
    [self getDataWithChannel];
    
    __weak WorthBuyDetailListViewController *detailVC=self;
    [_tableView addPullToRefreshWithActionHandler:^{
        
        detailVC.isRefresh=1;
        detailVC.timeForPage=NULL;
        detailVC.isFinished=0;
        [detailVC getDataWithChannel];
        
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        if (!detailVC.isFinished) {
            if (detailVC.tableView.pullToRefreshView.state==SVInfiniteScrollingStateStopped) {
                [detailVC getDataWithChannel];
            }
        }else{
            if (detailVC.tableView.infiniteScrollingView && detailVC.tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
                [detailVC.tableView.infiniteScrollingView stopAnimating];
            }
            
        }
        
    }];
    
}


-(void)getDataWithChannel{
        
    NetAccess *net=[NetAccess sharedNetAccess];
    
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%ld", (long)self.buy_list],@"buy_list",self.timeForPage,@"post_create_time", nil];
    [net getDataWithStyle:NetStylePostBarWorthBuy andParam:param];
    
    [LoadingView startOnTheViewController:self];
    
}

-(void)getDataSucceed:(NSNotification *) not{
    
    
    [LoadingView stopOnTheViewController:self];
    
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    
    if (_isRefresh==1) {
        [_dataArray removeAllObjects];
        [_tableView reloadData];
        _isRefresh=0;
    }
    
    NSString *styleString=not.object;
    
    NetAccess *net=[NetAccess sharedNetAccess];
    
    NSArray *returnArray=[net getReturnDataWithNetStyle:[styleString intValue]];
    
    if (returnArray.count) {
        
        [_dataArray addObjectsFromArray:returnArray];
        [_tableView reloadData];
        
        WorthBuyItem *item=[returnArray lastObject];
        self.timeForPage=item.time;
        
    }else{
        
        _isFinished=1;
        if (self.timeForPage) {
            [self showHUDWithMessage:@"已没有更多数据"];
        }else{
            [self showHUDWithMessage:@"还没有数据哦"];
        }
        
    }
    
}


-(void)getDataFail:(NSNotification *)not{
    
    _addTopicBtn.enabled=YES;
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    
}

#pragma mark UITableViewDelegate


-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 140;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify = @"WORTHBUY";
    
    WorthBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        cell = [[WorthBuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    
    cell.delegate = self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    //数据
    [cell.imgBtn setBackgroundImage:nil forState:UIControlStateNormal];
    
    WorthBuyItem *item = [_dataArray objectAtIndex:indexPath.row];
    
    cell.shopLabel.text = item.shopName;
    if (item.remainTime.length <= 0) {
        cell.remainTimeLabel.text = nil;
    } else {
        cell.remainTimeLabel.text = [NSString stringWithFormat:@"还剩%@",item.remainTime];
    }
    cell.describeLabel.text = item.descript;
    cell.priceLabel.text = [NSString stringWithFormat:@"¥%@%@",item.currentPrice,item.isPostage?@"包邮":@"元"];
    [cell.priceLabel setFont:[UIFont boldSystemFontOfSize:13.0] range:NSMakeRange(0, 1)];
    
    if (item.originPrice.length <= 0) {
        cell.originPriceLabel.text = nil;
    } else {
        NSDictionary *attributes = @{NSFontAttributeName:cell.priceLabel.font};
        CGSize size = [cell.priceLabel.text sizeWithAttributes:attributes];
        CGRect originFrame = cell.originPriceLabel.frame;
        originFrame.origin.x = cell.priceLabel.frame.origin.x + size.width + 5;
        cell.originPriceLabel.frame = originFrame;
        cell.originPriceLabel.text = [NSString stringWithFormat:@"原价:%@元",item.originPrice];
    }
    if (item.latestState.length <= 0) {
        cell.latestStateLabel.text = nil;
    } else {
        cell.latestStateLabel.text = [NSString stringWithFormat:@"最新:%@",item.latestState];
    }
    cell.imgBtn.photosArray = item.photoArray;
    
    WorthBuyImageItem *imgItem = [item.photoArray objectAtIndex:0];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
//    [manager downloadWithURL:[NSURL URLWithString:imgItem.imgThumbStr] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//        [cell.imgBtn setImage:image forState:UIControlStateNormal];
//    }];
    [manager downloadImageWithURL:[NSURL URLWithString:imgItem.imgThumbStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [cell.imgBtn setImage:image forState:UIControlStateNormal];

    }];
    
//    if (item.good_type == 0 ) {
//        //没有logo
//        cell.classLogoImgV.image = nil;
//    } else {
//        
//        NSString *imageStr = [NSString stringWithFormat:@"worth_buy_logo_%d",item.good_type];
//        cell.classLogoImgV.image = [UIImage imageNamed:imageStr];
//    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    WorthBuyItem *item=[_dataArray objectAtIndex:indexPath.row];
    WorthBuyImageItem *imgItem = [item.photoArray objectAtIndex:0];
    
    if (item.urlstring.length) {
        
        WebViewController *webView=[[WebViewController alloc]init];
        webView.urlStr=[item.urlstring stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        webView.descript = item.descript;
        webView.imgThumb = imgItem.imgThumbStr;
        webView.img_id = item.good_id;
        [webView setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:webView animated:YES];
        
    }
    
    
}

#pragma mark CellDelegate

-(void)seeThePhotos:(BtnWithPhotos *)btn{
    
    int i = 0;
    
    NSMutableArray *imgArr = [[NSMutableArray alloc]init];
    _PhotoArray=[NSMutableArray array];
    
    for (WorthBuyImageItem *imgItem in btn.photosArray) {
        
        NSMutableDictionary *imgDic=[[NSMutableDictionary alloc]init];
        [imgDic setObject:imgItem.imgStr1280 forKey:kMyShowImg];
        [imgDic setObject:imgItem.imgClearStr forKey:kMyShowImgDown];
        [imgDic setObject:imgItem.imgThumbStr forKey:kMyShowImgThumb];
        
        [imgArr addObject:imgDic];
        
        MWPhoto *photo=[[MWPhoto alloc]initWithURL:[NSURL URLWithString:imgItem.imgStr1280] info:nil];
        photo.img_info =@{@"description": [NSString stringWithFormat:@"%d/%lu",i+1,(unsigned long)btn.photosArray.count]};
        [_PhotoArray addObject:photo];
        i++;
        
    }
    
    MWPhotoBrowser *browser =[[ MWPhotoBrowser alloc]initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    [browser setCurrentPhotoIndex:0];
    browser.type = 10;
    browser.needPlay = NO;     //需要播放
    browser.imgArr = imgArr;    //播放需要的东西
    browser.is_show_album =NO;
    browser.user_id =self.loginUserId;
    
    BBSNavigationController *nav=[[BBSNavigationController alloc]initWithRootViewController:browser];
    [self presentViewController:nav animated:YES completion:nil];
    
    
}
#pragma mark HUD

-(void)showHUDWithMessage:(NSString *)message{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60,64+20+50+50+50+5 , 200, 30)];
    label.backgroundColor = [UIColor darkGrayColor];
    label.layer.cornerRadius = 3.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:13];
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
#pragma mark MWPhotoBrowserDelegate

-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    MWPhoto *photo=[_PhotoArray objectAtIndex:index];
    return photo;
}

-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return [_PhotoArray count];
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
