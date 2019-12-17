//
//  SynchroVC.m
//  BabyShow
//
//  Created by WMY on 15/12/16.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "SynchroVC.h"
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
#import <ShareSDK/ShareSDK.h>
#import "MyHomeNewVersionVC.h"
#import "FDActionSheet.h"
#import "AddFoucExplainVC.h"


@interface SynchroVC ()<UITableViewDataSource,UITableViewDelegate,MWPhotoBrowserDelegate,DiaryDetailPhotoCellDelegate,FDActionSheetDelegate>
{
    NSMutableArray *_dataArray;
    NSMutableArray *_PhotoArray;
    NSArray *facesArray;
    NSDictionary *facesDictionary;
    UITableView *_tableView;
    
    NSString *loginUserID;
    int page;
    BOOL _isRefresh;
    BOOL _isGetMore;
    BOOL _isFinished;
}
@property(nonatomic,strong)YLButton *synchroBtn;
@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,assign)BOOL isFinished;
@property (nonatomic, assign)BOOL isRefresh;
@property (nonatomic, assign)BOOL isGetMore;
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UIButton *selectAllBtn;
@property(nonatomic,assign)BOOL isAll;
@property(nonatomic,assign)BOOL isHaveBaby;
@property(nonatomic,strong)NSMutableArray *babyNameArray;
@property(nonatomic,strong)NSMutableArray *babyIdArray;
@property(nonatomic,strong)NSString *babysIdolId;
@property(nonatomic,strong)PostBarDetailNewUserItem *itemInTheVC;
@property(nonatomic,strong)NSString *selectBabyId;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)NSMutableArray *selectItemsArray;
@property(nonatomic,assign)BOOL isClick;
@end

