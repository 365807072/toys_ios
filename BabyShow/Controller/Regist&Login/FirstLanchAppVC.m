//
//  FirstLanchAppVC.m
//  BabyShow
//
//  Created by WMY on 15/11/9.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "FirstLanchAppVC.h"


@interface FirstLanchAppVC ()
{
    UIScrollView *scrollView;
}
@property(nonatomic,strong)UIButton *enterButton;

@end

@implementation FirstLanchAppVC
-(void)viewWillAppear:(BOOL)animated{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    scrollView.contentSize=CGSizeMake(SCREENWIDTH,0);//设置大小
    scrollView.pagingEnabled = YES;
    scrollView.showsHorizontalScrollIndicator = NO;//水平是否有滚动条

    scrollView.bounces = NO;//是否有回弹
    scrollView.delegate = self;//代理设置
    [self.view addSubview:scrollView];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,-20,SCREENWIDTH,SCREENHEIGHT)];
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(pushNextPic:)];
        imageView.tag = 0;
        [imageView addGestureRecognizer:tap];
        
        if (SCREENWIDTH==320 && SCREENHEIGHT==480 ) {
            imageView.image = [UIImage imageNamed :[NSString stringWithFormat:@"img_firstLanch_4_1"]];
        }else if (SCREENWIDTH==320 && SCREENHEIGHT==568){
            imageView.image = [UIImage imageNamed :[NSString stringWithFormat:@"img_firstLanch_5_1"]];
        }else if(SCREENWIDTH==375 && SCREENHEIGHT==667){
            imageView.image = [UIImage imageNamed :[NSString stringWithFormat:@"img_firstLanch_6_1"]];
        }else if(SCREENWIDTH==414 && SCREENHEIGHT==736){
            imageView.image = [UIImage imageNamed :[NSString stringWithFormat:@"img_firstLanch_6p_1"]];
        }else{
            imageView.image = [UIImage imageNamed :[NSString stringWithFormat:@"img_firstLanch_6_1"]];
        }
        
        [scrollView addSubview:imageView];
    
    _enterButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _enterButton.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
   [_enterButton addTarget:self action:@selector(pushStartVC) forControlEvents:UIControlEventTouchUpInside];
    [_enterButton.layer setMasksToBounds:YES];
    [scrollView addSubview:_enterButton];


    
}
-(void)pushNextPic:(UITapGestureRecognizer*)sender{
    UIView *aView = (UIView*)sender.view;
    NSInteger tag = aView.tag+1;
   
    [scrollView setContentOffset:CGPointMake(tag*320, 0) animated:YES];
}
-(void)pushStartVC{
    NSString *latitude = [[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"];
    NSString *longitude = [[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"];
    NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NSParameterAssert([reach isKindOfClass:[Reachability class]]);
    NetworkStatus stats = [reach currentReachabilityStatus];
    if (stats == NotReachable) {
    [BBSAlert showAlertWithContent:@"您似乎与网络断开，检查一下网络设置" andDelegate:self];
        
    }else{
        //注册游客请求
        NetAccess *net=[NetAccess sharedNetAccess];
        NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:identifierForVendor,@"imin",[NSString stringWithFormat:@"%@,%@",latitude,longitude],@"mapsign",nil];
        [net getDataWithStyle:NetStyleVisitorRegist andParam:param];

    }

}
-(void)netError{

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
