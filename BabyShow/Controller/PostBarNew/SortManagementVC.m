//
//  SortManagementVC.m
//  BabyShow
//
//  Created by WMY on 16/9/18.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "SortManagementVC.h"
#import "SortManagementCell.h"
#import "SortClassItem.h"
#import "AddNewSortCell.h"

@interface SortManagementVC ()<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_tableViewNew;
    NSMutableArray *tableArray;//数组
}
@property(nonatomic,strong)YLButton *backBtn;
@property(nonatomic,strong)NSString *group_class_id;
@property(nonatomic,strong)NSString *titleClass;

@end

@implementation SortManagementVC
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tabBarController.tabBar.hidden = YES;


}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!tableArray) {
        tableArray = [NSMutableArray array];
    }
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setTableView];
    [self setLeftButton];
    self.navigationItem.title = @"分类管理";
    [self getSortData];

    // Do any additional setup after loading the view.
}
-(void)setTableView{
    _tableViewNew = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64)];
    _tableViewNew.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    _tableViewNew.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableViewNew.showsVerticalScrollIndicator = NO;
    _tableViewNew.delegate = self;
    _tableViewNew.dataSource = self;
    [self.view addSubview:_tableViewNew];
    
}
-(void)setLeftButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)getSortData{
   NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",[NSString stringWithFormat:@"%ld",self.groupId],@"group_id", nil];
    UrlMaker *urlMark = [[UrlMaker alloc]initWithNewV1UrlStr:kgetGroupCategory Method:NetMethodGet andParam:params];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMark.url];
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    __weak ASIHTTPRequest *blockRequest=request;
    [request setCompletionBlock:^{
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:@"success"]integerValue] == 1) {
            NSArray *dataArray = [dic objectForKey:@"data"];
            NSMutableArray *returnArray = [NSMutableArray array];
             for (NSDictionary *dataDic in dataArray) {
                 SortClassItem *item = [[SortClassItem alloc]init];
                 item.group_class_id = MBNonEmptyString(dataDic[@"group_class_id"]);
                 item.title = MBNonEmptyString(dataDic[@"title"]);
                 [returnArray addObject:item];
             }
            [tableArray removeAllObjects];
            [tableArray addObjectsFromArray:returnArray];
            [_tableViewNew reloadData];
        }
        
    }];
    [request setFailedBlock:^{
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return tableArray.count+1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == tableArray.count) {
        return 120;
    }
    return 53;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *returnCell;
    if (indexPath.row == tableArray.count) {
        static NSString *identifier = @"AddsortManagementCell";
        AddNewSortCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil) {
            cell = [[AddNewSortCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.addNewSortBtn.tag = indexPath.row;
        [cell.addNewSortBtn addTarget:self action:@selector(addNewSortClass) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor =[BBSColor hexStringToColor:@"f5f5f5"];
        returnCell = cell;
        
    }else{
    static NSString *identifier = @"sortManagementCell";
    SortClassItem *item = [tableArray objectAtIndex:indexPath.row];
    SortManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[SortManagementCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.editBtn.tag = indexPath.row;
    cell.deleBtn.tag = indexPath.row;
    cell.smallDeleBtn.tag = indexPath.row;
    cell.rankLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row+1];
    cell.sortLabel.text = [NSString stringWithFormat:@"%@",item.title];
    [cell.deleBtn addTarget:self action:@selector(deleteSort:) forControlEvents:UIControlEventTouchUpInside];
    [cell.smallDeleBtn addTarget:self action:@selector(deleteSort:) forControlEvents:UIControlEventTouchUpInside];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
        returnCell = cell;
    }
    return returnCell;
}
-(void)addNewSortClass{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"添加分类" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"添加", nil];
    alert.tag = 702;
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    SortClassItem *item = [tableArray objectAtIndex:indexPath.row];
    [self editSortName:item.title groupClassId:item.group_class_id];
    
}
-(void)editSortName:(NSString*)name groupClassId:(NSString *)groupClassId{
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"修改类名" message:name delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
    self.group_class_id = groupClassId;
    self.titleClass = name;
    alert.tag = 700;
    alert.alertViewStyle=UIAlertViewStylePlainTextInput;
    [alert show];

}
-(void)deleteSort:(id)sender{
    UIButton *btn = (id)sender;
    SortClassItem *item = [tableArray objectAtIndex:btn.tag];
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"删除分类" message:item.title delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alert.tag = 701;
    self.group_class_id = item.group_class_id;
    [alert show];

    
}
#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 700) {
        if (buttonIndex == 1) {
            
            UITextField *nameField=[alertView textFieldAtIndex:0];
            NSDictionary *Param=[NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",
                                 self.group_class_id,@"group_class_id",[NSString stringWithFormat:@"%ld",self.groupId],@"group_id",nameField.text,@"title",nil];
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:@"editGroupCategory" Method:NetMethodPost andParam:Param];
            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                id obj=[Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:theAppDelegate.myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [self getSortData];
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [BBSAlert showAlertWithContent:errorString andDelegate:self];
                }
            }];
            [request setFailedBlock:^{
            }];
        }

    }else if (alertView.tag == 701){
        if (buttonIndex == 1) {
            //删除分类
            NSDictionary *Param=[NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",
                                 self.group_class_id,@"group_class_id",nil];
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:@"CancelGroupCategory" Method:NetMethodGet andParam:Param];
            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:theAppDelegate.myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIHTTPRequest *blockRequest=request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:kBBSSuccess] integerValue]==1) {
                    [self getSortData];
                }else{
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [BBSAlert showAlertWithContent:errorString andDelegate:self];
                    
                }
            }];
            [request setFailedBlock:^{
                
            }];
     
        }
    }else if (alertView.tag == 702){
        if (buttonIndex == 1) {
            [LoadingView startOnTheViewController:self];
            UITextField *nameField=[alertView textFieldAtIndex:0];
            NSDictionary *Param=[NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",
                                 [NSString stringWithFormat:@"%ld",self.groupId],@"group_id",nameField.text,@"title",nil];
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:@"editGroupCategory" Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            for (NSString *key in [Param allKeys]) {
                id obj=[Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            [request setDownloadCache:theAppDelegate.myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIFormDataRequest *blockRequest=request;
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    [self getSortData];
                    [LoadingView stopOnTheViewController:self];
                }else{
                    [LoadingView stopOnTheViewController:self];

                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [BBSAlert showAlertWithContent:errorString andDelegate:self];
                }
            }];
            [request setFailedBlock:^{
                [LoadingView stopOnTheViewController:self];

            }];
        }

    }
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
