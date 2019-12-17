//
//  RegisterStep1VC.m
//  BabyShow
//
//  Created by WMY on 15/12/9.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "RegisterStep1VC.h"
#import <SMS_SDK/SMSSDK.h>
//#import <SMS_SDK/SMSSDKCountryAndAreaCode.h>
//#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
//#import <SMS_SDK/SMSSDK+ExtexdMethods.h>
#import <MOBFoundation/MOBFoundation.h>
#import "InputCheck.h"
#import "RegisterStep2ViewController.h"

@interface RegisterStep1VC (){
    UIScrollView *_scrollView;
    UIView *back1;
    UIView *back2;
    BaseLabel *labelStep1;
    BaseLabel *labelStep2;
    BaseLabel *labelStep3;
    BaseImageView *imgStep1;
    BaseImageView *imgStep2;
    BaseImageView *imgStep3;
    YLButton *sumbitBtn;
    UITextField *phoneNumberTextField;
    YLButton *sendBtn;
    UITextField *phoneCodeTextField;
    UITextField *firstPassWordTF;
    UITextField *secondPasswordTF;
    NSTimer* _timer2;
    int count;

}

@end

@implementation RegisterStep1VC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
     }
    
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden=NO;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
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
    cateName.text = @"注册";
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
    
    
    back2 = [[UIView alloc]initWithFrame:CGRectMake(0, 15, SCREENWIDTH, 80)];
    back2.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
    [_scrollView addSubview:back2];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
    line1.backgroundColor = [BBSColor hexStringToColor:@"e5e5e5"];
    [back2 addSubview:line1];
    
    phoneNumberTextField= [[UITextField alloc]initWithFrame:CGRectMake(15, 10, 200, 17)];
    phoneNumberTextField.placeholder = @"请输入您的手机号码";
    phoneNumberTextField.font = [UIFont systemFontOfSize:13];
    phoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneNumberTextField.borderStyle = UITextBorderStyleNone;
    phoneNumberTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    phoneNumberTextField.delegate = self;
    [back2 addSubview:phoneNumberTextField];
    //[UIImage imageNamed:@"btn_changephone_sends"]
    
    sendBtn = [YLButton buttonEasyInitBackColor:nil frame:CGRectMake(SCREENWIDTH-103, phoneNumberTextField.frame.origin.y-5, 85, 30) type:UIButtonTypeSystem backImage:nil target:self action:@selector(sendPhoneNumber) forControlEvents:UIControlEventTouchUpInside];
    [sendBtn.layer setMasksToBounds:YES];
    [sendBtn.layer setCornerRadius:6.0];
    [sendBtn.layer setBorderWidth:1.0];
    [sendBtn.layer setBorderColor:[BBSColor hexStringToColor:@"fe6161"].CGColor];
     [back2 addSubview:sendBtn];
    
    [sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    sendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [sendBtn setTitleColor:[BBSColor hexStringToColor:@"fe6161"] forState:UIControlStateNormal];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 0.5)];
    line2.backgroundColor = [BBSColor hexStringToColor:@"e5e5e5"];
    [back2 addSubview:line2];
    
    phoneCodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(15,50, 290, 17)];
    phoneCodeTextField.placeholder = @"请输入手机短信中的验证码";
    phoneCodeTextField.font = [UIFont systemFontOfSize:13];
    phoneCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    phoneCodeTextField.borderStyle = UITextBorderStyleNone;
    phoneCodeTextField.delegate = self;
    [back2 addSubview:phoneCodeTextField];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(0, 79.5, SCREENWIDTH, 0.5)];
    line3.backgroundColor = [BBSColor hexStringToColor:@"e5e5e5"];
    [back2 addSubview:line3];
    
    back1 = [[UIView alloc]initWithFrame:CGRectMake(0, back2.frame.origin.y+80+15, SCREENWIDTH, 80)];
    back1.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
    [_scrollView addSubview:back1];
    
    firstPassWordTF= [[UITextField alloc]initWithFrame:CGRectMake(15, 10, 200, 20)];
    firstPassWordTF.placeholder = @"请输入密码6~16个字母或数字哦";
    firstPassWordTF.font = [UIFont systemFontOfSize:13];
    firstPassWordTF.borderStyle = UITextBorderStyleNone;
    firstPassWordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    firstPassWordTF.delegate = self;
    firstPassWordTF.secureTextEntry = YES;
    [back1 addSubview:firstPassWordTF];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 39.5, SCREENWIDTH, 1)];
    lineView.backgroundColor = [BBSColor hexStringToColor:@"e5e5e5"];
    [back1 addSubview:lineView];
    
    secondPasswordTF= [[UITextField alloc]initWithFrame:CGRectMake(15, 50, 200, 20)];
    secondPasswordTF.placeholder = @"再次确认密码";
    secondPasswordTF.font = [UIFont systemFontOfSize:13];
    secondPasswordTF.borderStyle = UITextBorderStyleNone;
    secondPasswordTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    secondPasswordTF.delegate = self;
    secondPasswordTF.secureTextEntry = YES;
    [back1 addSubview:secondPasswordTF];
    
    
    sumbitBtn = [YLButton buttonEasyInitBackColor:[BBSColor hexStringToColor:@"fe6161"] frame:CGRectMake(15, back1.frame.origin.y+back1.frame.size.height+13, 285, 35) type:UIButtonTypeSystem backImage:nil target:self action:@selector(sumbitCode) forControlEvents:UIControlEventTouchUpInside];
    sumbitBtn.layer.masksToBounds = YES;
    sumbitBtn.layer.cornerRadius = 17;
    [sumbitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_scrollView addSubview:sumbitBtn];
    
    _scrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [_scrollView addGestureRecognizer:singleTap];
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
                                              cancelButtonTitle:NSLocalizedString(@"sure", nil)
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
    NSString *phoneString = phoneNumberTextField.text;
   
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneString
                                   zone:@"86"
                                   template:nil
                                 result:^(NSError *error)
     {
         
         if (!error)
         {
             [LoadingView stopOnTheViewController:self];
             [BBSAlert showAlertWithContent:@"发送验证码成功" andDelegate:self andDismissAnimated:1];
             
         }
         else
         {
             [LoadingView stopOnTheViewController:self];
             UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示信息", nil)
                                                             message:[NSString stringWithFormat:@"错误描述：%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                            delegate:self
                                                   cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                   otherButtonTitles:nil, nil];
             [alert show];
         }
         
     }];
    
}
//提交
-(void)sumbitCode{
    NSLog(@"1111111111111111111");
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
        InputCheck *inputCheck=[[InputCheck alloc]init];
        NSString *firstPassWord = firstPassWordTF.text;
        NSString *secondePassWord = secondPasswordTF.text;
        if (firstPassWord.length <= 0) {
            sumbitBtn.enabled = YES;

            [self showHUDWithMessage:@"设置密码不能为空"];
        }
        if (secondePassWord.length <= 0) {
            sumbitBtn.enabled = YES;

            [self showHUDWithMessage:@"确认密码不能为空"];
            
            
        }
        if (![inputCheck passwordCheck:firstPassWord]) {
            sumbitBtn.enabled = YES;

            [BBSAlert showAlertWithContent:@"请输入正确格式的密码哦：6~16个字母或数字" andDelegate:self];
            return;
        }
        if (![inputCheck passwordCompareCheck:firstPassWord withRePeat:secondePassWord]) {
            [self showHUDWithMessage:@"两次密码不一致"];
            sumbitBtn.enabled = YES;

            firstPassWordTF.text = nil;
            secondPasswordTF.text = nil;
            return;
        }

        [SMSSDK commitVerificationCode:phoneCodeTextField.text phoneNumber:phoneNumberTextField.text zone:@"86" result:^(NSError *error) {
            if (!error) {
                //sumbitBtn.enabled = YES;

                NSLog(@"成功成功啦");
                [self registerData];
                
            }
            else
            {
                sumbitBtn.enabled = YES;

                NSLog(@"验证失败失败啦");

                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                                message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]]
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}
-(void)registerData{
    NSString *firstPassWord = firstPassWordTF.text;
    NSString *secondePassWord = secondPasswordTF.text;
    NSUserDefaults *defaultlat = [NSUserDefaults standardUserDefaults];
    NSString *lat = [defaultlat valueForKey:@"latitude"];
    NSUserDefaults *defaultlog = [NSUserDefaults standardUserDefaults];
    NSString *longitude = [defaultlog valueForKey:@"longitude"];
    NSMutableDictionary *param;
    if (!lat||!longitude) {
        param=[NSMutableDictionary dictionaryWithObjectsAndKeys:
               [firstPassWord md5] ,kRegistPassword,[secondePassWord md5],@"confirm_password",phoneNumberTextField.text,@"mobile",@"",@"mapsign",nil];
        
    }else{
        param=[NSMutableDictionary dictionaryWithObjectsAndKeys:
               [firstPassWord md5] ,kRegistPassword,[secondePassWord md5],@"confirm_password",phoneNumberTextField.text,@"mobile",[NSString stringWithFormat:@"%@,%@",lat,longitude],@"mapsign",nil];
    }
    [[HTTPClient sharedClient]postNew:kRegistMobile params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *dataDic = [result objectForKey:kBBSData];
            UserInfoItem *item = [[UserInfoItem alloc]init];
            item.avatarStr = [dataDic objectForKey:@"avatar"];
            item.email = [dataDic objectForKey:@"email"];
            item.nickname = [dataDic objectForKey:@"nick_name"];
            item.userId = [dataDic objectForKey:@"user_id"];
            item.isVisitor = [NSNumber numberWithBool:NO];
            UserInfoManager *manager = [[UserInfoManager alloc]init];
            [manager saveUserInfo:item];
            [self gotoAddAChild];
            
        }else{
            phoneCodeTextField.text = nil;
            firstPassWordTF.text = nil;
            secondPasswordTF.text = nil;
            [sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            sendBtn.enabled = YES;
            [_timer2 invalidate];
            // [sendBtn setImage:[UIImage imageNamed:@"btn_more_getcode"] forState:UIControlStateNormal];
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        phoneCodeTextField.text = nil;
        firstPassWordTF.text = nil;
        secondPasswordTF.text = nil;
        //[sendBtn setImage:[UIImage imageNamed:@"btn_more_getcode"] forState:UIControlStateNormal];
        [sendBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        sendBtn.enabled = YES;
        [_timer2 invalidate];
        [BBSAlert showAlertWithContent:@"网络错误请稍后重试" andDelegate:nil];
        
        
    }];


}
-(void)gotoAddAChild{
    
    [MobClick event:UMEVENTLOGIN];
    [MobClick event:UMEVENTREGISTER];
    
    [LoadingView stopOnTheViewController:self];
    
    RegisterStep2ViewController *step2=[[RegisterStep2ViewController alloc]init];
    step2.Type=0;
    [self.navigationController pushViewController:step2 animated:YES];
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [_scrollView endEditing:YES];
    
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
  
    if ([string isEqualToString:@""]) {//这个是判断删除键的时候返回的是yes还是NO，因为点击删除键时String返回的是空字符串
        return YES;
    }
    if (textField == phoneNumberTextField) {
        if (phoneNumberTextField.text.length >= 11) {
            return NO;
        }
    }
    if (textField == phoneCodeTextField) {
        if (phoneCodeTextField.text.length >= 4) {
            return NO;
        }
        
    }
    if (textField == firstPassWordTF) {
        if (firstPassWordTF.text.length >= 16) {
            return NO;
        }
    }
    if (textField == secondPasswordTF) {
        if (secondPasswordTF.text.length >= 16) {
            return NO;
        }
    }
    return YES;
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
