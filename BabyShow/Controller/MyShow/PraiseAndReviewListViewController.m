//
//  PraiseAndReviewListViewController.m
//  BabyShow
//
//  Created by Lau on 13-12-18.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PraiseAndReviewListViewController.h"
#import "UIImageView+WebCache.h"
#import "BBSEmojiInfo.h"
#import "InputToolBarUtility.h"
#import "SVPullToRefresh.h"
#import "MyHomeNewVersionVC.h"

@interface PraiseAndReviewListViewController ()

@property (nonatomic ,assign)BOOL isFinished;
@property (nonatomic ,assign)NSInteger deleteIndex;
@property(nonatomic,strong)NSString *postCreateTime;

@end

@implementation PraiseAndReviewListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _dataArray=[[NSMutableArray alloc]init];
        self.lastId=[[NSNumber alloc]init];
        _userDic=[[NSMutableDictionary alloc]init];
        _isFinished = NO;
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
 
    if (self.type==MyShowReviewList || self.type==MyShowAddReview) {
        
        self.title=@"评论";

    }else{
        
        self.title=@"赞";

    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)  name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewSucceed) name:USER_REVIEW_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reviewFail:) name:USER_REVIEW_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getReviewListSucceed:) name:USER_GET_REVIEW_LIST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getReviewListFail:) name:USER_GET_REVIEW_LIST_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPraiseListSucceed:) name:USER_GET_PRAISE_LIST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getPraiseListFail:) name:USER_GET_PRAISE_LIST_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteReviewSucceed:) name:USER_DELETE_REVIEW_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteReviewFail:) name:USER_DELETE_REVIEW_FAIL object:nil];
    self.navigationController.navigationBarHidden=NO;
   
}

-(void)getData{
    
    netAccess = [NetAccess sharedNetAccess];
    NSDictionary *param;
    
    if (self.isDiary == YES) {
        param = [NSDictionary dictionaryWithObjectsAndKeys:
               @"1",@"isdiary",self.imgID,kReviewListImgId,self.lastId,kReviewListLastId, nil];
    } else if (self.isPost == YES) {
        param = [NSDictionary dictionaryWithObjectsAndKeys:
               @"1",@"ispost",LOGIN_USER_ID,@"login_user_id",self.reviewId,@"review_id",self.postCreateTime,@"post_create_time",nil];
    }else{
        param = [NSDictionary dictionaryWithObjectsAndKeys:
               self.imgID,kReviewListImgId,self.lastId,kReviewListLastId, nil];
    }
    
    if (self.isWorthBuy == YES) {

        [netAccess getDataWithStyle:NetStylePostBarWorthBuyReviewList andParam:param];
    
    }else{
        
        if (self.type == MyShowReviewList || self.type == MyShowAddReview) {
            
            [netAccess getDataWithStyle:NetStyleReviewList andParam:param];
            [LoadingView startOnTheViewController:self];
            
        }else{
            
            [netAccess getDataWithStyle:NetStylePraiseList andParam:param];
            [LoadingView startOnTheViewController:self];
            
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    
    facesArray = [[NSArray alloc]initWithArray:[Emoji allEmoji]];
    facesDictionary = [[NSDictionary alloc]initWithDictionary:[Emoji allEmojiDictionary]];
    numArray = [[NSMutableArray alloc]init];

    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
    CGRect tableviewFrame=CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT);
    
    _tableview=[[UITableView alloc]initWithFrame:tableviewFrame style:UITableViewStylePlain];
    _tableview.delegate=self;
    _tableview.dataSource=self;
    _tableview.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    _tableview.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableview];
    
    if (self.type==MyShowAddReview || self.type==MyShowReviewList) {
        
        CGRect reviewFieldFrame;
        
        _tableview.frame=CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT-toolBarHeight);
        reviewFieldFrame=CGRectMake(0, VIEWHEIGHT-toolBarHeight, VIEWWIDTH, toolBarHeight);
        //表情键盘
        self.toolBar = [[InputToolBarUtility alloc]initWithFrame:reviewFieldFrame superViewController:self];
        self.toolBar.backgroundColor =[BBSColor hexStringToColor:@"f1f1f1"];
        self.clickDelegate = self.toolBar;
        [self.view addSubview:self.toolBar];
        
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchOnTheView)];
        tap.delegate=self;
        [self.view addGestureRecognizer:tap];
        
        _isEmptyViewExist=0;
        _emptyView=[[UIView alloc]initWithFrame:self.view.frame];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, 40)];
        label.text=@"暂时还没有人评论哦";
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:14];
        [_emptyView addSubview:label];
        
    }else{
        
        _isEmptyViewExist=0;
        _emptyView=[[UIView alloc]initWithFrame:self.view.frame];
        UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, 40)];
        label.text=@"暂时还没有人赞哦";
        label.textAlignment=NSTextAlignmentCenter;
        label.font=[UIFont systemFontOfSize:14];
        [_emptyView addSubview:label];
        
    }
    __block PraiseAndReviewListViewController *blockSelf = self;
    [_tableview addInfiniteScrollingWithActionHandler:^{
        
        if (!blockSelf.isFinished) {
            [blockSelf getData];
        }else{
            if (blockSelf.tableview.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
                [blockSelf.tableview.infiniteScrollingView stopAnimating];
            }
        }
    }];
    
    self.lastId=NULL;
    self.postCreateTime = NULL;
    [self getData];
}

