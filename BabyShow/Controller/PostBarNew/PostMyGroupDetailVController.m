//
//  PostMyGroupDetailVController.m
//  BabyShow
//
//  Created by WMY on 15/6/16.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostMyGroupDetailVController.h"
#import "SVPullToRefresh.h"
#import "PostMyInterestCell.h"
#import "PostMyGroupDetailItem.h"
#import "UIImageView+WebCache.h"
#import "PostBarNewMakeAPost.h"
#import "PostGroupEditViewController.h"
#import "StoreMoreListVC.h"
#import "PostGroupSpecialCell.h"
#import "JingHuaVC.h"
#import "LoginHTMLVC.h"
#import "PostBarNewDetialV1VC.h"
#import "StoreDetailNewVC.h"
#import "BabyShowPlayerVC.h"
#import "YLImageView.h"
#import "YLGIFImage.h"


@interface PostMyGroupDetailVController ()
{
    UITableView *_tableView;
    UIView *_headerView;
    UIButton *_selectBtn;
    
    UIButton *topBtn;
    UIButton *_FTBtn;
    
    BOOL _isRefresh;
    BOOL _isGetMore;
    BOOL _isFinished;
    
    NSMutableArray *_dataArray;
    UIImageView *navBarHairlineImageView;
}
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, assign) BOOL isGetMore;
@property (nonatomic, assign) BOOL isFinished;
@property(nonatomic,strong)UIImageView *avatarImg;
@property(nonatomic,strong)UILabel *nickNameLabel;
@property(nonatomic,strong)UILabel *review_countLabel;
@property(nonatomic,strong)UILabel *post_countLabel;
@property(nonatomic,strong)UIButton *shareButton;
@property(nonatomic,strong)UIButton *deleButton;
@property(nonatomic,assign)NSInteger indexPathRow;
@property(nonatomic,strong)UILabel *labelGroupName;
@property(nonatomic,strong)UIView *navigationView;
@property(nonatomic,strong)NSString *groupName;
@property (nonatomic,strong)YLImageView *ylIamgeView;




@end

@implementation PostMyGroupDetailVController

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_GROUPDETAILLIST_GET_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_GROUPDETAILLIST_GET_FAIL object:nil];
    
    //网络错误
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    
    //添加关注成功
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postIdolSucceed) name:USER_POSTBAR_NEW_POSTIDOLS_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postIdolFail) name:USER_POSTBAR_NEW_POSTIDOLS_FAIL object:nil];
    
    //取消关注
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPostIdolSucceed) name:USER_POSTBAR_NEW_CANCELPOSTIDOL_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelPostIdolFail) name:USER_POSTBAR_NEW_CANCELPOSTIDOL_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeVideoSucceed) name:USER_POSTBAR_NEW_MAKE_A_GROUPPOST_SUCCEED object:nil];

    
    //如果有新的帖子的话刷新
    if (theAppDelegate.isHaveNewGroupPost == YES) {
        theAppDelegate.isHaveNewGroupPost = NO;
        [self makeApostSucceed];
    }
    if (theAppDelegate.isUpdateNow == YES) {
        theAppDelegate.isUpdateNow = NO;
        [self postingSuceed];
    }
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}
-(void)makeVideoSucceed{
    if (theAppDelegate.isHaveNewGroupPost == YES) {
        theAppDelegate.isHaveNewGroupPost = NO;
        [self makeApostSucceed];
    }

}
-(void)postingSuceed{
    _ylIamgeView = [[YLImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH-60,SCREENHEIGHT-100, 39, 39)];
   _ylIamgeView.image = [YLGIFImage imageNamed:@"up_show.gif"];
    [self.view addSubview:_ylIamgeView];
             
}
-(void)makeApostSucceed{
    [_ylIamgeView removeFromSuperview];
    [self refresh];
}
-(void)refresh{
    _isRefresh=YES;
    _isGetMore=NO;
    _isFinished=NO;
    self.last_id = NULL;
    [_dataArray removeAllObjects];
    [self getData];
    [self getHeaderViewData];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationView];
    [self setHeaderView];
    [self setRightButton];
    [self setLeftButton];
    [self setTableView];
    [self getData];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    navBarHairlineImageView.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;

    if ((_tableView.pullToRefreshView)&& [_tableView.pullToRefreshView state] ==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && [_tableView.infiniteScrollingView state]== SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    [LoadingView stopOnTheViewController:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self];

    
}
#pragma mark UI
-(void)setNavigationView
{
    self.navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    self.navigationView.backgroundColor = [BBSColor hexStringToColor:NAVICOLOR];
    [self.view addSubview:self.navigationView];
}
-(void)setLeftButton{
    CGRect backBtnFrame=CGRectMake(10, 30, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *imageBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 31)];
    imageBack.image = [UIImage imageNamed:@"btn_back1.png"];
    [_backBtn addSubview:imageBack];
    _labelGroupName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 230, 31)];
    _labelGroupName.textColor = [UIColor whiteColor];
    [_backBtn addSubview:_labelGroupName];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    [self.navigationView addSubview:_backBtn];
    
}
-(void)setRightButton{
    
    _FTBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _FTBtn.frame=CGRectMake(SCREENWIDTH-49, 30, 49, 31);
    [_FTBtn setTitle:@"发帖" forState:UIControlStateNormal];
    [_FTBtn addTarget:self action:@selector(makeAPost) forControlEvents:UIControlEventTouchUpInside];
    _FTBtn.titleLabel.font=[UIFont systemFontOfSize:15.8];
    [self.navigationView addSubview:_FTBtn];
    
}


