//
//  MyMessageListVC.m
//  BabyShow
//
//  Created by WMY on 15/11/16.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyMessageListVC.h"
#import "RegisterStep2ViewController.h"
#import "TA_AlbumListViewController.h"
#import "AlbumListViewController.h"
#import "MyOutPutViewController.h"
#import "MyFansListViewController.h"
#import "PhotoShareViewController.h"
#import "PostBarNewVC.h"
#import "ImageDetailViewController.h"
//#import "PostBarNewDetailVC.h"
#import "WebViewController.h"
#import "BBSNavigationController.h"
#import "ReportViewController.h"
#import "ClickViewController.h"

#import "MyOutPutBasicItem.h"
#import "UserInfoItem.h"
#import "MyOutPutTitleItem.h"
#import "MyOutPutTitleItemNotToday.h"
#import "MyOutPutDescribeItem.h"
#import "MyOutPutUrlItem.h"
#import "MyOutPutImgGroupItem.h"
#import "MyOutPutPraiseAndReviewItem.h"

#import "MyHomePageCell.h"
#import "MessageCell.h"
#import "MessageListRequestCell.h"
#import "MyOutPutTitleTodayCell.h"
#import "MyOutPutTitleNotTodayCell.h"
#import "MyOutPutDescribeCell.h"
#import "MyOutPutUrlCell.h"
#import "MyOutPutGroupImgCell.h"
#import "MyOutPutSingleImgCell.h"
#import "MyOutPutPraiseAndReviewCell.h"

#import "MWPhotoBrowser.h"
#import "SVPullToRefresh.h"
#import "SDWebImageManager.h"
#import "BBSEmojiInfo.h"
#import "MyOrdersViewController.h"
#import "StoreOrdersViewController.h"
#import "MyHomeNewVersionVC.h"
#import "PostBarNewDetialV1VC.h"
#import "BabyShowPlayerVC.h"


@interface MyMessageListVC ()<MessageCellDelegate,MessageListRequestCellDelegate,UIActionSheetDelegate,
MyOutPutUrlCellDelegate,myOutPutGroupImgCellDelegate,MyOutPutSingleImgCellDelegate,MyOutPutPraiseAndReviewCellDelegate,MWPhotoBrowserDelegate>
{
    UIView *_emptyView;
    
}
//添加关注/取消关注,区分header的按钮还是row里面的按钮
@property (nonatomic ,assign) BOOL focusHeader;
@property (nonatomic ,strong) NSNumber *lastId;
@property (nonatomic ,assign) BOOL isRefresh;//是否刷新
@property (nonatomic ,assign) BOOL isFinished;
@property (nonatomic ,assign) NSInteger selectedIndex;


@end

@implementation MyMessageListVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _dataArray=[[NSMutableArray alloc]init];
        _PhotoArray=[[NSMutableArray alloc]init];
        
        self.messDic=[[NSDictionary alloc]init];
        self.userid=[[NSString alloc]init];
        self.message=[[NSString alloc]init];
        facesArray = [[NSArray alloc]initWithArray:[Emoji allEmoji]];
        facesDictionary = [[NSDictionary alloc]initWithDictionary:[Emoji allEmojiDictionary]];
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden=NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessListSucceed:) name:USER_GET_MESSLIST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessListFail:) name:USER_GET_MESSLIST_FAIL object:nil];
    //请求数据成功与失败
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusSucceed) name:USER_FOCUS_ON_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusFail:) name:USER_FOCUS_ON_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFocusSucceed) name:USER_CANCEL_FOCUS_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFocusFail:) name:USER_CANCEL_FOCUS_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(agreeShareSucceed) name:USER_AGREE_SHARE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(agreeShareFail:) name:USER_AGREE_SHARE_FAIL object:nil];
    //赞成功与失败
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseSucceed) name:USER_MYSHOWPRAISE_SUCCEED object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseFail:) name:USER_MYSHOWPRAISE_FAIL object:nil];
//    
//    //取消赞成功与失败
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseSucceed) name:USER_MYSHOWCANCELPRAISE_SUCCEED object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseFail:) name:USER_MYSHOWCANCELPRAISE_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(combineDiarySucceed) name:USER_DIARY_COMBINEDIARY_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(combineDiaryFail) name:USER_DIARY_COMBINEDIARY_FAIL object:nil];
    self.tabBarController.tabBar.hidden = YES;

    
    
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    if ((_tableView.pullToRefreshView)&&[_tableView.pullToRefreshView state]==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && [_tableView.infiniteScrollingView state]==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    [LoadingView stopOnTheViewController:self];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setBack];
    [self setTableViewMess];
    // Do any additional setup after loading the view.
    
}
#pragma mark UI
-(void)setBack{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
    self.navigationItem.title=@"消息";

    
}
-(void)setTableViewMess{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.showsVerticalScrollIndicator=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    //获取数据
    _isRefresh = NO;
    _isFinished = NO;
    self.lastId = NULL;
    _page = 1;
    [self getMessageData];
    __weak MyMessageListVC *blockSelf = self;
    [_tableView addPullToRefreshWithActionHandler:^{
        //获取数据
        blockSelf.isRefresh = YES;
        blockSelf.isFinished = NO;
        blockSelf.lastId = NULL;
        blockSelf.page = 1;
        [blockSelf getMessageData];
        
    }];
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        if (!blockSelf.isFinished) {
            //刷新停止状态，还没有触发刷新操作
            if (blockSelf.tableView.pullToRefreshView.state == SVInfiniteScrollingStateStopped) {
                [blockSelf getMessageData];
                
            }
        }else{
            if (blockSelf.tableView.infiniteScrollingView && blockSelf.tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
                //已经发送请求，但数据还没回来，这时菊花一直在转
                [blockSelf.tableView.infiniteScrollingView stopAnimating];
            }
        }
    }];
    
    
    

    
}
- (void)clearBadgeValue {
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.messCount=[NSNumber numberWithInt:0];
    [delegate.tabbarcontroller setbadgeValue:NULL];
    if (self.Type != 1 && delegate.isAllowedToNoti) {
        
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        
    }
}

