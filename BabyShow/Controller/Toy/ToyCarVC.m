//
//  ToyCarVC.m
//  BabyShow
//
//  Created by WMY on 17/3/1.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyCarVC.h"
#import "NIAttributedLabel.h"
#import "RefreshControl.h"
#import "ToyCarHeadItem.h"
#import "ToyCarDetailCell.h"
#import "ToyCarHeadCell.h"
#import "ToyMessDetailCell.h"
#import "ToyMessDetailItem.h"
#import "ToyCarHeadItem.h"
#import "ToyCarMainItem.h"
#import "LineViewCell.h"
#import "ToyOrderBottomItem.h"
#import "ToyOrderNumberItem.h"
#import "ToyDetailTimeCell.h"
#import "ToyOrderNumberCell.h"
#import "MakeSureMoneyVC.h"
#import "MakeSurePaySureVC.h"
#import "UIImageView+WebCache.h"
#import "ToyLeaseDetailVC.h"
#import "ClickViewController.h"

@interface ToyCarVC ()<RefreshControlDelegate,ToyAddCarCellDelegate,UIAlertViewDelegate>{
    UITableView *_tableView;
    RefreshControl *_refreshControl;
    UIButton *_backBtn;
    UIView *_emptyView;
    UIImageView *_noToyImgView;
    NSMutableArray *_toyCarDataArray;
    NSMutableArray *_toyCarCanDeleteToyArray;//购物车里面可以删除的数组


}
@property(nonatomic,strong)NSString *post_create_carToy;//购物车
@property(nonatomic,strong)UIView *payToys;//结算页面
@property(nonatomic,strong)UIButton *payBtn;//去结算
@property(nonatomic,strong)UILabel *totalLabel;//合计
@property(nonatomic,strong)UILabel *totalMoneyLabel;//合计金额
@property(nonatomic,strong)UIView *carAlertView;//购物车上面的提示页面
@property(nonatomic,strong)UIImageView *alertViewImg;//购物车提示图片
@property(nonatomic,strong)UILabel * alertLabel;//购物车提示的语言
@property(nonatomic,strong)NSString *searchWordAlert;
@property(nonatomic,strong)NSString *isButton;//去结算的按钮
@property(nonatomic,strong)UIView *grayBackView;//导航的透明页面
@property(nonatomic,strong)UIImageView *imgVip;//展示的查看vip大图

@property(nonatomic,strong)YLButton *editBtn;//购物车的编辑按钮
@property(nonatomic,strong)NSMutableArray *deleteArray;//删除选择玩具的数组
@property(nonatomic,assign)BOOL isDeleteToyCar;//是否是在编辑购物车的状态
@property(nonatomic,strong)YLButton *deleteToyCar;//删除
@property(nonatomic,strong)YLButton *selectAllBtn;//全选购物车
@property(nonatomic,assign)BOOL isEditSelect;//编辑按钮是否被选中
@property(nonatomic,assign)BOOL isSelectAll;//全选是否被选中
@property(nonatomic,strong)NSString *carWay;//全部或是单个
@property(nonatomic,strong)NSString *cardsString;//购物车数组

@property(nonatomic,strong)UIButton *goBuyCardBtn;//去购买年卡




@end

@implementation ToyCarVC
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _toyCarDataArray = [NSMutableArray array];
        _toyCarCanDeleteToyArray = [NSMutableArray array];//购物车里面玩具可以删除的数组
        _deleteArray = [NSMutableArray array];//购物车准备删除的玩具
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault]; [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = NO;
    self.automaticallyAdjustsScrollViewInsets=NO;

    _post_create_carToy = NULL;
    [self getToyCarListData];


  }

