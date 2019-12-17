//
//  LoveBabyFirstVC.m
//  BabyShow
//
//  Created by WMY on 16/4/11.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "LoveBabyFirstVC.h"
#import "MoreSpecialTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "SpecialDetailTVC.h"
#import "SVPullToRefresh.h"
#import "SpecialHeadHotModel.h"
#import "UIButton+WebCache.h"
#import "RefreshControl.h"

@interface LoveBabyFirstVC ()<RefreshControlDelegate>{
    UITableView *_tableViewSpecial;
    NSMutableArray *_arraySpecial;
    RefreshControl *_refreshControl;

}
@property(nonatomic,strong)UITableView *tableViewSpecial;
@property(nonatomic,strong)UIView *headerView;
@property(nonatomic,strong)UIButton *imageButtonBig;
@property(nonatomic,strong)UIButton *imageButtonUp;
@property(nonatomic,strong)UIButton *imageButtonDown;
@property(nonatomic,strong)UILabel *labelBig;
@property(nonatomic,strong)UILabel *labelUp;
@property(nonatomic,strong)UILabel *labelDown;
@property(nonatomic,strong)NSMutableArray *specialHotArray;
@property(nonatomic,strong)UIView *gryBarView;
@property(nonatomic,strong)UILabel *moreColorLine;
@property(nonatomic,strong)UILabel *moreSpecialLabel;

@end

@implementation LoveBabyFirstVC

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil//1
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _arraySpecial = [NSMutableArray array];
        _specialHotArray = [NSMutableArray array];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;

    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.automaticallyAdjustsScrollViewInsets=NO;
    self.lastId = NULL;
    [self setHeaderView];
    [self setTableView];
    [self refreshControlInit];
    // Do any additional setup after loading the view.
}

#pragma mark -refreshControl
-(void)refreshControlInit{
    _refreshControl = [[RefreshControl alloc]initWithScrollView:_tableViewSpecial delegate:self];
    _refreshControl.topEnabled = YES;
    _refreshControl.bottomEnabled = NO;
    [_refreshControl startRefreshingDirection:RefreshDirectionTop];
    
}
-(void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection)direction{
    if (refreshControl == _refreshControl) {
        if (direction == RefreshDirectionTop) {
            self.lastId = NULL;
        }
        [self getHotSpecialData];
        [self getDataSpecial];
    }
}
-(void)refreshComplete :(RefreshControl *)refreshControl{
    if (refreshControl.refreshingDirection==RefreshingDirectionTop)
    {
        [refreshControl finishRefreshingDirection:RefreshDirectionTop];
    }
    else if (refreshControl.refreshingDirection==RefreshingDirectionBottom)
    {
        [refreshControl finishRefreshingDirection:RefreshDirectionBottom];
        
    }
}

#pragma mark UI

