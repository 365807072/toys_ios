//
//  StoreOrdersViewController.m
//  BabyShow
//
//  Created by WMY on 15/9/16.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "StoreOrdersViewController.h"
#import "StoreOrderCell.h"
#import "SVPullToRefresh.h"
#import "StoreOrdersItem.h"
#import "OrderDetailViewController.h"
#import "VerficationVC.h"

@interface StoreOrdersViewController ()
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
@property(nonatomic,strong)NSString *sureCode;
@property(nonatomic,assign)NSInteger indexPathSureCode;
@property(nonatomic,strong)StoreOrdersItem *item;
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UITextField *VerificationTF;
@property(nonatomic,strong)UIButton *sureBtn;
@property(nonatomic,strong)UIView *backView;

@property(nonatomic,strong)UIView *btnView;
@property(nonatomic,assign)NSInteger OrderStatus;
@property(nonatomic,assign)NSInteger orderSelectCount;
@property(nonatomic,strong)NSArray *orderSelectArray;
@property(nonatomic,strong)UIView *selectBackView;
@property(nonatomic,strong)NSString *searchId;
@property(nonatomic,strong)UIView *moneyBackView;
@property(nonatomic,assign)BOOL isBottom;
@property(nonatomic,strong)UILabel *orderCountLabel;
@property(nonatomic,strong)UILabel *orderMoneyLabel;

@end

@implementation StoreOrdersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil//1
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray=[NSMutableArray array];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{//1
    _sureBtn.enabled = YES;
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_ORDER_BUSINESS_GETMYORDERLIST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_ORDER_BUSINESS_GETMYORDERLIST_FAIL object:nil];
    //网络错误
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    self.tabBarController.tabBar.hidden = YES;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.isBottom = YES;
    [self setLeftButton];
    //[self setRightButton];
    [self setTableView];
    [self setPhoneNumberTrip];
    [self setMoneyBackViewHidden];
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
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

#pragma mark UI
//返回按钮
-(void)setLeftButton{
    
    //返回按钮
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 31)];
    imagev.image = [UIImage imageNamed:@"btn_back1.png"];
    [_backBtn addSubview:imagev];
    UILabel *cateName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 31)];
    cateName.textColor = [UIColor whiteColor];
    cateName.text = @"我的订单";
    [_backBtn addSubview:cateName];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
