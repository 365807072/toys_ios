//
//  MyOrdersViewController.m
//  BabyShow
//
//  Created by WMY on 15/9/16.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyOrdersViewController.h"
#import "MyOrderCell.h"
#import "OrderDetailViewController.h"
#import "SVPullToRefresh.h"
#import "MyOrdersItem.h"

#import "StoreMoreListVC.h"
#import "ShowAlertView.h"
#import "StoreDetailNewVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>

@interface MyOrdersViewController ()
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
@property(nonatomic,strong)UILabel *phoneLabel;
@property(nonatomic,strong)UIButton *sendRedBagBtn;
@property(nonatomic,strong)NSString *orderId;//分享红包的id
@property(nonatomic,strong)NSString *packDescripition;
@property(nonatomic,strong)UIView *grayView;
@property(nonatomic,strong)UIButton *sendRedBagButton;//发放红包
@property(nonatomic,strong)UIButton *cancelBtn;//取消发放
@property(nonatomic,assign)NSInteger OrderStatus;//订单状态
@property(nonatomic,strong)UIView *btnView;
@property(nonatomic,strong)NSString *packet_title;//红包主标题
@property(nonatomic,strong)NSString *phoneString;//拨打电话


@end

@implementation MyOrdersViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil//1
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray=[NSMutableArray array];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{//1
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_ORDER_MYORDER_GETMYORDERLIST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_ORDER_MYORDER_GETMYORDERLIST_FAIL object:nil];
    //网络错误
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    self.tabBarController.tabBar.hidden = YES;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.OrderStatus = 0;
    
    [self setLeftButton];
    [self setTableView];
    [self setPhoneNumberTrip];
    [self setSendRedBagBtn];
    [self isHavePacket];
    
    
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
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
        [_backBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        
    }
}
#pragma mark 推送过来的时候的返回按钮
-(void)dismissVC{
    NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:@""forKey:@"push"];
    [pushJudge synchronize];//记得立即同步
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)setSendRedBagBtn{
    _sendRedBagBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sendRedBagBtn.frame = CGRectMake(SCREENWIDTH-60, SCREENHEIGHT-40-64, 48, 51);
    [_sendRedBagBtn setBackgroundImage:[UIImage imageNamed:@"img_myorders_redbag@2x"] forState:UIControlStateNormal];
    [self.view addSubview:_sendRedBagBtn];
    _sendRedBagBtn.hidden = YES;
    
}
-(void)setPhoneNumberTrip{
    _phoneLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-25, SCREENWIDTH, 25)];
    _phoneLabel.text = @"有任何问题，请联系自由环球租赁";
    _phoneLabel.font = [UIFont systemFontOfSize:12];
    _phoneLabel.textAlignment = NSTextAlignmentCenter;
    _phoneLabel.backgroundColor = [BBSColor hexStringToColor:@"000000" alpha:0.5];
    _phoneLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:_phoneLabel];
    
    self.btnView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 37)];
    self.btnView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.btnView];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 36, SCREENWIDTH, 1)];
    lineView.backgroundColor = [BBSColor hexStringToColor:@"eeeeee"];
    [self.btnView addSubview:lineView];
    
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20+i*25+(SCREENWIDTH-20*2-25*3)/4*i, 5, (SCREENWIDTH-20*2-25*3)/4, 26);
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
    
    
}
-(void)orderType:(UIButton*)sender{
    UIButton *button = (UIButton*)sender;
    
    UIButton *button0 = (UIButton*)[self.view viewWithTag:900];
    UIButton *button1 = (UIButton*)[self.view viewWithTag:901];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:902];
    UIButton *button3 = (UIButton*)[self.view viewWithTag:903];
    
    if (button.tag == 900) {
        button0.selected = NO;
        button1.selected = NO;
        button2.selected = NO;
        button3.selected = NO;
        self.OrderStatus = 0;
        
    }else if (button.tag == 901){
        button0.selected =YES;
        button1.selected =YES;
        button2.selected = NO;
        button3.selected = NO;
        self.OrderStatus = 2;
        
        
    }else if (button.tag == 902){
        button0.selected = YES;
        button1.selected =NO;
        button2.selected = YES;
        button3.selected = NO;
        self.OrderStatus = 1;
        
        
    }else if (button.tag == 903){
        button0.selected = YES;
        button1.selected = NO;
        button2.selected = NO;
        button3.selected = YES;
        self.OrderStatus = 3;
        
        
    }
    self.isRefresh=YES;
    self.isFinished=NO;
    self.isGetMore=NO;
    self.post_create_time=NULL;
    [self getDataOrderList];
    
    
}
-(void)setTableView{
    
    CGRect tableviewFrame=CGRectMake(0, 101, SCREENWIDTH, SCREENHEIGHT-101);
    _tableView=[[UITableView alloc]initWithFrame:tableviewFrame];
    _tableView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
    [LoadingView startOnTheViewController:self];
    [self performSelector:@selector(getDataOrderList) withObject:nil afterDelay:3.0];
    //[self getDataOrderList];
    
    __weak MyOrdersViewController *myOderList=self;
    [_tableView addPullToRefreshWithActionHandler:^{
        myOderList.isRefresh=YES;
        myOderList.isFinished=NO;
        myOderList.isGetMore=NO;
        myOderList.post_create_time=NULL;
        [myOderList getDataOrderList];
        [myOderList isHavePacket];
        
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
- (void)addEmptyHintView {
    
    if (_emptyView) {
        return;
    }
    _emptyView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
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
#pragma mark data
//检测是否有可以发的红包
-(void)isHavePacket{
    NSString *loginUserId=[NSString stringWithFormat:@"%@",LOGIN_USER_ID];
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"login_user_id", nil];
    [[HTTPClient sharedClient]getNew:kCheckPacket params:param success:^(NSDictionary *result) {
        NSDictionary *data = result[@"data"];
        if ([data[@"check_packet"]boolValue] == YES) {
            if ([_fromPayOrder isEqualToString:@"fromPayOrder"]) {
                //发红包的控件
                //蒙版
                _grayView = [[UIView  alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENHEIGHT)];
                _grayView.backgroundColor = [BBSColor hexStringToColor:@"000000" alpha:0.3];
                [self.view addSubview:_grayView];
                //确认分享红包按钮
                _sendRedBagButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_sendRedBagButton setBackgroundImage:[UIImage imageNamed:@"btn_myorder_redbag@2x"] forState:UIControlStateNormal];
                _sendRedBagButton.frame = CGRectMake(10, SCREENHEIGHT-223, SCREENWIDTH-20, 167);
                [_grayView addSubview:_sendRedBagButton];
                [_sendRedBagButton addTarget:self action:@selector(sendRedPacket) forControlEvents:UIControlEventTouchUpInside];
                
                //取消发红包
                _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                _cancelBtn.frame = CGRectMake(10, SCREENHEIGHT-48, SCREENWIDTH-20, 39);
                _cancelBtn.backgroundColor = [UIColor whiteColor];
                [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
                [_cancelBtn setTitleColor:[BBSColor hexStringToColor:@"3a97ff"] forState:UIControlStateNormal];
                [_cancelBtn addTarget:self action:@selector(cancelSendRedBag) forControlEvents:UIControlEventTouchUpInside];
                [_grayView addSubview:_cancelBtn];
            }
            _sendRedBagBtn.hidden = NO;
            _orderId = data[@"order_id"];
            _packDescripition = data[@"packet_description"];
            _packet_title = data[@"packet_title"];
            [_sendRedBagBtn addTarget:self action:@selector(sendRedPacket) forControlEvents:UIControlEventTouchUpInside];
            
        }else{
            _sendRedBagBtn.hidden = YES;
        }
        
        
    } failed:^(NSError *error) {
        
    }];
    
}
-(void)getDataOrderList{
    
    NSString *loginUserId=LOGIN_USER_ID;
    NetAccess *net = [NetAccess sharedNetAccess];
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"login_user_id",[NSString stringWithFormat:@"%ld",(long)self.OrderStatus ],@"status",self.post_create_time,@"post_create_time", nil];
    
    [net getDataWithStyle:NetStyleUserOrderList andParam:paramDic];
    
}
-(void)back{
#define theAppDelegate    ((AppDelegate*)[[UIApplication sharedApplication] delegate])
    if ([_fromPayOrder isEqualToString:@"fromPayOrder"]) {
        BBSTabBarViewController *tabVc = [[BBSTabBarViewController alloc]init];
        tabVc.selectedIndex = 3;
        theAppDelegate.window.rootViewController =tabVc;
        [tabVc setBBStabbarSelectedIndex:3];
        
    }else{
    [self.navigationController popViewControllerAnimated:YES];
    }
}
#pragma mark  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 104+33;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = [NSString stringWithFormat:@"STOREMORELIST"];
    MyOrderCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[MyOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    MyOrdersItem *item = [_dataArray objectAtIndex:indexPath.row];
    [cell.buttonToStore setTitle:[NSString stringWithFormat:@"%@",item.businessTitle] forState:UIControlStateNormal];

    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13]};
    CGSize nickSize = [item.businessTitle sizeWithAttributes:attributes];
    
    cell.buttonToStore.frame = CGRectMake(35, 10, nickSize.width+10, 15);
    cell.buttonToStore.tag = indexPath.row;
    [cell.buttonToStore addTarget:self action:@selector(pushDetailStore:) forControlEvents:UIControlEventTouchUpInside];
    cell.labelOrderNUmbers.text = item.orderNum;
    cell.arrowImg.frame = CGRectMake(35+nickSize.width+10, 13, 7, 10);
    //拨打电话
    NSString *phoneString = [NSString stringWithFormat:@"拨打商家电话：%@",item.business_contact];
    [cell.buttonPhoneNumber setTitle:[NSString stringWithFormat:@"%@",phoneString] forState:UIControlStateNormal];
    CGSize phoneSize = [phoneString sizeWithAttributes:attributes];
    //15, 10+33, 300, 15
    cell.buttonPhoneNumber.frame = CGRectMake(15, 33+10, phoneSize.width+30, 15);
    cell.arrayImgPhone.frame = CGRectMake(15+phoneSize.width+10, 33+12, 7, 10);
    
    cell.arrayImgPhone.userInteractionEnabled = YES;
    cell.buttonPhoneNumber.tag = indexPath.row;
    [cell.buttonPhoneNumber addTarget:self action:@selector(callPhoneNumber:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([item.status isEqualToString:@"1"]) {
        cell.labelOrderState.text = @"未消费";
    }else if([item.status isEqualToString:@"2"]){
        cell.labelOrderState.text = @"未支付";
    }else if([item.status isEqualToString:@"3"]){
        cell.labelOrderState.text = @"已完成";
    }else if([item.status isEqualToString:@"4"]){
        cell.labelOrderState.text = @"退款中";
    }else if([item.status isEqualToString:@"5"]){
        cell.labelOrderState.text = @"已退款";
    }else if ([item.status isEqualToString:@"6"]){
        cell.labelOrderState.text = @"待上门付款";
    }
    if ([item.order_role isEqualToString:@"1"]) {
        cell.labelSureCode.frame = CGRectMake(cell.labelOrderNumber.frame.origin.x, cell.labelOrderNumber.frame.origin.y+10+cell.labelOrderNumber.frame.size.height, 240, 15);
        cell.labelSureCode.text = @"一经对方同意，即刻开通同步权限";
        cell.labelNumberCode.hidden = YES;
        cell.imgPriceCombine.hidden = YES;
        cell.labelPriceCombine.hidden = YES;
        
    }else{
        cell.labelSureCode.frame = CGRectMake(cell.labelOrderNumber.frame.origin.x, cell.labelOrderNumber.frame.origin.y+10+cell.labelOrderNumber.frame.size.height, 70, 15);
        if ([item.status isEqualToString:@"1"]) {
            cell.labelSureCode.text = @"验证码：";
            cell.labelOrderState.text = @"未消费";

        }else if([item.status isEqualToString:@"2"]){
            cell.labelSureCode.text = @"验证码：";
            cell.labelOrderState.text = @"未支付";
        }else if([item.status isEqualToString:@"3"]){
            cell.labelSureCode.text = @"验证时间：";
            cell.labelOrderState.text = @"已完成";
        }else if([item.status isEqualToString:@"4"]){
            cell.labelSureCode.text = @"验证码：";
            cell.labelOrderState.text = @"退款中";
        }else if([item.status isEqualToString:@"5"]){
            cell.labelSureCode.text = @"验证码：";
            cell.labelOrderState.text = @"已退款";
        }else if ([item.status isEqualToString:@"6"]){
            cell.labelSureCode.text = @"验证码：";
            cell.labelOrderState.text = @"待上门付款";
        }

        cell.labelNumberCode.hidden = NO;
        cell.imgPriceCombine.hidden = NO;
        cell.labelPriceCombine.hidden = NO;
        cell.labelNumberCode.text = item.verification;
        cell.labelPriceCombine.text = [NSString stringWithFormat:@"%@",item.package_name];
    }
    cell.labelPrice.text = item.price;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    OrderDetailViewController *storeDetailVC = [[OrderDetailViewController alloc]init];
    MyOrdersItem *item = [_dataArray objectAtIndex:indexPath.row];
    if ([item.order_role isEqualToString:@"1"]) {
        
    }else{
        storeDetailVC.order_id = item.order_id;
        NSString *loginUserId=[NSString stringWithFormat:@"%@",LOGIN_USER_ID];
        storeDetailVC.longin_user_id = loginUserId;
        storeDetailVC.refreshInOrderList = ^{
            _isRefresh=YES;
            _isFinished=NO;
            _isGetMore=NO;
            _post_create_time=NULL;
            [self getDataOrderList];
            [self isHavePacket];
            
        };
        [self.navigationController pushViewController:storeDetailVC animated:YES];
        
    }
}
#pragma mark 直接拨打电话
-(void)callPhoneNumber:(UIButton*)sender{
    MyOrdersItem *item = [_dataArray objectAtIndex:sender.tag];
    NSString *telephone = [NSString stringWithFormat:@"确认拨打%@",item.business_contact];
    _phoneString = item.business_contact;
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:telephone delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拨打", nil];
    [alert show];
}
#pragma mark alerviewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

        if (buttonIndex == 1) {
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",_phoneString]]];
        }
}

#pragma mark跳转到商家详情
-(void)pushDetailStore:(UIButton *)sender{
    
    MyOrdersItem *item = [_dataArray objectAtIndex:sender.tag];
    StoreDetailNewVC *storeDetail = [[StoreDetailNewVC alloc]init];
    NSString *loginUserId=[NSString stringWithFormat:@"%@",LOGIN_USER_ID];
    storeDetail.longin_user_id =loginUserId;
    storeDetail.business_id = item.businessId;
    [self.navigationController pushViewController:storeDetail animated:YES];
}
//查看更多优惠跳转商家列表
-(void)pushStoreList{
    //商家列表
    BBSTabBarViewController *tabVC = [[BBSTabBarViewController alloc]init];
    theAppDelegate.window.rootViewController = tabVC;
    [tabVC setBBStabbarSelectedIndex:0];
    tabVC.selectedIndex = 0;
}
-(void)cancelSendRedBag{
    [_grayView removeFromSuperview];
    _sendRedBagButton.hidden = YES;
}
//分享红包给朋友
-(void)sendRedPacket{
    NSString *urlString = [NSString stringWithFormat:@"%@user_id=%@&order_id=%@",kRedPacketShare,LOGIN_USER_ID,_orderId];
    NSString *content = _packDescripition;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_orderId,@"order_id",@"1",@"share_state", nil];
    
    [[HTTPClient sharedClient]getNewV1:kOrderShareState params:params success:^(NSDictionary *result) {
        
    } failed:^(NSError *error) {
        
    }];
    __weak MyOrdersViewController *myStoreVC = self;
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",kRedImg]];
    UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
    
    NSArray* imageArray = @[shareImg];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]
                                      title:_packet_title
                                       type:SSDKContentTypeAuto];
    
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",content,[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:_packet_title image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
    //分享
    [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateBegin:
            {
                //  [storeVC showLoadingView:YES];
                break;
            }
            case SSDKResponseStateSuccess:
            {
                //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
                //分享成功后回来
                
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
                break;
            }
            case SSDKResponseStateCancel:
            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
                break;
            }
                
            default:
                break;
        }
    }];
    
    
    
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
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
        _emptyView.hidden = YES;
        
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
        MyOrdersItem *item = [returnArray lastObject];
        self.post_create_time = item.postCreatTime;
    }
    [LoadingView stopOnTheViewController:self];
    if (_dataArray.count == 0) {
        [self addEmptyHintView];
        _emptyView.hidden = NO;
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
    
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state == 2) {
        [_tableView.infiniteScrollingView stopAnimating];
        
    }
    
    [LoadingView stopOnTheViewController:self];
    
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
        _tableView.frame=CGRectMake(0, 101, SCREENWIDTH, SCREENHEIGHT-101);
        _phoneLabel.frame = CGRectMake(0, SCREENHEIGHT-25, SCREENWIDTH, 25);
        self.btnView.frame = CGRectMake(0, 64, SCREENWIDTH, 37);
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
        [UIView commitAnimations];
    }
    //up
    if (point.y-scrollView.contentOffset.y<-40) {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [self.navigationController setNavigationBarHidden:YES animated:YES];
        _phoneLabel.frame = CGRectMake(0, SCREENHEIGHT-25, SCREENWIDTH, 25);
        _tableView.frame=CGRectMake(0, 57, SCREENWIDTH, SCREENHEIGHT-57);
        self.btnView.frame = CGRectMake(0, 20, SCREENWIDTH, 37);
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
