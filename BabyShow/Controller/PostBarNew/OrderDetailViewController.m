//
//  OrderDetailViewController.m
//  BabyShow
//
//  Created by WMY on 15/9/21.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "CommentOrderViewController.h"
#import "PayOrderNewVC.h"

@interface OrderDetailViewController ()
@property(nonatomic,strong)UIScrollView *bottomScrollView;
@property(nonatomic,strong)NSString *orderId;
@property(nonatomic,strong)NSString *package;
@property(nonatomic,strong)NSString *business_id;
@property(nonatomic,strong)NSString *payment;
@property(nonatomic,strong)UIButton *commentBtn;
@property(nonatomic,strong)UIView *grayView;
@property(nonatomic,strong)UIView *backUIView;
@property(nonatomic,strong)UIImageView *imgProject;
@property(nonatomic,strong)UILabel *labelProject;
@property(nonatomic,strong)UIView *grayView2;
@property(nonatomic,assign)BOOL isReturn;

@end

@implementation OrderDetailViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [self getDataDetail];

    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButton];
    _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,self.view.bounds.size.height)];
    _bottomScrollView.alwaysBounceVertical = YES;
    _bottomScrollView.backgroundColor = [BBSColor whiteColor];
    [self.view addSubview:_bottomScrollView];
    [self setViews];

    
    // Do any additional setup after loading the view.
}
#pragma mark UI
-(void)setLeftButton{
    
    //返回按钮
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 31)];
    imagev.image = [UIImage imageNamed:@"btn_back1.png"];
    [_backBtn addSubview:imagev];
    UILabel *cateName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 31)];
    cateName.textColor = [UIColor whiteColor];
    cateName.text = @"订单详情";
    [_backBtn addSubview:cateName];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