-(void)setHeaderView{
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, 280)];
    _headerView.backgroundColor = [UIColor whiteColor];
    UILabel *hotLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 8, 3, 13)];
    hotLabel.backgroundColor = KColorRGB(252, 87, 89, 1);
    [_headerView addSubview:hotLabel];
    
    UILabel *hotSpecialLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, 7, 100, 17)];
    hotSpecialLabel.text = @"热门主题";
    hotSpecialLabel.textColor = [UIColor redColor];
    hotSpecialLabel.font = [UIFont systemFontOfSize:16];
    [_headerView addSubview:hotSpecialLabel];
    
    
    self.imageButtonBig = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imageButtonBig.frame = CGRectMake(5, 27, (SCREENWIDTH-15)*2/3, (SCREENWIDTH-15)*2/3+4);
    [_headerView addSubview:self.imageButtonBig];
    self.labelBig = [[UILabel alloc]initWithFrame:CGRectMake(0, (SCREENWIDTH-15)*2/3+2-20,(SCREENWIDTH-15)*2/3, 22)];
    self.labelBig.backgroundColor = KColorRGB(0,0,0,0.5);
    self.labelBig.font = [UIFont systemFontOfSize:13];
    self.labelBig.text = @"宝宝秀一下";
    self.labelBig.textColor = KColorRGB(251,251,249,1);
    self.labelBig.textAlignment = NSTextAlignmentCenter;
    [self.imageButtonBig addSubview:self.labelBig];
    
    
    
    self.imageButtonUp = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imageButtonUp.frame = CGRectMake((SCREENWIDTH-15)*2/3+10, 27,(SCREENWIDTH-15)/3-2, (SCREENWIDTH-15)/3);
    [_headerView addSubview:self.imageButtonUp];
    
    self.labelUp = [[UILabel alloc]initWithFrame:CGRectMake(0, (SCREENWIDTH-15)/3-20, (SCREENWIDTH-15)/3-2, 20)];
    self.labelUp.backgroundColor = KColorRGB(0,0,0,0.5);
    self.labelUp.font = [UIFont systemFontOfSize:12];
    self.labelUp.text = @"宝宝秀一下";
    self.labelUp.textColor = KColorRGB(251, 251, 249, 1);
    self.labelUp.textAlignment = NSTextAlignmentCenter;
    [self.imageButtonUp addSubview:self.labelUp];
    
    
    self.imageButtonDown = [UIButton buttonWithType:UIButtonTypeSystem];
    self.imageButtonDown.frame = CGRectMake((SCREENWIDTH-15)*2/3+10, 27+4+(SCREENWIDTH-15)/3,(SCREENWIDTH-15)/3, (SCREENWIDTH-15)/3-2);
    self.imageButtonDown.backgroundColor = [UIColor whiteColor];
    [_headerView addSubview:self.imageButtonDown];
    self.labelDown = [[UILabel alloc]initWithFrame:CGRectMake(0, (SCREENWIDTH-15)/3-20, (SCREENWIDTH-15)/3, 20)];
    self.labelDown.backgroundColor = KColorRGB(0,0,0,0.5);
    self.labelDown.font = [UIFont systemFontOfSize:12];
    self.labelDown.text = @"宝宝秀一下";
    self.labelDown.textColor = KColorRGB(251, 251, 249, 1);
    self.labelDown.textAlignment = NSTextAlignmentCenter;
    [self.imageButtonDown addSubview:self.labelDown];
    self.gryBarView = [[UIView alloc]initWithFrame:CGRectMake(0,self.imageButtonBig.frame.origin.y+self.imageButtonBig.frame.size.height+5, SCREENWIDTH, 6)];
    self.gryBarView.backgroundColor = KColorRGB(242, 242, 242, 1);
    [_headerView addSubview:_gryBarView];
    
    self.moreColorLine = [[UILabel alloc]initWithFrame:CGRectMake(10, self.gryBarView.frame.origin.y+13+5, 3, 13)];
    self.moreColorLine.backgroundColor = KColorRGB(252, 87, 89, 1);
    [_headerView addSubview:self.moreColorLine];
    
    self.moreSpecialLabel = [[UILabel alloc]initWithFrame:CGRectMake(17, self.gryBarView.frame.origin.y+12+5, 190, 17)];
    self.moreSpecialLabel.text = @"更多主题";
    self.moreSpecialLabel.textColor = [UIColor redColor];
    [_headerView addSubview:self.moreSpecialLabel];
    self.moreSpecialLabel.font = [UIFont systemFontOfSize:16];
}
-(void)setTableView{
    CGRect tableviewFrame=CGRectMake(0,0, SCREENWIDTH, SCREENHEIGHT-64);
    _tableViewSpecial = [[UITableView alloc]initWithFrame:tableviewFrame];
    _tableViewSpecial.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableViewSpecial.delegate=self;
    _tableViewSpecial.dataSource=self;
    _tableViewSpecial.separatorStyle=UITableViewCellSeparatorStyleNone;
    _tableViewSpecial.showsVerticalScrollIndicator=NO;
    [self.view addSubview:_tableViewSpecial];
    [_tableViewSpecial setTableHeaderView:_headerView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Data
-(void)getDataSpecial{
    NSDictionary *newParam;
    int netType;
    netType = NetStyleSpecialList;
    newParam = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.lastId,@"last_id",nil];
    UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kSpecialList Method:NetMethodGet andParam:newParam];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy| ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    __weak ASIHTTPRequest *blockRequest = request;
    [request setCompletionBlock:^{
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:kBBSSuccess]integerValue] == 1) {
            NSDictionary *dataArray = [dic objectForKey:kBBSData];
            NSMutableArray *returnArray = [NSMutableArray array];
            for (NSDictionary *dataDic in dataArray) {
                MoreSpecialModel *moreSpecialModel = [[MoreSpecialModel alloc]init];
                moreSpecialModel.rank = [[dataDic objectForKey:@"rank"]integerValue];
                moreSpecialModel.cate_name = [dataDic objectForKey:@"cate_name"];
                moreSpecialModel.cate_id = [[dataDic objectForKey:@"cate_id"]integerValue];
                moreSpecialModel.renshu = [[dataDic objectForKey:@"renshu"]integerValue];
                NSArray *imgsArray = [dataDic objectForKey:@"imgs"];
                NSMutableArray *imgssArray = [NSMutableArray array];
                if (imgsArray.count) {
                    for (NSDictionary *imgDic in imgsArray) {
                        NSString *imgString = imgDic[@"img_thumb"];
                        [imgssArray addObject:imgString];
                    }
                    moreSpecialModel.firstImge = imgssArray[0];
                    moreSpecialModel.secondImge = imgssArray[1];
                    moreSpecialModel.thirdImge = imgssArray[2];
                    moreSpecialModel.fourImge = imgssArray[3];
                }
                [returnArray addObject:moreSpecialModel];
            }
            if (returnArray.count == 0) {
                _refreshControl.bottomEnabled = NO;;
            }
            if (self.lastId == NULL) {
                [_arraySpecial removeAllObjects];
                _refreshControl.bottomEnabled = YES;
                
            }
            MoreSpecialModel *item = [returnArray lastObject];
            self.lastId = [NSString stringWithFormat:@"%ld",(long)item.rank] ;
            [_arraySpecial addObjectsFromArray:returnArray];
            [_tableViewSpecial reloadData];
            [self refreshComplete:_refreshControl];
        }else
        {
            [self refreshComplete:_refreshControl];
            [BBSAlert showAlertWithContent:[dic objectForKey:kBBSReMsg] andDelegate:self];
        }
        
        
    }];
    [request setFailedBlock:^{
        [self refreshComplete:_refreshControl];
    }];
    
    
    
}
-(void)getHotSpecialData{
    [_specialHotArray removeAllObjects];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id" ,nil];
    [[HTTPClient sharedClient]getNew:kSpecialHot params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSArray *dataArray = result[@"data"];
            if ([dataArray isKindOfClass:[NSNull class]]||dataArray.count <= 0) {
                NSLog(@"居然是空值");
                
            }else{
                for (NSDictionary *specialDic in dataArray) {
                    SpecialHeadHotModel *specialHotModel = [[SpecialHeadHotModel alloc]init];
                    specialHotModel.cate_name = specialDic[@"cate_name"];
                    NSNumber *a = specialDic[@"cate_id"];
                    specialHotModel.cate_id = [a integerValue];
                    specialHotModel.imgs = specialDic[@"imgs"];
                    [self.specialHotArray addObject:specialHotModel];
                }
                SpecialHeadHotModel *specialHotModel1 = [[SpecialHeadHotModel alloc]init];
                specialHotModel1 = self.specialHotArray[0];
                NSDictionary *imgDic = specialHotModel1.imgs[0];
                NSString *imgString = imgDic[@"img_thumb"];
                [self.imageButtonBig sd_setBackgroundImageWithURL:[NSURL URLWithString:imgString] forState:UIControlStateNormal];
                [self.imageButtonBig addTarget:self action:@selector(pushSpecialViewController:) forControlEvents:UIControlEventTouchUpInside];
                self.imageButtonBig.tag = 400;
                self.labelBig.text = specialHotModel1.cate_name;
                
                
                SpecialHeadHotModel *specialHotModel2 = [[SpecialHeadHotModel alloc]init];
                specialHotModel2 = self.specialHotArray[1];
                NSDictionary *imgDic2 = specialHotModel2.imgs[0];
                NSString *imgString2 = imgDic2[@"img_thumb"];
                [self.imageButtonUp sd_setBackgroundImageWithURL:[NSURL URLWithString:imgString2] forState:UIControlStateNormal];
                [self.imageButtonUp addTarget:self action:@selector(pushSpecialViewController:) forControlEvents:UIControlEventTouchUpInside];
                self.imageButtonUp.tag = 401;
                self.labelUp.text = specialHotModel2.cate_name;
                
                
                SpecialHeadHotModel *specialHotModel3 = [[SpecialHeadHotModel alloc]init];
                specialHotModel3 = self.specialHotArray[2];
                NSDictionary *imgDic3 = specialHotModel3.imgs[0];
                NSString *imgString3 = imgDic3[@"img_thumb"];
                [self.imageButtonDown sd_setBackgroundImageWithURL:[NSURL URLWithString:imgString3] forState:UIControlStateNormal];
                self.imageButtonDown.tag = 402;
                [self.imageButtonDown addTarget:self action:@selector(pushSpecialViewController:) forControlEvents:UIControlEventTouchUpInside];
                self.labelDown.text = specialHotModel3.cate_name;
                
                
            }
            
        }
        
    } failed:^(NSError *error) {
        
    }];
    
}
#pragma mark 跳转页面//未写
-(void)pushSpecialViewController:(id)sender{
    UIButton *buttons = sender;
    NSInteger index = buttons.tag -400;
    SpecialDetailTVC *specialDetailVC = [[SpecialDetailTVC alloc]init];
    SpecialHeadHotModel *specialHotModel = [[SpecialHeadHotModel alloc]init];
    specialHotModel = self.specialHotArray[index];
    
    specialDetailVC.title = specialHotModel.cate_name;
    specialDetailVC.cate_id = specialHotModel.cate_id;
    [self.navigationController pushViewController:specialDetailVC animated:YES];
    
}

