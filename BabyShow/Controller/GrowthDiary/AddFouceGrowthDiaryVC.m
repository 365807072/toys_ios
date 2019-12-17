//
//  AddFouceGrowthDiaryVC.m
//  BabyShow
//
//  Created by WMY on 15/12/15.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "AddFouceGrowthDiaryVC.h"
#import "SeachTeacherCell.h"
#import "SeachTeacherItem.h"
#import "UIImageView+WebCache.h"
#import "AddChooseFouceVC.h"

@interface AddFouceGrowthDiaryVC ()<UISearchBarDelegate>{
    //搜索结果
    UITableView *searchResultsTableView;
    UISearchBar *theSearchBar;
    NSArray *searchResultsArray;

}
@property(nonatomic,strong)UIView *navigationView;

@end

@implementation AddFouceGrowthDiaryVC
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil//1
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    theSearchBar.hidden = NO;
    
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;
    theSearchBar.hidden = YES;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setNavigationView];
    [self setLeftButton];
    [self setSeacherBar];
    
    // Do any additional setup after loading the view.
}
#pragma mark UI
-(void)setNavigationView
{
    self.navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 64)];
    self.navigationView.backgroundColor = [BBSColor hexStringToColor:NAVICOLOR];
    [self.view addSubview:self.navigationView];
    
}

-(void)setLeftButton{
    CGRect backBtnFrame=CGRectMake(10, 25, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.adjustsImageWhenHighlighted = NO;
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    [self.navigationView addSubview:_backBtn];
}


-(void)setSeacherBar{
    if (theSearchBar) {
        if (![theSearchBar isFirstResponder]) {
            [theSearchBar becomeFirstResponder];
        }
        return;
    }
    
    theSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(35, 20, SCREENWIDTH-50, 44)];
    theSearchBar.placeholder = @"搜索ID号、昵称";
    [theSearchBar setImage:[UIImage imageNamed:@"btn_show_searched"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    
    theSearchBar.tintColor=[BBSColor hexStringToColor:@"f9f3f3"];//光标的颜色
    theSearchBar.delegate = self;

    theSearchBar.tag = 2;
    theSearchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:theSearchBar.bounds.size];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [self.navigationView addSubview:theSearchBar];
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
#pragma mark - 创建搜索结果的TableView Methods
- (void)setSearchResultsTableView{
    if (searchResultsTableView) {
        [searchResultsTableView removeFromSuperview];
        searchResultsTableView = nil;
    }
    
    searchResultsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64) style:UITableViewStylePlain];
    searchResultsTableView.delegate = self;
    searchResultsTableView.dataSource = self;
    searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    searchResultsTableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:searchResultsTableView];
}
#pragma mark -  UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return searchResultsArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
        return 80;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

        NSDictionary *dic = [searchResultsArray objectAtIndex:indexPath.row];
        static NSString *identifierOfSeachGruop = @"identifierOfSeachTeacher";
        SeachTeacherCell *cell= [tableView dequeueReusableCellWithIdentifier:identifierOfSeachGruop];
        if (!cell) {
            cell = [[SeachTeacherCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierOfSeachGruop];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
    [cell.avatarImg  sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"avatar"]]];
    cell.userNameLabel.text = dic[@"nick_name"];
    cell.babyNameLabel.text = dic[@"baby_name"];
    if ([dic[@"idol_type"]boolValue]==YES) {
        cell.fouceImg.hidden = YES;
    }else{
        cell.fouceImg.hidden = NO;
    }
    
        return cell;
    }
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *rowDic = [searchResultsArray objectAtIndex:indexPath.row];
    if ([rowDic[@"idol_type"]boolValue]==YES) {
    }else{

        AddChooseFouceVC *addChooseVC = [[AddChooseFouceVC alloc]init];
        addChooseVC.login_user_id = self.loginUserid;
        addChooseVC.baby_id = rowDic[@"baby_id"];
        addChooseVC.idol_user_id = rowDic[@"user_id"];
        
        [self.navigationController pushViewController:addChooseVC animated:YES];

    }

    
    
}

#pragma mark - UISearchBarDelegate Methods
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
    [searchResultsTableView removeFromSuperview];
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    //    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:NO animated:YES];
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    
    [self searchUserWithWord:searchBar.text];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [self removeDimBackground];
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return  YES;
}
- (void)removeDimBackground{
    
    if ([self.view viewWithTag:3]) {
        UIView *aView = [self.view viewWithTag:3];
        [aView removeFromSuperview];
    }
    
}
- (void)removeTableView:(UITapGestureRecognizer *)tapGes{
    if (searchResultsTableView) {
        [searchResultsTableView removeFromSuperview];
    }
    if (theSearchBar && [theSearchBar isFirstResponder]) {
        theSearchBar.text = @"";
        [theSearchBar resignFirstResponder];
    }
    UIView *aView = (UIView *)tapGes.view;
    [aView removeFromSuperview];
    
    //[theSearchBar removeFromSuperview];
   // theSearchBar = nil;
    
}
#pragma mark - 搜索群 Methods
- (void)searchUserWithWord:(NSString *)keyWord{
    
    [LoadingView startOnTheViewController:self];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,kFindPartUserLogin_user_id,[keyWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],kFindPartUserSearch_word, nil];
    [[HTTPClient sharedClient] getNew:kSearchKindergartenUser params:param success:^(NSDictionary *result) {
        [LoadingView stopOnTheViewController:self];
        if ([[result objectForKey:kBBSSuccess]intValue] == 1) {
            searchResultsArray = [result objectForKey:kBBSData];
            if (searchResultsArray==nil || [searchResultsArray isKindOfClass:[NSNull class]]||searchResultsArray.count == 0){
                [BBSAlert showAlertWithContent:@"未找到相关内容" andDelegate:nil];
                
            } else {
                [self setSearchResultsTableView];
            }
        }else {
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
            
        }
    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
        [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
    }];
    
}

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