#pragma mark data
- (void)getMessageData{
    
    NSDictionary *params ;
        params =[NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.userid,@"user_id",self.lastId,@"last_id", nil];
    
    NetAccess *net = [NetAccess sharedNetAccess];
    [net getDataWithStyle:NetStyleGetMessList andParam:params];
    [LoadingView startOnTheViewController:self];
    
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSObject *object = [_dataArray objectAtIndex:indexPath.row];
    
    if([object isKindOfClass:[MessageListRequestItem class]]){
        //消息
        return 99;
        
    } else {
        //动态
        return 99;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *returnCell;
    
    NSObject *object = [_dataArray objectAtIndex:indexPath.row];
    ClickViewController *clickVC = [[ClickViewController alloc] init];
    if ([object isKindOfClass:[MessageItem class]]) {
        //动态
        MessageItem *item = (MessageItem *)object;
        MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MESSAGEDT"];
        if (!cell) {
            
            cell=[[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MESSAGEDT"];
            
        }else{
            
            [cell.photoBtn setBackgroundImage:[UIImage imageNamed:@"img_message_photo.png"] forState:UIControlStateNormal];
            
        }
        
        cell.delegate=self;
        cell.avatarBtn.tag=indexPath.row;
        cell.photoBtn.tag=indexPath.row;
        cell.photoBtn.hidden=YES;
        cell.isReadView.hidden=YES;
        cell.nameLabel.text=item.nickName;
        cell.messLabel.text=item.message;
        cell.timeLabel.text=[NSString stringWithFormat:@"%@",item.time];
        cell.avatarView.image=[UIImage imageNamed:@"img_message_avatar_100.png"];
        if ([item.isRead integerValue]==0) {
            cell.isReadView.hidden=NO;
        }else{
            cell.isReadView.hidden=YES;
        }
        
        CGRect nameFrame = cell.nameLabel.frame;
        CGSize size = [item.nickName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:cell.nameLabel.font} context:nil].size;
        [cell.levelImageView setClickToViewController:clickVC];
        //avatar:
        NSURL *avatarUrl=[NSURL URLWithString:item.avatarStr];
        [[SDWebImageManager sharedManager]downloadImageWithURL:avatarUrl
                                                       options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                           
                                                       } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                                           cell.avatarView.image=image;
                                                       }];
        if (!(item.levelImg.length) <= 0) {
            [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:item.levelImg] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                cell.levelImageView.frame =CGRectMake(nameFrame.origin.x + size.width + 1, nameFrame.origin.y+5, image.size.width*0.8,image.size.height*0.8);
                cell.levelImageView.image = image;
                
            }];
        }else{
            cell.levelImageView.image = nil;
        }
        if (item.photoStr.length) {
            NSURL *photoUrl=[NSURL URLWithString:item.photoStr];
            SDWebImageManager *manager=[SDWebImageManager sharedManager];
            [manager downloadImageWithURL:photoUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [cell.photoBtn setBackgroundImage:image forState:UIControlStateNormal];
                cell.photoBtn.hidden=NO;
                
            }];
        }
        else{
            
            [cell.photoBtn setBackgroundImage:[UIImage imageNamed:@"img_message_photo.png"] forState:UIControlStateNormal];
            cell.photoBtn.hidden=NO;
            
        }
        
        
        //photoview;
        if ([item.point isEqualToString:@"12"]||[item.point isEqualToString:@"11"] ||[item.point isEqualToString:@"13"]|| [item.point isEqualToString:@"24"] ) {
            
            
        }else if ([item.point isEqualToString:@"65"]){
            cell.photoBtn.hidden=YES;//更新了共享相册,不显示图片
        }
        
        returnCell=cell;
    } else {
        //消息
        MessageListRequestItem *item = (MessageListRequestItem *)object;
        MessageListRequestCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MESSAGEQQ"];
        
        if (!cell) {
            
            cell=[[MessageListRequestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MESSAGEQQ"];
            
            
        }
        
        cell.delegate=self;
        cell.avatarBtn.tag=indexPath.row;
        cell.isReadView.hidden=YES;
        cell.nameLabel.text=item.name;
        cell.messageLabel.text=item.message;
        
        if ([item.isRead integerValue]==0) {
            cell.isReadView.hidden=NO;
        }else{
            cell.isReadView.hidden=YES;
        }
        
        CGRect nameFrame = cell.nameLabel.frame;
        CGSize size = [item.name boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:cell.nameLabel.font} context:nil].size;
        if (!(item.levelImg.length) <= 0) {
            [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:item.levelImg] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                cell.levelImageView.frame =CGRectMake(nameFrame.origin.x + size.width + 1, nameFrame.origin.y+5, image.size.width*0.8,image.size.height*0.8);
                cell.levelImageView.image = image;
                
            }];
        }else{
            cell.levelImageView.image = nil;
        }
        [cell.levelImageView setClickToViewController:clickVC];
        
        
        NSURL *avatarUrl=[NSURL URLWithString:item.avatarStr];
        SDWebImageManager *manager=[SDWebImageManager sharedManager];
        [manager downloadImageWithURL:avatarUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            cell.avatarView.image=image;
        }];
        
        cell.Btn.tag=indexPath.row;
        
        [cell.Btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([item.point isEqualToString:@"42"]) {
            
            if ([item.isAgreed intValue]==0) {
                
                [cell.Btn setTitle:@"同意" forState:UIControlStateNormal];
                [cell.Btn setBackgroundColor:[BBSColor hexStringToColor:@"ff8585"]];
                
            }else if([item.isAgreed intValue]==1){
                
                [cell.Btn setTitle:@"已同意" forState:UIControlStateNormal];
                [cell.Btn setBackgroundColor:[UIColor lightGrayColor]];
                
            }
            
        }else if ([item.point isEqualToString:@"41"]){
            
            if ([item.relation intValue]==0 || [item.relation intValue]==3) {
                
                [cell.Btn setTitle:@"添加关注" forState:UIControlStateNormal];
                [cell.Btn setBackgroundColor:[BBSColor hexStringToColor:@"ff8585"]];
                
            }else if ([item.relation intValue]==2 ){
                
                [cell.Btn setTitle:@"相互关注" forState:UIControlStateNormal];
                [cell.Btn setBackgroundColor:[UIColor lightGrayColor]];
                
            }else if ([item.relation intValue]==1){
                
                [cell.Btn setTitle:@"已关注" forState:UIControlStateNormal];
                [cell.Btn setBackgroundColor:[UIColor lightGrayColor]];
                //刚刚和我们的微
            }
            
        }else if([item.point isEqualToString:@"31"] ){
            if ([item.message isEqualToString:@"请求同步成长记录"]) {
                [cell.Btn setTitle:@"同步" forState:UIControlStateNormal];
                cell.Btn.backgroundColor = [BBSColor hexStringToColor:@"ff8585"];
                //  [self getMessageData];
                cell.Btn.hidden = NO;
                
                
            }else{
                cell.Btn.hidden = YES;
            }
            
            
        }
        
        returnCell=cell;
    }
    
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return returnCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSObject *object = [_dataArray objectAtIndex:indexPath.row];
    BOOL isHV;
    //动态
    
    /**
     *  1是评论和赞跳转(包括话题赞评论)，2是共享相册跳转 3跟帖跳转
     */
    if ([object isKindOfClass:[MessageItem class]]) {
        MessageItem *item = (MessageItem *)object;
        float height = [item.img_height floatValue];
        float weight = [item.img_width floatValue];
        if (height > weight) {
            isHV = NO;//横屏
        }else{
            isHV = YES;
        }
        
        if ([item.point isEqualToString:@"11"]||[item.point isEqualToString:@"12"]||[item.point isEqualToString:@"13"]) {
            if (item.video_url.length>0) {
                BabyShowPlayerVC *babyShowPlayerVC = [[BabyShowPlayerVC alloc]init];
                babyShowPlayerVC.videoUrl = item.video_url;
                babyShowPlayerVC.img_id = item.imgId;
                babyShowPlayerVC.isHV = isHV;
                
                [self.navigationController pushViewController:babyShowPlayerVC animated:YES];

            }else{
            ImageDetailViewController *detail = [[ImageDetailViewController alloc]init];
            detail.imgID = [NSString stringWithFormat:@"%@",item.rootImgId];
            detail.userID = [NSString stringWithFormat:@"%@",item.userId];
            detail.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:detail animated:YES];
            }
            
        }else if ([item.target isEqualToString:@"2"]){
            
        }else if ([item.point isEqualToString:@"21"]||[item.point isEqualToString:@"22"]||[item.point isEqualToString:@"23"]||[item.point isEqualToString:@"24"]){
            
            UserInfoManager *manager = [[UserInfoManager alloc]init];
            UserInfoItem *currentUser = [manager currentUserInfo];
            NSLog(@"item.video_url.length常常常常 = %ld",item.video_url.length);
            if (item.video_url.length>0) {
                BabyShowPlayerVC *babyShowPlayerVC = [[BabyShowPlayerVC alloc]init];
                babyShowPlayerVC.videoUrl = item.video_url;
                babyShowPlayerVC.img_id = item.imgId;
                babyShowPlayerVC.isHV = isHV;
                [self.navigationController pushViewController:babyShowPlayerVC animated:YES];
            }else{
            PostBarNewDetialV1VC *detailVC = [[PostBarNewDetialV1VC alloc]init];
            detailVC.img_id = item.rootImgId;
            //楼主ID ,在这里(消息列表里)应该就是我当前登录的ID,因为肯定是我的贴
            detailVC.user_id = currentUser.userId;
            detailVC.login_user_id = currentUser.userId;
            detailVC.refreshInVC = ^(BOOL isRefresh){
            };
            [detailVC setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:detailVC animated:YES];
            }
        }
    }else if([object isKindOfClass:[MessageListRequestItem class]]){
        //消息
        MessageListRequestItem *item = (MessageListRequestItem *)object;
        ////////////////////////待定不行
        
        MyHomeNewVersionVC *homepage=[[MyHomeNewVersionVC alloc]init];
        homepage.userid=[NSString stringWithFormat:@"%@",item.userid];
        
        if ([LOGIN_USER_ID intValue]==[item.userid intValue]) {
            homepage.Type=0;
        }else{
            homepage.Type=1;
        }
        
        [self.navigationController pushViewController:homepage animated:YES];
    }
    [self clearBadgeValue];
    for (NSObject *object in _dataArray) {
        if ([object isKindOfClass:[MessageItem class]]) {
            MessageItem *item = (MessageItem *)object;
            item.isRead = [NSNumber numberWithInt:1];
            
        } else {
            MessageListRequestItem *item = (MessageListRequestItem *)object;
            item.isRead = [NSNumber numberWithInt:1];
            
        }
    }
    [_tableView reloadData];
    
}
-(void)back{//已写
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - MessageListRequestDelegate

-(void)MessageListRequestCellClickOnAvatar:(UIButton *)btn{
        //请求
        MessageListRequestItem *item=[_dataArray objectAtIndex:btn.tag];
        
        //////////////待定
        
        MyHomeNewVersionVC *homepage=[[MyHomeNewVersionVC alloc]init];
        homepage.userid=[NSString stringWithFormat:@"%@",item.userid];
        
        if ([LOGIN_USER_ID intValue]==[item.userid intValue]) {
            homepage.Type=0;
        }else{
            homepage.Type=1;
        }
        [homepage setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:homepage animated:YES];
}

#pragma mark - MessageCellDelegate

-(void)ClickOnAvatar:(UIButton *)btn{
    NSObject *object = [_dataArray objectAtIndex:btn.tag];
    if ([object isKindOfClass:[MessageItem class]]) {
        //动态
        MessageItem *item= (MessageItem *) object;
        ////////////////待定
        
        MyHomeNewVersionVC *homepage=[[MyHomeNewVersionVC alloc]init];
        homepage.userid=[NSString stringWithFormat:@"%@",item.userId];
        
        if ([LOGIN_USER_ID intValue]==[item.userId intValue]) {
            homepage.Type=0;
        }else{
            homepage.Type=1;
        }
        [homepage setHidesBottomBarWhenPushed:YES];
        
        [self.navigationController pushViewController:homepage animated:YES];
    }
}

-(void)ClickOnPhoto:(UIButton *)btn{
    
    /**
     *  1是评论和赞跳转(包括话题赞评论)，2是共享相册跳转 3跟帖跳转
     */
    BOOL isHV;
    MessageItem *item=[_dataArray objectAtIndex:btn.tag];
    float height = [item.img_height floatValue];
    float weight = [item.img_width floatValue];
    if (height > weight) {
        isHV = NO;//横屏
    }else{
        isHV = YES;
    }

    
    if ([item.point isEqualToString:@"11"]||[item.point isEqualToString:@"12"]||[item.point isEqualToString:@"13"]) {
        
        ImageDetailViewController *detail=[[ImageDetailViewController alloc]init];
        detail.imgID=[NSString stringWithFormat:@"%@",item.rootImgId];
        detail.userID=[NSString stringWithFormat:@"%@",item.userId];
        //detail.isPost=item.isPost;
        detail.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:detail animated:YES];
        
    }else if ([item.target isEqualToString:@"2"]){
        
    }else if ([item.point isEqualToString:@"21"]||[item.point isEqualToString:@"22"]||[item.point isEqualToString:@"23"]){
        
        UserInfoManager *manager=[[UserInfoManager alloc]init];
        UserInfoItem *currentUser=[manager currentUserInfo];
        if (item.video_url.length>0) {
            BabyShowPlayerVC *babyShowPlayerVC = [[BabyShowPlayerVC alloc]init];
            babyShowPlayerVC.videoUrl = item.video_url;
            babyShowPlayerVC.img_id = item.imgId;
            babyShowPlayerVC.isHV = isHV;
            [self.navigationController pushViewController:babyShowPlayerVC animated:YES];
        }else{
        PostBarNewDetialV1VC *detailVC=[[PostBarNewDetialV1VC alloc]init];
        detailVC.img_id=item.rootImgId;
        //楼主ID ,在这里(消息列表里)应该就是我当前登录的ID,因为肯定是我的贴
        detailVC.user_id=currentUser.userId;
        detailVC.login_user_id=currentUser.userId;
        detailVC.refreshInVC = ^(BOOL isRefresh){
            
        };
        [detailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
        }
    }
    [self clearBadgeValue];
    for (MessageItem *item in _dataArray) {
        item.isRead = [NSNumber numberWithInt:1];
    }
    [_tableView reloadData];
    
    
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
    MyOutPutImgGroupItem *photoItem=[singleArray objectAtIndex:btn.indexpath.row];
    
    NSMutableArray *imgArr = [[NSMutableArray alloc]init];
    int i = 0;
    for (MyShowImageItem *imgItem in photoItem.photosArray) {
        
        NSMutableDictionary *imgDic=[[NSMutableDictionary alloc]init];
        [imgDic setObject:imgItem.imageClearStr forKey:kMyShowImg];
        [imgDic setObject:imgItem.img_down forKey:kMyShowImgDown];
        [imgDic setObject:imgItem.img_width forKey:kMyShowImgWidth];
        [imgDic setObject:imgItem.img_height forKey:kMyShowImgHeight];
        [imgDic setObject:imgItem.imageStr forKey:kMyShowImgThumb];
        [imgDic setObject:imgItem.img_thumb_width forKey:kMyShowImgThumbWidth];
        [imgDic setObject:imgItem.img_thumb_height forKey:kMyShowImgThumbHeight];
        [imgArr addObject:imgDic];
        MWPhoto *photo=[[MWPhoto alloc]initWithURL:[NSURL URLWithString:imgItem.imageClearStr] info:nil];
        photo.img_info =@{@"description": [NSString stringWithFormat:@"%d/%lu",i+1,(unsigned long)photoItem.photosArray.count]};
        [_PhotoArray addObject:photo];
        i++;
        
    }
    
    MWPhotoBrowser *browser =[[ MWPhotoBrowser alloc]initWithDelegate:self];
    //    browser.imgstr=imgItem.imageStr;
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    [browser setCurrentPhotoIndex:btn.tag];
    browser.type = 10;
    browser.needPlay = YES;     //需要播放
    browser.imgArr = imgArr;    //播放需要的东西
    browser.is_show_album =NO;
    browser.user_id =self.userid;
    
    BBSNavigationController *nav=[[BBSNavigationController alloc]initWithRootViewController:browser];
    [self presentViewController:nav animated:YES completion:nil];
    
    
}

-(void)SeeTheSingleImage:(btnWithIndexPath *)btn{
    
    [_PhotoArray removeAllObjects];
    
    NSArray *singleArray=[_dataArray objectAtIndex:btn.indexpath.section];
    MyOutPutImgGroupItem *photoItem=[singleArray objectAtIndex:btn.indexpath.row];
    
    NSMutableArray *imgArr = [[NSMutableArray alloc]init];
    int i = 0;
    for (MyShowImageItem *imgItem in photoItem.photosArray) {
        
        NSMutableDictionary *imgDic=[[NSMutableDictionary alloc]init];
        [imgDic setObject:imgItem.imageClearStr forKey:kMyShowImg];
        [imgDic setObject:imgItem.img_down forKey:kMyShowImgDown];
        [imgDic setObject:imgItem.img_width forKey:kMyShowImgWidth];
        [imgDic setObject:imgItem.img_height forKey:kMyShowImgHeight];
        [imgDic setObject:imgItem.imageStr forKey:kMyShowImgThumb];
        [imgDic setObject:imgItem.img_thumb_width forKey:kMyShowImgThumbWidth];
        [imgDic setObject:imgItem.img_thumb_height forKey:kMyShowImgThumbHeight];
        [imgArr addObject:imgDic];
        MWPhoto *photo=[[MWPhoto alloc]initWithURL:[NSURL URLWithString:imgItem.imageClearStr] info:nil];
        photo.img_info =@{@"description": [NSString stringWithFormat:@"1/1"]};
        [_PhotoArray addObject:photo];
        i++;
        
    }
    
    MWPhotoBrowser *browser =[[ MWPhotoBrowser alloc]initWithDelegate:self];
    //    browser.imgstr=imgItem.imageStr;
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    [browser setCurrentPhotoIndex:btn.tag];
    browser.type = 10;
    browser.needPlay = NO;     //需要播放
    browser.imgArr = imgArr;    //播放需要的东西
    browser.is_show_album =NO;
    browser.user_id =self.userid;
    
    BBSNavigationController *nav=[[BBSNavigationController alloc]initWithRootViewController:browser];
    [self presentViewController:nav animated:YES completion:nil];
    
}

-(void)praise:(UIButton *)btn{
    
    _praiseSection=btn.tag;
    
    NetAccess *net=[NetAccess sharedNetAccess];
    
    NSMutableDictionary *paramDic=[[NSMutableDictionary alloc]init];
    [paramDic setObject:LOGIN_USER_ID forKey:kAdmireUserId];
    [paramDic setObject:self.userid forKey:kAdmireAdmireId];
    
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
    
    PraiseAndReviewListViewController *reviewsListVC=[[PraiseAndReviewListViewController alloc]init];
    reviewsListVC.useridBePraised=self.userid;
    reviewsListVC.hidesBottomBarWhenPushed=YES;
    reviewsListVC.ownerId = self.userid;
    
    if ([obj isKindOfClass:[MyOutPutTitleItem class]]) {
        
        MyOutPutTitleItem *item=(MyOutPutTitleItem *)obj;
        reviewsListVC.imgID=item.imgid;
        if ([item.come_from isEqualToString:@"1"]) {
            reviewsListVC.isPost=NO;
            reviewsListVC.isWorthBuy=NO;
        }else if ([item.come_from isEqualToString:@"2"]){
            reviewsListVC.isPost=YES;
            reviewsListVC.isWorthBuy=NO;
        }else if ([item.come_from isEqualToString:@"3"]){
            reviewsListVC.isPost=NO;
            reviewsListVC.isWorthBuy=YES;
        }
        
    }else if ([obj isKindOfClass:[MyOutPutTitleItemNotToday class]]){
        
        MyOutPutTitleItemNotToday *item=(MyOutPutTitleItemNotToday *)obj;
        reviewsListVC.imgID=item.imgid;
        if ([item.come_from isEqualToString:@"1"]) {
            reviewsListVC.isPost=NO;
            reviewsListVC.isWorthBuy=NO;
        }else if ([item.come_from isEqualToString:@"2"]){
            reviewsListVC.isPost=YES;
            reviewsListVC.isWorthBuy=NO;
        }else if ([item.come_from isEqualToString:@"3"]){
            reviewsListVC.isPost=NO;
            reviewsListVC.isWorthBuy=YES;
        }
        
    }
    
    [self.navigationController pushViewController:reviewsListVC animated:YES];
    
}

-(void)more:(UIButton *)btn{
    
    NSString *message ;
    if ([self.userid isEqualToString:LOGIN_USER_ID]) {
        message = @"删除";
    }else{
        message = @"举报";
    }
    UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:message otherButtonTitles:nil];
    action.tag=btn.tag;
    [action showFromTabBar:self.tabBarController.tabBar];
    
    
}
#pragma mark - 消息ButtonAction

