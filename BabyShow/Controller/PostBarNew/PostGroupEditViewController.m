//
//  PostGroupEditViewController.m
//  BabyShow
//
//  Created by WMY on 15/7/22.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostGroupEditViewController.h"
#import "SVPullToRefresh.h"
//#import "UIImageView+AFNetworking.h"
#import "PostMyInterestCell.h"
#import "UIImageView+WebCache.h"
#import "PostMyGroupDetailItem.h"


@interface PostGroupEditViewController (){
    UITableView *_tableView;
    BOOL _isRefresh;
    BOOL _isGetMore;
    BOOL _isFinished;
    NSMutableArray *_dataArray;
     UIButton *_FTBtn;
    UIView *_headerView;
    
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,assign)BOOL isGetMore;
@property(nonatomic,assign)BOOL isFinished;
@property(nonatomic,strong)UIButton *deleButton;
@property(nonatomic,assign)NSInteger indexPathRow;
@property(nonatomic,strong)UILabel *labelName;
@property(nonatomic,strong)UITextField *textFieldName;
@property(nonatomic,strong)UIButton *btnEdit;
@property(nonatomic,strong)UIButton *btnEditComplete;
@property(nonatomic,strong)NSString *groupEditName;


@end

@implementation PostGroupEditViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray=[NSMutableArray array];
        
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    //获取帖子列表数据成功的方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_GROUPDETAILLIST_GET_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_GROUPDETAILLIST_GET_FAIL object:nil];
    
    //网络错误
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    //删除和置顶成功和失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delGroupPostSucceed) name:USER_POSTBAR_NEW_DELGROUPPOST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delGroupPostFail:) name:USER_POSTBAR_NEW_DELGROUPPOST_FAIL object:nil];
    
    //修改群名成功
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doGroupSuccess) name:USER_POSTBAR_NEW_DOGROUP_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(doGroupFail:) name:USER_POSTBAR_NEW_DOGROUP_FAIL object:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.navigationItem.title = @"管理";
    _isRefreshInOtherVC = NO;
    [self setHeaderView];
    [self setTableView];
    [self setLeftButton];
    [self setRightButton];
    [self getData];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    
    if ((_tableView.pullToRefreshView)&& [_tableView.pullToRefreshView state] ==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && [_tableView.infiniteScrollingView state]== SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    [LoadingView stopOnTheViewController:self];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark  UI
//修改群名
-(void)setHeaderView{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
    _headerView.backgroundColor = [BBSColor hexStringToColor:@"#f7f7f7"];
    UILabel *labelGroupName = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-98, 13, 90, 25)];
    labelGroupName.text = @"修改群名";
    labelGroupName.textColor = [BBSColor hexStringToColor:@"#666666"];
    labelGroupName.font = [UIFont systemFontOfSize:13];
    [_headerView addSubview:labelGroupName];
    
    _labelName = [[UILabel alloc]initWithFrame:CGRectMake(15, 17, 170, 20)];
    _labelName.text = self.groupName;
    _labelName.font = [UIFont systemFontOfSize:16];
    _labelName.textColor = [BBSColor hexStringToColor:@"#020202"];
    [_headerView addSubview:_labelName];
    
    _btnEdit = [UIButton buttonWithType:UIButtonTypeCustom];
    _btnEdit.frame = CGRectMake(SCREENWIDTH-37, 14, 23, 23);
    [_btnEdit setBackgroundImage:[UIImage imageNamed:@"btn_qun_edit"] forState:UIControlStateNormal];
    [_btnEdit addTarget:self action:@selector(editNameAction) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_btnEdit];
    
}
-(void)setTableView{
    
    CGRect tableviewFrame=CGRectMake(0, 61, SCREENWIDTH, SCREENHEIGHT-61);
    _tableView=[[UITableView alloc]initWithFrame:tableviewFrame];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
    [_tableView setTableHeaderView:_headerView];
    __weak PostGroupEditViewController *postBar=self;
    [_tableView addInfiniteScrollingWithActionHandler:^{
        if (!postBar.isFinished) {
            if (postBar.tableView.pullToRefreshView.state==SVInfiniteScrollingStateStopped) {
                
                [postBar getData];
            }
        }else{
            if (postBar.tableView.infiniteScrollingView && postBar.tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
                [postBar.tableView.infiniteScrollingView stopAnimating];
            }
            
        }
        
    }];
    
}

