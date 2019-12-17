//
//  ToySearchVC.m
//  BabyShow
//
//  Created by WMY on 17/2/9.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToySearchVC.h"
#import "ToyLeaseItem.h"
#import "ToyLeaseListCell.h"
#import "SDWebImageManager.h"
#import "UIImageView+WebCache.h"
#import "ToyLeaseDetailVC.h"
#import "NIAttributedLabel.h"
#import "PurchaseCarAnimationTool.h"
#import "ToyCarVC.h"
#import "LoginHTMLVC.h"
#import "BookToysVC.h"
#import "ToySearchHistoryAndHotItem.h"
#import "ToySearchResultVC.h"
@interface ToySearchVC ()<UISearchBarDelegate,UISearchControllerDelegate,UISearchResultsUpdating,UITableViewDataSource,UITableViewDelegate>{
    UISearchController *searchController;
    UITableView *tableViewSearch;
    UIView *chooseBtnView;
    NSArray *chooseTitleArray;
    NSMutableArray *chooseBtnArray;
    UIView *navigationView;
    UISearchBar *theSearchBar;
    NSMutableArray *searchResultUserArray;
    UILabel *_badgeValueLabel;

}
@property(nonatomic,strong)UIButton *addCarBtn;//购物车
@property(nonatomic,strong)NSDictionary *historyDic;
@property(nonatomic,strong)NSDictionary *hotDic;
@property(nonatomic,strong)UIScrollView *grayScrollview;
@property(nonatomic,strong)UIView *historyView;
@property(nonatomic,strong)UIView *hotView;
@property(nonatomic,strong)NSArray *searchInfoArray;
@property(nonatomic,strong)NSArray *hotArray;
@end

