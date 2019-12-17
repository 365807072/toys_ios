//
//  MessageListViewController.m
//  BabyShow
//
//  Created by Lau on 14-1-13.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MessageListViewController.h"

#import "SDWebImageManager.h"
#import "SVPullToRefresh.h"
//#import "PostBarNewDetailVC.h"
#import "PostBarNewDetialV1VC.h"

#import "UserInfoItem.h"
#import "MyHomeNewVersionVC.h"

@interface MessageListViewController ()

@property (nonatomic ,assign)NSInteger selectedIndex;
@property (nonatomic ,assign)BOOL isFinished;
@property (nonatomic ,strong)UITableView *tableView;


@end

@implementation MessageListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        dataArray=[[NSMutableArray alloc]init];
        self.lastId=[[NSNumber alloc]init];

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessListSucceed:) name:USER_GET_MESSLIST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessListFail:) name:USER_GET_MESSLIST_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusSucceed) name:USER_FOCUS_ON_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(focusFail:) name:USER_FOCUS_ON_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFocusSucceed) name:USER_CANCEL_FOCUS_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelFocusFail:) name:USER_CANCEL_FOCUS_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(agreeShareSucceed) name:USER_AGREE_SHARE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(agreeShareFail:) name:USER_AGREE_SHARE_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail:) name:USER_NET_ERROR object:nil];
    
}

-(void)getData{
    NSString *loginUserId=LOGIN_USER_ID;
    
    if (self.Type==0) {
        //消息
        
        NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"user_id",@"1",@"msg_type",self.lastId,@"last_id", nil];
        NetAccess *net=[NetAccess sharedNetAccess];
        [net getDataWithStyle:NetStyleGetMessRequestList andParam:param];
        
    }else if(self.Type==1){
        //动态
        
        NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"user_id",@"2",@"msg_type",self.lastId,@"last_id", nil];
        NetAccess *net=[NetAccess sharedNetAccess];
        [net getDataWithStyle:NetStyleGetMessList andParam:param];
        
    }
    
    [LoadingView startOnTheViewController:self];
    titleBtn.enabled = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
     NSLog( @"第二个页面扩大附近垃圾发电量空间按领导说MyMessageListVC.h");
    
    self.view.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    
    titleBtn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 105, 27)];
    [titleBtn setBackgroundImage:[UIImage imageNamed:@"btn_messagelist_request_new1.png"] forState:UIControlStateNormal];
    [titleBtn addTarget:self action:@selector(changeList) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView=titleBtn;
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    __block MessageListViewController *blockSelf = self;
    
    [_tableView addInfiniteScrollingWithActionHandler:^{
        if (!blockSelf.isFinished) {
            [blockSelf getData];
        }else{
            if (blockSelf.tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
                [blockSelf.tableView.infiniteScrollingView stopAnimating];
            }
        }
    }];
    
    self.lastId=NULL;
    [self getData];
}
- (void)addEmptyHintView {
   
    if (_emptyView){
        return;
    }
    _emptyView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _emptyView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(10, 74, 300, 30)];
    label.text=@"暂时还没有消息哦";
    label.font=[UIFont systemFontOfSize:14];
    label.textAlignment=NSTextAlignmentCenter;
    [_emptyView addSubview:label];
    [self.view addSubview:_emptyView];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    
}

