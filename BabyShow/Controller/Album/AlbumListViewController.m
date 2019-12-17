//
//  PhotosViewController.m
//  BabyShow
//
//  Created by Lau on 14-1-6.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "AlbumListViewController.h"
#import "JSONKit.h"
#import "UIImageView+WebCache.h"
#import "DateFormatter.h"
#import "ShowAlertView.h"
#import "SingleAlbumViewController.h"
#import "AlbumList2ViewController.h"
#import "TA_AlbumListViewController.h"
#import "ThemeAlbumViewController.h"
#import "MakeAShowViewController.h"
#import "PBMakeAPostViewController.h"
#import "VideoAlbumVC.h"

@interface AlbumListViewController ()
{
    NSIndexPath *moveIndexPath;         //移动时记录点击的位置
}
@end

@implementation AlbumListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataSourceArray = [[NSMutableArray alloc] init];
        _shareAlbumArray = [[NSMutableArray alloc]init];
        _movingInfo = [[NSDictionary alloc] init];
    }
    return self;
}
-(void)setBackButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)back{
    
    for (UIViewController *vc in self.navigationController.viewControllers) {
        if ([vc isKindOfClass:[MakeAShowViewController class]]) {
            
            MakeAShowViewController *MakeAShowVC=(MakeAShowViewController *)vc;
            [MakeAShowVC.pickedImagesArray addObjectsFromArray:MakeAShowVC.imageArray];
            [MakeAShowVC makeImageViewWithPickedImagesArray:MakeAShowVC.pickedImagesArray];
            MakeAShowVC.describeField.text=MakeAShowVC.content;
            
        }else if ([vc isKindOfClass:[PBMakeAPostViewController class]]){
            
            PBMakeAPostViewController *makeAShowVC=(PBMakeAPostViewController *) vc;
            [makeAShowVC makeImageViewsWithPhotosArray:makeAShowVC.photoArray];
            
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barTintColor = [BBSColor hexStringToColor:NAVICOLOR];

    [MobClick beginLogPageView:@"ALBUM LIST"];
    
    [self startRequestAlbumList];
    [self startRequestShareAlbumList];
    [super viewWillAppear:animated];
}
- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor=[UIColor whiteColor];

    self.navigationItem.title=@"相册";
    self.automaticallyAdjustsScrollViewInsets =NO;
    self.albumListTableView =[[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64) style:UITableViewStylePlain];
    self.albumListTableView.delegate = self;
    self.albumListTableView.dataSource = self;
    self.albumListTableView.backgroundColor=[UIColor clearColor];
    self.albumListTableView.separatorStyle =UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.albumListTableView];
    __weak AlbumListViewController *blockSelf = self;
    [self.albumListTableView addPullToRefreshWithActionHandler:^{
        [blockSelf startRequestAlbumList];
        [blockSelf startRequestShareAlbumList];
    }];
    
    [self setBackButton];

}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"ALBUM LIST"];
    
}