-(void)setHeaderView{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90)];
    _headerView.backgroundColor = [BBSColor hexStringToColor:NAVICOLOR];
    _avatarImg = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 70, 70)];
    _avatarImg.layer.cornerRadius = 35;
    _avatarImg.layer.masksToBounds = YES;
    [_headerView addSubview:_avatarImg];
    
    _nickNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 15, 170, 18)];
    _nickNameLabel.font = [UIFont systemFontOfSize:15];
    _nickNameLabel.textColor = [UIColor whiteColor];
    [_headerView addSubview:_nickNameLabel];
    
    _review_countLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 43, 100, 15)];
    _review_countLabel.font = [UIFont systemFontOfSize:13];
    _review_countLabel.textColor = [UIColor whiteColor];
    [_headerView addSubview:_review_countLabel];
    
    _post_countLabel = [[UILabel alloc]initWithFrame:CGRectMake(90, 65, 100, 15)];
    _post_countLabel.font = [UIFont systemFontOfSize:13];
    _post_countLabel.textColor = [UIColor whiteColor];
    [_headerView addSubview:_post_countLabel];
    
    _shareButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _shareButton.frame = CGRectMake(SCREENWIDTH-15-68, 47, 68, 29);
    [_shareButton addTarget:self action:@selector(cancelShareButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_headerView addSubview:_shareButton];
    [self getHeaderViewData];
    
    
}