-(void)sendText:(NSString *)text{

    NSString *userid=LOGIN_USER_ID;
    NSLog(@"texttext = %@",text);
    NSMutableDictionary *param ;
    if (self.isPost == YES) {
        param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                 LOGIN_USER_ID,@"login_user_id",
                 text,kReviewDemand,
                 self.reviewId,@"review_id",nil];

        [param setObject:@"1" forKey:@"ispost"];
    }
    if (self.isDiary == YES) {
        param = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                 LOGIN_USER_ID,@"login_user_id",
                 text,kReviewDemand,
                 self.imgID,kReviewImgId,
                 self.ownerId,kReviewOwnerId,
                 _selectedReviewItem.userid,kReviewAtId,nil];
        [param setObject:@"1" forKey:@"isdiary"];


    }
    netAccess=[NetAccess sharedNetAccess];
    
    if (self.isWorthBuy==YES) {
        [netAccess getDataWithStyle:NetStylePostBarWorthBuyReview andParam:param];
    }else{
        [netAccess getDataWithStyle:NetStyleReview andParam:param];
    }

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark NSNotification

-(void)deleteReviewSucceed:(NSNotification *)not{
    
    [LoadingView stopOnTheViewController:self];
    
    [_dataArray removeObjectAtIndex:_deleteIndex];
    
    [_tableview beginUpdates];
    [_tableview deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_deleteIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [_tableview endUpdates];
    
    if (_dataArray.count == 0) {
        [_tableview addSubview:_emptyView];
        _isEmptyViewExist=1;
    }
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];

    if (self.isWorthBuy==YES) {
        delegate.worthbuyHasNewReview=YES;
    }else if (self.isPost==YES) {
        delegate.postbarHasNewReview=YES;
    }else if (self.isDiary==YES) {
        //无
    }else{
        delegate.hasNewReview=YES;
    }
}

-(void)deleteReviewFail:(NSNotification *) not{
    
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    
}

-(void)netFail{
    
    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    
    if (_tableview.pullToRefreshView && _tableview.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableview.pullToRefreshView stopAnimating];
    }
    if (_tableview.infiniteScrollingView && _tableview.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableview.infiniteScrollingView stopAnimating];
    }
}

-(void)reviewSucceed{
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (self.isWorthBuy==YES) {
        delegate.worthbuyHasNewReview=YES;
    }else if (self.isPost==YES) {
        delegate.postbarHasNewReview=YES;
    }else if (self.isDiary==YES) {
        //
    }else {
        delegate.hasNewReview=YES;
    }
    
    self.lastId=NULL;
    self.postCreateTime = NULL;
    [_dataArray removeAllObjects];
    [self getData];
    
}

-(void)reviewFail:(NSNotification *)not{
    
    [LoadingView stopOnTheViewController:self];
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}

-(void)getReviewListSucceed:(NSNotification *) note{
    
    NSNumber *styleNumber=note.object;
    int styleInt=[styleNumber intValue];
    
    NSArray *dataArray=[netAccess getReturnDataWithNetStyle:styleInt];
    
    if (!dataArray.count) {
        _isFinished = YES;
    }
    
    [_dataArray addObjectsFromArray:dataArray];
    
    if (!_dataArray.count) {
        [_tableview addSubview:_emptyView];
        _isEmptyViewExist=1;
    }else{
        if (_isEmptyViewExist) {
            [_emptyView removeFromSuperview];
        }
    }

    MyShowReviewItem *item=[dataArray lastObject];
    self.postCreateTime=item.postCreatTime;
    self.lastId = item.reviewId;
    
    [_tableview reloadData];
    [LoadingView stopOnTheViewController:self];
    
    if (_tableview.pullToRefreshView && _tableview.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableview.pullToRefreshView stopAnimating];
    }
    if (_tableview.infiniteScrollingView && _tableview.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableview.infiniteScrollingView stopAnimating];
    }
}

