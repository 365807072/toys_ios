//
//  ModifyPasswordViewController.m
//  BabyShow
//
//  Created by Mayeon on 14-3-21.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ModifyPasswordViewController.h"

#import "InputCheck.h"
#import "JSONKit.h"
#import "NSString+NSString_MD5.h"

@interface ModifyPasswordViewController ()
{
    UIButton *doneBtn;
}
@end

@implementation ModifyPasswordViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.title=@"修改密码";
        
    }
    return self;
}
-(void)setLeftAndRightBtn{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
    doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [doneBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.frame=backBtnFrame;
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    self.navigationItem.rightBarButtonItem=right;
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)done:(id)sender{
    
    [self resignKeyboard:nil];
    
    NSString *oldString = self.theOldPwdTextField.text;
    NSString *thenewpwd = self.theNewPwdTextField.text;
    NSString *repeatpwd = self.confirmPwdTextField.text;
    if (oldString.length<=0) {
        //show message
        [self showHUDWithMessage:@"旧密码不能为空"];
        self.theOldPwdTextField.layer.borderColor = [BBSColor hexStringToColor:BACKCOLOR].CGColor;
        self.theOldPwdTextField.layer.borderWidth = 1;
        return;
    }
    if (thenewpwd.length<=0) {
        //show message
        [self showHUDWithMessage:@"新密码不能为空"];
        self.theNewPwdTextField.layer.borderColor = [BBSColor hexStringToColor:BACKCOLOR].CGColor;
        self.theNewPwdTextField.layer.borderWidth = 1;
        return;
    }
    if (repeatpwd.length<=0) {
        //show message
        [self showHUDWithMessage:@"确认密码不能为空"];
        self.confirmPwdTextField.layer.borderColor = [BBSColor hexStringToColor:BACKCOLOR].CGColor;
        self.confirmPwdTextField.layer.borderWidth = 1;
        return;
    }

    InputCheck *inputCheck = [[InputCheck alloc]init];
    if (!([inputCheck passwordCheck:oldString] && [inputCheck passwordCheck:thenewpwd] && [inputCheck passwordCheck:repeatpwd])) {
        [self showHUDWithMessage:@"6~16位非中文"];
        return;
    }
    if ([inputCheck passwordCompareCheck:oldString withRePeat:thenewpwd]) {
        [self showHUDWithMessage:@"新密码与原密码一致"];
        return;
    }
    if (![inputCheck passwordCompareCheck:thenewpwd withRePeat:repeatpwd]) {
        [self showHUDWithMessage:@"两次密码不一致"];
        return;
    }
    
    
    //request MD5
    NSString *user_id = LOGIN_USER_ID;
    NSString *url = [NSString stringWithFormat:@"%@%@",kBasicUrlStr,kDoPasswd];
    NSLog(@"修改密码:%@",url);
    ASIFormDataRequest *doPasswdRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [doPasswdRequest setPostValue:[NSString stringWithFormat:@"0"] forKey:kDoPasswdDo_type];
    [doPasswdRequest setPostValue:[thenewpwd md5] forKey:kDoPasswdNew_passwd];
    [doPasswdRequest setPostValue:[oldString md5] forKey:kDoPasswdOld_passwd];
    [doPasswdRequest setPostValue:user_id forKey:kDoPasswdUser_id];
    doPasswdRequest.delegate = self;
    [doPasswdRequest startAsynchronous];
    
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setLeftAndRightBtn];
    self.view.backgroundColor = [BBSColor hexStringToColor:@"f9f3f3"];
    
    CGRect rect = CGRectMake(25, 64+20, 270, 38);
    CGRect rect2 = CGRectMake(25, 64+20+50, 270, 38);
    CGRect rect3 = CGRectMake(25, 64+20+50+50, 270, 38);
    
    self.theOldPwdTextField = [[UITextField alloc]initWithFrame:rect];
    self.theOldPwdTextField.placeholder = @"输入旧密码";
    self.theOldPwdTextField.delegate = self;
    self.theOldPwdTextField.borderStyle =  UITextBorderStyleRoundedRect;
    [self.view addSubview:self.theOldPwdTextField];
    
    self.theNewPwdTextField = [[UITextField alloc]initWithFrame:rect2];
    self.theNewPwdTextField.placeholder = @"输入新密码6~16个字母或数字";
    self.theNewPwdTextField.delegate = self;
    self.theNewPwdTextField.borderStyle =  UITextBorderStyleRoundedRect;
    [self.view addSubview:self.theNewPwdTextField];
    
    self.confirmPwdTextField = [[UITextField alloc]initWithFrame:rect3];
    self.confirmPwdTextField.placeholder = @"确认新密码";
    self.confirmPwdTextField.delegate = self;
    self.confirmPwdTextField.borderStyle =  UITextBorderStyleRoundedRect;
    [self.view addSubview:self.confirmPwdTextField];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyboard:)];
    [self.view addGestureRecognizer:tapGes];
}
-(void)resignKeyboard:(UITapGestureRecognizer *)tapGes{
    for (id subview in self.view.subviews) {
        if ([subview isFirstResponder]) {
            [subview resignFirstResponder];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextFieldDelegate Methods
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.layer.borderColor = [BBSColor hexStringToColor:BACKCOLOR].CGColor;
    textField.layer.borderWidth = 1;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    textField.layer.borderColor = nil;
    textField.layer.borderWidth = 0;
}
#pragma mark - ASIHTTPRequest Methods
-(void)requestStarted:(ASIHTTPRequest *)request{
    doneBtn.enabled = NO;
    [LoadingView startOnTheViewController:self];
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    doneBtn.enabled = YES;
    [LoadingView stopOnTheViewController:self];
    
    NSDictionary *responseDict = [request.responseString objectFromJSONString];
    NSLog(@"dict:%@",responseDict);
    if ([[responseDict objectForKey:@"success"]intValue] == 1) {
       [BBSAlert showAlertWithContent:@"密码修改成功" andDelegate:nil];
        [self.navigationController popViewControllerAnimated:YES];
    }else {
        [BBSAlert showAlertWithContent:[responseDict objectForKey:@"reMsg"] andDelegate:nil];
    }
    
    
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    doneBtn.enabled = YES;
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
}
@end