-(void)btnOnClick:(UIButton *)btn{
    
    _selectedIndex = btn.tag;
    MessageListRequestItem *item=[_dataArray objectAtIndex:btn.tag];
    
    if ([item.point isEqualToString:@"42"]) {
        
        if ([item.isAgreed intValue]==0) {
            
            [self requestShare:btn];
            
        }else if([item.isAgreed intValue]==1){
            
            [self requestCancelShare:btn];
            
        }
        
    }else if ([item.point isEqualToString:@"41"]){
        
        if ([item.relation intValue]==0 || [item.relation intValue]==3 ) {
            
            [self focusOn:btn];
            
        }else if ([item.relation intValue]==2 || [item.relation intValue]==1 ){
            
            [self cancelFocus:btn];
            
        }
        
    }else if([item.point isEqualToString:@"31"]){
        
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:item.userid,@"login_user_id",item.img_id,@"baby_id",item.root_imgid,@"share_baby_id",item.share_userid,@"share_user_id", nil];
        [[NetAccess sharedNetAccess]getDataWithStyle:NetStyleCombineDiary andParam:param];
        [LoadingView startOnTheViewController:self];
    }
    
}
-(void)requestShare:(UIButton *)btn{
    
    
    MessageListRequestItem *item = [_dataArray objectAtIndex:btn.tag];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"user_id",item.userid,@"share_id",@"1",@"share_type",@"1",@"is_agree", nil];
    
    NetAccess *net = [NetAccess sharedNetAccess];
    [net getDataWithStyle:NetStyleAgreeShare andParam:param];
    [LoadingView startOnTheViewController:self];
    
}

