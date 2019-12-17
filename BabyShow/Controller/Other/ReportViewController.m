//
//  ReportViewController.m
//  BabyShow
//
//  Created by Lau on 14-1-10.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ReportViewController.h"

@interface ReportViewController ()

@end


@implementation ReportViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.imgId=[[NSString alloc]init];
        self.title=@"举报";
                
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    self.navigationController.navigationBarHidden=NO;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.contentView =[[UITextView alloc]initWithFrame:CGRectMake(10, 74, 300, 120)];
    self.contentView.layer.borderColor=[UIColor grayColor].CGColor;
    self.contentView.font=[UIFont systemFontOfSize:14];
    self.contentView.layer.borderWidth=0.5;
    self.contentView.layer.cornerRadius=5;
    self.contentView.keyboardType=UIKeyboardTypeDefault;
    self.contentView.delegate=self;
    [self.view addSubview:self.contentView];
    
    
    UIButton *sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn addTarget:self action:@selector(report) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.frame=CGRectMake(0, 0, 40, 33);
    [sendBtn setTitle:@"确定" forState:UIControlStateNormal];
    [sendBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [sendBtn setTitleColor:[BBSColor hexStringToColor:@"c479dd"] forState:UIControlStateNormal];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchOnTheView)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportSucceed) name:USER_REPORT_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reportFail:) name:USER_REPORT_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)touchOnTheView{
    
    [self.contentView resignFirstResponder];
    
}

-(void)report{
    
    [self.contentView resignFirstResponder];
    
    [LoadingView startOnTheViewController:self];
    [self performSelector:@selector(disappear) withObject:self afterDelay:1.5];
    
//    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
//    NSString *loginUserId=[userDefault objectForKey:USERID];
//    
//    NSMutableDictionary *param=[[NSMutableDictionary alloc]init];
//    [param setObject:self.imgId forKey:@"img_id"];
//    [param setObject:loginUserId forKey:@"user_id"];
//    
//    if (self.contentView.text.length) {
//        
//        [param setObject:self.contentView.text forKey:@"remark"];
//        
//    }
//    
//    
//    NetAccess *net=[NetAccess sharedNetAccess];
//    [net getDataWithStyle:NetStyleRePort andParam:param];
//    [LoadingView startOnTheViewController:self];
//    
//    NSLog(@"report");
    
}


-(void)textViewDidChange:(UITextView *)textView{
    
    
    [textView flashScrollIndicators];   // 闪动滚动条
    
    CGRect frame = textView.frame;
    CGSize constraintSize = CGSizeMake(frame.size.width, MAXFLOAT);
    CGSize size = [textView sizeThatFits:constraintSize];
    
    if(size.height>120 && size.height<260){
        
        textView.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, size.height);
        
    }
    
}



-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView.text.length>=140) {
        return NO;
    }
    return YES;
}


-(void)reportSucceed{
    
    [LoadingView stopOnTheViewController:self];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)reportFail:(NSNotification *) not{
    [LoadingView stopOnTheViewController:self];
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
}

-(void)netFail{
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:self];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)disappear{
    
    [LoadingView stopOnTheViewController:self];
    [self.navigationController popViewControllerAnimated:YES];

}

@end
