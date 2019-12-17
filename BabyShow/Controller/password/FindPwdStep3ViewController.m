//
//  FindPwdStep3ViewController.m
//  BabyShow
//
//  Created by Mayeon on 14-3-24.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "FindPwdStep3ViewController.h"
#import "LoginViewController.h"

#import "InputCheck.h"
#import "JSONKit.h"
#import "NSString+NSString_MD5.h"


@interface FindPwdStep3ViewController ()
{
    UIButton *doneBtn;
}
@end

@implementation FindPwdStep3ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"找回密码";
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
}

-(void)showHUDWithMessage:(NSString *)message{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(80,65+20+50+50 , 160, 30)];
    label.backgroundColor = [UIColor darkGrayColor];
    label.layer.cornerRadius = 3.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.textColor = [UIColor whiteColor];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [self.view addSubview:label];
    [UIView commitAnimations];
    [self performSelector:@selector(remove:) withObject:label afterDelay:1.0];
    
}
-(void)remove:(UILabel *)label{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [label removeFromSuperview];
    [UIView commitAnimations];
}
-(void)setLeftAndRightBtn{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
    doneBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [doneBtn setTitle:@"确定" forState:UIControlStateNormal];
    [doneBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.frame=backBtnFrame;
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:doneBtn];

    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -15;
    self.navigationItem.rightBarButtonItems = @[spaceItem,right];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)done:(id)sender{
    
    [self resignKeyBoard];
    
    NSString *theNewPwd = theNewTextField.text;
    NSString *repeatPwd = confirmTextField.text;
    if (theNewPwd.length <= 0 || repeatPwd.length <= 0) {
        [self showHUDWithMessage:@"密码不能为空"];
        return;
    }
    
    InputCheck *check = [[InputCheck alloc]init];
    if ( (![check passwordCheck:theNewPwd]) || (![check passwordCheck:repeatPwd])) {
        [self showHUDWithMessage:@"6~16位非中文"];
        return;
    }
    if (![check passwordCompareCheck:theNewPwd withRePeat:repeatPwd]) {
        [self showHUDWithMessage:@"两次密码不一致"];
        return;
    }
    //request
    NSString *url = [NSString stringWithFormat:@"%@%@",kBasicUrlStr,kDoPasswd];
    ASIFormDataRequest *doPasswdRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [doPasswdRequest setPostValue:[NSString stringWithFormat:@"1"] forKey:kDoPasswdDo_type];
    [doPasswdRequest setPostValue:[theNewPwd md5] forKey:kDoPasswdNew_passwd];
    [doPasswdRequest setPostValue:self.email forKey:kDoPasswdEmail];
    doPasswdRequest.delegate = self;
    [doPasswdRequest startAsynchronous];
                                           
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [BBSColor hexStringToColor:@"f9f3f3"];
    [self setLeftAndRightBtn];
    
    CGRect rect = CGRectMake(25, 64+20, 270, 38);
    CGRect rect2 = CGRectMake(25, 64+20+50, 270, 38);
    
    theNewTextField = [[UITextField alloc]initWithFrame:rect];
    theNewTextField.placeholder = @"输入新密码";
    theNewTextField.delegate = self;
    theNewTextField.borderStyle =  UITextBorderStyleRoundedRect;
    [self.view addSubview:theNewTextField];
    [theNewTextField becomeFirstResponder];
    
    confirmTextField = [[UITextField alloc]initWithFrame:rect2];
    confirmTextField.placeholder = @"确认新密码";
    confirmTextField.delegate = self;
    confirmTextField.borderStyle =  UITextBorderStyleRoundedRect;
    [self.view addSubview:confirmTextField];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyBoard)];
    [self.view addGestureRecognizer:tapGes];
}
-(void)resignKeyBoard{
    if ([theNewTextField isFirstResponder]) {
        [theNewTextField resignFirstResponder];
    }
    if ([confirmTextField isFirstResponder]) {
        [confirmTextField resignFirstResponder];
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
    if ([[responseDict objectForKey:@"success"]intValue] == 1) {
        for (UIViewController *temp in self.navigationController.viewControllers) {
            if ([temp isKindOfClass:[LoginViewController class]]) {
                [BBSAlert showAlertWithContent:@"找回密码成功，请登录" andDelegate:nil];
                //退回到进行移动操作的界面
                [self.navigationController popToViewController:temp animated:YES];
            }
        }
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
