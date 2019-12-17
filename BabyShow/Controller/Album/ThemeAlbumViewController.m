//
//  ThemeAlbumViewController.m
//  BabyShow
//
//  Created by Mayeon on 14-4-8.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ThemeAlbumViewController.h"
#import "BBSNavigationController.h"
#import "BBSNavigationControllerNotTurn.h"
#import "SVPullToRefresh.h"
#import "ThemeAlbumCell.h"
#import "JSONKit.h"
#import "ImageView.h"
#import "UIImageView+WebCache.h"
#import "DateFormatter.h"

@interface ThemeAlbumViewController ()

@end

@implementation ThemeAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = [[NSMutableArray alloc]init];
        _mwphotosArray = [[NSMutableArray alloc]init];
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
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor=[UIColor whiteColor];

    self.title=@"主题相册";
    [self setBackButton];
    [self setupTableView];
    [self getMyThemeAlbumList];

}
- (void)setupTableView{
    
    if (self.themeAlbumTableView) {
        [self.themeAlbumTableView removeFromSuperview];
        self.themeAlbumTableView = nil;
    }
    
    CGRect rect = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    self.themeAlbumTableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    self.themeAlbumTableView.delegate = self;
    self.themeAlbumTableView.dataSource = self;
    self.themeAlbumTableView.backgroundColor = [UIColor clearColor];
    self.themeAlbumTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    __weak ThemeAlbumViewController *blockSelf = self;
    //下拉刷新
    [self.themeAlbumTableView addPullToRefreshWithActionHandler:^{
        [blockSelf getMyThemeAlbumList];
    }];
    
    //加载更多
    [self.themeAlbumTableView addInfiniteScrollingWithActionHandler:^{
        NSDictionary *lastDict = [blockSelf.dataArray lastObject];
       
        [LoadingView startOnTheViewController:blockSelf];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:blockSelf.user_id,kImgListUser_id,LOGIN_USER_ID,kImgListLogin_user_id,[blockSelf.formerDict objectForKey:@"id"],kImgListAlbum_id,[lastDict objectForKey:@"img_id"],kImgListLast_id, nil];
        [[HTTPClient sharedClient]getNewV1:kImgListV2 params:params success:^(NSDictionary *result) {
            [LoadingView stopOnTheViewController:blockSelf];
            if (blockSelf.themeAlbumTableView.pullToRefreshView && [blockSelf.themeAlbumTableView.pullToRefreshView state] == SVPullToRefreshStateLoading) {
                [blockSelf.themeAlbumTableView.pullToRefreshView stopAnimating];
            }
            [blockSelf.themeAlbumTableView.infiniteScrollingView stopAnimating];
            if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                NSArray *array = [result objectForKey:kBBSData];
                if (array.count <= 0) {
                    [blockSelf.themeAlbumTableView.infiniteScrollingView removeFromSuperview];
                } else {
                    [blockSelf.dataArray addObjectsFromArray:array];
                    [blockSelf.themeAlbumTableView reloadData];
                }
            } else {
                [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
            }
        } failed:^(NSError *error) {
            if (blockSelf.themeAlbumTableView.pullToRefreshView && [blockSelf.themeAlbumTableView.pullToRefreshView state] == SVPullToRefreshStateLoading) {
                [blockSelf.themeAlbumTableView.pullToRefreshView stopAnimating];
            }
            [LoadingView stopOnTheViewController:blockSelf];

        }];

    }];
    [self.view addSubview:self.themeAlbumTableView];

}
- (void)setupWhenNoThemeList{
    [self.themeAlbumTableView removeFromSuperview];
    
    UIView *no_albumView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height-64)];
    no_albumView.backgroundColor = [UIColor clearColor];
    UIImageView *cry_imageVIew = [[UIImageView alloc]initWithFrame:CGRectMake(96.5, 64+36, 127, 127)];
    cry_imageVIew.image = [UIImage imageNamed:@"img_myshow_empty_babyface"];
    [no_albumView addSubview:cry_imageVIew];
    
    UILabel *no_albumLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64+167, 320, 30)];
    no_albumLabel.text = @"暂时没有主题相册哦";
    no_albumLabel.textColor =[BBSColor hexStringToColor:@"c3ad8f"];
    no_albumLabel.backgroundColor =[UIColor clearColor];
    no_albumLabel.textAlignment = NSTextAlignmentCenter;
    [no_albumView addSubview:no_albumLabel];
    
    [self.view addSubview:no_albumView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 请求 Methods
- (void)getMyThemeAlbumList{

    [LoadingView startOnTheViewController:self];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.user_id,kImgListUser_id,LOGIN_USER_ID,kImgListLogin_user_id,[self.formerDict objectForKey:@"id"],kImgListAlbum_id, nil];
    [[HTTPClient sharedClient]getNewV1:kImgListV2 params:params success:^(NSDictionary *result) {
        [LoadingView stopOnTheViewController:self];
        if (self.themeAlbumTableView.pullToRefreshView && [self.themeAlbumTableView.pullToRefreshView state] == SVPullToRefreshStateLoading) {
            [self.themeAlbumTableView.pullToRefreshView stopAnimating];
        }
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            [self.dataArray removeAllObjects];
            NSArray *array = [result objectForKey:kBBSData];
            [self.dataArray addObjectsFromArray:array];
            if (self.dataArray.count == 0) {
                [self setupWhenNoThemeList];
            }else {
                [self setupTableView];
                [self.themeAlbumTableView reloadData];
            }
        } else {
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }

    } failed:^(NSError *error) {
        if (self.themeAlbumTableView.pullToRefreshView && [self.themeAlbumTableView.pullToRefreshView state] == SVPullToRefreshStateLoading) {
            [self.themeAlbumTableView.pullToRefreshView stopAnimating];
        }
        [LoadingView stopOnTheViewController:self];
    }];

}
#pragma mark - UITableViewDataSource Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"ThemeAlbumCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        cell.contentView.backgroundColor = [BBSColor hexStringToColor:@"efe7da"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
      
    }
    for (id view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat x=5.5,y = 3;
    CGRect rect =CGRectMake(x, y, 75, 75);
    NSDictionary *lineDict = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *imgArray = [[NSArray alloc]initWithArray:[lineDict objectForKey:@"img"]];
    for (int i = 0; i < imgArray.count+1; i++) {
        ImageView *img = [[ImageView alloc]initWithFrame:rect];
        img.backgroundColor = [UIColor clearColor];
        img.tag = i;
        if (i == 0) {
            img.imageInfo = nil;
            img.image = [UIImage imageNamed:@"img_theme_play"];
        } else {
            img.image = [UIImage imageNamed:@"img_imgloding"];
            NSDictionary *dict  =[imgArray objectAtIndex:i-1];
            img.imageInfo = dict;
            [img sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"img_thumb"]]];
        }
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        [img addGestureRecognizer:tapGes];
        [cell.contentView addSubview:img];

        x = x + 75 + 3;
        if (x >=300) {
            x = 5.5;
            y = y + 75 + 3.5;
        }
        rect = CGRectMake(x, y, 75, 75);
    }
    if (x<=5.5) {
        y -=78.5;//用于下面的分割线
    }
    CGRect seperatorLineFrame = CGRectMake(0, y+88, SCREENWIDTH, 0.5);
    UIView *seperatorLine = [[UIView alloc]initWithFrame:seperatorLineFrame];
    seperatorLine.backgroundColor = [BBSColor hexStringToColor:@"e9e9e9"];
    [cell.contentView addSubview:seperatorLine];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *lineDict = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *imgArray = [lineDict objectForKey:@"img"];
    return (imgArray.count/4+1)*(75 +3.5)+15;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 42;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSDictionary *lineDict = [self.dataArray objectAtIndex:section];
    double  timeStamp = [[lineDict objectForKey:@"create_time"] doubleValue]/1000;
    NSString *create_time = [DateFormatter dateStringFromDate:[NSDate dateWithTimeIntervalSince1970:timeStamp] formatter:@"yyyy-MM-dd HH:mm:ss"];
    
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 25)];
    aView.backgroundColor = [UIColor whiteColor];
    
    CGRect dayFrame = CGRectMake(8, 7, 40, 30);
    UILabel *dayLabel = [[UILabel alloc]initWithFrame:dayFrame];
    dayLabel.backgroundColor = [UIColor clearColor];
    dayLabel.font = [UIFont boldSystemFontOfSize:30];
    dayLabel.textColor = [BBSColor hexStringToColor:@"b28850"];
    dayLabel.text = [create_time substringWithRange:NSMakeRange(8, 2)];
    [aView addSubview:dayLabel];

    CGRect monthFrame = CGRectMake(45, 8, 80, 15);
    UILabel *monthLabel = [[UILabel alloc]initWithFrame:monthFrame];
    monthLabel.backgroundColor = [UIColor clearColor];
    monthLabel.font = [UIFont boldSystemFontOfSize:15];
    monthLabel.textColor = [BBSColor hexStringToColor:@"b28850"];
    monthLabel.text = [NSString stringWithFormat:@"%@月",[create_time substringWithRange:NSMakeRange(5, 2)]];
    [aView addSubview:monthLabel];
    
    CGRect yearFrame = CGRectMake(45, 24, 80, 13);
    UILabel *yearLabel = [[UILabel alloc]initWithFrame:yearFrame];
    yearLabel.backgroundColor = [UIColor clearColor];
    yearLabel.font = [UIFont systemFontOfSize:13];
    yearLabel.textColor = [BBSColor hexStringToColor:@"c3ad8f"];
    yearLabel.text = [NSString stringWithFormat:@"%@年",[create_time substringWithRange:NSMakeRange(0, 4)]];
    [aView addSubview:yearLabel];
    
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *editImage = [UIImage imageNamed:@"theme_section_edit"];
    [editBtn setBackgroundImage:editImage forState:UIControlStateNormal];
    editBtn.frame = CGRectMake(260, 12, editImage.size.width, editImage.size.height);
    editBtn.tag = section;
    [editBtn addTarget:self action:@selector(toEditThemeAlbum:) forControlEvents:UIControlEventTouchUpInside];
