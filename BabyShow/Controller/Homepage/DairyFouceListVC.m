//
//  DairyFouceListVC.m
//  BabyShow
//
//  Created by WMY on 15/12/15.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "DairyFouceListVC.h"
#import "DairyFouceCell.h"
#import "SVPullToRefresh.h"
#import "DairyFouceItem.h"
#import "UIImageView+WebCache.h"

@interface DairyFouceListVC (){
    UITableView *_tableView;
    BOOL _isRefresh;
    BOOL _isGetMore;
    BOOL _isFinished;
    NSMutableArray *_dataArray;

}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) BOOL isGetMore;
@property (nonatomic, assign) BOOL isFinished;
@property(nonatomic,strong)NSString *post_create_time;
@property(nonatomic,strong)NSString *is_each_others;


@end

@implementation DairyFouceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
     self.automaticallyAdjustsScrollViewInsets = NO;
    [self setLeftButton];
    [self setTableView];
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{//1
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    self.tabBarController.tabBar.hidden = YES;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    
    //取消关注的列表
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_MYHOME_CANCELFOUCE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_MYHOME_CANCELFOUCE_FAIL object:nil];
    
}
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.tabBarController.tabBar.hidden = NO;
    if ((_tableView.pullToRefreshView)&& [_tableView.pullToRefreshView state] ==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    
    if (_tableView.infiniteScrollingView && [_tableView.infiniteScrollingView state]== SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    [LoadingView stopOnTheViewController:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

#pragma mark UI
//返回按钮
-(void)setLeftButton{
    
    //返回按钮
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 31)];
    imagev.image = [UIImage imageNamed:@"btn_back1.png"];
    [_backBtn addSubview:imagev];
    UILabel *cateName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 31)];
    cateName.textColor = [UIColor whiteColor];
    cateName.text = @"关注我的成长记录";
    [_backBtn addSubview:cateName];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
-(void)setTableView{
    
    CGRect tableviewFrame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    _tableView=[[UITableView alloc]initWithFrame:tableviewFrame];
    _tableView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
    __weak DairyFouceListVC *dairyVC = self;
    [_tableView addPullToRefreshWithActionHandler:^{
        dairyVC.isRefresh = YES;
        dairyVC.isFinished = NO;
        dairyVC.isGetMore = NO;
        dairyVC.post_create_time = NULL;
        [dairyVC getData];
    }];
    [_tableView addInfiniteScrollingWithActionHandler:^{
        if (!dairyVC.isFinished) {
            if (dairyVC.tableView.pullToRefreshView.state == SVInfiniteScrollingStateStopped) {
                [dairyVC getData];
            }
        }else{
            if (dairyVC.tableView.infiniteScrollingView && dairyVC.tableView.infiniteScrollingView.state == SVInfiniteScrollingStateLoading) {
                [dairyVC.tableView.infiniteScrollingView stopAnimating];
            }
        }
    }];
    
}
- (void)addEmptyHintView {
    
    if (_emptyView) {
        return;
    }
    _emptyView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _emptyView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    UIImage *image=[UIImage imageNamed:@"img_myshow_empty_babyface"];
    UIImageView *imgView=[[UIImageView alloc]initWithImage:image];
    imgView.frame=CGRectMake(96.5, 100, 127, 127);
    [_emptyView addSubview:imgView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(50, 240, 220, 30)];
    label.font=[UIFont systemFontOfSize:17];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor = [BBSColor hexStringToColor:@"c3ad8f"];
    label.text = @"你还没有人关注";
    [_emptyView addSubview:label];
    
    [self.view addSubview:_emptyView];
    
}


