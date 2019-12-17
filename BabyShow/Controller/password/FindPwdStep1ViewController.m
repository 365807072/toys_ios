//
//  FindPwdStep1ViewController.m
//  BabyShow
//
//  Created by Mayeon on 14-3-24.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "FindPwdStep1ViewController.h"
#import "FindPwdStep2ViewController.h"

#import "InputCheck.h"
#import "JSONKit.h"

@interface FindPwdStep1ViewController ()
{
    UIButton *nextBtn;
    NSString *email;
}
@end

@implementation FindPwdStep1ViewController

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
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(80,65+30+50+50 , 160, 30)];
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
    email = emailTextField.text;
    if(email.length <= 0){
        [self showHUDWithMessage:@"邮箱不能为空"];
        return;
    }
    InputCheck *inputCheck = [[InputCheck alloc]init];
    if (![inputCheck emailChek:email]) {
        [self showHUDWithMessage:@"邮箱格式不对"];
        return;
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@",kBasicUrlStr,kSendMail];
    NSLog(@"邮箱发送验证码:%@",url);
    ASIFormDataRequest *sendEmailRequest = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    [sendEmailRequest setPostValue:email forKey:kSendMailEmail];
    sendEmailRequest.delegate = self;
    sendEmailRequest.timeOutSeconds = 100;
    [sendEmailRequest startAsynchronous];

    FindPwdStep2ViewController *step2ViewController = [[FindPwdStep2ViewController alloc]init];
    step2ViewController.email = email;
    [self.navigationController pushViewController:step2ViewController animated:YES];

    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [BBSColor hexStringToColor:@"f9f3f3"];
    self.navigationController.navigationBarHidden=NO;

    [self setLeftAndRightBtn];

    emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(20, 90, 280, 38)];
    emailTextField.borderStyle = UITextBorderStyleRoundedRect;
    emailTextField.placeholder = @"输入邮箱";
    emailTextField.layer.borderWidth = 1;
    emailTextField.layer.borderColor = [BBSColor hexStringToColor:BACKCOLOR].CGColor;
    [self.view addSubview:emailTextField];
    [emailTextField becomeFirstResponder];
    
    UILabel *hintLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, 140, 280, 60)];
    hintLabel.numberOfLines = 0;
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.backgroundColor = [UIColor clearColor];
    hintLabel.textColor = [UIColor lightGrayColor];
    hintLabel.text = @"您的邮箱会收到一条含有验证码的邮件,请到邮箱进行确认";
    [self.view addSubview:hintLabel];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(resignKeyBoard)];
    [self.view addGestureRecognizer:tapGes];
}
-(void)resignKeyBoard{
    if ([emailTextField isFirstResponder]) {
        [emailTextField resignFirstResponder];
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
//    [LoadingView startOnTheViewController:self];
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    nextBtn.enabled = YES;
//    [LoadingView stopOnTheViewController:self];
    
    NSDictionary *responseDict = [request.responseString objectFromJSONString];
    NSLog(@"邮箱发送验证码:%@",responseDict);
    if ([[responseDict objectForKey:@"success"]intValue] == 1) {
//        FindPwdStep2ViewController *step2ViewController = [[FindPwdStep2ViewController alloc]init];
//        step2ViewController.email = email;
//        [self.navigationController pushViewController:step2ViewController animated:YES];

    }else {
        [BBSAlert showAlertWithContent:[responseDict  objectForKey:@"reMsg"] andDelegate:nil];
    }
    
    
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    nextBtn.enabled = YES;
    NSLog(@"%@",request.responseString);
//    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
}
@end
