//
//  ChangePhoneNumber2VC.m
//  BabyShow
//
//  Created by WMY on 15/12/10.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ChangePhoneNumber2VC.h"
#import <SMS_SDK/SMSSDK.h>
//#import <SMS_SDK/SMSSDKCountryAndAreaCode.h>
//#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
//#import <SMS_SDK/SMSSDK+ExtexdMethods.h>
#import <MOBFoundation/MOBFoundation.h>


@interface ChangePhoneNumber2VC ()<UIAlertViewDelegate>
{
    UIScrollView *_scrollView;
    UIView *back1;
    
    BaseLabel *labelStep1;
    BaseLabel *labelStep2;
    BaseImageView *imgStep1;
    YLButton *sumbitBtn;
    BaseLabel *oldPhoneNumberLabel;
    BaseLabel *inputLabel;
    UITextField *phoneNumberTextField;
    UITextField *phoneCodeTextField;
    YLButton *sendBtn;
    NSMutableArray *_areaArray;
    BaseLabel *timeLabel;
    NSTimer* _timer2;
     int count;
    YLButton *clickBtnSkip;//点击跳过验证
    UIView *lineView;//点击验证码下面的线

}


@end


@implementation ChangePhoneNumber2VC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = [BBSColor hexStringToColor:NAVICOLOR];
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
    if (self.typeChangeOrBing == 1) {
        cateName.text = @"绑定手机号";
    }else{
    cateName.text = @"更换手机号";
    }
    [_backBtn addSubview:cateName];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [self.view endEditing:YES];
    
}