#pragma mark UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [dataArray count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.Type==0){
        
        return 85;
        
    }
    return 80;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *returnCell;
    
    if (self.Type==1) {
        //动态
        
        MessageCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MESSAGEDT"];
        
        if (!cell) {
            
            cell=[[MessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MESSAGEDT"];
            
        }else{
            
            [cell.photoBtn setBackgroundImage:[UIImage imageNamed:@"img_message_photo.png"] forState:UIControlStateNormal];;

        }
        
        cell.delegate=self;
        cell.avatarBtn.tag=indexPath.row;
        cell.photoBtn.tag=indexPath.row;
        cell.photoBtn.hidden=YES;
        cell.isReadView.hidden=YES;
        
        MessageItem *item=[dataArray objectAtIndex:indexPath.row];
        cell.nameLabel.text=item.nickName;
        cell.messLabel.text=item.message;
        cell.timeLabel.text=[NSString stringWithFormat:@"%@",item.time];
        cell.avatarView.image=[UIImage imageNamed:@"img_message_avatar_100.png"];
        if ([item.isRead integerValue]==0) {
            cell.isReadView.hidden=NO;
        }else{
            cell.isReadView.hidden=YES;
        }
        
        //avatar:
        NSURL *avatarUrl=[NSURL URLWithString:item.avatarStr];
        SDWebImageManager *manager=[SDWebImageManager sharedManager];
//        [manager downloadWithURL:avatarUrl options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
//            
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//            cell.avatarView.image=image;
//        }];
        [manager downloadImageWithURL:avatarUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            cell.avatarView.image=image;
        }];
        
        //photoview;
        if ([item.target isEqualToString:@"1"] || [item.target isEqualToString:@"3"] ) {
            
            if (item.photoStr.length) {
                NSURL *photoUrl=[NSURL URLWithString:item.photoStr];
                SDWebImageManager *manager=[SDWebImageManager sharedManager];
//                [manager downloadWithURL:photoUrl options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
//                } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//                    [cell.photoBtn setBackgroundImage:image forState:UIControlStateNormal];
//                    cell.photoBtn.hidden=NO;
//                }];
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

        }else if ([item.target isEqualToString:@"2"]){
            cell.photoBtn.hidden=YES;//更新了共享相册,不显示图片
        }
        
        returnCell=cell;

    }else if(self.Type==0){
        //消息
        
        MessageListRequestCell *cell=[tableView dequeueReusableCellWithIdentifier:@"MESSAGEQQ"];
        
        if (!cell) {
            
            cell=[[MessageListRequestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MESSAGEQQ"];
            
        }
        
        cell.delegate=self;
        cell.avatarBtn.tag=indexPath.row;
        cell.isReadView.hidden=YES;
        
        MessageListRequestItem *item=[dataArray objectAtIndex:indexPath.row];
        
        cell.nameLabel.text=item.name;
        cell.messageLabel.text=item.message;
        
        if ([item.isRead integerValue]==0) {
            cell.isReadView.hidden=NO;
        }else{
            cell.isReadView.hidden=YES;
        }
        
        NSURL *avatarUrl=[NSURL URLWithString:item.avatarStr];
        SDWebImageManager *manager=[SDWebImageManager sharedManager];
//        [manager downloadWithURL:avatarUrl options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
//            
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//            cell.avatarView.image=image;
//        }];
        [manager downloadImageWithURL:avatarUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            cell.avatarView.image=image;
        }];
        
        [cell.Btn setBackgroundColor:[UIColor redColor]];
        cell.Btn.tag=indexPath.row;
        
        [cell.Btn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([item.msgType intValue]==6) {
            
            if ([item.isAgreed intValue]==0) {
                
                [cell.Btn setTitle:@"同意" forState:UIControlStateNormal];
                [cell.Btn setBackgroundColor:[BBSColor hexStringToColor:@"3daf2c"]];
                
            }else if([item.isAgreed intValue]==1){
                
                [cell.Btn setTitle:@"已同意" forState:UIControlStateNormal];
                [cell.Btn setBackgroundColor:[UIColor lightGrayColor]];

            }
            
        }else if ([item.msgType intValue]==4){
            
            if ([item.relation intValue]==0 || [item.relation intValue]==3) {
                
                [cell.Btn setTitle:@"添加关注" forState:UIControlStateNormal];
                [cell.Btn setBackgroundColor:[BBSColor hexStringToColor:BACKCOLOR]];

            }else if ([item.relation intValue]==2 ){
                
                [cell.Btn setTitle:@"相互关注" forState:UIControlStateNormal];
                [cell.Btn setBackgroundColor:[UIColor lightGrayColor]];

            }else if ([item.relation intValue]==1){
                
                [cell.Btn setTitle:@"已关注" forState:UIControlStateNormal];
                [cell.Btn setBackgroundColor:[UIColor lightGrayColor]];
                
            }
            
        }
            
        returnCell=cell;
        
    }
    
    returnCell.selectionStyle=UITableViewCellSelectionStyleNone;
    returnCell.contentView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    return returnCell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.Type==1) {
        //动态

        /**
         *  1是评论和赞跳转(包括话题赞评论)，2是共享相册跳转 3跟帖跳转
         */
        MessageItem *item=[dataArray objectAtIndex:indexPath.row];
        
        if ([item.target isEqualToString:@"1"]) {
            
            ImageDetailViewController *detail=[[ImageDetailViewController alloc]init];
            detail.imgID=[NSString stringWithFormat:@"%@",item.rootImgId];
            detail.userID=[NSString stringWithFormat:@"%@",item.userId];
            detail.isPost=item.isPost;
            detail.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:detail animated:YES];
            
        }else if ([item.target isEqualToString:@"2"]){
            
        }else if ([item.target isEqualToString:@"3"]){
            
            UserInfoManager *manager=[[UserInfoManager alloc]init];
            UserInfoItem *currentUser=[manager currentUserInfo];
            
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
        
    }else if(self.Type==0){
        //消息
        MessageListRequestItem *item=[dataArray objectAtIndex:indexPath.row];
        
        MyHomeNewVersionVC *homepage=[[MyHomeNewVersionVC alloc]init];
        homepage.userid=[NSString stringWithFormat:@"%@",item.userid];
        
        NSString *loginUserId=LOGIN_USER_ID;
        
        if ([loginUserId intValue]==[item.userid intValue]) {
            homepage.Type=0;
        }else{
            homepage.Type=1;
        }
        
        [self.navigationController pushViewController:homepage animated:YES];
    }
}


#pragma mark MessageListRequestDelegate

-(void)MessageListRequestCellClickOnAvatar:(UIButton *)btn{
    if(self.Type==0){
        //请求
        MessageListRequestItem *item=[dataArray objectAtIndex:btn.tag];
        
       MyHomeNewVersionVC *homepage=[[MyHomeNewVersionVC alloc]init];
        homepage.userid=[NSString stringWithFormat:@"%@",item.userid];
        
        NSString *loginUserId=LOGIN_USER_ID;
        
        if ([loginUserId intValue]==[item.userid intValue]) {
            homepage.Type=0;
        }else{
            homepage.Type=1;
        }
        
        [self.navigationController pushViewController:homepage animated:YES];
    }
}

#pragma mark MessageCellDelegate

-(void)ClickOnAvatar:(UIButton *)btn{
    if (self.Type==1) {
        //动态
        MessageItem *item=[dataArray objectAtIndex:btn.tag];
        
        MyHomeNewVersionVC *homepage=[[MyHomeNewVersionVC alloc]init];
        homepage.userid=[NSString stringWithFormat:@"%@",item.userId];
        

        NSString *loginUserId=LOGIN_USER_ID;
        
        if ([loginUserId intValue]==[item.userId intValue]) {
            homepage.Type=0;
        }else{
            homepage.Type=1;
        }
        
        [self.navigationController pushViewController:homepage animated:YES];
    }
}

-(void)ClickOnPhoto:(UIButton *)btn{
    
    /**
     *  1是评论和赞跳转(包括话题赞评论)，2是共享相册跳转 3跟帖跳转
     */
    MessageItem *item=[dataArray objectAtIndex:btn.tag];
    
    if ([item.target isEqualToString:@"1"]) {
        
        ImageDetailViewController *detail=[[ImageDetailViewController alloc]init];
        detail.imgID=[NSString stringWithFormat:@"%@",item.rootImgId];
        detail.userID=[NSString stringWithFormat:@"%@",item.userId];
        detail.isPost=item.isPost;
        detail.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:detail animated:YES];

    }else if ([item.target isEqualToString:@"2"]){
        
    }else if ([item.target isEqualToString:@"3"]){
        
        UserInfoManager *manager=[[UserInfoManager alloc]init];
        UserInfoItem *currentUser=[manager currentUserInfo];
        
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

#pragma mark 消息ButtonAction

-(void)btnOnClick:(UIButton *)btn{
    
    _selectedIndex = btn.tag;
    MessageListRequestItem *item=[dataArray objectAtIndex:btn.tag];
    
    if ([item.msgType intValue]==6) {
        
        if ([item.isAgreed intValue]==0) {
            
            [self requestShare:btn];
            
        }else if([item.isAgreed intValue]==1){
            
            [self requestCancelShare:btn];
            
        }
        
    }else if ([item.msgType intValue]==4){
        
        if ([item.relation intValue]==0 || [item.relation intValue]==3 ) {
            
            [self focusOn:btn];
            
        }else if ([item.relation intValue]==2 || [item.relation intValue]==1 ){
            
            [self cancelFocus:btn];
            
        }
        
    }
    
}

-(void)requestShare:(UIButton *)btn{
    
    actionType=REQUESTSHARE;
    
    UIActionSheet *acs=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:NULL otherButtonTitles:@"同意共享", nil];
    acs.tag=btn.tag;
    [acs showFromTabBar:self.tabBarController.tabBar];
    
}

-(void)requestCancelShare:(UIButton *)btn{
    
    actionType=CANCELSHARE;
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请注意" message:@"如果删除共享，对方将无法在相册共享组看到你的相册啦，确定删除吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alert.tag=btn.tag;
    [alert show];
    
}


-(void)focusOn:(UIButton *)btn{
    
    actionType=FOCUS;
    UIActionSheet *acs=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:NULL otherButtonTitles:@"添加关注", nil];
    acs.tag=btn.tag;
    [acs showFromTabBar:self.tabBarController.tabBar];
    
}

-(void)cancelFocus:(UIButton *)btn{
    
    actionType=CANCELFOCUS;
    
    UIActionSheet *acs=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"取消关注" otherButtonTitles:nil];
    acs.tag=btn.tag;
    [acs showFromTabBar:self.tabBarController.tabBar];

}

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==1){
        NSString *loginUserId=LOGIN_USER_ID;
        
        MessageListRequestItem *item=[dataArray objectAtIndex:alertView.tag];
        
        NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"user_id",item.userid,@"share_id",@"1",@"share_type",@"0",@"is_agree", nil];
        
        NetAccess *net=[NetAccess sharedNetAccess];
        [net getDataWithStyle:NetStyleAgreeShare andParam:param];
        [LoadingView startOnTheViewController:self];
        
    }
    
}