-(void)requestCancelShare:(UIButton *)btn{
    
    actionType=CANCELSHARE_TYPE;
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请注意" message:@"如果删除共享，对方将无法在相册共享组看到你的相册啦，确定删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alert.tag=btn.tag;
    [alert show];
    
}

-(void)focusOn:(UIButton *)btn{
    _focusHeader = NO;
    MessageListRequestItem *item = [_dataArray objectAtIndex:btn.tag];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"user_id",item.userid,@"idol_id", nil];
    
    [[NetAccess sharedNetAccess] getDataWithStyle:NetStyleFocusOn andParam:param];
    [LoadingView startOnTheViewController:self];
}

-(void)cancelFocus:(UIButton *)btn{
    _focusHeader = NO;
    actionType=CANCELFOCUS_TYPE;
    
    UIActionSheet *acs=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"取消关注" otherButtonTitles:nil];
    acs.tag=btn.tag;
    [acs showFromTabBar:self.tabBarController.tabBar];
    
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==1){
        if (alertView.tag < 0) {
            AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            [delegate setStartViewController];
            return;
            
        }
        
        MessageListRequestItem *item=[_dataArray objectAtIndex:alertView.tag];
        
        NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"user_id",item.userid,@"share_id",@"1",@"share_type",@"0",@"is_agree", nil];
        
        NetAccess *net=[NetAccess sharedNetAccess];
        [net getDataWithStyle:NetStyleAgreeShare andParam:param];
        [LoadingView startOnTheViewController:self];
        
    }
    
}
#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    if (self.Type == 1) {
        if (buttonIndex==0) {
            //这个页面没有删除
            //举报
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            NSArray *singleArray=[_dataArray objectAtIndex:actionSheet.tag];
            MyOutPutPraiseAndReviewItem *pItem=[singleArray lastObject];
            ReportViewController *report=[[ReportViewController alloc]init];
            report.imgId=pItem.imgid;
            report.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:report animated:YES];
            
        }
    } else {
        if (buttonIndex == 0) {
            if (actionType == CANCELFOCUS_TYPE){
                
                MessageListRequestItem *item = [_dataArray objectAtIndex:actionSheet.tag];
                
                NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"user_id",item.userid,@"idol_id", nil];
                NetAccess *net = [NetAccess sharedNetAccess];
                [net getDataWithStyle:NetStyleCancelFocus andParam:param];
                [LoadingView startOnTheViewController:self];
                
            }
        }
    }
}

