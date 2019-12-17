//
//  GrowthDetailViewController.m
//  BabyShow
//
//  Created by Monica on 15-1-24.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "GrowthDetailViewController.h"

#import "BBSNavigationController.h"
#import "PraiseAndReviewListViewController.h"
#import "GrowthDiaryViewController.h"
#import "GrowthEditViewController.h"

#import "DiaryDetailTitleCell.h"
#import "DiaryDetailUserCell.h"
#import "DiaryDetailDescribeCell.h"
#import "DiaryDetailPhotoCell.h"
#import "DiaryDetailReviewCell.h"
#import "DiaryDetailMoreReviewCell.h"
#import "DiaryDetailCountCell.h"

#import "PostBarDetailNewTitleItem.h"
#import "PostBarDetailNewUserItem.h"
#import "PostBarDetailNewDescribeItem.h"
#import "PostBarDetailNewPhotoItem.h"
#import "PostBarDetailNewReviewItem.h"
#import "PostBarDetailNewMoreReviewItem.h"
#import "PostBarDetailNewPraiseItem.h"

#import "SVPullToRefresh.h"
#import "SDWebImageManager.h"
#import "MWPhotoBrowser.h"
#import "BBSEmojiInfo.h"

#import "ShowAlertView.h"
#import "MyHomeNewVersionVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>



@interface GrowthDetailViewController ()<DiaryDetailCountCellDelegate,DiaryDetailPhotoCellDelegate,DiaryDetailMoreReviewCellDelegate,UITableViewDelegate,UITableViewDataSource,MWPhotoBrowserDelegate,UIActionSheetDelegate>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_PhotoArray;
    NSArray *facesArray;
    NSDictionary *facesDictionary;
    
    NSString *loginUserID;
    int page;
    
    NSIndexPath *_praiseIndexPath;
    NSIndexPath *_reviewIndexPath;
    NSInteger    _deleteSection;
}

@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,assign)BOOL isFinished;
@property(nonatomic,strong)UIButton *editBtn;

@end

