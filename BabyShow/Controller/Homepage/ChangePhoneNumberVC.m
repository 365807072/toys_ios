//
//  ChangePhoneNumberVC.m
//  BabyShow
//
//  Created by WMY on 15/12/9.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ChangePhoneNumberVC.h"
#import "ChangePhoneNumber2VC.h"
#import <SMS_SDK/SMSSDK.h>
//#import <SMS_SDK/SMSSDKCountryAndAreaCode.h>
//#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
//#import <SMS_SDK/SMSSDK+ExtexdMethods.h>
#import <MOBFoundation/MOBFoundation.h>

@interface ChangePhoneNumberVC (){
    UIScrollView *_scrollView;
    UIView *back1;
    UIView *back2;
    BaseLabel *labelStep1;
    BaseLabel *labelStep2;
    BaseImageView *imgStep1;
    YLButton *sumbitBtn;
    BaseLabel *oldPhoneNumberLabel;
    UITextField *phoneCodeTextField;
    YLButton *sendBtn;
    BaseLabel *timeLabel;
    NSTimer* _timer2;
}

@end

@implementation ChangePhoneNumberVC

-(void)viewWillAppear:(BOOL)animated{
    sumbitBtn.enabled = YES;
    [super viewWillAppear:animated];
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
    cateName.text = @"更换手机号";
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
    
    labelStep1 = [BaseLabel makeFrame:CGRectMake(94, 16, 61, 15) font:11 textColor:@"fe6c6c" textAlignment:NSTextAlignmentLeft text:@"1.安全验证"];
    [back1 addSubview:labelStep1];
    
    imgStep1 = [BaseImageView imgViewWithFrame:CGRectMake(labelStep1.frame.origin.x+labelStep1.frame.size.width+5, 18, 6, 11) backImg:[UIImage imageNamed:@"img_myhome_arrow"] userInterface:NO backgroupcolor:nil];
    [back1 addSubview:imgStep1];
    
    labelStep2 = [BaseLabel makeFrame:CGRectMake(imgStep1.frame.origin.x+imgStep1.frame.size.width+10, 16, 61, 15) font:11 textColor:@"999999" textAlignment:NSTextAlignmentLeft text:@"2.换绑手机"];
    [back1 addSubview:labelStep2];
    
    back2 = [[UIView alloc]initWithFrame:CGRectMake(0, back1.frame.origin.y+back1.frame.size.height+10, SCREENWIDTH, 89)];
    back2.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
    [_scrollView addSubview:back2];
    
    NSString *loginUserId=LOGIN_USER_ID;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"login_user_id", nil];
    [[HTTPClient sharedClient]getNew:kMobileInfo params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = [result objectForKey:@"data"];
            oldPhoneNumberLabel = [BaseLabel makeFrame:CGRectMake(18, 15, 110, 17) font:13 textColor:@"cccccc" textAlignment:NSTextAlignmentLeft text:data[@"hidden_mobile"]];
            [back2 addSubview:oldPhoneNumberLabel];
        }
    } failed:^(NSError *error) {
        
    }];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, SCREENWIDTH, 1)];
    line.backgroundColor = [BBSColor hexStringToColor:@"e5e5e5"];
    [back2 addSubview:line];
    
    phoneCodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(18, 15+45, 180, 17)];
    phoneCodeTextField.placeholder = @"请输入完整的旧手机号";
    phoneCodeTextField.font = [UIFont systemFontOfSize:13];
    phoneCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneCodeTextField.borderStyle = UITextBorderStyleNone;
    phoneCodeTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneCodeTextField.delegate = self;
    [back2 addSubview:phoneCodeTextField];
    
    sumbitBtn = [YLButton buttonEasyInitBackColor:[BBSColor hexStringToColor:@"fe6161"] frame:CGRectMake(21, back2.frame.origin.y+back2.frame.size.height+8, 280, 41) type:UIButtonTypeSystem backImage:nil target:self action:@selector(sumbitCode) forControlEvents:UIControlEventTouchUpInside];
    sumbitBtn.layer.masksToBounds = YES;
    sumbitBtn.layer.cornerRadius = 20;
    [sumbitBtn setTitle:@"验证" forState:UIControlStateNormal];
    [_scrollView addSubview:sumbitBtn];
    
    timeLabel = [BaseLabel makeFrame:CGRectMake(15, sumbitBtn.frame.origin.y+sumbitBtn.frame.size.height+20, SCREENWIDTH-30, 30) font:15 textColor:@"666666" textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"接收验证码中", nil)];
    [_scrollView addSubview:timeLabel];
    timeLabel.hidden = YES;
    
    _scrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [_scrollView addGestureRecognizer:singleTap];
    
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [_scrollView endEditing:YES];
    
}

-(void)sumbitCode{
    [phoneCodeTextField resignFirstResponder];
    sumbitBtn.enabled = NO;
    //判断手机号
    if(phoneCodeTextField.text.length != 11)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                        message:NSLocalizedString(@"手机号码格式不正确请重新输入", nil)
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
        sumbitBtn.enabled = YES;
    }
    else
    {
        NSString *loginUserId=LOGIN_USER_ID;
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"login_user_id",phoneCodeTextField.text,@"new_mobile", nil];
        [[HTTPClient sharedClient]getNew:kCheckMobile params:params success:^(NSDictionary *result) {
            if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                ChangePhoneNumber2VC *changePhoneNumber2 = [[ChangePhoneNumber2VC alloc]init];
                [self.navigationController pushViewController:changePhoneNumber2 animated:YES];
            }else{
                sumbitBtn.enabled = YES;
                [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
            }
        } failed:^(NSError *error) {
            sumbitBtn.enabled = YES;
            [BBSAlert showAlertWithContent:@"网络错误请稍后重试" andDelegate:nil];
        }];
        
    }


}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger length = textField.text.length;
    if ([string isEqualToString:@""]) {
        return YES;
    }

    if (length >= 11) {
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