-(void)setTableView{
    
    CGRect tableviewFrame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    _tableView=[[UITableView alloc]initWithFrame:tableviewFrame];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
    
    //类型是话题列表
    [_tableView setTableHeaderView:_headerView];
    __weak PostMyGroupDetailVController *postBar=self;
    [_tableView addPullToRefreshWithActionHandler:^{
        postBar.isRefresh=YES;
        postBar.isFinished=NO;
        postBar.isGetMore=NO;
        postBar.last_id=NULL;
        [postBar getData];
        [postBar getHeaderViewData];
    }];
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

#pragma mark data
-(void)getHeaderViewData{
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%ld",(long)_group_id],@"group_id",nil];
    [[HTTPClient sharedClient]getNewV1:kGetGroupInfo params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSArray *infoArray = result[@"data"];
            for (NSDictionary *infoDic in infoArray) {
                // [_avatarImg setImageWithURL:infoDic[@"avatar"]];
                [_avatarImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",infoDic[@"avatar"]]]];
                _nickNameLabel.text = [NSString stringWithFormat:@"圈主：%@",infoDic[@"nick_name"]];
                if([infoDic[@"review_count"] isKindOfClass:[NSNull class]] ){
                    _review_countLabel.text = @"参与0人";
                    
                }else{
                    NSNumber *review_count = infoDic[@"review_count"];
                    _review_countLabel.text = [NSString stringWithFormat:@"参与%@人",review_count];
                }
                _post_countLabel.text = [NSString stringWithFormat:@"帖子%@个",infoDic[@"post_count"]];
                _isShare = [[infoDic objectForKey:@"is_share"]boolValue];
                _userId = [[infoDic objectForKey:@"user_id"]stringValue];
                NSString *longuserString = [NSString stringWithFormat:@"%@",LOGIN_USER_ID];
                _groupName = [infoDic objectForKey:@"group_name"];
                _labelGroupName.text = _groupName;

                
                
                if ([longuserString isEqualToString:_userId]) {
                    //[_shareButton setTitle:@"编辑" forState:UIControlStateNormal];
                    [_shareButton setBackgroundImage:[UIImage imageNamed:@"btn_qun_manage"] forState:UIControlStateNormal];
                }else{
                    //加关注
                    if (_isShare == 1) {
                        [_shareButton setBackgroundImage:[UIImage imageNamed:@"btn_quxiaoguanzhu"] forState:UIControlStateNormal];
                    }else{
                        [_shareButton setBackgroundImage:[UIImage imageNamed:@"btn_tianjiaguanzhu"] forState:UIControlStateNormal];
                        
                    }
                }
            }
        }
    } failed:^(NSError *error) {
        // [BBSAlert showAlertWithContent:@"网络连接错误请重试" andDelegate:nil];
        
    }];
}
//添加关注成功的通知方法
-(void)postIdolSucceed{
    //
    [self getHeaderViewData];
}
//添加失败的通知方法
-(void)postIdolFail{
}

//取消关注通知方法
-(void)cancelPostIdolSucceed{
    [self getHeaderViewData];
}
-(void)cancelPostIdolFail{
    
}
//关注按钮触发的事件
-(void)cancelShareButtonAction{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:LOGIN_USER_ID forKey:@"login_user_id"];
    [param setObject:[NSString stringWithFormat:@"%ld",(long)self.group_id]forKey:@"group_id"];
    NSString *longuserString = [NSString stringWithFormat:@"%@",LOGIN_USER_ID];
    if ([longuserString isEqualToString:_userId]) {
        PostGroupEditViewController *postGroupEditVC = [[PostGroupEditViewController alloc]init];
        postGroupEditVC.login_user_id = LOGIN_USER_ID;
        postGroupEditVC.group_id = _group_id;
        postGroupEditVC.groupName = _groupName;
        postGroupEditVC.refreshPostDetail= ^(NSString *groupName,BOOL isRefreshIntheVC){
            _labelGroupName.text = groupName;
            self.groupName = groupName;
            if (isRefreshIntheVC == YES) {
                self.isRefreshIntheVC = isRefreshIntheVC;
                
            }
        };
        [self.navigationController pushViewController:postGroupEditVC animated:NO];
    } else if (_isShare == 1) {
        NetAccess *net = [NetAccess sharedNetAccess];
        [net getDataWithStyle:NetStyleCancelPostIdol andParam:param];
        [self getHeaderViewData];
        
    }else{
        NetAccess *net = [NetAccess sharedNetAccess];
        [net getDataWithStyle:NetStylePostIdol andParam:param];
    }
    // [LoadingView startOnTheViewController:self];
}