//返回按钮
-(void)setLeftButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)setRightButton{
    
    _FTBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _FTBtn.frame=CGRectMake(SCREENWIDTH-49, 30, 49, 31);
    [_FTBtn setTitle:@"完成" forState:UIControlStateNormal];
    [_FTBtn addTarget:self action:@selector(editCompleteEnd) forControlEvents:UIControlEventTouchUpInside];
    _FTBtn.titleLabel.font=[UIFont systemFontOfSize:15.8];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_FTBtn];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        spaceItem.width = -15;
        self.navigationItem.rightBarButtonItems = @[spaceItem,rightItem];
    
}

-(void)back{
    self.refreshPostDetail(self.groupName,_isRefreshInOtherVC);

    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)editCompleteEnd{
    self.refreshPostDetail(self.groupName,_isRefreshInOtherVC);

    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark data
-(void)getData
{
    NetAccess *net  = [NetAccess sharedNetAccess];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%ld",(long)_group_id],@"group_id",self.last_id,@"post_create_time", nil];
    [net getDataWithStyle:NetStyleGroupDetailListEdit andParam:paramDic];
    [LoadingView startOnTheViewController:self];
}
#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 110;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"MYGROUPDETAIL"];
    PostMyInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PostMyInterestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.label.frame = CGRectMake(0, 100, SCREENWIDTH, 10);
    cell.label.backgroundColor = [BBSColor hexStringToColor:@"f9f9f9"];
    PostMyGroupDetailItem *item = [_dataArray objectAtIndex:indexPath.row];
    cell.videoView.frame = CGRectMake(0, 0, 0, 0);
    
    if (!(item.img.length <= 0)) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:item.img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            cell.photoView.frame = CGRectMake(15, 17, 70, 70);
            cell.photoView.image = image;

        }];
        
        cell.titleLabel.frame = CGRectMake(100, 25, 220, 20);
        cell.titleLabel.font = [UIFont systemFontOfSize:16];
        cell.titleLabel.textColor = [BBSColor hexStringToColor:@"#020202"];
        cell.reviewLabel.frame = CGRectZero;
        cell.descriptionLabel.frame = CGRectZero;
        if (item.is_group == 5) {
            cell.videoView.frame = CGRectMake(20, 22, 67*0.5, 67*0.5);
        }else{
            cell.videoView.frame = CGRectMake(0, 0, 0, 0);
        }
    }else
    {
        cell.photoView.frame = CGRectMake(0, 0, 0, 0);
        cell.titleLabel.frame = CGRectMake(15, 25, 250, 20);
        cell.titleLabel.font = [UIFont systemFontOfSize:16];
        cell.titleLabel.textColor = [BBSColor hexStringToColor:@"#020202"];
        cell.reviewLabel.frame = CGRectZero;
        cell.descriptionLabel.frame = CGRectZero;
        cell.videoView.frame = CGRectMake(0, 0, 0, 0);
    }
    cell.titleLabel.text = item.img_title;
    if (indexPath.row ==0) {
        cell.butDele.hidden = YES;
        cell.butTop.hidden = YES;
        cell.btnGongGao.hidden = YES;
        cell.btnJingHua.hidden = YES;
        cell.descriptionLabel.frame = CGRectMake(cell.titleLabel.frame.origin.x, cell.titleLabel.frame.origin.y+30, cell.titleLabel.frame.size.width, cell.titleLabel.frame.size.height);
        cell.descriptionLabel.font = [UIFont systemFontOfSize:16];
        cell.descriptionLabel.text = item.describe;
        
    }else
    {
        if (item.is_top==1) {
            cell.labelTop.text = @"置顶";
            cell.imgViewTop.image = [UIImage imageNamed:@"btn_qun_topdown"];
            cell.labelTop.textColor = [BBSColor hexStringToColor:@"999999"];
        }else{
            cell.labelTop.text = @"置顶";
            cell.imgViewTop.image = [UIImage imageNamed:@"btn_qun_toppost"];
            cell.labelTop.textColor = [BBSColor hexStringToColor:@"#479fde"];
            
        }
        
        if (item.isNotice == 1) {
            cell.imgGongGao.image = [UIImage imageNamed:@"btn_qun_gonggaos"];
            cell.labelGongGao.textColor = [BBSColor hexStringToColor:@"85a4fe"];
        }else{
            cell.imgGongGao.image = [UIImage imageNamed:@"btn_qun_gonggao"];
            cell.labelGongGao.textColor = [BBSColor hexStringToColor:@"999999"];

        }
        if (item.isEssence == 1) {
            cell.imgJingHua.image = [UIImage imageNamed:@"btn_qun_jinghuas"];
            cell.labelJinghua.textColor = [BBSColor hexStringToColor:@"fc7675"];
            
        }else{
            cell.imgJingHua.image = [UIImage imageNamed:@"btn_qun_jinghua"];
            cell.labelJinghua.textColor = [BBSColor hexStringToColor:@"999999"];
        }
    cell.butTop.hidden = NO;
    cell.butTop.frame = CGRectMake(cell.titleLabel.frame.origin.x+48+15+48+48, 60, 80, 19);
    [cell.butTop addTarget:self action:@selector(postToTop:) forControlEvents:UIControlEventTouchUpInside];
    cell.butTop.tag = indexPath.row;
        
    cell.butDele.hidden = NO;
    cell.butDele.frame = CGRectMake(cell.titleLabel.frame.origin.x+48+10+48 , 60, 48, 19);
    cell.butDele.tag = indexPath.row;
    [cell.butDele addTarget:self action:@selector(deleGroupPost:) forControlEvents:UIControlEventTouchUpInside];
        
        cell.btnJingHua.hidden = NO;
        cell.btnJingHua.frame = CGRectMake(cell.titleLabel.frame.origin.x , 60, 50, 19);
        [cell.btnJingHua addTarget:self action:@selector(jinghua:) forControlEvents:UIControlEventTouchUpInside];
        cell.btnJingHua.tag = indexPath.row;
        
        cell.btnGongGao.hidden = NO;
        cell.btnGongGao.frame = CGRectMake(cell.titleLabel.frame.origin.x+48+5, 60, 48, 19);
        cell.btnGongGao.tag = indexPath.row;
        [cell.btnGongGao addTarget:self action:@selector(gonggao:) forControlEvents:UIControlEventTouchUpInside];
        
    
    }
    [cell.photoView setContentMode:UIViewContentModeScaleAspectFill];
    cell.photoView.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger length = textField.text.length;
    if (length >= 20 && string.length > 0) {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:nil message:@"群名不能超过20字哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertview show];
        
        return NO;
    }
    return YES;
}