@implementation GrowthDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = [NSMutableArray array];
        _PhotoArray = [NSMutableArray array];
        loginUserID = LOGIN_USER_ID;
        facesArray = [[NSArray alloc]initWithArray:[Emoji allEmoji]];
        facesDictionary = [[NSDictionary alloc]initWithDictionary:[Emoji allEmojiDictionary]];
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    page = 1;
    [self setLeftBarButton];
    [self setRightBarButton];
    [self setTableView];
    [self getData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_DIARY_IMGS_LIST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFailed:) name:USER_DIARY_IMGS_LIST_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed) name:USER_NET_ERROR object:nil];
    
    //赞
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PraiseSucceed:) name:USER_MYSHOWPRAISE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PraiseFail:) name:USER_MYSHOWPRAISE_FAIL object:nil];
    
    //取消赞
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PraiseSucceed:) name:USER_MYSHOWCANCELPRAISE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PraiseFail:) name:USER_MYSHOWCANCELPRAISE_FAIL object:nil];
    
    //删除单张成长日记
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSucceed:) name:USER_DELETE_SHOW_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteFail:) name:USER_DELETE_SHOW_FAIL object:nil];
    
    if (self.refresh) {
        
        for (UIViewController *viewC in self.navigationController.viewControllers) {
            if ([viewC isKindOfClass:[GrowthDiaryViewController class]]) {
                GrowthDiaryViewController *viewController = (GrowthDiaryViewController *)viewC;
                viewController.refresh = YES;
            }
        }
        
        [_dataArray removeAllObjects];
        page = 1;
        _isFinished = NO;
        [self getData];
        
    }
    
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [LoadingView stopOnTheViewController:self];
}
#pragma mark - NetWork Methods
- (void)getData {
    _editBtn.enabled = NO;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:loginUserID,@"user_id",self.babyID,@"baby_id",self.nodeID,@"album_id",[NSString stringWithFormat:@"%d",page],@"page",nil];
    
    [[NetAccess sharedNetAccess] getDataWithStyle:NetStyleDiaryImgsList andParam:params];
    [LoadingView startOnTheViewController:self];
    
}
#pragma mark - private
- (void)setLeftBarButton {
    CGRect backBtnFrame=CGRectMake(0, 0, 23, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back2"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    
    UIFont *font = [UIFont boldSystemFontOfSize:17];
    CGFloat width = [self.nodeName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size.width;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, width, 31)];
    label.font = font;
    label.text = self.nodeName;
    label.textColor = [UIColor whiteColor];
    UIBarButtonItem *labelBar = [[UIBarButtonItem alloc] initWithCustomView:label];
    self.navigationItem.leftBarButtonItems = @[left,labelBar];
}
- (void)setRightBarButton {
    
    UIButton *shareBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame=CGRectMake(0, 0, 45, 29);
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"btn_diary_share1"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareOut:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *shareItem=[[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 25)];
    aView.backgroundColor =[BBSColor hexStringToColor:@"ffffff" alpha:0.8];
    UIBarButtonItem *lineItem = [[UIBarButtonItem alloc] initWithCustomView:aView];
    
    _editBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame=CGRectMake(0, 0, 45, 29);
    _editBtn.tag = 987;
    [_editBtn setBackgroundImage:[UIImage imageNamed:@"btn_diary_edit"] forState:UIControlStateNormal];
    
    UIBarButtonItem *editItem=[[UIBarButtonItem alloc]initWithCustomView:_editBtn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10;
    
    //rightBarButtonItems are placed right-to-left with the first item in the list at the right outside edge and right aligned.
    self.navigationItem.rightBarButtonItems = @[spaceItem,editItem,lineItem,shareItem];
}
- (void)setTableView {
    if (_tableView) {
        [_tableView reloadData];
    }
    
    CGRect frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    __block GrowthDetailViewController *blockSelf = self;
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        if (!blockSelf.isFinished) {
            if (blockSelf.tableView.pullToRefreshView.state==SVInfiniteScrollingStateStopped) {
                [blockSelf getData];
            }
        }else{
            if (blockSelf.tableView.infiniteScrollingView && blockSelf.tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
                [blockSelf.tableView.infiniteScrollingView stopAnimating];
            }
            
        }
    }];
    
}
#pragma mark - Actions Methods
- (void)shareOut:(UIButton *)button {
    NSArray *firstArray =  [_dataArray firstObject];
    PostBarDetailNewTitleItem *titleItem ;
    PostBarDetailNewPhotoItem *photoItem ;
    PostBarDetailNewUserItem  *userItem ;
    for (int i = 0; i < firstArray.count; i++) {
        if ([firstArray[i] isKindOfClass:[PostBarDetailNewTitleItem class]]) {
            titleItem = firstArray[i];
            continue;
        }
        if ([firstArray[i] isKindOfClass:[PostBarDetailNewUserItem class]]) {
            userItem = firstArray[i];
            continue;
        }
        if ([firstArray[i] isKindOfClass:[PostBarDetailNewPhotoItem class]]) {
            photoItem = firstArray[i];
            break;
        }
    }
    
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray;
    if (photoItem.thumbString.length > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",photoItem.thumbString]];
        UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        NSData *basicImgData = UIImagePNGRepresentation(shareImg);
        if (basicImgData.length/1024>150) {
            shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
            
        }

        imageArray = @[shareImg];
        
    }else{
        imageArray = @[[UIImage imageNamed:@"img_default"]];
        
    }
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
    //添加一个自定义的平台（非必要）
//    SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"img_diary_share"]
//                                                                                  label:@"话题"
//                                                                                onClick:^{
//                                                                                    [self shareToPostAndShow];
//
//                                                                                }];
//    [activePlatforms addObject:item];

    NSString *tagName = userItem.tag_name;
    
    NSString *urlString = [NSString stringWithFormat:@"%@album_id=%@&user_id=%@&baby_id=%@",DiaryDetailShareUrl,self.nodeID,userItem.userid,self.babyID];
    NSString *content;
    if (tagName.length > 0) {
        content = [NSString stringWithFormat:@"%@@%@:%@",userItem.username,tagName,(titleItem.titleContent.length <=0) ? @"精彩记录宝宝成长每一天" : titleItem.titleContent];
        
    }else{
        content = [NSString stringWithFormat:@"%@@%@:%@",userItem.username,self.nodeName,(titleItem.titleContent.length <=0) ? @"精彩记录宝宝成长每一天" : titleItem.titleContent];
        
        
    }
    NSString *titleString = [NSString stringWithFormat:@"%@成长记录",userItem.username];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]
                                      title:titleString
                                       type:SSDKContentTypeAuto];
    //设置新浪微博
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",content,[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:titleString image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
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
- (void)shareToPostAndShow {
    [LoadingView startOnTheViewController:self];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.nodeID,@"album_id",@"1",@"post_class", nil];
    [[HTTPClient sharedClient] postNewV1:kShareToPost params:params success:^(NSDictionary *result) {
        [LoadingView stopOnTheViewController:self];
        if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
            [BBSAlert showAlertWithContent:@"分享成功" andDelegate:nil];
        } else {
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
        [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
    }];
}
#pragma mark -
- (void)editDiary:(UIButton *)button {
    
    NSArray *sectionArray=[_dataArray objectAtIndex:0];
    id obj=[sectionArray objectAtIndex:0];
    
    GrowthEditViewController *viewController = [[GrowthEditViewController alloc] init];
    viewController.babyID = self.babyID;
    viewController.nodeID = self.nodeID;
    viewController.nodeName = self.nodeName;
    if ([obj isKindOfClass:[PostBarDetailNewTitleItem class]]) {
        
        PostBarDetailNewTitleItem *item=(PostBarDetailNewTitleItem *) obj;
        viewController.nodeTitle = item.titleContent;
        
    }
    [self.navigationController pushViewController:viewController animated:YES];
    
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark UITableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArray count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array=[_dataArray objectAtIndex:section];
    return [array count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *sectionArray=[_dataArray objectAtIndex:indexPath.section];
    PostBarDetailNewBasicItem *item=[sectionArray objectAtIndex:indexPath.row];
    return item.height;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *returnCell;
    
    NSArray *sectionArray=[_dataArray objectAtIndex:indexPath.section];
    
    id obj=[sectionArray objectAtIndex:indexPath.row];
    
    SDWebImageManager *manager=[SDWebImageManager sharedManager];
    
    if ([obj isKindOfClass:[PostBarDetailNewTitleItem class]]) {
        
        PostBarDetailNewTitleItem *item=(PostBarDetailNewTitleItem *) obj;
        
        DiaryDetailTitleCell *cell=[tableView dequeueReusableCellWithIdentifier:item.identify];
        if (!cell) {
            cell=[[DiaryDetailTitleCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.identify];
        }
        
        [cell resetFrameWithContent:item.titleContent];
        cell.titleLabel.text=item.titleContent;
        
        returnCell=cell;
        
    }else if ([obj isKindOfClass:[PostBarDetailNewUserItem class]]){
        
        PostBarDetailNewUserItem *item=(PostBarDetailNewUserItem *) obj;
        
        DiaryDetailUserCell *cell=[tableView dequeueReusableCellWithIdentifier:item.identify];
        if (!cell) {
            cell=[[DiaryDetailUserCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.identify];
        }
        cell.avatarView.image = [UIImage imageNamed:@"img_message_avatar_100"];
        [manager downloadImageWithURL:[NSURL URLWithString:item.avatarString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            cell.avatarView.image=image;
        }];
        cell.nameLabel.text=item.username;
        cell.timeLabel.text=item.time;
        
        returnCell=cell;
        
    }else if ([obj isKindOfClass:[PostBarDetailNewDescribeItem class]]){
        
        PostBarDetailNewDescribeItem *item=(PostBarDetailNewDescribeItem *) obj;
        
        DiaryDetailDescribeCell *cell=[tableView dequeueReusableCellWithIdentifier:item.identify];
        if (!cell) {
            cell=[[DiaryDetailDescribeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.identify];
        }
        
        [cell resetLabelFrameWithContent:item.describeString];
        cell.describeLabel.text=item.describeString;
        
        NSDictionary *dictionary = [BBSEmojiInfo detailContentWithStringAndEmoji:cell.describeLabel.text fromArray:facesArray];
        NSString *content = [dictionary objectForKey:@"content"];
        NSArray *tNumArray = [dictionary objectForKey:@"emoji"];
        
        cell.describeLabel.text=content;
        
        for (NSInteger i = tNumArray.count-1; i >=0; i--) {
            
            NSDictionary *dict = [tNumArray objectAtIndex:i];
            int numid = [[dict objectForKey:@"location"] intValue];
            NSString * emojiText = [dict objectForKey:@"emojiText"];
            UIImage *image = [UIImage imageNamed:[facesDictionary objectForKey:emojiText]];
            [cell.describeLabel insertImage:image atIndex:(numid-i*4) margins:UIEdgeInsetsMake(-2, 0, -2, 0)];
            
        }
        
        
        returnCell=cell;
        
    }else if ([obj isKindOfClass:[PostBarDetailNewPhotoItem class]]){
        
        PostBarDetailNewPhotoItem *item=(PostBarDetailNewPhotoItem *) obj;
        
        DiaryDetailPhotoCell *cell=[tableView dequeueReusableCellWithIdentifier:item.identify];
        if (!cell) {
            cell=[[DiaryDetailPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.identify];
        }
        
        cell.delegate=self;
        cell.imgBtn.indexpath=indexPath;
        
        [cell.imgBtn setBackgroundImage:nil forState:UIControlStateNormal];
        cell.imgBtn.frame=item.frame;
        [manager downloadImageWithURL:[NSURL URLWithString:item.thumbString] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            [cell.imgBtn setBackgroundImage:image forState:UIControlStateNormal];
            
        }];
        returnCell=cell;
        
    }else if ([obj isKindOfClass:[PostBarDetailNewReviewItem class]]){
        
        PostBarDetailNewReviewItem *item=(PostBarDetailNewReviewItem *) obj;
        
        DiaryDetailReviewCell *cell=[tableView dequeueReusableCellWithIdentifier:item.identify];
        if (!cell) {
            cell=[[DiaryDetailReviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.identify];
        }
        cell.reviewLabel.text=[NSString stringWithFormat:@"%@:%@",item.username,item.reviewContent];
        [cell resetLabelFrameWithContent:cell.reviewLabel.text];
        
        NSDictionary *dictionary = [BBSEmojiInfo detailContentWithStringAndEmoji:cell.reviewLabel.text fromArray:facesArray];
        NSString *content = [dictionary objectForKey:@"content"];
        NSArray *tNumArray = [dictionary objectForKey:@"emoji"];
        
        cell.reviewLabel.text=content;
        [cell.reviewLabel setTextColor:[BBSColor hexStringToColor:BACKCOLOR] range:[cell.reviewLabel.text rangeOfString:[NSString stringWithFormat:@"%@:",item.username]]];
        
        for (NSInteger i = tNumArray.count-1; i >=0; i--) {
            
            NSDictionary *dict = [tNumArray objectAtIndex:i];
            int numid = [[dict objectForKey:@"location"] intValue];
            NSString * emojiText = [dict objectForKey:@"emojiText"];
            UIImage *image = [UIImage imageNamed:[facesDictionary objectForKey:emojiText]];
            [cell.reviewLabel insertImage:image atIndex:(numid-i*4) margins:UIEdgeInsetsMake(-2, 0, -2, 0)];
            
        }
        
        returnCell=cell;
        
    }else if ([obj isKindOfClass:[PostBarDetailNewMoreReviewItem class]]){
        
        PostBarDetailNewMoreReviewItem *item=(PostBarDetailNewMoreReviewItem *) obj;
        
        DiaryDetailMoreReviewCell *cell=[tableView dequeueReusableCellWithIdentifier:item.identify];
        if (!cell) {
            cell=[[DiaryDetailMoreReviewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.identify];
        }
        [cell.moreReviewBtn setTitle:item.titleString forState:UIControlStateNormal];
        
        cell.delegate=self;
        cell.moreReviewBtn.indexpath=indexPath;
        
        returnCell=cell;
        
    }else if ([obj isKindOfClass:[PostBarDetailNewPraiseItem class]]){
        
        PostBarDetailNewPraiseItem *item=(PostBarDetailNewPraiseItem *) obj;
        
        DiaryDetailCountCell *cell=[tableView dequeueReusableCellWithIdentifier:item.identify];
        if (!cell) {
            cell=[[DiaryDetailCountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.identify];
        }
        
        if (item.isPraised==YES) {
            [cell.praiseBtn setBackgroundImage:[UIImage imageNamed:@"btn_myoutput_praised"] forState:UIControlStateNormal];
        }else{
            [cell.praiseBtn setBackgroundImage:[UIImage imageNamed:@"btn_unlike"] forState:UIControlStateNormal];
        }
        
        [cell.praiseBtn setTitle:[NSString stringWithFormat:@"%ld",(long)item.praiseCount] forState:UIControlStateNormal];
        [cell.reviewBtn setTitle:[NSString stringWithFormat:@"%ld",(long)item.reviewCount] forState:UIControlStateNormal];
        
        cell.delegate=self;
        cell.praiseBtn.indexpath=indexPath;
        cell.reviewBtn.indexpath=indexPath;
        cell.moreBtn.indexpath=indexPath;
        
        returnCell=cell;
        
    }
    
    returnCell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return returnCell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *sectionArray=[_dataArray objectAtIndex:indexPath.section];
    
    id obj=[sectionArray objectAtIndex:indexPath.row];
    
    if ([obj isKindOfClass:[PostBarDetailNewUserItem class]]) {
        
        PostBarDetailNewUserItem *userItem=(PostBarDetailNewUserItem *) obj;
        
        MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
        myHomePage.userid=userItem.userid;
        myHomePage.hidesBottomBarWhenPushed=YES;
        
        
        if ([userItem.userid intValue]==[loginUserID intValue]) {
            myHomePage.Type=0;
        }else{
            myHomePage.Type=1;
        }
        
        [self.navigationController pushViewController:myHomePage animated:YES];
        
    }
}
#pragma mark - CellDelegate Methods
- (void)showTheDetailOfThePhoto:(btnWithIndexPath *)btn {
    NSArray *sectionArray=[_dataArray objectAtIndex:btn.indexpath.section];
    PostBarDetailNewPhotoItem *item=[sectionArray objectAtIndex:btn.indexpath.row];
    
    int i=0;
    [_PhotoArray removeAllObjects];
    for (NSString *clearString in item.clearPhotosArray) {
        MWPhoto *photo=[[MWPhoto alloc]initWithURL:[NSURL URLWithString:clearString] info:nil];
        photo.img_info =@{@"description": [NSString stringWithFormat:@"%d/%lu",i+1,(unsigned long)item.clearPhotosArray.count],@"img_down":clearString};
        [_PhotoArray addObject:photo];
        i++;
        
    }
    
    MWPhotoBrowser *browser =[[ MWPhotoBrowser alloc]initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    [browser setCurrentPhotoIndex:item.index];
    browser.type = 2;
    browser.needPlay = NO;     //需要播放
    browser.is_show_album =NO;
    browser.user_id =loginUserID;
    
    BBSNavigationController *nav=[[BBSNavigationController alloc]initWithRootViewController:browser];
    [self presentViewController:nav animated:YES completion:nil];
    
}

- (void)praise:(btnWithIndexPath *)sender {
    _praiseIndexPath=[NSIndexPath indexPathForRow:sender.indexpath.row inSection:sender.indexpath.section];
    
    [LoadingView startOnTheViewController:self];
    
    NSArray *sectionArray=[_dataArray objectAtIndex:sender.indexpath.section];
    PostBarDetailNewPraiseItem *praiseItem=[sectionArray lastObject];
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:praiseItem.userid,kAdmireAdmireId,
                            loginUserID,kAdmireUserId,
                            praiseItem.imgid,kAdmireImgId,
                            @"1",@"isdiary",nil];
    
    NetAccess *net=[NetAccess sharedNetAccess];
    
    if (praiseItem.isPraised==NO) {
        
        [net getDataWithStyle:NetStyleAdmire andParam:paramDic];
        
    }else{
        
        [net getDataWithStyle:NetStyleCancelAdmire andParam:paramDic];
        
    }
}
- (void)review:(btnWithIndexPath *)sender {
    _reviewIndexPath = sender.indexpath;
    
    NSArray *sectionArray = [_dataArray objectAtIndex:sender.indexpath.section];
    
    PostBarDetailNewPraiseItem *item = [sectionArray lastObject];
    
    PraiseAndReviewListViewController *reviewListVC = [[PraiseAndReviewListViewController alloc]init];
    reviewListVC.imgID = item.imgid;
    reviewListVC.ownerId = item.userid;
    reviewListVC.useridBePraised = item.userid;//删除用
    reviewListVC.type = MyShowReviewList;
    reviewListVC.isDiary = YES;
    [self.navigationController pushViewController:reviewListVC animated:YES];
    
}
- (void)moreReviews:(btnWithIndexPath *)sender {
    
    NSArray *sectionArray=[_dataArray objectAtIndex:sender.indexpath.section];
    
    PostBarDetailNewPraiseItem *item=[sectionArray lastObject];
    
    PraiseAndReviewListViewController *reviewListVC=[[PraiseAndReviewListViewController alloc]init];
    reviewListVC.imgID=item.imgid;
    reviewListVC.ownerId = item.userid;
    reviewListVC.useridBePraised=item.userid;
    reviewListVC.type=MyShowReviewList;
    reviewListVC.isDiary=YES;
    [self.navigationController pushViewController:reviewListVC animated:YES];
    
}
/*!
 *  删除该张
 */
- (void)more:(btnWithIndexPath *)sender {
    
    _deleteSection = sender.indexpath.section;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >=8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *shareAction = [UIAlertAction actionWithTitle:@"分享" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self shareToThird];
        }];
        [alertController addAction:shareAction];
        [alertController addAction:[UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self deleteOrReport];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [alertController dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:^{
            
        }];
    } else {
        UIActionSheet *action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"分享",@"删除",nil];
        action.tag=sender.indexpath.section;
        action.destructiveButtonIndex = action.numberOfButtons - 2;
        [action showInView:self.view];
    }
    
    
}
#pragma mark - NetNotification Methods
- (void)getDataSucceed:(NSNotification *)noti {
    _editBtn.enabled = YES;
    [_editBtn addTarget:self action:@selector(editDiary:) forControlEvents:UIControlEventTouchUpInside];
    NSString *styleString=noti.object;
    NSArray *returnArray=[[NetAccess sharedNetAccess] getReturnDataWithNetStyle:[styleString intValue]];
    _refresh = NO;
    if (returnArray.count==0) {
        _isFinished=YES;
    } else {
        page ++;
    }
    
    [_dataArray addObjectsFromArray:returnArray];
    
    [_tableView reloadData];
    
    [LoadingView stopOnTheViewController:self];
    
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    
}
- (void)getDataFailed:(NSNotification *)noti {
    _editBtn.enabled = YES;
    [LoadingView stopOnTheViewController:self];
    _refresh = NO;
    
    NSString *message = noti.object;
    [BBSAlert showAlertWithContent:message andDelegate:nil];
    
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
}
-(void)PraiseSucceed:(NSNotification *) note{
    
    DiaryDetailCountCell *cell=(DiaryDetailCountCell *)[_tableView cellForRowAtIndexPath:_praiseIndexPath];
    
    NSArray *sectionArray=[_dataArray objectAtIndex:_praiseIndexPath.section];
    PostBarDetailNewPraiseItem *Item=[sectionArray lastObject];
    
    if (Item.isPraised==YES) {
        [cell.praiseBtn setBackgroundImage:[UIImage imageNamed:@"btn_unlike"] forState:UIControlStateNormal];
        Item.praiseCount--;
        Item.isPraised=NO;
        [cell.praiseBtn setTitle:[NSString stringWithFormat:@"%ld",(long)Item.praiseCount] forState:UIControlStateNormal];
    }else{
        [cell.praiseBtn setBackgroundImage:[UIImage imageNamed:@"btn_myoutput_praised"] forState:UIControlStateNormal];
        Item.praiseCount++;
        Item.isPraised=YES;
        [cell.praiseBtn setTitle:[NSString stringWithFormat:@"%ld",(long)Item.praiseCount] forState:UIControlStateNormal];
    }
    
    [LoadingView stopOnTheViewController:self];
    
    
}

-(void)PraiseFail:(NSNotification *) note{
    
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:note.object andDelegate:self];
    
}
-(void)deleteSucceed:(NSNotification *) note{
    
    NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:_deleteSection];
    
    NSArray *itemsArray = [_dataArray objectAtIndex:_deleteSection];
    NSMutableArray *indexPathsArray = [[NSMutableArray alloc]init];
    
    for (int i = 0;i<itemsArray.count;i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:_deleteSection];
        [indexPathsArray addObject:indexPath];
        
    }
    
    [_dataArray removeObjectAtIndex:_deleteSection];
    
    [_tableView beginUpdates];
    
    [_tableView deleteRowsAtIndexPaths:indexPathsArray withRowAnimation:UITableViewRowAnimationFade];
    [_tableView deleteSections:set withRowAnimation:UITableViewRowAnimationFade];
    [_tableView reloadData];
    [_tableView endUpdates];
    [LoadingView stopOnTheViewController:self];
    
    GrowthDiaryViewController *viewController;
    for (UIViewController *viewC in self.navigationController.viewControllers) {
        if ([viewC isKindOfClass:[GrowthDiaryViewController class]]) {
            viewController = (GrowthDiaryViewController *)viewC;
            viewController.refresh = YES;
        }
    }
    
    if (_dataArray.count==0) {
        
        viewController.needReload = YES;
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

-(void)deleteFail:(NSNotification *) note{
    
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:note.object andDelegate:nil];
    
}

- (void)netFailed {
    [LoadingView stopOnTheViewController:self];
    _refresh = NO;
    
    
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
}
#pragma mark - UIActionSheetDelegate Methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    _deleteSection=actionSheet.tag;
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:NO];
    
    if (buttonIndex == 0) {
        //分享
        //如果actionsheet没有完全消失就调用分享列表会崩溃
        if (!actionSheet.isVisible) {
            [self shareToThird];
        }
    } else if (buttonIndex == 1) {
        //删除
        [self deleteOrReport];
        
    }
}