@implementation ToySearchVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleDefault;
    //获取购物车里面的玩具数量
    [self getToyCarCount];
     [self getDataSearchHistoryAndHotData];
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [BBSColor hexStringToColor:@"f9f9f9"];
    [self setSearchBar];
   // [self setLeftButton];
    if (!searchResultUserArray) {
        searchResultUserArray = [NSMutableArray array];
    }
    _grayScrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, navigationView.frame.origin.y+56, SCREEN_WIDTH,SCREEN_HEIGHT-(navigationView.frame.origin.y+56))];
    _grayScrollview.alwaysBounceVertical = YES;
    _grayScrollview.backgroundColor = [BBSColor hexStringToColor:@"f9f9f9"];
    [self.view addSubview:_grayScrollview];
    
    _historyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    _historyView.backgroundColor = [UIColor clearColor];
    [_grayScrollview addSubview:_historyView];
    
    _hotView = [[UIView alloc]initWithFrame:CGRectMake(0, _historyView.frame.origin.y+_historyView.frame.size.height, SCREEN_WIDTH, 0)];
    _hotView.backgroundColor = [UIColor clearColor];
    [_grayScrollview addSubview:_hotView];
    [self setToyCar];
    // Do any additional setup after loading the view.
}
#pragma mark  获取搜素历史记录和热搜榜
-(void)getDataSearchHistoryAndHotData{
       NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
    [_hotView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [_historyView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [[HTTPClient sharedClient]getNewV1:@"getToysSearchList" params:dic success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = result[@"data"];
            NSDictionary *ownDic = data[@"own"];
            NSDictionary *hotDic = data[@"hot"];
            _searchInfoArray = ownDic[@"search_info"];
            _hotArray = hotDic[@"search_info"];
            if (_searchInfoArray.count > 0) {
                UILabel *historyLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 15, SCREEN_WIDTH-50, 15)];
                historyLabel.text = ownDic[@"search_title_name"];
                historyLabel.font = [UIFont systemFontOfSize:14];
                historyLabel.textColor = [UIColor blackColor];
                [_historyView addSubview:historyLabel];
                UIButton *cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                cleanBtn.frame = CGRectMake(SCREEN_WIDTH-70, 12, 58, 20);
                [cleanBtn setImage:[UIImage imageNamed:@"cleanHistory"] forState:UIControlStateNormal];
                [cleanBtn addTarget:self action:@selector(makesureDeleteHistory) forControlEvents:UIControlEventTouchUpInside];
                [_historyView addSubview:cleanBtn];
                CGFloat w = 14;
                CGFloat h = 44;
                for (int i = 0; i < _searchInfoArray.count; i++) {
                    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    searchBtn.tag = 101+i;
                    NSDictionary *searchDic = _searchInfoArray[i];
                    NSString *searchTitle = searchDic[@"search_title"];
                    [searchBtn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
                    searchBtn.backgroundColor = [BBSColor hexStringToColor:@"ececec"];
                    searchBtn.titleLabel.font = [UIFont systemFontOfSize:12];
                    [searchBtn setTitle:searchTitle forState:UIControlStateNormal];
                    [searchBtn addTarget:self action:@selector(searchHistotyAndHot:) forControlEvents:UIControlEventTouchUpInside];
                    [_historyView addSubview:searchBtn];
                    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
                    CGFloat length = [searchTitle boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width+20;
                    searchBtn.frame = CGRectMake(w, h, length, 25);
                    searchBtn.layer.masksToBounds = YES;
                    searchBtn.layer.cornerRadius = 12.5;
                    if (w+length+15 > SCREEN_WIDTH) {
                        w = 14;
                        h = h + searchBtn.frame.size.height+10;
                        searchBtn.frame = CGRectMake(w, h, length, 25);
                    }
                    w = searchBtn.frame.size.width + searchBtn.frame.origin.x+10;
                }
                _historyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, h+25+10);
                UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, h+35, SCREEN_WIDTH, 1)];
                lineView.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
                [_historyView addSubview:lineView];
                //_historyView.backgroundColor = [UIColor redColor];
                
            }else{
                _historyView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 0);

            }
            if (_hotArray.count > 0) {
                UILabel *hotLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 15, SCREEN_WIDTH-50, 15)];
                hotLabel.text = hotDic[@"search_title_name"];
                hotLabel.font = [UIFont systemFontOfSize:14];
                hotLabel.textColor = [UIColor blackColor];
                [_hotView addSubview:hotLabel];
                float hotHeight = 30;
                for (int i = 0; i < _hotArray.count; i++) {
                    NSDictionary *hotDic = _hotArray[i];
                    NSString *hotId = hotDic[@"id"];
                    NSString *hotTitle = hotDic[@"search_title"];
                    UIButton *rankBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                    rankBtn.frame = CGRectMake(0, hotHeight, SCREEN_WIDTH, 30);
                    [_hotView addSubview:rankBtn];
                    rankBtn.adjustsImageWhenHighlighted = NO;
                    rankBtn.tag = 201+i;
                    hotHeight += 30;
                    [rankBtn addTarget:self action:@selector(searchHot:) forControlEvents:UIControlEventTouchUpInside];
                    
                    UILabel *rankCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(14, 10, 18, 18)];
                    rankCountLabel.text = hotId;
                    rankCountLabel.textColor = [UIColor whiteColor];
                    rankCountLabel.layer.masksToBounds = YES;
                    rankCountLabel.layer.cornerRadius = 9;
                    rankCountLabel.textAlignment = NSTextAlignmentCenter;
                    rankCountLabel.font = [UIFont systemFontOfSize:13];
                    [rankBtn addSubview:rankCountLabel];
                    if ([hotId isEqualToString:@"1"]) {
                        rankCountLabel.backgroundColor = [BBSColor hexStringToColor:@"ff6036"];
                    }else if ([hotId isEqualToString:@"2"]){
                        rankCountLabel.backgroundColor = [BBSColor hexStringToColor:@"ff8a63"];
                    }else if ([hotId isEqualToString:@"3"]){
                        rankCountLabel.backgroundColor = [BBSColor hexStringToColor:@"ffd55a"];
                    }else{
                       rankCountLabel.backgroundColor = [BBSColor hexStringToColor:@"d8d8d8"];
                    }
                    UILabel *rankTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 10, SCREEN_WIDTH-35, 18)];
                    rankTextLabel.text = hotTitle;
                    rankTextLabel.textColor = [BBSColor hexStringToColor:@"333333"];
                    rankTextLabel.font = [UIFont systemFontOfSize:13];
                    [rankBtn addSubview:rankTextLabel];
                }
                _hotView.frame = CGRectMake(0, _historyView.frame.origin.y+_historyView.frame.size.height, SCREEN_WIDTH, (_hotArray.count+1)*30);
                
 
            }
            _grayScrollview.contentSize  = CGSizeMake(SCREEN_WIDTH, _hotView.frame.origin.y+_hotView.frame.size.height);
            [self.view bringSubviewToFront:self.addCarBtn];


            
            
        }
        
    } failed:^(NSError *error) {
        
    }];
}
#pragma mark ----- 清空搜素历史------------
-(void)makesureDeleteHistory{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"确认删除全部历史记录" preferredStyle:UIAlertControllerStyleAlert];
    __weak ToySearchVC *babyVC = self;
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    UIAlertAction *otherAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [babyVC deleteDistoryData];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:otherAction];
    [self presentViewController:alertController animated:YES completion:nil];

}
-(void)deleteDistoryData{
       NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id", nil];
     [[HTTPClient sharedClient]getNewV1:@"delToysSearch" params:dic success:^(NSDictionary *result) {
         if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
             [self getDataSearchHistoryAndHotData];
         }
    
} failed:^(NSError *error) {

}];
}
#pragma mark 点击搜素历史和热门搜素之后
-(void)searchHistotyAndHot:(UIButton*)sender{
            NSInteger i = sender.tag -101;
            NSDictionary *searchDic = _searchInfoArray[i];
            NSString *searchTitle = searchDic[@"search_title"];
    [self searchUserWithWord:searchTitle];
}
-(void)searchHot:(UIButton*)sender{
    NSInteger i = sender.tag -201;
    NSDictionary *searchDic = _hotArray[i];
    NSString *searchTitle = searchDic[@"search_title"];
    [self searchUserWithWord:searchTitle];
}

