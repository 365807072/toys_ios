
//
//  WorthBuyPublishViewController.m
//  BabyShow
//
//  Created by Monica on 14-12-18.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "WorthBuyPublishViewController.h"

@interface WorthBuyPublishViewController ()<UITextViewDelegate>
//商品链接,推荐理由
@property (nonatomic ,strong)UILabel *shopLinkLabel;
@property (nonatomic ,strong)UILabel *shopReasonLabel;
@property (nonatomic ,strong)UITextView *linkTextView;
@property (nonatomic ,strong)UITextView *reasonTextView;
@property (nonatomic ,strong)UILabel *hint1Label;
@property (nonatomic ,strong)UILabel *hint2Label;
@property (nonatomic ,strong)UIView *seperatorView;
@property (nonatomic ,strong)UIView *seperator1View;
@property (nonatomic ,strong)UIView *seperator2View;
@property (nonatomic ,strong)UIButton *submitBtn;

@end

@implementation WorthBuyPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐";
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_tableview_background.png"]];
    [self setBackBtn];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 155)];
    backgroundView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backgroundView];
    
    CGRect linkLabelFrame = CGRectMake(7.5, 75, SCREENWIDTH-15, 25);
    CGRect linkTextViewFrame = CGRectMake(17.5, 100, SCREENWIDTH-35, 38);
    CGRect hint1LabelFrame = CGRectMake(20, 101.5, SCREENWIDTH-35, 34);
    CGRect seperator1Frame = CGRectMake(15, 139, SCREENWIDTH-30, 0.5);

    CGRect reasonLabelFrame = CGRectMake(7.5, 145, SCREENWIDTH-15, 25);
    CGRect reasonTextViewFrame = CGRectMake(17.5, 170, SCREENWIDTH-35, 38);
    CGRect hint2LabelFrame = CGRectMake(20, 171.5, SCREENWIDTH-35, 34);
    CGRect seperator2Frame = CGRectMake(15, 209, SCREENWIDTH-30, 0.5);

    CGRect seperatorFrame = CGRectMake(0, 219, SCREENWIDTH, 0.7);
    CGRect submitFrame = CGRectMake(0, 0, 49, 31);
    
    self.shopLinkLabel = [[UILabel alloc]initWithFrame:linkLabelFrame];
    _shopLinkLabel.text = @" 商品链接";
    _shopLinkLabel.font = [UIFont boldSystemFontOfSize:17];
    _shopLinkLabel.textColor = [BBSColor hexStringToColor:@"e9635e"];
    [self.view addSubview:_shopLinkLabel];
    
    self.shopReasonLabel = [[UILabel alloc]initWithFrame:reasonLabelFrame];
    _shopReasonLabel.text = @" 推荐理由";
    _shopReasonLabel.font = [UIFont boldSystemFontOfSize:17];
    _shopReasonLabel.textColor = [BBSColor hexStringToColor:@"e9635e"];
    [self.view addSubview:_shopReasonLabel];
    
    self.hint1Label = [[UILabel alloc]initWithFrame:hint1LabelFrame];
    _hint1Label.text = @"优惠商品购买链接";
    _hint1Label.font = [UIFont systemFontOfSize:16.0];
    _hint1Label.textColor = [BBSColor hexStringToColor:@"9d9d9d"];
    [self.view addSubview:_hint1Label];
    
    self.hint2Label = [[UILabel alloc]initWithFrame:hint2LabelFrame];
    _hint2Label.text = @"请输入推荐理由";
    _hint2Label.font = [UIFont systemFontOfSize:16.0];
    _hint2Label.textColor = [BBSColor hexStringToColor:@"9d9d9d"];
    [self.view addSubview:_hint2Label];
    
    self.linkTextView = [[UITextView alloc]initWithFrame:linkTextViewFrame];
    _linkTextView.backgroundColor = [UIColor clearColor];
    _linkTextView.font = [UIFont systemFontOfSize:16];
    _linkTextView.delegate = self;
    _linkTextView.textColor = [BBSColor hexStringToColor:@"#2a2a2a"];
    [self.view addSubview:_linkTextView];
    
    self.reasonTextView = [[UITextView alloc]initWithFrame:reasonTextViewFrame];
    _reasonTextView.backgroundColor = [UIColor clearColor];
    _reasonTextView.font = [UIFont systemFontOfSize:16];
    _reasonTextView.delegate = self;
    _reasonTextView.textColor = [BBSColor hexStringToColor:@"#2a2a2a"];
    [self.view addSubview:_reasonTextView];
    
    self.seperatorView = [[UIView alloc]initWithFrame:seperatorFrame];
    _seperatorView.backgroundColor = [BBSColor hexStringToColor:@"adadad"];
    [self.view addSubview:_seperatorView];
    
    self.seperator1View = [[UIView alloc]initWithFrame:seperator1Frame];
    _seperator1View.backgroundColor = [BBSColor hexStringToColor:@"adadad"];
    [self.view addSubview:_seperator1View];
    
    self.seperator2View = [[UIView alloc]initWithFrame:seperator2Frame];
    _seperator2View.backgroundColor = [BBSColor hexStringToColor:@"adadad"];
    [self.view addSubview:_seperator2View];
    
    self.submitBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _submitBtn.frame = submitFrame;
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _submitBtn.titleLabel.font=[UIFont systemFontOfSize:15.8];
    [_submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithCustomView:_submitBtn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -15;
    
    self.navigationItem.rightBarButtonItems = @[spaceItem,rightItem];

}
-(void)setBackBtn{
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
-(void)back{
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}
#pragma mark - 提交
- (void)submit {
    NSString *good_url = _linkTextView.text;
    NSString *reason = _reasonTextView.text;
    
    if (good_url.length <= 0) {
        [BBSAlert showAlertWithContent:@"请填写商品链接" andDelegate:nil];
        return;
    }
    if (reason.length <= 0) {
        [BBSAlert showAlertWithContent:@"请填写推荐理由" andDelegate:nil];
        return;
    }
    
    NSString *user_id = LOGIN_USER_ID;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:good_url,kWorthBuyImageNewGood_url,reason,kWorthBuyImageNewReason,user_id,kWorthBuyImageNewUser_id, nil];
    [LoadingView startOnTheViewController:self];
    [[NetAccess sharedNetAccess]getDataWithStyle:NetStylePostBarAddTopicWorthBuy andParam:params];

}
#pragma mark - 
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:@"WorthBuyPublish"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(succeed) name:USER_PUBLISH_WORTHBUY_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fail:) name:USER_PUBLISH_WORTHBUY_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"WorthBuyPublish"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
   
    if (textView == _linkTextView) {
        if (textView.text.length > 0) {
            _hint1Label.hidden = YES;
        } else {
            _hint1Label.hidden = NO;
        }
    } else if (textView == _reasonTextView) {
        if (textView.text.length > 0) {
            _hint2Label.hidden = YES;
        } else {
            _hint2Label.hidden = NO;
        }
    }
}
#pragma mark - NSNotification
- (void)succeed {
    [LoadingView stopOnTheViewController:self];
    [self showHUDWithMessage:@"推荐成功,请等待系统审核"];
    
    [self performSelector:@selector(disappear) withObject:nil afterDelay:2];
    
}
- (void)fail:(NSNotification *)noti {
    [LoadingView stopOnTheViewController:self];
    NSString *reMsg = [noti object];
    [BBSAlert showAlertWithContent:reMsg andDelegate:nil];
}
- (void)netFail {
    
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:@"网络连接失败,请重试" andDelegate:nil];
}
#pragma mark HUD

-(void)showHUDWithMessage:(NSString *)message{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60,64+20+50+50+50+50 , 200, 30)];
    label.backgroundColor = [UIColor darkGrayColor];
    label.layer.cornerRadius = 3.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:13];
    label.alpha=0.5;
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

-(void)disappear{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
