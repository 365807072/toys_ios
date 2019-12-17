//
//  GetCashVC.m
//  BabyShow
//
//  Created by WMY on 16/12/13.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "GetCashVC.h"
#import "NIAttributedLabel.h"

@interface GetCashVC ()
@property(nonatomic,strong)UIImageView *iconImg;//解释图标
@property(nonatomic,strong)UILabel *explianLabel;
@property(nonatomic,strong)UILabel *moneyLabel;
@property(nonatomic,strong)UILabel *moneyCountLabel;
@property(nonatomic,strong)UIButton *btnSurePay;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UIView *yellowView;



@end

@implementation GetCashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"提现";
    [self setLeftButton];
    [self setSubViews];
    [self getDataMess];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
#pragma mark UI
//返回按钮
-(void)setLeftButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)setSubViews{
    _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 173)];
    _backView.backgroundColor = [BBSColor hexStringToColor:@"fffdf6"];
    [self.view addSubview:_backView];
    
    _yellowView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 36)];
    _yellowView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_yellowView];

    self.iconImg = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 18, 22)];
    self.iconImg.image = [UIImage imageNamed:@"support"];
    [_yellowView addSubview:self.iconImg];
    
    self.explianLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImg.frame.origin.x+self.iconImg.frame.size.width+7, 12, SCREENWIDTH-42, 20)];
    self.explianLabel.textColor = [BBSColor hexStringToColor:@"23baec"];
    self.explianLabel.font = [UIFont systemFontOfSize:12];
    [_yellowView addSubview:self.explianLabel];
    
    self.moneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImg.frame.origin.x, 46, SCREENWIDTH-42, 20)];
    self.moneyLabel.textColor = [BBSColor hexStringToColor:@"fcbb62"];
    self.moneyLabel.font = [UIFont systemFontOfSize:18];
    [_backView addSubview:self.moneyLabel];
    self.moneyLabel.text = @"账户余额（元）";
    
    self.moneyCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.iconImg.frame.origin.x, 80, SCREENWIDTH-42, 70)];
    self.moneyCountLabel.textColor = [BBSColor hexStringToColor:@"fcbb62"];
    self.moneyCountLabel.font = [UIFont systemFontOfSize:60];
    [_backView addSubview:self.moneyCountLabel];

    _btnSurePay = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _btnSurePay.layer.masksToBounds = YES;
    _btnSurePay.layer.cornerRadius = 21;
    _btnSurePay.frame = CGRectMake(13,183+64, SCREENWIDTH-27, 43);
    _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
    [_btnSurePay setTitle:@"确认提现" forState:UIControlStateNormal];
    [_btnSurePay setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
    [self.view addSubview:_btnSurePay];
}
-(void)getDataMess{
    NSString *loginUserId=LOGIN_USER_ID;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"login_user_id", nil];
    [[HTTPClient sharedClient]getNewV1:@"getUserPrice" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = [result objectForKey:@"data"];
            NSString *expString = data[@"description"];
            
            CGFloat height = [self getHeightByWidth:SCREENWIDTH-42 title:expString font:[UIFont systemFontOfSize:12]];
            self.explianLabel.frame = CGRectMake(self.iconImg.frame.origin.x+self.iconImg.frame.size.width+7, 12, SCREENWIDTH-42, height);
            self.explianLabel.numberOfLines = 0;
            _yellowView.frame = CGRectMake(0, 64, SCREENWIDTH, height+20);
            self.moneyLabel.frame =CGRectMake(self.iconImg.frame.origin.x, _yellowView.frame.size.height, SCREENWIDTH-42, 20);
            
            self.moneyCountLabel.frame = CGRectMake(self.iconImg.frame.origin.x, self.moneyLabel.frame.origin.y+self.moneyLabel.frame.size.height+5, SCREENWIDTH-42, 70);
            _btnSurePay.frame = CGRectMake(13,_backView.frame.size.height+120, SCREENWIDTH-27, 43);
            self.explianLabel.text = data[@"description"];
            
            self.moneyCountLabel.text =data[@"account_price"];
            if ([data[@"is_apply"] isEqualToString:@"0"]) {
                _btnSurePay.enabled = NO;
                _btnSurePay.backgroundColor = [BBSColor hexStringToColor:@"cccccc"];
            }else{
                _btnSurePay.enabled = YES;
                [_btnSurePay addTarget:self action:@selector(getCash) forControlEvents:UIControlEventTouchUpInside];
            }

        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您的网络出现错误" andDelegate:self];
    }];

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

-(void)getCash{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"下次租玩具时还能继续用哦！确认申请提现么？" preferredStyle:UIAlertControllerStyleAlert];
        __weak GetCashVC *babyVC = self;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"再想想" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [babyVC paySure];
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
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
    }else{
        [self paySure];
    }
    
}
-(void)paySure{
     NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",@"1",@"source", nil];
    
    [[HTTPClient sharedClient]getNewV1:@"toysOrderRefund" params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            [BBSAlert showAlertWithContent:@"提交申请成功，1~3个工作日退回原账户" andDelegate:self];
            [self getDataMess];
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您的网络出现错误" andDelegate:self];
    }];
    
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