//    [aView addSubview:editBtn];
    
    return aView;
}
- (void)toEditThemeAlbum:(UIButton *)button{
    
    NSDictionary *lineDict = [self.dataArray objectAtIndex:button.tag];
    //子图片
    NSArray *imgArray = [[NSArray alloc]initWithArray:[lineDict objectForKey:@"img"]];
    PhotosEditViewController *editVC=[[PhotosEditViewController alloc]init];
    editVC.dataArray=(NSMutableArray *)imgArray;
    [self.navigationController pushViewController:editVC animated:YES];

    
    //TODO: 去到编辑页面
}
#pragma mark - 点击操作 Methods
- (void)tapImageView:(UITapGestureRecognizer *)tapGes{
    ImageView *imageView = (ImageView *)tapGes.view;
   // UITableViewCell *cell = (UITableViewCell *)[imageView superview].superview.superview;
    UITableViewCell *cell = (UITableViewCell *)[imageView superview].superview;
    NSIndexPath *indexPath = [self.themeAlbumTableView indexPathForCell:cell];
    NSDictionary *lineDict = [self.dataArray objectAtIndex:indexPath.section];
    //子图片
    NSArray *imgArray = [[NSArray alloc]initWithArray:[lineDict objectForKey:@"img"]];
    if (imageView.imageInfo == nil) {
        //播放
        NSLog(@"播放");
        PPTViewController *ppt=[[PPTViewController alloc]init];
        ppt.photosArray=(NSMutableArray *)imgArray;
        ppt.maxPlayNumOnce=3;
        BBSNavigationControllerNotTurn *nav=[[BBSNavigationControllerNotTurn alloc]initWithRootViewController:ppt];
        [self presentViewController:nav animated:YES completion:^{}];
        
        /**
         *  TO:小波:lineDict 为包含了该秀秀的全部字典信息,imgArray 为图片信息数组
         */
    } else {
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        for (int i =0; i < imgArray.count; i++) {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithDictionary:[imgArray objectAtIndex:i]];
            [dict setValue:[NSString stringWithFormat:@"%d/%lu",i+1,(unsigned long)imgArray.count] forKey:@"description"];
            [tempArray addObject:dict];
        }

        [self.mwphotosArray removeAllObjects];
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (int i =0; i < tempArray.count; i++) {
            NSDictionary *dict = (NSDictionary *)[tempArray objectAtIndex:i];
            if (dict) {
                MWPhoto *photo =[[MWPhoto alloc]initWithURL:[NSURL URLWithString:[dict objectForKey:@"img"]] info:dict];
                [arr addObject:photo];
            }
        }
        self.mwphotosArray = arr;
        arr = nil ;
        
        MWPhotoBrowser *browser =[[ MWPhotoBrowser alloc]initWithDelegate:self];
        browser.displayActionButton = YES;
        browser.displayNavArrows = NO;
        browser.displaySelectionButtons = NO;
        browser.alwaysShowControls = NO;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = YES;
        browser.startOnGrid = NO;
        [browser setCurrentPhotoIndex:imageView.tag-1];
        browser.type = self.type;
        browser.needRefresh = NO;
        browser.is_show_album =[[self.formerDict objectForKey:@"is_show_album"]boolValue];
        browser.showTitle = YES;    //只用于本页面在大图页面显示title ,其他地方不适用
        browser.user_id =self.user_id;
        browser.needPlay = YES;         //需要播放
        browser.imgArr = tempArray;    //播放需要的东西
        //        [self.navigationController pushViewController:browser animated:YES];
        BBSNavigationController *nav=[[BBSNavigationController alloc]initWithRootViewController:browser];
        [self presentViewController:nav animated:YES completion:nil];
    }
}
#pragma mark - MWPhotoBrowserDelegate
-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.mwphotosArray.count;
}
-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < self.mwphotosArray.count) {
        return [self.mwphotosArray objectAtIndex:index];
    }
    return nil;
}
@end