#pragma mark 帖子置顶
-(void)postToTop:(id)sender{
    UIButton *button = (UIButton *)sender;
    PostMyGroupDetailItem *item = [_dataArray objectAtIndex:button.tag];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    if (item.is_top == 1) {
        [param setObject:@"1" forKey:@"is_cancle"];
    }
    [param setObject:LOGIN_USER_ID forKey:@"login_user_id"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)self.group_id]forKey:@"group_id"];
    [param setObject:item.imgId forKey:@"img_id"];
    NetAccess *net = [NetAccess sharedNetAccess];
    [net getDataWithStyle:NetStyleTopGroupPost andParam:param];
}
//删除
-(void)deleGroupPost:(id)sender{
    UIButton *button = (UIButton *)sender;
    _indexPathRow = button.tag;
    PostMyGroupDetailItem *item = [_dataArray objectAtIndex:button.tag];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:LOGIN_USER_ID forKey:@"login_user_id"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)self.group_id]forKey:@"group_id"];
    [param setObject:item.imgId forKey:@"img_id"];
    NetAccess *net = [NetAccess sharedNetAccess];
    [net getDataWithStyle:NetStyleDelGroupPost andParam:param];
    
}
//精华
-(void)jinghua:(id)sender{
    UIButton *button = (UIButton *)sender;
    PostMyGroupDetailItem *item = [_dataArray objectAtIndex:button.tag];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:LOGIN_USER_ID forKey:@"login_user_id"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)self.group_id]forKey:@"group_id"];
    [param setObject:item.imgId forKey:@"img_id"];
    if (item.isEssence==1) {
        [param setObject:@"1" forKey:@"is_cancle"];
    }else{
        [param setObject:@"0" forKey:@"is_cancle"];
    }
    __weak PostGroupEditViewController *blockSelf = self;
    [[HTTPClient sharedClient]postNewV1:kEssenceGroupPost params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSLog(@"datadic = %@",result);
            NSIndexPath *refreshCell = [NSIndexPath indexPathForRow:button.tag inSection:0];
            NSArray *array = [NSArray arrayWithObject:refreshCell];
            item.isEssence = !item.isEssence;
            [blockSelf.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
                _isRefreshInOtherVC = YES;
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
        
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"网络或格式错误，稍后重试" andDelegate:self];
    }];
}
//公告
-(void)gonggao:(id)sender{
    UIButton *button = (UIButton *)sender;
    PostMyGroupDetailItem *item = [_dataArray objectAtIndex:button.tag];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:LOGIN_USER_ID forKey:@"login_user_id"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)self.group_id]forKey:@"group_id"];
    [param setObject:item.imgId forKey:@"img_id"];
    if (item.isNotice==1) {
        [param setObject:@"1" forKey:@"is_cancle"];
    }else{
        [param setObject:@"0" forKey:@"is_cancle"];
    }
    __weak PostGroupEditViewController *blockSelf = self;

    [[HTTPClient sharedClient]postNewV1:kNoticeGroupPost params:param success:^(NSDictionary *result) {
    if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
        NSLog(@"datadic = %@",result);
        NSIndexPath *refreshCell = [NSIndexPath indexPathForRow:button.tag inSection:0];
        NSArray *array = [NSArray arrayWithObject:refreshCell];
        item.isNotice = !item.isNotice;
        [blockSelf.tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
            _isRefreshInOtherVC = YES;

    }else{
        [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];

    }

} failed:^(NSError *error) {
    [BBSAlert showAlertWithContent:@"网络或格式错误，稍后重试" andDelegate:self];

    
}];

    
    
}
#pragma mark 点击修改群名
-(void)editNameAction{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"修改群名" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    //alert.alertViewStyle = UIAlertViewStyleLoginAndPasswordInput;
    //alert.alertViewStyle = UIAlertViewStyleSecureTextInput;
    [alert show];
    
}
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        UITextField *nameTextField = [alertView textFieldAtIndex:0];
        NSString *textField = [nameTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        NSString *groupName = nameTextField.text;
      //  groupName = [groupName stringByReplacingOccurrencesOfString:@"\r" withString:@""];
        self.groupName = groupName;
        self.groupEditName = groupName;
        if (groupName.length > 0) {
            NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
            [param setObject:LOGIN_USER_ID forKey:@"login_user_id"];
            [param setObject:[NSString stringWithFormat:@"%ld",(long)self.group_id]forKey:@"group_id"];
            [param setObject:groupName forKey:@"group_name"];
            [[NetAccess sharedNetAccess]getDataWithStyle:NetStyleDoGroup andParam:param];

        }
    }
}

