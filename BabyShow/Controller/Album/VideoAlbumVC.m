//
//  VideoAlbumVC.m
//  BabyShow
//
//  Created by WMY on 16/7/7.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "VideoAlbumVC.h"
#import "SDWebImageManager.h"
#import "BabyShowPlayerVC.h"

@interface VideoAlbumVC (){
    RefreshControl *_refreshControl;
}
@property(nonatomic,strong)NSString *postCreateTimeNew;
@end

@implementation VideoAlbumVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _dataArrayNew=[[NSMutableArray alloc]init];
    }
    return self;

}
-(void)viewWillAppear:(BOOL)animated{
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.tabBarController.tabBar.hidden = YES;
    


}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setBackBtn];
    [self setTableView];
    [self refreshControlInit];
    // Do any additional setup after loading the view.
}
#pragma mark UI

-(void)setBackBtn{
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
    self.title = @"视频";
    
}
//已复制
-(void)setTableView{
    
    //最新
    _tableViewVideo = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    _tableViewVideo.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableViewVideo.dataSource = self;
    _tableViewVideo.delegate = self;
    _tableViewVideo.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewVideo.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableViewVideo];
    
    
}
#pragma mark -refreshControl
-(void)refreshControlInit{
    _refreshControl = [[RefreshControl alloc]initWithScrollView:_tableViewVideo delegate:self];
    _refreshControl.topEnabled = YES;
    _refreshControl.bottomEnabled = NO;
    [_refreshControl startRefreshingDirection:RefreshDirectionTop];
    
}
-(void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    if (refreshControl == _refreshControl) {
        if (direction == RefreshDirectionTop) {
            _postCreateTimeNew = NULL;
            
        }
        
        [self getDataVideoList];
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
-(void)getDataVideoList{
    NSDictionary *newParam = [NSDictionary dictionaryWithObjectsAndKeys:
                              LOGIN_USER_ID,@"login_user_id",self.userId,@"user_id",_postCreateTimeNew,@"post_create_time",nil];
    
    UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kGetVideoList Method:NetMethodGet andParam:newParam];
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
    
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:15];
    [request startAsynchronous];
    
    __weak ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:@"success"]integerValue] == 1) {
            NSArray *dataArray = [dic objectForKey:@"data"];
            NSMutableArray *returnArray=[NSMutableArray array];
            if (dataArray.count == 0) {
                [BBSAlert showAlertWithContent:@"已没有相关视频" andDelegate:self];
                [self refreshComplete:_refreshControl];

            }else{
            for (NSDictionary *dataDic in dataArray) {
                VideoItem *videoItem = [[VideoItem alloc]init];
                videoItem.img_id = dataDic[@"img_id"];
                videoItem.post_create_time = dataDic[@"post_create_time"];
                videoItem.video_url = dataDic[@"video_url"];
                videoItem.img = dataDic[@"img"];
                videoItem.create_time = dataDic[@"create_time"];
                videoItem.img_thumb_width = dataDic[@"img_width"];
                videoItem.img_thumb_height = dataDic[@"img_height"];
                [returnArray addObject:videoItem];
            }
            if (returnArray.count == 0) {
                _refreshControl.bottomEnabled = NO;
            }
            if (_postCreateTimeNew == NULL) {
                [_dataArrayNew removeAllObjects];
                _refreshControl.bottomEnabled = YES;
            }
            VideoItem *item = [returnArray lastObject];
            _postCreateTimeNew = item.post_create_time;
            [_dataArrayNew addObjectsFromArray:returnArray];
            [_tableViewVideo reloadData];
            [self refreshComplete:_refreshControl];
            }
        }else{
            [self refreshComplete:_refreshControl];
            [BBSAlert showAlertWithContent:[dic objectForKey:kBBSReMsg] andDelegate:self];
        }
        
    }];
    [request setFailedBlock:^{
        [self refreshComplete:_refreshControl];
    }];

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArrayNew count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  SCREENWIDTH*0.6+20+55;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *identifier = [NSString stringWithFormat:@"MYVIDEOPLAYCELL"];
    PlayVideoMyCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[PlayVideoMyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    VideoItem *item = [_dataArrayNew objectAtIndex:indexPath.row];
    cell.dateLable.text = item.create_time;
    float height = [item.img_thumb_height floatValue];
    float weight = [item.img_thumb_width floatValue];

    SDWebImageManager *manager=[SDWebImageManager sharedManager];
    if (height>weight) {
        [manager downloadImageWithURL:[NSURL URLWithString:item.img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            cell.ImgBtn.image = image;
            cell.imgBigBtn.image = image;
            cell.imgBigBtn.hidden = NO;
            cell.grayView.hidden = NO;
        }];
        
    }else{
        [manager downloadImageWithURL:[NSURL URLWithString:item.img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            cell.ImgBtn.image = image;
            cell.imgBigBtn.hidden = YES;
            cell.grayView.hidden = YES;
        }];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}
#pragma mark -点击图片跳转播放详情页面

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    VideoItem *item = [_dataArrayNew objectAtIndex:indexPath.row];
    BabyShowPlayerVC *babyShowPlayerVC = [[BabyShowPlayerVC alloc]init];
    babyShowPlayerVC.videoUrl = item.video_url;
    babyShowPlayerVC.img_id = item.img_id;
    [self.navigationController pushViewController:babyShowPlayerVC animated:YES];
    
}
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//#pragma mark 当滚动的时候隐藏和显示导航条
//
//CGPoint point;
//
//-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
//    point=scrollView.contentOffset;
//    
//}
//
//-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
//    
//    //down
//    if (point.y-scrollView.contentOffset.y>40) {
//        [UIView beginAnimations:nil context:nil];
//        [UIView setAnimationDuration:0.25];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//        _tableViewVideo.frame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
//        [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
//        [UIView commitAnimations];
//    }
//    //up
//    if (point.y-scrollView.contentOffset.y<-40) {
//            [UIView beginAnimations:nil context:nil];
//            [UIView setAnimationDuration:0.25];
//            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//            [self.navigationController setNavigationBarHidden:YES animated:YES];
//            _tableViewVideo.frame=CGRectMake(0, 20, SCREENWIDTH, SCREENHEIGHT-20);
//            [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
//            [UIView commitAnimations];
//        
//    }
//}

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
