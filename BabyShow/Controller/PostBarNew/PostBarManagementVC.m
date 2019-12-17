//
//  PostBarManagementVC.m
//  BabyShow
//
//  Created by WMY on 16/9/22.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarManagementVC.h"
#import "PostBarManagementCell.h"
#import "PostBarManagementItem.h"
#import "UIImageView+WebCache.h"

@interface PostBarManagementVC (){
    RefreshControl *_refreshControl;
    UITableView *_tableViewNew;
    NSMutableArray *tableArray;//数组
    //刷新
    NSString *postCreatTime;
}
@property(nonatomic,strong)YLButton *backBtn;
@property(nonatomic,strong)UIView *alertViewBack;
@property(nonatomic,strong)UIImageView *img1;
@property(nonatomic,strong)UIImageView *img2;
@property(nonatomic,strong)UIImageView *img3;
@property(nonatomic,strong)UIView *lineWhiteView3;
@property(nonatomic,strong)UIView *lineWhiteView4;
@property(nonatomic,strong)UIView *lineWhiteView1;
@property(nonatomic,strong)UIView *lineWhiteView2;
@property(nonatomic,strong)UIView *whiteView;
@property(nonatomic,strong)UITapGestureRecognizer *tap1;
@property(nonatomic,strong)UITapGestureRecognizer *tap2;
@property(nonatomic,strong)UITapGestureRecognizer *tap3;
@property(nonatomic,strong)NSString *editEssenceImgID;//设置精华贴的id
@property(nonatomic,strong)EditEssenceVC *editEssenceVC;
@property(nonatomic,strong)UIView *headView;
@property(nonatomic,assign)NSInteger deleteIndex;//记录别删除的帖子



@end

@implementation PostBarManagementVC
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    //删除和置顶成功和失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delGroupPostSucceed) name:USER_POSTBAR_NEW_DELGROUPPOST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(delGroupPostFail:) name:USER_POSTBAR_NEW_DELGROUPPOST_FAIL object:nil];
    
}

-(void)delGroupPostSucceed{
    [LoadingView stopOnTheViewController:self];
    [tableArray removeObjectAtIndex:_deleteIndex];
    [_tableViewNew beginUpdates];
    [_tableViewNew deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_deleteIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [_tableViewNew endUpdates];
    [_tableViewNew reloadData];
}
-(void)delGroupPostFail:(NSNotification*)not{
    [LoadingView stopOnTheViewController:self];
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];

}
-(void)viewWillDisappear:(BOOL)animated{
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    if (!tableArray) {
        tableArray = [NSMutableArray array];
    }
    [self setHeadViewAlert];

    [self setTableView];
    [self refreshControlInit];
    self.navigationItem.title = @"帖子管理";
    [self setLeftButton];
    }
-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresh) name:@"managermentPostSuccess" object:nil];
}
-(void)refresh{
    postCreatTime = NULL;
    [self getNewTableViewData];

}
-(void)setHeadViewAlert{
    self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 30)];
    UILabel *alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 300, 20)];
    alertLabel.text = @"每个群最多选择五个精华哦~";
    alertLabel.font = [UIFont systemFontOfSize:15];
    alertLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    alertLabel.textAlignment = NSTextAlignmentCenter;
    [self.headView addSubview:alertLabel];
}
-(void)setLeftButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
-(void)setTableView{
    _tableViewNew = [[UITableView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH, SCREENHEIGHT-64)];
    _tableViewNew.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableViewNew.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewNew.showsVerticalScrollIndicator = NO;
    _tableViewNew.delegate = self;
    _tableViewNew.dataSource = self;
    _tableViewNew.tableHeaderView = self.headView;
    
    [self.view addSubview:_tableViewNew];
}
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark  刷新控件refreshControl
-(void)refreshControlInit{
    _refreshControl = [[RefreshControl alloc]initWithScrollView:_tableViewNew delegate:self];
    _refreshControl.delegate = self;
    _refreshControl.topEnabled = YES;
    _refreshControl.bottomEnabled = NO;
    [_refreshControl startRefreshingDirection:RefreshDirectionTop];
}
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    if (refreshControl == _refreshControl) {
        if (direction == RefreshDirectionTop){
            postCreatTime = NULL;
      }
        [self getNewTableViewData];
    }
}

