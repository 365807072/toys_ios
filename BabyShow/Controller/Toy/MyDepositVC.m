//
//  MyDepositVC.m
//  BabyShow
//
//  Created by WMY on 17/1/6.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyDepositVC.h"
#import "MyDepositDetailListVC.h"
#import "WMYLabel.h"
#import "NIAttributedLabel.h"

@interface MyDepositVC ()
@property(nonatomic,strong)UIScrollView *backScrollview;
@property(nonatomic,strong)UIView *backView;

@property(nonatomic,strong)UILabel *labelTitle;
@property(nonatomic,strong)UILabel *labelMoney;
@property(nonatomic,strong)UILabel *labelDetail;
@property(nonatomic,strong)UIButton *btnDetail;
@property(nonatomic,strong)UIButton *btnSurePay;
@property(nonatomic,strong)NSString *status;


@end

@implementation MyDepositVC
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor blackColor]}];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [BBSColor hexStringToColor:NAVICOLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];

}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.navigationItem.title = @"我的押金";
    [self setBackBton];
    [self setSubview];
    [self getData];
    
    // Do any additional setup after loading the view.
}
-(void)setSubview{
    self.view.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    
    _backScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,SCREEN_HEIGHT-64)];
    
    _backScrollview.contentSize = CGSizeMake(SCREENWIDTH, SCREEN_HEIGHT);
    _backScrollview.alwaysBounceVertical = YES;
    [self.view addSubview:_backScrollview];
    //WithFrame:CGRectMake(0, 64, SCREENWIDTH, 130)];
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 130)];
    _backView.backgroundColor = [BBSColor hexStringToColor:@"f76363"];
    [_backScrollview addSubview:_backView];
    
        //可用押金
    self.labelTitle = [[UILabel alloc]initWithFrame:CGRectMake(20, 20, SCREENWIDTH-42, 20)];
    self.labelTitle.textColor = [UIColor whiteColor];
    self.labelTitle.font = [UIFont systemFontOfSize:15];
    [_backView addSubview:self.labelTitle];
    //具体钱数
    self.labelMoney = [[UILabel alloc]initWithFrame:CGRectMake(16, self.labelTitle.frame.origin.y+self.labelTitle.frame.size.height+5, SCREENWIDTH-42, 40)];
    self.labelMoney.textColor = [UIColor whiteColor];
    self.labelMoney.font = [UIFont systemFontOfSize:35];
    [_backView addSubview:self.labelMoney];
    //详细内容
    self.labelDetail = [[WMYLabel alloc]initWithFrame:CGRectMake(20, self.labelMoney.frame.origin.y+self.labelMoney.frame.size.height+10, SCREENWIDTH-42, 20)];
    self.labelDetail.numberOfLines = 0;
    self.labelDetail.textColor = [UIColor whiteColor];
    self.labelDetail.font = [UIFont systemFontOfSize:14];
    [_backView addSubview:self.labelDetail];
    
    self.btnDetail = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnDetail.titleLabel.font = [UIFont systemFontOfSize:16];
    self.btnDetail.frame = CGRectMake(SCREENWIDTH-100, self.labelMoney.frame.origin.y+10, 90, 17);
    [self.btnDetail setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_backView addSubview:self.btnDetail];
    [self.btnDetail addTarget:self action:@selector(pushDetailCash) forControlEvents:UIControlEventTouchUpInside];
    
    _btnSurePay = [UIButton buttonWithType:UIButtonTypeCustom];
     _btnSurePay.frame = CGRectMake(13,130+10+64+30, SCREENWIDTH-27, 43);
    _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
    _btnSurePay.layer.masksToBounds = YES;
    _btnSurePay.layer.cornerRadius = 20;
    [_btnSurePay setTitle:@"提现" forState:UIControlStateNormal];
    [_btnSurePay setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
    [self.view addSubview:_btnSurePay];
}
#pragma mark 押金明细
-(void)pushDetailCash{
    MyDepositDetailListVC *myDepositVC = [[MyDepositDetailListVC alloc]init];
    myDepositVC.order_id = self.orderId;
    [self.navigationController pushViewController:myDepositVC animated:YES];
    
}
#pragma mark data
-(void)getData{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.orderId,@"order_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"getToysDeposit" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = [result objectForKey:@"data"];
            self.labelTitle.text = data[@"deposit_title"];
            self.labelMoney.text = data[@"price"];
            NSString *expString = data[@"total_deposit_detail"];
            CGFloat height = [self getHeightByWidth:SCREENWIDTH-42 title:expString font:[UIFont systemFontOfSize:14]];
            self.labelDetail.frame = CGRectMake(20, self.labelMoney.frame.origin.y+self.labelMoney.frame.size.height+10, SCREENWIDTH-42, height);
            self.labelDetail.text = data[@"total_deposit_detail"];
            NSString *detail = [NSString stringWithFormat:@"%@",data[@"deposit_detail"]];
            [self.btnDetail setTitle:detail forState:UIControlStateNormal];
            _status = data[@"refund_status"];
            NSString *is_refund = [NSString stringWithFormat:@"%@",data[@"is_refund"]];
            _backView.frame = CGRectMake(0, 0, SCREENWIDTH, 110+height);
            _btnSurePay.frame = CGRectMake(13,110+height+10+64+30, SCREENWIDTH-27, 43);

            
            if ([is_refund isEqualToString:@"1"]) {
                _btnSurePay.hidden = NO;
                [_btnSurePay addTarget:self action:@selector(makesureRefund) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                _btnSurePay.hidden = YES;
            }
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您的网络出现错误" andDelegate:self];
    }];
    

}
-(void)makesureRefund{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"下次租玩具时还能继续用哦！确认申请提现么？" preferredStyle:UIAlertControllerStyleAlert];
        __weak MyDepositVC *babyVC = self;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [babyVC sureCancelOrder];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"下次租玩具时还能继续用哦！确认申请提现么？" delegate:self cancelButtonTitle:@"再想想" otherButtonTitles:@"继续", nil];
        alertView.tag = 101;
        [alertView show];
    }
    
    
}
-(void)sureCancelOrder{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",@"0",@"source",self.orderId,@"order_id",_status,@"refund_status", nil];
    [[HTTPClient sharedClient]getNewV1:@"toysOrderRefund" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            [BBSAlert showAlertWithContent:@"提交申请成功，1~3个工作日退回原账户" andDelegate:self];
            [self getData];
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您的网络出现错误" andDelegate:self];
    }];

    
}
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
    }else{
        [self sureCancelOrder];
    }
    
}

-(void)setBackBton{
    CGRect backBtnFrame=CGRectMake(0, 0, 10, 17);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.adjustsImageWhenHighlighted = NO;
    
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"babyShow_back"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
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

-(void)back{
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
