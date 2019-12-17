//
//  MyOutPutViewController.m
//  BabyShow
//
//  Created by Monica on 9/18/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyOutPutViewController.h"
#import "SDWebImageManager.h"
#import "BBSNavigationController.h"
#import "PraiseAndReviewListViewController.h"
#import "ReportViewController.h"
#import "WebViewController.h"
#import "MyOutPutTitleItem.h"
#import "MyOutPutDescribeItem.h"
#import "MyOutPutUrlItem.h"
#import "MyOutPutImgGroupItem.h"
#import "MyOutPutPraiseAndReviewItem.h"
#import "MyOutPutTitleItemNotToday.h"
#import "SVPullToRefresh.h"
#import "Emoji.h"
#import "BBSEmojiInfo.h"
#import "ShowAlertView.h"
#import "PostBarDetailNewTitleItem.h"
#import "PostBarDetailNewUrlItem.h"
#import "PostBarDetailNewPhotoItem.h"
#import "PostBarDetailNewUserItem.h"
#import "PostBarNewDetialV1VC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>
#import "PlayVideoCell.h"
#import "Reachability.h"
#import "XSMediaPlayer.h"
#import "BabyShowPlayerVC.h"
#import "MyShowNewBasicItem.h"
#define kDeviceVersion [[UIDevice currentDevice].systemVersion floatValue]

#define kNavbarHeight ((kDeviceVersion>=7.0)? 64 :44 )


@interface MyOutPutViewController ()<PlayVideoCellDelegate>

@property (nonatomic, assign)BOOL isFresh;

@property (nonatomic ,strong)UITableView *tableview;
@property(nonatomic,strong)PlayVideoCell *currentCell;//当前播放的视频
@property(nonatomic,strong)NSIndexPath *currentIndexPath;//当前cell的index
@property(nonatomic,strong)XSMediaPlayer *showPlayer;

@end

@implementation MyOutPutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _dataArray=[[NSMutableArray alloc]init];
        _PhotoArray=[[NSMutableArray alloc]init];
        facesArray = [[NSArray alloc]initWithArray:[Emoji allEmoji]];
        facesDictionary = [[NSDictionary alloc]initWithDictionary:[Emoji allEmojiDictionary]];
        
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;

    //网络错误
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    
    //请求数据成功与失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_MYSHOWGET_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_MYSHOWGET_FAIL object:nil];
    
    //赞成功与失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseSucceed) name:USER_MYSHOWPRAISE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseFail:) name:USER_MYSHOWPRAISE_FAIL object:nil];
    
    //取消赞成功与失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseSucceed) name:USER_MYSHOWCANCELPRAISE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseFail:) name:USER_MYSHOWCANCELPRAISE_FAIL object:nil];
    
    //删除秀秀
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteShowSucceed:) name:USER_DELETE_SHOW_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteShowFail:) name:USER_DELETE_SHOW_FAIL object:nil];
    // app退到后台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
    // app进入前台
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterPlayGround) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    
    
}
// 应用退到后台
- (void)appDidEnterBackground
{
    [_showPlayer playOrPause:YES];
    [_showPlayer playRelease];
    [_showPlayer removeFromSuperview];
}

// 应用进入前台
- (void)appDidEnterPlayGround
{
    [_showPlayer playOrPause:YES];
    [_showPlayer playRelease];
    [_showPlayer removeFromSuperview];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _page=1;
    [self getData];
    [self setTableView];
    [self setBackBtn];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_showPlayer removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
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
    
}

-(void)setTableView{
    
    self.automaticallyAdjustsScrollViewInsets=NO;
    
    if ([self.userid isEqualToString:self.loginUserid]) {
        self.title=@"我发布的";
    }else{
        self.title=@"Ta发布的";
    }
    
    _tableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH,SCREENHEIGHT-64)];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.backgroundColor = [UIColor whiteColor];
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableview.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableview];
    
    //下拉刷新
    __weak MyOutPutViewController *myOutPut=self;
    
    [_tableview addPullToRefreshWithActionHandler:^{
        
        myOutPut.isFresh=1;
        [myOutPut refresh];
        
    }];
    
    //上拉加载更多
    
    [_tableview addInfiniteScrollingWithActionHandler:^{
        
        if (myOutPut.tableview.pullToRefreshView.state==SVInfiniteScrollingStateStopped) {
            
            [myOutPut requestMoreData];
            
        }
        
    }];
    
    
}

#pragma mark data

-(void)requestMoreData{
    [_showPlayer playRelease];
    [_showPlayer removeFromSuperview];

    _isGetMore=1;
    _isFresh=0;
    if (_isFinished==NO) {
        [self getData];
    }
    
}

-(void)refresh{
    [_showPlayer playRelease];
    [_showPlayer removeFromSuperview];

    _isFinished=0;
    _isGetMore=0;
    _isFresh=1;
    _page=1;
    [self getData];
    
}

-(void)getData{
    
    NSDictionary *newParam=[NSDictionary dictionaryWithObjectsAndKeys:self.userid,@"user_id",
                            LOGIN_USER_ID,@"login_user_id",
                            [NSNumber numberWithInteger:_page],@"page",nil];
    NetAccess *netAccess=[NetAccess sharedNetAccess];
    [netAccess getDataWithStyle:NetStylemyImgs andParam:newParam];
    [LoadingView startOnTheViewController:self];
    
}

