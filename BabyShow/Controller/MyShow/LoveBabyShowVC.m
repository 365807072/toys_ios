//
//  LoveBabyShowVC.m
//  BabyShow
//
//  Created by WMY on 16/4/11.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "LoveBabyShowVC.h"
#import "LoveBabyFirstVC.h"
#import "LoveBabySecondVC.h"
#import "BBSCommonNavigationController.h"

@interface LoveBabyShowVC (){
    UISegmentedControl *segment;
    UIScrollView *_scrollView;
    UIView *backView;
}
@property(nonatomic,strong)UIScreenEdgePanGestureRecognizer *screenEdgePan;

@end

@implementation LoveBabyShowVC
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

}

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [BBSColor hexStringToColor:NAVICOLOR];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    if ([self.from isEqualToString:@"FromMain"]) {
        BBSCommonNavigationController *nav = (BBSCommonNavigationController*)self.navigationController;
        nav.isNotGoBack = YES;

    }
    [self setBackBton];
   [self setBttons];
   [self buildScrollView];
}

-(void)setBackBton{
    CGRect backBtnFrame=CGRectMake(0, 0, 10, 17);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.adjustsImageWhenHighlighted = NO;
    
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"babyShow_back"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    

}
-(void)back{
    
    if ([self.from isEqualToString:@"FromMain"]) {
        BBSCommonNavigationController *nav = (BBSCommonNavigationController*)self.navigationController;
        nav.isNotGoBack = NO;

        [self.navigationController popToRootViewControllerAnimated:YES];
    }
        [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)buildScrollView{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor =  [BBSColor hexStringToColor:@"f5f5f5"];
    _scrollView.frame = CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT);
    _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH*2,SCREEN_HEIGHT);
    _scrollView.pagingEnabled = YES;
    _scrollView.scrollEnabled = NO;
    [self.view addSubview:_scrollView];
    //这是第一个秀秀
    LoveBabySecondVC *loveBabySecondVC = [[LoveBabySecondVC alloc]init];
    loveBabySecondVC.view.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    if ([self.from isEqualToString:@"FromMain"]) {
        loveBabySecondVC.from = @"FromMain";
    }
    [self addChildViewController:loveBabySecondVC];
    [_scrollView addSubview:loveBabySecondVC.view];
    
    //这是萌宝
    LoveBabyFirstVC *loveBabyFirstVC = [[LoveBabyFirstVC alloc]init];
    loveBabyFirstVC.view.frame = CGRectMake(SCREENWIDTH, 0, SCREENWIDTH, SCREENHEIGHT);
    [self addChildViewController:loveBabyFirstVC];
    [_scrollView addSubview:loveBabyFirstVC.view];
    if (_isBaby ==YES) {
        [_showBtn setTitleColor:[BBSColor hexStringToColor:@"333333"] forState:UIControlStateNormal];
        [_babyBtn setTitleColor:[BBSColor hexStringToColor:@"ff6d6d"] forState:UIControlStateNormal];
        _babyBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _showBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width, 0) animated:YES];

    }
}

-(void)setBttons{
    backView = [[UIView alloc]initWithFrame:CGRectMake((SCREENWIDTH-100)/2, 0, 100, 22)];
    self.navigationItem.titleView = backView;
    _showBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _showBtn.frame = CGRectMake(0,-3 , 50, 30);
    [_showBtn setTitle:@"秀秀" forState:UIControlStateNormal];
    _showBtn.tag = 101;
    [_showBtn setTitleColor:[BBSColor hexStringToColor:@"ff6d6d"] forState:UIControlStateNormal];
    _showBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [backView addSubview:_showBtn];
    
    _babyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    _babyBtn.frame = CGRectMake(50,-3, 50, 30);
    [_babyBtn setTitle:@"萌宝" forState:UIControlStateNormal];
    _babyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _babyBtn.tag = 102;
    [_babyBtn setTitleColor:[BBSColor hexStringToColor:@"333333"] forState:UIControlStateNormal];
    [backView addSubview:_babyBtn];
    [_showBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [_babyBtn addTarget:self action:@selector(changeBtn:) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)changeBtn:(id)sender{
    UIButton *button = (id)sender;
    if (button.tag==101) {
        [_showBtn setTitleColor:[BBSColor hexStringToColor:@"ff6d6d"] forState:UIControlStateNormal];
        [_babyBtn setTitleColor:[BBSColor hexStringToColor:@"333333"] forState:UIControlStateNormal];
        _babyBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _showBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
 
    }else{
        [_showBtn setTitleColor:[BBSColor hexStringToColor:@"333333"] forState:UIControlStateNormal];
        [_babyBtn setTitleColor:[BBSColor hexStringToColor:@"ff6d6d"] forState:UIControlStateNormal];
        _babyBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _showBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_scrollView setContentOffset:CGPointMake(_scrollView.bounds.size.width, 0) animated:YES];
    }
    
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