#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (_arraySpecial.count) {
        return [_arraySpecial count];
    }
    return 0;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (SCREENWIDTH-10-15)/4+35+6;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identify = @"moreSpecialCell";
    MoreSpecialTableViewCell  *cell = [tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = [[MoreSpecialTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MoreSpecialModel *item  = [_arraySpecial objectAtIndex:indexPath.row];
    cell.nameLabel.text = item.cate_name;
    [cell.firstImageView sd_setImageWithURL:[NSURL URLWithString:item.firstImge] placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
    [cell.secondImageView sd_setImageWithURL:[NSURL URLWithString:item.secondImge] placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
    [cell.thirdImageView sd_setImageWithURL:[NSURL URLWithString:item.thirdImge] placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
    [cell.fourImageView sd_setImageWithURL:[NSURL URLWithString:item.fourImge] placeholderImage:[UIImage imageNamed:@"img_message_photo"]];
    cell.countOfPeopleLabel.text = [NSString stringWithFormat:@"共%ld人参与",(long)item.renshu];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SpecialDetailTVC *specialDtailVC = [[SpecialDetailTVC alloc]init];
    MoreSpecialModel *item = _arraySpecial[indexPath.row];
    specialDtailVC.cate_id = item.cate_id;
    specialDtailVC.title = item.cate_name;
    [self.navigationController pushViewController:specialDtailVC animated:YES];
    
    
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
