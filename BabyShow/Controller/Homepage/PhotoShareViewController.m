//
//  PhotoShareViewController.m
//  BabyShow
//
//  Created by Lau on 14-2-11.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PhotoShareViewController.h"
#import "UIImageView+WebCache.h"
#import "MyHomeNewVersionVC.h"

@interface PhotoShareViewController ()

//不让TA看YES,不看TA的NO
@property (nonatomic ,assign) BOOL denyOther;

@end

@implementation PhotoShareViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        dataArray=[[NSMutableArray alloc]init];

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_GET_SHARE_LIST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_GET_SHARE_LIST_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netError) name:USER_NET_ERROR object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelShareSucceed:) name:USER_CANCEL_SHARE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelShareFail:) name:USER_CANCEL_SHARE_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(agreeShareSucceed) name:USER_AGREE_SHARE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(agreeShareFail:) name:USER_AGREE_SHARE_FAIL object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    
   
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
    self.title = @"共享人";
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-20) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    _anouceLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-20, SCREENWIDTH, 20)];
    _anouceLabel.textAlignment=NSTextAlignmentCenter;
    _anouceLabel.lineBreakMode=NSLineBreakByCharWrapping;
    _anouceLabel.numberOfLines=0;

    _anouceLabel.text=@"共享的相册直接展现在对方的相册列表,并可下载高清相片";//@"我共享的：TA的相册显示在我的相册中；我可下载共享相册里的高清相片。\n共享我的：我的相册显示在在TA的相册中；TA可以下载共享相册里的高清相片。";
    //共享的相册直接展现在对方的相册列表,并可下载高清相片
    _anouceLabel.font=[UIFont systemFontOfSize:12];
    _anouceLabel.textColor=[UIColor grayColor];
    [self.view addSubview:_anouceLabel];
    
    self.page = 1;
    [self getData];
    
}
- (void)addEmptyHintView {
    
    if (_emptyView) {
        return;
    }
    _emptyView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _emptyView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    
    UIImage *image=[UIImage imageNamed:@"img_myshow_empty_babyface"];
    UIImageView *imgView=[[UIImageView alloc]initWithImage:image];
    imgView.frame=CGRectMake(96.5, 100, 127, 127);
    [_emptyView addSubview:imgView];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(50, 240, 220, 30)];
    label.font=[UIFont systemFontOfSize:17];
    label.textAlignment=NSTextAlignmentCenter;
    label.textColor = [BBSColor hexStringToColor:@"c3ad8f"];
    if ([LOGIN_USER_ID integerValue]!=[self.userId integerValue]) {
        label.text=@"TA还没有共享人哦";
    } else {
        label.text = @"你还没有共享人哦";
    }
    
    [_emptyView addSubview:label];
    
    [self.view addSubview:_emptyView];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark private

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getData{
    
    if (!_isGetMore) {
        
        [dataArray removeAllObjects];
    }
    
    [LoadingView startOnTheViewController:self];

    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:self.userId,@"user_id",
                         [NSString stringWithFormat:@"%d",self.page],@"page",@"16",@"page_size",nil];
    
    NetAccess *net=[NetAccess sharedNetAccess];
    [net getDataWithStyle:NetStyleShareList andParam:param];
    
}

-(void)getMore{
    
    _isGetMore=1;
    [self getData];
    
}

#pragma mark UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [dataArray count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *returnCell;
    
    id obj=[dataArray objectAtIndex:indexPath.row];
    
    if ([obj isKindOfClass:[NSString class] ]) {
        
        MoreBtnCell *cell=[[MoreBtnCell alloc]init];
        [cell.btn setTitle:obj forState:UIControlStateNormal];
        [cell.btn addTarget:self action:@selector(getMore) forControlEvents:UIControlEventTouchUpInside];
        returnCell=cell;
        
    }else{
        
        static NSString *identify=@"MYSHARE";

        MHPMyCareCell *cell=[tableView dequeueReusableCellWithIdentifier:identify];

        if (!cell) {
            
            cell=[[MHPMyCareCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
            
        }
    
        ShareItem *item=[dataArray objectAtIndex:indexPath.row];

        cell.nameLabel.text=item.nickName;
        
        if ([LOGIN_USER_ID integerValue]==[self.userId integerValue]) {
            cell.Btn.hidden=NO;
        }else{
            cell.Btn.hidden=YES;
        }
    
        if ([item.isShare integerValue] == 1) {
            [cell.Btn setTitle:@"我共享的" forState:UIControlStateNormal];
            [cell.Btn setBackgroundColor:[BBSColor hexStringToColor:BACKCOLOR]];

        }else if ([item.isShare integerValue]==2){
            [cell.Btn setTitle:@"互相共享" forState:UIControlStateNormal];
            [cell.Btn setBackgroundColor:[UIColor lightGrayColor]];

        } else {
            [cell.Btn setTitle:@"共享我的" forState:UIControlStateNormal];
            [cell.Btn setBackgroundColor:[BBSColor hexStringToColor:BACKCOLOR]];
        }
    
        [cell.avatarView sd_setImageWithURL:[NSURL URLWithString:item.avatar]];
        cell.delegate=self;
        cell.avatarBtn.tag=indexPath.row;
        cell.Btn.tag=indexPath.row;
        returnCell=cell;
        
    }
    
    returnCell.selectionStyle=UITableViewCellSelectionStyleNone;
    returnCell.contentView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    return returnCell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ShareItem *item=[dataArray objectAtIndex:indexPath.row];
    
    MyHomeNewVersionVC *homePage=[[MyHomeNewVersionVC alloc]init];
    homePage.userid=[NSString stringWithFormat:@"%@",item.userId];
    
    if ([LOGIN_USER_ID integerValue]==[item.userId integerValue]) {
        homePage.Type=0;
    }else{
        homePage.Type=1;
    }
    
    [self.navigationController pushViewController:homePage animated:YES];

    
}

#pragma mark NSNotification

-(void)agreeShareSucceed{
    
    [LoadingView stopOnTheViewController:self];
    self.page = 1;
    [self getData];
    
}

-(void)agreeShareFail:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}

