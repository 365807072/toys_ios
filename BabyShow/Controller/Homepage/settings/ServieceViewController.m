//
//  ServieceViewController.m
//  BabyShow
//
//  Created by Lau on 14-1-17.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ServieceViewController.h"

@interface ServieceViewController ()

@end

@implementation ServieceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.title=@"服务条款";
        // Custom initialization
    }
    return self;
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

    
    NSString *path=[[NSBundle mainBundle] pathForResource:@"Service" ofType:@"txt"];
    NSString *content=[[NSString alloc]initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];

    UITextView *textView=[[UITextView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    textView.text=content;
    textView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    [textView setEditable:NO];
    [self.view addSubview:textView];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
