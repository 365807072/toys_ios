//
//  ClickViewController.m
//  BabyShow
//
//  Created by Monica on 15-3-20.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ClickViewController.h"
#import "ClickImage.h"

@interface ClickViewController ()

@property (nonatomic ,strong)UIImageView *backImageV;

@end

@implementation ClickViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"说明";
    [self setBackBtn];
    
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    UIImage *image = [UIImage imageNamed:@"img_level_new"];
    CGFloat width = SCREENWIDTH;
    CGFloat height = SCREENHEIGHT;
    CGRect frame = CGRectMake( 0, 0, width , height);
    scrollView.contentSize = CGSizeMake(width, height);
    
    _backImageV = [[UIImageView alloc] initWithFrame:frame];
    _backImageV.image = image;
    // _backImageV.contentMode = UIViewContentModeTopLeft;
    _backImageV.userInteractionEnabled = YES;
    [scrollView addSubview:_backImageV];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideAndBack)];
    [self.view addGestureRecognizer:tapGes];
}
- (void)hideAndBack {
    [ClickImage dismissClickView];
}
- (void)setBackBtn {
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)shouldAutorotate {
    return NO;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.isPushIn) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.isPushIn) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        
    }
}

@end
