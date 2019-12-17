//
//  SearchResultVC.m
//  BabyShow
//
//  Created by WMY on 16/8/2.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "SearchResultVC.h"
#import "StoreMoreListCell.h"
#import "SearchUserItem.h"
#import "PostMyInterestCell.h"
#import "SDWebImageManager.h"
#import "MyHomeNewVersionVC.h"
#import "StoreDetailNewVC.h"
#import "PostBarNewDetialV1VC.h"
#import "PostMyGroupDetailVController.h"
#import "BabyShowPlayerVC.h"
#import "PostBarGroupNewVC.h"
#import "PostBarNewGroupOnlyOneVC.h"

@interface SearchResultVC ()<UISearchControllerDelegate,UISearchResultsUpdating,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
    //searchController
    UISearchController *searchController;
    UITableView *tableViewSearch;
    UIView *chooseBtnView;
    NSArray *chooseTitleArray;
    NSMutableArray *chooseBtnArray;
    UIView *navigationView;
    UISearchBar *theSearchBar;
    NSMutableArray *searchResultUserArray;
     NSInteger      btnTag;
}

@end

@implementation SearchResultVC
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBarHidden = YES;
    
    if (!searchResultUserArray) {
        searchResultUserArray = [NSMutableArray array];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden = NO;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setSearchBar];
    [self setChooseSearchBtn];
    [self setTableView];
    [self setLeftButton];
    btnTag = 6001;
    
    // Do any additional setup after loading the view.
}
-(void)setSearchBar{
    navigationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, StatusAndNavBar_HEIGHT)];
    navigationView.backgroundColor = [BBSColor hexStringToColor:NAVICOLOR ];
    [self.view addSubview:navigationView];
    
    if (theSearchBar) {
        if (![theSearchBar isFirstResponder]) {
            [theSearchBar becomeFirstResponder];
        }
        return;
    }
    
    theSearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(35, StatusBar_HEIGHT + 5, SCREENWIDTH-50, 30)];
    theSearchBar.placeholder = @"搜索";
    [theSearchBar setImage:[UIImage imageNamed:@"btn_show_searched"] forSearchBarIcon:UISearchBarIconSearch state:UIControlStateNormal];
    UITextField *searchField = [theSearchBar valueForKey:@"searchField"];
    if (searchField) {
        [searchField setBackgroundColor:[UIColor whiteColor]];
        searchField.layer.cornerRadius = 14;
        searchField.layer.masksToBounds = YES;
        searchField.font = [UIFont systemFontOfSize:13];
    }

    theSearchBar.layer.masksToBounds = YES;
    theSearchBar.layer.cornerRadius = 15;
    theSearchBar.tintColor=[BBSColor hexStringToColor:@"f9f3f3"];//光标的颜色
    theSearchBar.delegate = self;
    
    theSearchBar.tag = 2;
    theSearchBar.backgroundImage = [self imageWithColor:[UIColor clearColor] size:theSearchBar.bounds.size];
    
    
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