-(void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBar.barTintColor = [BBSColor hexStringToColor:NAVICOLOR];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault]; [self.navigationController.navigationBar setShadowImage:nil];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets=NO;
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"购物车";
     _post_create_carToy = NULL;
    [self setBackButton];
    [self setHeadViewCar];
    [self setBottomView];
    [self setTableView];
    [self refreshControlInit];
    [self setRightBtn];
    // Do any additional setup after loading the view.
}
#pragma mark 购物车右边的编辑按钮
-(void)setRightBtn{
    _editBtn = [YLButton buttonWithFrame:CGRectMake(SCREENWIDTH-40, 0, 30, 22) type:UIButtonTypeCustom backImage:nil target:self action:@selector(getAskPage) forControlEvents:UIControlEventTouchUpInside];
    _editBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
     UIBarButtonItem  *right = [[UIBarButtonItem alloc]initWithCustomView:_editBtn];
    self.navigationItem.rightBarButtonItem = right;
    [_editBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
    
}
#pragma mark点击编辑或完成
-(void)getAskPage{
    _isEditSelect = !_isEditSelect;
    if (_isEditSelect == YES) {
        [self deleteCarToy];
    }else{
        [self completeDeleteToy];
    }
    
}
#pragma mark 删除状态下面布局
-(void)deleteCarToy{
    [_editBtn setTitle:@"完成" forState:UIControlStateNormal];
    _isDeleteToyCar = YES;
    _isEditSelect = YES;
    _deleteToyCar.hidden = NO;
    _selectAllBtn.hidden = NO;
    self.payBtn.hidden = YES;
    self.totalLabel.hidden = YES;
    [_tableView reloadData];
    self.totalMoneyLabel.hidden = YES;
    
}

#pragma mark 完成状态下的布局
-(void)completeDeleteToy{
    _isDeleteToyCar = NO;
    _isEditSelect = NO;
    _deleteToyCar.hidden = YES;
    _selectAllBtn.hidden = YES;
    _isSelectAll = NO;

    self.payBtn.hidden = NO;
    self.totalLabel.hidden = NO;
    self.totalMoneyLabel.hidden = NO;
    [_tableView reloadData];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    if (_isSelectAll == NO) {
        [self.selectAllBtn setImage:[UIImage imageNamed:@"toy_car_buy_unselect"] forState:UIControlStateNormal];
    }

}

#pragma mark  底部按钮
-(void)setBottomView{
    //底部合计金额的页面
    self.payToys = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT-50, SCREENWIDTH, 50)];
    self.payToys.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.payToys];
    self.payBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.payBtn.frame = CGRectMake(SCREENWIDTH-92, 3, 86, 44);
    [self.payToys addSubview:self.payBtn];
    
    self.totalLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 50, 30)];
    self.totalLabel.font = [UIFont systemFontOfSize:14];
    self.totalLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    [self.payToys addSubview:self.totalLabel];
    
    self.totalMoneyLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.totalLabel.frame.origin.x+self.totalLabel.frame.size.width-15, 10, 185, 30)];
    self.totalMoneyLabel.textColor = [BBSColor hexStringToColor:@"fd6363"];
    self.totalMoneyLabel.font = [UIFont systemFontOfSize:15];
    [self.payToys addSubview:self.totalMoneyLabel];
    [self setDeleteButtons];
}
#pragma mark 删除状态地下布局按钮
-(void)setDeleteButtons{
    //删除购物车的按钮，最开始状态是隐藏的
    self.deleteToyCar = [YLButton buttonWithFrame: CGRectMake(SCREENWIDTH-92, 3, 86, 44) type:UIButtonTypeCustom backImage:[UIImage imageNamed:@"toy_delete_toy_car"] target:self action:@selector(deleteSureToyCar) forControlEvents:UIControlEventTouchUpInside];
    [self.payToys addSubview:self.deleteToyCar];
    self.deleteToyCar.hidden = YES;
    
    self.selectAllBtn = [YLButton buttonWithFrame:CGRectMake(10, 10, 80, 30) type:UIButtonTypeCustom backImage:[UIImage imageNamed:@"toy_car_buy_unselect"] target:self action:@selector(selectAllToyToDelete) forControlEvents:UIControlEventTouchUpInside];
    [self.selectAllBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0,30 )];
    [self.selectAllBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 10, 0, 20)];
    [self.selectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
    [self.selectAllBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.selectAllBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    self.selectAllBtn.hidden = YES;
    [self.payToys addSubview:self.selectAllBtn];
    
}
#pragma mark 点击删除时全选的tableview变化
-(void)selectAllToyToDelete{
    _isSelectAll = !_isSelectAll;
    if (_isSelectAll == YES) {
        [self.selectAllBtn setImage:[UIImage imageNamed:@"toy_car_buy_select"] forState:UIControlStateNormal];
        [_tableView reloadData];
    }else{
        [self.selectAllBtn setImage:[UIImage imageNamed:@"toy_car_buy_unselect"] forState:UIControlStateNormal];
        [_tableView reloadData];
    }
}
#pragma mark  确定删除某个玩具或全选删除
-(void)deleteSureToyCar{
    if (_isSelectAll == YES) {
        //删除全部
        _carWay = @"1";
        [self deleteAlertViewToyCar];
    }else{
        if (_deleteArray.count<=0) {
            [BBSAlert showAlertWithContent:@"您还没选择要删除的玩具哦" andDelegate:self];
        }else{
            
            NSString *cardString = [_deleteArray componentsJoinedByString:@","];
            [self deleteAlertViewToyCar];
            _carWay = @"0";
            _cardsString = cardString;
        }
    }
    
}
#pragma mark 购物车删除最后接口，如果是1的话就是全选，如果是0的话是部分
-(void)deleteAlertViewToyCar{
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确认删除玩具" preferredStyle:UIAlertControllerStyleAlert];
        __weak ToyCarVC *babyVC = self;
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        }];
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [babyVC deleteToyCarAllSure];
        }];
        [alertController addAction:cancelAction];
        [alertController addAction:otherAction];
        [self presentViewController:alertController animated:YES completion:nil];
        
    }else{
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"确认删除玩具" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"继续", nil];
        alertView.tag = 103;
        [alertView show];
    }
}
-(void)deleteToyCarAllSure{
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    [param setObject:LOGIN_USER_ID forKey:@"login_user_id"];
    if ([_carWay isEqualToString:@"1"]) {
        [param setObject:@"1" forKey:@"way"];
    }else{
        [param setObject:@"0" forKey:@"way"];
        [param setObject:_cardsString forKey:@"cart_ids"];
    }
    [[HTTPClient sharedClient]postNewV1:@"ToysCartDel" params:param success:^(NSDictionary *result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *dataDic = result[@"data"];
            NSString *cartCount = dataDic[@"cart_count"];
            if ([cartCount isEqualToString:@"0"]) {
                [self completeDeleteToy];
            }
            _post_create_carToy = NULL;
            [self getToyCarListData];
            [_tableView reloadData];
            [_deleteArray removeAllObjects];
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
        
    }];
}
#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
 if (alertView.tag == 103){
        if (buttonIndex == 0) {
        }else{
            [self deleteToyCarAllSure];
        }
        
    }
    
}