-(void)setRightButton{
    CGRect rightFrame=CGRectMake(0,SCREENWIDTH-59 ,45, 15);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,45, 15)];
    imagev.image = [UIImage imageNamed:@"order_group"];
    [_backBtn addSubview:imagev];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=rightFrame;
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.rightBarButtonItem=right;

}
//验证码，电话指导控件
-(void)setPhoneNumberTrip{
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-25, SCREENWIDTH, 25)];
    _phoneLabel.text = @"有任何问题，请联系自由环球租赁";
    _phoneLabel.font = [UIFont systemFontOfSize:12];
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    _phoneLabel.backgroundColor = [BBSColor hexStringToColor:@"000000" alpha:0.5];
    _phoneLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_phoneLabel];
    
    self.btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 77)];
    self.btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.btnView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 36, SCREENWIDTH, 1)];
    lineView.backgroundColor = [BBSColor hexStringToColor:@"eeeeee"];
    [self.btnView addSubview:lineView];
    
    for (int i = 0; i < 5; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15+i*15+(SCREENWIDTH-15*2-15*4)/5*i, 8, (SCREENWIDTH-15*2-15*4)/5, 23);
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"babyshow_myorder_btn%d",i+1]];
        UIImage *imgClick = [UIImage imageNamed:[NSString stringWithFormat:@"babyshow_myorder_btns%d",i+1]];
        btn.adjustsImageWhenHighlighted = NO;
        
        if (i==0) {
            [btn setImage:imgClick forState:UIControlStateNormal];
            [btn setImage:img forState:UIControlStateSelected];
            
        }else{
            [btn setImage:img forState:UIControlStateNormal];
            [btn setImage:imgClick forState:UIControlStateSelected];
        }
        [self.btnView addSubview:btn];
        btn.tag = 900+i;
        [btn addTarget:self action:@selector(orderType:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 37, SCREEN_WIDTH, 50)];
    _backView.backgroundColor = [UIColor whiteColor];
    [self.btnView addSubview:_backView];
    _VerificationTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 200, 30)];
    _VerificationTF.placeholder = @"输入验证码直接验证";
    _VerificationTF.delegate = self;
    _VerificationTF.font = [UIFont systemFontOfSize:14];
    _VerificationTF.borderStyle = UITextBorderStyleRoundedRect;
    _VerificationTF.backgroundColor = [BBSColor hexStringToColor:@"e7e7e7"];
    
    [_backView addSubview:_VerificationTF];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sureBtn.frame = CGRectMake(SCREENWIDTH-90, 10, 80, 30);
    _sureBtn.backgroundColor = [BBSColor hexStringToColor:@"fe6161"];
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.cornerRadius = 10;
    [_sureBtn setTitle:@"验证" forState:UIControlStateNormal];
    [_sureBtn addTarget:self action:@selector(pushVeriVC) forControlEvents:UIControlEventTouchUpInside];
    [_backView addSubview:_sureBtn];
    

}
-(void)setMoneyBackViewHidden{
    self.moneyBackView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-44, SCREENWIDTH, 44)];
    self.moneyBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.moneyBackView];
    UIImageView *imgCount = [[UIImageView alloc]initWithFrame:CGRectMake(10, 11, 16, 20)];
    imgCount.image = [UIImage imageNamed:@"order_btn_count"];
    [self.moneyBackView addSubview:imgCount];
    _orderCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(36, 11, 120, 20)];
    _orderCountLabel.font = [UIFont systemFontOfSize:14];
    _orderCountLabel.textColor = [BBSColor hexStringToColor:@"333333"];
    [self.moneyBackView addSubview:_orderCountLabel];
    
    UIImageView *imgMoney = [[UIImageView alloc]initWithFrame:CGRectMake(156, 12, 16, 17)];
    imgMoney.image = [UIImage imageNamed:@"order_money_count"];
    [self.moneyBackView addSubview:imgMoney];
    
    
    _orderMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(180, 12, 140, 20)];
    _orderMoneyLabel.font = [UIFont systemFontOfSize:14];
    _orderMoneyLabel.textColor = [BBSColor hexStringToColor:@"333333"];
    [self.moneyBackView addSubview:_orderMoneyLabel];
    self.moneyBackView.hidden = YES;

    
}
#pragma mark  点击上面订单类型
-(void)orderType:(UIButton*)sender{
    UIButton *button = (UIButton*)sender;
    
    UIButton *button0 = (UIButton*)[self.view viewWithTag:900];
    UIButton *button1 = (UIButton*)[self.view viewWithTag:901];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:902];
    UIButton *button3 = (UIButton*)[self.view viewWithTag:903];
    UIButton *button4 = (UIButton*)[self.view viewWithTag:904];
    //全部
    if (button.tag == 900) {
        button0.selected = NO;
        button1.selected = NO;
        button2.selected = NO;
        button3.selected = NO;
        button4.selected = NO;
        self.OrderStatus = 0;
        [self buttonActionGetData];
        
    }else if (button.tag == 901){//未支付
        button0.selected =YES;
        button1.selected =YES;
        button2.selected = NO;
        button3.selected = NO;
        button4.selected = NO;
        self.OrderStatus = 2;
        [self buttonActionGetData];
        
    }else if (button.tag == 902){//未消费
        button0.selected = YES;
        button1.selected =NO;
        button2.selected = YES;
        button3.selected = NO;
        button4.selected = NO;
        self.OrderStatus = 1;
        [self buttonActionGetData];
        
        
    }else if (button.tag == 903){//已完成
        button0.selected = YES;
        button1.selected = NO;
        button2.selected = NO;
        button3.selected = YES;
        button4.selected = NO;
        self.OrderStatus = 3;
        [self buttonActionGetData];
    }else if (button.tag == 904){//明细
        button0.selected = YES;
        button1.selected = NO;
        button2.selected = NO;
        button3.selected = NO;
        button4.selected = YES;
        self.selectBackView.hidden = NO;
        self.moneyBackView.hidden = NO;
        [self.view bringSubviewToFront:self.selectBackView];

    }
}
#pragma mark 前四个按钮事件
-(void)buttonActionGetData{
    self.isRefresh=YES;
    self.isFinished=NO;
    self.isGetMore=NO;
    self.post_create_time=NULL;
    self.selectBackView.hidden = YES;
    _isBottom = YES;
    _phoneLabel.frame = CGRectMake(0, SCREENHEIGHT-25, SCREENWIDTH, 25);
    self.moneyBackView.hidden = YES;
    self.searchId = NULL;
    [self getDataOrderList];

}

