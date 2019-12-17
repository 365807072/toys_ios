//
//  JingHuaVC.m
//  BabyShow
//
//  Created by WMY on 15/12/25.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "JingHuaVC.h"
#import "SVPullToRefresh.h"
//#import "UIImageView+AFNetworking.h"
#import "PostMyInterestCell.h"
#import "PostMyGroupDetailItem.h"
#import "UIImageView+WebCache.h"
#import "PostBarNewMakeAPost.h"
//#import "PostBarNewDetailVC.h"
#import "PostGroupEditViewController.h"

#import "StoreMoreListVC.h"
#import "PostGroupSpecialCell.h"
#import "PostBarNewDetialV1VC.h"
#import "StoreDetailNewVC.h"
#import "BabyShowPlayerVC.h"


@interface JingHuaVC (){
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

@end

@implementation JingHuaVC
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_POST_NOTICERECGROUPLIST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_POST_NOTICERECGROUPLIST_FAIL object:nil];
    
    //网络错误
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    }


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor whiteColor];
    if (_goup_type == 1) {
        self.navigationItem.title = @"公告";
    }else{
        self.navigationItem.title = @"精华";
    }
    [self setLeftButton];
    [self setTableView];
    [self getData];


    // Do any additional setup after loading the view.
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
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
   
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
#pragma mark UI
-(void)setTableView{
    
    CGRect tableviewFrame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    _tableView=[[UITableView alloc]initWithFrame:tableviewFrame];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
    
    __weak JingHuaVC *postBar=self;
    [_tableView addPullToRefreshWithActionHandler:^{
        
        postBar.isRefresh=YES;
        postBar.isFinished=NO;
        postBar.isGetMore=NO;
        postBar.last_id=NULL;
        [postBar getData];
        
        
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

-(void)getData
{
    NetAccess *net  = [NetAccess sharedNetAccess];
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%ld",(long)_goupId],@"group_id",[NSString stringWithFormat:@"%ld",_goup_type],@"group_type",self.last_id,@"post_create_time", nil];
    [net getDataWithStyle:NetStyleNoticeRecGroupList andParam:paramDic];
    [LoadingView startOnTheViewController:self];
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
            //[self showHUDWithMessage:@"已没有更多数据"];
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
    
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state == 2) {
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
       return 78;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PostMyGroupDetailItem *item = [_dataArray objectAtIndex:indexPath.row];
        NSString *identifier = [NSString stringWithFormat:@"MYGROUPJINHUALIST"];
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
            if (item.is_group == 5) {
                cell.videoView.frame = CGRectMake(20, 22, 67*0.5, 67*0.5);
 
            }else{
                cell.videoView.frame = CGRectMake(0, 0, 0, 0);
            }
            cell.titleLabel.frame = CGRectMake(80, 8, 220, 20);
            cell.reviewLabel.frame = CGRectMake(80, 35, 200, 18);
            cell.descriptionLabel.frame = CGRectMake(80, 57, 213, 17);
            
        }else
        {
            cell.photoView.frame = CGRectMake(0, 0, 0, 0);
            cell.titleLabel.frame = CGRectMake(10, 8, 250, 20);
            cell.reviewLabel.frame = CGRectMake(10, 35, 200, 18);
            cell.descriptionLabel.frame = CGRectMake(10, 57, 213, 17);
        }
        if (item.is_group == 2) {
            cell.groupImageV.frame = CGRectMake(0, 2, 20, 20);
            cell.groupImageV.image = [UIImage imageNamed:@"img_post_store@2x"];
            CGFloat a = cell.titleLabel.frame.size.width -20;
            cell.titleLabelS.frame = CGRectMake(21, 0, a, 23);
            cell.photoView.layer.masksToBounds = NO;
            
        }else{
            CGFloat b = cell.titleLabel.frame.size.width;
            cell.groupImageV.frame = CGRectMake(0, 0, 0, 0);
            cell.titleLabelS.frame = CGRectMake(0, 0, b, 23);
            cell.photoView.layer.masksToBounds = NO;
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
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PostMyGroupDetailItem *item = [_dataArray objectAtIndex:indexPath.row];
        if (item.is_group == 2) {
            StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
            storeVC.longin_user_id = self.login_user_id;
            storeVC.business_id = item.imgId;
            [self.navigationController pushViewController:storeVC animated:YES];
            
        }else if(item.is_group == 4){
            StoreMoreListVC *storeListVC = [[StoreMoreListVC alloc]init];
            storeListVC.login_user_id = self.login_user_id;
            [self.navigationController pushViewController:storeListVC animated:YES];
        }else if (item.is_group == 5){
            BabyShowPlayerVC *babyShowPlayVC = [[BabyShowPlayerVC alloc]init];
            BOOL isHV;
            if ([item.img_thumb_height floatValue] > [item.img_thumb_width floatValue]) {
                isHV = NO;//横屏
            }else{
                isHV = YES;
            }
            babyShowPlayVC.videoUrl = item.videoUrl;
            babyShowPlayVC.img_id = item.imgId;
            babyShowPlayVC.isHV = isHV;
            [self.navigationController pushViewController:babyShowPlayVC animated:YES];
            
        }else{
            PostBarNewDetialV1VC *detailVC = [[PostBarNewDetialV1VC alloc]init];
            detailVC.img_id=item.imgId;
            detailVC.user_id=item.userid;
            detailVC.login_user_id=self.login_user_id;
            detailVC.refreshInVC = ^(BOOL isRefreshInTheVC){
                if (isRefreshInTheVC == YES) {
                    _isRefresh = YES;
                    _isGetMore = NO;
                    _isFinished = NO;
                    self.last_id = NULL;
                    [self getData];

                }
                
            };
            [detailVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:detailVC animated:YES];
        }
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