-(void)getData
{
    NetAccess *net  = [NetAccess sharedNetAccess];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%ld",(long)_group_id],@"group_id",self.last_id,@"post_create_time", nil];
    [net getDataWithStyle:NetStyleGroupDetailList andParam:paramDic];
    [LoadingView startOnTheViewController:self];
}
-(void)back{
    
    self.refreshBlock(_isRefreshIntheVC);
    [self.navigationController popViewControllerAnimated:YES];
    
}
//发帖
-(void)makeAPost{
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    
    if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL) {
        LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
        
        UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
        [self presentViewController:nav animated:YES completion:^{
        }];
        return;
    }
    PostBarNewMakeAPost *makePostVC=[[PostBarNewMakeAPost alloc]init];
    makePostVC.group_id = self.group_id;
    makePostVC.post_class = self.post_class;
    makePostVC.isFromGroup = @"isfromGroup";
    makePostVC.update = ^(){
        _isRefreshIntheVC = YES;
        NSLog(@"ljalklak");
    };
    [makePostVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:makePostVC animated:YES];
}
-(void)dimissAlert:(UIAlertView *)alert{
    if (alert) {
        [alert dismissWithClickedButtonIndex:[alert cancelButtonIndex] animated:YES];
    }
}
#pragma mark alerviewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
        if (buttonIndex==1) {
            AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate setStartViewController];
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
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    
}