-(void)cancelShareSucceed:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];
    self.page = 1;
    [self getData];
    
}

-(void)cancelShareFail:(NSNotification *)not{
    
    [LoadingView stopOnTheViewController:self];
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];

}

-(void)getDataSucceed:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *styleString = not.object;
    NetAccess *net = [NetAccess sharedNetAccess];
    NSArray *returnArray = [net getReturnDataWithNetStyle:[styleString intValue]];
    
    if ([[dataArray lastObject] isKindOfClass:[NSString class]]) {
        
        [dataArray removeLastObject];
        
    }
    
    [dataArray addObjectsFromArray:returnArray];
    
    if (returnArray.count) {
        _page ++;
    }
    if (returnArray.count == 15) {
        
        [dataArray addObject:@"加载更多"];

    }
    if (dataArray.count == 0) {
        [self addEmptyHintView];
    } else {
        if (_emptyView) {
            [_emptyView removeFromSuperview];
            _emptyView = nil;
        }
        
        if (_tableView) {
            [_tableView reloadData];
        }
    }
    [_tableView reloadData];
    
}

-(void)getDataFail:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];
    
    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:self];

}

-(void)netError{
    
    [LoadingView stopOnTheViewController:self];
    
    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:self];

}

#pragma mark MHPMyCareCellDelegate

-(void)ClickOnTheAvatar:(UIButton *)avatar{
    
    
}

-(void)addToBeMyFocus:(UIButton *)btn{
    
    UIActionSheet *acs;
    
    ShareItem *item=[dataArray objectAtIndex:btn.tag];
    if (item.isShare.intValue == 0) {
        //共享我的
        acs=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"不让TA看了",nil];

    } else if (item.isShare.intValue == 1) {
        //我共享的
        acs=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"不看TA的了",nil];

    } else {
        //相互共享
        acs=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"不看TA的了",@"不让TA看了",nil];

    }
    
    acs.tag=btn.tag;
    [acs showFromTabBar:self.tabBarController.tabBar];
    
}

#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    ShareItem *item = [dataArray objectAtIndex:actionSheet.tag];
    if (buttonIndex==0) {
        
        UIAlertView *alerView;
        
        if (item.isShare.intValue == 0) {
            _denyOther = YES;
            alerView=[[UIAlertView alloc]initWithTitle:nil message:@"在TA的共享相册里将不会显示你的相册了哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"取消共享", nil];
        }else{//1,2
            _denyOther = NO;
            alerView=[[UIAlertView alloc]initWithTitle:nil message:@"在你的共享相册里将不会显示TA的相册了哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"取消共享", nil];
        }
        
        alerView.tag=actionSheet.tag;
        [alerView show];
        
    } else if (buttonIndex == 1) {
        if (item.isShare.intValue == 2) {
            _denyOther = NO;
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"在TA的共享相册里将不会显示你的相册了哦" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"取消共享", nil];
            alertView.tag=actionSheet.tag;
            [alertView show];
        }
    }
        
    
}

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    ShareItem *item = [dataArray objectAtIndex:alertView.tag];
    if (buttonIndex == 1) {
        
        if (_denyOther == NO) {
            //不看他的了
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"user_id",
                                 item.userId,@"share_id", nil];
            NetAccess *net = [NetAccess sharedNetAccess];
            [net getDataWithStyle:NetStyleCancelShare andParam:param];
            [LoadingView startOnTheViewController:self];
            
        }else{
            //不让他看了
            NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"user_id",item.userId,@"share_id",@"1",@"share_type",@"0",@"is_agree", nil];
            
            NetAccess *net=[NetAccess sharedNetAccess];
            [net getDataWithStyle:NetStyleAgreeShare andParam:param];
            [LoadingView startOnTheViewController:self];
            
        }
        
    }
    
}


@end