-(void)getReviewListFail:(NSNotification *)not{
    
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
    [LoadingView stopOnTheViewController:self];
    if (_tableview.pullToRefreshView && _tableview.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableview.pullToRefreshView stopAnimating];
    }
    if (_tableview.infiniteScrollingView && _tableview.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableview.infiniteScrollingView stopAnimating];
    }
}


-(void)getPraiseListSucceed:(NSNotification *) note{
    
    NSString *styleString=note.object;
    
    NSArray *dataArray=[netAccess getReturnDataWithNetStyle:[styleString intValue]];
    
    if (!dataArray.count) {
        _isFinished = YES;
    }
    
    [_dataArray addObjectsFromArray:dataArray];
    
    if (!_dataArray.count) {
        
        [_tableview addSubview:_emptyView];
        _isEmptyViewExist=1;
        
    }else{
        
        if (_isEmptyViewExist) {
            [_emptyView removeFromSuperview];
        }
    }
    
    MyShowPraiseItem *item=[dataArray lastObject];
    self.lastId=item.praiseId;
    
    [_tableview reloadData];
    [LoadingView stopOnTheViewController:self];
    if (_tableview.pullToRefreshView && _tableview.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableview.pullToRefreshView stopAnimating];
    }
    if (_tableview.infiniteScrollingView && _tableview.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableview.infiniteScrollingView stopAnimating];
    }
}