@implementation SynchroVC
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
       _dataArray = [NSMutableArray array];
        _PhotoArray = [NSMutableArray array];
        loginUserID = LOGIN_USER_ID;
       facesArray = [[NSArray alloc]initWithArray:[Emoji allEmoji]];
       facesDictionary = [[NSDictionary alloc]initWithDictionary:[Emoji allEmojiDictionary]];
        _selectItemsArray = [NSMutableArray array];
        _babyIdArray = [NSMutableArray array];
        _babyNameArray = [NSMutableArray array];
     
        
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_DIARY_IMGS_LIST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFailed:) name:USER_DIARY_IMGS_LIST_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ((_tableView.pullToRefreshView)&& [_tableView.pullToRefreshView state] ==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    
    if (_tableView.infiniteScrollingView && [_tableView.infiniteScrollingView state]== SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    [LoadingView stopOnTheViewController:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setLeftBarButton];
    [self setRightButton];
    
    [self setTableView];
    [self setAllSelectView];

    [self getData];

    // Do any additional setup after loading the view.
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
-(void)setRightButton{
    self.synchroBtn = [YLButton buttonEasyInitBackColor:nil frame:CGRectMake(0, 0, 40, 34) type:UIButtonTypeSystem backImage:nil target:self action:@selector(synchroAction) forControlEvents:UIControlEventTouchUpInside];
    [self.synchroBtn setTitle:@"同步" forState:UIControlStateNormal];
    self.synchroBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17];
    
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:self.synchroBtn];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
-(void)setAllSelectView{
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-40, SCREENWIDTH, 40)];
    backView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.view addSubview:backView];
    
    self.selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.selectBtn.frame = CGRectMake(10, 10, 18.5, 18.5);
    [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_unselect_pay"] forState:UIControlStateNormal];
    [backView addSubview:self.selectBtn];
    [self.selectBtn addTarget:self action:@selector(selectAllItem) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectAllBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.selectAllBtn.frame = CGRectMake(35, 10, 30, 20);
    [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectAllBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
    [backView addSubview:self.selectAllBtn];
    [self.selectAllBtn addTarget:self action:@selector(selectAllItem) forControlEvents:UIControlEventTouchUpInside];
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
    _tableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_tableView];
    
    __block SynchroVC *blockSelf = self;
    [_tableView addPullToRefreshWithActionHandler:^{
        
        blockSelf.isRefresh=1;
        page = 1;
        blockSelf.isFinished=0;
        [blockSelf.babyIdArray removeAllObjects];
        [blockSelf.babyNameArray removeAllObjects];
        [blockSelf.selectItemsArray removeAllObjects];
        [blockSelf getData];
        
    }];
    
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
#pragma mark - data
- (void)getData {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:loginUserID,@"user_id",self.babyID,@"baby_id",self.nodeID,@"album_id",[NSString stringWithFormat:@"%d",page],@"page",nil];
    [[NetAccess sharedNetAccess] getDataWithStyle:NetStyleDiaryImgsList andParam:params];
    [LoadingView startOnTheViewController:self];
    
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
        NSLog(@"第一种DiaryDetailTitleCell=%@",item.titleContent);
        
        returnCell=cell;
        
    }else if ([obj isKindOfClass:[PostBarDetailNewUserItem class]]){
        
        PostBarDetailNewUserItem *item=(PostBarDetailNewUserItem *) obj;
        _itemInTheVC = item;
        
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
    
        cell.synchroImg.hidden = NO;
        NSLog(@"第二种DiaryDetailUserCell=%@",item.username);
        if (_isAll == YES) {
            cell.synchroImg.hidden = YES;
        }else{
            [cell setChecked:item.isClick];

        }
        returnCell=cell;
        
    }else if ([obj isKindOfClass:[PostBarDetailNewDescribeItem class]]){
        
        PostBarDetailNewDescribeItem *item=(PostBarDetailNewDescribeItem *) obj;
        
        DiaryDetailDescribeCell *cell=[tableView dequeueReusableCellWithIdentifier:item.identify];
        if (!cell) {
            cell=[[DiaryDetailDescribeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.identify];
        }
        
        [cell resetLabelFrameWithContent:item.describeString];
        cell.describeLabel.text=item.describeString;
        NSLog(@"第3种DiaryDetailDescribeCell=%@",item.describeString);

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
        NSLog(@"第4种DiaryDetailDescribeCell=%@",item.thumbString);

        returnCell=cell;
        
    }else if ([obj isKindOfClass:[PostBarDetailNewPraiseItem class]]){
        
        PostBarDetailNewPraiseItem *item=(PostBarDetailNewPraiseItem *) obj;
        
        DiaryDetailCountCell *cell=[tableView dequeueReusableCellWithIdentifier:item.identify];
        if (!cell) {
            cell=[[DiaryDetailCountCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:item.identify];
        }
        cell.moreBtn.hidden = YES;
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
        DiaryDetailUserCell *cell = (DiaryDetailUserCell*)[tableView cellForRowAtIndexPath:indexPath];
        userItem.isClick = !userItem.isClick;
        [cell setChecked:userItem.isClick];
        if (userItem.isClick == YES) {
            [_selectItemsArray addObject:userItem];
        }else if (userItem.isClick == NO){
            [_selectItemsArray removeObject:userItem];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - NetNotification Methods
- (void)getDataSucceed:(NSNotification *)noti {
    NSString *styleString=noti.object;
    NSArray *returnArray=[[NetAccess sharedNetAccess] getReturnDataWithNetStyle:[styleString intValue]];
    [LoadingView stopOnTheViewController:self];
    
    if (_tableView.pullToRefreshView && _tableView.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableView.pullToRefreshView stopAnimating];
    }
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
    
    if (_isRefresh==1) {
        [_dataArray removeAllObjects];
        [_tableView reloadData];
        _isRefresh=0;
    }
    if (returnArray.count) {
        
        [_dataArray addObjectsFromArray:returnArray];
        [_tableView reloadData];
        page ++;
    }else{
        
        _isFinished=1;
            [self showHUDWithMessage:@"已没有更多数据"];
        }
        
    
   }
- (void)getDataFailed:(NSNotification *)noti {
    [LoadingView stopOnTheViewController:self];
    
    NSString *message = noti.object;
    [BBSAlert showAlertWithContent:message andDelegate:nil];
    
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
}
-(void)netFail{
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }

    
    [BBSAlert showAlertWithContent:@"网络链接失败" andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    
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

#pragma mark
-(void)selectAllItem{
    _isAll = !_isAll;
    if (_isAll == YES) {
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_select_pay"] forState:UIControlStateNormal];
        [self.selectAllBtn setTitleColor:[BBSColor hexStringToColor:@"fe4d3d"] forState:UIControlStateNormal];
        [_tableView reloadData];


    }else{
        [self.selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_unselect_pay"] forState:UIControlStateNormal];
        [self.selectAllBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
        [_tableView reloadData];
    }
}
-(void)synchroAction{
    if (_itemInTheVC.is_type ==0) {
        AddFoucExplainVC *addFouceVC = [[AddFoucExplainVC alloc]init];
        addFouceVC.login_user_id = loginUserID;
        addFouceVC.babys_idol_id = _itemInTheVC.babys_idol_id;
        [self.navigationController pushViewController:addFouceVC animated:YES];
    }else{
        if (_isAll == YES) {
            if (_itemInTheVC.babysCount == 1) {
                NSArray *array = _itemInTheVC.babysArray;
                NSDictionary *dic = array[0];
                _selectBabyId = [NSString stringWithFormat:@"%@",dic[@"baby_id"]];
                [self sureBtton];
            }else{
                for (NSDictionary *babyDic in _itemInTheVC.babysArray) {
                    [_babyIdArray addObject:babyDic[@"baby_id"]];
                    [_babyNameArray addObject:babyDic[@"user_name"]];
                }
                _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
                _backView.backgroundColor = [BBSColor hexStringToColor:@"000000" alpha:0.3];
                [self.view addSubview:_backView];
                UIView *sheetView = [[UIView alloc]initWithFrame:CGRectMake(45, 130, 230, 80+40*_itemInTheVC.babysCount)];
                sheetView.backgroundColor = [UIColor whiteColor];
                sheetView.layer.masksToBounds = YES;
                sheetView.layer.cornerRadius = 10;
                [_backView addSubview:sheetView];
                UILabel *sheetTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 180,20 )];
                sheetTitle.text = @"请选择需要同步给的宝宝";
                sheetTitle.textColor = [BBSColor hexStringToColor:@"999999"];
                sheetTitle.font = [UIFont systemFontOfSize:15];
                [sheetView addSubview:sheetTitle];
                for (int i= 0; i < _itemInTheVC.babysCount+1; i++) {
                    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40*(i+1), 230,1 )];
                    lineView.backgroundColor = [BBSColor hexStringToColor:@"e1e1e1"];
                    [sheetView addSubview:lineView];
                }
                for (int i = 0; i< _itemInTheVC.babysCount; i++) {
                    UILabel *babyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,40*(i+1)+10, 200, 20)];
                    babyNameLabel.font = [UIFont systemFontOfSize:15];
                    babyNameLabel.text = _babyNameArray[i];
                    [sheetView addSubview:babyNameLabel];
                    UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                    selectBtn.frame = CGRectMake(230-30, babyNameLabel.frame.origin.y, 18.5, 18.5);
                    [selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_unselect_pay"] forState:UIControlStateNormal];
                    selectBtn.tag = 5555+i;
                    [sheetView addSubview:selectBtn];
                    UIButton *buttonSelect = [UIButton buttonWithType:UIButtonTypeSystem];
                    buttonSelect.frame = CGRectMake(10, babyNameLabel.frame.origin.y, 220, 30);
                    buttonSelect.tag = 6666+i;
                    [buttonSelect addTarget:self action:@selector(selectBaby:) forControlEvents:UIControlEventTouchUpInside];
                    [sheetView addSubview:buttonSelect];
                }
                UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                cancleBtn.frame = CGRectMake(30, 40*(_itemInTheVC.babysCount+1)+5, 40, 20);
                [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
                [sheetView addSubview:cancleBtn];
                [cancleBtn addTarget:self action:@selector(cancleBtn) forControlEvents:UIControlEventTouchUpInside];
                
                UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                sureBtn.frame = CGRectMake(150, 40*(_itemInTheVC.babysCount+1)+5, 35, 20);
                [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
                [sheetView addSubview:sureBtn];
                [sureBtn addTarget:self action:@selector(sureBtton) forControlEvents:UIControlEventTouchUpInside];
            }
        }else{
        if (_selectItemsArray.count<=0) {
            [BBSAlert showAlertWithContent:@"请选择需要同步的照片" andDelegate:nil];
        }else{
            
        if (_itemInTheVC.babysCount == 1) {
            NSArray *array = _itemInTheVC.babysArray;
            NSDictionary *dic = array[0];
            _selectBabyId = [NSString stringWithFormat:@"%@",dic[@"baby_id"]];
            [self sureBtton];
            
        }else{
      for (NSDictionary *babyDic in _itemInTheVC.babysArray) {
                                [_babyIdArray addObject:babyDic[@"baby_id"]];
                                [_babyNameArray addObject:babyDic[@"user_name"]];
                              
        }
            _backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
            _backView.backgroundColor = [BBSColor hexStringToColor:@"000000" alpha:0.3];
            [self.view addSubview:_backView];
            
            UIView *sheetView = [[UIView alloc]initWithFrame:CGRectMake(45, 130, 230, 80+40*_itemInTheVC.babysCount)];
            sheetView.backgroundColor = [UIColor whiteColor];
            sheetView.layer.masksToBounds = YES;
            sheetView.layer.cornerRadius = 10;
            [_backView addSubview:sheetView];
            
            UILabel *sheetTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 180,20 )];
            sheetTitle.text = @"请选择需要同步给的宝宝";
            sheetTitle.textColor = [BBSColor hexStringToColor:@"999999"];
            sheetTitle.font = [UIFont systemFontOfSize:15];
            [sheetView addSubview:sheetTitle];
            for (int i= 0; i < _itemInTheVC.babysCount+1; i++) {
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 40*(i+1), 230,1 )];
                lineView.backgroundColor = [BBSColor hexStringToColor:@"e1e1e1"];
                [sheetView addSubview:lineView];
            }
            for (int i = 0; i< _itemInTheVC.babysCount; i++) {
                UILabel *babyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,40*(i+1)+10, 200, 20)];
                babyNameLabel.font = [UIFont systemFontOfSize:15];
                babyNameLabel.text = _babyNameArray[i];
                [sheetView addSubview:babyNameLabel];
                UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeSystem];
                selectBtn.frame = CGRectMake(230-30, babyNameLabel.frame.origin.y, 18.5, 18.5);
                [selectBtn setBackgroundImage:[UIImage imageNamed:@"btn_unselect_pay"] forState:UIControlStateNormal];
                selectBtn.tag = 5555+i;
                [sheetView addSubview:selectBtn];
                UIButton *buttonSelect = [UIButton buttonWithType:UIButtonTypeSystem];
                buttonSelect.frame = CGRectMake(10, babyNameLabel.frame.origin.y, 220, 30);
                buttonSelect.tag = 6666+i;
                [buttonSelect addTarget:self action:@selector(selectBaby:) forControlEvents:UIControlEventTouchUpInside];
                [sheetView addSubview:buttonSelect];
                
            }
            UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            cancleBtn.frame = CGRectMake(30, 40*(_itemInTheVC.babysCount+1)+5, 40, 20);
            [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
            
            [sheetView addSubview:cancleBtn];
            [cancleBtn addTarget:self action:@selector(cancleBtn) forControlEvents:UIControlEventTouchUpInside];
            UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            sureBtn.frame = CGRectMake(150, 40*(_itemInTheVC.babysCount+1)+5, 35, 20);
            [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
            [sheetView addSubview:sureBtn];
            [sureBtn addTarget:self action:@selector(sureBtton) forControlEvents:UIControlEventTouchUpInside];

            }
        
          }
       }
    }
}
#pragma mark - UIActionSheetDelegate Methods
-(void)selectBaby:(id)sender{
    UIButton *button =(UIButton*)sender;
    NSInteger tag = button.tag-6666;
    UIButton *buttons = [self.view viewWithTag:tag+5555];
    UIButton *buttonOther;
    for (int i = 0; i <_itemInTheVC.babysCount; i++) {
        if (tag == i) {
            [buttons setBackgroundImage:[UIImage imageNamed:@"btn_select_pay"] forState:UIControlStateNormal];
        }else{
            buttonOther = [self.view viewWithTag:i+5555];
            [buttonOther setBackgroundImage:[UIImage imageNamed:@"btn_unselect_pay"] forState:UIControlStateNormal];
        }
    }
    _selectBabyId = [NSString stringWithFormat:@"%@",_babyIdArray[tag]];
}
-(void)cancleBtn{
    _selectBabyId = NULL;
    [_backView removeFromSuperview];
}
-(void)sureBtton{
    if (_selectBabyId) {
        [_backView removeFromSuperview];
        NSMutableArray *array = [NSMutableArray array];
        for (PostBarDetailNewUserItem *item in _selectItemsArray) {
            NSString *imgId = item.imgid;
            [array addObject:imgId];
        }
        if (_isAll == YES) {
            [array removeAllObjects];
        }
        NSString *imgString = [array componentsJoinedByString:@","];
        if (_isClick == NO) {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",_selectBabyId,@"baby_id",self.nodeID,@"album_id",imgString,@"img_id", nil];
            
            _isClick = YES;
            [[HTTPClient sharedClient]getNew:kBabysIdolCombine params:params success:^(NSDictionary *result) {
                if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                    
                    [BBSAlert showAlertWithContent:@"同步成功" andDelegate:nil];
                    [self back];
                }else{
                    _isClick = NO;
                    [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
                }
            } failed:^(NSError *error) {
                _isClick = NO;
                [BBSAlert showAlertWithContent:@"网络问题，请稍后重试"andDelegate:nil];
            }];
        }
        
        
 
    }else{
        [BBSAlert showAlertWithContent:@"请选择小孩" andDelegate:nil];
    }
}
#pragma mark
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark HUD

-(void)showHUDWithMessage:(NSString *)message{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60,64+20+50+50+50+5 , 200, 30)];
    label.backgroundColor = [UIColor darkGrayColor];
    label.layer.cornerRadius = 3.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:13];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