-(void)pushNewToy:(NSString*)businessId{
    ToyLeaseDetailVC *toyDetailVC = [[ToyLeaseDetailVC alloc]init];
    toyDetailVC.business_id = businessId;
    [self.navigationController pushViewController:toyDetailVC animated:YES];

}
#pragma mark 购物车的位置
-(void)setToyCar{
    self.addCarBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addCarBtn.frame = CGRectMake(SCREENWIDTH-80, SCREENHEIGHT-100, 43, 43);
    [self.addCarBtn setBackgroundImage:[UIImage imageNamed:@"toy_car_list"] forState:UIControlStateNormal];
    [self.addCarBtn addTarget:self action:@selector(pushtoyCar) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.addCarBtn];
    //购物车的数量的label
    _badgeValueLabel=[[UILabel alloc]initWithFrame:CGRectMake(35, 0, 20, 20)];
    _badgeValueLabel.backgroundColor=[BBSColor hexStringToColor:@"FF7F7C"];
    _badgeValueLabel.textColor=[UIColor whiteColor];
    _badgeValueLabel.font=[UIFont systemFontOfSize:10];
    _badgeValueLabel.textAlignment=NSTextAlignmentCenter;
    _badgeValueLabel.layer.masksToBounds=YES;
    _badgeValueLabel.layer.cornerRadius=10;
    [self.addCarBtn addSubview:_badgeValueLabel];
    _badgeValueLabel.hidden = NO;
}
#pragma mark 进入购物车
-(void)pushtoyCar{
    if ([self isVisitor] == YES) {
        [self loginIn];
    }else{
        ToyCarVC *toyCarVC = [[ToyCarVC alloc]init];
        [self.navigationController pushViewController:toyCarVC animated:YES];
    }
}
#pragma mark 是否是用户登录还是游客
-(BOOL)isVisitor{
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    if ([userItem.isVisitor boolValue] == YES || LOGIN_USER_ID == NULL) {
        return YES;
    }else{
        return NO;
    }
}
#pragma mark 判断用户身份后的登录
-(void)loginIn{
    LoginHTMLVC *loginVC = [[LoginHTMLVC alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:^{
    }];
    return;
}

#pragma mark 购物车里面的玩具数量
-(void)getToyCarCount{
    NSDictionary *param = [NSDictionary dictionaryWithObject:LOGIN_USER_ID forKey:@"login_user_id"];
    [[HTTPClient sharedClient]getNewV1:@"getToysCartNumber" params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *data = result[@"data"];
            NSString *toyCount = data[@"cart_number"];
            if ([toyCount isEqualToString:@"0"]) {
                _badgeValueLabel.hidden = YES;
            }else{
                _badgeValueLabel.hidden = NO;
                _badgeValueLabel.text = toyCount;
            }
            
        }
    } failed:^(NSError *error) {
        
    }];
}