#pragma mark - NSNotification

-(void)netFail{
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    
}

-(void)focusSucceed{
    
    if (_focusHeader) {
        _relation=1;
      //  [headerView.addKidBtn setBackgroundImage:[UIImage imageNamed:@"btn_myhomepage_cancel_focus.png"] forState:UIControlStateNormal];
    } else {
        MessageListRequestItem *item=[_dataArray objectAtIndex:_selectedIndex];
        
        if ([item.point isEqualToString:@"41"]){
            //改为相互关注
            item.isRead = [NSNumber numberWithInt:1];
            item.relation = [NSNumber numberWithInt:2];
            
            [_dataArray replaceObjectAtIndex:_selectedIndex withObject:item];
            [_tableView reloadData];
            
        }
        [self clearBadgeValue];
        for (MessageListRequestItem *item in _dataArray) {
            item.isRead = [NSNumber numberWithInt:1];
        }
        [_tableView reloadData];
        
    }
    [LoadingView stopOnTheViewController:self];
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
}

-(void)focusFail:(NSNotification *) not{
    
    NSString *errorString=not.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
}

-(void)cancelFocusSucceed{
    
    if (_focusHeader) {
        
        _relation=0;
        //[headerView.addKidBtn setBackgroundImage:[UIImage imageNamed:@"btn_myhomepage_puton_focus.png"] forState:UIControlStateNormal];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    } else {
        MessageListRequestItem *item=[_dataArray objectAtIndex:_selectedIndex];
        
        if ([item.point isEqualToString:@"41"]){
            //改为他关注了我
            item.isRead = [NSNumber numberWithInt:1];
            item.relation = [NSNumber numberWithInt:0];
            
            [_dataArray replaceObjectAtIndex:_selectedIndex withObject:item];
            [_tableView reloadData];
            
        }
       [self clearBadgeValue];
        for (MessageListRequestItem *item in _dataArray) {
            item.isRead = [NSNumber numberWithInt:1];
        }
        [_tableView reloadData];
        
    }
    [LoadingView stopOnTheViewController:self];
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
}