#pragma mark - 无相册时
-(void)setupViewWhenNoAlbum{
    [self.albumListTableView removeFromSuperview];
    
    UIView *no_albumView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    
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
#pragma mark - 请求我的相册.和共享相册列表
-(void)startRequestAlbumList{
    //GET
    [LoadingView startOnTheViewController:self];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,kAlbumListUser_id, nil];
    [[HTTPClient sharedClient] getNewV1:kAlbumList params:params success:^(NSDictionary *result) {
        if ((self.albumListTableView.pullToRefreshView)&& [self.albumListTableView.pullToRefreshView state] ==SVPullToRefreshStateLoading) {
            
            [self.albumListTableView.pullToRefreshView stopAnimating];
        }
        [LoadingView stopOnTheViewController:self];
        if ([[result objectForKey:kBBSSuccess] integerValue] == 1) {
            NSArray *data = [result objectForKey:kBBSData];
            if (data.count ==0) {//没有相册
                [self setupViewWhenNoAlbum];
            }else{
                [self.dataSourceArray removeAllObjects];
                NSMutableArray *tempArray = [[NSMutableArray alloc]init];
                for (int i = 0; i < data.count; i++) {
                    NSDictionary *model = [data objectAtIndex:i];
                    [tempArray addObject:model];
                    if (tempArray.count == 2 || i == data.count-1) {
                        NSArray *arr = [[NSArray alloc]initWithArray:tempArray];
                        [self.dataSourceArray addObject:arr];
                        [tempArray removeAllObjects];
                    }
                }
                [self.albumListTableView reloadData];
            }
        }else {
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        if (self.albumListTableView.pullToRefreshView && [self.albumListTableView.pullToRefreshView state] == SVPullToRefreshStateLoading) {
            [self.albumListTableView.pullToRefreshView stopAnimating];
        }
        [LoadingView stopOnTheViewController:self];
        [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
    }];
    
}
-(void)startRequestShareAlbumList{
    
    [LoadingView startOnTheViewController:self];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,kShareAlbumUser_id, nil];

    [[HTTPClient sharedClient] getNew:kShareAlbum params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess] integerValue] == 1) {
            
            NSArray *data = [result objectForKey:kBBSData];
            [self.shareAlbumArray removeAllObjects];
            
            NSMutableArray *tempArray = [[NSMutableArray alloc]init];
            for (int i = 0; i < data.count; i++) {
                NSDictionary *model = [data objectAtIndex:i];
                [tempArray addObject:model];
                if (tempArray.count == 2 || i == data.count-1) {
                    NSArray *arr = [[NSArray alloc]initWithArray:tempArray];
                    [self.shareAlbumArray addObject:arr];
                    [tempArray removeAllObjects];
                }
            }
            [self.albumListTableView reloadData];
        }else{
            //error
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        if (self.albumListTableView.pullToRefreshView && [self.albumListTableView.pullToRefreshView state] == SVPullToRefreshStateLoading) {
            [self.albumListTableView.pullToRefreshView stopAnimating];
        }
        [LoadingView stopOnTheViewController:self];
        [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
    }];

}
#pragma mark -
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDataSource Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //当前页面是移动的页面,不能显示共享相册,对他们没有操作权限
    if ([self.movingInfo objectForKey:@"isMoving"] || [self.movingInfo objectForKey:@"isChoosing"]) {
        return 1;
    }
    return 2;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
 
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 25)];
    view.backgroundColor = [UIColor whiteColor];
    
    CGRect imageViewFrame = CGRectMake(125, 4, 70, 19);
    UIImage *myAlbumImage = [UIImage imageNamed:@"album_myalbum"];
    UIImage *shareAlbumImage = [UIImage imageNamed:@"album_sharealbum"];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:imageViewFrame];
    imageView.backgroundColor =[UIColor clearColor];
    
    CGRect  seperatorViewFrame = CGRectMake(0, 0, SCREENWIDTH, 1);
    UIImageView *seperatorView = [[UIImageView alloc]initWithFrame:seperatorViewFrame];
    seperatorView.backgroundColor =[UIColor clearColor];

    if (section == 0) {
        imageView.image = myAlbumImage;
        seperatorView.image = nil;
    }else {
        seperatorView.image = [UIImage imageNamed:@"line"];
        imageView.image = shareAlbumImage;
    }
    [view addSubview:seperatorView];
    [view addSubview:imageView];

    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return self.dataSourceArray.count;
    }else {
        return self.shareAlbumArray.count;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 150;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"AlbumListIdentifier";
    
    AlbumBabyCell *cell = (AlbumBabyCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[AlbumBabyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    switch (indexPath.section) {
        case 0:// 我的相册
        {
            NSArray *section0Array = [self.dataSourceArray objectAtIndex:indexPath.row];
            NSDictionary *model0 = nil;
            NSDictionary *model1 = nil;
            if (section0Array.count == 2) {
                model0 = [section0Array objectAtIndex:0];
                model1 = [section0Array objectAtIndex:1];
            }else {
                model0 = [section0Array objectAtIndex:0];
                model1 = nil;
            }
            if (model0) {
                [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:[model0 objectForKey:@"album_cover"]]];
                cell.leftAlbumNameLabel.text = [model0 objectForKey:@"album_name"];
                cell.leftBackGroundImageView.image = [UIImage imageNamed:@"album_border"];
                cell.leftBackGroundImageView.imageInfo = model0;
            }else {
                cell.leftImageView.image = nil;
                cell.leftAlbumNameLabel.text = nil;
                cell.leftBackGroundImageView.image = nil;
                cell.leftBackGroundImageView.imageInfo = nil;
            }
            if (model1) {
                [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:[model1 objectForKey:@"album_cover"]]];
                
                cell.rightAlbumNameLabel.text = [model1 objectForKey:@"album_name"];
                cell.rightBackGroundImageView.image = [UIImage imageNamed:@"album_border"];
                cell.rightBackGroundImageView.imageInfo = model1;
            }else {
                cell.rightImageView.image = nil;
                cell.rightAlbumNameLabel.text = nil;
                cell.rightBackGroundImageView.image = nil;
                cell.rightBackGroundImageView.imageInfo = nil;
            }
            break;
        }
        case 1://共享相册
        {
            NSArray *section1Array = [self.shareAlbumArray objectAtIndex:indexPath.row];
            NSDictionary *model0 = nil;
            NSDictionary *model1 = nil;
            if (section1Array.count == 2) {
                model0 = [section1Array objectAtIndex:0];
                model1 = [section1Array objectAtIndex:1];
            }else {
                model0 = [section1Array objectAtIndex:0];
                model1 = nil;
            }
            if (model0) {
                [cell.leftImageView sd_setImageWithURL:[NSURL URLWithString:[model0 objectForKey:@"avatar"]]];
                cell.leftAlbumNameLabel.text = [model0 objectForKey:@"nick_name"];
                cell.leftBackGroundImageView.image = [UIImage imageNamed:@"album_border"];
                cell.leftBackGroundImageView.imageInfo = model0;
            } else {
                cell.leftImageView.image = nil;
                cell.leftAlbumNameLabel.text = nil;
                cell.leftBackGroundImageView.image = nil;
                cell.leftBackGroundImageView.imageInfo = nil;
            }
            
            if (model1) {
                [cell.rightImageView sd_setImageWithURL:[NSURL URLWithString:[model1 objectForKey:@"avatar"]]];
                cell.rightAlbumNameLabel.text = [model1 objectForKey:@"nick_name"];
                cell.rightBackGroundImageView.image = [UIImage imageNamed:@"album_border"];
                cell.rightBackGroundImageView.imageInfo = model1;
            } else {
                cell.rightImageView.image = nil;
                cell.rightAlbumNameLabel.text = nil;
                cell.rightBackGroundImageView.image = nil;
                cell.rightBackGroundImageView.imageInfo = nil;
            }
            break;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark - 新版点击图片进入相册 Methods
-(void)selectAlbumInfo:(NSDictionary *)imageInfo cell:(UITableViewCell *)cell isLeft:(BOOL)isLeft{
    if (imageInfo == nil){
        return;
    }
    NSLog(@"imageInfo = %@",imageInfo);
    if ([imageInfo objectForKey:@"nick_name"]) {
        TA_AlbumListViewController *albumListVC = [[TA_AlbumListViewController alloc] init];
        albumListVC.title = [imageInfo objectForKey:@"nick_name"];
        albumListVC.ta_user_id =[imageInfo objectForKey:@"user_id"];
        albumListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:albumListVC animated:YES];

    } else {
        if ([[imageInfo objectForKey:@"is_video"]integerValue] == YES) {
            if ([self.movingInfo objectForKey:@"isMoving"]||[self.movingInfo objectForKey:@"isChoosing"]) {
                [ShowAlertView showAlertViewWithTitle:nil message:@"视频不允许操作" cancelTitle:@"确定"];
                return;
            }
            //如果是视频的时候，跳转到下一级页面
            VideoAlbumVC *videoAlbumVC = [[VideoAlbumVC alloc]init];
            videoAlbumVC.userId = LOGIN_USER_ID;
            [self.navigationController pushViewController:videoAlbumVC animated:YES];
            
        }else{
        BOOL is_default = [[imageInfo objectForKey:@"is_default"] boolValue];
        if (is_default) {// 下一级是图片
            if ([self.movingInfo objectForKey:@"isMoving"] || [self.movingInfo objectForKey:@"isChoosing"]) {
                if ([[imageInfo objectForKey:@"is_show_album"] integerValue] == 1) {
                    [ShowAlertView showAlertViewWithTitle:nil message:@"秀秀/主题相册不允许操作" cancelTitle:@"确定"];
                    return;
                }
            }
            
            if (![[imageInfo objectForKey:@"album_name"] isEqualToString:@"秀秀相册"]){
                //判断进入主题相册还是秀秀相册
                ThemeAlbumViewController *themeViewController = [[ThemeAlbumViewController alloc]init];
                themeViewController.user_id = LOGIN_USER_ID;
                themeViewController.type = 0;
                themeViewController.formerDict = imageInfo;
                [themeViewController setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:themeViewController animated:YES];
            } else {
                SingleAlbumViewController *singleAlbumViewController = [[SingleAlbumViewController alloc]init];
                singleAlbumViewController.summaryDictionary = imageInfo;
                singleAlbumViewController.user_id = LOGIN_USER_ID;
                singleAlbumViewController.type = 0;
                [singleAlbumViewController setHidesBottomBarWhenPushed:YES];
                [self.navigationController pushViewController:singleAlbumViewController animated:YES];
            }
        } else {    //下一级页面仍然是相册列表
            //请求二级相册列表
            AlbumList2ViewController *albumList2ViewController =[[ AlbumList2ViewController alloc]init];
            albumList2ViewController.formerDict = imageInfo;
            albumList2ViewController.type = 0;      //我的相册
            albumList2ViewController.user_id = LOGIN_USER_ID;
            albumList2ViewController.movingInfo =self.movingInfo;
            [albumList2ViewController setHidesBottomBarWhenPushed:YES];
            [self.navigationController pushViewController:albumList2ViewController animated:YES];
        }
    }
    }
}

@end
