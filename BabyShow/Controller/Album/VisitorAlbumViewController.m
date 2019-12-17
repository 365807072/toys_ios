//
//  VisitorAlbumViewController.m
//  BabyShow
//
//  Created by Lau on 6/4/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "VisitorAlbumViewController.h"

@interface VisitorAlbumViewController ()

@end

@implementation VisitorAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    UIImageView *anouceView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-40)];
    anouceView.image=[UIImage imageNamed:@"img_myshow_emptybaby"];
    [self.view addSubview:anouceView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 227, 300, 30)];
    label.text=@"游客不能使用这里哟！";
    label.textAlignment=NSTextAlignmentCenter;
    label.font=[UIFont systemFontOfSize:17];
    label.textColor=[BBSColor hexStringToColor:@"c6a886"];
    //[self.view addSubview:label];
    
    UIButton *loginBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    loginBtn.frame=CGRectMake(SCREENWIDTH-220, SCREENHEIGHT-40-50, 144, 25);
    [loginBtn setImage:[UIImage imageNamed:@"btn_visitor_album_login"] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(jumpToTheLoginView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];

}

-(void)jumpToTheLoginView{
    
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    [manager removeCurrentUserInfo];
    
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [delegate setStartViewController];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}
@end