#pragma mark 系统通知

-(void)getDataSucceed:(NSNotification *)note{
    
    NetAccess *net=[NetAccess sharedNetAccess];
    NSString *styleString=note.object;
    NSArray *returnArray=[net getReturnDataWithNetStyle:[styleString intValue]];
    
    if (returnArray.count) {
        
        if (_isRefresh==YES) {
            [_dataArray removeAllObjects];
            _isRefresh=NO;
        }
        
        [_dataArray addObjectsFromArray:returnArray];
        [_tableView reloadData];
        
        
    }else{
        if (_isRefresh == YES) {
            [_dataArray removeAllObjects];
            [_tableView reloadData];
        }else{
            
            _isFinished=1;
            [self showHUDWithMessage:@"已没有更多数据"];
        }
        
    }
    
    if (_dataArray.count) {
        PostMyGroupDetailItem *item = [_dataArray lastObject];
        self.last_id = item.post_create_time;
        
    }
    
    if ((_tableView.pullToRefreshView)&& [_tableView.pullToRefreshView state] ==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    
    if (_tableView.infiniteScrollingView && [_tableView.infiniteScrollingView state]== SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    
    [LoadingView stopOnTheViewController:self];
    
    
}
-(void)getDataFail:(NSNotification *) note{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=note.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    
}

-(void)netFail{
    // _shareButton.enabled = NO;
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }

    [LoadingView stopOnTheViewController:self];
    
}
//删除帖子成功方法
-(void)delGroupPostSucceed{
    _isRefreshInOtherVC = YES;
    self.isRefresh=YES;
    self.isFinished=NO;
    self.isGetMore=NO;
    self.last_id=NULL;
    [self getData];
}
-(void)delGroupPostFail:(NSNotification *) note
{
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=note.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
    
}
//修改群名成功
-(void)doGroupSuccess{
    _isRefreshInOtherVC = YES;
    _labelName.text = self.groupEditName;
    self.groupName = self.groupEditName;
//    UIApplication *app=[UIApplication sharedApplication];
//    AppDelegate *delegate=(AppDelegate *)app.delegate;
//    delegate.tabbarcontroller.tabBar.userInteractionEnabled = YES;
//    delegate.postbarHasNewTopic=YES;

    
}
-(void)doGroupFail:(NSNotification *)note{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=note.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
}

-(void)showHUDWithMessage:(NSString *)message{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60,64+20+50+50+50+5 , 200, 30)];
    label.backgroundColor = [UIColor darkGrayColor];
    label.layer.cornerRadius = 3.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:14];
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



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