#pragma mark data
-(void)getData{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.post_create_time,@"post_create_time" ,nil];
    NetAccess *net = [NetAccess sharedNetAccess];
    [net getDataWithStyle:NetStyleCancelFouceDiaryList andParam:params];
    [LoadingView startOnTheViewController:self];
    
}
#pragma mark  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = [NSString stringWithFormat:@"dairycancelfoucecell"];
    DairyFouceCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DairyFouceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    DairyFouceItem *item = [_dataArray objectAtIndex:indexPath.row];
    cell.userNameLabel.text= item.nick_name;
    [cell.avatarImg sd_setImageWithURL:[NSURL URLWithString:item.avatar]];
    cell.babyNameLabel.text = item.descriptions;
    if ([item.is_each_others isEqualToString:@"2"]) {
        //[cell.fouceImg setBackgroundImage:[UIImage imageNamed:@"img_diary_fouce"] forState:UIControlStateNormal];//还没关注
        [cell.fouceImg setBackgroundColor:[BBSColor hexStringToColor:@"fe6161"]];
        [cell.fouceImg setTitle:@"同意" forState:UIControlStateNormal];
        [cell.fouceImg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    }else if ([item.is_each_others isEqualToString:@"1"]){
       // [cell.fouceImg setBackgroundImage:[UIImage imageNamed:@"btn_diary_cancelfouce"] forState:UIControlStateNormal];//已经关注
        [cell.fouceImg setBackgroundColor:[BBSColor hexStringToColor:@"818181"]];
        [cell.fouceImg setTitle:@"取消关注" forState:UIControlStateNormal];
        [cell.fouceImg setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
    cell.fouceImg.tag = indexPath.row+9000;
    [cell.fouceImg addTarget:self action:@selector(fouceAction:) forControlEvents:UIControlEventTouchUpInside];
    //朵儿
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //么么
    return cell;
    
}
-(void)fouceAction:(id)sender{
    UIButton *button = (UIButton*)sender;
    NSInteger tag = button.tag-9000;
    NSString *isEach ;
    NSLog(@"tag=%ld",tag);
    NSLog(@"dataarrya = %@",_dataArray);
    DairyFouceItem *item = [_dataArray objectAtIndex:tag];
    if ([item.is_each_others isEqualToString:@"2"]) {
        isEach= @"1";//去关注
    }else if([item.is_each_others isEqualToString:@"1"]){
        isEach = @"2";//取消关注
    }
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",item.babys_idol_id,@"babys_idol_id",isEach,@"is_each_others", nil];
    __weak DairyFouceListVC *blockSelf = self;
    if ([isEach isEqualToString:@"1"]) {
    [[HTTPClient sharedClient]getNew:kEditBabysIdol params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                //添加关注成功后刷新本cell
                [BBSAlert showAlertWithContent:@"添加关注" andDelegate:nil andDismissAnimated:1];
                item.is_each_others = @"1";
                NSIndexPath *refreshCell = [NSIndexPath indexPathForRow:tag inSection:0];
                NSArray *array = [NSArray arrayWithObject:refreshCell];
                [blockSelf.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
                    }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        
    }];
    }else if([isEach isEqualToString:@"2"]){
    UIActionSheet *acs=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"取消关注" otherButtonTitles:nil];
            acs.tag = tag+100;
            [acs showFromTabBar:self.tabBarController.tabBar];
    }
}

#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        NSString *isEach ;
        isEach = @"2";
          DairyFouceItem *item = [_dataArray objectAtIndex:actionSheet.tag-100];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",item.babys_idol_id,@"babys_idol_id",isEach,@"is_each_others", nil];

        [[HTTPClient sharedClient]getNew:kEditBabysIdol params:params success:^(NSDictionary *result) {
            if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                [_dataArray removeObjectAtIndex:actionSheet.tag-100];
                [_tableView beginUpdates];
                [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:actionSheet.tag-100 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [_tableView endUpdates];
                [_tableView reloadData];

            }else{
                [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
            }
            
            
        } failed:^(NSError *error) {
            
        }];

    }
    
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    
}

-(void)getDataSucceed:(NSNotification *) not{
    
    
    [LoadingView stopOnTheViewController:self];
    NSString *styleString=not.object;
    
    NetAccess *net=[NetAccess sharedNetAccess];
    
    NSArray *returnArray=[net getReturnDataWithNetStyle:[styleString intValue]];
    if (returnArray.count==0) {
        _isFinished = YES;

    }
    if (_isRefresh) {
        [_dataArray removeAllObjects];
        _isRefresh = NO;
    }
    [_dataArray addObjectsFromArray:returnArray];
    [_tableView reloadData];
    
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    if (_dataArray.count) {
        DairyFouceItem *item = [returnArray lastObject];
        self.post_create_time = item.post_create_time;
    }
    if (_dataArray.count == 0) {
         [self addEmptyHintView];
    }else if(_tableView){
        [_tableView reloadData];
    }
}
-(void)getDataFail:(NSNotification *)not{
    
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state == 2) {
        [_tableView.infiniteScrollingView stopAnimating];
        
    }

    
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    
}
-(void)netFail{
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state == 2) {
        [_tableView.infiniteScrollingView stopAnimating];
        
    }

    
    [LoadingView stopOnTheViewController:self];
    
}
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