#pragma UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_dataArray.count) {
        NSArray *singleArray=[_dataArray objectAtIndex:section];
        if (singleArray.count) {
            return singleArray.count;
        }
    }
    return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *singleArray=[_dataArray objectAtIndex:indexPath.section];
    MyOutPutBasicItem *item=[singleArray objectAtIndex:indexPath.row];
    if (item.height) {
        return item.height+15;
    }
    return 0;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSArray *singleArray=[_dataArray objectAtIndex:indexPath.section];
    MyOutPutBasicItem *item=[singleArray objectAtIndex:indexPath.row];
    UITableViewCell *cell;
    
    if ([item isKindOfClass:[MyOutPutTitleItem class]]) {
        
        MyOutPutTitleItem *titleItem=(MyOutPutTitleItem *)item;
        
        MyOutPutTitleTodayCell *todayCell=[tableView dequeueReusableCellWithIdentifier:titleItem.identify];
        if (!todayCell) {
            todayCell=[[MyOutPutTitleTodayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleItem.identify];
        }
        
        todayCell.timeLabel.text=titleItem.time;
        if ([titleItem.come_from isEqualToString:@"1"]) {
            todayCell.sourceImgView.image=[UIImage imageNamed:@"img_myoutput_show"];
        }else if ([titleItem.come_from isEqualToString:@"2"]){
            todayCell.sourceImgView.image=[UIImage imageNamed:@"img_myoutput_hot"];
        }else if ([titleItem.come_from isEqualToString:@"3"]){
            todayCell.sourceImgView.image=[UIImage imageNamed:@"img_myoutput_worthbuy"];
        }
        cell=todayCell;
        
    }else if ([item isKindOfClass:[MyOutPutTitleItemNotToday class]]){
        
        MyOutPutTitleItemNotToday *titleItemNT=( MyOutPutTitleItemNotToday *)item;
        
        MyOutPutTitleNotTodayCell *notTodayCell=[tableView dequeueReusableCellWithIdentifier:titleItemNT.identify];
        if (!notTodayCell) {
            notTodayCell=[[MyOutPutTitleNotTodayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:titleItemNT.identify];
        }
        
        notTodayCell.dayLabel.text=titleItemNT.day;
        notTodayCell.monthLabel.text=[NSString stringWithFormat:@"%@月",titleItemNT.month];
        notTodayCell.yearLabel.text=[NSString stringWithFormat:@"%@年",titleItemNT.year];
        if ([titleItemNT.come_from isEqualToString:@"1"]) {
            notTodayCell.sourceImgView.image=[UIImage imageNamed:@"img_myoutput_show"];
        }else if ([titleItemNT.come_from isEqualToString:@"2"]){
            notTodayCell.sourceImgView.image=[UIImage imageNamed:@"img_myoutput_hot"];
        }else if ([titleItemNT.come_from isEqualToString:@"3"]){
            notTodayCell.sourceImgView.image=[UIImage imageNamed:@"img_myoutput_worthbuy"];
        }
        cell=notTodayCell;
        
    }else if ([item isKindOfClass:[MyOutPutDescribeItem class]]){
        
        MyOutPutDescribeItem *desItem=(MyOutPutDescribeItem *)item;
        
        MyShowNewDescribeCell *desCell=[tableView dequeueReusableCellWithIdentifier:desItem.identify];
        if (!desCell) {
            desCell=[[MyShowNewDescribeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:desItem.identify];
        }
        desCell.describeLabel.frame=CGRectMake(14, 5, 292, desItem.height);
        desCell.describeLabel.text=desItem.desContent;
        
        NSDictionary *dictionary = [BBSEmojiInfo detailContentWithStringAndEmoji:desCell.describeLabel.text fromArray:facesArray];
        NSString *content = [dictionary objectForKey:@"content"];
        NSArray *tNumArray = [dictionary objectForKey:@"emoji"];
        
        desCell.describeLabel.text=content;
        
        for (NSInteger i = tNumArray.count-1; i >=0; i--) {
            
            NSDictionary *dict = [tNumArray objectAtIndex:i];
            int numid = [[dict objectForKey:@"location"] intValue];
            NSString * emojiText = [dict objectForKey:@"emojiText"];
            UIImage *image = [UIImage imageNamed:[facesDictionary objectForKey:emojiText]];
            [desCell.describeLabel insertImage:image atIndex:(numid-i*4) margins:UIEdgeInsetsMake(-2, 0, -2, 0)];
            
        }
        if ([desCell.describeLabel.text hasPrefix:@"//来自☆话题//"]) {
            desCell.describeLabel.indexPath = indexPath;
            desCell.describeLabel.clickDelegate = self;
            [desCell.describeLabel setTextColor:[UIColor redColor] range:[desCell.describeLabel.text rangeOfString:@"//来自☆话题//"]];
        } else {
            desCell.describeLabel.indexPath = nil;
            desCell.describeLabel.clickDelegate = nil;
            desCell.describeLabel.textColor = [BBSColor hexStringToColor:@"6e6550"];
        }
        cell=desCell;
        
    }else if ([item isKindOfClass:[MyOutPutUrlItem class]]){
        
        MyOutPutUrlItem *urlItem=(MyOutPutUrlItem *)item;
        MyOutPutUrlCell *urlCell=[tableView dequeueReusableCellWithIdentifier:urlItem.identify];
        if (!urlCell) {
            urlCell=[[MyOutPutUrlCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"url"];
        }
        urlCell.delegate=self;
        urlCell.backGroundBtn.hidden = YES;
        urlCell.titleLabel.hidden = YES;
        urlCell.photoView.hidden = YES;
        urlCell.backGroundBtn.indexpath=indexPath;
        urlCell.titleLabel.text=urlItem.title;
        SDWebImageManager *manager=[SDWebImageManager sharedManager];
        [manager downloadImageWithURL:[NSURL URLWithString:urlItem.url_img_string] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            urlCell.photoView.image=image;
        }];
        
        cell=urlCell;
        
    }else if ([item isKindOfClass:[MyOutPutImgGroupItem class]]){
        //一种
        MyOutPutImgGroupItem *imgItem=(MyOutPutImgGroupItem *) item;
        
        if (imgItem.photosArray.count==1) {
            if (imgItem.video_url.length > 0) {
                //播放视频的
                static NSString *identifier =@"PLAYVIDEOCELLMY";
                PlayVideoCell *playCell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!playCell) {
                    playCell = [[PlayVideoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                playCell.delegate = self;
                playCell.playSamllBtn.indexpath = indexPath;
                playCell.ImgBtn.indexpath = indexPath;
                playCell.grayView.indexpath = indexPath;
                playCell.imgBigBtn.indexpath = indexPath;
                MyShowImageItem *imgthing=[imgItem.photosArray firstObject];
                float height = [imgthing.img_thumb_height floatValue];
                float weight = [imgthing.img_thumb_width floatValue];

                SDWebImageManager *manager=[SDWebImageManager sharedManager];
                if (height >weight) {
                    [manager downloadImageWithURL:[NSURL URLWithString:imgthing.imageStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        [playCell.ImgBtn setBackgroundImage:image forState:UIControlStateNormal];
                        [playCell.imgBigBtn setBackgroundImage:image forState:UIControlStateNormal];
                        playCell.imgBigBtn.hidden = NO;
                        playCell.grayView.hidden = NO;

                    }];

                }else{
                [manager downloadImageWithURL:[NSURL URLWithString:imgthing.imageStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [playCell.ImgBtn setBackgroundImage:image forState:UIControlStateNormal];
                    playCell.imgBigBtn.hidden = YES;
                    playCell.grayView.hidden = YES;

                }];
                }
                cell=playCell;

            }else{
            
            MyOutPutSingleImgCell *singleImgCell=[tableView dequeueReusableCellWithIdentifier:imgItem.identify];
            if (!singleImgCell) {
                singleImgCell=[[MyOutPutSingleImgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imgItem.identify];
            }
            singleImgCell.imgBtn.indexpath=indexPath;
            singleImgCell.delegate=self;
            [singleImgCell.imgBtn setBackgroundImage:nil forState:UIControlStateNormal];
            singleImgCell.imgBtn.frame=imgItem.frame;
            
            MyShowImageItem *imgthing=[imgItem.photosArray firstObject];
            
            SDWebImageManager *manager=[SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:imgthing.imageStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [singleImgCell.imgBtn setBackgroundImage:image forState:UIControlStateNormal];
                
            }];
            singleImgCell.backgroundColor=[UIColor clearColor];
            singleImgCell.contentView.backgroundColor=[UIColor clearColor];
            cell=singleImgCell;
            }
        }else{
            
            MyOutPutGroupImgCell *imgGroupCell=[tableView dequeueReusableCellWithIdentifier:imgItem.identify];
            if (!imgGroupCell) {
                imgGroupCell=[[MyOutPutGroupImgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imgItem.identify];
            }
            
            for (btnWithIndexPath *btn in imgGroupCell.btnArry) {
                [btn setBackgroundImage:nil forState:UIControlStateNormal];
                btn.hidden=YES;
            }
            
            imgGroupCell.delegate=self;
            
            NSInteger maxNum=imgItem.photosArray.count>6?6:imgItem.photosArray.count;
            
            for (int i=0;  i< maxNum; i++) {
                
                MyShowImageItem *imgThing=[imgItem.photosArray objectAtIndex:i];
                btnWithIndexPath *btn=[imgGroupCell.btnArry objectAtIndex:i];
                btn.hidden=NO;
                btn.indexpath=indexPath;
                
                SDWebImageManager *manager=[SDWebImageManager sharedManager];
                [manager downloadImageWithURL:[NSURL URLWithString:imgThing.imageStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                    
                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                    [btn setBackgroundImage:image forState:UIControlStateNormal];
                }];
                
            }
            
            cell=imgGroupCell;
            
        }
        
    }else if ([item isKindOfClass:[MyOutPutPraiseAndReviewItem class]]){
        
        MyOutPutPraiseAndReviewItem *pItem=(MyOutPutPraiseAndReviewItem *)item;
        
        MyOutPutPraiseAndReviewCell *pCell=[tableView dequeueReusableCellWithIdentifier:pItem.identify];
        if (!pCell) {
            pCell=[[MyOutPutPraiseAndReviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:pItem.identify];
        }
        [pCell.praiseBtn setTitle:[NSString stringWithFormat:@"%@",pItem.praise_count] forState:UIControlStateNormal];
        [pCell.reviewBtn setTitle:[NSString stringWithFormat:@"%@",pItem.review_count] forState:UIControlStateNormal];
        if (pItem.isPraised==YES) {
            [pCell.praiseBtn setBackgroundImage:[UIImage imageNamed:@"btn_myoutput_praised"] forState:UIControlStateNormal];
        }else{
            [pCell.praiseBtn setBackgroundImage:[UIImage imageNamed:@"btn_unlike"] forState:UIControlStateNormal];
        }
        pCell.delegate=self;
        pCell.praiseBtn.tag=indexPath.section;
        pCell.reviewBtn.tag=indexPath.section;
        pCell.moreBtn.tag=indexPath.section;
        cell=pCell;
        
    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *singleArray=[_dataArray objectAtIndex:indexPath.section];
    [self pushNewDetailVC:singleArray];
    

}
#pragma mark 跳转详情
-(void)pushNewDetailVC:(NSArray*)singleArray{
    
    id obj=[singleArray firstObject];
    
    PostBarNewDetialV1VC *reviewsListVC=[[PostBarNewDetialV1VC alloc]init];
    reviewsListVC.hidesBottomBarWhenPushed=YES;
    reviewsListVC.refreshInVC = ^(BOOL isFresh ){
        
    };
    
    
    MyShowNewBasicItem *item;
    BOOL isHV;
    
    if ([obj isKindOfClass:[MyOutPutTitleItem class]]) {
        
        MyOutPutTitleItem *item=(MyOutPutTitleItem *)obj;
        reviewsListVC.img_id=item.imgid;
        //1是秀秀，2是话题，3是值得买
        if ([item.come_from isEqualToString:@"1"]) {
            if (item.video_url.length > 0) {
                
                BabyShowPlayerVC *babyShowPlayerVc = [[BabyShowPlayerVC alloc]init];
                babyShowPlayerVc.videoUrl = item.video_url;
                babyShowPlayerVc.img_id = item.imgid;
                [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
            }else{
                [self.navigationController pushViewController:reviewsListVC animated:YES];
                
            }
        }else if ([item.come_from isEqualToString:@"2"]){
            if (item.video_url.length > 0) {
                
                BabyShowPlayerVC *babyShowPlayerVc = [[BabyShowPlayerVC alloc]init];
                babyShowPlayerVc.videoUrl = item.video_url;
                babyShowPlayerVc.img_id = item.imgid;
                for (item in singleArray) {
                    if ([item isKindOfClass:[MyOutPutImgGroupItem class]]) {
                        MyOutPutImgGroupItem *imgItem=(MyOutPutImgGroupItem *) item;
                        MyShowImageItem *imgthing=[imgItem.photosArray firstObject];
                        float height = [imgthing.img_thumb_height floatValue];
                        float weight = [imgthing.img_thumb_width floatValue];
                        if (height > weight) {
                            isHV = NO;
                            babyShowPlayerVc.isHV = isHV;
                            [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
                            break;
                        }else{
                            isHV = YES;
                            babyShowPlayerVc.isHV = isHV;
                            [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
                            break;
                            
                        }
                    }
                }
                
            }else{
                [self.navigationController pushViewController:reviewsListVC animated:YES];
                
            }
            
        }else if ([item.come_from isEqualToString:@"3"]){
            [self.navigationController pushViewController:reviewsListVC animated:YES];
            
        }
        
    }else if ([obj isKindOfClass:[MyOutPutTitleItemNotToday class]]){
        
        MyOutPutTitleItemNotToday *item=(MyOutPutTitleItemNotToday *)obj;
        reviewsListVC.img_id=item.imgid;
        if ([item.come_from isEqualToString:@"1"]) {
            if (item.video_url.length > 0) {
                BabyShowPlayerVC *babyShowPlayerVc = [[BabyShowPlayerVC alloc]init];
                babyShowPlayerVc.videoUrl = item.video_url;
                babyShowPlayerVc.img_id = item.imgid;
                [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
            }else{
                [self.navigationController pushViewController:reviewsListVC animated:YES];
                
            }
        }else if ([item.come_from isEqualToString:@"2"]){
            if (item.video_url.length > 0) {
                BabyShowPlayerVC *babyShowPlayerVc = [[BabyShowPlayerVC alloc]init];
                babyShowPlayerVc.videoUrl = item.video_url;
                babyShowPlayerVc.img_id = item.imgid;
                for (item in singleArray) {
                    if ([item isKindOfClass:[MyOutPutImgGroupItem class]]) {
                        MyOutPutImgGroupItem *imgItem=(MyOutPutImgGroupItem *) item;
                        MyShowImageItem *imgthing=[imgItem.photosArray firstObject];
                        float height = [imgthing.img_thumb_height floatValue];
                        float weight = [imgthing.img_thumb_width floatValue];
                        if (height > weight) {
                            isHV = NO;
                            babyShowPlayerVc.isHV = isHV;
                            [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
                            break;
                        }else{
                            isHV = YES;
                            babyShowPlayerVc.isHV = isHV;
                            [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
                            break;
                            
                        }
                    }
                }
            }else{
                reviewsListVC.img_id = item.imgid;
                [self.navigationController pushViewController:reviewsListVC animated:YES];
                
            }
            
        }else if ([item.come_from isEqualToString:@"3"]){
        }
        
    }

}
#pragma mark nsnotification

-(void)praiseSucceed{
    
    NSArray *singleArray=[_dataArray objectAtIndex:_praiseSection];
    MyOutPutPraiseAndReviewItem *pItem=[singleArray lastObject];
    
    NSInteger count=[pItem.praise_count integerValue];
    
    if (pItem.isPraised==YES) {
        pItem.isPraised=NO;
        count--;
        pItem.praise_count=[NSString stringWithFormat:@"%ld",(long)count];
    }else{
        pItem.isPraised=YES;
        count++;
        pItem.praise_count=[NSString stringWithFormat:@"%ld",(long)count];
    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:singleArray.count-1 inSection:_praiseSection];
    NSArray *array=[NSArray arrayWithObject:indexPath];
    
    [_tableview reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    
    [LoadingView stopOnTheViewController:self];
    
}

-(void)praiseFail:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}

-(void)netFail{
    if (_tableview.pullToRefreshView && _tableview.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableview.pullToRefreshView stopAnimating];
    }
    
    if (_tableview.infiniteScrollingView && _tableview.infiniteScrollingView.state == 2) {
        [_tableview.infiniteScrollingView stopAnimating];
        
    }
    
    [BBSAlert showAlertWithContent:@"网络链接失败" andDelegate:self];
    
}

-(void)getDataSucceed:(NSNotification *) note{
    
    
    NetAccess *net=[NetAccess sharedNetAccess];
    NSString *styleString=note.object;
    NSArray *returnArray=[net getReturnDataWithNetStyle:[styleString intValue]];
    
    if (returnArray.count) {
        
        if (_isFresh==YES) {
            [_dataArray removeAllObjects];
            _isFresh=NO;
        }
        
        [_dataArray addObjectsFromArray:returnArray];
        [_tableview reloadData];
        
        
    }else{
        
        _isFinished=1;
        [self showHUDWithMessage:@"已没有更多数据"];
        
    }
    
    if (_dataArray.count) {
        _page++;
    }
    
    if ((_tableview.pullToRefreshView)&& [_tableview.pullToRefreshView state] ==SVPullToRefreshStateLoading) {
        [_tableview.pullToRefreshView stopAnimating];
    }
    
    if (_tableview.infiniteScrollingView && [_tableview.infiniteScrollingView state]== SVInfiniteScrollingStateLoading) {
        [_tableview.infiniteScrollingView stopAnimating];
    }
    
    [LoadingView stopOnTheViewController:self];
    
}

-(void)getDataFail:(NSNotification *) not{
    
    [_tableview.pullToRefreshView stopAnimating];
    [_tableview.infiniteScrollingView stopAnimating];
    
    [LoadingView stopOnTheViewController:self];
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}

#pragma mark cell_delegate

-(void)jumpToTheWebView:(btnWithIndexPath *)btn{
    
    NSArray *singleArray=[_dataArray objectAtIndex:btn.indexpath.section];
    MyOutPutUrlItem *urlItem=[singleArray objectAtIndex:btn.indexpath.row];
    
    WebViewController *webVC=[[WebViewController alloc]init];
    webVC.urlStr=urlItem.url_string;
    [self.navigationController pushViewController:webVC animated:YES];
    
}

-(void)SeeTheDetailOfThePhoto:(btnWithIndexPath *)btn{
    [_PhotoArray removeAllObjects];
    
    NSArray *singleArray=[_dataArray objectAtIndex:btn.indexpath.section];
    [self pushNewDetailVC:singleArray];
//    MyOutPutImgGroupItem *photoItem=[singleArray objectAtIndex:btn.indexpath.row];
//    
//    NSMutableArray *imgArr = [[NSMutableArray alloc]init];
//    int i = 0;
//    for (MyShowImageItem *imgItem in photoItem.photosArray) {
//        
//        NSMutableDictionary *imgDic=[[NSMutableDictionary alloc]init];
//        [imgDic setObject:imgItem.imageClearStr forKey:kMyShowImg];
//        [imgDic setObject:imgItem.img_down forKey:kMyShowImgDown];
//        [imgDic setObject:imgItem.img_width forKey:kMyShowImgWidth];
//        [imgDic setObject:imgItem.img_height forKey:kMyShowImgHeight];
//        [imgDic setObject:imgItem.imageStr forKey:kMyShowImgThumb];
//        [imgDic setObject:imgItem.img_thumb_width forKey:kMyShowImgThumbWidth];
//        [imgDic setObject:imgItem.img_thumb_height forKey:kMyShowImgThumbHeight];
//        [imgArr addObject:imgDic];
//        MWPhoto *photo=[[MWPhoto alloc]initWithURL:[NSURL URLWithString:imgItem.imageClearStr] info:nil];
//        photo.img_info =@{@"description": [NSString stringWithFormat:@"%d/%lu",i+1,(unsigned long)photoItem.photosArray.count]};
//        [_PhotoArray addObject:photo];
//        i++;
//        
//    }
//    
//    MWPhotoBrowser *browser =[[ MWPhotoBrowser alloc]initWithDelegate:self];
//    //    browser.imgstr=imgItem.imageStr;
//    browser.displayActionButton = YES;
//    browser.displayNavArrows = NO;
//    browser.displaySelectionButtons = NO;
//    browser.alwaysShowControls = NO;
//    browser.zoomPhotosToFill = YES;
//    browser.enableGrid = YES;
//    browser.startOnGrid = NO;
//    [browser setCurrentPhotoIndex:btn.tag];
//    browser.type = 10;
//    browser.needPlay = YES;     //需要播放
//    browser.imgArr = imgArr;    //播放需要的东西
//    browser.is_show_album =NO;
//    browser.user_id =self.userid;
//    
//    BBSNavigationController *nav=[[BBSNavigationController alloc]initWithRootViewController:browser];
//    [self presentViewController:nav animated:YES completion:nil];
    
    
}

-(void)SeeTheSingleImage:(btnWithIndexPath *)btn{
    
    [_PhotoArray removeAllObjects];
    
    NSArray *singleArray=[_dataArray objectAtIndex:btn.indexpath.section];
    [self pushNewDetailVC:singleArray];
//    MyOutPutImgGroupItem *photoItem=[singleArray objectAtIndex:btn.indexpath.row];
//    
//    NSMutableArray *imgArr = [[NSMutableArray alloc]init];
//    int i = 0;
//    for (MyShowImageItem *imgItem in photoItem.photosArray) {
//        
//        NSMutableDictionary *imgDic=[[NSMutableDictionary alloc]init];
//        [imgDic setObject:imgItem.imageClearStr forKey:kMyShowImg];
//        [imgDic setObject:imgItem.img_down forKey:kMyShowImgDown];
//        [imgDic setObject:imgItem.img_width forKey:kMyShowImgWidth];
//        [imgDic setObject:imgItem.img_height forKey:kMyShowImgHeight];
//        [imgDic setObject:imgItem.imageStr forKey:kMyShowImgThumb];
//        [imgDic setObject:imgItem.img_thumb_width forKey:kMyShowImgThumbWidth];
//        [imgDic setObject:imgItem.img_thumb_height forKey:kMyShowImgThumbHeight];
//        [imgArr addObject:imgDic];
//        MWPhoto *photo=[[MWPhoto alloc]initWithURL:[NSURL URLWithString:imgItem.imageClearStr] info:nil];
//        photo.img_info =@{@"description": [NSString stringWithFormat:@"1/1"]};
//        [_PhotoArray addObject:photo];
//        i++;
//        
//    }
//    
//    MWPhotoBrowser *browser =[[ MWPhotoBrowser alloc]initWithDelegate:self];
//    //    browser.imgstr=imgItem.imageStr;
//    browser.displayActionButton = YES;
//    browser.displayNavArrows = NO;
//    browser.displaySelectionButtons = NO;
//    browser.alwaysShowControls = NO;
//    browser.zoomPhotosToFill = YES;
//    browser.enableGrid = YES;
//    browser.startOnGrid = NO;
//    [browser setCurrentPhotoIndex:btn.tag];
//    browser.type = 10;
//    browser.needPlay = NO;     //需要播放
//    browser.imgArr = imgArr;    //播放需要的东西
//    browser.is_show_album =NO;
//    browser.user_id =self.userid;
//    
//    BBSNavigationController *nav=[[BBSNavigationController alloc]initWithRootViewController:browser];
//    [self presentViewController:nav animated:YES completion:nil];
    
}

-(void)praise:(UIButton *)btn{
    
    _praiseSection=btn.tag;
    
    NetAccess *net=[NetAccess sharedNetAccess];
    
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:LOGIN_USER_ID forKey:@"login_user_id"];
    [paramDic setObject:self.userid forKey:@"admire_user_id"];
    
    NSArray *singleArray=[_dataArray objectAtIndex:btn.tag];
    id obj=[singleArray firstObject];
    
    if ([obj isKindOfClass:[MyOutPutTitleItem class]]) {
        
        MyOutPutTitleItem *item=(MyOutPutTitleItem *)obj;
        [paramDic setObject:item.imgid forKey:kAdmireImgId];
        if ([item.come_from isEqualToString:@"2"]) {
            [paramDic setObject:@"1" forKey:@"ispost"];
        }
        
        MyOutPutPraiseAndReviewItem *pItem=[singleArray lastObject];
        
        if ([item.come_from isEqualToString:@"3"]) {
            
            if (pItem.isPraised==YES) {
                [net getDataWithStyle:NetStylePostBarWorthBuyCancelAdmire andParam:paramDic];
            }else{
                [net getDataWithStyle:NetStylePostBarWorthBuyAdmire andParam:paramDic];
            }
            
        }else{
            
            if (pItem.isPraised==YES) {
                [net getDataWithStyle:NetStyleCancelAdmire andParam:paramDic];
            }else{
                [net getDataWithStyle:NetStyleAdmire andParam:paramDic];
            }
            
        }
        
    }else if ([obj isKindOfClass:[MyOutPutTitleItemNotToday class]]){
        
        MyOutPutTitleItemNotToday *item=(MyOutPutTitleItemNotToday *)obj;
        [paramDic setObject:item.imgid forKey:kAdmireImgId];
        if ([item.come_from isEqualToString:@"2"]) {
            [paramDic setObject:@"1" forKey:@"ispost"];
        }
        
        MyOutPutPraiseAndReviewItem *pItem=[singleArray lastObject];
        
        if ([item.come_from isEqualToString:@"3"]) {
            
            if (pItem.isPraised==YES) {
                [net getDataWithStyle:NetStylePostBarWorthBuyCancelAdmire andParam:paramDic];
            }else{
                [net getDataWithStyle:NetStylePostBarWorthBuyAdmire andParam:paramDic];
            }
            
        }else{
            
            if (pItem.isPraised==YES) {
                [net getDataWithStyle:NetStyleCancelAdmire andParam:paramDic];
            }else{
                [net getDataWithStyle:NetStyleAdmire andParam:paramDic];
            }
            
        }
        
    }
    
    [LoadingView startOnTheViewController:self];
    
}

-(void)review:(UIButton *)btn{
    
    NSArray *singleArray=[_dataArray objectAtIndex:btn.tag];
    id obj=[singleArray firstObject];
    
    PostBarNewDetialV1VC *reviewsListVC=[[PostBarNewDetialV1VC alloc]init];
    reviewsListVC.hidesBottomBarWhenPushed=YES;
    reviewsListVC.refreshInVC = ^(BOOL isFresh ){
        
    };

    
    MyShowNewBasicItem *item;
    BOOL isHV;
    
    if ([obj isKindOfClass:[MyOutPutTitleItem class]]) {
        
        MyOutPutTitleItem *item=(MyOutPutTitleItem *)obj;
        reviewsListVC.img_id=item.imgid;
        //1是秀秀，2是话题，3是值得买
        if ([item.come_from isEqualToString:@"1"]) {
            if (item.video_url.length > 0) {
                
                BabyShowPlayerVC *babyShowPlayerVc = [[BabyShowPlayerVC alloc]init];
                babyShowPlayerVc.videoUrl = item.video_url;
                babyShowPlayerVc.img_id = item.imgid;
                [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
            }else{
                [self.navigationController pushViewController:reviewsListVC animated:YES];

            }
        }else if ([item.come_from isEqualToString:@"2"]){
            if (item.video_url.length > 0) {
                
                BabyShowPlayerVC *babyShowPlayerVc = [[BabyShowPlayerVC alloc]init];
                babyShowPlayerVc.videoUrl = item.video_url;
                babyShowPlayerVc.img_id = item.imgid;
                for (item in singleArray) {
                    if ([item isKindOfClass:[MyOutPutImgGroupItem class]]) {
                        MyOutPutImgGroupItem *imgItem=(MyOutPutImgGroupItem *) item;
                        MyShowImageItem *imgthing=[imgItem.photosArray firstObject];
                        float height = [imgthing.img_thumb_height floatValue];
                        float weight = [imgthing.img_thumb_width floatValue];
                        if (height > weight) {
                            isHV = NO;
                            babyShowPlayerVc.isHV = isHV;
                            [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
                            break;
                        }else{
                            isHV = YES;
                            babyShowPlayerVc.isHV = isHV;
                            [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
                            break;
                            
                        }
                    }
                }
                
            }else{
                [self.navigationController pushViewController:reviewsListVC animated:YES];
                
            }

        }else if ([item.come_from isEqualToString:@"3"]){
            [self.navigationController pushViewController:reviewsListVC animated:YES];

        }
        
    }else if ([obj isKindOfClass:[MyOutPutTitleItemNotToday class]]){
        
        MyOutPutTitleItemNotToday *item=(MyOutPutTitleItemNotToday *)obj;
        reviewsListVC.img_id=item.imgid;
        if ([item.come_from isEqualToString:@"1"]) {
            if (item.video_url.length > 0) {
                BabyShowPlayerVC *babyShowPlayerVc = [[BabyShowPlayerVC alloc]init];
                babyShowPlayerVc.videoUrl = item.video_url;
                babyShowPlayerVc.img_id = item.imgid;
                [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
            }else{
                [self.navigationController pushViewController:reviewsListVC animated:YES];
                
            }
        }else if ([item.come_from isEqualToString:@"2"]){
            if (item.video_url.length > 0) {
                BabyShowPlayerVC *babyShowPlayerVc = [[BabyShowPlayerVC alloc]init];
                babyShowPlayerVc.videoUrl = item.video_url;
                babyShowPlayerVc.img_id = item.imgid;
                for (item in singleArray) {
                    if ([item isKindOfClass:[MyOutPutImgGroupItem class]]) {
                        MyOutPutImgGroupItem *imgItem=(MyOutPutImgGroupItem *) item;
                        MyShowImageItem *imgthing=[imgItem.photosArray firstObject];
                        float height = [imgthing.img_thumb_height floatValue];
                        float weight = [imgthing.img_thumb_width floatValue];
                        if (height > weight) {
                            isHV = NO;
                            babyShowPlayerVc.isHV = isHV;
                            [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
                            break;
                        }else{
                            isHV = YES;
                            babyShowPlayerVc.isHV = isHV;
                            [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
                            break;
                            
                        }
                    }
                }
            }else{
                reviewsListVC.img_id = item.imgid;
                [self.navigationController pushViewController:reviewsListVC animated:YES];
                
            }

        }else if ([item.come_from isEqualToString:@"3"]){
        }
        
    }
    
    
}

-(void)more:(UIButton *)btn{
    
    NSArray *singleArray=[_dataArray objectAtIndex:btn.tag];
    MyOutPutPraiseAndReviewItem *pItem=[singleArray lastObject];

    NSString *message ;
    if ([self.userid isEqualToString:self.loginUserid]) {
        message = @"删除";
    }else{
        message = @"举报";
    }
    _deleteSection = btn.tag;
    if ([UIDevice currentDevice].systemVersion.floatValue >=8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
            UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [self shareToThird];
            }];
            [alertController addAction:shareAction];
      
        [alertController addAction:[UIAlertAction actionWithTitle:message style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self deleteOrReport];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    } else {
        UIActionSheet *action;
        action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享",message,nil];
        action.tag=btn.tag;
        action.destructiveButtonIndex = action.numberOfButtons - 2;
        [action showFromTabBar:self.tabBarController.tabBar];
    }
    
    
}
- (void)clickLabel:(ClickDescLabel *)label touchesWithIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *singleArray = [_dataArray objectAtIndex:indexPath.section];
    MyOutPutBasicItem *item = [singleArray objectAtIndex:0];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            LOGIN_USER_ID,@"login_user_id",
                            item.userid,@"user_id",
                            item.imgid,@"img_id",
                            item.create_time,@"create_time", nil];
    [LoadingView startOnTheViewController:self];
    __block MyOutPutViewController *blockSelf = self;
    [[HTTPClient sharedClient] getNew:kGoToPost params:params success:^(NSDictionary *result) {
        [LoadingView stopOnTheViewController:self];
        if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
            NSDictionary *dict = [result objectForKey:kBBSData];
            PostBarNewDetialV1VC *detailVC=[[PostBarNewDetialV1VC alloc]init];
            detailVC.img_id = [dict objectForKey:@"img_id"];
            detailVC.user_id = item.userid;
            detailVC.login_user_id = blockSelf.loginUserid;
            detailVC.refreshInVC = ^(BOOL isFresh ){
                
            };
            [detailVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:detailVC animated:YES];
            
        } else {
            
        }
    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
    }];
    
}
#pragma mark -点击图片跳转播放详情页面
-(void)playVideoUrl:(btnWithIndexPath *)btn{
    _currentIndexPath = btn.indexpath;
    BOOL isHV;
    NSArray *singleArray=[_dataArray objectAtIndex:_currentIndexPath.section];
    MyOutPutImgGroupItem *photoItem=[singleArray objectAtIndex:_currentIndexPath.row];
    MyShowImageItem *imgthing=[photoItem.photosArray firstObject];
    float height = [imgthing.img_thumb_height floatValue];
    float weight = [imgthing.img_thumb_width floatValue];
    if (height > weight) {
        isHV = NO;//横屏
    }else{
        isHV = YES;
        
    }
    BabyShowPlayerVC *babyShowPlayerVc = [[BabyShowPlayerVC alloc]init];
    babyShowPlayerVc.videoUrl = photoItem.video_url;
    babyShowPlayerVc.img_id = photoItem.imgid;
    babyShowPlayerVc.isHV = isHV;
    [self.navigationController pushViewController:babyShowPlayerVc animated:YES];
    
}

#pragma mark -点击本页面播放
-(void)playVideoInTheView:(btnWithIndexPath *)btn{
    
    _currentIndexPath = btn.indexpath;
    _currentCell = [_tableview cellForRowAtIndexPath:btn.indexpath];
    //检查网络设置
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NSParameterAssert([reach isKindOfClass:[Reachability class]]);
    NetworkStatus stats = [reach currentReachabilityStatus];
    if (stats == NotReachable) {
        [BBSAlert showAlertWithContent:@"您似乎与网络断开，检查一下网络设置" andDelegate:self];
        
    }else if(stats == ReachableViaWiFi){
        NSLog(@"网络wifi");
        [self canPlayVideo];
        
        
    }else if (stats == ReachableViaWWAN|| stats == kReachableVia4G || stats == kReachableVia3G || stats == kReachableVia2G){
        
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"您当前并未连接WIFI，继续播放将使用手机流量，是否继续？" preferredStyle:UIAlertControllerStyleAlert];
            __weak MyOutPutViewController *babyVC = self;
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"返回" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            }];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [babyVC canPlayVideo];
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"您当前并未连接WIFI，继续播放将使用手机流量，是否继续？" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"继续", nil];
            alertView.tag = 101;
            [alertView show];
        }
    }
    
}
#pragma mark 点击播放
-(void)canPlayVideo{
    BOOL isHV;
    NSArray *singleArray=[_dataArray objectAtIndex:_currentIndexPath.section];
    MyOutPutImgGroupItem *photoItem=[singleArray objectAtIndex:_currentIndexPath.row];
    MyShowImageItem *imgthing=[photoItem.photosArray firstObject];
    float height = [imgthing.img_thumb_height floatValue];
    float weight = [imgthing.img_thumb_width floatValue];
    if (height > weight) {
        isHV = NO;//横屏
    }else{
        isHV =YES;
        
    }
    SDWebImageManager *manager=[SDWebImageManager sharedManager];
    if (_showPlayer) {
        [_showPlayer removeFromSuperview];
        _showPlayer.videoURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@",photoItem.video_url]];
    }else{
        _showPlayer = [[XSMediaPlayer alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.6+20)];
        _showPlayer.videoURL =[NSURL URLWithString:[NSString stringWithFormat:@"%@",photoItem.video_url]];
        
    }
    [manager downloadImageWithURL:[NSURL URLWithString:imgthing.imageStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        [_showPlayer settingBackgroupImg:image];
        
    }];
    
    [_showPlayer setHorizontalOrVerticalScreen:isHV];
    _showPlayer.isHV = isHV;
    [_showPlayer.player play];
    [_currentCell addSubview:_showPlayer ];
    
}
#pragma mark -scrollview delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _tableview) {
        if (_showPlayer == nil) {
            return;
        }
        if (_showPlayer.superview) {
            CGRect rectInTableView = [_tableview rectForRowAtIndexPath:_currentIndexPath];
            CGRect rectInSuperview = [_tableview convertRect:rectInTableView toView:[_tableview superview]];
            if (rectInSuperview.origin.y-kNavbarHeight <-(SCREENWIDTH*0.6+20)||rectInSuperview.origin.y>SCREENHEIGHT) {
                [_showPlayer.player pause];
                [_showPlayer playRelease];
                [_showPlayer removeFromSuperview];
                [_tableview reloadData];
                
            }else{
                if (![_currentCell.subviews containsObject:_showPlayer]) {
                    [_showPlayer playOrPause:YES ];
                }
                
            }
            
        }
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
    }else{
        [self canPlayVideo];
    }
    
}


#pragma mark private

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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
#pragma mark 分享给
- (void)shareToThird {
    
    // NetAccess *net = [NetAccess sharedNetAccess];
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
    [paramDic setObject:self.loginUserid forKey:@"user_id"];
    NSArray *singleArray = [_dataArray objectAtIndex:_deleteSection];
    id obj = [singleArray firstObject];
    NSString *userID,*imgID,*desc,*thumbString,*shareUrl,*isVideo;
    if ([obj isKindOfClass:[MyOutPutTitleItem class]]) {
        MyOutPutTitleItem *item = (MyOutPutTitleItem *)obj;
        imgID = item.imgid;
        userID = item.userid;
        
        //话题
        if ([item.come_from isEqualToString:@"2"]) {
            //发话题
            MyOutPutDescribeItem *titleItem ;
            MyOutPutImgGroupItem *photoItem ;
            for (int i = 0; i < singleArray.count; i++) {
                if ([singleArray[i] isKindOfClass:[MyOutPutDescribeItem class]]) {
                    titleItem = singleArray[i];
                    desc = titleItem.desContent;
                    
                }
            }
            for (int i = 0; i < singleArray.count; i++) {
                if ([singleArray[i]isKindOfClass:[MyOutPutImgGroupItem class]]) {
                    photoItem = singleArray[i];
                    isVideo = photoItem.video_url;
                    MyShowImageItem *imgthing = [photoItem.photosArray firstObject];
                    thumbString = imgthing.imageStr;
                }
            }
            if (isVideo.length > 0) {
                shareUrl = [NSString stringWithFormat:@"%@img_id=%@&user_id=%@",VideoShareUrl,imgID,userID];
            }else{
                shareUrl = [NSString stringWithFormat:@"%@img_id=%@&user_id=%@",PostShareUrl,imgID,userID];
                
            }
            NSLog(@"shshshshhshs = %@",shareUrl);
            //值得买
        }else if ([item.come_from isEqualToString:@"3"]){
            
            //秀秀
        }else{
            for (int i = 0; i < singleArray.count; i++) {
                if ([singleArray[i] isKindOfClass:[MyOutPutImgGroupItem class]]) {
                    MyOutPutImgGroupItem *photoItem = singleArray[i];
                    MyShowImageItem *imageItem = [photoItem.photosArray firstObject];
                    thumbString = imageItem.imageStr;
                }
            }
            for (int i = 0; i <singleArray.count; i++) {
                if ([singleArray[i] isKindOfClass:[MyOutPutDescribeItem class]]) {
                    MyOutPutDescribeItem *descItem = singleArray[i];
                    desc = descItem.desContent;
                }
            }
            shareUrl =[NSString stringWithFormat:@"%@img_id=%@&user_id=%@",AppShareUrl,imgID,userID];
        }
    }else if([obj isKindOfClass:[MyOutPutTitleItemNotToday class]]){
        MyOutPutTitleItemNotToday *item = (MyOutPutTitleItemNotToday *)obj;
        imgID = item.imgid;
        userID = item.userid;
        if ([item.come_from isEqualToString:@"2"]) {
            //发话题
            MyOutPutDescribeItem *titleItem ;
            MyOutPutImgGroupItem *photoItem ;
            for (int i = 0; i < singleArray.count; i++) {
                if ([singleArray[i] isKindOfClass:[MyOutPutDescribeItem class]]) {
                    titleItem = singleArray[i];
                    desc = titleItem.desContent;
                    
                }
            }
            for (int i = 0; i < singleArray.count; i++) {
                if ([singleArray[i]isKindOfClass:[MyOutPutImgGroupItem class]]) {
                    photoItem = singleArray[i];
                    isVideo = photoItem.video_url;
                    MyShowImageItem *imgthing = [photoItem.photosArray firstObject];
                    thumbString = imgthing.imageStr;
                }
            }
            if (isVideo.length > 0) {
                shareUrl = [NSString stringWithFormat:@"%@img_id=%@&user_id=%@",VideoShareUrl,imgID,userID];
            }else{
                shareUrl = [NSString stringWithFormat:@"%@img_id=%@&user_id=%@",PostShareUrl,imgID,userID];
                
            }
        }else if ([item.come_from isEqualToString:@"3"]){
            
        }else{
            //发秀秀
            for (int i = 0; i < singleArray.count; i++) {
                if ([singleArray[i] isKindOfClass:[MyOutPutImgGroupItem class]]) {
                    MyOutPutImgGroupItem *photoItem = singleArray[i];
                    MyShowImageItem *imageItem = [photoItem.photosArray firstObject];
                    thumbString = imageItem.imageStr;
                }
            }
            for (int i = 0; i <singleArray.count; i++) {
                if ([singleArray[i] isKindOfClass:[MyOutPutDescribeItem class]]) {
                    MyOutPutDescribeItem *descItem = singleArray[i];
                    desc = descItem.desContent;
                }
            }
            shareUrl =[NSString stringWithFormat:@"%@img_id=%@&user_id=%@",AppShareUrl,imgID,userID];
        }
    }
    NSLog(@"shshshshshshhs = %@",shareUrl);
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray;
    if (thumbString.length > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",thumbString]];
        UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        NSData *basicImgData = UIImagePNGRepresentation(shareImg);
        if (basicImgData.length/1024>150) {
            shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
            
        }

        imageArray = @[shareImg];
    }else{
        imageArray = @[[UIImage imageNamed:@"img_default"]];
        
    }
    NSString *shareTitle;
    if (desc.length>0) {
        shareTitle = desc;
    }else{
        shareTitle = @"自由环球租赁话题分享";
    }

    [shareParams SSDKSetupShareParamsByText:desc
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",shareUrl]]                                      title:shareTitle
                                       type:SSDKContentTypeAuto];
    
    //设置新浪微博
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",desc,[NSURL URLWithString:[NSString stringWithFormat:@"%@",shareUrl]]];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:nil image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",shareUrl]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
    //分享
    [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateBegin:
            {
                //  [storeVC showLoadingView:YES];
                break;
            }
            case SSDKResponseStateSuccess:
            {
                //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
                break;
            }
            case SSDKResponseStateCancel:
            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
                break;
            }
                
            default:
                break;
        }
    }];
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (void)copyURL:(NSString *)string {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:string];
}
-(void)deleteOrReport {
    NSArray *superUser = [BABYSHOWSUPERGRANTUSER componentsSeparatedByString:@","];
    BOOL isSuperGrant  = NO;
    for (int i = 0; i < superUser.count; i++) {
        NSString *user = [superUser objectAtIndex:i];
        if ([self.loginUserid integerValue] == [user integerValue]) {
            isSuperGrant = YES;
            break;
        }
    }
    if ([self.userid isEqualToString:self.loginUserid] || isSuperGrant) {
        [LoadingView startOnTheViewController:self];
        NetAccess *net = [NetAccess sharedNetAccess];
        NSMutableDictionary *paramDic = [[NSMutableDictionary alloc]init];
        [paramDic setObject:self.loginUserid forKey:@"user_id"];
        
        NSArray *singleArray=[_dataArray objectAtIndex:_deleteSection];
        id obj=[singleArray firstObject];
        if ([obj isKindOfClass:[MyOutPutTitleItem class]]) {
            
            MyOutPutTitleItem *item=(MyOutPutTitleItem *)obj;
            [paramDic setObject:item.imgid forKey:@"img_ids"];
            //话题
            if ([item.come_from isEqualToString:@"2"]) {
                [paramDic setObject:@"1" forKey:@"ispost"];
                [net getDataWithStyle:NetStyleDelShow andParam:paramDic];

            }else if ([item.come_from isEqualToString:@"3"]) {
                
                [net getDataWithStyle:NetStyleWorthBuyDeletShow andParam:paramDic];
                
            }else{
                //秀秀，话题
                //秀秀，话题
                [net getDataWithStyle:NetStyleDelShow andParam:paramDic];
                
            }
            
        }else if ([obj isKindOfClass:[MyOutPutTitleItemNotToday class]]){
            
            MyOutPutTitleItemNotToday *item=(MyOutPutTitleItemNotToday *)obj;
            [paramDic setObject:item.imgid forKey:@"img_ids"];
            
            if ([item.come_from isEqualToString:@"2"]) {
                [paramDic setObject:@"1" forKey:@"ispost"];
                [net getDataWithStyle:NetStyleDelShow andParam:paramDic];

            }else if ([item.come_from isEqualToString:@"3"]) {
                
                [net getDataWithStyle:NetStyleWorthBuyDeletShow andParam:paramDic];
                
            }else{
                //秀秀，话题
                [net getDataWithStyle:NetStyleDelShow andParam:paramDic];
                
            }
            
        }
        
        
    }
    
    
}
#pragma mark 删除秀秀

-(void)deleteShowSucceed:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];
    
    NSIndexSet *set=[[NSIndexSet alloc]initWithIndex:_deleteSection];
    
    NSArray *itemsArray=[_dataArray objectAtIndex:_deleteSection];
    NSMutableArray *indexPathsArray=[[NSMutableArray alloc]init];
    
    for (int i=0;i<itemsArray.count;i++) {
        
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:i inSection:_deleteSection];
        [indexPathsArray addObject:indexPath];
        
    }
    
    [_dataArray removeObjectAtIndex:_deleteSection];
    
    [_tableview beginUpdates];
    
    [_tableview deleteRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationFade];
    [_tableview deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
    
    [_tableview endUpdates];
    
    [_tableview reloadData];
    
}