#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    PostMyGroupDetailItem *item = [_dataArray objectAtIndex:indexPath.row];
    if ([item.distinguish isEqualToString:@"1"]||[item.distinguish isEqualToString:@"2"]) {
        return 39;
    }
    return 78;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostMyGroupDetailItem *item = [_dataArray objectAtIndex:indexPath.row];
    if ([item.distinguish isEqualToString:@"1"]) {
        NSString *identifierGongGao = [NSString stringWithFormat:@"IDENTIFIERGONGGAO"];
        PostGroupSpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierGongGao];
        if (cell == nil) {
            cell = [[PostGroupSpecialCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierGongGao];
        }
        cell.labelGongGao.text = @"公告";
        cell.labelGongGao.textColor = [BBSColor hexStringToColor:@"779dfe"];
        cell.imgType.image = [UIImage imageNamed:@"img_postbar_gonggao"];
        cell.labelName.text = item.img_title;
        //cell.labelSubName.text = item.describe;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

        
    }else if ([item.distinguish isEqualToString:@"2"]){
        NSString *identifierJingHua = [NSString stringWithFormat:@"IDENTIFIERJINGHUA"];
        PostGroupSpecialCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierJingHua];
        if (cell == nil) {
            cell = [[PostGroupSpecialCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierJingHua];
        }
        cell.labelGongGao.text = @"精华";
        cell.labelGongGao.textColor = [BBSColor hexStringToColor:@"fc7675"];
        cell.imgType.image = [UIImage imageNamed:@"img_postbar_jinghua"];
        cell.labelName.text = item.img_title;
        //cell.labelSubName.text = item.describe;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

        
    }else{
    
    NSString *identifier = [NSString stringWithFormat:@"MYGROUPDETAIL"];
    PostMyInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PostMyInterestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.label.frame = CGRectMake(0, 77, SCREENWIDTH, 1);
    if (!(item.img.length <= 0)) {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:item.img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            cell.photoView.frame = CGRectMake(10, 10, 60, 60);
            cell.photoView.image = image;
            
        }];
        cell.titleLabel.frame = CGRectMake(80, 8, 220, 20);
        cell.reviewLabel.frame = CGRectMake(80, 35, 200, 18);
        cell.descriptionLabel.frame = CGRectMake(80, 57, 213, 17);
        
    }else
    {
        cell.photoView.frame = CGRectMake(0, 0, 0, 0);
        cell.titleLabel.frame = CGRectMake(10, 8, 250, 20);
        cell.reviewLabel.frame = CGRectMake(10, 35, 200, 18);
        cell.descriptionLabel.frame = CGRectMake(10, 57, 213, 17);
        cell.videoView.frame = CGRectMake(0, 0, 0, 0);
    }
    if (item.is_group == 2) {
        cell.groupImageV.frame = CGRectMake(0, 2, 20, 20);
        cell.groupImageV.image = [UIImage imageNamed:@"img_post_store@2x"];
        CGFloat a = cell.titleLabel.frame.size.width -20;
        cell.titleLabelS.frame = CGRectMake(21, 0, a, 23);
        cell.photoView.layer.masksToBounds = NO;
        cell.videoView.frame = CGRectMake(0, 0, 0, 0);

        
    }else if (item.is_group == 5 && !(item.img.length <=0)){
        CGFloat b = cell.titleLabel.frame.size.width;
        cell.groupImageV.frame = CGRectMake(0, 0, 0, 0);
        cell.titleLabelS.frame = CGRectMake(0, 0, b, 23);
        cell.photoView.layer.masksToBounds = NO;
        cell.videoView.frame = CGRectMake(20, 22, 67*0.5, 67*0.5);
        
    }else{
        CGFloat b = cell.titleLabel.frame.size.width;
        cell.groupImageV.frame = CGRectMake(0, 0, 0, 0);
        cell.titleLabelS.frame = CGRectMake(0, 0, b, 23);
        cell.photoView.layer.masksToBounds = NO;
        cell.videoView.frame = CGRectMake(0, 0, 0, 0);

    }
    if (item.is_group == 2) {
        cell.titleLabelS.text = item.img_title;
        cell.reviewLabel.text = [NSString stringWithFormat:@"参与%@人  观看%@人",item.reviewCount,item.postCount];
        cell.descriptionLabel.text = item.describe;
        cell.descriptionLabel.textColor = [BBSColor hexStringToColor:@"#878787"];
        
    }else{
        cell.titleLabelS.text = item.img_title;
        cell.reviewLabel.text = [NSString stringWithFormat:@"参与%@人  观看%@人",item.reviewCount,item.postCount];
        cell.descriptionLabel.text = item.describe;
        cell.descriptionLabel.textColor = [BBSColor hexStringToColor:@"#878787"];
    }
        [cell.photoView setContentMode:UIViewContentModeScaleAspectFill];
        cell.photoView.clipsToBounds = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    }
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostMyGroupDetailItem *item = [_dataArray objectAtIndex:indexPath.row];
    if ([item.distinguish isEqualToString:@"1"]) {
        JingHuaVC *jingHuaVC = [[JingHuaVC alloc]init];
        jingHuaVC.goup_type = 1;
        jingHuaVC.login_user_id = LOGIN_USER_ID;
        jingHuaVC.goupId = _group_id;
        [self.navigationController pushViewController:jingHuaVC animated:YES];
    
        
    }else if([item.distinguish isEqualToString:@"2"]){
        JingHuaVC *jingHuaVC = [[JingHuaVC alloc]init];
        jingHuaVC.goup_type = 2;
        jingHuaVC.login_user_id = LOGIN_USER_ID;
        jingHuaVC.goupId = _group_id;

        [self.navigationController pushViewController:jingHuaVC animated:YES];

        
    }else{
    if (item.is_group == 2) {
        StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
        storeVC.longin_user_id = LOGIN_USER_ID;
        storeVC.business_id = item.imgId;
        [self.navigationController pushViewController:storeVC animated:YES];
        
    }else if(item.is_group == 4){
        StoreMoreListVC *storeListVC = [[StoreMoreListVC alloc]init];
        storeListVC.login_user_id = LOGIN_USER_ID;
        [self.navigationController pushViewController:storeListVC animated:YES];
    }else if (item.is_group == 5){
        BabyShowPlayerVC *babyShowPlayVC = [[BabyShowPlayerVC alloc]init];
        babyShowPlayVC.videoUrl = item.videoUrl;
        babyShowPlayVC.img_id = item.imgId;
        [self.navigationController pushViewController:babyShowPlayVC animated:YES];
 
    }else{
        
        PostBarNewDetialV1VC *detailVC = [[PostBarNewDetialV1VC alloc]init];
        detailVC.img_id=item.imgId;
        detailVC.user_id=item.userid;
        detailVC.login_user_id=LOGIN_USER_ID;
                detailVC.refreshInVC = ^(BOOL isRefreshInTheVC){
                    if (isRefreshInTheVC == YES) {
                        _isRefresh = YES;
                        _isGetMore = NO;
                        _isFinished = NO;
                        self.last_id = NULL;
                        [self getData];
                        [self getHeaderViewData];
                        _isRefreshIntheVC = isRefreshInTheVC;
                    }
                    
                };

        [detailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
    }
    }
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
