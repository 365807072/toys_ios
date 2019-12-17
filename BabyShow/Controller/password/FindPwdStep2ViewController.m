//
//  FindPwdStep2ViewController.m
//  BabyShow
//
//  Created by Mayeon on 14-3-24.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "FindPwdStep2ViewController.h"
#import "FindPwdStep3ViewController.h"

#import "JSONKit.h"


@interface FindPwdStep2ViewController ()
{
    UIButton *nextBtn;
}
@end

@implementation FindPwdStep2ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
}

-(void)showHUDWithMessage:(NSString *)message{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(80,65+20+50 , 160, 30)];
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
    
    nextBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setTitle:@"确定" forState:UIControlStateNormal];
    [nextBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [nextBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(next:) forControlEvents:UIControlEventTouchUpInside];
    nextBtn.frame=backBtnFrame;
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:nextBtn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -15;
    self.navigationItem.rightBarButtonItems = @[spaceItem,right];
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)next:(id)sender{
    [self resignKeyBoard];
    
    FindPwdStep3ViewController *step3ViewController = [[FindPwdStep3ViewController alloc]init];
    step3ViewController.email = self.email;
    [self.navigationController pushViewController:step3ViewController animated:YES];
    return;
    if (verifyCodeTextField.text.length <= 0) {
        [self showHUDWithMessage:@"请输入6位验证码"];
        return;
    }
    if (verifyCodeTextField.text.length != 6) {
        [self showHUDWithMessage:@"验证码为6位数字"];
        return;
    }
    //请求对验证码进行验证
    //requestfinished后push
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kBasicUrlStr,kVerifyCode];
    NSLog(@"验证码验证:%@",url);
    ASIFormDataRequest *verifyCodeRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [verifyCodeRequest setPostValue:self.email forKey:kVerifyCodeEmail];
    [verifyCodeRequest setPostValue:verifyCodeTextField.text forKey:kVerifyCodeSecret];
    verifyCodeRequest.delegate = self;
    [verifyCodeRequest startAsynchronous];

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [BBSColor hexStringToColor:@"f9f3f3"];
    [self setLeftAndRightBtn];
    
    self.title = @"找回密码";
    
    verifyCodeTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 90, 280, 38)];
    verifyCodeTextField.borderStyle = UITextBorderStyleRoundedRect;
    verifyCodeTextField.placeholder = @"输入验证码";
    verifyCodeTextField.keyboardType = UIKeyboardTypeNumberPad;
    verifyCodeTextField.layer.borderWidth = 1;
    verifyCodeTextField.layer.borderColor = [BBSColor hexStringToColor:BACKCOLOR].CGColor;
    [self.view addSubview:verifyCodeTextField];
    [verifyCodeTextField becomeFirstResponder];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyBoard)];
    [self.view addGestureRecognizer:tapGes];
}
-(void)resignKeyBoard{
    if ([verifyCodeTextField isFirstResponder]) {
        [verifyCodeTextField resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - ASIHTTPRequest Methods
-(void)requestStarted:(ASIHTTPRequest *)request{
    nextBtn.enabled = NO;
    [LoadingView startOnTheViewController:self];
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    nextBtn.enabled = YES;
    [LoadingView stopOnTheViewController:self];
    
    NSDictionary *responseDict = [request.responseString objectFromJSONString];
    if ([[responseDict objectForKey:@"success"]intValue] == 1) {
        FindPwdStep3ViewController *step3ViewController = [[FindPwdStep3ViewController alloc]init];
        step3ViewController.email = self.email;
        [self.navigationController pushViewController:step3ViewController animated:YES];
    }else {
        [BBSAlert showAlertWithContent:[responseDict objectForKey:@"reMsg"] andDelegate:nil];
    }
   

}
-(void)requestFailed:(ASIHTTPRequest *)request{
    nextBtn.enabled = YES;
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
}
@end