-(void)deleteShowFail:(NSNotification *)not{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}

#pragma mark - MWPhotoBrowserDelegate

-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    
    return _PhotoArray.count;
    
}
-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    if (index < _PhotoArray.count) {
        
        return [_PhotoArray objectAtIndex:index];
        
    }
    
    return nil;
    
}

#pragma mark actionsheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:NO];
    
    if (actionSheet.numberOfButtons == 2) {
        if (buttonIndex == 0) {
            
            if ([self.userid isEqualToString:self.loginUserid]) {
                //删除
                _deleteSection=actionSheet.tag;
                [LoadingView startOnTheViewController:self];
                NetAccess *net=[NetAccess sharedNetAccess];
                NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
                [paramDic setObject:self.loginUserid forKey:@"user_id"];
                NSArray *singleArray=[_dataArray objectAtIndex:actionSheet.tag];
                id obj=[singleArray firstObject];
                if ([obj isKindOfClass:[MyOutPutTitleItem class]]) {
                    MyOutPutTitleItem *item=(MyOutPutTitleItem *)obj;
                    [paramDic setObject:item.imgid forKey:@"img_ids"];
                    //话题
                    if ([item.come_from isEqualToString:@"2"]) {
                        [paramDic setObject:@"1" forKey:@"ispost"];
                    }
                    //值得买
                    if ([item.come_from isEqualToString:@"3"]) {
                        
                        [net getDataWithStyle:NetStyleWorthBuyDeletShow andParam:paramDic];
                        
                    }else{
                        //秀秀，话题
                        if (item.video_url.length > 0) {
                            [paramDic setObject:@"1" forKey:@"is_video"];
                        }
                        
                        [net getDataWithStyle:NetStyleDelShow andParam:paramDic];
                        
                    }
                }else if ([obj isKindOfClass:[MyOutPutTitleItemNotToday class]]){
                    MyOutPutTitleItemNotToday *item=(MyOutPutTitleItemNotToday *)obj;
                    [paramDic setObject:item.imgid forKey:@"img_ids"];
                    if ([item.come_from isEqualToString:@"2"]) {
                        [paramDic setObject:@"1" forKey:@"ispost"];
                    }
                    if ([item.come_from isEqualToString:@"3"]) {
                        
                        [net getDataWithStyle:NetStyleWorthBuyDeletShow andParam:paramDic];
                        
                    }else{
                        if (item.video_url.length > 0) {
                            [paramDic setObject:@"1" forKey:@"is_video"];
                        }
                        [net getDataWithStyle:NetStyleDelShow andParam:paramDic];
                        
                    }
                    
                }
                
            }

        }
    }else{
    
    if (buttonIndex==1) {
        
        if ([self.userid isEqualToString:self.loginUserid]) {
            //删除
            _deleteSection=actionSheet.tag;
            [LoadingView startOnTheViewController:self];
            NetAccess *net=[NetAccess sharedNetAccess];
            NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
            [paramDic setObject:self.loginUserid forKey:@"user_id"];
            NSArray *singleArray=[_dataArray objectAtIndex:actionSheet.tag];
            id obj=[singleArray firstObject];
            if ([obj isKindOfClass:[MyOutPutTitleItem class]]) {
                MyOutPutTitleItem *item=(MyOutPutTitleItem *)obj;
                [paramDic setObject:item.imgid forKey:@"img_ids"];
                //话题
                if ([item.come_from isEqualToString:@"2"]) {
                    [paramDic setObject:@"1" forKey:@"ispost"];
                }
                //值得买
                if ([item.come_from isEqualToString:@"3"]) {
                    
                    [net getDataWithStyle:NetStyleWorthBuyDeletShow andParam:paramDic];
                    
                }else{
                    //秀秀，话题
                    if (item.video_url.length > 0) {
                        [paramDic setObject:@"1" forKey:@"is_video"];
                    }

                    [net getDataWithStyle:NetStyleDelShow andParam:paramDic];
                    
                }
            }else if ([obj isKindOfClass:[MyOutPutTitleItemNotToday class]]){
                MyOutPutTitleItemNotToday *item=(MyOutPutTitleItemNotToday *)obj;
                [paramDic setObject:item.imgid forKey:@"img_ids"];
                if ([item.come_from isEqualToString:@"2"]) {
                    [paramDic setObject:@"1" forKey:@"ispost"];
                }
                if ([item.come_from isEqualToString:@"3"]) {
                    
                    [net getDataWithStyle:NetStyleWorthBuyDeletShow andParam:paramDic];
                    
                }else{
                    if (item.video_url.length > 0) {
                        [paramDic setObject:@"1" forKey:@"is_video"];
                    }

                    [net getDataWithStyle:NetStyleDelShow andParam:paramDic];
                    
                }
                
            }
            
        }
    }else if(buttonIndex == 0 )
    {
        if (!actionSheet.isVisible) {
            [self shareToThird];
        }
    }else{
        
        //举报
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        NSArray *singleArray=[_dataArray objectAtIndex:actionSheet.tag];
        MyOutPutPraiseAndReviewItem *pItem=[singleArray lastObject];
        ReportViewController *report=[[ReportViewController alloc]init];
        report.imgId=pItem.imgid;
        report.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:report animated:YES];
        
    }
    }
    
}


@end