#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
    
    if (buttonIndex==0) {
        if (actionType==REQUESTSHARE) {
            NSString *loginUserId=LOGIN_USER_ID;
            
            MessageListRequestItem *item=[dataArray objectAtIndex:actionSheet.tag];
            
            NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"user_id",item.userid,@"share_id",@"1",@"share_type",@"1",@"is_agree", nil];
            
            NetAccess *net=[NetAccess sharedNetAccess];
            [net getDataWithStyle:NetStyleAgreeShare andParam:param];
            [LoadingView startOnTheViewController:self];
            
        }else if (actionType==CANCELSHARE){
            //改在alertview中执行请求
            NSString *loginUserId=LOGIN_USER_ID;
            
            MessageListRequestItem *item=[dataArray objectAtIndex:actionSheet.tag];
            
            NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"user_id",item.userid,@"share_id",@"1",@"share_type",@"0",@"is_agree", nil];
            
            NetAccess *net=[NetAccess sharedNetAccess];
            [net getDataWithStyle:NetStyleAgreeShare andParam:param];
            [LoadingView startOnTheViewController:self];
            
        }else if(actionType==FOCUS){
            
            MessageListRequestItem *item=[dataArray objectAtIndex:actionSheet.tag];
            NSString *loginUserId=LOGIN_USER_ID;
            NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"user_id",item.userid,@"idol_id", nil];
            NetAccess *net=[NetAccess sharedNetAccess];
            [net getDataWithStyle:NetStyleFocusOn andParam:param];
            [LoadingView startOnTheViewController:self];
            
        }else if (actionType==CANCELFOCUS){
            
            MessageListRequestItem *item=[dataArray objectAtIndex:actionSheet.tag];
            NSString *loginUserId=LOGIN_USER_ID;
            NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"user_id",item.userid,@"idol_id", nil];
            NetAccess *net=[NetAccess sharedNetAccess];
            [net getDataWithStyle:NetStyleCancelFocus andParam:param];
            [LoadingView startOnTheViewController:self];
            
        }
    }
}