-(void)refreshComplete :(RefreshControl *)refreshControl{
    if (refreshControl.refreshingDirection==RefreshingDirectionTop)
    {
        [refreshControl finishRefreshingDirection:RefreshDirectionTop];
    }
    else if (refreshControl.refreshingDirection==RefreshingDirectionBottom)
    {
        [refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
    }
}
-(void)getNewTableViewData{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%ld",(long)self.groupId],@"group_id", postCreatTime,@"post_create_time",nil];
    UrlMaker *urlMark = [[UrlMaker alloc]initWithNewV1UrlStr:@"getGroupManage" Method:NetMethodGet andParam:params];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMark.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    __weak ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:@"success"]integerValue] == 1) {
            NSArray *dataArray = [dic objectForKey:@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
            for (NSDictionary *dataDic in dataArray) {
                PostBarManagementItem *item = [[PostBarManagementItem alloc]init];
                item.img_title = MBNonEmptyString(dataDic[@"img_title"]);
                item.img_description = MBNonEmptyString(dataDic[@"img_description"]);
                item.img_id = MBNonEmptyString(dataDic[@"img_id"]);
                item.is_group = MBNonEmptyString(dataDic[@"is_group"]);
                item.post_create_time = MBNonEmptyString(dataDic[@"post_create_time"]);
                item.show_essence_name = MBNonEmptyString(dataDic[@"show_essence_name"]);
                item.essence = dataDic[@"essence"];
                item.group_class = dataDic[@"group_class"];
                item.imgArray = dataDic[@"img"];
                [returnArray addObject:item];
            }
            if (returnArray.count == 0) {
                _refreshControl.bottomEnabled = NO;
            }
            if (postCreatTime == NULL) {
                [tableArray removeAllObjects];
                _refreshControl.bottomEnabled = YES;
            }
            PostBarManagementItem *item = [returnArray lastObject];
            postCreatTime = item.post_create_time;
            [tableArray addObjectsFromArray:returnArray];
            [_tableViewNew reloadData];
            [self refreshComplete:_refreshControl];
        }else{
            [self refreshComplete:_refreshControl];
            if (dic) {
                [BBSAlert showAlertWithContent:[dic objectForKey:kBBSReMsg] andDelegate:self];
            }else{
                [BBSAlert showAlertWithContent:@"请刷新" andDelegate:self];
            }
        }
    }];
    [request setFailedBlock:^{
        [self refreshComplete:_refreshControl];
    }];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 73;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *returnCell;
    PostBarManagementItem *item = [tableArray objectAtIndex:indexPath.row];
    static NSString *identifier = @"POSRBARMANAGEMENTCELL";
    
    PostBarManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[PostBarManagementCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.titleLabel.text = item.img_title;
    cell.descriptionLabel.text = item.img_description;
    //图片的展示
    if (item.imgArray) {
        NSString *imgTitle1;
        NSDictionary *imgDic1;
        imgDic1 = item.imgArray[0];
        imgTitle1 = MBNonEmptyString(imgDic1[@"img_thumb"]);
        [cell.photoView sd_setImageWithURL:[NSURL URLWithString:imgTitle1] placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
        }
    [cell.postBarModelBtn setTitle:item.show_essence_name forState:UIControlStateNormal];
    cell.postBarModelBtn.tag = indexPath.row+1000;
    [cell.postBarModelBtn addTarget:self action:@selector(alertViewShow:) forControlEvents:UIControlEventTouchUpInside];
    cell.postBarSortBtn.tag = indexPath.row+1000;
    [cell.postBarSortBtn addTarget:self action:@selector(alertShowSortView:) forControlEvents:UIControlEventTouchUpInside];
    cell.deleBtn.tag = indexPath.row+1000;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell.deleBtn addTarget:self action:@selector(deletePost:) forControlEvents:UIControlEventTouchUpInside];
    returnCell = cell;
    return returnCell;

}
-(void)deletePost:(id)sender{
    UIButton *senderBtn = (id)sender;
    _deleteIndex = senderBtn.tag-1000;
    PostBarManagementItem *item = [tableArray objectAtIndex:senderBtn.tag-1000];
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:LOGIN_USER_ID forKey:@"login_user_id"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)self.groupId]forKey:@"group_id"];
    [param setObject:item.img_id forKey:@"img_id"];
    NetAccess *net = [NetAccess sharedNetAccess];
    [net getDataWithStyle:NetStyleDelGroupPost andParam:param];


}
-(void)alertViewShow:(id)sender{
    UIButton *senderBtn = (id)sender;
    PostBarManagementItem *item = [tableArray objectAtIndex:senderBtn.tag-1000];
    self.editEssenceImgID = item.img_id;
    _editEssenceVC = [[EditEssenceVC alloc]init];
    _editEssenceVC.leftArray = item.essence;
    _editEssenceVC.imgId = item.img_id;
    _editEssenceVC.groupId = self.groupId;
    _editEssenceVC.fromModel = 1;
    [self.view addSubview:_editEssenceVC.view];
}
-(void)alertShowSortView:(id)sender{
    UIButton *senderBtn = (id)sender;
    PostBarManagementItem *item = [tableArray objectAtIndex:senderBtn.tag-1000];
    _editEssenceVC = [[EditEssenceVC alloc]init];
    _editEssenceVC.leftArray = item.group_class;
    _editEssenceVC.fromModel = 2;
    _editEssenceVC.imgId = item.img_id;
    [self.view addSubview:_editEssenceVC.view];



}
-(void)hideMenuVC{
    
}
-(void)changeImgAndId:(id)sender{
    UITapGestureRecognizer *tap = (id)sender;
    if (tap == _tap1) {
        
    }else if (tap == _tap2){
        
    }else if(tap == _tap3){
        
    }
        
}
//点击收回编辑页面
-(void)removeTheViewFromWidow{
    self.alertViewBack.hidden = YES;
    [self.lineWhiteView3 removeFromSuperview];
    
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
