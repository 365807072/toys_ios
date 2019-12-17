//
//  TA_AlbumListViewController.m
//  BabyShow
//
//  Created by Lau on 14-1-18.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "TA_AlbumListViewController.h"
#import "JSONKit.h"
#import "AlbumListCell.h"
#import "AlbumList2ViewController.h"
#import "ThemeAlbumViewController.h"
#import "SingleAlbumViewController.h"
#import "DateFormatter.h"
#import "ShowAlertView.h"
#import "UIImageView+WebCache.h"
#import "VideoAlbumVC.h"

@interface TA_AlbumListViewController ()
{
    NSIndexPath *moveIndexPath;         //移动时记录点击的位置
}
@end

@implementation TA_AlbumListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.dataSourceArray = [[NSMutableArray alloc] init];

    }
    return self;
}
-(void)setBackButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor =[UIColor whiteColor]; 
    [self setBackButton];
    
    self.automaticallyAdjustsScrollViewInsets =NO;
    
    self.albumListTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-(64+40)) style:UITableViewStylePlain];
    self.albumListTableView.delegate = self;
    self.albumListTableView.dataSource = self;
    self.albumListTableView.backgroundColor=[UIColor clearColor];
    self.albumListTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.albumListTableView];
    __block TA_AlbumListViewController *blockSelf = self;
    [self.albumListTableView addPullToRefreshWithActionHandler:^{
        [blockSelf startRequestAlbumList];
    }];
    
    CGRect frame  = self.albumListTableView.frame;
    CGFloat tableHeight = frame.size.height;
    
    self.askForShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.askForShareButton.frame = CGRectMake(0,(64+tableHeight), 320, 40);
    [self.askForShareButton setBackgroundImage:[UIImage imageNamed:@"img_upload_back"] forState:UIControlStateNormal];
    [self.askForShareButton setTitle:@"请求共享该用户相册" forState:UIControlStateNormal];
    [self.askForShareButton setTitleColor:[BBSColor hexStringToColor:BACKCOLOR] forState:UIControlStateNormal];
    [self.askForShareButton addTarget:self action:@selector(askForShare:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.askForShareButton];

}
#pragma mark - 请求共享
-(void)askForShare:(id)sender{

    if (self.isShare == 1) {
        //取消共享
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定"
//                                                           message:@"取消共享"
//                                                          delegate:self
//                                                 cancelButtonTitle:@"取消"
//                                                 otherButtonTitles:@"确定", nil];
//        alertView.tag = CANCEL_SHARE_REQUEST_TAG;
//        [alertView show];
    }else {
        //请求共享
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"确定"
                                                           message:@"发送请求"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"确定", nil];
        alertView.tag = SHARE_REQUEST_TAG;
        [alertView show];
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    NSString *user_id = LOGIN_USER_ID;
    NSString *share_id = self.ta_user_id;

    if (buttonIndex ==1) {
        if (alertView.tag == CANCEL_SHARE_REQUEST_TAG) {
            //取消共享
            if (self.cancelShareRequest) {
                [self.cancelShareRequest clearDelegatesAndCancel];
            }
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewBasicUrl,kDoShare]];
            self.cancelShareRequest = [ASIFormDataRequest requestWithURL:url];
            [self.cancelShareRequest setPostValue:share_id forKey:kDoShareUser_id];
            [self.cancelShareRequest setPostValue:user_id forKey:kDoShareShare_id];
            [self.cancelShareRequest setPostValue:@"1" forKey:kDoShareShare_type];
            [self.cancelShareRequest setPostValue:@"0" forKey:kDoShareIs_agree];
            [self.cancelShareRequest setDelegate:self];
            [self.cancelShareRequest setTag:CANCEL_SHARE_REQUEST_TAG];
            [self.cancelShareRequest startAsynchronous];

        }else if (alertView.tag == SHARE_REQUEST_TAG){
            if (self.askForShareRequest) {
                [self.askForShareRequest clearDelegatesAndCancel];
            }
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewBasicUrl,kDoShare]];
            self.askForShareRequest = [ASIFormDataRequest requestWithURL:url];
            [self.askForShareRequest setPostValue:user_id forKey:kDoShareUser_id];
            [self.askForShareRequest setPostValue:share_id forKey:kDoShareShare_id];
            [self.askForShareRequest setPostValue:@"0" forKey:kDoShareShare_type];
            [self.askForShareRequest setDelegate:self];
            [self.askForShareRequest setTag:SHARE_REQUEST_TAG];
            [self.askForShareRequest startAsynchronous];
        }
        
    } else {
        
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [self startRequestAlbumList];
    [super viewWillAppear:animated];
}
#pragma mark - 无相册时
-(void)setupViewWhenNoAlbum{
    [self.albumListTableView removeFromSuperview];
    
    UIView *no_albumView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    
    UIImageView *cry_imageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(96.5, 64+36, 127, 127)];
    cry_imageVIew.image = [UIImage imageNamed:@"img_myshow_empty_babyface"];
    [no_albumView addSubview:cry_imageVIew];
    
    UILabel *no_albumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+167, 320, 30)];
    no_albumLabel.text = @"暂时没有相册哦";
    no_albumLabel.textColor = [BBSColor hexStringToColor:@"c3ad8f"];
    no_albumLabel.backgroundColor =[UIColor clearColor];
    no_albumLabel.textAlignment = NSTextAlignmentCenter;
    [no_albumView addSubview:no_albumLabel];
    
    [self.view addSubview:no_albumView];
}

