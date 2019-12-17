//
//  FindPassWord1VC.m
//  BabyShow
//
//  Created by WMY on 16/1/7.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "FindPassWord1VC.h"
#import <SMS_SDK/SMSSDK.h>
//#import <SMS_SDK/SMSSDKCountryAndAreaCode.h>
//#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
//#import <SMS_SDK/SMSSDK+ExtexdMethods.h>
#import <MOBFoundation/MOBFoundation.h>
#import "FindPassWord2VC.h"

@interface FindPassWord1VC (){
    UIScrollView *_scrollView;
    UIView *back1;
    UIView *back2;
    BaseLabel *labelStep1;
    BaseLabel *labelStep2;
    BaseImageView *imgStep1;
    YLButton *sumbitBtn;
    BaseLabel *oldPhoneNumberLabel;
    UITextField *phoneNumberTF;
    UITextField *phoneCodeTextField;
    YLButton *sendBtn;
    NSTimer* _timer2;
    int count;
    


}

@end


@implementation FindPassWord1VC

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
    
    labelStep1 = [BaseLabel makeFrame:CGRectMake(94, 16, 61, 15) font:11 textColor:@"fe6c6c" textAlignment:NSTextAlignmentLeft text:@"1.安全验证"];
    [back1 addSubview:labelStep1];
    
    imgStep1 = [BaseImageView imgViewWithFrame:CGRectMake(labelStep1.frame.origin.x+labelStep1.frame.size.width+5, 18, 6, 11) backImg:[UIImage imageNamed:@"img_myhome_arrow"] userInterface:NO backgroupcolor:nil];
    [back1 addSubview:imgStep1];
    
    labelStep2 = [BaseLabel makeFrame:CGRectMake(imgStep1.frame.origin.x+imgStep1.frame.size.width+10, 16, 61, 15) font:11 textColor:@"999999" textAlignment:NSTextAlignmentLeft text:@"2.重置密码"];
    [back1 addSubview:labelStep2];
    back2 = [[UIView alloc]initWithFrame:CGRectMake(0, back1.frame.origin.y+back1.frame.size.height+10, SCREENWIDTH, 89)];
    back2.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
    [_scrollView addSubview:back2];
    
    phoneNumberTF = [[UITextField alloc]initWithFrame:CGRectMake(18, 15, 180, 17)];
    phoneNumberTF.placeholder = @"请输入手机号";
    phoneNumberTF.font = [UIFont systemFontOfSize:13];
    phoneNumberTF.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberTF.borderStyle = UITextBorderStyleNone;
    phoneNumberTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNumberTF.delegate = self;
    [back2 addSubview:phoneNumberTF];

    
    sendBtn = [YLButton buttonEasyInitBackColor:nil frame:CGRectMake(SCREENWIDTH-94, 7, 85, 30) type:UIButtonTypeSystem backImage:nil target:self action:@selector(sendPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn.layer setMasksToBounds:YES];
    [sendBtn.layer setCornerRadius:6.0];
    [sendBtn.layer setBorderWidth:1.0];
    [sendBtn.layer setBorderColor:[BBSColor hexStringToColor:@"fe6161"].CGColor];
    [back2 addSubview:sendBtn];
    
    [sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendBtn setTitleColor:[BBSColor hexStringToColor:@"fe6161"] forState:UIControlStateNormal];

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 44.5, SCREENWIDTH, 1)];
    line.backgroundColor = [BBSColor hexStringToColor:@"e5e5e5"];
    [back2 addSubview:line];
    
    phoneCodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(18, 15+45, 180, 17)];
    phoneCodeTextField.placeholder = @"请输入手机短信中的验证码";
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
    _scrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [_scrollView addGestureRecognizer:singleTap];

    

}

//手机发送验证码
-(void)sendPhoneNumber{
    
    if (phoneNumberTF.text.length != 11) {
        //手机号码不正确
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                        message:NSLocalizedString(@"手机号格式有误，请重新输入", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"知道了", nil)
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }else{
        
        count = 0;
        
        NSTimer* timer2 = [NSTimer scheduledTimerWithTimeInterval:1
                                                           target:self
                                                         selector:@selector(updateTime)
                                                         userInfo:nil
                                                          repeats:YES];
        _timer2 = timer2;
        [self sendCodeNumber];
    }
    
}
-(void)updateTime
{
    count++;
    if (count >= 60)
    {
        [sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        sendBtn.enabled = YES;
        [_timer2 invalidate];
        return;
    }
    NSString *timeString = [NSString stringWithFormat:@"%d秒",60-count];
    [sendBtn setTitle:timeString forState:UIControlStateNormal];
    sendBtn.enabled = NO;
    
}

//发送
-(void)sendCodeNumber{
   
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNumberTF.text
                                   zone:@"86"
                       template:nil
                                 result:^(NSError *error)
     {
         if (!error)
         {
             [BBSAlert showAlertWithContent:@"验证码发送成功，注意查收" andDelegate:nil];
             NSLog(@"验证码发送成功");
         }
         else
         {
             
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                             message:[NSString stringWithFormat:@"错误描述：%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"知道了", nil)
                                                   otherButtonTitles:nil, nil];
             [alert show];

         }
         
     }];
    
}
//提交
-(void)sumbitCode{
    
    sumbitBtn.enabled = NO;
    NSString *phoneString = phoneNumberTF.text;
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:phoneString,@"mobile",nil];
    [[HTTPClient sharedClient]getNew:kCheckMobileInfo params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue]==YES) {
                if(phoneCodeTextField.text.length != 4)
                {
                    sumbitBtn.enabled = YES;
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                                    message:NSLocalizedString(@"验证码格式有误请重新输入", nil)
                                                                   delegate:self
                                                          cancelButtonTitle:@"知道了"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                }
                else
                {
                    [SMSSDK commitVerificationCode:phoneCodeTextField.text phoneNumber:phoneNumberTF.text zone:@"86" result:^(NSError *error) {
                        if (!error) {
                            NSLog(@"成功");
                            sumbitBtn.enabled = NO;
                            FindPassWord2VC *findPass2 = [[FindPassWord2VC alloc]init];
                            findPass2.phoneString = phoneNumberTF.text;
                            [self.navigationController pushViewController:findPass2 animated:YES];
                            
                        }else{
                            NSLog(@"验证失败");
                            sumbitBtn.enabled = YES;
                            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                                            message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]]
                                                                           delegate:self
                                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                                  otherButtonTitles:nil, nil];
                            [alert show];
                            
                        }
                    }];
                }
                

            
            
            
        }else{
            sumbitBtn.enabled = YES;
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
        
    } failed:^(NSError *error) {
        sumbitBtn.enabled = YES;

        [BBSAlert showAlertWithContent:@"网络错误请稍后重试" andDelegate:nil];
    }];
    
    
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [_scrollView endEditing:YES];
    
}
#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField == phoneNumberTF) {
        if (phoneNumberTF.text.length>=11) {
            return NO;
        }
    }
    if (textField == phoneCodeTextField) {
        if (phoneCodeTextField.text.length >= 4) {
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
