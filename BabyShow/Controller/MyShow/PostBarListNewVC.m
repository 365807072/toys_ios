//
//  PostBarListNewVC.m
//  BabyShow
//
//  Created by WMY on 16/8/8.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarListNewVC.h"
#import "PostBarNewWithImageCell.h"
#import "PostBarNewWithOutImageCell.h"
#import "PostBarWithPhotoItem.h"
#import "PostBarWithOutPhotoItem.h"
#import "UserInfoItem.h"
#import "SVPullToRefresh.h"
#import "PostBarHeaderItem.h"
#import "UIImageView+WebCache.h"
#import "PostMyInterestCell.h"
#import "PostMyInterestItem.h"
#import "PostMyGroupDetailVController.h"
#import "PostBarNewDetialV1VC.h"
#import "RefreshControl.h"
#import "BabyShowPlayerVC.h"
#import "StoreDetailNewVC.h"
#import "BabyshowPostBarNewCell.h"
#import "PostBarGroupNewVC.h"
#import "BabyShowMainItem.h"
#import "PostBarFirstCell.h"
#import "PostBarSecondCell.h"
#import "LeftPictureCell.h"
#import "StoreMainNewListVC.h"
#import "PostBarNewGroupOnlyOneVC.h"
@interface PostBarListNewVC (){
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    RefreshControl *_refreshControl;



}
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation PostBarListNewVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil//1
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray=[NSMutableArray array];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{//1
    
    [super viewWillAppear:animated];
    
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    _post_create_time = NULL;
    [self setTableView];
    [self setLeftButton];
    [self refreshControlInit];

    // Do any additional setup after loading the view.
}
#pragma mark- refreshControl