-(void)setViews{
    //商店图标
    self.imageStore = [[UIImageView alloc]initWithFrame:CGRectMake(15, 17, 16, 16)];
    self.imageStore.image = [UIImage imageNamed:@"img_order_store"];
    [_bottomScrollView addSubview:self.imageStore];
    
    //商店名字
    _labelStoreName = [[UILabel alloc]initWithFrame:CGRectMake(_imageStore.frame.origin.x+_imageStore.frame.size.width +7, _imageStore.frame.origin.y, 200, 15)];
    _labelStoreName.text = @"快乐每一天";
    _labelStoreName.font = [UIFont systemFontOfSize:12];
    [_bottomScrollView addSubview:_labelStoreName];
    
    //过期时间
    _labelTime = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-100, _labelStoreName.frame.origin.y, 88, 14)];
    _labelTime.font = [UIFont systemFontOfSize:11];
    _labelTime.textAlignment = NSTextAlignmentRight;
    _labelTime.textColor = [BBSColor hexStringToColor:@"666666"];
    _labelTime.text = @"2016-08-17过期";
    [_bottomScrollView addSubview:_labelTime];
    
    //地址图标
    _imageAddress = [[UIImageView alloc]initWithFrame:CGRectMake(self.imageStore.frame.origin.x, self.imageStore.frame.origin.y+self.imageStore.frame.size.height+17, 14, 19)];
    _imageAddress.image = [UIImage imageNamed:@"img_order_address"];
    [_bottomScrollView addSubview:_imageAddress];
    
    //地址
    _labelAddress = [[WMYLabel alloc]initWithFrame:CGRectMake(_labelStoreName.frame.origin.x, _imageAddress.frame.origin.y, 250, 30)];
    _labelAddress.numberOfLines = 2;
    _labelAddress.font = [UIFont systemFontOfSize:12];
    [_labelAddress setVerticalAlignment:VerticalAlignmentTop];
    [_bottomScrollView addSubview:_labelAddress];
    
    _imgProject = [[UIImageView alloc]initWithFrame:CGRectMake(self.imageStore.frame.origin.x, self.imageAddress.frame.origin.y+self.imageAddress.frame.size.height+17, 14, 19)];
    _imgProject.image = [UIImage imageNamed:@"img_store_package"];
    [_bottomScrollView addSubview:_imgProject];
    
    _labelProject = [[UILabel alloc]initWithFrame:CGRectMake(_labelStoreName.frame.origin.x, _imgProject.frame.origin.y, 250, 30)];
    _labelProject.numberOfLines = 0;
    _labelProject.font = [UIFont systemFontOfSize:12];
    [_bottomScrollView addSubview:_labelProject];
    
    _grayView=[[UIView alloc]initWithFrame:CGRectMake(0, _labelProject.frame.origin.y+_labelProject.frame.size.height+19, SCREENWIDTH, 21.5)];
    _grayView.backgroundColor = [BBSColor hexStringToColor:@"f9f9f9"];
    
    [_bottomScrollView addSubview:_grayView];
    
    _backUIView = [[UIView alloc]initWithFrame:CGRectMake(0, _grayView.frame.origin.y+_grayView.frame.size.height+10, SCREENWIDTH, 360)];
    [_bottomScrollView addSubview:_backUIView];
        NSMutableArray *dataArray = [NSMutableArray arrayWithObjects:@"订单号",@"验证码",@"下单时间",@"支付方式",@"套餐",@"红包",@"价格",@"数量",@"消费状态", nil];
    for (int i = 0; i < 9; i++) {
        
        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 12+40*i, 100, 13)];
        leftLabel.font = [UIFont systemFontOfSize:12];
        leftLabel.text = [NSString stringWithFormat:@"%@",dataArray[i]];
        [_backUIView addSubview:leftLabel];
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, leftLabel.frame.origin.y+13+15, SCREENWIDTH, 1)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"f9f9f9"];
        [_backUIView addSubview:lineView];
        
        UILabel *rightLabel  = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-120-4, leftLabel.frame.origin.y, 108, 13)];
        rightLabel.font = [UIFont systemFontOfSize:12];
        rightLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        rightLabel.tag = 300+i;
        [_backUIView addSubview:rightLabel];
        rightLabel.textAlignment = NSTextAlignmentRight;
        
    }

    _grayView2 =   [[UIView alloc]initWithFrame:CGRectMake(0, _grayView.frame.origin.y+_grayView.frame.size.height+360, SCREENWIDTH, _bottomScrollView.frame.size.height-_grayView.frame.origin.y+_grayView.frame.size.height+300)];
    
    _grayView2.backgroundColor = [BBSColor hexStringToColor:@"f9f9f9"];
    [_bottomScrollView addSubview:_grayView2];
   
    if (_isStore==YES) {
        
    }else{
    _btnReturnBackMoney = [UIButton buttonWithType:UIButtonTypeSystem];
    _btnReturnBackMoney.frame = CGRectMake(SCREENWIDTH-88, _backUIView.frame.origin.y+360+12, 71, 29);

    _btnReturnBackMoney.hidden = YES;
    [_bottomScrollView addSubview:_btnReturnBackMoney];
    [_btnReturnBackMoney setBackgroundImage:[UIImage imageNamed:@"btn_order_comment"] forState:UIControlStateNormal];

    }
    _bottomScrollView.contentSize =CGSizeMake(SCREENWIDTH, SCREENHEIGHT+100);
    
}
-(void)getDataDetail
{
    [LoadingView startOnTheViewController:self];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.order_id,@"order_id", nil];
    [[HTTPClient sharedClient]getNewV1:kOrderDetailV1 params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            [LoadingView stopOnTheViewController:self];
            NSDictionary *dataDic = result[@"data"];
            _orderId = dataDic[@"order_id"];
            _labelStoreName.text = dataDic[@"business_title"];
            _labelTime.text = dataDic[@"business_time"];
            _labelAddress.text = dataDic[@"address"];
            _business_id = dataDic[@"business_id"];
            _labelProject.text = dataDic[@"business_package"];
            NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
            CGSize textsize = [_labelProject.text boundingRectWithSize:CGSizeMake(250, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            _labelProject.frame = CGRectMake(_labelStoreName.frame.origin.x, self.labelProject.frame.origin.y, 250, textsize.height);
            _grayView.frame = CGRectMake(0, _labelProject.frame.origin.y+_labelProject.frame.size.height+19, SCREENWIDTH, 21.5);
            _backUIView.frame = CGRectMake(0, _grayView.frame.origin.y+_grayView.frame.size.height+10, SCREENWIDTH, 320+40);
            _grayView2.frame = CGRectMake(0, _grayView.frame.origin.y+_grayView.frame.size.height+360+10, SCREENWIDTH, _bottomScrollView.frame.size.height-_grayView.frame.origin.y+_grayView.frame.size.height+200);
            _btnReturnBackMoney.frame = CGRectMake(SCREENWIDTH-88, _backUIView.frame.origin.y+360+12, 71, 29);
            _bottomScrollView.contentSize =CGSizeMake(SCREENWIDTH, _grayView2.frame.origin.y+150);
            
            NSString *order_Num;
            if (dataDic[@"order_num"]) {
                order_Num = dataDic[@"order_num"];
            }else{
                order_Num = @"";
            }
            NSString *verification;
            if (_isStore) {
                verification = @"";
            }else{
                verification = dataDic[@"verification"];
            }
            NSString *order_time = dataDic[@"order_time"];
            _payment = dataDic[@"payment_name"];
            
            NSString *payMenth = _payment;
            NSString *packet_price = dataDic[@"packet_price"];
            _package = dataDic[@"package"];
            NSString *packageNumber = dataDic[@"package_name"];
            NSString *price = dataDic[@"price"];
            NSString *priceLabel = [NSString stringWithFormat:@"¥%@",price];
            NSString *number = dataDic[@"number"];
            NSNumber *checkComment= dataDic[@"check_comment"];
            NSInteger check = [checkComment integerValue];
            
            NSString *status = dataDic[@"status"];
            NSString *statuss;
            if ([status isEqualToString:@"1"]) {
                statuss = @"未消费";
                if ([_payment isEqualToString:@"5"]) {
                    _btnReturnBackMoney.hidden = YES;
                }else{
                    _btnReturnBackMoney.hidden = NO;
                    [_btnReturnBackMoney setBackgroundImage:[UIImage imageNamed:@"btn_order_returnMoney"] forState:UIControlStateNormal];
                    [_btnReturnBackMoney addTarget:self action:@selector(alertShow) forControlEvents:UIControlEventTouchUpInside];
                }
                
            }else if ([status isEqualToString:@"2"]) {
                statuss = @"未支付";
                _btnReturnBackMoney.hidden = NO;
                [_btnReturnBackMoney setBackgroundImage:[UIImage imageNamed:@"btn_order_pay"] forState:UIControlStateNormal];
                [_btnReturnBackMoney addTarget:self action:@selector(goToPay) forControlEvents:UIControlEventTouchUpInside];
                
            }else if ([status isEqualToString:@"3"]) {
                statuss = @"已完成";
                if (check == 0) {
                    _btnReturnBackMoney.hidden = NO;
                    [_btnReturnBackMoney setBackgroundImage:[UIImage imageNamed:@"btn_order_comment"] forState:UIControlStateNormal];
                    [_btnReturnBackMoney addTarget:self action:@selector(goToComment) forControlEvents:UIControlEventTouchUpInside];
                }else{
                    _btnReturnBackMoney.hidden = YES;
                }
            }else if ([status isEqualToString:@"4"]) {
                _btnReturnBackMoney.hidden = YES;
                statuss = @"退款中";
            }else if ([status isEqualToString:@"5"]) {
                _btnReturnBackMoney.hidden = YES;
                statuss = @"已退款";
            }else if ([status isEqualToString:@"6"]){
                statuss = @"待上门付款";
                _btnReturnBackMoney.hidden = YES;
            }
            
            NSMutableArray *dataArray = [NSMutableArray arrayWithObjects:order_Num,verification,order_time,payMenth,packageNumber,packet_price,priceLabel ,number,statuss, nil];
            for (int i=0; i < 9; i++) {
                UILabel *rightLabel = (UILabel *)[_bottomScrollView viewWithTag:300+i];
                rightLabel.text = dataArray[i];
            }
            
        }

     } failed:^(NSError *error) {
         [LoadingView stopOnTheViewController:self];
         
         [BBSAlert showAlertWithContent:@"网络连接错误请重试" andDelegate:nil];
     }];
    }
