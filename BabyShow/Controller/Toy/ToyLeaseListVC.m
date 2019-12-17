//
//  ToyLeaseListVC.m
//  BabyShow
//
//  Created by WMY on 16/12/6.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyLeaseListVC.h"
#import "RefreshControl.h"
#import "ToyLeaseItem.h"
#import "ToyLeaseListCell.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "ToyLeaseDetailVC.h"
#import "MakeAToyPostVC.h"
#import "ToyTransportVC.h"
#import "NIAttributedLabel.h"
#import "LoginHTMLVC.h"
#import "WebViewController.h"
#import "MyDepositVC.h"
@interface ToyLeaseListVC ()<RefreshControlDelegate>{
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    RefreshControl *_refreshControl;
    UIView *btnView;
    UIButton *firstBtn;
    UIButton *secondBtn;
    UIButton *thridBtn;
    UIView *iconView;
}

@property (nonatomic, strong) NSString *post_create_time;
@property(nonatomic,strong)UIButton *editBtn;//发帖
@property(nonatomic,strong)NSString *orderId;//发完贴之后的玩具订单id
@end

@implementation ToyLeaseListVC
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
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;


}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationItem.title = @"玩具";
    self.view.backgroundColor = [UIColor whiteColor];
    _post_create_time = NULL;
    if (_inTheViewData!= 2003) {
        _inTheViewData = 2001;
    }
    [self setBackButton];
    [self setHeaderView];
    [self setTableView];
    [self refreshControlInit];
    [self setEditBtnFrame];
    [self setRightBtn];
    // Do any additional setup after loading the view.
}
-(void)setRightBtn{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(SCREENWIDTH-40, 0, 25, 26);
    [rightBtn addTarget:self action:@selector(getAskPage) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"toy_ask"] forState:UIControlStateNormal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = right;
    
}
-(void)getAskPage{
    WebViewController *webView=[[WebViewController alloc]init];
    NSString *url = @"http://www.meimei.yihaoss.top/question/questionIndex.html";
    webView.urlStr=[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [webView setHidesBottomBarWhenPushed:YES];
    webView.fromWhree = @"1";
    
    [self.navigationController pushViewController:webView animated:YES];

}
-(void)setHeaderView
{
    btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH,42)];
    [self.view addSubview:btnView];
    
    firstBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    firstBtn.frame = CGRectMake(0, 0, SCREENWIDTH/3, 42);
    [firstBtn setTitle:@"待租" forState:UIControlStateNormal];
    firstBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [firstBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 55, 10,15)];
    [firstBtn setTitleColor:[BBSColor hexStringToColor:@"fc6262"] forState:UIControlStateNormal];
    [btnView addSubview:firstBtn];
    firstBtn.tag = 2001;
    [firstBtn addTarget:self action:@selector(changeDataWithTag:) forControlEvents:UIControlEventTouchUpInside];
    secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    secondBtn.frame = CGRectMake(SCREENWIDTH/3, 0, SCREENWIDTH/3, 42);
    [secondBtn setTitle:@"已租" forState:UIControlStateNormal];
    secondBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [secondBtn setTitleEdgeInsets:UIEdgeInsetsMake(5,0, 10, 0)];
    [secondBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
    [btnView addSubview:secondBtn];
    secondBtn.tag = 2002;
    [secondBtn addTarget:self action:@selector(changeDataWithTag:) forControlEvents:UIControlEventTouchUpInside];

    
    thridBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    thridBtn.frame = CGRectMake(SCREENWIDTH*2/3, 0, SCREENWIDTH/3, 42);
    [thridBtn setTitle:@"自己" forState:UIControlStateNormal];
    thridBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [thridBtn setTitleEdgeInsets:UIEdgeInsetsMake(5, 20, 10,50)];
    [thridBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
    [btnView addSubview:thridBtn];
    thridBtn.tag = 2003;
    [thridBtn addTarget:self action:@selector(changeDataWithTag:) forControlEvents:UIControlEventTouchUpInside];

    iconView = [[UIView alloc]init];

    if (_inTheViewData == 2001 ) {
        iconView.frame = CGRectMake(SCREENWIDTH/4-10, 33, 5, 5);
        [firstBtn setTitleColor:[BBSColor hexStringToColor:@"fc6262"] forState:UIControlStateNormal];
        [secondBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
        [thridBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];

    }else if (_inTheViewData == 2002){
        iconView.frame = CGRectMake(SCREENWIDTH/2-2, 33, 5, 5);
        [firstBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
        [secondBtn setTitleColor:[BBSColor hexStringToColor:@"fc6262"] forState:UIControlStateNormal];
        [thridBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
    }else if (_inTheViewData == 2003){
        iconView.frame = CGRectMake(SCREENWIDTH*3/4+10, 33, 5, 5);
        [firstBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
        [secondBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
        [thridBtn setTitleColor:[BBSColor hexStringToColor:@"fc6262"] forState:UIControlStateNormal];
    }
    iconView.backgroundColor = [BBSColor hexStringToColor:NAVICOLOR];
    iconView.layer.masksToBounds = YES;
    iconView.layer.cornerRadius = 2.5;
    [btnView addSubview:iconView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 41.5, SCREENWIDTH, 0.5)];
    lineView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
    [btnView addSubview:lineView];

}
-(void)setEditBtnFrame{
    self.editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editBtn.frame = CGRectMake(320-60, SCREENHEIGHT-104, 50,50);
    [self.editBtn setBackgroundImage:[UIImage imageNamed:@"img_myshow_newmakeashow"] forState:UIControlStateNormal];
    [self.editBtn addTarget:self action:@selector(pushMakeAToyPostVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.editBtn];
}
#pragma mark 发布一条新信息
-(void)pushMakeAToyPostVC{
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
        return;
    }else{
        MakeAToyPostVC *makeAToy = [[MakeAToyPostVC alloc]init];
        makeAToy.refreshIngrowthVC = ^(){
            [self changeData:2003];
        };
        [self.navigationController pushViewController:makeAToy animated:YES];
    }
}
-(void)setTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect tableviewFrame=CGRectMake(0,106, SCREENWIDTH, SCREENHEIGHT-64-42);
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

-(void)setBackButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.adjustsImageWhenHighlighted = NO;
    
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
#pragma mark 点击上面按钮的时候数据的切换
-(void)changeDataWithTag:(UIButton*)sender{
    UIButton *button = sender;
    _inTheViewData = button.tag;
    [self changeData:_inTheViewData];

}
-(void)changeData:(NSInteger)tag{
    if (_inTheViewData == 2001) {
        iconView.frame = CGRectMake(SCREENWIDTH/4-10, 33, 5, 5);
        [firstBtn setTitleColor:[BBSColor hexStringToColor:@"fc6262"] forState:UIControlStateNormal];
        [secondBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
        [thridBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
        _post_create_time = NULL;
        [self getListData];
    }else if (_inTheViewData == 2002){
        iconView.frame = CGRectMake(SCREENWIDTH/2-2, 33, 5, 5);
        [firstBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
        [secondBtn setTitleColor:[BBSColor hexStringToColor:@"fc6262"] forState:UIControlStateNormal];
        [thridBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
        _post_create_time = NULL;
        [self getListData];
        
    }else if (_inTheViewData == 2003){
        UserInfoManager *manager=[[UserInfoManager alloc]init];
        UserInfoItem *userItem=[manager currentUserInfo];
        if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
            LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
            [self presentViewController:nav animated:YES completion:^{
            }];
            return;
        }else{
        iconView.frame = CGRectMake(SCREENWIDTH*3/4+10, 33, 5, 5);
        [firstBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
        [secondBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
        [thridBtn setTitleColor:[BBSColor hexStringToColor:@"fc6262"] forState:UIControlStateNormal];
        _post_create_time = NULL;
        [self getListData];
    
        }
        
    }

    
}
-(void)back{
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    if ([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
        NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults];
        [pushJudge setObject:@""forKey:@"push"];
        [pushJudge synchronize];//记得立即同步
        [self dismissViewControllerAnimated:YES completion:nil];

    }else{
    [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)getListData{
    NSString *isOrder;
    if (_inTheViewData == 2001) {
        isOrder = @"0";
    }else if (_inTheViewData == 2002){
        isOrder = @"1";
    }else if (_inTheViewData == 2003){
        isOrder = @"-1";

    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",isOrder,@"is_order",_post_create_time,@"post_create_time", nil];
    UrlMaker *urlMark = [[UrlMaker alloc]initWithNewV1UrlStr:kgetToysList Method:NetMethodGet andParam:params];
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
                item.business_title = dataDic[@"business_title"];
                item.way = dataDic[@"way"];
                item.img_thumb = dataDic[@"img_thumb"];
                item.is_support = dataDic[@"is_support"];
                item.sell_price = dataDic[@"sell_price"];
                item.is_order = dataDic[@"is_order"];
                item.post_create_time = dataDic[@"post_create_time"];
                item.status = dataDic[@"status"];
                item.status_name = dataDic[@"status_name"];
                item.avatar = dataDic[@"avatar"];
                item.support_name = dataDic[@"support_name"];
                item.order_id = dataDic[@"order_id"];
                item.is_jump = dataDic[@"is_jump"];
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
    return 122;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"TOYLEASELISTCELL"];
    ToyLeaseListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[ToyLeaseListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    ToyLeaseItem *item = [_dataArray objectAtIndex:indexPath.row];
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    if (item.img_thumb.length >0) {
        [cell.photoView sd_setImageWithURL:[NSURL URLWithString:item.img_thumb]];
    }else{
        cell.photoView.image = [UIImage imageNamed:@"img_message_photo"];
    }

    CGFloat height = [self getHeightByWidth:SCREENWIDTH-157 title:item.business_title font:[UIFont systemFontOfSize:16]];
    cell.toyNameLabel.frame = CGRectMake(cell.toyNameLabel.frame.origin.x, cell.toyNameLabel.frame.origin.y, SCREENWIDTH-157, height);
    cell.toyNameLabel.text = item.business_title;
    cell.toyNameLabel.lineBreakMode = UILineBreakModeWordWrap;

    [manager downloadImageWithURL:[NSURL URLWithString:item.avatar] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {

        cell.userImg.image = image;
    }];
    cell.userImg.frame = CGRectMake(cell.toyNameLabel.frame.origin.x, cell.toyNameLabel.frame.origin.y+cell.toyNameLabel.frame.size.height+4, 15,15);
    cell.userNameLabel.frame = CGRectMake(cell.userImg.frame.origin.x+cell.userImg.frame.size.width+5, cell.userImg.frame.origin.y, 170, 15);
    cell.userNameLabel.text = item.user_name;
    cell.explainLabel.text = item.support_name;
    if ([item.way isEqualToString:@"1"]) {
        cell.toyImg.image = [UIImage imageNamed:@"toy_lease"];
    }else if ([item.way isEqualToString:@"0"]){
        cell.toyImg.image = [UIImage imageNamed:@"toy_buy"];
    }
    cell.priceLabel.text = item.sell_price;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     ToyLeaseItem *item = [_dataArray objectAtIndex:indexPath.row];
    if ([item.is_jump isEqualToString:@"1"]) {
    
        ToyTransportVC *toyTransportVC = [[ToyTransportVC alloc]init];
        toyTransportVC.order_id = item.order_id;
        [self.navigationController pushViewController:toyTransportVC animated:YES];
    }else if ([item.is_jump isEqualToString:@"0"]){
        ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
        toyDetailVC.business_id = item.business_id;
        [self.navigationController pushViewController:toyDetailVC animated:YES];

    }
//    MyDepositVC *myDepostitVC = [[MyDepositVC alloc]init];
//    [self.navigationController pushViewController:myDepostitVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