-(void)setTableView{
    
    CGRect tableviewFrame=CGRectMake(0, 151, SCREENWIDTH, SCREENHEIGHT-101);
    _tableView=[[UITableView alloc]initWithFrame:tableviewFrame];
    _tableView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    
    [self.view addSubview:_tableView];
    [self getDataOrderList];
    //直接就先把筛选的数据加载出来
    [self getSelectData];
    __weak StoreOrdersViewController *myOderList=self;
    [_tableView addPullToRefreshWithActionHandler:^{
        myOderList.VerificationTF.text = nil;
        myOderList.isRefresh=YES;
        myOderList.isFinished=NO;
        myOderList.isGetMore=NO;
        myOderList.post_create_time=NULL;
        [myOderList getDataOrderList];
        
    }];
    [_tableView addInfiniteScrollingWithActionHandler:^{
        if (!myOderList.isFinished) {
            if (myOderList.tableView.pullToRefreshView.state==SVInfiniteScrollingStateStopped) {
                [myOderList getDataOrderList];
            }
        }else{
            if (myOderList.tableView.infiniteScrollingView && myOderList.tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
                [myOderList.tableView.infiniteScrollingView stopAnimating];
            }
            
        }
        
    }];
    
}
-(void)pushVeriVC{
    [_VerificationTF resignFirstResponder];
    NSString *verification = _VerificationTF.text;
    NSString *loginUserId=LOGIN_USER_ID;

    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"login_user_id",verification,@"verification", nil];
    _sureBtn.enabled = NO;

    [[HTTPClient sharedClient]getNew:kSearchVerification params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            
            NSDictionary *data = result[@"data"];
            VerficationVC *verficationVC = [[VerficationVC alloc]init];
            verficationVC.orderIdVeri = data[@"order_id"];
            verficationVC.orderNumVeri = data[@"order_num"];
            verficationVC.verificationVeri = data[@"verification"];
            verficationVC.priceVeri = data[@"price"];
            verficationVC.businessPackageVeri = data[@"business_package"];
            verficationVC.refreshInStoreVC = ^(){
                _VerificationTF.text = nil;
                _isRefresh=YES;
                _isFinished=NO;
                _isGetMore=NO;
                _post_create_time=NULL;
                [BBSAlert showAlertWithContent:@"订单验证成功" andDelegate:nil];
                
                [self getDataOrderList];

            };
            [self.navigationController pushViewController:verficationVC animated:YES];
            
            
        }else{

            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
            _sureBtn.enabled = YES;
        }
        
    } failed:^(NSError *error) {
        _sureBtn.enabled = YES;
        
    }];
    
    
}
- (void)addEmptyHintView {
    
    if (_emptyView) {
        return;
    }
    _emptyView=[[UIView alloc]initWithFrame:CGRectMake(0, 151, SCREENWIDTH, SCREENHEIGHT)];
    _emptyView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
     _emptyView.frame = CGRectMake(0, 101, SCREENWIDTH, SCREENHEIGHT-101-25);
    
    UIImage *image=[UIImage imageNamed:@"img_no_storeorder"];
    UIImageView *imgView=[[UIImageView alloc]initWithImage:image];
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    imgView.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-101-25);
    [_emptyView addSubview:imgView];
    
    UIButton *moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    moreButton.frame = CGRectMake(0, 0,  SCREENWIDTH, SCREENHEIGHT-101-25);
    [moreButton addTarget:self action:@selector(pushStoreList) forControlEvents:UIControlEventTouchUpInside];
    [_emptyView addSubview:moreButton];
    [self.view addSubview:_emptyView];
    
}
//查看更多优惠跳转商家列表
-(void)pushStoreList{
    //商家列表
    BBSTabBarViewController *tabVC = [[BBSTabBarViewController alloc]init];
    theAppDelegate.window.rootViewController = tabVC;
    [tabVC setBBStabbarSelectedIndex:1];
    tabVC.selectedIndex = 1;
}

