//
//  WorthBuyDetailListSegViewController.m
//  BabyShow
//
//  Created by WMY on 15/6/2.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "WorthBuyDetailListSegViewController.h"
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


@interface WorthBuyDetailListSegViewController ()
@property (nonatomic, assign)BOOL isRefresh;
@property (nonatomic, assign)BOOL isGetMore;
@property (nonatomic, assign)BOOL isFinished;

@property (nonatomic, assign)NSInteger selectedIndex;
@property (nonatomic, assign)NSInteger post_class;

@property (nonatomic ,strong)UITableView *tableView;


@end

@implementation WorthBuyDetailListSegViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedIndex=0;
    _post_class = 1;

    self.loginUserId =LOGIN_USER_ID;
    self.automaticallyAdjustsScrollViewInsets=NO;
    [self setSegView];
    [self setTableView];
    [self setBackBtn];
    _dataArray=[NSMutableArray array];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    _addTopicBtn.enabled=YES;
    
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
        [self getDataWithChannel:_post_class];
        
    }
    
    
    
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
#pragma mark UI

-(void)setBackBtn{
    
    //返回按钮
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



-(void)setSegView{
    
    NSArray *segArray=[NSArray arrayWithObjects:@"童装",@"童鞋配饰",@"书本玩具",@"婴幼用品", nil];
    NSArray *segArray1=[NSArray arrayWithObjects:@"服装",@"美妆",@"鞋包配饰",@"辣妈用品", nil];
    if (self.buy_type == 5) {
        _seg=[[UISegmentedControl alloc]initWithItems:segArray1];

    }
    else{
        _seg=[[UISegmentedControl alloc]initWithItems:segArray];
        

    }
       _seg.frame=CGRectMake(0, 0, 320, 34);
    _seg.backgroundColor=[UIColor whiteColor];
    [_seg setTintColor:[UIColor clearColor]];
    [_seg addTarget:self action:@selector(ChangeChanel:) forControlEvents:UIControlEventValueChanged];
    
    NSDictionary *selectedAttributesDic=[NSDictionary dictionaryWithObjectsAndKeys:
                                         [BBSColor hexStringToColor:BACKCOLOR],NSForegroundColorAttributeName,
                                         [UIFont fontWithName:@"Helvetica-Bold" size:15],NSFontAttributeName,nil];
    
    NSDictionary *unselectedAttributesDic=[NSDictionary dictionaryWithObjectsAndKeys:
                                           [BBSColor hexStringToColor:@"#6b6b6b"],NSForegroundColorAttributeName,
                                           [UIFont systemFontOfSize:13],NSFontAttributeName,nil];
    
    [_seg setTitleTextAttributes:unselectedAttributesDic forState:UIControlStateNormal];
    [_seg setTitleTextAttributes:selectedAttributesDic forState:UIControlStateSelected];
    [_seg setSelectedSegmentIndex:_selectedIndex];
    
    UIView *seperateView=[[UIView alloc]initWithFrame:CGRectMake(0, 33, SCREENWIDTH, 1)];
    UIImage *seperateImage=[UIImage imageNamed:@"img_myshow_line"];
    seperateView.backgroundColor=[UIColor colorWithPatternImage:seperateImage];
    [_seg addSubview:seperateView];
    
    
    _channelViewArray=[NSMutableArray array];
    
    UIView *lineView=[[UIView alloc]initWithFrame:CGRectMake(0, 30, 80, 3)];
    lineView.backgroundColor=[BBSColor hexStringToColor:BACKCOLOR];
    [_seg addSubview:lineView];
    [_channelViewArray addObject:lineView];
    
    UIView *lineView1=[[UIView alloc]initWithFrame:CGRectMake(80, 30, 80, 3)];
    lineView1.backgroundColor=[BBSColor hexStringToColor:BACKCOLOR];
    [_seg addSubview:lineView1];
    [_channelViewArray addObject:lineView1];
    
    UIView *lineView2=[[UIView alloc]initWithFrame:CGRectMake(160, 30, 80, 3)];
    lineView2.backgroundColor=[BBSColor hexStringToColor:BACKCOLOR];
    [_seg addSubview:lineView2];
    [_channelViewArray addObject:lineView2];
    
    UIView *lineView3=[[UIView alloc]initWithFrame:CGRectMake(240, 30, 80, 3)];
    lineView3.backgroundColor=[BBSColor hexStringToColor:BACKCOLOR];
    [_seg addSubview:lineView3];
    [_channelViewArray addObject:lineView3];
    
    [self setSelectedChannel:_selectedIndex];
    
}
-(void)setTableView{
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor whiteColor];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor whiteColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.scrollsToTop=YES;
    [self.view addSubview:_tableView];
    
    [_tableView setTableHeaderView:_headerView];
    
    __weak WorthBuyDetailListSegViewController *worthBuy=self;
    [_tableView addPullToRefreshWithActionHandler:^{
        
        worthBuy.isRefresh=1;
        worthBuy.timeForPage=NULL;
        worthBuy.isFinished=0;
        [worthBuy getDataWithChannel:worthBuy.post_class];
        
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        if (!worthBuy.isFinished) {
            if (worthBuy.tableView.pullToRefreshView.state==SVInfiniteScrollingStateStopped) {
                [worthBuy getDataWithChannel:worthBuy.post_class];
            }
        }else{
            if (worthBuy.tableView.infiniteScrollingView && worthBuy.tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
                [worthBuy.tableView.infiniteScrollingView stopAnimating];
            }
            
        }
        
    }];
    
}

-(void)getDataWithChannel:(NSInteger) channel{
    
    _addTopicBtn.enabled=NO;
    
    NetAccess *net=[NetAccess sharedNetAccess];
    
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:self.loginUserId,@"login_user_id",[NSString stringWithFormat:@"%ld",(long)channel],@"buy_class",[NSString stringWithFormat:@"%ld", (long)self.buy_type],@"buy_type",self.timeForPage,@"post_create_time", nil];
    [net getDataWithStyle:NetStylePostBarWorthBuy andParam:param];
    
    [LoadingView startOnTheViewController:self];
    
}
-(void)getDataSucceed:(NSNotification *) not{
    
    _addTopicBtn.enabled=YES;
    
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
#pragma mark UITableViewDelegate
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return _seg;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 34;
}

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



-(void)getDataFail:(NSNotification *)not{
    
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    

    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    
}


-(void)ChangeChanel:(UISegmentedControl *) seg{
    
    _selectedIndex = [seg selectedSegmentIndex];
    
    switch (_selectedIndex) {
        case 0:
            _post_class = 1;
            break;
        case 1:
            _post_class = 2;
            break;
        case 2:
            _post_class = 3;
            break;
        case 3:
            _post_class = 4;
            break;
        default:
            break;
    }
    [self setSelectedChannel:_selectedIndex];
    
}

-(void)setSelectedChannel:(NSInteger) index{
    
    for (UIView *channelView in _channelViewArray) {
        if ([_channelViewArray indexOfObject:channelView]==index) {
            [channelView setHidden:NO];
        }else{
            [channelView setHidden:YES];
        }
    }
    
    _isRefresh=1;
    self.timeForPage=NULL;
    _isFinished=0;
    [self getDataWithChannel:_post_class];
    
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

-(void)netFail{
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    [LoadingView stopOnTheViewController:self];
    
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