-(void)refreshControlInit{
    _refreshControl                             = [[RefreshControl alloc] initWithScrollView:_tableView delegate:self];
    _refreshControl.topEnabled                  = YES;
    _refreshControl.bottomEnabled               = NO;
    [_refreshControl startRefreshingDirection:RefreshDirectionTop];
    
    
}
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    if (refreshControl == _refreshControl) {
        if (direction == RefreshDirectionTop) {
            _post_create_time                           = NULL;
        }
        [self getData];
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
//返回按钮
-(void)setLeftButton{
    
    //返回按钮
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 31)];
    imagev.image = [UIImage imageNamed:@"btn_back1.png"];
    [_backBtn addSubview:imagev];
    UILabel *cateName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 190, 31)];
    cateName.textColor = [UIColor whiteColor];
    cateName.text = self.titleNav;
    [_backBtn addSubview:cateName];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    NSUserDefaults*pushJudge = [NSUserDefaults standardUserDefaults];
    if([[pushJudge objectForKey:@"push"]isEqualToString:@"push"]) {
        [_backBtn addTarget:self action:@selector(dismissVC) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    }
    
}
#pragma mark 推送过来的时候的返回按钮
-(void)dismissVC{
    NSUserDefaults * pushJudge = [NSUserDefaults standardUserDefaults];
    [pushJudge setObject:@""forKey:@"push"];
    [pushJudge synchronize];//记得立即同步
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setTableView{
    self.automaticallyAdjustsScrollViewInsets = NO;
    CGRect tableviewFrame=CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    _tableView=[[UITableView alloc]initWithFrame:tableviewFrame];
    _tableView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableView];
    
    
}
-(void)getData{
    NSMutableDictionary *paramDic;
    paramDic= [NSMutableDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.post_create_time,@"post_create_time", nil];
    UrlMaker *urlMarker;
    if ([self.fromFouce isEqualToString:@"myFouce"]) {
    urlMarker = [[UrlMaker alloc]initWithNewV1UrlStr:@"getIdolGroupList" Method:NetMethodGet andParam:paramDic];
    }else{
    if (self.type) {
        [paramDic setObject:self.type forKey:@"type"];
    }
    [paramDic setObject:[NSString stringWithFormat:@"%ld",self.tag_id] forKey:@"tag_id"];
        if (self.img_ids) {
               [paramDic setObject:self.img_ids forKey:@"img_ids"];
        }
         if (self.isThrid == YES) {
    urlMarker = [[UrlMaker alloc]initWithNewV1UrlStr:@"getOwnGroupList" Method:NetMethodGet andParam:paramDic];
        }else{
     urlMarker = [[UrlMaker alloc]initWithNewV1UrlStr:@"getListingHotList" Method:NetMethodGet andParam:paramDic];
        }
    }
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMarker.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:20];
    [request startAsynchronous];
    __weak ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        _refreshControl.topEnabled = YES;
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:@"success"]integerValue] == 1) {
            NSArray *dataArray = dic[@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
            for (NSDictionary *dataDic in dataArray) {
                BabyShowMainItem *item = [[BabyShowMainItem alloc]init];
                item.imgTitle = MBNonEmptyString(dataDic[@"img_title"]);
                item.imgId = MBNonEmptyString(dataDic[@"img_id"]);
                item.img_description = MBNonEmptyString(dataDic[@"img_description"]);
                item.reviewCount = MBNonEmptyString(dataDic[@"review_count"]);
                item.postCount = MBNonEmptyString(dataDic[@"post_count"]);
                //话题群商家
                item.style = MBNonEmptyString(dataDic[@"style"]);
                //图片样式
                item.imgStyle = [MBNonEmptyString(dataDic[@"img_style"])integerValue];
                item.video_url = MBNonEmptyString(dataDic[@"video_url"]);
                item.tag_id = [MBNonEmptyString(dataDic[@"tag_id"])integerValue];
                item.userName = MBNonEmptyString(dataDic[@"user_name"]);
                item.show_post_create_time = MBNonEmptyString(dataDic[@"show_post_create_time"]);
                item.postCreattime = MBNonEmptyString(dataDic[@"post_create_time"]);
                item.hot_time_title = MBNonEmptyString(dataDic[@"hot_time_title"]);
                //跳转
                item.type = MBNonEmptyString(dataDic[@"type"]);
                item.img_ids = MBNonEmptyString(dataDic[@"img_ids"]);
                item.imgArray = dataDic[@"img"];
                if (item.imgStyle == 8) {
                    //单图
                    item.height = 223;
                }else if (item.imgStyle == 5){
                    item.height = [self resetFrameWithTitle:item.imgTitle width:SCREENWIDTH-10];
                    //纯文字
                }else if (item.imgStyle == 6 || item.imgStyle == 7){
                    //单图加文字
                    item.height = [self resetFrameWithTitle:item.imgTitle width:SCREENWIDTH-104-20];
                }
                [returnArray addObject:item];
            }
            if (returnArray.count == 0) {
                _refreshControl.bottomEnabled = NO;
            }
            if (_post_create_time == NULL) {
                [_dataArray removeAllObjects];
                _refreshControl.bottomEnabled = YES;
            }
            BabyShowMainItem *item = [returnArray lastObject];
            _post_create_time = item.postCreattime;
            [_dataArray addObjectsFromArray:returnArray];
            [_tableView reloadData];
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
#pragma mark  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 5小图纯文字，6小图加文字，7小图视频，8大图
    BabyShowMainItem *item = [_dataArray objectAtIndex:indexPath.row];
    if (item.imgStyle == 8) {
        return item.height;
    }else if(item.imgStyle == 7 || item.imgStyle == 6){
        return 90;
    }else if (item.imgStyle == 5 ){
        if (item.height == 0) {
            return 12+12+12;
        }else{
            return 12+item.height+12+12+12;
        }
        
    }
    
    return 100;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //cell的重用
    UITableViewCell *returnCell;

    //如果是话题的话，cell的格式
    BabyShowMainItem *item = [_dataArray objectAtIndex:indexPath.row];
    if (item.imgStyle == 5){
        //纯文字
        NSString *identifier = [NSString stringWithFormat:@"POSTBARFIRSTCELL"];
        PostBarFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PostBarFirstCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.describleLabel.text = item.imgTitle;
        if ([item.type isEqualToString:@"32"]) {
            cell.groupImgView.hidden = NO;
            if (item.userName.length >0 && item.postCount.length > 0) {
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@",item.userName];
            }else if (item.userName.length >0 && item.postCount.length <= 0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@",item.userName];
            }else if (item.userName.length <=0 && item.postCount.length >0){
                cell.praiseCountLabel.text = @"";
            }

        }else{
            cell.groupImgView.hidden = YES;
            if (item.userName.length >0 && item.postCount.length > 0) {
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@   %@观看",item.userName,item.postCount];
            }else if (item.userName.length >0 && item.postCount.length <= 0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@",item.userName];
            }else if (item.userName.length <=0 && item.postCount.length >0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@观看",item.postCount];
            }

        }

        [cell resetFrameWithDescribeContent:item.imgTitle];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        returnCell = cell;
        
    }else if (item.imgStyle == 7 || item.imgStyle == 6){
        //图加文
        NSString *identifierSecond = [NSString stringWithFormat:@"POSTBARSECOND"];
        PostBarSecondCell *cell = [tableView dequeueReusableCellWithIdentifier:identifierSecond];
        if (!cell) {
            cell = [[PostBarSecondCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierSecond];
        }
        cell.titleLabel.text = item.imgTitle;
        [cell resetFrameWithDescribeContent:item.imgTitle];

        NSString *imgTitle;
        NSDictionary *imgDic1;
        
        if (item.imgArray) {
            imgDic1 = item.imgArray[0];
            imgTitle = MBNonEmptyString(imgDic1[@"img_thumb"]);
            
        }
        
        if (imgTitle.length > 0) {
            [cell.photoView sd_setImageWithURL:[NSURL URLWithString:imgTitle]];
        }
        
        if (item.video_url.length>0) {
            cell.videoView.frame = CGRectMake(213+30, 30, 67*0.5, 67*0.5);
        }else{
            cell.videoView.frame = CGRectMake(0, 0, 0, 0);
            
        }
        if ([item.type isEqualToString:@"32"]) {
            cell.groupImgView.hidden = NO;
            if (item.userName.length >0 && item.postCount.length > 0) {
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@",item.userName];
            }else if (item.userName.length >0 && item.postCount.length <= 0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@",item.userName];
            }else if (item.userName.length <=0 && item.postCount.length >0){
                cell.praiseCountLabel.text = @"";
            }

        }else{
            cell.groupImgView.hidden = YES;
            if (item.userName.length >0 && item.postCount.length > 0) {
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@   %@观看",item.userName,item.postCount];
            }else if (item.userName.length >0 && item.postCount.length <= 0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@",item.userName];
            }else if (item.userName.length <=0 && item.postCount.length >0){
                cell.praiseCountLabel.text = [NSString stringWithFormat:@"%@观看",item.postCount];
            }

        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        returnCell = cell;
    }else if (item.imgStyle == 8){
        NSString *identifier = [NSString stringWithFormat:@"LEFTPICTURECELL"];
        LeftPictureCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[LeftPictureCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        NSString *imgTitle;
        NSDictionary *imgDic1;
        NSString *imgString;
        
        if (item.imgArray) {
            imgDic1 = item.imgArray[0];
            imgTitle = MBNonEmptyString(imgDic1[@"img_thumb"]);
            
        }
        if (imgTitle.length > 0) {
            [cell.imgViewBig sd_setImageWithURL:[NSURL URLWithString:imgTitle]];
        }
        cell.dateLabel.text = item.userName;
        cell.titleLabel.text = item.imgTitle;
        cell.subuTitleLabel.text = item.img_description;
        cell.hotDataLabel.text = [NSString stringWithFormat:@"-  %@  -",item.hot_time_title];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        returnCell = cell;
    }

    return returnCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BabyShowMainItem *item = [_dataArray objectAtIndex:indexPath.row];
    NSString *imgId;
    NSString *userId ;
    NSString *imgIds;//跳列表时用的标示
    NSString *type;
    BOOL isHV;
    if (item.imgArray) {
        imgId  = item.imgArray[0][@"img_id"];
        userId = item.imgArray[0][@"user_id"];
        float height = [item.imgArray[0][@"img_thumb_height"] floatValue];
        float weight = [item.imgArray[0][@"img_thumb_width"] floatValue];
        if (height > weight) {
            isHV = NO;//横屏
        }else{
            isHV = YES;
        }
    }
    imgIds = item.img_ids;
    type = item.type;
    if ([item.type isEqualToString:@"1"]) {
        [self pushPostBarNewList:item.tag_id imgIds:imgIds type:type title:item.imgTitle];
        //话题列表
    }else if ([item.type isEqualToString:@"2"]){
        //某个帖
        [self pushPostNewDetialVC:imgId userId:userId];
        
    }else if ([item.type isEqualToString:@"3"]){
        //视频帖
        [self pushBabyShowPlayer:item.video_url imgId:imgId isHV:isHV];
        
    }else if ([item.type isEqualToString:@"21"]){
        //商家列表
        [self pushStoreNewList:item.tag_id imgIds:imgIds title:item.imgTitle];
        
    }
    else if ([item.type isEqualToString:@"22"]){
        //商家详情
        [self pushStoreDetialNewVC:imgId];
        
    }else if ([item.type isEqualToString:@"31"]){
        //群列表
        [self pushPostBarNewList:item.tag_id imgIds:imgId type:type title:item.imgTitle];
        
    }else if ([item.type isEqualToString:@"32"]){
        //群详情//可以
        [self pushPostMyGroupDetailVC:imgId];
        
    }



    
}
#pragma mark 跳转帖子列表
-(void)pushPostBarNewList:(NSInteger)tagId  imgIds:(NSString*)imgIds type:(NSString*)type  title:(NSString*)title{
    PostBarListNewVC *postBarListVC = [[PostBarListNewVC alloc]init];
    postBarListVC.tag_id = tagId;
    postBarListVC.img_ids = imgIds;
    postBarListVC.type = type;
    postBarListVC.titleNav = title;
    
    [self.navigationController pushViewController:postBarListVC animated:YES];
}
#pragma mark 跳转帖子详情
-(void)pushPostNewDetialVC:(NSString *)imgId userId:(NSString*)userId {
    //跳转帖子详情
    PostBarNewDetialV1VC *detailVC = [[PostBarNewDetialV1VC alloc]init];
    // PostBarNewDetailVC *detailVC=[[PostBarNewDetailVC alloc]init];
    
    detailVC.img_id=[NSString stringWithFormat:@"%@",imgId];
    detailVC.user_id=userId;
    detailVC.login_user_id=LOGIN_USER_ID;
    detailVC.refreshInVC = ^(BOOL isRefresh){
    };
    [detailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}
#pragma mark 跳转视频帖子
-(void)pushBabyShowPlayer:(NSString *)video_url imgId:(NSString*)imgId   isHV:(BOOL)isHV{
    BabyShowPlayerVC *babyShowPlayerVC = [[BabyShowPlayerVC alloc]init];
    babyShowPlayerVC.img_id = imgId;
    babyShowPlayerVC.videoUrl = video_url;
    babyShowPlayerVC.isHV = isHV;
    [self.navigationController pushViewController:babyShowPlayerVC animated:YES];
}
#pragma mark 跳转商家列表
-(void)pushStoreNewList:(NSInteger)tagId  imgIds:(NSString *)imgIds title:(NSString*)title{
    StoreMainNewListVC *storeMainVC = [[StoreMainNewListVC alloc]init];
    storeMainVC.tag_id = tagId;
    storeMainVC.img_ids = imgIds;
    storeMainVC.titleNav = title;
    [self.navigationController pushViewController:storeMainVC animated:YES];
    
}
#pragma mark 跳转商家详情
-(void)pushStoreDetialNewVC:(NSString*)imgId{
    StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
    storeVC.longin_user_id = LOGIN_USER_ID;
    storeVC.business_id = imgId;
    [self.navigationController pushViewController:storeVC animated:YES];
}

#pragma mark 跳转群详情
-(void)pushPostMyGroupDetailVC:(NSString *)imgId{
    PostBarNewGroupOnlyOneVC *postBarVC = [[PostBarNewGroupOnlyOneVC alloc]init];
    postBarVC.group_id = [imgId intValue];
    [self.navigationController pushViewController:postBarVC animated:YES];

}

//传入宽度和题目之后的高度
-(CGFloat)resetFrameWithTitle:(NSString*)title width:(CGFloat)width{
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float height = 0.0;
    
    if (title.length>0) {
        if (size.height >17.900391) {
            height = 40;
        }else{
            height = 20;
        }
        
    }else{
        height = 0;
    }
    
    return height;
    
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
