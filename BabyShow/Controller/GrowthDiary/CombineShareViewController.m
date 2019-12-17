//
//  CombineShareViewController.m
//  BabyShow
//
//  Created by Monica on 15-4-2.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "CombineShareViewController.h"
#import "CombineInputViewController.h"


#import "CombineShareCell.h"

#import "UIImageView+WebCache.h"
#import "btnWithIndexPath.h"
#import "MyHomeNewVersionVC.h"

@interface CombineShareViewController () <UITableViewDelegate,UITableViewDataSource,CombineShareDelegate>

@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *dataArray;

@end

@implementation CombineShareViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = [[NSMutableArray alloc] init];
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDataSucceed) name:USER_DIARY_COMBINESENDMAIL_SUCCEED object:nil];
  //  [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getDataFail:) name:USER_DIARY_COMBINESENDMAIL_FAIL object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"我要同步";
    [self setLeftBarButton];
    [self addTableView];
    [self getData];
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    
}
#pragma mark notification
-(void)getDataSucceed{
    [LoadingView stopOnTheViewController:self];
    NSString *errorString=@"请求同步成功";
    [BBSAlert showAlertWithContent:errorString andDelegate:self];

}
-(void)getDataFail:(NSNotification *)not{
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Data Methods
- (void)getData {
    
    [LoadingView startOnTheViewController:self];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_baby_id,@"baby_id",LOGIN_USER_ID,@"login_user_id", nil];
    [[HTTPClient sharedClient] getNew:kMyShareList params:params success:^(NSDictionary *result) {
        [LoadingView stopOnTheViewController:self];
        if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
            _dataArray = [result objectForKey:kBBSData];
            
            
            if (_tableView) {
                if (_dataArray.count <= 0) {
                    _tableView.tableFooterView = ^UIView *{
                        UIView *footerView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
                        footerView.backgroundColor = [UIColor whiteColor];
                        
                        UIImage *image = [UIImage imageNamed:@"img_myshow_empty_babyface"];
                        UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
                        imgView.frame = CGRectMake(96.5, 0, 127, 127);
                        [footerView addSubview:imgView];
                        
                        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 140, SCREENWIDTH, 30)];
                        label.font = [UIFont systemFontOfSize:17];
                        label.textAlignment = NSTextAlignmentCenter;
                        label.textColor = [BBSColor hexStringToColor:@"c3ad8f"];
                        label.text = @"你还没有好友哦,抓紧去关注吧!";
                        [footerView addSubview:label];
                        
                        return footerView;
                    }();
                }
                [_tableView reloadData];
            }
        } else {
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
        [BBSAlert showAlertWithContent:@"网络连接失败请重试" andDelegate:nil];
    }];
}
#pragma mark - Private
- (void)setLeftBarButton {
    CGRect backBtnFrame = CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame = backBtnFrame;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    
    self.navigationItem.leftBarButtonItem = left;
}
- (void)addTableView {
    if (!_tableView) {
      
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = ^UIView *{
            
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
            view.backgroundColor = [BBSColor hexStringToColor:@"f3f1ef"];
            
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, SCREENWIDTH, 40)];
            label.text = @"只能同步好友中出生日期一样的宝宝";
            label.textAlignment = NSTextAlignmentCenter;
            label.textColor = [BBSColor hexStringToColor:@"a19993"];
            label.font = [UIFont systemFontOfSize:16];
            [view addSubview:label];
            
            return view;
        }();
        [self.view addSubview:_tableView];
    }
    [_tableView reloadData];
    
}

#pragma mark - UITableViewDataSource Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"CombineCell";
    
    CombineShareCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[CombineShareCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    }
    NSDictionary *info = [_dataArray objectAtIndex:indexPath.row];
    cell.babyNameLabel.text = [info objectForKey:@"baby_name"];
    cell.userNameLabel.text = [info objectForKey:@"nick_name"];
    UIImage *image = [UIImage imageNamed:@"img_message_avatar_100"];
    cell.iconImageV.image = image;
    [cell.iconImageV sd_setImageWithURL:[NSURL URLWithString:[info objectForKey:@"user_avatar"]] placeholderImage:image];
    cell.iconImageV.tag = indexPath.row;
    cell.combineBtn.indexpath = indexPath;
    BOOL is_combined = [[info objectForKey:@"is_common"] boolValue];
    if (is_combined) {
        [cell.combineBtn setTitle:@"已同步" forState:UIControlStateNormal];
        cell.combineBtn.backgroundColor = [BBSColor hexStringToColor:@"dbdbdb"];
        cell.combineBtn.tag = 101;

    } else {
        [cell.combineBtn setTitle:@"同步" forState:UIControlStateNormal];
        cell.combineBtn.backgroundColor = [BBSColor hexStringToColor:@"ff8585"];

    }
    return cell;
}
#pragma mark - UITableViewDelegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}
#pragma mark -
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)combineUsers:(id)button {
    btnWithIndexPath *btn = (btnWithIndexPath *)button;
    

    NSDictionary *info = [_dataArray objectAtIndex:btn.indexpath.row];
    BOOL is_combined = [[info objectForKey:@"is_common"] boolValue];
    if (is_combined) {
        //解除同步,暂不提供该功能
        return;
    }else {
        [btn setTitle:@"已请求" forState:UIControlStateNormal];
        btn.backgroundColor = [BBSColor hexStringToColor:@"dbdbdb"];

        
    NSString *loginId =LOGIN_USER_ID;
    NSString *babyId = [info objectForKey:@"baby_id"];
    NSLog(@"info = %@",info);
    NSString *share_baby_id = [info objectForKey:@"share_baby_id"];
    NSString *share_user_id = [info objectForKey:@"user_id"];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:loginId,@"login_user_id",babyId,@"baby_id",share_baby_id,@"share_baby_id",share_user_id,@"share_user_id", nil];
    [[NetAccess sharedNetAccess]getDataWithStyle:NetStyleCombineSendMail andParam:param];
    }
    
}
-(void)clickTheAvatar:(id)imgV{
    
    UIImageView *imageView = (UIImageView *)imgV;
    NSDictionary *info = [_dataArray objectAtIndex:imageView.tag];
    NSString *user_id = [NSString stringWithFormat:@"%@",[info objectForKey:@"user_id"]];

    MyHomeNewVersionVC *myHomePage = [[MyHomeNewVersionVC alloc]init];
    myHomePage.userid = user_id;
    myHomePage.hidesBottomBarWhenPushed=YES;
    
    if ([user_id intValue]==[LOGIN_USER_ID intValue]) {
        
        myHomePage.Type=0;
        
    }else{
        
        myHomePage.Type=1;
        
    }
    
    [self.navigationController pushViewController:myHomePage animated:YES];
    
}
@end