#pragma mark data
-(void)getDataOrderList{
    NSString *loginUserId=[NSString stringWithFormat:@"%@",LOGIN_USER_ID];
    NetAccess *net = [NetAccess sharedNetAccess];
    if (self.searchId) {
    }else{
        self.searchId = @"";
    }

    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"login_user_id",[NSString stringWithFormat:@"%ld",(long)self.OrderStatus],@"status",self.searchId,@"search_id",self.post_create_time,@"post_create_time", nil];
    [net getDataWithStyle:NetStyleBusinessOrderList andParam:paramDic];
    [LoadingView startOnTheViewController:self];
}
#pragma mark 筛选数据
-(void)getSelectData{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    [[HTTPClient sharedClient]getNewV1:kSearchCompletedOrder params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            self.orderSelectArray = [result objectForKey:@"data"];
            
            float floatRow = self.orderSelectArray.count/4;
            int row = ceil(floatRow);
            self.selectBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 101, SCREENWIDTH, SCREENHEIGHT)];
            self.selectBackView.backgroundColor = [BBSColor hexStringToColor:@"d1d1d1" alpha:0.7];
            [self.view addSubview:self.selectBackView];
            //回收页面的手势
            self.selectBackView.userInteractionEnabled = YES;
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
            [self.selectBackView addGestureRecognizer:singleTap];
            
            self.selectBackView.hidden = YES;
            
            UIView *selectBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,  20+(23+15)*row+23+20)];
            selectBtnView.backgroundColor = [UIColor whiteColor];
            [self.selectBackView addSubview:selectBtnView];
            
            for (int i = 0; i < self.orderSelectArray.count; i++) {
                NSDictionary *orderDic = self.orderSelectArray[i];
                NSString *searchTime = orderDic[@"search_time"];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.tag = 600+i;
                float RowInI = i/4;
                int rowInI = ceil(RowInI);
                [button setBackgroundImage:[UIImage imageNamed:@"order_btn_back"] forState:UIControlStateNormal];
                button.frame = CGRectMake(13+i%4*16+i%4*61, 20+(23+15)*rowInI, 61, 23);
                [selectBtnView addSubview:button];
                [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
                button.titleLabel.font = [UIFont systemFontOfSize:10];
                [button setTitle:searchTime forState:UIControlStateNormal];
                [button addTarget:self action:@selector(orderData:) forControlEvents:UIControlEventTouchUpInside];
            }
        }else{
            
        }
    } failed:^(NSError *error) {
        
    }];
}
#pragma mark 筛选页面上面button的事件
-(void)orderData:(UIButton*)sender{
    
    UIButton *button = (UIButton*)sender;
    NSDictionary *orderDetail = self.orderSelectArray[button.tag-600];
    NSString *orderCount = orderDetail[@"order_count"];
    NSString *orderTotalPrice = orderDetail[@"order_total_price"];
    self.searchId = orderDetail[@"search_id"];
    self.selectBackView.hidden = YES;
    self.isRefresh=YES;
    self.isFinished=NO;
    self.isGetMore=NO;
    self.post_create_time=NULL;
    _isBottom = NO;
    _orderCountLabel.text = [NSString stringWithFormat:@"订单数量：%@",orderCount];
     _orderMoneyLabel.text = [NSString stringWithFormat:@"总金额：%@",orderTotalPrice];
    self.moneyBackView.hidden = NO;
    [self getDataOrderList];
       _phoneLabel.frame = CGRectMake(0, SCREENHEIGHT-44-25, SCREENWIDTH, 25);

}
-(void)tapAction{
    self.selectBackView.hidden = YES;
    UIButton *button0 = (UIButton*)[self.view viewWithTag:900];
    UIButton *button1 = (UIButton*)[self.view viewWithTag:901];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:902];
    UIButton *button3 = (UIButton*)[self.view viewWithTag:903];
    UIButton *button4 = (UIButton*)[self.view viewWithTag:904];

    if (self.OrderStatus == 0) {
        button0.selected = NO;
        button1.selected = NO;
        button2.selected = NO;
        button3.selected = NO;
        button4.selected = NO;
        [self buttonActionGetData];

        
    }else if (self.OrderStatus == 1){
        button0.selected = YES;
        button1.selected =NO;
        button2.selected = YES;
        button3.selected = NO;
        button4.selected = NO;
        [self buttonActionGetData];
        
    }else if (self.OrderStatus == 2){
        button0.selected =YES;
        button1.selected =YES;
        button2.selected = NO;
        button3.selected = NO;
        button4.selected = NO;
        [self buttonActionGetData];
    }else if (self.OrderStatus == 3){
        button0.selected = YES;
        button1.selected = NO;
        button2.selected = NO;
        button3.selected = YES;
        button4.selected = NO;
        [self buttonActionGetData];
        
    }else{
        
    }
}
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = [NSString stringWithFormat:@"STOREMORELIST"];
    StoreOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[StoreOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    StoreOrdersItem *item = [_dataArray objectAtIndex:indexPath.row];
    cell.labelOrderNUmbers.text = item.orderNum;
    cell.labelPrice.text = item.price;
    if ([item.status isEqualToString:@"1"]) {
        cell.labelOrderState.text = @"未消费";
        cell.labelSureCode.text = @"验证码：";

    }else if([item.status isEqualToString:@"2"]){
        cell.labelOrderState.text = @"未支付";
        cell.labelSureCode.text = @"验证码：";

    }else if([item.status isEqualToString:@"3"]){
        cell.labelOrderState.text = @"已完成";
        cell.labelSureCode.text = @"验证时间：";
    }else if([item.status isEqualToString:@"4"]){
        cell.labelOrderState.text = @"退款中";
        cell.labelSureCode.text = @"验证码：";

    }else if([item.status isEqualToString:@"5"]){
        cell.labelOrderState.text = @"已退款";
        cell.labelSureCode.text = @"验证码：";

    }else if([item.status isEqualToString:@"6"]){
        cell.labelOrderState.text = @"待上门付款";
        cell.labelSureCode.text = @"验证码：";

    }
    cell.labelPriceCombine.text = [NSString stringWithFormat:@"%@",item.package_name];
    [cell.btnSureCode addTarget:self action:@selector(writeSureCode:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnSureCode.titleLabel.font = [UIFont systemFontOfSize:12];
    cell.btnSureCode.tag = indexPath.row;
    if (item.verification) {
        [cell.btnSureCode setTitle:[NSString stringWithFormat:@"%@",item.verification] forState:UIControlStateNormal];
        [cell.btnSureCode setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    }else{
        [cell.btnSureCode setTitle:@"" forState:UIControlStateNormal];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailViewController *storeDetailVC = [[OrderDetailViewController alloc]init];
    StoreOrdersItem *item = [_dataArray objectAtIndex:indexPath.row];
    storeDetailVC.order_id = item.order_id;
    storeDetailVC.isStore = YES;
    NSString *loginUserId=LOGIN_USER_ID;
    storeDetailVC.longin_user_id = loginUserId;
    [self.navigationController pushViewController:storeDetailVC animated:YES];

}
#pragma mark
//点击验证码btn
-(void)writeSureCode:(UIButton*)sender{
    [_VerificationTF resignFirstResponder];
    _indexPathSureCode = sender.tag;

    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"输入验证码" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"完成", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
}
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *nameTextField = [alertView textFieldAtIndex:0];
        NSString *textField = [nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *groupName = [textField stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        groupName = [groupName stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        StoreOrdersItem *item = [_dataArray objectAtIndex:_indexPathSureCode];
        if (groupName.length > 0) {
            _sureCode = groupName;
            UIButton *button = (UIButton *)[self.view viewWithTag:_indexPathSureCode];
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:_indexPathSureCode inSection:0];
            NSArray *array = [NSArray arrayWithObject:indexPath];
            [_tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
            NSString *loginUserId=[NSString stringWithFormat:@"%@",LOGIN_USER_ID];
            NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:_sureCode,@"verification",loginUserId,@"login_user_id",item.order_id,@"order_id" ,nil];
            [[HTTPClient sharedClient]getNew:kBusinessVerification params:paramDic success:^(NSDictionary *result) {
                if ([[result objectForKey:kBBSSuccess] integerValue] == 1) {
                   _isRefresh=YES;
                    _isFinished=NO;
                    _isGetMore=NO;
                    _post_create_time=NULL;
                    [self getDataOrderList];
                    
                }else{
                    //error
                    [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
                }

            } failed:^(NSError *error) {
                [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];

            }];
            
           // [[NetAccess sharedNetAccess]getDataWithStyle:NetStyleBusinessVerification andParam:paramDic];
        
        }
    }
}


#pragma mark 系统通知
-(void)getDataSucceed:(NSNotification *) note{
    
    NSString *styleString=note.object;
    NetAccess *net=[NetAccess sharedNetAccess];
    NSArray *returnArray=[net getReturnDataWithNetStyle:[styleString intValue]];
    
    if (returnArray.count == 0) {
        _isFinished = YES;
        
        [self showHUDWithMessage:@"已没有更多订单信息"];
        
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
        StoreOrdersItem *item = [returnArray lastObject];
        self.post_create_time = item.postCreatTime;
    }
    [LoadingView stopOnTheViewController:self];
    if (_dataArray.count == 0) {
        [self addEmptyHintView];
        _emptyView.hidden = NO;
    } else  if (_tableView) {
        _emptyView.hidden = YES;
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField == _VerificationTF) {
        if (_VerificationTF.text.length >= 9) {
            return NO;
        }
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
        _tableView.frame=CGRectMake(0, 141, SCREENWIDTH, SCREENHEIGHT-141);
        if (_isBottom == YES) {
            _phoneLabel.frame = CGRectMake(0,SCREENHEIGHT-25, SCREENWIDTH, 25);
        }else{
            _phoneLabel.frame = CGRectMake(0, SCREENHEIGHT-25-44, SCREENWIDTH, 25);
        }
        self.btnView.frame = CGRectMake(0, 64, SCREENHEIGHT, 77);
        
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
        [UIView commitAnimations];
    }
    //up
    if (point.y-scrollView.contentOffset.y<-40) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        if (_isBottom == YES) {
            _phoneLabel.frame = CGRectMake(0,SCREENHEIGHT-25, SCREENWIDTH, 25);
        }else{
            _phoneLabel.frame = CGRectMake(0, SCREENHEIGHT-25-44, SCREENWIDTH, 25);
        }

        _tableView.frame=CGRectMake(0, 77, SCREENWIDTH, SCREENHEIGHT-77);
        self.btnView.frame = CGRectMake(0, 20, SCREENWIDTH, 87);
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
