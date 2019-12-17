//
//  AddFoucExplainVC.m
//  BabyShow
//
//  Created by WMY on 15/12/16.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "AddFoucExplainVC.h"
#import "PayOrderNewVC.h"

@interface AddFoucExplainVC ()
@property(nonatomic,strong)BaseLabel *explainLabel;
@property(nonatomic,strong)BaseLabel *explainDetailLabel;
@property(nonatomic,strong)YLButton *makeSurePay;


@end

@implementation AddFoucExplainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButton];
    [self setExplainLabel];

    // Do any additional setup after loading the view.
}
#pragma mark UI
-(void)setLeftButton{
    
    //返回按钮
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.adjustsImageWhenHighlighted = NO;
    UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 31)];
    imagev.image = [UIImage imageNamed:@"btn_back1.png"];
    [_backBtn addSubview:imagev];
    UILabel *cateName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 31)];
    cateName.textColor = [UIColor whiteColor];
    cateName.text = @"添加关注";
    [_backBtn addSubview:cateName];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
-(void)setExplainLabel{
    self.view.backgroundColor = [BBSColor hexStringToColor:@"f7f7f7"];
    UIView *backView= [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 300)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    self.explainLabel= [BaseLabel makeFrame:CGRectMake(10, 10, 200, 16) font:16 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"此服务为付费服务:"];
    [backView addSubview:self.explainLabel];
    
    self.explainDetailLabel = [BaseLabel makeFrame:CGRectMake(10, 50, SCREENWIDTH-20, 218) font:15 textColor:@"484848" textAlignment:NSTextAlignmentLeft text:nil];
    self.explainDetailLabel.text = @"*建议用户使用普通会员的免费服务，普通会员能实现付费服务的全部功能；\n\n* 白金会员将非常完美地实现主账户和个人账户之间记录的同步，包括自己宝宝年龄的重新精确计算、相片的自动同步到自己的成长记录中、以及相册描述和相片描述的自动同步。\n\n* 白金会员也是对作者额外大量工作的认可和肯定，同时促进彼此之间的交流和互动，共同建设完美的孩子成长记录。";
    self.explainDetailLabel.numberOfLines = 0;
    [backView addSubview:self.explainDetailLabel];
    
    self.makeSurePay = [YLButton buttonEasyInitBackColor:[BBSColor hexStringToColor:@"ff6162"] frame:CGRectMake(20, 384, SCREENWIDTH-40, 40) type:UIButtonTypeSystem backImage:nil target:self action:@selector(makeSureGoPay) forControlEvents:UIControlEventTouchUpInside];
    [self.makeSurePay setTitle:@"马上支付" forState:UIControlStateNormal];
    self.makeSurePay.layer.masksToBounds = YES;
    self.makeSurePay.layer.cornerRadius = 20;
    [self.view addSubview:self.makeSurePay];
    
    
    
}
-(void)makeSureGoPay{
    PayOrderNewVC *payOrder = [[PayOrderNewVC alloc]init];
    payOrder.order_role = @"1";
    payOrder.business_id = self.babys_idol_id;
    payOrder.longin_user_id = self.login_user_id;
    payOrder.priceCombine = @"1";
    [self.navigationController pushViewController:payOrder animated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
