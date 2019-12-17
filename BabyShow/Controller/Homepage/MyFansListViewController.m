//
//  MyFansListViewController.m
//  BabyShow
//
//  Created by 于 晓波 on 1/4/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyFansListViewController.h"
#import "SDWebImageManager.h"
#import "SVPullToRefresh.h"
#import "MyHomeNewVersionVC.h"

//粉丝列表有添加关注和取消关注,关注列表只有取消关注

@interface MyFansListViewController ()

@property (nonatomic ,assign)NSInteger selectedIndex;
@property (nonatomic ,assign)BOOL      isFinished;
@property (nonatomic ,strong)UITableView *tableView;


@end

@implementation MyFansListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        _dataArray=[[NSMutableArray alloc]init];
        self.userid=[[NSString alloc]init];
        
        _selectedItem =[[IdolListItem alloc]init];
    
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_GET_IDOLLIST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_GET_IDOLLIST_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusSucceed) name:USER_FOCUS_ON_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusFail:) name:USER_FOCUS_ON_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFocusSucceed) name:USER_CANCEL_FOCUS_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFocusFail:) name:USER_CANCEL_FOCUS_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    self.title = @"关注";
    
    _tableView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    __block MyFansListViewController *blockSelf = self;
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        if (!blockSelf.isFinished) {
            [blockSelf getData];
        }else{
            if (blockSelf.tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
                [blockSelf.tableView.infiniteScrollingView stopAnimating];
            }
        }
    }];
    
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
    self.page = 1;
    [self getData];
    
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
    if ([LOGIN_USER_ID integerValue]!=[self.userid integerValue]) {
        label.text=@"TA还没有关注/粉丝";
    } else {
        label.text = @"你还没有关注/粉丝";
    }
    
    [_emptyView addSubview:label];
    
    [self.view addSubview:_emptyView];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark Private
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getData{
    
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:self.userid,@"user_id",
                         [NSString stringWithFormat:@"%d",self.page],@"page",nil];
    netAccess=[NetAccess sharedNetAccess];
    [netAccess getDataWithStyle:NetStylegetIdolList andParam:param];
    
    [LoadingView startOnTheViewController:self];

}

#pragma mark - UITableViewDataSource Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identify=@"MYCELL";
    MHPMyCareCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell=[[MHPMyCareCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    IdolListItem *item=[_dataArray objectAtIndex:indexPath.row];
    cell.nameLabel.text=item.nickName;
    
    NSString *avatarStr=item.avatarStr;
//    [[SDWebImageManager sharedManager] downloadWithURL:[NSURL URLWithString:avatarStr] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
//        
//    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//        cell.avatarView.image = image;
//    }];
    [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:avatarStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        cell.avatarView.image = image;
    }];
    
    if ([item.relation intValue] == 0) {
        [cell.Btn setTitle:@"未关注" forState:UIControlStateNormal];
        [cell.Btn setBackgroundColor:[BBSColor hexStringToColor:@"3daf2c"]];

    }else if ([item.relation intValue] == 1){
        
        [cell.Btn setTitle:@"已关注" forState:UIControlStateNormal];
        [cell.Btn setBackgroundColor:[BBSColor hexStringToColor:BACKCOLOR]];
        
    }else {
        
        [cell.Btn setTitle:@"相互关注" forState:UIControlStateNormal];
        [cell.Btn setBackgroundColor:[UIColor lightGrayColor]];
        
    }
    
    NSString *loginUserId=LOGIN_USER_ID;
    
    if ([loginUserId integerValue]!=[self.userid integerValue]) {
        cell.Btn.hidden=YES;
    }
    
    
    cell.delegate=self;
    cell.Btn.tag=indexPath.row;
    cell.avatarBtn.tag=indexPath.row;
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    return cell;
}
#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _selectedItem=[_dataArray objectAtIndex:indexPath.row];
    
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.userid=_selectedItem.userid;
    NSString *loginUserId=LOGIN_USER_ID;
    
    if ([loginUserId integerValue]==[_selectedItem.userid integerValue]) {
        
        myHomePage.Type=0;
        
    }else{
        
        myHomePage.Type=1;
        
    }
    
    [self.navigationController pushViewController:myHomePage animated:YES];
    
}

#pragma mark MHPMyCareCellDelegate

