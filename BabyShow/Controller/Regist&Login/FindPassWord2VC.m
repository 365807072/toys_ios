//
//  FindPassWord2VC.m
//  BabyShow
//
//  Created by WMY on 16/1/7.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "FindPassWord2VC.h"
#import "InputCheck.h"

@interface FindPassWord2VC (){
    UIScrollView *_scrollView;
    UIView *back1;
    UIView *back2;
    BaseLabel *labelStep1;
    BaseLabel *labelStep2;
    BaseImageView *imgStep1;
    YLButton *sumbitBtn;
    UITextField *phoneNumberTF;
    UITextField *phoneCodeTextField;
    YLButton *sendBtn;
}

@end

@implementation FindPassWord2VC

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftButton];
    [self setSubViews];

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
    cateName.text = @"找回登录密码";
    [_backBtn addSubview:cateName];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
-(void)setSubViews{
    _scrollView =[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.contentSize=[UIScreen mainScreen].bounds.size;
    _scrollView.backgroundColor = [BBSColor hexStringToColor:@"f0efed"];
    [self.view addSubview:_scrollView];
    
    back1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 41)];
    back1.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
    [_scrollView addSubview:back1];
    
    labelStep1 = [BaseLabel makeFrame:CGRectMake(94, 16, 61, 15) font:11 textColor:@"999999" textAlignment:NSTextAlignmentLeft text:@"1.安全验证"];
    [back1 addSubview:labelStep1];
    
    imgStep1 = [BaseImageView imgViewWithFrame:CGRectMake(labelStep1.frame.origin.x+labelStep1.frame.size.width+5, 18, 6, 11) backImg:[UIImage imageNamed:@"img_myhome_arrow"] userInterface:NO backgroupcolor:nil];
    [back1 addSubview:imgStep1];
    
    labelStep2 = [BaseLabel makeFrame:CGRectMake(imgStep1.frame.origin.x+imgStep1.frame.size.width+10, 16, 61, 15) font:11 textColor:@"fe6c6c" textAlignment:NSTextAlignmentLeft text:@"2.重置密码"];
    [back1 addSubview:labelStep2];
    back2 = [[UIView alloc]initWithFrame:CGRectMake(0, back1.frame.origin.y+back1.frame.size.height+10, SCREENWIDTH, 89)];
    back2.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
    [_scrollView addSubview:back2];
    
    phoneNumberTF = [[UITextField alloc]initWithFrame:CGRectMake(18, 15, 180, 17)];
    phoneNumberTF.placeholder = @"新密码6~16个字母或数字";
    phoneNumberTF.font = [UIFont systemFontOfSize:13];
    phoneNumberTF.borderStyle = UITextBorderStyleNone;
    phoneNumberTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNumberTF.delegate = self;
    [back2 addSubview:phoneNumberTF];
    [back2 addSubview:sendBtn];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, SCREENWIDTH, 1)];
    line.backgroundColor = [BBSColor hexStringToColor:@"e5e5e5"];
    [back2 addSubview:line];
    
    phoneCodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(18, 15+45, 180, 17)];
    phoneCodeTextField.placeholder = @"再次输入密码";
    phoneCodeTextField.font = [UIFont systemFontOfSize:13];
    phoneCodeTextField.borderStyle = UITextBorderStyleNone;
    phoneCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneCodeTextField.delegate = self;
    [back2 addSubview:phoneCodeTextField];
    
    sumbitBtn = [YLButton buttonEasyInitBackColor:[BBSColor hexStringToColor:@"fe6161"] frame:CGRectMake(21, back2.frame.origin.y+back2.frame.size.height+8, 280, 41) type:UIButtonTypeSystem backImage:nil target:self action:@selector(sumbitCode) forControlEvents:UIControlEventTouchUpInside];
    sumbitBtn.layer.masksToBounds = YES;
    sumbitBtn.layer.cornerRadius = 20;
    [sumbitBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_scrollView addSubview:sumbitBtn];
    _scrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [_scrollView addGestureRecognizer:singleTap];
    
    
    
}
#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField == phoneNumberTF) {
        if (phoneNumberTF.text.length>=16) {
            return NO;
        }
    }
    if (textField == phoneCodeTextField) {
        if (phoneCodeTextField.text.length >= 16) {
            return NO;
        }
    }
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)back{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}

//回收键盘
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [_scrollView endEditing:YES];
    
}

//重置密码时的检测和上传
-(void)sumbitCode{
    InputCheck *inputCheck = [[InputCheck alloc]init];
    NSString *firstPassWord = phoneNumberTF.text;
    NSString *secondePassWord = phoneCodeTextField.text;
    if (firstPassWord.length <= 0) {
        [self showHUDWithMessage:@"设置密码不能为空"];
        return;
    }
    if (secondePassWord.length <= 0) {
        [self showHUDWithMessage:@"确认密码不能为空"];
        return;
    }
    if (![inputCheck passwordCheck:firstPassWord]) {
        [BBSAlert showAlertWithContent:@"请输入正确格式的密码哦：6~16个字母或数字" andDelegate:self];
        return;
    }
    if (![inputCheck passwordCompareCheck:firstPassWord withRePeat:secondePassWord]) {
        [self showHUDWithMessage:@"两次密码不一致"];
        phoneNumberTF.text = nil;
        phoneCodeTextField.text = nil;
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:self.phoneString,@"mobile",[firstPassWord md5],kRegistPassword,[secondePassWord md5],@"confirm_password",nil];
    [[HTTPClient sharedClient]postNew:kEditPassword params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            [BBSAlert showAlertWithContent:@"密码重置成功" andDelegate:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
        
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"网络错误请稍后重试" andDelegate:nil];

    }];

    
}
-(void)showHUDWithMessage:(NSString *)message{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60,64+20+50+50+50+5 , 200, 30)];
    label.backgroundColor = [UIColor darkGrayColor];
    label.layer.cornerRadius = 3.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.textColor = [UIColor whiteColor];
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
