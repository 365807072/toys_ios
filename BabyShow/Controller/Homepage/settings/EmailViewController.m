//
//  EmailViewController.m
//  BabyShow
//
//  Created by Lau on 14-2-18.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "EmailViewController.h"

@interface EmailViewController ()

@end

@implementation EmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        dataArray=[[NSMutableArray alloc]init];
        self.title=@"联系我们";
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.view.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
    [dataArray addObject:@"自由环球租赁旅行网"];
//    [dataArray addObject:@"官 方 网 站：  http://baobaoshowshow.com/"];
//    [dataArray addObject:@"邮         箱:     service@baobaoshowshow.com"];
//    [dataArray addObject:@"微信公众号： 自由环球租赁"];
//    [dataArray addObject:@"官 方 微 博：  http://weibo.com/u/5203340950"];
//    [dataArray addObject:@"联 系 电 话：  010-82865072"];
//    [dataArray addObject:@"Q          Q：    3087914135"];

    
    _tableView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.tableHeaderView = [self tableHeaderView];
    [self.view addSubview:_tableView];
    
	// Do any additional setup after loading the view.
}
- (UIView *)tableHeaderView {
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH , 30)];
    
    
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREENWIDTH - 40, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.text = [NSString stringWithFormat:@"当前版本:自由环球租赁%@",currentVersion];
    label.font = [UIFont systemFontOfSize:15];
    [aView addSubview:label];
    
    
    return aView;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    
    cell.textLabel.text=[dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
//    cell.textLabel.textAlignment=NSTextAlignmentCenter;
    cell.textLabel.font=[UIFont systemFontOfSize:13.5];
    cell.contentView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    return cell;
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