-(void)ClickOnTheAvatar:(UIButton *)avatar{
    _selectedItem=[_dataArray objectAtIndex:avatar.tag];
    
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    myHomePage.userid=_selectedItem.userid;
    
    NSString *loginUserId=LOGIN_USER_ID;
    
    if ([loginUserId integerValue]==[_selectedItem.userid integerValue]) {
        
        myHomePage.Type=0;
        
    }else{
        
        myHomePage.Type=1;
        
    }
    
    [self.navigationController pushViewController:myHomePage animated:YES];
    
}

-(void)addToBeMyFocus:(UIButton *) btn{
    
    IdolListItem *item = [_dataArray objectAtIndex:btn.tag];
    
    if ([item.relation intValue] == 0) {
        
        //关注我的,添加关注
        UIActionSheet *acs = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"添加关注",nil];
        acs.tag = btn.tag;
        [acs showFromTabBar:self.tabBarController.tabBar];
        
    } else {
    
        //相互关注,我关注的,都是取消关注
        UIActionSheet *acs=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"取消关注" otherButtonTitles:nil];
        acs.tag=btn.tag;
        [acs showFromTabBar:self.tabBarController.tabBar];
    }

}

#pragma mark - NSNotification
-(void)getDataSucceed:(NSNotification *)not{
    
    NSString *styleString=not.object;
    NetAccess *net=[NetAccess sharedNetAccess];
    
    NSArray *dataArray=[net getReturnDataWithNetStyle:[styleString intValue]];
    
    if (dataArray.count == 0) {
        _isFinished = YES;
    } else {
        _page ++ ;
    }
    [_dataArray addObjectsFromArray:dataArray];
    
    if (_dataArray.count == 0) {
        [self addEmptyHintView];
    } else {
        if (_emptyView) {
            [_emptyView removeFromSuperview];
            _emptyView = nil;
        }
        
        if (_tableView) {
            [_tableView reloadData];
        }
    }
    
    [LoadingView stopOnTheViewController:self];
    
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
}

-(void)getDataFail:(NSNotification *)not{
    
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    
}

-(void)focusSucceed{
    
    [LoadingView stopOnTheViewController:self];

    IdolListItem *item=[_dataArray objectAtIndex:_selectedIndex];
    //将该条的relation由0(关注我)改为2(相互关注),然后刷新tableview
    item.relation = @"2";
    [_dataArray replaceObjectAtIndex:_selectedIndex withObject:item];
    [_tableView reloadData];

    
}

-(void)focusFail:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];

    NSString *errorString=not.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}

-(void)cancelFocusSucceed{
    [LoadingView stopOnTheViewController:self];

    IdolListItem *item=[_dataArray objectAtIndex:_selectedIndex];
    //关注页面,取消关注则移除该条,粉丝页面,将relation由2改为1
    if ([item.relation intValue] == 1) {
        [_dataArray removeObjectAtIndex:_selectedIndex];
        [_tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [_tableView endUpdates];
        [_tableView reloadData];//不刷新的话,下面的Cell的btn.tag没有刷新
        if (_dataArray.count == 0) {
            [self addEmptyHintView];
        }
    } else {
        item.relation = @"0";
        [_dataArray replaceObjectAtIndex:_selectedIndex withObject:item];
        [_tableView reloadData];
    }

}

-(void)cancelFocusFail:(NSNotification *) not{
    [LoadingView stopOnTheViewController:self];

    NSString *errorString=not.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}
-(void)netFail{
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state == 2) {
        [_tableView.infiniteScrollingView stopAnimating];
        
    }

    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    
}
#pragma mark - UIActionSheetDelegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        _selectedIndex = actionSheet.tag;
        IdolListItem *item=[_dataArray objectAtIndex:actionSheet.tag];
    
        NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"user_id",item.userid,@"idol_id", nil];
        NetAccess *net=[NetAccess sharedNetAccess];
        
        
        if ([item.relation intValue] == 0) {
            
            //关注我的,添加关注
            [net getDataWithStyle:NetStyleFocusOn andParam:param];
            
        }else {
            
            //已关注、相互关注
            //取消关注
            [net getDataWithStyle:NetStyleCancelFocus andParam:param];
            
        }
        
        [LoadingView startOnTheViewController:self];
    }
    
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    
}

@end