-(void)setLeftButton{
    CGRect backBtnFrame=CGRectMake(0, StatusBar_HEIGHT + 5, 55, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.adjustsImageWhenHighlighted = NO;
    
    [_backBtn setImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    //_backBtn.backgroundColor = [UIColor redColor];
    [_backBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    [navigationView addSubview:_backBtn];
}

-(void)setChooseSearchBtn{
    chooseBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, StatusAndNavBar_HEIGHT, SCREENWIDTH, 41)];
    chooseBtnView.backgroundColor = [UIColor whiteColor];
    chooseTitleArray = [NSArray arrayWithObjects:@"用户",@"商家",@"帖子",@"群", nil];
    chooseBtnArray = [NSMutableArray array];
    for (int i = 0; i < 4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20+i*(62+10), 10, 62, 20);
        btn.tag = 6001+i;
        NSString *title = chooseTitleArray[i];
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:[BBSColor hexStringToColor:@"666666"] forState:UIControlStateNormal];
        [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -22, 0, 20)];
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"btn_select_pay"] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:@"btn_unselect_pay"] forState:UIControlStateNormal];
        }
        
        [btn setImageEdgeInsets:UIEdgeInsetsMake(2, 37,2, 8)];
        [btn addTarget:self action:@selector(chooseTag:) forControlEvents:UIControlEventTouchUpInside];
        [chooseBtnArray addObject:btn];
        [chooseBtnView addSubview:btn];
    }
}
-(void)chooseTag:(UIButton*)btn{
    
    for (int i = 0; i < 4; i++) {
        if (i == btn.tag-6001) {
            [chooseBtnArray[i] setImage:[UIImage imageNamed:@"btn_select_pay"] forState:UIControlStateNormal];
        }else{
            [chooseBtnArray[i] setImage:[UIImage imageNamed:@"btn_unselect_pay"] forState:UIControlStateNormal];
        }
    }
    
    btnTag = btn.tag;
    if (theSearchBar.text.length>0) {
        [self searchUserWithWord:theSearchBar.text];
    }
    [tableViewSearch reloadData];
}
-(void)setTableView{
    tableViewSearch = [[UITableView alloc]initWithFrame:CGRectMake(0, StatusAndNavBar_HEIGHT, SCREENWIDTH, SCREENHEIGHT-StatusAndNavBar_HEIGHT)];
    tableViewSearch.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    tableViewSearch.tableHeaderView = chooseBtnView;
    tableViewSearch.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableViewSearch.delegate = self;
    tableViewSearch.dataSource = self;
    [self.view addSubview:tableViewSearch];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITableViewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [searchResultUserArray count];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (btnTag == 6001) {
        //用户
        return 50;
    }else if (btnTag == 6002){
        //商家
        return 100;
    }else if (btnTag == 6003){
        //帖子
        return 78;
        
    }else if (btnTag == 6004){
        //群
        return 78;
    }
    return 100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *returnCell;
    SearchUserItem *item  = [searchResultUserArray objectAtIndex:indexPath.row];
    if (btnTag == 6001) {
        //用户
        static NSString *identifier = @"identifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        for (UIView *subView in cell.contentView.subviews) {
            [subView removeFromSuperview];
        }
        
        UIImageView *avatarImgV = [[UIImageView alloc]initWithFrame:CGRectMake(8, 6, 38, 38)];
        avatarImgV.image = [UIImage imageNamed:@"img_message_avatar_100"];
        avatarImgV.layer.masksToBounds = YES;
        avatarImgV.layer.cornerRadius = 19.0;
        [cell.contentView addSubview:avatarImgV];
        
        UILabel *nicknameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50, 10, 250, 30)];
        nicknameLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:nicknameLabel];
        
        UIView *seperatorLine = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, SCREENWIDTH, 0.5)];
        seperatorLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line"]];
        [cell.contentView addSubview:seperatorLine];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",item.img_thumb]];
        [[SDWebImageManager sharedManager]downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            avatarImgV.image = image;
        }];
        
        nicknameLabel.text = [NSString stringWithFormat:@"%@",item.search_word];
        
        returnCell = cell;

    }else if (btnTag == 6002){
        //商家
        NSString *identifier = [NSString stringWithFormat:@"STOREMORELIST"];
        StoreMoreListCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[StoreMoreListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
        }
        if (!(item.img_thumb.length <= 0)) {
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:item.img_thumb] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                cell.imgBusinessPic.image = image;
            }];
        }
        cell.labelPriceShowNumber.text = [NSString stringWithFormat:@"¥%@",item.babyshow_price];
        
        NSDictionary *attributes = @{NSFontAttributeName:cell.labelPriceShowNumber.font};
        CGSize size = [cell.labelPriceShowNumber.text sizeWithAttributes:attributes];
        
        cell.labelPriceShowNumber.frame = CGRectMake(cell.labelPriceShowNumber.frame.origin.x, cell.labelPriceShowNumber.frame.origin.y, size.width+10, 15);
        
        cell.labelDeletePrice.frame = CGRectMake(cell.labelPriceShowNumber.frame.origin.x+size.width+10, cell.labelDeletePrice.frame.origin.y, 60, 15);
        
        cell.labelDeletePrice.text = [NSString stringWithFormat:@"¥%@",item.market_price];
        cell.labelBusinessTitle.text = item.search_word;
        cell.labelSubtitle.text = item.img_description;
        cell.buyPeopleCount.text = [NSString stringWithFormat:@"%@人购买",item.order_count];
        if (item.distance.length >0) {
            cell.labelPostCreatTime.text = [NSString stringWithFormat:@"%@",item.distance];
            
        }else{
            cell.labelPostCreatTime.hidden = YES;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        returnCell = cell;


       
    }else if (btnTag == 6003){
        //帖子
        NSString *identifier = [NSString stringWithFormat:@"POSTMYINTERESTCELL"];
        PostMyInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PostMyInterestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
        }
        cell.label.frame = CGRectMake(0, 77, SCREENWIDTH, 1);
        if (!(item.img_thumb.length <= 0)) {
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:item.img_thumb] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                cell.photoView.frame = CGRectMake(10, 10, 60, 60);
                cell.photoView.image = image;
                
            }];
            cell.titleLabel.frame = CGRectMake(80, 8, 220, 20);
            cell.reviewLabel.frame = CGRectMake(80, 33, 200, 18);
            cell.descriptionLabel.frame = CGRectMake(80, 57, 213, 17);
            
            
        }else
        {
            cell.photoView.frame = CGRectMake(0, 0, 0, 0);
            cell.titleLabel.frame = CGRectMake(10, 8, 250, 20);
            cell.reviewLabel.frame = CGRectMake(10, 35, 200, 18);
            cell.descriptionLabel.frame = CGRectMake(10, 57, 213, 17);
            cell.videoView.frame = CGRectMake(0, 0, 0, 0);
        }
        if ([item.is_group isEqualToString:@"1" ]) {
            cell.groupImageV.frame = CGRectMake(0, 2, 40, 18);
            CGFloat a = cell.titleLabel.frame.size.width -25;
            cell.groupImageV.image = [UIImage imageNamed:@"img_group_logo"];
            cell.titleLabelS.frame = CGRectMake(41, 0, a, 40);
            cell.photoView.layer.masksToBounds = YES;
            cell.photoView.layer.cornerRadius = 30;
            cell.videoView.frame = CGRectMake(0, 0, 0, 0);
        }else  if([item.is_group isEqualToString:@"1" ]){
            cell.groupImageV.frame = CGRectMake(0, 2, 20, 20);
            cell.groupImageV.image = [UIImage imageNamed:@"img_post_store@2x"];
            CGFloat a = cell.titleLabel.frame.size.width -20;
            cell.titleLabelS.frame = CGRectMake(21, 0, a, 23);
            cell.photoView.layer.masksToBounds = NO;
            cell.videoView.frame = CGRectMake(0, 0, 0, 0);
            
        }else if ([item.is_group isEqualToString:@"5"] && !(item.img_thumb.length <= 0)){
            CGFloat b = cell.titleLabel.frame.size.width;
            cell.groupImageV.frame = CGRectMake(0, 0, 0, 0);
            cell.titleLabelS.frame = CGRectMake(0, 0, b, 23);
            cell.photoView.layer.masksToBounds = NO;
            cell.videoView.frame = CGRectMake(20, 22, 67*0.5, 67*0.5);
            
        }else{
            CGFloat b = cell.titleLabel.frame.size.width;
            cell.groupImageV.frame = CGRectMake(0, 0, 0, 0);
            cell.titleLabelS.frame = CGRectMake(0, 0, b, 23);
            cell.photoView.layer.masksToBounds = NO;
            cell.videoView.frame = CGRectMake(0, 0, 0, 0);
            
        }
        //判断title
        //判断title
        if ([item.is_group isEqualToString:@"1"]) {
            cell.titleLabelS.text = item.search_word;
            cell.reviewLabel.text = [NSString stringWithFormat:@"参与%@人  帖子%@个",item.review_count,item.post_count];
            cell.descriptionLabel.text = nil;
            
        } else if(item.is_group == 0){
            cell.titleLabelS.text = item.search_word;
            cell.reviewLabel.text = [NSString stringWithFormat:@"参与%@人  观看%@人",item.review_count,item.post_count];
            cell.descriptionLabel.text = item.img_description;
            cell.descriptionLabel.textColor = [BBSColor hexStringToColor:@"#878787"];
        }else{
            cell.titleLabelS.text = item.search_word;
            cell.reviewLabel.text = [NSString stringWithFormat:@"参与%@人  观看%@人",item.review_count,item.post_count];
            cell.descriptionLabel.text = item.img_description;
            cell.descriptionLabel.textColor = [BBSColor hexStringToColor:@"#878787"];
            
        }
        [cell.photoView setContentMode:UIViewContentModeScaleAspectFill];
        cell.photoView.clipsToBounds = YES;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        returnCell = cell;
        
    }else if (btnTag == 6004){
        //群
        //帖子
        NSString *identifier = [NSString stringWithFormat:@"POSTMYINTERESTCELL"];
        PostMyInterestCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[PostMyInterestCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
        }
        cell.label.frame = CGRectMake(0, 77, SCREENWIDTH, 1);
        if (!(item.img_thumb.length <= 0)) {
            SDWebImageManager *manager = [SDWebImageManager sharedManager];
            [manager downloadImageWithURL:[NSURL URLWithString:item.img_thumb] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                cell.photoView.frame = CGRectMake(10, 10, 60, 60);
                cell.photoView.image = image;
                
            }];
            cell.titleLabel.frame = CGRectMake(80, 8, 220, 20);
            cell.reviewLabel.frame = CGRectMake(80, 33, 200, 18);
            cell.descriptionLabel.frame = CGRectMake(80, 57, 213, 17);
            
            
        }else
        {
            cell.photoView.frame = CGRectMake(0, 0, 0, 0);
            cell.titleLabel.frame = CGRectMake(10, 8, 250, 20);
            cell.reviewLabel.frame = CGRectMake(10, 35, 200, 18);
            cell.descriptionLabel.frame = CGRectMake(10, 57, 213, 17);
            cell.videoView.frame = CGRectMake(0, 0, 0, 0);
        }
        if ([item.is_group isEqualToString:@"1" ]) {
            cell.groupImageV.frame = CGRectMake(0, 2, 40, 18);
            CGFloat a = cell.titleLabel.frame.size.width -25;
            cell.groupImageV.image = [UIImage imageNamed:@"img_group_logo"];
            cell.titleLabelS.frame = CGRectMake(41, 0, a, 20);
            
            cell.photoView.layer.masksToBounds = YES;
            cell.photoView.layer.cornerRadius = 30;
            cell.videoView.frame = CGRectMake(0, 0, 0, 0);
        }else  if([item.is_group isEqualToString:@"2" ]){
            cell.groupImageV.frame = CGRectMake(0, 2, 20, 20);
            cell.groupImageV.image = [UIImage imageNamed:@"img_post_store@2x"];
            CGFloat a = cell.titleLabel.frame.size.width -20;
            cell.titleLabelS.frame = CGRectMake(21, 0, a, 23);
            cell.photoView.layer.masksToBounds = NO;
            cell.videoView.frame = CGRectMake(0, 0, 0, 0);
            
        }else if ([item.is_group isEqualToString:@"5"] && !(item.img_thumb.length <= 0)){
            CGFloat b = cell.titleLabel.frame.size.width;
            cell.groupImageV.frame = CGRectMake(0, 0, 0, 0);
            cell.titleLabelS.frame = CGRectMake(0, 0, b, 23);
            cell.photoView.layer.masksToBounds = NO;
            cell.videoView.frame = CGRectMake(20, 22, 67*0.5, 67*0.5);
            
        }else{
            CGFloat b = cell.titleLabel.frame.size.width;
            cell.groupImageV.frame = CGRectMake(0, 0, 0, 0);
            cell.titleLabelS.frame = CGRectMake(0, 0, b, 23);
            cell.photoView.layer.masksToBounds = NO;
            cell.videoView.frame = CGRectMake(0, 0, 0, 0);
            
        }
        
        //判断title
        //判断title
        if ([item.is_group isEqualToString:@"1"]) {
            cell.titleLabelS.text = item.search_word;
            cell.reviewLabel.text = [NSString stringWithFormat:@"参与%@人  帖子%@个",item.review_count,item.post_count];
            cell.descriptionLabel.text = nil;
            
        } else if(item.is_group == 0){
            cell.titleLabelS.text = item.search_word;
            cell.reviewLabel.text = [NSString stringWithFormat:@"参与%@人  观看%@人",item.review_count,item.post_count];
            cell.descriptionLabel.text = item.img_description;
            cell.descriptionLabel.textColor = [BBSColor hexStringToColor:@"#878787"];
        }else{
            cell.titleLabelS.text = item.search_word;
            cell.reviewLabel.text = [NSString stringWithFormat:@"参与%@人  观看%@人",item.review_count,item.post_count];
            cell.descriptionLabel.text = item.img_description;
            cell.descriptionLabel.textColor = [BBSColor hexStringToColor:@"#878787"];
            
        }
        [cell.photoView setContentMode:UIViewContentModeScaleAspectFill];
        cell.photoView.clipsToBounds = YES;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        returnCell = cell;

    }

    return returnCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SearchUserItem *item  = [searchResultUserArray objectAtIndex:indexPath.row];
    if (btnTag == 6001) {
        //用户
        MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
        myHomePage.userid = item.search_id;
        NSString *loginUserId=LOGIN_USER_ID;
        if ([loginUserId integerValue]==[item.search_id integerValue]) {
            myHomePage.Type=0;
        }else{
            myHomePage.Type=1;
        }
        myHomePage.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:myHomePage animated:YES];
        
    }else if (btnTag == 6002){
        //商家
        StoreDetailNewVC *storeVC = [[StoreDetailNewVC alloc]init];
        storeVC.longin_user_id = LOGIN_USER_ID;
        storeVC.business_id = item.search_id;
        [self.navigationController pushViewController:storeVC animated:YES];


    }else if (btnTag == 6003){
        //帖子
        if (item.video_url.length > 0) {
            BabyShowPlayerVC *babyShowPlayerVC = [[BabyShowPlayerVC alloc]init];
            babyShowPlayerVC.img_id = item.search_id;
            babyShowPlayerVC.videoUrl = item.video_url;
            [self.navigationController pushViewController:babyShowPlayerVC animated:YES];

        }else{
        PostBarNewDetialV1VC *detailVC=[[PostBarNewDetialV1VC alloc]init];
        detailVC.img_id=item.search_id;
        detailVC.login_user_id=LOGIN_USER_ID;
        detailVC.refreshInVC = ^(BOOL isRefresh){
            if (isRefresh == YES) {
            }
        };
        
        //detailVC.isSaved=item.isSaved;啊
        [detailVC setHidesBottomBarWhenPushed:YES];
        [self.navigationController pushViewController:detailVC animated:YES];
        }
        
    }else if (btnTag == 6004){
        //群

        PostBarNewGroupOnlyOneVC *postBarVC = [[PostBarNewGroupOnlyOneVC alloc]init];
        postBarVC.group_id = [item.search_id intValue];
        [self.navigationController pushViewController:postBarVC animated:YES];
    }

    
}
#pragma mark - UISearchBarDelegate Methods
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [searchBar setShowsCancelButton:YES animated:YES];
        return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@"searchBarShouldEndEditing");
    
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"这是搜素的");
   // [self searchUserWithWord:searchBar.text];

    [searchBar setShowsCancelButton:NO animated:YES];
    
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self searchUserWithWord:searchBar.text];
    NSLog(@"searchBarSearchButtonClicked");

    [searchBar resignFirstResponder];
    
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for(UIView *view in  [[[searchBar subviews] objectAtIndex:0] subviews]) {
        if([view isKindOfClass:[NSClassFromString(@"UINavigationButton") class]]) {
            UIButton * cancel =(UIButton *)view;
            [cancel setTitle:@"搜索" forState:UIControlStateNormal];
            cancel.titleLabel.font = [UIFont systemFontOfSize:14];
            cancel.frame = CGRectMake(SCREENWIDTH-50-10-35, -1, 35, 34);
        }
    }
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self searchUserWithWord:searchBar.text];

    [searchBar resignFirstResponder];
}
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return  YES;
}

