//
//  SubmitOrderViewController.m
//  BabyShow
//
//  Created by WMY on 15/8/28.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "SubmitOrderViewController.h"

@interface SubmitOrderViewController ()

@end

@implementation SubmitOrderViewController
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView *fullImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    fullImageView.image = [UIImage imageNamed:@"img_store_detail"];
    fullImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [fullImageView addGestureRecognizer:tap];
    [tap addTarget:self action:@selector(dismissSelfVC)];
    
    [self.view addSubview:fullImageView];
    // Do any additional setup after loading the view from its nib.
}
-(void)dismissSelfVC{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
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