-(void)cancelFocusFail:(NSNotification *) not{
    
    NSString *errorString=not.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
}
-(void)agreeShareSucceed{
    
    [LoadingView stopOnTheViewController:self];
    
    MessageListRequestItem *item = [_dataArray objectAtIndex:_selectedIndex];
    
    if ([item.point isEqualToString:@"42"]) {
        item.isRead = [NSNumber numberWithInt:1];
        
        if ([item.isAgreed intValue] == 0) {
            //同意共享成功
            item.isAgreed = [NSNumber numberWithInt:1];
            [_dataArray replaceObjectAtIndex:_selectedIndex withObject:item];
            
        }else if([item.isAgreed intValue] == 1){
            //删除对他的共享成功
            [_dataArray removeObjectAtIndex:_selectedIndex];
            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView endUpdates];
        }
    }
    [self clearBadgeValue];
    for (MessageListRequestItem *item in _dataArray) {
        item.isRead = [NSNumber numberWithInt:1];
    }
    [_tableView reloadData];
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
}

-(void)agreeShareFail:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString = not.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
}
-(void)getMessListSucceed:(NSNotification *)not{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *styleString = not.object;
    NetAccess *net = [NetAccess sharedNetAccess];
    NSArray *returnArray = [net getReturnDataWithNetStyle:[styleString intValue]];
    
    if (_isRefresh) {
        [_dataArray removeAllObjects];
        _isRefresh = NO;
    }
    
    [_dataArray addObjectsFromArray:returnArray];
    [_tableView reloadData];
    
    
    if (returnArray.count == 0) {
        _isFinished = YES;
    }
       if (_dataArray.count == 0) {
        [self addEmptyHintView];
    } else {
        if (_emptyView) {
            [_emptyView removeFromSuperview];
            _emptyView = nil;
        }
        //好友主页,显示他发布的
        if (self.Type == 1) {
            if (returnArray.count) {
                _page++;
            }
            
        }else {
            //我的主页,消息展示
            NSObject *object = [returnArray lastObject];
            if ([object isKindOfClass:[MessageItem class]]) {
                
                MessageItem *item = (MessageItem *)object;
                self.lastId = item.messId;
                
            } else if ([object isKindOfClass:[MessageListRequestItem class]]) {
                
                MessageListRequestItem *item = (MessageListRequestItem *)object;
                self.lastId = item.messId;
                
            }
        }

        
        
    }
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state == SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
}

-(void)getMessListFail:(NSNotification *)not{
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
    [LoadingView stopOnTheViewController:self];
    NSString *errorString = not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state == SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
}

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
    
    [_tableView reloadRowsAtIndexPaths:array withRowAnimation:UITableViewRowAnimationNone];
    
    [LoadingView stopOnTheViewController:self];
    
}

-(void)praiseFail:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}
//合并成功的方法
-(void)combineDiarySucceed{
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:@"合并成功请刷新" andDelegate:self];
    [self getMessageData];
    
    
    
}
-(void)combineDiaryFail{
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:@"合并失败，请稍后重试" andDelegate:self];
    
}

- (void)addEmptyHintView {
    
    if (_emptyView){
        return;
    }
    CGRect frame = CGRectMake(0, self.view.bounds.size.height / 2 , SCREENWIDTH, 50);
    _emptyView=[[UIView alloc]initWithFrame:frame];
    _emptyView.backgroundColor = [UIColor clearColor];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 300, 30)];
        label.text=@"暂时还没有消息哦";
    label.font=[UIFont systemFontOfSize:14];
    label.textAlignment=NSTextAlignmentCenter;
    [_emptyView addSubview:label];
    [_tableView addSubview:_emptyView];
    
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