-(void)setSubViews{
    _scrollView =[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.contentSize=[UIScreen mainScreen].bounds.size;
    _scrollView.backgroundColor = [BBSColor hexStringToColor:@"f0efed"];
    [self.view addSubview:_scrollView];
    self.view.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [self.view addGestureRecognizer:singleTap];
    if (self.typeChangeOrBing == 1) {
        back1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0)];
        back1.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
        [_scrollView addSubview:back1];

    }else{
        back1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 41)];
        back1.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
        [_scrollView addSubview:back1];
        labelStep1 = [BaseLabel makeFrame:CGRectMake(94, 16, 61, 15) font:11 textColor:@"999999" textAlignment:NSTextAlignmentLeft text:@"1.安全验证"];
        [back1 addSubview:labelStep1];
        
        imgStep1 = [BaseImageView imgViewWithFrame:CGRectMake(labelStep1.frame.origin.x+labelStep1.frame.size.width+5, 18, 6, 11) backImg:[UIImage imageNamed:@"img_myhome_arrow"] userInterface:NO backgroupcolor:nil];
        [back1 addSubview:imgStep1];
        
        labelStep2 = [BaseLabel makeFrame:CGRectMake(imgStep1.frame.origin.x+imgStep1.frame.size.width+10, 16, 61, 15) font:11 textColor:@"fe6c6c" textAlignment:NSTextAlignmentLeft text:@"2.换绑手机"];
        [back1 addSubview:labelStep2];
    }
    
    if (self.typeChangeOrBing == 1) {
        oldPhoneNumberLabel = [BaseLabel makeFrame:CGRectMake(15, back1.frame.origin.y+back1.frame.size.height+17, 110, 17) font:13 textColor:@"333333" textAlignment:NSTextAlignmentLeft text:@"请输入手机号码"];

    }else{
        oldPhoneNumberLabel = [BaseLabel makeFrame:CGRectMake(15, back1.frame.origin.y+back1.frame.size.height+17, 110, 17) font:13 textColor:@"333333" textAlignment:NSTextAlignmentLeft text:@"请输入新手机号码"];

    }
    [_scrollView addSubview:oldPhoneNumberLabel];
    
    phoneNumberTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, oldPhoneNumberLabel.frame.origin.y+oldPhoneNumberLabel.frame.size.height+12,190 , 37)];
    phoneNumberTextField.placeholder = @"请填写手机号";
    phoneNumberTextField.font = [UIFont systemFontOfSize:13];
    phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberTextField.borderStyle = UITextBorderStyleRoundedRect;
    phoneNumberTextField.delegate = self;
    [_scrollView addSubview:phoneNumberTextField];
    
    sendBtn = [YLButton buttonEasyInitBackColor:[BBSColor hexStringToColor:@"fe6c6c"] frame:CGRectMake(SCREENWIDTH-103, phoneNumberTextField.frame.origin.y, 96, 36) type:UIButtonTypeSystem backImage:nil target:self action:@selector(sendPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    sendBtn.layer.masksToBounds = YES;
    sendBtn.layer.cornerRadius = 6.0;
    [sendBtn setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];

    [_scrollView addSubview:sendBtn];
    
    
    inputLabel = [BaseLabel makeFrame:CGRectMake(15, phoneNumberTextField.frame.origin.y+phoneNumberTextField.frame.size.height+20, 110, 17) font:13 textColor:@"333333" textAlignment:NSTextAlignmentLeft text:@"请输入验证码"];
    [_scrollView addSubview:inputLabel];

    phoneCodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(15, inputLabel.frame.origin.y+inputLabel.frame.size.height+10, 290, 37)];
    phoneCodeTextField.placeholder = @"请输入手机短信中的验证码";
    phoneCodeTextField.font = [UIFont systemFontOfSize:13];
    phoneCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneCodeTextField.borderStyle = UITextBorderStyleRoundedRect;
    phoneCodeTextField.delegate = self;
    [_scrollView addSubview:phoneCodeTextField];
    
    sumbitBtn = [YLButton buttonEasyInitBackColor:[BBSColor hexStringToColor:@"fe6161"] frame:CGRectMake(15, phoneCodeTextField.frame.origin.y+phoneCodeTextField.frame.size.height+19, 280, 41) type:UIButtonTypeSystem backImage:nil target:self action:@selector(sumbitCode) forControlEvents:UIControlEventTouchUpInside];
    sumbitBtn.layer.masksToBounds = YES;
    sumbitBtn.layer.cornerRadius = 20;
    [sumbitBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [_scrollView addSubview:sumbitBtn];
    
    timeLabel = [BaseLabel makeFrame:CGRectMake(15, sumbitBtn.frame.origin.y+sumbitBtn.frame.size.height+20, SCREENWIDTH-30, 30) font:15 textColor:@"666666" textAlignment:NSTextAlignmentCenter text:NSLocalizedString(@"接收验证码中", nil)];
    [_scrollView addSubview:timeLabel];
    timeLabel.hidden = YES;
    
    clickBtnSkip = [YLButton buttonEasyInitBackColor:nil frame:CGRectMake(100, sumbitBtn.frame.origin.y+sumbitBtn.frame.size.height+70, 120, 50) type:UIButtonTypeSystem backImage:nil target:self action:@selector(skipCode) forControlEvents:UIControlEventTouchUpInside];
    clickBtnSkip.titleLabel.font = [UIFont systemFontOfSize:13];
    [clickBtnSkip setTitle:@"点我跳过绑定" forState:UIControlStateNormal];
    [clickBtnSkip setTitleColor:[BBSColor hexStringToColor:@"999999"] forState:UIControlStateNormal];
    clickBtnSkip.titleLabel.font = [UIFont systemFontOfSize:14];
    [_scrollView addSubview:clickBtnSkip];
    clickBtnSkip.hidden = YES;
    lineView = [[UIView alloc]initWithFrame:CGRectMake(22, 35, 75, 1)];
    lineView.backgroundColor = [BBSColor hexStringToColor:NAVICOLOR];
    lineView.hidden = YES;
    [clickBtnSkip addSubview:lineView];

}
#pragma mark 跳过验证码的操作
-(void)skipCode{
    NSString *loginUserId=LOGIN_USER_ID;
    NSString *phoneNumber = phoneNumberTextField.text;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"login_user_id",phoneNumber,@"mobile", nil];
    [[HTTPClient sharedClient]getNewV1:kEditMobile params:params success:^(NSDictionary *result) {
        
    } failed:^(NSError *error) {
        
    }];
    UserInfoManager *manager = [[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    userItem.isVisitor = [NSNumber numberWithBool:NO];
    [manager saveUserInfo:userItem];
    if (self.isFromTab) {
        BBSTabBarViewController *tabVc = [[BBSTabBarViewController alloc]init];
        tabVc.selectedIndex = 3;
        theAppDelegate.window.rootViewController =tabVc;
        [tabVc setBBStabbarSelectedIndex:3];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }else{
        [self dismissViewControllerAnimated:YES completion:^{
        }];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
//手机发送验证码
-(void)sendPhoneNumber{
    [LoadingView startOnTheViewController:self];
        if (phoneNumberTextField.text.length != 11) {
            [LoadingView stopOnTheViewController:self];
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
            [self.view endEditing:YES];

        }
    
}
#pragma mark 点击获取验证码的时候获取用户的手机号
-(void)getUserPhonenumber{
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",phoneNumberTextField.text,@"mobile", nil];
    [[HTTPClient sharedClient]postNewV1:@"getUserMobile" params:param success:^(NSDictionary *result) {
        
    } failed:^(NSError *error) {
    }];
}
-(void)updateTime
{
    count++;
    if (count >= 60)
    {
        [sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        sendBtn.enabled = YES;
        [_timer2 invalidate];
        if ([self.fromLogin isEqualToString:@"login"]) {
            clickBtnSkip.hidden = NO;
            lineView.hidden = NO;
        }
        return;
    }
    NSString *timeString = [NSString stringWithFormat:@"%d秒",60-count];
    [sendBtn setTitle:timeString forState:UIControlStateNormal];
    sendBtn.enabled = NO;
    
}

//发送
-(void)sendCodeNumber{
    [self getUserPhonenumber];
  
   [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNumberTextField.text
                                   zone:@"86"
                                   template:nil
                                 result:^(NSError *error)
     {
         if (!error)
         {
             [LoadingView stopOnTheViewController:self];
             [BBSAlert showAlertWithContent:@"验证码发送成功，注意查收" andDelegate:nil];
             
         }
         else
         {
             [LoadingView stopOnTheViewController:self];
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                             message:[NSString stringWithFormat:@"错误描述：%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"知道了", nil)
                                                   otherButtonTitles:nil, nil];

             [alert show];
         }
         
     }];
   
}
#pragma mark 提交
//提交
-(void)sumbitCode{
    sumbitBtn.enabled = NO;
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
        [SMSSDK commitVerificationCode:phoneCodeTextField.text phoneNumber:phoneNumberTextField.text zone:@"86" result:^(NSError *error) {
            if (!error) {
                NSString *loginUserId=LOGIN_USER_ID;
                NSString *phoneNumber = phoneNumberTextField.text;

                NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"login_user_id",phoneNumber,@"mobile", nil];
                [[HTTPClient sharedClient]getNew:kEditMobile params:params success:^(NSDictionary *result) {
                    if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                        UserInfoManager *manager = [[UserInfoManager alloc]init];
                        UserInfoItem *userItem=[manager currentUserInfo];
                        userItem.isVisitor = [NSNumber numberWithBool:NO];
                        [manager saveUserInfo:userItem];
                        if (self.isFromTab) {
                            BBSTabBarViewController *tabVc = [[BBSTabBarViewController alloc]init];
                            tabVc.selectedIndex = 3;
                            theAppDelegate.window.rootViewController =tabVc;
                            [tabVc setBBStabbarSelectedIndex:3];
                            [self dismissViewControllerAnimated:YES completion:^{
                            }];
                        }else{
                            [self dismissViewControllerAnimated:YES completion:^{
                            }];
                            [self.navigationController popToRootViewControllerAnimated:YES];
                            
                        }
                        [BBSAlert showAlertWithContent:@"手机号绑定成功" andDelegate:nil andDismissAnimated:2];
                    }else{
                        NSLog(@"rererere绑定问= %@",result);
                        if ([[result objectForKey:@"reCode"]integerValue] == 3008) {
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"手机号被注册，是否绑定" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"绑定", nil];
                            [alertView show];
                            alertView.tag = 1003;
                            sumbitBtn.enabled = YES;
                        }else if ([[result objectForKey:@"reCode"]integerValue] == 3009){
                            if ([self.fromLogin isEqualToString:@"login"]) {
                                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"手机号已被绑定，请尝试手机号登录" message:nil delegate:self cancelButtonTitle:@"换手机号" otherButtonTitles:@"去登录", nil];
                                alertView.tag = 1001;
                                [alertView show];
                            }else{
                            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"手机号已被绑定" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
                                alertView.tag = 1002;
                            [alertView show];
                            }
                            sumbitBtn.enabled = YES;
                            
  
                        }else{
                            sumbitBtn.enabled = YES;
                        [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];

                        }
                    }
                } failed:^(NSError *error) {
                    sumbitBtn.enabled = YES;
                    
                    [BBSAlert showAlertWithContent:@"网络问题" andDelegate:nil];

                    
                }];
            }
            else
            {
                NSLog(@"验证失败");
                sumbitBtn.enabled = YES;
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                                message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]]
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                      otherButtonTitles:nil, nil];
                alert.tag = 1003;
           

                [alert show];
            }
        }];
    }
}
#pragma mark - UIAlertViewDelegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1001) {
        if (buttonIndex == 0) {
            
        }else{
            [self back];
        }
    }else if (alertView.tag == 1002){
        
        
    }else if (alertView.tag == 1003){
        if (buttonIndex == 0) {
            
        }else{
            [LoadingView startOnTheViewController:self];
            NSString *phoneNumber = phoneNumberTextField.text;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",phoneNumber,@"mobile", nil];
            [[HTTPClient sharedClient]getNew:kAddMobile params:params success:^(NSDictionary *result) {
                if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                    [BBSAlert showAlertWithContent:@"手机号绑定成功" andDelegate:nil andDismissAnimated:2];
                    [self.navigationController popToRootViewControllerAnimated:YES];
                }else{
                    [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
                    
                }
                
            } failed:^(NSError *error) {
                
            }];
        }
 
    }
}
#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField == phoneNumberTextField) {
        if (phoneNumberTextField.text.length>=11) {
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