#pragma mark - 请求相册列表数据
-(void)startRequestAlbumList{
    //GET
    [LoadingView startOnTheViewController:self];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.ta_user_id,kAlbumListUser_id,LOGIN_USER_ID,kAlbumListLogin_user_id, nil];
    [[HTTPClient sharedClient] getNewV1:kAlbumList params:params success:^(NSDictionary *result) {
        [LoadingView stopOnTheViewController:self];
        if (self.albumListTableView.pullToRefreshView && [self.albumListTableView.pullToRefreshView state] == SVPullToRefreshStateLoading) {
            [self.albumListTableView.pullToRefreshView stopAnimating];
        }
        if ([[result objectForKey:kBBSSuccess] integerValue] == 1) {
            //是否是共享关系
            self.isShare = [[result objectForKey:@"isShare"]boolValue];
            if (self.isShare == 0) {              //未申请共享
                [self.askForShareButton setTitle:@"请求共享该用户相册" forState:UIControlStateNormal];
            } else  if (self.isShare == 1){       //已共享
                [self.askForShareButton setTitle:@"已共享" forState:UIControlStateNormal];
            }
            
            NSArray *data = [result objectForKey:kBBSData];
            if (data.count ==0) {//没有相册
                [self setupViewWhenNoAlbum];
            }else{
                [self.dataSourceArray removeAllObjects];
                NSMutableArray *tempArray = [[NSMutableArray alloc]init];
                for (int i = 0; i < data.count; i++) {
                    NSDictionary *model = [data objectAtIndex:i];
                    [tempArray addObject:model];
                    if (tempArray.count == 2 || i == data.count-1) {
                        NSArray *arr = [[NSArray alloc]initWithArray:tempArray];
                        [self.dataSourceArray addObject:arr];
                        [tempArray removeAllObjects];
                    }
                }
                [self.albumListTableView reloadData];
            }
        } else {
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
        if (self.albumListTableView.pullToRefreshView && [self.albumListTableView.pullToRefreshView state] == SVPullToRefreshStateLoading) {
            [self.albumListTableView.pullToRefreshView stopAnimating];
        }
        [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSourceArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"AlbumListIdentifier";
    
    AlbumBabyCell *cell = (AlbumBabyCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AlbumBabyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    NSArray *section0Array = [self.dataSourceArray objectAtIndex:indexPath.row];
    NSDictionary *model0 = nil;
    NSDictionary *model1 = nil;
    if (section0Array.count == 2) {
        model0 = [section0Array objectAtIndex:0];
        model1 = [section0Array objectAtIndex:1];
    }else {
        model0 = [section0Array objectAtIndex:0];
        model1 = nil;
    }
    if (model0) {
        [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:[model0 objectForKey:@"album_cover"]]];
        cell.leftAlbumNameLabel.text = [model0 objectForKey:@"album_name"];
        cell.leftBackGroundImageView.image = [UIImage imageNamed:@"album_border"];
        cell.leftBackGroundImageView.imageInfo = model0;
    }else {
        cell.leftImageView.image = nil;
        cell.leftAlbumNameLabel.text = nil;
        cell.leftBackGroundImageView.image = nil;
        cell.leftBackGroundImageView.imageInfo = nil;
    }
    if (model1) {
        [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:[model1 objectForKey:@"album_cover"]]];
        cell.rightAlbumNameLabel.text = [model1 objectForKey:@"album_name"];
        cell.rightBackGroundImageView.image = [UIImage imageNamed:@"album_border"];
        cell.rightBackGroundImageView.imageInfo = model1;
    }else {
        cell.rightImageView.image = nil;
        cell.rightAlbumNameLabel.text = nil;
        cell.rightBackGroundImageView.image = nil;
        cell.rightBackGroundImageView.imageInfo = nil;
    }

/**old    AlbumListCell *cell = (AlbumListCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell  =[[AlbumListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.accessoryType =UITableViewCellAccessoryDisclosureIndicator;
    //数据源
    NSDictionary *rowDictionary = [self.dataSourceArray objectAtIndex:indexPath.row];
    
    double  timeStamp = [[rowDictionary objectForKey:@"create_time"] doubleValue]/1000;
    NSString *create_time = [DateFormatter dateStringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp] formatter:@"yyyy-MM-dd HH:mm"];
    cell.albumNameLabel.text = [rowDictionary objectForKey:@"album_name"];
    [cell.albumCoverImageView setImageWithURL:[NSURL URLWithString:[rowDictionary objectForKey:@"album_cover"]]];
    cell.albumCountLabel.text = [NSString stringWithFormat:@"%@",[rowDictionary objectForKey:@"img_count"]];
    cell.albumCountLabel.backgroundColor =[BBSColor hexStringToColor:@"ea6863"];
    cell.albumCreatetimeLabel.text = create_time;
    cell.albumDescriptionLabel.text = @"";
    cell.m_checkImageView.hidden = YES; */
    return cell;
}
/**old
#pragma mark - UITableViewDelegate Methods
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *rowDictionary = [self.dataSourceArray objectAtIndex:indexPath.row];
    //是否是默认相册,0否,点击下一页同样进行相册列表请求(添加album_id参数) ,1是,点击进入下一页请求图片列表
    BOOL is_default = [[rowDictionary objectForKey:@"is_default"] boolValue];
    if (is_default) {
        SingleAlbumViewController *singleAlbumViewController = [[SingleAlbumViewController alloc]init];
        singleAlbumViewController.summaryDictionary = rowDictionary;
        singleAlbumViewController.user_id = self.ta_user_id;
        //添加一个用户类型,0我的,1他的,2他的并且已共享
        singleAlbumViewController.type = self.isShare?2:1;
        [singleAlbumViewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:singleAlbumViewController animated:YES];
        
    }else{
        //请求二级相册列表
        AlbumList2ViewController *albumList2ViewController =[[ AlbumList2ViewController alloc]init];
        albumList2ViewController.formerDict = rowDictionary;
        albumList2ViewController.type = self.isShare?2:1;      //TA的相册
        albumList2ViewController.user_id = self.ta_user_id;
        [albumList2ViewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:albumList2ViewController animated:YES];
    }
}
 */
#pragma mark - 新版点击事件 Methods
-(void)selectAlbumInfo:(NSDictionary *)imageInfo cell:(UITableViewCell *)cell isLeft:(BOOL)isLeft{
    if (imageInfo == nil) {
        return;
    }
    //是否是默认相册,0否,点击下一页同样进行相册列表请求(添加album_id参数) ,1是,点击进入下一页请求图片列表
    BOOL is_default = [[imageInfo objectForKey:@"is_default"] boolValue];
    if ([[imageInfo objectForKey:@"is_video"]integerValue] == YES) {
        //如果是视频的时候，跳转到下一级页面
        VideoAlbumVC *videoAlbumVC = [[VideoAlbumVC alloc]init];
        videoAlbumVC.userId = self.ta_user_id;
        [self.navigationController pushViewController:videoAlbumVC animated:YES];

    }else{
    if (is_default) {
        //判断进入主题相册还是秀秀相册
        if (![[imageInfo objectForKey:@"album_name"] isEqualToString:@"秀秀相册"]) {
            ThemeAlbumViewController *themeViewController = [[ThemeAlbumViewController alloc]init];
            themeViewController.user_id = self.ta_user_id;
            themeViewController.type = self.isShare?2:1;
            themeViewController.formerDict = imageInfo;
            [themeViewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:themeViewController animated:YES];
        }else{
            SingleAlbumViewController *singleAlbumViewController = [[SingleAlbumViewController alloc]init];
            singleAlbumViewController.summaryDictionary = imageInfo;
            singleAlbumViewController.user_id = self.ta_user_id;
            //添加一个用户类型,0我的,1他的,2他的并且已共享
            singleAlbumViewController.type = self.isShare?2:1;
            [singleAlbumViewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:singleAlbumViewController animated:YES];
        }
       
        
    }else{
        //请求二级相册列表
        AlbumList2ViewController *albumList2ViewController =[[ AlbumList2ViewController alloc]init];
        albumList2ViewController.formerDict = imageInfo;
        albumList2ViewController.type = self.isShare?2:1;      //TA的相册
        albumList2ViewController.user_id = self.ta_user_id;
        [albumList2ViewController setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:albumList2ViewController animated:YES];
    }
    }
}
#pragma mark - ASIHTTPRequest
-(void)requestStarted:(ASIHTTPRequest *)request{

    [LoadingView startOnTheViewController:self];
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    [LoadingView stopOnTheViewController:self];
    if (self.albumListTableView.pullToRefreshView && [self.albumListTableView.pullToRefreshView state] == SVPullToRefreshStateLoading) {
        [self.albumListTableView.pullToRefreshView stopAnimating];
    }

    NSString *requestString = [request responseString];
    NSDictionary *requestDictionary = [requestString objectFromJSONString];
    if (request.tag == SHARE_REQUEST_TAG){
        if ([[requestDictionary objectForKey:kBBSSuccess] integerValue] == 1) {
            [ShowAlertView showAlertViewWithTitle:nil message:@"发送请求成功" cancelTitle:@"确定"];
        }else {
            [BBSAlert showAlertWithContent:[requestDictionary objectForKey:kBBSReMsg] andDelegate:nil];
        }
    }else if (request.tag == CANCEL_SHARE_REQUEST_TAG){
        if ([[requestDictionary objectForKey:kBBSReMsg] integerValue] == 1) {
            [BBSAlert showAlertWithContent:@"取消成功" andDelegate:nil];
            [self startRequestAlbumList];
        }else {
            [BBSAlert showAlertWithContent:[requestDictionary objectForKey:kBBSReMsg] andDelegate:nil];
        }
    }
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    [LoadingView stopOnTheViewController:self];
    if (self.albumListTableView.pullToRefreshView && [self.albumListTableView.pullToRefreshView state] == SVPullToRefreshStateLoading) {
        [self.albumListTableView.pullToRefreshView stopAnimating];
    }
}

@end
