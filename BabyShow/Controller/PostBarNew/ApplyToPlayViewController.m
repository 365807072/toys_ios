//
//  ApplyToPlayViewController.m
//  BabyShow
//
//  Created by Monica on 11/10/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "ApplyToPlayViewController.h"
#import "ApplyAlbumCell.h"

@interface ApplyToPlayViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic ,strong)UITableView *tableView;
@property (nonatomic ,strong)NSMutableArray *dataArray;
@property (nonatomic ,strong)NSMutableDictionary *selectedDict;

@end

@implementation ApplyToPlayViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _dataArray = [[NSMutableArray alloc]init];
        _selectedDict = [[NSMutableDictionary alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"选择相册";
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self setLeftBtn];
    [self setRightBtn];
    [self setTableView];
    
    [self queryAlbumList];
}
#pragma mark UI
-(void)setLeftBtn{
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setRightBtn{
    
    CGRect joinBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *joinBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    joinBtn.frame=joinBtnFrame;
    [joinBtn setTitle:@"   报名" forState:UIControlStateNormal];
    joinBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
    [joinBtn addTarget:self action:@selector(joinThis:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:joinBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}
- (void)joinThis:(UIButton *)sender {
    
    NSMutableArray *albums = [[NSMutableArray alloc]init];
    
    for (NSDictionary *dict in [_selectedDict allValues]) {
        NSMutableDictionary *tempDict = [[NSMutableDictionary alloc]initWithCapacity:2];
        [tempDict setValue:[dict objectForKey:@"id"] forKey:@"album_id"];
        [tempDict setValue:[dict objectForKey:@"album_name"] forKey:@"album_name"];
        [albums addObject:tempDict];
        tempDict = nil;
    }
    
    if (albums.count <= 0) {
        [BBSAlert showAlertWithContent:@"您还没有选择相册呢" andDelegate:nil];
        return;
    }
    
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:albums options:NSJSONWritingPrettyPrinted error:nil];
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    [[HTTPClient sharedClient] postNew:kJoinHotAlbum params:@{kJoinHotAlbumLogin_user_id:LOGIN_USER_ID,kJoinHotAlbumAlbums:jsonString} success:^(NSDictionary *result) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"报名成功" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alertView show];
    } failed:^(NSError *error) {
        NSLog(@"error");
    }];
}
- (void)setTableView {
    
    if (self.tableView) {
        [self.tableView reloadData];
    }
    
    CGRect tableViewFrame = CGRectMake(0, 64, SCREENWIDTH, SCREENHEIGHT-64);
    _tableView = [[UITableView alloc]initWithFrame:tableViewFrame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_tableView];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Networking
- (void)queryAlbumList {
    __weak ApplyToPlayViewController *blockSelf = self;
    [[HTTPClient sharedClient] getNew:kJoinAlbumList params:@{kJoinAlbumListLogin_user_id:LOGIN_USER_ID} success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
            blockSelf.dataArray = [result objectForKey:kBBSData];
            [blockSelf setTableView];
        }
    } failed:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.dataArray) {
        NSDictionary *sectionDict = [self.dataArray objectAtIndex:section];
        NSArray *rowsArray = [sectionDict objectForKey:@"child_album"];
        return rowsArray.count;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    ApplyAlbumCell *cell = (ApplyAlbumCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[ApplyAlbumCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSDictionary *sectionDict = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *rowsArray = [sectionDict objectForKey:@"child_album"];
    NSDictionary *rowDict = [rowsArray objectAtIndex:indexPath.row];
    cell.albumNameLabel.text = [NSString stringWithFormat:@"%@ ( %@ )",[rowDict objectForKey:@"album_name"],[rowDict objectForKey:@"img_count"]];
    
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return nil;
    }
    
    UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 25)];
    aView.backgroundColor = [BBSColor hexStringToColor:@"f2f4f5"];
    
    UILabel *aLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 2.5, SCREENWIDTH-20, 20)];
    aLabel.font = [UIFont systemFontOfSize:18];
    [aView addSubview:aLabel];
    
    NSDictionary *sectionDict = [self.dataArray objectAtIndex:section];
    aLabel.text = [NSString stringWithFormat:@"%@",[sectionDict objectForKey:@"album_name"]];

    
    return aView;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    }
    return 25;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - UITableView Delegates 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ApplyAlbumCell *cell = (ApplyAlbumCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    NSDictionary *sectionDict = [self.dataArray objectAtIndex:indexPath.section];
    NSArray *rowsArray = [sectionDict objectForKey:@"child_album"];
    NSDictionary *rowDict = [rowsArray objectAtIndex:indexPath.row];
    
    //没有相片时不允许操作
    if ([[rowDict objectForKey:@"img_count"] integerValue] <= 0) {
        return;
    }
    
    if (cell.isSelected) {
        //改为未选中，并且在报名信息中排除
        cell.isSelected = NO;
        cell.checkImageView.image =[UIImage imageNamed:@"btn_share_unselected"];
        [_selectedDict removeObjectForKey:indexPath];
    } else {
        cell.isSelected = YES;
        cell.checkImageView.image = [UIImage imageNamed:@"btn_share_selected"];
        [_selectedDict setObject:rowDict forKey:indexPath];
        
    }
}
#pragma mark - UIAlertViewDelegate 
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