-(void)getPraiseListFail:(NSNotification *) not{
    
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    
    if (_tableview.pullToRefreshView && _tableview.pullToRefreshView.state==SVPullToRefreshStateLoading) {
        [_tableview.pullToRefreshView stopAnimating];
    }
    if (_tableview.infiniteScrollingView && _tableview.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableview.infiniteScrollingView stopAnimating];
    }
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [_userDic removeAllObjects];
    
    id obj=[_dataArray objectAtIndex:indexPath.row];
    
    if ([obj isKindOfClass:[MyShowReviewItem class]]) {
    
        [_userDic removeAllObjects];
        
        id obj=[_dataArray objectAtIndex:indexPath.row];
        
        if ([obj isKindOfClass:[MyShowReviewItem class]]) {
            
            _selectedReviewItem=[_dataArray objectAtIndex:indexPath.row];
            
           MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
            
            NSString *loginUserId=LOGIN_USER_ID;
            
            if (self.type==MyShowPraiseList) {
                
                myHomePage.userid=[NSString stringWithFormat:@"%@",_selectedPraiseItem.userid];
                
                if ([loginUserId integerValue]==[_selectedPraiseItem.userid integerValue]) {
                    myHomePage.Type=0;
                }else{
                    myHomePage.Type=1;
                }
            }else{
                
                myHomePage.userid=[NSString stringWithFormat:@"%@",_selectedReviewItem.userid];
                
                if ([loginUserId integerValue]==[_selectedReviewItem.userid integerValue]) {
                    myHomePage.Type=0;
                }else{
                    myHomePage.Type=1;
                }
            }
            
            [self.navigationController pushViewController:myHomePage animated:YES];
        }
        
    }else if([obj isKindOfClass:[MyShowPraiseItem class]]){
        
        _selectedPraiseItem=[_dataArray objectAtIndex:indexPath.row];
        MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
        
        NSString *loginUserId=LOGIN_USER_ID;
        
        if (self.type==MyShowPraiseList) {
            
            myHomePage.userid=[NSString stringWithFormat:@"%@",_selectedPraiseItem.userid];
            
            if ([loginUserId integerValue]==[_selectedPraiseItem.userid integerValue]) {
                
                myHomePage.Type=0;
                
            }else{
                
                myHomePage.Type=1;
                
            }
        }else{
            
            myHomePage.userid=[NSString stringWithFormat:@"%@",_selectedReviewItem.userid];
            
            if ([loginUserId integerValue]==[_selectedReviewItem.userid integerValue]) {
                
                myHomePage.Type=0;
                
            }else{
                
                myHomePage.Type=1;
                
            }
            
        }
        
        [self.navigationController pushViewController:myHomePage animated:YES];
        
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArray count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *MYSHOWPRAISELIST=@"MYSHOWPRAISELIST";
    static NSString *MYSHOWREVIEWLIST=@"MYSHOWREVIEWLIST";
    
    UITableViewCell *cell;
    
    if (self.type==MyShowPraiseList) {
        
        PraiseListCell *praisecell=[tableView dequeueReusableCellWithIdentifier:MYSHOWPRAISELIST];
        
        if (!praisecell) {
            
            praisecell=[[PraiseListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MYSHOWPRAISELIST];
            
        }
        
        MyShowPraiseItem *item=[_dataArray objectAtIndex:indexPath.row];
        praisecell.nameLabel.text=item.authorname;
        praisecell.timeLabel.text=item.time;
        [praisecell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:item.avatarStr]];
        
        cell=praisecell;
      
    }else if(self.type==MyShowReviewList || self.type==MyShowAddReview){
        
        ReviewListCell * reviewcell=[[ReviewListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MYSHOWREVIEWLIST];

        MyShowReviewItem *item=[_dataArray objectAtIndex:indexPath.row];
        reviewcell.contentLabel.frame=CGRectMake(40, 30, 270, item.height+10);
        reviewcell.nameLabel.text=item.username;
        reviewcell.timeLabel.text=item.time;
        NSDictionary *dictionary = [BBSEmojiInfo detailContentWithStringAndEmoji:item.content fromArray:facesArray];
        NSString *content = [dictionary objectForKey:@"content"];
        NSArray *tNumArray = [dictionary objectForKey:@"emoji"];
    
        reviewcell.contentLabel.text=content;
        for (NSInteger i = tNumArray.count-1; i >= 0; i--) {
            NSDictionary *dict = [tNumArray objectAtIndex:i];
            int numid = [[dict objectForKey:@"location"] intValue];
            NSString * emojiText = [dict objectForKey:@"emojiText"];
            UIImage *image = [UIImage imageNamed:[facesDictionary objectForKey:emojiText]];
            [reviewcell.contentLabel insertImage:image atIndex:(numid-i*4) margins:UIEdgeInsetsMake(-1, 0, -3, 0)];
            
        }
        
        if (item.height>30) {
            reviewcell.seperateView.frame=CGRectMake(0, 40+item.height+10-0.5, 320, 0.5);
        }
        if (self.isPost == YES) {
            
        }else{
        reviewcell.delegate=self;
        }
        reviewcell.avatarBtn.tag=indexPath.row;
        if (item.avatarStr.length>0) {
            [reviewcell.avatarImageView sd_setImageWithURL:[NSURL URLWithString:item.avatarStr]];
        }
        [reviewcell.btn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        reviewcell.btn.tag=indexPath.row;
        cell=reviewcell;
        
    }
    cell.contentView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    cell.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    id obj=[_dataArray objectAtIndex:indexPath.row];

    if ([obj isKindOfClass:[MyShowPraiseItem class]]) {
        return 60;
    }else if ([obj isKindOfClass:[MyShowReviewItem class]]){
        MyShowReviewItem *item=[_dataArray objectAtIndex:indexPath.row];
        NSLog(@"iteitiriifii = %f",item.height);
        if (item.height>30) {
            return item.height+50;
            
        }else{
            return 60;
        }
    }
    
    return 60;
    
}
#pragma mark ReviewCellDelegate

-(void)cellOnLongPress:(UITableViewCell *) cell{
    
    NSIndexPath *indexPath = [_tableview indexPathForCell:cell];
    MyShowReviewItem *item=[_dataArray objectAtIndex:indexPath.row];
    NSArray *userArray = [BABYSHOWSUPERGRANTUSER componentsSeparatedByString:@","];
    
    BOOL isSuperGrant = NO;
    for (int i = 0 ; i < userArray.count; i++) {
        NSString *user = [userArray objectAtIndex:i];
        if ([LOGIN_USER_ID integerValue] == [user integerValue] )  {
            isSuperGrant = YES;
            break;
        }
    }
    
    if ([item.userid integerValue]==[LOGIN_USER_ID integerValue]||isSuperGrant) {
        UIActionSheet *acs=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
        NSIndexPath *indexPath=[_tableview indexPathForCell:cell];
        
        acs.tag=indexPath.row;
        [acs showFromTabBar:self.tabBarController.tabBar];
        
    }
}

-(void)avatarOnClick:(UIButton *)Button{
    
    [_userDic removeAllObjects];
    
    id obj=[_dataArray objectAtIndex:Button.tag];
    
    if ([obj isKindOfClass:[MyShowReviewItem class]]) {
        
        _selectedReviewItem=[_dataArray objectAtIndex:Button.tag];
        
        MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
        
        NSString *loginUserId=LOGIN_USER_ID;
        
        if (self.type==MyShowPraiseList) {
            
            myHomePage.userid=[NSString stringWithFormat:@"%@",_selectedPraiseItem.userid];
            
            if ([loginUserId integerValue]==[_selectedPraiseItem.userid integerValue]) {
                
                myHomePage.Type=0;
                
            }else{
                
                myHomePage.Type=1;
                
            }
            
        }else{
            
            myHomePage.userid=[NSString stringWithFormat:@"%@",_selectedReviewItem.userid];
            
            if ([loginUserId integerValue]==[_selectedReviewItem.userid integerValue]) {
                
                myHomePage.Type=0;
                
            }else{
                
                myHomePage.Type=1;
                
            }
            
        }
        
        [self.navigationController pushViewController:myHomePage animated:YES];
        
    }
    
}

-(void)OnClick:(UIButton *) btn{
    
    id obj=[_dataArray objectAtIndex:btn.tag];
    
    if ([obj isKindOfClass:[MyShowReviewItem class]]) {
        
        _selectedReviewItem=[_dataArray objectAtIndex:btn.tag];
        
    }
    
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"to_other",_selectedReviewItem.username,@"user_name", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:CHANGE_STATE_NOTI object:nil userInfo:dictionary];
}

#pragma mark NSNotice

-(void)keyboardWillShow:(NSNotification *) not{
    
    NSDictionary *info = [not userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;

    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7){
        
        _tableview.frame=CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT-kbSize.height-toolBarHeight);
        _addReviewView.frame=CGRectMake(0, VIEWHEIGHT-toolBarHeight-kbSize.height, VIEWWIDTH, 40);
        
    }else{
        
        _tableview.frame=CGRectMake(0, 0, VIEWWIDTH, SCREENHEIGHT-kbSize.height-toolBarHeight-44-20);
        _addReviewView.frame=CGRectMake(0, SCREENHEIGHT-kbSize.height-toolBarHeight-44-20, VIEWWIDTH, 40);
        
    }
}