#pragma mark NSNotification

-(void)agreeShareSucceed{
    
    [LoadingView stopOnTheViewController:self];
    
    MessageListRequestItem *item=[dataArray objectAtIndex:_selectedIndex];
    
    if ([item.msgType intValue]==6) {
        item.isRead = [NSNumber numberWithInt:1];

        if ([item.isAgreed intValue]==0) {
            //同意共享成功
            item.isAgreed = [NSNumber numberWithInt:1];
            [dataArray replaceObjectAtIndex:_selectedIndex withObject:item];
            
        }else if([item.isAgreed intValue]==1){
            //删除对他的共享成功
            [dataArray removeObjectAtIndex:_selectedIndex];
            [_tableView beginUpdates];
            [_tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:_selectedIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [_tableView endUpdates];
        }
        [_tableView reloadData];
    }
}

-(void)agreeShareFail:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=not.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}

-(void)focusSucceed{
    
    [LoadingView stopOnTheViewController:self];
    
    MessageListRequestItem *item=[dataArray objectAtIndex:_selectedIndex];
    
    if ([item.msgType intValue] == 4){
        //改为相互关注
        item.isRead = [NSNumber numberWithInt:1];
        item.relation = [NSNumber numberWithInt:2];
        
        [dataArray replaceObjectAtIndex:_selectedIndex withObject:item];
        [_tableView reloadData];
        
    }

}