-(void)setSearchBar{
    navigationView = [[UIView alloc]init];//WithFrame:CGRectMake(0, 0, SCREENWIDTH, 56)];
    if (ISIPhoneX) {
        navigationView.frame = CGRectMake(0, 20, SCREENWIDTH, 56);
    }else{
        navigationView.frame =CGRectMake(0, 0, SCREENWIDTH, 56);

    }
    navigationView.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
    [self.view addSubview:navigationView];
    
    CGRect backBtnFrame = CGRectMake(0, 18, 40, 17+12);
    UIButton* backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.adjustsImageWhenHighlighted = NO;
    [backBtn setImage:[UIImage imageNamed:@"btn_toy_detail_back"] forState:UIControlStateNormal];
    [backBtn setImageEdgeInsets:UIEdgeInsetsMake(12, 10, 0, 20)];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame=backBtnFrame;
    [navigationView addSubview:backBtn];
    if (theSearchBar) {
        if (![theSearchBar isFirstResponder]) {
            [theSearchBar becomeFirstResponder];
        }
        return;
    }
    
    theSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(33, 25, SCREENWIDTH-50, 26)];
    theSearchBar.barTintColor = [BBSColor hexStringToColor:@"ededed"];
    theSearchBar.tintColor = [UIColor blackColor];
    theSearchBar.backgroundImage = [[UIImage alloc] init];
    UITextField *searchField = [theSearchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[BBSColor hexStringToColor:@"ededed"]];
        searchField.layer.masksToBounds = YES;
        if ([[[UIDevice currentDevice]systemVersion]floatValue]>= 11.0 ) {
           // searchField.layer.cornerRadius = 20;

        }else{
            //searchField.layer.cornerRadius = 13;

        }
        searchField.font = [UIFont systemFontOfSize:13];
        searchField.leftView = nil;
        //searchField.backgroundColor = [UIColor redColor];
        //searchField.frame = CGRectMake(searchField.frame.origin.x, searchField.frame.origin.y, 300, searchField.frame.size.height);
        NSLog(@"dddddddddd.hr = %f",searchField.frame.size.height);
    }
    
    theSearchBar.layer.masksToBounds = YES;
    //theSearchBar.layer.cornerRadius = 14.5;
    theSearchBar.tintColor=[BBSColor hexStringToColor:@"666666"];//光标的颜色
   // theSearchBar.backgroundColor = [UIColor yellowColor];
    theSearchBar.delegate = self;
    theSearchBar.tag = 2;
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>= 9) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitleTextAttributes:@{NSForegroundColorAttributeName: [BBSColor hexStringToColor:@"666666"], NSFontAttributeName: [UIFont systemFontOfSize:12]} forState:UIControlStateNormal];

    }else{
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[BBSColor hexStringToColor:@"666666"],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [navigationView addSubview:theSearchBar];
    [UIView commitAnimations];
    
    
}

//取消searchbar背景色
- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}



#pragma mark - UISearchBarDelegate Methods
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchUserWithWord:searchBar.text];
    [searchBar resignFirstResponder];
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:12];
            [cancel setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
            
            cancel.frame = CGRectMake(SCREENWIDTH-85, -5, 35, 34);
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    
   // [self searchUserWithWord:searchBar.text];
    
    [searchBar resignFirstResponder];
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return  YES;
}
-(void)searchUserWithWord:(NSString*)keyWord{
   // [self setTableView];
    

    [theSearchBar resignFirstResponder];
    //[LoadingView startOnTheViewController:self];
    ToySearchResultVC *toySearchResultVc = [[ToySearchResultVC alloc]init];
    
    toySearchResultVc.businessId = keyWord;
    [self.navigationController pushViewController:toySearchResultVc animated:NO];
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:NO];
    
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