-(void)searchUserWithWord:(NSString*)keyWord{
    [theSearchBar resignFirstResponder];
      [LoadingView startOnTheViewController:self];
       NSInteger search_class = btnTag-6000;
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,kFindPartUserLogin_user_id,[NSString stringWithFormat:@"%ld",search_class],@"search_class",[keyWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],kFindPartUserSearch_word, nil];
    [searchResultUserArray removeAllObjects];

    [[HTTPClient sharedClient]getNewV1:ksearchInformation params:param success:^(NSDictionary *result) {
        [LoadingView stopOnTheViewController:self];
        if ([[result objectForKey:kBBSSuccess]intValue] == 1) {
            NSArray *dataArray = [result objectForKey:@"data"];
            for (NSDictionary *dataDic in dataArray) {
                SearchUserItem *item = [[SearchUserItem alloc]init];
                item.search_id = MBNonEmptyString(dataDic[@"search_id"]);
                item.search_word = MBNonEmptyString(dataDic[@"search_word"]);
                item.img_description = MBNonEmptyString(dataDic[@"img_description"]);
                item.img_thumb = MBNonEmptyString(dataDic[@"img_thumb"]);
                item.is_group = MBNonEmptyString(dataDic[@"is_group"]);
                item.distance = MBNonEmptyString(dataDic[@"distance"]);
                item.order_count = MBNonEmptyString(dataDic[@"order_count"]);
                item.market_price = MBNonEmptyString(dataDic[@"market_price"]);
                item.babyshow_price = MBNonEmptyString(dataDic[@"babyshow_price"]);
                item.review_count = MBNonEmptyString(dataDic[@"review_count"]);
                item.post_count = MBNonEmptyString(dataDic[@"post_count"]);
                item.video_url = MBNonEmptyString(dataDic[@"video_url"]);
                [searchResultUserArray addObject:item];
            }
            if (dataArray.count == 0) {
                [LoadingView stopOnTheViewController:self];
                [BBSAlert showAlertWithContent:@"没有找到相关内容" andDelegate:self];
            }
            [tableViewSearch reloadData];
            
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
            [LoadingView stopOnTheViewController:self];

        }
    } failed:^(NSError *error) {
        
        [LoadingView stopOnTheViewController:self];

    }];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:NO];
    
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
