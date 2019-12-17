//
//  AlbumList2ViewController.m
//  BabyShow
//
//  Created by Lau on 14-1-13.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "AlbumList2ViewController.h"
#import "AlbumListCell.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"
#import "DateFormatter.h"
#import "ShowAlertView.h"
#import "SingleAlbumViewController.h"



@interface AlbumList2ViewController ()
{
    
    NSIndexPath *moveIndexPath;     //老版的重命名,移动和删除点击的cell记录
    NSDictionary *image_info;       //新版的重命名,移动和删除,记录该相册的字典值
}
@end

@implementation AlbumList2ViewController
//相册里面我的相册下孩子的和其他
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _formerDict = [[NSDictionary alloc] init];
        _dataSourceArray = [[NSMutableArray alloc] init];
        _movingInfo = [[NSDictionary alloc] init];
        image_info = [[NSDictionary alloc]init];
    }
    return self;
}
-(void)setEditBarButton{
    self.editButton= [UIButton buttonWithType:UIButtonTypeSystem];
    [self.editButton setFrame:CGRectMake(0, 0, 40, 30)];
    [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    [self.editButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.editButton addTarget:self action:@selector(clickEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:self.editButton];
    if ([self.movingInfo objectForKey:@"isMoving"] || [self.movingInfo objectForKey:@"isChoosing"]) {
        self.navigationItem.rightBarButtonItem =nil;
    }else {
        self.navigationItem.rightBarButtonItem = rightBtnItem;
    }
    if (self.type == 1 || self.type == 2) {
        self.navigationItem.rightBarButtonItem =nil;
    }
}
-(void)setBackButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.adjustsImageWhenHighlighted = NO;
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
    
    self.navigationItem.title=[self.formerDict objectForKey:@"album_name"];

    self.view.backgroundColor=[UIColor clearColor];
    
    [self setEditBarButton];
    [self setBackButton];
    self.isEditingMode = NO;
    self.isChecked = NO;
    //uiscrollview及其子类会默认在上边和下边留一段空白,上边的为导航条高度加状态条的高度,默认为yes保留空白
    self.automaticallyAdjustsScrollViewInsets =NO;
    
    self.albumList2TableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    self.albumList2TableView.delegate = self;
    self.albumList2TableView.dataSource = self;
    self.albumList2TableView.backgroundColor=[UIColor clearColor];
    self.albumList2TableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    //编辑模式下默认不允许用户选中,困扰我太久
    self.albumList2TableView.allowsSelectionDuringEditing = YES;
    __block AlbumList2ViewController *blockSelf = self;
    [self.albumList2TableView addPullToRefreshWithActionHandler:^{
        [blockSelf startRequestAlbumList];
    }];

    [self.view addSubview:self.albumList2TableView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [self startRequestAlbumList];
    [super viewWillAppear:animated];
}
#pragma mark - 无相册时
-(void)setupViewWhenNoAlbum{
    [self.albumList2TableView removeFromSuperview];
    
    UIView *no_albumView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    no_albumView.backgroundColor = [UIColor clearColor];
    UIImageView *cry_imageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(96.5, 64+36, 127, 127)];
    cry_imageVIew.image = [UIImage imageNamed:@"img_myshow_empty_babyface"];
    [no_albumView addSubview:cry_imageVIew];
    
    UILabel *no_albumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+167, 320, 30)];
    no_albumLabel.text = @"暂时没有相册哦";
    no_albumLabel.textColor =[BBSColor hexStringToColor:@"c3ad8f"];
    no_albumLabel.backgroundColor =[UIColor clearColor];
    no_albumLabel.textAlignment = NSTextAlignmentCenter;
    [no_albumView addSubview:no_albumLabel];
    
    [self.view addSubview:no_albumView];
}
#pragma mark - 请求相册列表数据
-(void)startRequestAlbumList{
    //GET
    //50条,暂时没加上拉加载更多
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.user_id,kAlbumListUser_id,[self.formerDict objectForKey:@"id"],kAlbumListAlbum_id,@"50",kAlbumListPage_size, nil];
    
    UrlMaker *url = [[UrlMaker alloc] initWithNewV1UrlStr:kAlbumList Method:NetMethodGet andParam:params];
    
    ASIHTTPRequest *albumListRequest = [[ASIHTTPRequest alloc] initWithURL:url.url];
    [albumListRequest setDelegate:self];
    albumListRequest.tag = GLOBAL_REQUEST;
    [albumListRequest startAsynchronous];
}
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.type == 1 || self.type == 2) {
        return self.dataSourceArray.count;
    }else {
        if (self.isEditingMode || [self.movingInfo objectForKey:@"isMoving"]) {
            return self.dataSourceArray.count;
        }
        return self.dataSourceArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 172;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"AlbumListIdentifier";
    
    AlbumDetailCell *cell = (AlbumDetailCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AlbumDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.delegate = self;
    }
    
    NSArray *section0Array = [self.dataSourceArray objectAtIndex:indexPath.row];
    NSDictionary *model0 = nil;
    NSDictionary *model1 = nil;
    if (section0Array.count == 2) {
        model0 = [section0Array objectAtIndex:0];
        model1 = [section0Array objectAtIndex:1];
    }else if(section0Array.count == 1) {
        model0 = [section0Array objectAtIndex:0];
        model1 = nil;
    }else {
        model0 = nil;
        model1 = nil;
    }
    if (model0) {
        if ([[model0 objectForKey:@"new_album"] boolValue] == 1) {
           cell.leftBackGroundImageView.image =[UIImage imageNamed:@"add_album"];
            cell.leftAlbumNameLabel.text = @"新建相册";
            cell.leftAlbumNameLabel.frame = CGRectMake(0, 140, 160, 40);
            [cell.leftAlbumNameLabel insertImage:[UIImage imageNamed:@"add"] atIndex:0 margins:UIEdgeInsetsMake(0, 45, 0, 3) verticalTextAlignment:NIVerticalTextAlignmentMiddle];
            cell.leftCreateTimeLabel.text = nil;
            cell.leftImageView.image = nil;
            cell.leftBackGroundImageView.imageInfo = model0;
            cell.leftSelectImageView.image = nil;
        } else {
            double  timeStamp = [[model0 objectForKey:@"create_time"] doubleValue]/1000;
            NSString *create_time = [DateFormatter dateStringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp] formatter:@"yyyy-MM-dd HH:mm"];
           // [cell.leftImageView setImageWithURL:[NSURL URLWithString:[model0 objectForKey:@"album_cover"]]placeholderImage:[UIImage imageNamed:@"white_border"]];
            [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:[model0 objectForKey:@"album_cover"]] placeholderImage:[UIImage imageNamed:@"white_border"]];
            cell.leftAlbumNameLabel.frame = CGRectMake(0, 132, 160, 20);
            cell.leftAlbumNameLabel.text = [model0 objectForKey:@"album_name"];
            cell.leftBackGroundImageView.image = [UIImage imageNamed:@"add_album"];
            cell.leftCreateTimeLabel.text = create_time;
            cell.leftBackGroundImageView.imageInfo = model0;
            cell.leftSelectImageView.hidden = !self.isEditingMode;
            cell.leftSelectImageView.image = [UIImage imageNamed:@"img_unchecked@2x"];
        }
    }else {
        cell.leftImageView.image = nil;
        cell.leftAlbumNameLabel.text = nil;
        cell.leftCreateTimeLabel.text = nil;
        cell.leftBackGroundImageView.image = nil;
        cell.leftBackGroundImageView.imageInfo = nil;
        cell.leftSelectImageView.image = nil;
    }
    if (model1) {
        double  timeStamp = [[model1 objectForKey:@"create_time"] doubleValue]/1000;
        NSString *create_time = [DateFormatter dateStringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp] formatter:@"yyyy-MM-dd HH:mm"];
       // [cell.rightImageView setImageWithURL:[NSURL URLWithString:[model1 objectForKey:@"album_cover"]]];
        [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:[model1 objectForKey:@"album_cover"]]];
        cell.rightAlbumNameLabel.text = [model1 objectForKey:@"album_name"];
        cell.rightCreateTimeLabel.text = create_time;
        cell.rightBackGroundImageView.image = [UIImage imageNamed:@"add_album"];
        cell.rightBackGroundImageView.imageInfo = model1;
        cell.rightSelectImageView.hidden = !self.isEditingMode;
        cell.rightSelectImageView.image = [UIImage imageNamed:@"img_unchecked@2x"];
    }else {
        cell.rightImageView.image = nil;
        cell.rightAlbumNameLabel.text = nil;
        cell.rightCreateTimeLabel.text = nil;
        cell.rightBackGroundImageView.image = nil;
        cell.rightBackGroundImageView.imageInfo = nil;
        cell.rightSelectImageView.image = nil;
    }

    return cell;
}
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}
#pragma mark - 新版点击事件 Methods
-(void)selectAlbumInfo:(NSDictionary *)imageInfo cell:(UITableViewCell *)cell isLeft:(BOOL)isLeft{
    if (imageInfo == nil) {
        return;
    }
    ////新建相册区域
    if ([[imageInfo objectForKey:@"new_album"]boolValue] == 1) {

        if (self.isEditingMode ) {
            return;
        }
        if ( [self.movingInfo objectForKey:@"isMoving"] || [self.movingInfo objectForKey:@"isChoosing"]) {
            return;
        }
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"新建相册"
                                                           message:nil
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"完成", nil];
        alertView.alertViewStyle =UIAlertViewStylePlainTextInput;
        UITextField *tf =[alertView textFieldAtIndex:0];
        tf.placeholder = @"新建相册";
        alertView.tag = NEW_ALBUM_ALERTVIEW_TAG;
        [alertView show];
        
    }else{//普通相册区域
        
        image_info = imageInfo;
        
        if (self.isEditingMode ) {
            AlbumDetailCell * editCell = (AlbumDetailCell *)cell;
            if (isLeft) {
                editCell.leftSelectImageView.image = [UIImage imageNamed:@"img_checked"];
            }else{
                editCell.rightSelectImageView.image = [UIImage imageNamed:@"img_checked"];
            }
            if (self.edit_type == Edit_Type_Delete) {
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"确认删除"
                                                                    message:[imageInfo objectForKey:@"album_name"]
                                                                   delegate:self
                                                          cancelButtonTitle:@"取消"
                                                          otherButtonTitles:@"确定", nil];
                alertView.tag = DELETE_ALBUM_ALERTVIEW_TAG;
                [alertView show];
            }else if (self.edit_type == Edit_Type_Rename){
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"重命名"
                                                                   message:nil
                                                                  delegate:self
                                                         cancelButtonTitle:@"取消"
                                                         otherButtonTitles:@"完成", nil];
                alertView.alertViewStyle =UIAlertViewStylePlainTextInput;
                UITextField *tf =[alertView textFieldAtIndex:0];
                tf.placeholder = @"相册名称";
                alertView.tag = RENAME_ALBUM_ALERTVIEW_TAG;
                [alertView show];
            }
            return;
        }
        if ( [self.movingInfo objectForKey:@"isMoving"]) {

            NSString *message = [NSString stringWithFormat:@"移动到\"%@\"",[imageInfo objectForKey:@"album_name"]];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:message
                                                               delegate:self
                                                      cancelButtonTitle:@"取消"
                                                      otherButtonTitles:@"确定", nil];
            alertView.tag =MOVE_IMG_ALERTVIEW_TAG;
            [alertView show];
            return;
        }
        BOOL is_default = [[imageInfo objectForKey:@"is_default"] boolValue];
        if (is_default) {
            SingleAlbumViewController *singleAlbumViewController = [[SingleAlbumViewController alloc]init];
            singleAlbumViewController.summaryDictionary = imageInfo;
            singleAlbumViewController.user_id = self.user_id;
            singleAlbumViewController.type = self.type;
            singleAlbumViewController.isChoosing = [[self.movingInfo objectForKey:@"isChoosing"] boolValue];
            singleAlbumViewController.currentCount = [[self.movingInfo objectForKey:@"currentCount"] unsignedIntegerValue];
            [singleAlbumViewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:singleAlbumViewController animated:YES];
        }else{
            //目前没有下一级目录
        }
    }
}
#pragma mark - 点击右上角按钮弹出更多编辑选项
-(void)setEditing:(BOOL)editing animated:(BOOL)animated{
    [super setEditing:editing animated:animated];
//old    [self.albumList2TableView setEditing:editing animated:animated];
    [self.albumList2TableView performSelector:@selector(reloadData) withObject:nil afterDelay:0.2];
}
-(AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
-(void)clickEdit:(id)sender{
    if (self.isEditingMode) {
        self.isEditingMode = !self.isEditingMode;
        [self setEditing:NO animated:YES];
        [self.editButton setTitle:@"编辑" forState:UIControlStateNormal];
    }else {
        UIActionSheet *moreActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"重命名",@"删除", nil];
        UITabBar *tabBar = [self appDelegate].tabbarcontroller.tabBar;
        
        [moreActionSheet showFromTabBar:tabBar];
    }
}
#pragma mark - UIActionSheetDelegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
       
        case 0://重命名
        {
            [self setEditing:YES animated:YES];
            self.edit_type = Edit_Type_Rename;
            [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
            self.isEditingMode = YES;
             break;
        }
        case 1://删除
        {
            [self setEditing:YES animated:YES];
            self.edit_type = Edit_Type_Delete;
            [self.editButton setTitle:@"完成" forState:UIControlStateNormal];
            self.isEditingMode = YES;

            break;
        }
        case 2://取消
        {
            break;
        }
        default:
            break;
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *user_id = LOGIN_USER_ID;
    if (buttonIndex == 1) {//确定
        if (alertView.tag == NEW_ALBUM_ALERTVIEW_TAG) {
            NSString *album_name = ((UITextField *)[alertView textFieldAtIndex:0]).text;
            if (album_name.length <= 0 ) {
                [ShowAlertView showAlertViewWithTitle:@"提示" message:@"名称不能为空" cancelTitle:@"知道了"];
                return;
            }
            NSString *album_id = [self.formerDict objectForKey:@"id"];

            [LoadingView startOnTheViewController:self];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:user_id,kNewAlbumUser_id,album_id,kNewAlbumAlbum_id,album_name,kNewAlbumAlbum_name, nil];
            [[HTTPClient sharedClient] postNew:kNewAlbum params:params success:^(NSDictionary *result) {
                [LoadingView stopOnTheViewController:self];
                if ([[result objectForKey:kBBSSuccess] integerValue] == 1) {
                    [MobClick event:UMEVENTADDALUM];
                    [self startRequestAlbumList];
                }else{
                    //error
                    [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
                }
            } failed:^(NSError *error) {
                [LoadingView stopOnTheViewController:self];
                if (self.albumList2TableView.pullToRefreshView && [self.albumList2TableView.pullToRefreshView state] == SVPullToRefreshStateLoading) {
                    [self.albumList2TableView.pullToRefreshView stopAnimating];
                }
                
            }];

        }else if (alertView.tag == DELETE_ALBUM_ALERTVIEW_TAG){
            
            NSDictionary  *rowDict = image_info;
            [LoadingView startOnTheViewController:self];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:user_id,kDoAlbumUser_id,[rowDict objectForKey:@"id"],kDoAlbumAlbum_id,@"1",kDoAlbumDo_type, nil];
            [[HTTPClient sharedClient] postNew:kDoAlbum params:params success:^(NSDictionary *result) {
                [LoadingView stopOnTheViewController:self];
                if ([[result objectForKey:kBBSSuccess] integerValue] == 1) {
                    self.isChecked = NO;
                    [self startRequestAlbumList];
                }else{
                    //error
                    self.isChecked = NO;
                    [self.albumList2TableView reloadData];
                    [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
                }
                    
            } failed:^(NSError *error) {
                [LoadingView stopOnTheViewController:self];
                if (self.albumList2TableView.pullToRefreshView && [self.albumList2TableView.pullToRefreshView state] == SVPullToRefreshStateLoading) {
                    [self.albumList2TableView.pullToRefreshView stopAnimating];
                }
                [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];

            }];
            
        }else if (alertView.tag == RENAME_ALBUM_ALERTVIEW_TAG){
            NSString *album_name = ((UITextField *)[alertView textFieldAtIndex:0]).text;
            if (album_name.length <= 0 ) {
                [ShowAlertView showAlertViewWithTitle:@"提示" message:@"名称不能为空" cancelTitle:@"知道了"];
                self.isChecked  = NO;
                [self.albumList2TableView reloadData];
                return;
            }
            NSDictionary  *rowDict = image_info;

            [LoadingView startOnTheViewController:self];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:user_id,kDoAlbumUser_id,[rowDict objectForKey:@"id"],kDoAlbumAlbum_id,album_name,kDoAlbumAlbum_name,@"0",kDoAlbumDo_type, nil];
            [[HTTPClient sharedClient] postNew:kDoAlbum params:params success:^(NSDictionary *result) {
                [LoadingView stopOnTheViewController:self];
                if ([[result objectForKey:kBBSSuccess] integerValue] == 1) {
                    self.isChecked = NO;
                    [self startRequestAlbumList];
                }else{
                    //error
                    self.isChecked = NO;
                    [self.albumList2TableView reloadData];
                    [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
                }
                
            } failed:^(NSError *error) {
                [LoadingView stopOnTheViewController:self];
                if (self.albumList2TableView.pullToRefreshView && [self.albumList2TableView.pullToRefreshView state] == SVPullToRefreshStateLoading) {
                    [self.albumList2TableView.pullToRefreshView stopAnimating];
                }
                [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
                
            }];
            
        }else if (alertView.tag == MOVE_IMG_ALERTVIEW_TAG){
            NSDictionary  *rowDict = image_info;
            if ([[self.movingInfo objectForKey:@"album_id"] isEqual:[rowDict objectForKey:@"id"]]){
                [ShowAlertView showAlertViewWithTitle:nil message:@"您选择的是同一个相册" cancelTitle:@"确定"];
                return;
            }
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kNewBasicUrl,kMoveImgs]];
            ASIFormDataRequest *moveRequest = [ASIFormDataRequest requestWithURL:url];
            [moveRequest setPostValue:user_id forKey:kMoveImgsUser_id];
            [moveRequest setPostValue:[self.movingInfo objectForKey:@"album_id"] forKey:kMoveImgsAlbum_id];
            [moveRequest setPostValue:[self.movingInfo objectForKey:@"img_ids"] forKey:kMoveImgsImg_ids];
            [moveRequest setPostValue:[rowDict objectForKey:@"id"] forKey:kMoveImgsTo_album_id];
            [moveRequest setTag:MOVE_IMG_ALERTVIEW_TAG];
            [moveRequest setDelegate:self];
            [moveRequest startAsynchronous];

        }
        
    }else{  //取消
        if (alertView.tag == MOVE_IMG_ALERTVIEW_TAG) {
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[SingleAlbumViewController class]]) {
                    //退回到进行移动操作的界面
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }else if (alertView.tag == DELETE_ALBUM_ALERTVIEW_TAG || alertView.tag == RENAME_ALBUM_ALERTVIEW_TAG){
            //还原未选中状态
            self.isChecked  = NO;
            
            [self.albumList2TableView reloadData];
        }
    }
    image_info = nil;
}
#pragma mark - ASIHTTPRequest
-(void)requestStarted:(ASIHTTPRequest *)request{
    [LoadingView startOnTheViewController:self];
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    if (self.albumList2TableView.pullToRefreshView && [self.albumList2TableView.pullToRefreshView state] == SVPullToRefreshStateLoading) {
        [self.albumList2TableView.pullToRefreshView stopAnimating];
    }
    [LoadingView stopOnTheViewController:self];
    NSString *requestString = [request responseString];
    NSDictionary *requestDictionary = [requestString objectFromJSONString];
    if (request.tag == GLOBAL_REQUEST) {
       
        if ([[requestDictionary objectForKey:kBBSSuccess] integerValue] == 1) {
/**            self.dataSourceArray = [requestDictionary objectForKey:kBBSData];
            [self.albumList2TableView reloadData];  */
            NSArray *data = [requestDictionary objectForKey:kBBSData];
        
            [self.dataSourceArray removeAllObjects];
            NSMutableArray *tempArray = [[NSMutableArray alloc]init];
            if (self.type == 0) {//我自己
                [tempArray addObject:@{@"new_album": [NSNumber numberWithBool:YES]}];
            }
            if (data.count <= 0 && self.type == 0){
                NSArray *arr = [[NSArray alloc]initWithArray:tempArray];
                [self.dataSourceArray addObject:arr];
                [tempArray removeAllObjects];
            } else {
                for (int i = 0; i < data.count; i++) {
                    NSDictionary *model = [data objectAtIndex:i];
                    [tempArray addObject:model];
                    if (tempArray.count == 2 || i == data.count-1) {
                        NSArray *arr = [[NSArray alloc]initWithArray:tempArray];
                        [self.dataSourceArray addObject:arr];
                        [tempArray removeAllObjects];
                    }
                }
            }
            if (self.dataSourceArray.count <= 0) {
                [self setupViewWhenNoAlbum];
            }else {
                [self.albumList2TableView reloadData];
            }
        }else {
            [BBSAlert showAlertWithContent:[requestDictionary objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } else if(request.tag == MOVE_IMG_ALERTVIEW_TAG){
        if ([[requestDictionary objectForKey:kBBSSuccess] integerValue] == 1) {
            //移动成功
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[SingleAlbumViewController class]]) {
                    //退回到进行移动操作的界面
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }else{
            //error
            [BBSAlert showAlertWithContent:[requestDictionary objectForKey:kBBSReMsg] andDelegate:nil];
            for (UIViewController *temp in self.navigationController.viewControllers) {
                if ([temp isKindOfClass:[SingleAlbumViewController class]]) {
                    //退回到进行移动操作的界面
                    [self.navigationController popToViewController:temp animated:YES];
                }
            }
        }
    }
    
    
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    [LoadingView stopOnTheViewController:self];
    if (self.albumList2TableView.pullToRefreshView && [self.albumList2TableView.pullToRefreshView state] == SVPullToRefreshStateLoading) {
        [self.albumList2TableView.pullToRefreshView stopAnimating];
    }
    [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
}
@end