#pragma mark pravite

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)touchOnTheView{
   
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"to_other",@"0",@"user_name", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:CHANGE_STATE_NOTI object:nil userInfo:dictionary];
    if ([self.clickDelegate respondsToSelector:@selector(clickToResignFirstResponder)]) {
        [self.clickDelegate clickToResignFirstResponder];
    }
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7){
        
        _tableview.frame=CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT-toolBarHeight);
        
    }else{
        _tableview.frame=CGRectMake(0, 0, VIEWWIDTH, SCREENHEIGHT-toolBarHeight-44-20);
        
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField.text.length>=140) {
        return NO;
    }
    return YES;
}

#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0){
        //删除
        _deleteIndex = actionSheet.tag;
        MyShowReviewItem *reviewItem=[_dataArray objectAtIndex:actionSheet.tag];
        
        NSDictionary *param;
        //值得买删除
        if (self.isWorthBuy==YES) {
            
            param=[NSDictionary dictionaryWithObjectsAndKeys:reviewItem.reviewId,@"review_id",
                   reviewItem.userid,@"user_id", nil];
            
            [[NetAccess sharedNetAccess] getDataWithStyle:NetStyleWorthBuyDelReview andParam:param];
            
            [LoadingView startOnTheViewController:self];

        }else{
            
            if (self.isPost==YES) {
                //话题删除
                param=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"ispost",reviewItem.reviewId,@"review_id",
                       reviewItem.userid,@"user_id", nil];
                
            }else if (self.isDiary == YES){
                //成长日记删除
                param=[NSDictionary dictionaryWithObjectsAndKeys:@"1",@"isdiary",reviewItem.reviewId,@"review_id",
                       reviewItem.userid,@"user_id", nil];
            } else {
                //秀秀删除
                param=[NSDictionary dictionaryWithObjectsAndKeys:reviewItem.reviewId,@"review_id",
                       reviewItem.userid,@"user_id", nil];
            }
            
            [[NetAccess sharedNetAccess] getDataWithStyle:NetStyleDelReview andParam:param];
            
            [LoadingView startOnTheViewController:self];

        }
        
    }

}

@end