#pragma mark 购物车上的提示页面
-(void)setHeadViewCar{
    self.carAlertView =  [[UIView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH, 35)];
    self.carAlertView.backgroundColor = [BBSColor hexStringToColor:@"fffdf6"];
    [self.view addSubview:self.carAlertView];
    self.alertViewImg = [[UIImageView alloc]initWithFrame:CGRectMake(9, 9, 15, 18)];
    self.alertViewImg.image = [UIImage imageNamed:@"toy_alert"];
    [self.carAlertView addSubview:self.alertViewImg];
    
    self.alertLabel = [[UILabel alloc]initWithFrame:CGRectMake(27, 9, SCREENWIDTH-40, 18)];
    self.alertLabel.textColor = [BBSColor hexStringToColor:@"846943"];
    self.alertLabel.font = [UIFont systemFontOfSize:12];
    self.alertLabel.numberOfLines = 0;
    [self.carAlertView addSubview:self.alertLabel];
    
}
#pragma mark tableview
-(void)setTableView{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,64+44, SCREENWIDTH, SCREENHEIGHT-64-46-44)];
    _tableView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}
#pragma mark- refreshControl

-(void)refreshControlInit{
    _refreshControl                             = [[RefreshControl alloc] initWithScrollView:_tableView delegate:self];
    _refreshControl.topEnabled                  = YES;
    _refreshControl.bottomEnabled               = NO;
    [_refreshControl startRefreshingDirection:RefreshDirectionTop];
    
    
}
- (void)refreshControl:(RefreshControl *)refreshControl didEngageRefreshDirection:(RefreshDirection) direction{
    if (refreshControl == _refreshControl) {
        if (direction == RefreshDirectionTop) {
                _post_create_carToy = NULL;
            }
        }
            [self getToyCarListData];
    
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
#pragma mark 获取购物车的数据
-(void)getToyCarListData{
    NSDictionary *newParam = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",nil];
    UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:@"getCartList" Method:NetMethodGet andParam:newParam];
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:15];
    [request startAsynchronous];
    __weak ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data1 = [dic objectForKey:@"data1"];
            NSString *card_title = data1[@"card_title"];
            NSString *is_card = data1[@"is_card"];
            if (card_title.length <=0) {
                self.carAlertView.hidden = YES;
                _tableView.frame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64-50);
            }else{
                self.carAlertView.hidden = NO;
                    CGFloat cardHeight = [self getHeightByWidth:SCREENWIDTH-40 title:card_title font:[UIFont systemFontOfSize:12]];
                    if (cardHeight <= 12) {
                        cardHeight = 17;
                    }else{
                        cardHeight = cardHeight;
                    }
                    self.alertLabel.frame = CGRectMake(27,9, SCREENWIDTH-40, cardHeight);
                    self.alertLabel.text = card_title;
                    self.carAlertView.frame = CGRectMake(0, 64, SCREENWIDTH, cardHeight+18);
                    _tableView.frame = CGRectMake(0, 64+cardHeight+18, SCREENWIDTH, SCREENHEIGHT-64-50-cardHeight-18);
            }
            //去结算按钮的状态
            self.isButton = data1[@"is_button"];
            [self.payBtn addTarget:self action:@selector(makeSureOrder) forControlEvents:UIControlEventTouchUpInside];
            if ([self.isButton isEqualToString:@"1"]) {
                //显示可以点击
                [self.payBtn setBackgroundImage:[UIImage imageNamed:@"toy_go_pay"] forState:UIControlStateNormal];
            }else{
                [self.payBtn setBackgroundImage:[UIImage imageNamed:@"toy_ungo_pay"] forState:UIControlStateNormal];
            }
            
            self.totalLabel.text = data1[@"total_title"];
            
            NSString *totalMoneyString = data1[@"total_price"];
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:totalMoneyString attributes:@{NSKernAttributeName:@(-1)}];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalMoneyString length])];
            self.totalMoneyLabel.attributedText = attributedString;

            NSArray *dataArray = [dic objectForKey:@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
            NSMutableArray *returnDeleteArray = [NSMutableArray array];
            for (NSDictionary *mainDic in dataArray) {
                NSMutableArray *singleArray = [[NSMutableArray alloc]init];
                NSMutableArray *singleArrayDelete = [[NSMutableArray alloc]init];
                NSString *cart_delete_status = mainDic[@"cart_delete_status"];
                //添加头部的item
                ToyCarHeadItem *titleItem = [[ToyCarHeadItem alloc]init];
                titleItem.toys_title = MBNonEmptyString(mainDic[@"toys_title"]);
                titleItem.isMember = MBNonEmptyString(mainDic[@"is_member"]);
                titleItem.type = MBNonEmptyString(mainDic[@"type"]);
                if ([titleItem.type isEqualToString:@"1"]) {
                    CGFloat heightTitle = [self getHeightByWidth:300 title:titleItem.toys_title font:[UIFont systemFontOfSize:13]];
                    if (heightTitle <=13) {
                        titleItem.cellHeight = 36;
                    }else{
                        titleItem.cellHeight = 20+heightTitle;
                    }
                }else {
                    titleItem.cellHeight = 10;
                }
                [singleArray addObject:titleItem];
                //添加玩具信息的item
                NSArray *toysArray = mainDic[@"toys_info"];
                if (toysArray.count) {
                    for (NSDictionary *toyDic in toysArray) {
                        ToyMessDetailItem *item = [[ToyMessDetailItem alloc]init];
                        item.cart_id = MBNonEmptyString(toyDic[@"cart_id"]);
                        item.business_id = MBNonEmptyString(toyDic[@"business_id"]);
                        item.business_title = MBNonEmptyString(toyDic[@"business_title"]);
                        item.every_price = MBNonEmptyString(toyDic[@"every_price"]);
                        item.img_thumb = MBNonEmptyString(toyDic[@"img_thumb"]);
                        item.check_state = MBNonEmptyString(toyDic[@"check_state"]);
                        item.is_order = MBNonEmptyString(toyDic[@"is_order"]);
                        item.order_id = MBNonEmptyString(toyDic[@"order_id"]);
                        item.descriptionOrder = MBNonEmptyString(toyDic[@"description"]);
                        item.smallImgThumb = MBNonEmptyString(toyDic[@"new_size_img_thumb"]);
                        item.cellHeight = 70+5;
                        [singleArray addObject:item];
                        if ([cart_delete_status isEqualToString:@"1"]) {
                            [singleArrayDelete addObject:item];
                        }
                    }
                }
                [returnArray addObject:singleArray];
                [returnDeleteArray addObject:singleArrayDelete];
            }
            if (returnArray.count == 0) {
                _refreshControl.bottomEnabled = NO;
            }
            if (_isDeleteToyCar == YES) {
                if (returnDeleteArray.count == 0) {
                    _refreshControl.bottomEnabled = NO;
                }
                _refreshControl.topEnabled = NO;
            }
            if (_post_create_carToy == NULL) {
                [_toyCarDataArray removeAllObjects];
                [_toyCarCanDeleteToyArray removeAllObjects];
                _refreshControl.bottomEnabled = YES;
            }
            
            [_toyCarDataArray addObjectsFromArray:returnArray];
            [_toyCarCanDeleteToyArray addObjectsFromArray:returnDeleteArray];//购物车删除状态下面的数组

            if (_toyCarDataArray.count == 0) {
                [self addEmptyHintView];
                _emptyView.hidden = NO;
            }
            [_tableView reloadData];
            [self refreshComplete:_refreshControl];
        }else{
            [self refreshComplete:_refreshControl];
            if (dic) {
                [BBSAlert showAlertWithContent:[dic objectForKey:kBBSReMsg] andDelegate:self];
            }else{
                [BBSAlert showAlertWithContent:@"请刷新"andDelegate:self];
            }
        }
    }];
    [request setFailedBlock:^{
        [self refreshComplete:_refreshControl];
    }];
    
}
#pragma mark 去买年卡
-(void)gotoBuyCard{
    ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
    toyDetailVC.business_id = @"1629";
    [self.navigationController pushViewController:toyDetailVC animated:YES];
 
}
#pragma mark  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_isDeleteToyCar == YES) {
        NSArray *singleDeleteArray = [_toyCarCanDeleteToyArray objectAtIndex:section];
        return [singleDeleteArray count];
    }else{
        NSArray *singArray = [_toyCarDataArray objectAtIndex:section];
        return [singArray count];
 
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_isDeleteToyCar == YES) {
        return _toyCarCanDeleteToyArray.count;
    }else{
        return _toyCarDataArray.count;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isDeleteToyCar == YES) {
        NSArray *singleArray = [_toyCarCanDeleteToyArray objectAtIndex:indexPath.section];
        ToyCarMainItem *item = [singleArray objectAtIndex:indexPath.row];
        return item.cellHeight;
    }else{
        NSArray *singleArray = [_toyCarDataArray objectAtIndex:indexPath.section];
        ToyCarMainItem *item = [singleArray objectAtIndex:indexPath.row];
        return item.cellHeight;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *tableViewCell;
    NSArray *singleArray;
    if (_isDeleteToyCar == YES) {
        singleArray = [_toyCarCanDeleteToyArray objectAtIndex:indexPath.section];
    }else{
        singleArray = [_toyCarDataArray objectAtIndex:indexPath.section];
    }
        ToyCarMainItem *item = [singleArray objectAtIndex:indexPath.row];
        if ([item isKindOfClass:[ToyCarHeadItem class]]){
            ToyCarHeadItem *headItem = (ToyCarHeadItem*)item;
            if ([headItem.type isEqualToString:@"1"]) {
                NSString *identifier = [NSString stringWithFormat:@"TOYCARGEADCELL"];
                ToyCarHeadCell *toyCell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!toyCell) {
                    toyCell = [[ToyCarHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                toyCell.backView.frame = CGRectMake(0, 0, SCREENWIDTH, item.cellHeight);
                toyCell.lineView.frame = CGRectMake(0, item.cellHeight, SCREENWIDTH, 1);
                toyCell.selectionName.text = headItem.toys_title;
                toyCell.selectionName.frame = CGRectMake(15, 10, 300, item.cellHeight-20);
                toyCell.selectionStyle = UITableViewCellSelectionStyleNone;
                tableViewCell = toyCell;
            }else {
                NSString *identifier = [NSString stringWithFormat:@"TOYCARDETAILCELLLINE"];
                LineViewCell *toyCell = [tableView dequeueReusableCellWithIdentifier:identifier];
                if (!toyCell) {
                    toyCell = [[LineViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                }
                toyCell.selectionStyle = UITableViewCellSelectionStyleNone;
                tableViewCell = toyCell;
            }
        }else if([item isKindOfClass:[ToyMessDetailItem class]]){
            ToyMessDetailItem *toyItem = (ToyMessDetailItem*)item;
            NSString *identifier = [NSString stringWithFormat:@"TOYMESSDETAILCELL"];
            ToyMessDetailCell *toyCell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!toyCell) {
                toyCell = [[ToyMessDetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            if (toyItem.img_thumb.length >0) {
                [toyCell.photoView sd_setImageWithURL:[NSURL URLWithString:toyItem.img_thumb]];
            }else{
                toyCell.photoView.image = [UIImage imageNamed:@"img_message_photo"];
            }
            //勾选上的状态
            if (_isDeleteToyCar == YES) {
                //购物车删除的时候的状态
                if (_isSelectAll == YES) {
                    [toyCell.selectBtn setImage:[UIImage imageNamed:@"toy_car_buy_select"] forState:UIControlStateNormal];
                }else{
                    [toyCell.selectBtn setImage:[UIImage imageNamed:@"toy_car_buy_unselect"] forState:UIControlStateNormal];
                }
            }else{
                //勾选上的状态，非购物车状态上的点击
                if ([toyItem.check_state isEqualToString:@"1"]) {
                    [toyCell.selectBtn setImage:[UIImage imageNamed:@"toy_car_buy_select"] forState:UIControlStateNormal];
                }else{
                    [toyCell.selectBtn setImage:[UIImage imageNamed:@"toy_car_buy_unselect"] forState:UIControlStateNormal];
                }
            }
            toyCell.delegate = self;
            toyCell.selectBtn.tag = indexPath.section;
            CGFloat height = [self getHeightByWidth:SCREEN_WIDTH-16-44-50-10-80 title:toyItem.business_title font:[UIFont systemFontOfSize:13]];
            toyCell.toyNameLabel.frame = CGRectMake(toyCell.toyNameLabel.frame.origin.x, toyCell.toyNameLabel.frame.origin.y,   SCREEN_WIDTH-16-44-50-10-80, height);
            toyCell.toyNameLabel.text = toyItem.business_title;
            //有库存
            if ([toyItem.is_order isEqualToString:@"0"]) {
                toyCell.decLabel.text = toyItem.descriptionOrder;
                toyCell.decLabel.textColor = [BBSColor hexStringToColor:@"fd6363"];
            }else{
                toyCell.decLabel.text = toyItem.descriptionOrder;
                toyCell.decLabel.textColor = [BBSColor hexStringToColor:@"9d9d9d"];
            }
            toyCell.decLabel.frame = CGRectMake(toyCell.decLabel.frame.origin.x, toyCell.toyNameLabel.frame.origin.y+height, SCREEN_WIDTH-16-44-50-10-80, 20);
            if (toyItem.smallImgThumb.length > 0) {
                toyCell.vipImgview.hidden = NO;
                UIImage *img = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:toyItem.smallImgThumb]]];
                [toyCell.vipImgview setImage:img forState:UIControlStateNormal];
                [toyCell.vipImgview addTarget:self action:@selector(clickToBigPic) forControlEvents:UIControlEventTouchUpInside];
            }else{
                toyCell.vipImgview.hidden = YES;
            }
            toyCell.priceLabel.text = toyItem.every_price;
            toyCell.selectionStyle = UITableViewCellSelectionStyleNone;
            tableViewCell = toyCell;
        }
        
    return tableViewCell;
}
#pragma mark 查看vip大图
-(void)clickToBigPic{
    if (!_grayBackView) {
        _grayBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREENHEIGHT)];
        _grayBackView.backgroundColor = [BBSColor hexStringToColor:@"65544b" alpha:0.5];
        [self.view addSubview:_grayBackView];
        _imgVip = [[UIImageView alloc]initWithFrame:CGRectMake(45, 120,227, 319)];
        _imgVip.image = [UIImage imageNamed:@"toy_vip"];
        [_grayBackView addSubview:_imgVip];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeNavBack)];
        [_grayBackView addGestureRecognizer:singleTap];
    }else{
        self.grayBackView.frame = CGRectMake(0,0, SCREENWIDTH, SCREENHEIGHT);
        self.imgVip.frame = CGRectMake(45, 120,227, 319);

    }
}
-(void)removeNavBack{
    self.imgVip.frame = CGRectMake(0, 0, 0, 0);
    [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleLightContent];
    [UIView animateWithDuration:1.0 // 动画时长
                          delay:0.0 // 动画延迟
         usingSpringWithDamping:1.0 // 类似弹簧振动效果 0~1它的范围为 0.0f 到 1.0f ，数值越小「弹簧」的振动效果越明显
          initialSpringVelocity:2.0 // 初始速度
                        options:UIViewAnimationOptionCurveEaseInOut // 动画过渡效果
                     animations:^{
                         // code...
                         
                         CGPoint point = CGPointMake(SCREENWIDTH/2, SCREENHEIGHT/2);
                         self.grayBackView.frame = CGRectMake(SCREEN_WIDTH/2, SCREENHEIGHT/2, 0, 0);
                        [self.grayBackView setCenter:point];
                     } completion:^(BOOL finished) {
                     }];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //购物车
    NSArray *singleArray;
    if (_isDeleteToyCar == YES) {
        singleArray = [_toyCarCanDeleteToyArray objectAtIndex:indexPath.section];
    }else{
        singleArray = [_toyCarDataArray objectAtIndex:indexPath.section];
    }
    ToyCarMainItem *item = [singleArray objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[ToyMessDetailItem class]]) {
        ToyMessDetailItem *toyItem = (ToyMessDetailItem*)item;
        ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
        toyDetailVC.business_id = toyItem.business_id;
        [self.navigationController pushViewController:toyDetailVC animated:YES];
    }
}
#pragma mark 勾选按钮 获取cell所在的
-(void)addToyToCar:(UIButton *)btn{
    UIButton *btns = (UIButton*)btn;
    UIView *sup = [btns superview];
    UIView *sup1 = [sup superview];
    UIView *sup2 = [sup1 superview];
    ToyMessDetailCell *cell = (ToyMessDetailCell*)sup2;
    NSInteger section = [[_tableView indexPathForCell:cell]section];
    NSInteger row = [[_tableView indexPathForCell:cell]row];
    NSMutableArray *singleArray;
    if (_isDeleteToyCar == YES) {
        singleArray = [_toyCarCanDeleteToyArray objectAtIndex:section];
    }else{
        singleArray = [_toyCarDataArray objectAtIndex:section];
    }
    ToyMessDetailItem *item = [singleArray objectAtIndex:row];
    if (_isDeleteToyCar == YES) {
        //选择删除的玩具
        if ([cell.selectBtn.imageView.image isEqual:[UIImage imageNamed:@"toy_car_buy_unselect"]]) {
            [cell.selectBtn setImage:[UIImage imageNamed:@"toy_car_buy_select"] forState:UIControlStateNormal];
            [_deleteArray addObject:item.cart_id];
        }else{
            [cell.selectBtn setImage:[UIImage imageNamed:@"toy_car_buy_unselect"] forState:UIControlStateNormal];
            [_deleteArray removeObject:item.cart_id];
        }
    }else{

    //是否有库存
    if ([item.is_order isEqualToString:@"1"]) {
        //无库存
        [BBSAlert showAlertWithContent:item.descriptionOrder andDelegate:self];
    }else{
        NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
        [param setObject:LOGIN_USER_ID forKey:@"login_user_id"];
        [param setObject:item.cart_id forKey:@"cart_id"];
        [param setObject:item.order_id forKey:@"order_id"];
        [[HTTPClient sharedClient]getNewV1:@"editCartCheckState" params:param success:^(NSDictionary *result) {
            if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
                NSDictionary *toyDic = result[@"data"];
                ToyMessDetailItem *item = [[ToyMessDetailItem alloc]init];
                item.cart_id = MBNonEmptyString(toyDic[@"cart_id"]);
                item.business_id = MBNonEmptyString(toyDic[@"business_id"]);
                item.business_title = MBNonEmptyString(toyDic[@"business_title"]);
                item.every_price = MBNonEmptyString(toyDic[@"every_price"]);
                item.img_thumb = MBNonEmptyString(toyDic[@"img_thumb"]);
                item.check_state = MBNonEmptyString(toyDic[@"check_state"]);
                item.is_order = MBNonEmptyString(toyDic[@"is_order"]);
                item.order_id = MBNonEmptyString(toyDic[@"order_id"]);
                item.descriptionOrder = MBNonEmptyString(toyDic[@"description"]);
                item.smallImgThumb = MBNonEmptyString(toyDic[@"new_size_img_thumb"]);
                item.close_order_des = MBNonEmptyString(toyDic[@"close_order_des"]);
                item.cellHeight = 75;
                [singleArray replaceObjectAtIndex:row withObject:item];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:row inSection:section];
                NSArray *indexArray=[NSArray arrayWithObjects:indexPath, nil];
                [_tableView reloadRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationFade];
                self.totalLabel.text = MBNonEmptyString(toyDic[@"total_title"]);
                
                NSString *totalMoneyString = MBNonEmptyString(toyDic[@"total_price"]);
                NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:totalMoneyString attributes:@{NSKernAttributeName:@(-1)}];
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [totalMoneyString length])];
                self.totalMoneyLabel.attributedText = attributedString;
                self.isButton = MBNonEmptyString(toyDic[@"is_button"]);
                if ([self.isButton isEqualToString:@"1"]) {
                    //显示可以点击
                    [self.payBtn setBackgroundImage:[UIImage imageNamed:@"toy_go_pay"] forState:UIControlStateNormal];
                }else{
                    [self.payBtn setBackgroundImage:[UIImage imageNamed:@"toy_ungo_pay"] forState:UIControlStateNormal];
                }
                if (item.close_order_des.length > 0) {
                    [BBSAlert showAlertWithContent:item.close_order_des andDelegate:self];
                }

                
                
            }else{
                [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
            }
        } failed:^(NSError *error) {
            [LoadingView stopOnTheViewController:self];
            [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
        }];
    }
    }
}