-(void)goToPay{
    PayOrderNewVC *payOrder = [[PayOrderNewVC alloc]init];
    payOrder.longin_user_id = self.longin_user_id;
    payOrder.business_id = self.business_id;
    payOrder.priceCombine = _package;
    //payOrder.order_id = _order_id;
    [self.navigationController pushViewController:payOrder animated:YES];
}
-(void)goToComment{
    CommentOrderViewController *commentVC = [[CommentOrderViewController alloc]init];
    commentVC.business_id = self.business_id;
    commentVC.order_id = _order_id;
    [self.navigationController pushViewController:commentVC animated:YES];
    
}
-(void)alertShow{
//    if ([_payment isEqualToString:@"1"]) {
    
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"退款将于1~3个工作日退回您的账户" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认退款", nil];
        [alert show];
    

//    }
//    else if([_payment isEqualToString:@"2"]){
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"联系客服退款" message:@"电话：010-82865072\nQ Q：3087914135" delegate:self cancelButtonTitle:@"知道啦" otherButtonTitles:nil, nil];
//        [alert show];
//    }
}
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.order_id,@"order_id", nil];
        [[HTTPClient sharedClient]getNew:kRefundOrder params:params success:^(NSDictionary *result) {
            if ([[result objectForKey:kBBSSuccess]integerValue]==1) {
                [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
                [self getDataDetail];
                _isReturn = YES;
            }
        } failed:^(NSError *error) {
            [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
            
        }];
        

    }
}
-(void)goToReturnBackMoney{
}
-(void)back{
    if (_isReturn == YES) {
        self.refreshInOrderList(nil);
    }
    [self.navigationController popViewControllerAnimated:YES];
    
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
