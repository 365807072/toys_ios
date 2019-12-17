//
//  AddChooseFouceVC.m
//  BabyShow
//
//  Created by WMY on 15/12/15.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "AddChooseFouceVC.h"
#import "AddFoucExplainVC.h"
#import "GrowthDiaryViewController.h"

@interface AddChooseFouceVC ()<UITextFieldDelegate>
@property(nonatomic,strong)BaseLabel *fouceCoustomLabel;
@property(nonatomic,strong)BaseLabel *coustomDetailLabel;
@property(nonatomic,strong)BaseLabel *vipCoustomLabel;
@property(nonatomic,strong)BaseLabel *vipDetailLabel;
@property(nonatomic,strong)UIButton *coustomBtn;
@property(nonatomic,strong)YLButton *vipBtn;
@property(nonatomic,strong)UITextField *nameTF;
@property(nonatomic,strong)YLButton *makeSureBtn;
@property(nonatomic,strong)NSString *idolType;

@end

@implementation AddChooseFouceVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.idolType = @"0";
    [self setLeftButton];
    [self setViews];
    
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    //self.tabBarController.tabBar.hidden = NO;
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
-(void)setViews{
    self.view.backgroundColor = [BBSColor hexStringToColor:@"f7f7f7"];
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 169)];
    backView.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
    [self.view addSubview:backView];
    
    self.fouceCoustomLabel = [BaseLabel makeFrame:CGRectMake(16, 21, 120, 20) font:16 textColor:@"323232" textAlignment:NSTextAlignmentLeft text:@"普通关注"];
    [backView addSubview:self.fouceCoustomLabel];
    
    self.coustomDetailLabel = [BaseLabel makeFrame:CGRectMake(16, 44, 280, 30) font:11 textColor:@"666666" textAlignment:NSTextAlignmentLeft text:@"对方同意后，可浏览和下载对方的成长记录\n前30天免费体验白金会员服务"];
    [backView addSubview:self.coustomDetailLabel];
    self.coustomDetailLabel.numberOfLines = 2;
    self.coustomBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.coustomBtn.frame = CGRectMake(SCREENWIDTH-40, 30, 18.5, 18.5);
    [self.coustomBtn setBackgroundImage:[UIImage imageNamed:@"btn_select_pay"] forState:UIControlStateNormal];
    [self.coustomBtn addTarget:self action:@selector(addFouce) forControlEvents:UIControlEventTouchUpInside];
    self.coustomBtn.tag = 1019;
    [backView addSubview:self.coustomBtn];
    
    UIButton *button1 =[UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame =CGRectMake(SCREEN_WIDTH-60, 10, 60, 50);
        [button1 addTarget:self action:@selector(addFouce) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button1];
    

    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 80, SCREENWIDTH, 1)];
    lineView.backgroundColor = [BBSColor hexStringToColor:@"e1e1e1"];
    [backView addSubview:lineView];
    
    
    self.vipCoustomLabel = [BaseLabel makeFrame:CGRectMake(16, 21+80, 120, 20) font:16 textColor:@"323232" textAlignment:NSTextAlignmentLeft text:@"白金会员"];
    [backView addSubview:self.vipCoustomLabel];
    
    self.vipDetailLabel = [BaseLabel makeFrame:CGRectMake(16, 47+80, 280, 20) font:11 textColor:@"666666" textAlignment:NSTextAlignmentLeft text:@"对方的成长记录内容可直接同步到自己的成长记录中"];
    [backView addSubview:self.vipDetailLabel];
    
    self.vipBtn = [YLButton buttonEasyInitBackColor:nil frame:CGRectMake(SCREENWIDTH-40, 30+80, 18.5, 18.5) type:UIButtonTypeSystem backImage:[UIImage imageNamed:@"btn_unselect_pay"] target:self action:@selector(addVipFouce) forControlEvents:UIControlEventTouchUpInside];
    self.vipBtn.tag = 1020;
    [backView addSubview:self.vipBtn];
    
    UIButton *button2 =[UIButton buttonWithType:UIButtonTypeSystem];
    button2.frame =CGRectMake(SCREEN_WIDTH-60, 10+80, 60, 60);
    
    [button2 addTarget:self action:@selector(addVipFouce) forControlEvents:UIControlEventTouchUpInside];
    [backView addSubview:button2];
    
    self.nameTF= [[UITextField alloc]initWithFrame:CGRectMake(15, backView.frame.origin.y+backView.frame.size.height+10, 290, 30)];
    self.nameTF.placeholder = @"例如：我是Emma的妈妈";
    self.nameTF.font = [UIFont systemFontOfSize:15];
    self.nameTF.borderStyle = UITextBorderStyleRoundedRect;
    self.nameTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.nameTF.delegate = self;
    [self.view addSubview:self.nameTF];
    
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    self.makeSureBtn = [YLButton buttonEasyInitBackColor:[BBSColor hexStringToColor:@"fe6161"] frame:CGRectMake(15, self.nameTF.frame.origin.y+40, 290, 40) type:UIButtonTypeSystem backImage:nil target:self action:@selector(makeSUreSumbit) forControlEvents:UIControlEventTouchUpInside];
    self.makeSureBtn.layer.masksToBounds = YES;
    self.makeSureBtn.layer.cornerRadius = 20;
    [self.makeSureBtn setTitle:@"确认" forState:UIControlStateNormal];
    [self.view addSubview:self.makeSureBtn];
}
-(void)addFouce{
    [self.vipBtn setBackgroundImage:[UIImage imageNamed:@"btn_unselect_pay"] forState:UIControlStateNormal];
    [self.coustomBtn setBackgroundImage:[UIImage imageNamed:@"btn_select_pay"] forState:UIControlStateNormal
     ];
    self.idolType = @"0";
    
    
}
-(void)addVipFouce{
    [self.vipBtn setBackgroundImage:[UIImage imageNamed:@"btn_select_pay"] forState:UIControlStateNormal];
    [self.coustomBtn setBackgroundImage:[UIImage imageNamed:@"btn_unselect_pay"] forState:UIControlStateNormal
     ];
    self.idolType = @"1";
    
}
-(void)makeSUreSumbit{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.baby_id,@"baby_id",self.idol_user_id,@"idol_user_id",self.nameTF.text,@"description",nil];
    
    [[HTTPClient sharedClient]postNew:kPublicBabysIdol params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            if ([self.idolType isEqualToString:@"1"]) {
                NSDictionary *dataDic = result[@"data"];
                NSString *babyIdolId = dataDic[@"babys_idol_id"];
                AddFoucExplainVC *addFouceExplainVC = [[AddFoucExplainVC alloc]init];
                addFouceExplainVC.login_user_id = self.login_user_id;
                addFouceExplainVC.babys_idol_id = babyIdolId;
                
                [self.navigationController pushViewController:addFouceExplainVC animated:YES];
                
            }else{
                [BBSAlert showAlertWithContent:@"关注成功，等待对方同意" andDelegate:nil];
                for (UIViewController *temp in self.navigationController.viewControllers) {
                    if ([temp isKindOfClass:[GrowthDiaryViewController class]]) {
                        [self.navigationController popToViewController:temp animated:YES];
                    }
                }

                

            }
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
        
    } failed:^(NSError *error) {
        NSLog(@"nserror = %@",error);
        
    }];

    
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [self.view endEditing:YES];
    
}

#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger length = textField.text.length;
    if (length >=20) {
        return NO;
    }
    return YES;
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