- (void)deleteOrReport {
    
    //删除
    NSArray *sectionArray=[_dataArray objectAtIndex:_deleteSection];
    PostBarDetailNewPraiseItem *item=[sectionArray lastObject];
    
    NSDictionary *paramDic=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"isdiary",item.imgid,@"id",
                            loginUserID,@"user_id", nil];
    NetAccess *net=[NetAccess sharedNetAccess];
    [net getDataWithStyle:NetStyleDelShow andParam:paramDic];
    [LoadingView startOnTheViewController:self];
}
- (void)shareToThird {
    
    NSArray *sectionArray =  [_dataArray objectAtIndex:_deleteSection];
    PostBarDetailNewDescribeItem *titleItem ;
    PostBarDetailNewPhotoItem *photoItem ;
    PostBarDetailNewUserItem  *userItem ;
    for (int i = 0; i < sectionArray.count; i++) {
        if ([sectionArray[i] isKindOfClass:[PostBarDetailNewDescribeItem class]]) {
            titleItem = sectionArray[i];
            continue;
        }
        if ([sectionArray[i] isKindOfClass:[PostBarDetailNewUserItem class]]) {
            userItem = sectionArray[i];
            continue;
        }
        if ([sectionArray[i] isKindOfClass:[PostBarDetailNewPhotoItem class]]) {
            photoItem = sectionArray[i];
            break;
        }
    }
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray;
    if (photoItem.thumbString.length > 0) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",photoItem.thumbString]];
        UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        imageArray = @[shareImg];
    }else{
        imageArray = @[[UIImage imageNamed:@"img_default"]];
        
    }
    /*
    NSMutableArray *activePlatforms = [NSMutableArray arrayWithArray:[ShareSDK activePlatforms]];
    //添加一个自定义的平台（非必要）
    SSUIShareActionSheetCustomItem *item = [SSUIShareActionSheetCustomItem itemWithIcon:[UIImage imageNamed:@"img_diary_share"]
                                                                                  label:@"话题"
                                                                                onClick:^{
                                                                                    
                                                                        [self shareSingleToPostAndShow:userItem.imgid];
                                                                                }];
    [activePlatforms addObject:item];
     */
    
    NSString *tagName = userItem.tag_name;
    NSString *urlString = [NSString stringWithFormat:@"%@user_id=%@&img_id=%@",DiarySingleShareUrl,userItem.userid,userItem.imgid];
    //    NSLog(@"%@",urlString);return;
    NSString *content = [NSString stringWithFormat:@"%@@%@:%@",userItem.username,userItem.time,(titleItem.describeString.length <=0) ? @"精彩记录宝宝成长每一天" : titleItem.describeString];
    NSString *titleString = [NSString stringWithFormat:@"%@成长记录",userItem.username];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]
                                      title:titleString
                                       type:SSDKContentTypeAuto];
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",content,[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:titleString image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
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
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                    message:nil
                                                                   delegate:nil
                                                          cancelButtonTitle:@"确定"
                                                          otherButtonTitles:nil];
                [alertView show];
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
- (void)shareSingleToPostAndShow:(NSString *)imgid {
    [LoadingView startOnTheViewController:self];
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:imgid,@"img_id", nil];
    [[HTTPClient sharedClient] postNew:kShareSingleToPost params:params success:^(NSDictionary *result) {
        [LoadingView stopOnTheViewController:self];
        if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
            [BBSAlert showAlertWithContent:@"分享成功" andDelegate:nil];
        } else {
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
        [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
    }];
}
#pragma mark MWPhotoBrowserDelegate

-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    
    return _PhotoArray.count;
    
}
-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    if (index < _PhotoArray.count) {
        
        return [_PhotoArray objectAtIndex:index];
        
    }
    
    return nil;
    
}
@end