-(void)focusFail:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=not.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}

-(void)cancelFocusSucceed{
    
    [LoadingView stopOnTheViewController:self];
    
    MessageListRequestItem *item=[dataArray objectAtIndex:_selectedIndex];
    
    if ([item.msgType intValue] == 4){
        //改为他关注了我
        item.isRead = [NSNumber numberWithInt:1];
        item.relation = [NSNumber numberWithInt:0];
        
        [dataArray replaceObjectAtIndex:_selectedIndex withObject:item];
        [_tableView reloadData];
        
    }
    
}

-(void)cancelFocusFail:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=not.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}

-(void)getMessListSucceed:(NSNotification *)not{
    
    NSString *styleString=not.object;
    NetAccess *net=[NetAccess sharedNetAccess];
    NSArray *returnArray=[net getReturnDataWithNetStyle:[styleString intValue]];
    [dataArray addObjectsFromArray:returnArray];

    if (returnArray.count == 0) {
        _isFinished = YES;
    }
    
    if (self.Type==1) {
        
        MessageItem *item=[returnArray lastObject];
        self.lastId=item.messId;
        
    }else if (self.Type==0){
        
        MessageListRequestItem *item=[returnArray lastObject];
        self.lastId=item.messId;
        
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
    
    [LoadingView stopOnTheViewController:self];
    titleBtn.enabled = YES;
    [_tableView reloadData];

    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
}

-(void)getMessListFail:(NSNotification *)not{
    
    [LoadingView stopOnTheViewController:self];
    titleBtn.enabled = YES;
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
}

-(void)netFail:(NSNotification *)not{
    
    [LoadingView stopOnTheViewController:self];
    
    titleBtn.enabled = YES;
    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:self];
    
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
}

#pragma mark Private

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)changeList{
    
    [dataArray removeAllObjects];

    if (self.Type==0) {
        
        [titleBtn setBackgroundImage:[UIImage imageNamed:@"btn_messagelist_news_new1.png"] forState:UIControlStateNormal];
        
        self.Type=1;
        self.lastId=NULL;
        [self getData];
        
    }else if(self.Type==1){
        
        [titleBtn setBackgroundImage:[UIImage imageNamed:@"btn_messagelist_request_new1.png"] forState:UIControlStateNormal];
        
        self.Type=0;
        self.lastId=NULL;
        [self getData];
        
    }
}



@end
