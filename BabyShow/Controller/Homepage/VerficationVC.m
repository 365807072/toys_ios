//
//  VerficationVC.m
//  BabyShow
//
//  Created by WMY on 16/2/26.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "VerficationVC.h"
#import "PlayVideoMyCell.h"

@interface VerficationVC (){
    UIScrollView *_scrollView;
    YLButton *sumbitBtn;

}

@end

@implementation VerficationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButton];
    [self setSubViews];

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
    
    _scrollView =[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.contentSize=[UIScreen mainScreen].bounds.size;
    _scrollView.contentSize = CGSizeMake(0,[UIScreen mainScreen].bounds.size.height+100);
    _scrollView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f9"];
    [self.view addSubview:_scrollView];
    
    NSDictionary  *dic2 = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
    CGSize textsize2 = [_businessPackageVeri boundingRectWithSize:CGSizeMake(230, MAXFLOAT) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil].size;

    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 142)];
    backView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:backView];
    
    UIView *lineView10 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
    lineView10.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView addSubview:lineView10];
    UIView *lineView11 = [[UIView alloc]initWithFrame:CGRectMake(14, 46, SCREENWIDTH, 0.5)];
    lineView11.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView addSubview:lineView11];
    
    UIView *lineView12 = [[UIView alloc]initWithFrame:CGRectMake(14, 46+textsize2.height+20, SCREENWIDTH, 0.5)];
    lineView12.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView addSubview:lineView12];
    
    
    BaseLabel *phoneLabel = [BaseLabel makeFrame:CGRectMake(13, 12, 60, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"订单号"];
    [backView addSubview:phoneLabel];
    
    
    BaseLabel *mailLabel = [BaseLabel makeFrame:CGRectMake(13, 12+46, 60, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"内容"];
    [backView addSubview:mailLabel];
    
    BaseLabel *adressLabel = [BaseLabel makeFrame:CGRectMake(13, 12+46+textsize2.height+20, 60, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"价格"];
    [backView addSubview:adressLabel];
    
    BaseLabel *orderNumberLabel = [BaseLabel makeFrame:CGRectMake(SCREENWIDTH-250, 12, 230, 20) font:14 textColor:@"999999" textAlignment:NSTextAlignmentLeft text:_orderNumVeri];
    [backView addSubview:orderNumberLabel];
    
    BaseLabel *businessPackageLabel = [BaseLabel makeFrame:CGRectMake(SCREENWIDTH-250, 12+46, 230, textsize2.height) font:14 textColor:@"999999" textAlignment:NSTextAlignmentLeft text:_businessPackageVeri];
    businessPackageLabel.numberOfLines = 0;
    [backView addSubview:businessPackageLabel];
    
    NSString *priceString = [NSString stringWithFormat:@"¥%@",_priceVeri];
    BaseLabel *priceLabel = [BaseLabel makeFrame:CGRectMake(SCREENWIDTH-250, 12+46+textsize2.height+20, 230, 20) font:14 textColor:@"999999" textAlignment:NSTextAlignmentLeft text:priceString];
    [backView addSubview:priceLabel];
    backView.frame =CGRectMake(0, 0, SCREENWIDTH, 142-46+textsize2.height+20);
    
    UIView *lineView13 = [[UIView alloc]initWithFrame:CGRectMake(0, 142-46+textsize2.height+20-0.5, SCREENWIDTH, 0.5)];
    lineView13.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView addSubview:lineView13];

    sumbitBtn = [YLButton buttonEasyInitBackColor:[BBSColor hexStringToColor:@"fe6161"] frame:CGRectMake(15, 142-46+textsize2.height+20+14.5, 280, 41) type:UIButtonTypeSystem backImage:nil target:self action:@selector(subitMessage) forControlEvents:UIControlEventTouchUpInside];
    sumbitBtn.layer.masksToBounds = YES;
    sumbitBtn.layer.cornerRadius = 20;
    [sumbitBtn setTitle:@"确定验证" forState:UIControlStateNormal];
    [_scrollView addSubview:sumbitBtn];
    
}
-(void)subitMessage{
    NSString *loginUserId=[NSString stringWithFormat:@"%@",LOGIN_USER_ID];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"login_user_id",_verificationVeri,@"verification",_orderIdVeri,@"order_id" ,nil];
    [[HTTPClient sharedClient]getNew:kBusinessVerification params:paramDic success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]integerValue] == 1) {
            self.refreshInStoreVC();
            [self.navigationController popViewControllerAnimated:YES];
            
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];

        }
        
    } failed:^(NSError *error) {
        
    }];
    
    
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