#pragma mark 添加购物车之后的结算
-(void)makeSureOrder{
    if ([self.isButton isEqualToString:@"1"]) {
        MakeSurePaySureVC *makeSureVC = [[MakeSurePaySureVC alloc]init];
        makeSureVC.source = @"1";
        makeSureVC.fromWhere = @"4";
        [self.navigationController pushViewController:makeSureVC animated:YES];
    }else{
        [BBSAlert showAlertWithContent:@"请选择要结算的商品" andDelegate:self];
    }
}

#pragma mark 没有订单的时候显示无订单页面
-(void)addEmptyHintView {
    if (_emptyView) {
        return;
    }
    _emptyView=[[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _emptyView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    _emptyView.backgroundColor = [UIColor whiteColor];
    
    UIImage *image;
    
    image = [UIImage imageNamed:@"img_no_toy_car"];
    _noToyImgView =[[UIImageView alloc]initWithImage:image];
    [_noToyImgView setContentMode:UIViewContentModeScaleAspectFill];
    _noToyImgView.clipsToBounds = YES;
    [_emptyView addSubview:_noToyImgView];
    if (ISIPhoneX) {
        _emptyView.frame = CGRectMake(0,44, SCREENWIDTH, SCREENHEIGHT-44);
        //_emptyView.backgroundColor = [UIColor redColor];
        float height = SCREENHEIGHT-44-47-60-90;
        _noToyImgView.frame=CGRectMake((SCREENWIDTH-0.8*height)/2,0, 0.8*height, height);
        
    }else{
        _emptyView.frame = CGRectMake(0,44, SCREENWIDTH, SCREENHEIGHT-44);
        _noToyImgView.frame=CGRectMake(0,0, SCREENWIDTH, SCREENHEIGHT-44-47-44-60);
    }

    
    _noToyImgView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped)];
    [_noToyImgView addGestureRecognizer:singleTap];
    [self.view addSubview:_emptyView];
    
}
#pragma mark 点击去首页
-(void)fingerTapped{
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

#pragma mark 添加返回
-(void)setBackButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 30, 17);
    _backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.adjustsImageWhenHighlighted = NO;
    [_backBtn setImage:[UIImage imageNamed:@"btn_toy_detail_back"] forState:UIControlStateNormal];
    [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 20)];

    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
//传入字符串，控件宽，字体，比较的高，最大的高，最小的高
-(CGFloat)getHeightByWidth:(CGFloat)width title:(NSString*)title font:(UIFont*)font{
    NIAttributedLabel *label = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, width, 0)];
    label.text = title;
    label.font = font;
    label.numberOfLines = 0;
    [label sizeToFit];
    CGFloat height = label.frame.size.height;
    return height;
}

#pragma mark 返回
-(void)back{
        [self.navigationController popViewControllerAnimated:YES];
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
