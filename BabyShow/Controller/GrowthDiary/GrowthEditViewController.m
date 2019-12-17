//
//  GrowthEditViewController.m
//  BabyShow
//
//  Created by Monica on 15-1-28.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "GrowthEditViewController.h"
#import "AlbumListViewController.h"
#import "GrowthDetailViewController.h"
#import "GrowthDiaryViewController.h"
#import "DiaryEditCell.h"
#import "DiaryAddCell.h"
#import "GrowthDiaryEditItem.h"
#import "UIImageView+WebCache.h"
#import "SVPullToRefresh.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import "ELCImagePickerController.h"
#import "DateFormatter.h"
#import "DateAlertView.h"
#define maxNumberOfImages       20
#define AlertDiaryTag_Tag       10001
#define AlertViewTag            10002
#define AlertViewDeleteTag      10003


@interface GrowthEditViewController ()<UITableViewDelegate,UITableViewDataSource,UITextViewDelegate,UITextFieldDelegate,UIActionSheetDelegate,UIAlertViewDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,DateAlertViewDelegate,CLLocationManagerDelegate>
{
    UIScrollView *tagScrollView;
    UILabel  *titleLabel;
    
    NSString *_tag_name;
    NSMutableDictionary *editInfoDict;
    NSMutableArray      *backupDataArray;//model的备份
    
    UITextField *_nodeTitleTextField;
    UITextField *_currentTextField;
    UITextView  *_currentTextView;
    NSIndexPath *_currentIndexPath;
    
    UITextField *yearTextField;
    UITextField *monthTextField;
    UITextField *dayTextField;
    
}
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSMutableArray *dataArray;
@property (nonatomic ,strong) NSMutableArray *tagDataArray;
@property (nonatomic ,assign) int page;
@property (nonatomic ,assign) BOOL isFinished;
@property (nonatomic ,assign) BOOL addTag;//是否手动添加过tag(自定义)

@property (nonatomic ,strong) CLLocationManager *locationManager;
@property (nonatomic ,strong) NSString *latitude;//拍照时当前手机的经纬度
@property (nonatomic ,strong) NSString *longitude;

@end

@implementation GrowthEditViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _dataArray = [NSMutableArray array];
        _tagDataArray = [[NSMutableArray alloc]init];
        backupDataArray = [[NSMutableArray alloc] init];
        editInfoDict = [[NSMutableDictionary alloc] init];
        _urlsArray = [[NSArray alloc] init];
        _page = 1;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.nodeName;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"编辑";
    [self setLeftBarButton];
    [self setRightBarButton];
    [self setTableView];
    [self setDeleteBtn];
    
    [self getData];
    [self getTagData];
    
    self.latitude = @"";
    self.longitude = @"";
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
        [self.locationManager startUpdatingLocation];
    }
    
}
- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"jdslfjdjflajsdfl = %@",self.urlsArray);

    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataSucceed:) name:USER_UPDATE_DIARY_LIST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFailed:) name:USER_UPDATE_DIARY_LIST_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFailed) name:USER_NET_ERROR object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importSucceed:) name:IMPORT_TO_DIARY_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(importFailed:) name:IMPORT_TO_DIARY_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDiarySucceed:) name:USER_UP_DIARY_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(upDiaryFailed:) name:USER_UP_DIARY_FAIL object:nil];

    if (_uploadUrls) {
        [self uploadImageWithURLs:_urlsArray];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - NetWork Methods
- (void)getData {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"user_id",self.babyID,@"baby_id",self.nodeID,@"album_id",[NSString stringWithFormat:@"%d",_page],@"page", nil];
    [[NetAccess sharedNetAccess] getDataWithStyle:NetStyleUpdateDiaryList andParam:params];
    [LoadingView startOnTheViewController:self];
    
}
- (void)getTagData {
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"user_id",self.babyID,@"baby_id",self.nodeID,@"album_id", nil];
    [[HTTPClient sharedClient] getNew:kDiaryTagList params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
            _tagDataArray = [NSMutableArray arrayWithArray:[result objectForKey:kBBSData]];
            
            CGFloat totalWidth = 0;
            for (int i = 0;i < _tagDataArray.count ;i++ ) {
                NSDictionary *tagInfo = [_tagDataArray objectAtIndex:i];
                NSString *tagName = [NSString stringWithFormat:@"  %@  ",[tagInfo objectForKey:@"tag_name"]];
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.backgroundColor = [BBSColor hexStringToColor:@"d2d2d2"];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                [button setTitle:tagName forState:UIControlStateNormal];
                button.layer.cornerRadius = 10;
                button.layer.masksToBounds = YES;
                button.tag = i + 100;
                [button addTarget:self action:@selector(chooseTag:) forControlEvents:UIControlEventTouchUpInside];
                CGFloat width = [tagName boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:button.titleLabel.font} context:nil].size.width;
                button.frame = CGRectMake(5*(i + 1) + totalWidth, 6.5, width, 25);
                [tagScrollView addSubview:button];
                
                totalWidth += width ;

            }
            tagScrollView.contentSize = CGSizeMake(totalWidth + 5*_tagDataArray.count, 38);
            if (_tag_name.length > 0 ) {
                _addTag = YES;
                UIButton *btn = (UIButton *)[tagScrollView viewWithTag:101];
                [self chooseTag:btn];
            }
        } else {
            
        }
    } failed:^(NSError *error) {
        
    }];
}
#pragma mark - private

- (void)setLeftBarButton {
    CGRect backBtnFrame = CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame = backBtnFrame;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    
    self.navigationItem.leftBarButtonItem = left;
}
- (void)setRightBarButton {
    
    UIButton *doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    doneBtn.frame=CGRectMake(0, 0, 51, 31);
    [doneBtn setTitle:@"    完成" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.8];
    [doneBtn addTarget:self action:@selector(doneEdit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *editItem=[[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10;
    
    //rightBarButtonItems are placed right-to-left with the first item in the list at the right outside edge and right aligned.
    self.navigationItem.rightBarButtonItems = @[spaceItem,editItem];
}

- (UIView *)tableHeaderView {
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 120)];
    view.backgroundColor = [UIColor clearColor];
    
    UIView *seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 37.5, SCREENWIDTH, 0.5)];
    seperatorView.backgroundColor = [BBSColor hexStringToColor:@"f3f3f3"];
    [view addSubview:seperatorView];
    
    UIView *seperatorView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 75.5, SCREENWIDTH, 0.5)];
    seperatorView1.backgroundColor = [BBSColor hexStringToColor:@"f3f3f3"];
    [view addSubview:seperatorView1];
    
    UIView *seperatorView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 114, SCREENWIDTH, 6)];
    seperatorView2.backgroundColor = [BBSColor hexStringToColor:@"f3f3f3"];
    [view addSubview:seperatorView2];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 9, 80, 20)];
    label1.text = @"添加标签";
    label1.textColor = [BBSColor hexStringToColor:@"9b9b9b"];
    label1.backgroundColor = [UIColor clearColor];
    label1.font = [UIFont systemFontOfSize:14.0];
    label1.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 47, 80, 20)];
    label2.text = @"修改时间";
    label2.textColor = [BBSColor hexStringToColor:@"9b9b9b"];
    label2.backgroundColor = [UIColor clearColor];
    label2.font = [UIFont systemFontOfSize:14.0];
    label2.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 85, 80, 20)];
    label3.text = @"添加标题";
    label3.textColor = [BBSColor hexStringToColor:@"9b9b9b"];
    label3.backgroundColor = [UIColor clearColor];
    label3.font = [UIFont systemFontOfSize:14.0];
    label3.textAlignment = NSTextAlignmentCenter;
    [view addSubview:label3];
    
    //添加标签
    tagScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(80, 0, SCREENWIDTH - 80 - 5, 38)];
    tagScrollView.backgroundColor = [UIColor clearColor];
    tagScrollView.showsHorizontalScrollIndicator = NO;
    tagScrollView.showsVerticalScrollIndicator = NO;
    [view addSubview:tagScrollView];
    
    //修改时间
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(80, 38, SCREENWIDTH - 80, 38)];
    UIImage *arrowImage = [UIImage imageNamed:@"img_diary_arrow1"];

    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 4, SCREENWIDTH - 80 - arrowImage.size.width -40, 30)];
    titleLabel.text = self.nodeName;
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.tag = 100;
    [aView addSubview:titleLabel];
    
    UIImageView *arrowImageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREENWIDTH - 80 - arrowImage.size.width - 10, (38- arrowImage.size.height)/2, arrowImage.size.width, arrowImage.size.height)];
    arrowImageV.image = arrowImage;
    arrowImageV.tag = 101;
    [aView addSubview:arrowImageV];
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editNodeName:)];
    [aView addGestureRecognizer:tapGes];
    [view addSubview:aView];
    
    //添加标题
    _nodeTitleTextField = [[UITextField alloc] initWithFrame:CGRectMake(100, 76, SCREENWIDTH - 100 -5, 38)];
    _nodeTitleTextField.placeholder = @"输入成长日记的名称";
    _nodeTitleTextField.text = self.nodeTitle;
    _nodeTitleTextField.delegate = self;
    _nodeTitleTextField.font = [UIFont systemFontOfSize:15];
    _nodeTitleTextField.clearButtonMode = UITextFieldViewModeAlways;
    [view addSubview:_nodeTitleTextField];
    
    return view;
    
}
- (void)setDeleteBtn {
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT - 40, SCREENWIDTH, 40)];
    
    UIView *seperator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
    seperator.backgroundColor = [BBSColor hexStringToColor:@"cfcfcf"];
    [aView addSubview:seperator];
    
//    CGRect btnFrame = CGRectMake((SCREENWIDTH - 70)/2, 0, 100, 40);
    
    UIImage *image = [UIImage imageNamed:@"img_diary_del"];
   
    CGFloat imageWidth=image.size.width;
    CGFloat imageHeight=image.size.height;
    CGFloat btnWidth=100;
    CGFloat btnHeight=40;
    CGFloat seperateWith=(SCREENWIDTH-2*imageWidth-2*btnWidth)/4;

    CGRect btnFrame1 = CGRectMake(seperateWith+imageWidth, 0, btnWidth, btnHeight);
    CGRect imageFrame1 = CGRectMake(seperateWith,20-imageHeight/2,imageWidth,imageHeight);
    
    CGRect btnFrame2=CGRectMake(imageWidth*2+btnWidth+3*seperateWith, 0, btnWidth, btnHeight);
    CGRect imageFrame2=CGRectMake(imageWidth+btnWidth+3*seperateWith,  20-imageHeight/2, imageWidth, imageHeight);

    UIImageView *setImageView = [[UIImageView alloc] initWithFrame:imageFrame1];
    setImageView.image = image;
    [aView addSubview:setImageView];
    
    self.privacyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (self.ifPrivacy==YES) {
        [self.privacyBtn setTitle:@"取消私密" forState:UIControlStateNormal];
    }else{
        [self.privacyBtn setTitle:@"设为私密" forState:UIControlStateNormal];
    }
    [self.privacyBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.privacyBtn.frame = btnFrame1;
    [self.privacyBtn addTarget:self action:@selector(setPrivacy:) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:self.privacyBtn];
    
    UIImageView *delete = [[UIImageView alloc] initWithFrame:imageFrame2];
    delete.image = image;
    [aView addSubview:delete];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [deleteBtn setTitle:@"删除全部" forState:UIControlStateNormal];
    [deleteBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    deleteBtn.frame = btnFrame2;
    [deleteBtn addTarget:self action:@selector(deleteDiary:) forControlEvents:UIControlEventTouchUpInside];
    [aView addSubview:deleteBtn];

    [self.view addSubview:aView];
    
}
- (void)setTableView {
    if (_tableView) {
        [_tableView reloadData];
    }
    
    CGRect frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT- 40);
    _tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableHeaderView = [self tableHeaderView];
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    __block GrowthEditViewController *blockSelf = self;
    [_tableView addInfiniteScrollingWithActionHandler:^{
        
        if (!blockSelf.isFinished) {
            if (blockSelf.tableView.pullToRefreshView.state==SVInfiniteScrollingStateStopped) {
                [blockSelf getData];
                [blockSelf resignFirstResponsder];

            }
        }else{
            if (blockSelf.tableView.infiniteScrollingView && blockSelf.tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
                [blockSelf.tableView.infiniteScrollingView stopAnimating];
            }
            
        }
    }];
    
}
//添加时间弹窗
- (void)addDateSelectorWithData:(NSArray *)array {
    
    [self resignFirstResponsder];
    
    DateAlertView *alertView = [[DateAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    if ([self.view viewWithTag:AlertViewTag]) {
        
    } else {
        alertView.tag = AlertViewTag;
        alertView.delegate = self;
        alertView.yearTF.text = [array objectAtIndex:0];
        alertView.monthTF.text = [array objectAtIndex:1];
        alertView.dayTF.text = [array objectAtIndex:2];
        alertView.segControl.selectedSegmentIndex = [[array objectAtIndex:3] integerValue];
        [self.view addSubview:alertView];

    }
}

- (void)resignFirstResponsder {
    
    if ([_currentTextField isFirstResponder]) {
        [_currentTextField resignFirstResponder];
    }
    if ([_currentTextView isFirstResponder]) {
        [_currentTextView resignFirstResponder];
    }

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.25];
    _tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT - 40);
    [UIView commitAnimations];
    
}

#pragma mark - Actions Methods
- (void)chooseTag:(UIButton *)button {

    for (UIButton *btn in tagScrollView.subviews) {
        if ([btn isEqual:button]) {
            btn.backgroundColor = [BBSColor hexStringToColor:@"fb6f6f"];
        } else {
            btn.backgroundColor = [BBSColor hexStringToColor:@"d2d2d2"];
        }
    }
    
    if (button.tag-100 == 0) {
        //自定义
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"添加标签" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
        UITextField *tf = (UITextField *)[alertView textFieldAtIndex:0];
        tf.placeholder = @"自定义标签";
        alertView.tag = AlertDiaryTag_Tag;
        [alertView show];
    } else {
        NSDictionary *tagInfo = [_tagDataArray objectAtIndex:button.tag-100];
        NSString *tagName = [tagInfo objectForKey:@"tag_name"];
        _tag_name = tagName;
    }
    
}
- (void)editNodeName:(UITapGestureRecognizer *)tagGes {
    
    _currentIndexPath = nil;
    [self addDateSelectorWithData:[self dateArrayFromString:self.nodeName]];
    
}

-(void)refreshPrivacyBtn{
    if (self.ifPrivacy==YES) {
        [self.privacyBtn setTitle:@"取消私密" forState:UIControlStateNormal];
    }else{
        [self.privacyBtn setTitle:@"设为私密" forState:UIControlStateNormal];
    }
    
}

-(void)setPrivacy:(id) sender{
    [LoadingView startOnTheViewController:self];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"user_id",self.nodeID,@"album_id", nil];

    if (!self.ifPrivacy) {
        
        [[HTTPClient sharedClient] postNew:kDiaryCate params:params success:^(NSDictionary *result) {
            [LoadingView stopOnTheViewController:self];
            if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
                self.ifPrivacy=YES;
                [self.privacyBtn setTitle:@"取消私密" forState:UIControlStateNormal];
                
            } else {
                [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
            }
        } failed:^(NSError *error) {
            [LoadingView stopOnTheViewController:self];
            [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
        }];

    }else{
        
        [[HTTPClient sharedClient] postNew:kCancelDiaryCate params:params success:^(NSDictionary *result) {
            [LoadingView stopOnTheViewController:self];
            if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
                
                self.ifPrivacy=NO;
                [self.privacyBtn setTitle:@"设为私密" forState:UIControlStateNormal];
                
            } else {
                [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
            }
        } failed:^(NSError *error) {
            [LoadingView stopOnTheViewController:self];
            [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
        }];

    }    
    
}

- (void)deleteDiary:(UIButton *)button {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您确认要删除全部吗?" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alertView.tag = AlertViewDeleteTag;
    [alertView show];
    
}
- (void)doneEdit:(UIButton *)button {
    
    //resignfirstresponsder
    [self resignFirstResponsder];
    
    if ([self.view viewWithTag:AlertViewTag]) {
        UIView *view= [self.view viewWithTag:AlertViewTag];
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             [view setAlpha:0.0];
                         }
                         completion:^(BOOL finished) {
                             [view removeFromSuperview];
                         }];
        return;
    }
    NSArray *allValues = [editInfoDict allValues];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"user_id",self.babyID,@"baby_id",self.nodeID,@"album_id",self.nodeName,@"album_name", nil];
    
    self.nodeTitle = _currentTextField.text;
    if (self.nodeTitle) {
        [params setObject:self.nodeTitle forKey:@"album_desc"];
    }
    if (allValues.count) {
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:allValues options:NSJSONWritingPrettyPrinted error:nil];
        NSString *dateJsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        [params setObject:dateJsonString forKey:@"diary_imgs"];
    }
    if (_tag_name) {
        [params setObject:_tag_name forKey:@"tag_name"];
    }

    [[NetAccess sharedNetAccess] getDataWithStyle:NetStyleUpDiary andParam:params];
    [LoadingView startOnTheViewController:self];
    
}

- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITableViewDelegate Methods
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return [_dataArray count] + 1;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        return 100;
    }
    return 90;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
    if (indexPath.row == 0) {
        static NSString *identifier = @"AddCell";
        DiaryAddCell *addCell = (DiaryAddCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (addCell == nil) {
            addCell = [[DiaryAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell = addCell;

    } else {
        NSString *identifier = [NSString stringWithFormat:@"EditCell%ld",(long)indexPath.row];
        DiaryEditCell *editCell = (DiaryEditCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (editCell == nil) {
        
            editCell = [[DiaryEditCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        
        GrowthDiaryEditItem *item = [_dataArray objectAtIndex:indexPath.row-1];
        [editCell.photoImageView sd_setImageWithURL:[NSURL URLWithString:item.img_thumb]];
        editCell.timeLabel.text = item.img_title;
        editCell.descTextView.text = item.img_description;
        editCell.descTextView.delegate = self;
        editCell.hintLabel.hidden = !(item.img_description.length <= 0);
        editCell.indexPath = indexPath;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showAlertView:)];
        [editCell.timeLabel addGestureRecognizer:tapGes];
        
        cell = editCell;

    }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self resignFirstResponsder];
    
    if ([tableView isEqual:_tableView]) {
        if (indexPath.row == 0) {
            //add
            UIActionSheet *acs=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从我的相册",@"从手机相册",@"拍摄一张", nil];
            [acs showInView:[UIApplication sharedApplication].keyWindow];
        }
    }
    
}
#pragma mark - Notification Methods
- (void)getDataSucceed:(NSNotification *)noti {
    [LoadingView stopOnTheViewController:self];
    NSDictionary *returnDict = [[NetAccess sharedNetAccess] getReturnDataWithNetStyle:[noti.object intValue]];
    
    if (!_tag_name){
        _tag_name = [returnDict objectForKey:@"tag_name"];
    }
    if (_tag_name.length > 0 && _tagDataArray.count > 0) {
        //这个请求后走完
        _addTag = YES;
        UIButton *btn = (UIButton *)[tagScrollView viewWithTag:101];
        [self chooseTag:btn];

    }
    
    id obj=[returnDict objectForKey:@"diary_cate"];
    self.ifPrivacy=[obj boolValue];
    
    [self refreshPrivacyBtn];
    
    NSArray *returnArr = [returnDict objectForKey:@"img"];
    if (returnArr.count <= 0) {
        _isFinished = YES;
    } else {
        _page ++;
    }
    
    for (GrowthDiaryEditItem *item in returnArr) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:item.img_title,@"img_title",item.img_description,@"img_description", nil];
        [backupDataArray addObject:dict];

    }
    
    [_dataArray addObjectsFromArray:returnArr];
    if (_tableView) {
        [_tableView reloadData];
    }
    
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
}
- (void)getDataFailed:(NSNotification *)noti {
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:noti.object andDelegate:nil];
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
}
- (void)importSucceed:(NSNotification *)noti {
    
    [LoadingView stopOnTheViewController:self];
    
    for (UIViewController *viewC in self.navigationController.viewControllers) {
        if ([viewC isKindOfClass:[GrowthDetailViewController class]]) {
            GrowthDetailViewController *viewController = (GrowthDetailViewController *)viewC;
            viewController.refresh = YES;
        }
    }
    self.page = 1;
    _isFinished = NO;
    [backupDataArray removeAllObjects];
    [_dataArray removeAllObjects];
    [self getData];
    
    _uploadUrls = NO;
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
}
- (void)importFailed:(NSNotification *)noti {
    [LoadingView stopOnTheViewController:self];
    NSString *message = noti.object;
    [BBSAlert showAlertWithContent:message andDelegate:nil];
    
    _uploadUrls = NO;
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
}
- (void)upDiarySucceed:(NSNotification *)noti {
    [LoadingView stopOnTheViewController:self];
    
    for (UIViewController *viewC in self.navigationController.viewControllers) {
        if ([viewC isKindOfClass:[GrowthDetailViewController class]]) {
            GrowthDetailViewController *viewController = (GrowthDetailViewController *)viewC;
            viewController.refresh = YES;
            viewController.nodeName = self.nodeName;
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)upDiaryFailed:(NSNotification *)noti {
    [BBSAlert showAlertWithContent:noti.object andDelegate:nil];
    [LoadingView stopOnTheViewController:self];
}
- (void)netFailed {
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:nil];
    
    if (_tableView.infiniteScrollingView && _tableView.infiniteScrollingView.state==SVInfiniteScrollingStateLoading) {
        [_tableView.infiniteScrollingView stopAnimating];
    }
}

#pragma mark - UITextFieldDelegate Methods
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    _currentTextField = textField;
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
   
    if (![string isEqualToString:@""]) {
        if ([[textField.text  stringByAppendingPathComponent:string] length] > 20) {
            return NO;
        }
    }
    
    return YES;
    
}
#pragma mark - UITextViewDelegate Methods
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {

    _currentTextView = textView;
    UIView * aView = [[textView superview] superview] ;
    //UITableViewCellScrollView
    //UITableViewWrapperView is the superView of uitableviewcell
    DiaryEditCell *editCell ;
    if ([aView isKindOfClass:[DiaryEditCell class]]) {
        editCell = (DiaryEditCell *)aView;
    } else {
        editCell = (DiaryEditCell *)[aView superview];
    }
    
    if (editCell) {
        editCell.hintLabel.hidden = YES;
        NSIndexPath *indexPath = editCell.indexPath;
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.25];
        _tableView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-216-36);
        [_tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        [UIView commitAnimations];
    }
    
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {

    //刚刚编辑过的,不是新编辑的,如果是从一个textview变为另一个textview,那么这里的textview是指第一个
    
    UIView * aView = [[textView superview] superview] ;
    //UITableViewCellScrollView
    DiaryEditCell *editCell ;
    if ([aView isKindOfClass:[DiaryEditCell class]]) {
        editCell = (DiaryEditCell *)aView;
    } else {
        editCell = (DiaryEditCell *)[aView superview];
    }

    if (editCell) {
        NSIndexPath *indexPath = editCell.indexPath;
        editCell.hintLabel.hidden = !(textView.text.length <= 0);
        
        GrowthDiaryEditItem *item = [_dataArray objectAtIndex:indexPath.row-1];
        NSDictionary *dict = [backupDataArray objectAtIndex:indexPath.row-1];
        //修改过,,,dict保留老数据
        if (![[dict objectForKey:@"img_description"] isEqualToString:textView.text]) {
            item.img_description = textView.text;
            //该条的描述已经修改过,或者该条的时间修改过,都会记录
            if ([editInfoDict objectForKey:[NSString stringWithFormat:@"%@",indexPath]]) {
                NSMutableDictionary *rowInfo = [editInfoDict objectForKey:[NSString stringWithFormat:@"%@",indexPath]];
                [rowInfo setObject:textView.text forKey:@"img_description"];
            } else {
                NSMutableDictionary *rowInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:item.img_id,@"img_id",item.img_title,@"diary_time",textView.text,@"img_description", nil];
                [editInfoDict setObject:rowInfo forKey:[NSString stringWithFormat:@"%@",indexPath]];
            }
        } else {
            if ([editInfoDict objectForKey:[NSString stringWithFormat:@"%@",indexPath]]) {
                NSMutableDictionary *rowInfo = [editInfoDict objectForKey:[NSString stringWithFormat:@"%@",indexPath]];
                if ([[dict objectForKey:@"img_title"] isEqualToString:[rowInfo objectForKey:@"diary_time"]]) {
                    //
                    [editInfoDict removeObjectForKey:[NSString stringWithFormat:@"%@",indexPath]];
                }
                
            }
        }
    }
    
    return YES;
}
#pragma mark - UIAlertViewDelegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == AlertDiaryTag_Tag) {
        if (buttonIndex == 0) {
            //cancel
        } else {
            NSString *tag_name = ((UITextField *)[alertView textFieldAtIndex:0]).text;
            CGFloat width = [[NSString stringWithFormat:@"  %@  ",tag_name] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
            CGFloat customWidth = [@"  自定义  " boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;

            _tag_name = tag_name;
            if (_addTag == YES) {
                //已经添加过,现在是修改,更新btn:frame,标题,tagdataarray
                NSDictionary *tagInfo = [_tagDataArray objectAtIndex:1];
                NSString *originTagName = [tagInfo objectForKey:@"tag_name"];
                CGFloat originWidth = [[NSString stringWithFormat:@"  %@  ",originTagName] boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size.width;
                CGFloat delta = width - originWidth;

                NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:tag_name,@"tag_name", nil];
                [_tagDataArray replaceObjectAtIndex:1 withObject:tempDict];
                for (UIButton *btn in tagScrollView.subviews) {
                    if (btn.tag > 100) {
                        if (btn.tag == 101) {
                            [btn setTitle:[NSString stringWithFormat:@"  %@  ",tag_name] forState:UIControlStateNormal];
                            CGRect frame =  btn.frame;
                            frame.size.width = width;
                            btn.frame = frame;
                            [self chooseTag:btn];
                        } else {
                            CGRect frame = btn.frame;
                            frame.origin.x += delta;
                            btn.frame = frame;
                        }
                    }
                }
                CGSize contentSize = tagScrollView.contentSize;
                contentSize.width += delta;
                tagScrollView.contentSize = contentSize;
                
            } else {
            
                _addTag = YES;
                NSDictionary *tempDict = [NSDictionary dictionaryWithObjectsAndKeys:tag_name,@"tag_name", nil];
                [_tagDataArray insertObject:tempDict atIndex:1];
                
                for (UIButton *btn in tagScrollView.subviews) {

                    if (btn.tag == 100) {
                        //不动
                    } else {
                        //frame往后移,
                        CGRect frame = btn.frame;
                        frame.origin.x += (5 + width);
                        btn.frame = frame;
                        btn.tag = btn.tag + 1;
                        
                    }
                }
                
                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                button.backgroundColor = [BBSColor hexStringToColor:@"d2d2d2"];
                button.titleLabel.font = [UIFont systemFontOfSize:15];
                [button setTitle:[NSString stringWithFormat:@"  %@  ",tag_name] forState:UIControlStateNormal];
                button.layer.cornerRadius = 10;
                button.layer.masksToBounds = YES;
                button.tag = 1 + 100;
                [button addTarget:self action:@selector(chooseTag:) forControlEvents:UIControlEventTouchUpInside];
                button.frame = CGRectMake(10 + customWidth, 6.5, width, 25);
                [tagScrollView addSubview:button];
                
                CGSize contentSize = tagScrollView.contentSize;
                contentSize.width += (5 + width);
                tagScrollView.contentSize = contentSize;
                [self chooseTag:button];
            }
            
        }
    } else if (alertView.tag == AlertViewDeleteTag){
        if (buttonIndex == 0) {
            //cancel
        } else {
            [LoadingView startOnTheViewController:self];
            
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"user_id",self.nodeID,@"album_id", nil];
            [[HTTPClient sharedClient] postNew:kDelDiaryAlbum params:params success:^(NSDictionary *result) {
                [LoadingView stopOnTheViewController:self];
                if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
                    for (UIViewController *viewC in self.navigationController.viewControllers) {
                        if ([viewC isKindOfClass:[GrowthDiaryViewController class]]) {
                            GrowthDiaryViewController *viewController = (GrowthDiaryViewController *)viewC;
                            viewController.refresh = YES;
                        }
                    }
                    [self.navigationController popToRootViewControllerAnimated:YES];
                } else {
                    [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
                }
            } failed:^(NSError *error) {
                [LoadingView stopOnTheViewController:self];
                [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
            }];
        }
    }
    
}
#pragma mark - UIActionSheetDelegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        AlbumListViewController *albumListVC = [[AlbumListViewController alloc] init];
        NSUInteger currentCount = 0;
        NSDictionary *movingDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"isChoosing",[NSNumber numberWithUnsignedInteger:currentCount],@"currentCount", nil];
        albumListVC.title = @"选择";
        albumListVC.movingInfo = movingDict;
        albumListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:albumListVC animated:YES];

    }else if (buttonIndex == 1) {
        ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
        elcPicker.maximumImagesCount = maxNumberOfImages;
        elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
        elcPicker.imagePickerDelegate = self;
        [self presentViewController:elcPicker animated:YES completion:nil];
        
    }else if (buttonIndex == 2){
        //拍摄
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
            
            UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate=self;
            imagePicker.allowsEditing=YES;
            imagePicker.videoQuality=UIImagePickerControllerQualityType640x480;
            [self.navigationController presentViewController:imagePicker animated:YES completion:^{}];
            
        }else{
            
            [BBSAlert showAlertWithContent:@"相机设备不可用，请到手机 设置->隐私->相机选项卡 打开自由环球租赁的开关" andDelegate:self];
            
        }
    } else {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        
    }
}
- (void)uploadWithImageArray:(NSArray *)imgArr dateDict:(NSDictionary *)dateDict {
    
   // NSString *dateJsonString = [dateDict JSONString];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dateDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *dateJsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:imgArr,@"photos",self.babyID,@"baby_id",LOGIN_USER_ID,@"user_id",self.nodeID,@"album_id",dateJsonString,@"imgs",[NSString stringWithFormat:@"%ld",(long)imgArr.count],@"file_count",@"1",@"isedit", nil];
    
    [[NetAccess sharedNetAccess] getDataWithStyle:NetStyleImportToDiary andParam:params];
    
    [LoadingView startOnTheViewController:self];
}
- (void)uploadImageWithURLs:(NSArray *)urlsArray {
    
    NSMutableArray *urlArray = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in urlsArray) {
        [urlArray addObject:[dict objectForKey:@"img_down"]];
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:urlArray options:NSJSONWritingPrettyPrinted error:nil];
    NSString *urlJsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];

    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.babyID,@"baby_id",LOGIN_USER_ID,@"user_id",self.nodeID,@"album_id",urlJsonString,@"imgUrls",@"1",@"isedit", nil];
    [[NetAccess sharedNetAccess] getDataWithStyle:NetStyleImportToDiary andParam:params];
    
    [LoadingView startOnTheViewController:self];
    
}
#pragma mark - ImagePickerDelegate Methods
- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info {
    
    NSMutableArray *imageArray = [[NSMutableArray alloc] init];
    NSMutableDictionary *dateDict = [[NSMutableDictionary alloc] init];
    for (int i = 0; i < info.count; i++) {
        NSDictionary *singleInfo = info[i];
        CLLocation *location = [singleInfo objectForKey:ALAssetPropertyLocation];
        CLLocationCoordinate2D coordinate = location.coordinate;
        NSDate *dateTime = [singleInfo objectForKey:ALAssetPropertyDate];
        UIImage *image = [singleInfo objectForKey:UIImagePickerControllerOriginalImage];
        [imageArray addObject:image];
        NSString *dateString = [DateFormatter dateStringFromDate:dateTime formatter:@"yyyy-MM-dd HH:mm:ss"];

        NSString *lat = @"";
        if (coordinate.latitude > 0) {
            lat = [NSString stringWithFormat:@"%f",coordinate.latitude];
        }
        NSString *lng = @"";
        if (coordinate.longitude > 0) {
            lng = [NSString stringWithFormat:@"%f",coordinate.longitude];
        }
        
        NSDictionary *imgsInfo = [NSDictionary dictionaryWithObjectsAndKeys:dateString,@"times",lat,@"lat",lng,@"lng", nil];
        [dateDict setObject:imgsInfo forKey:[NSString stringWithFormat:@"img%d",i+1]];
    }
    
    [self uploadWithImageArray:imageArray dateDict:dateDict];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    NSDictionary *dict = [info objectForKey:UIImagePickerControllerMediaMetadata];
    NSDictionary *tiffDict = [dict objectForKey:@"{TIFF}"];
    NSString *dateTime = [tiffDict objectForKey:@"DateTime"];
    dateTime = [dateTime stringByReplacingCharactersInRange:NSMakeRange(4, 1) withString:@"-"];
    dateTime = [dateTime stringByReplacingCharactersInRange:NSMakeRange(7, 1) withString:@"-"];
    NSArray *imageArray = [[NSArray alloc]initWithObjects:image, nil];
    NSDictionary *imgsInfo = [NSDictionary dictionaryWithObjectsAndKeys:dateTime,@"times",self.latitude,@"lat",self.longitude,@"lng", nil];
    
    NSDictionary *dateDict = [NSDictionary dictionaryWithObjectsAndKeys:imgsInfo,@"img1", nil];
    
    [self uploadWithImageArray:imageArray dateDict:dateDict];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - CLLocationManagerDelegate Methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    for (CLLocation *location in locations) {
        self.latitude = [NSString stringWithFormat:@"%f",location.coordinate.latitude];
        self.longitude = [NSString stringWithFormat:@"%f",location.coordinate.longitude];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    self.latitude = @"";
    self.longitude = @"";
}

#pragma mark - DateAlertViewDelegate Methods
- (void)getTimeInfo:(NSString *)dateString {
    if (_currentIndexPath) {
        //每条修改的时间
        DiaryEditCell *editCell = (DiaryEditCell *)[_tableView cellForRowAtIndexPath:_currentIndexPath];
        editCell.timeLabel.text = dateString;

        GrowthDiaryEditItem *item = [_dataArray objectAtIndex:_currentIndexPath.row-1];
        NSDictionary *dict = [backupDataArray objectAtIndex:_currentIndexPath.row-1];
        //修改过,,,dict保留老数据
        if (![[dict objectForKey:@"img_title"] isEqualToString:dateString]) {
            item.img_title = dateString;
            //该条的描述已经修改过,或者该条的时间修改过,都会记录
            if ([editInfoDict objectForKey:[NSString stringWithFormat:@"%@",_currentIndexPath]]) {
                NSMutableDictionary *rowInfo = [editInfoDict objectForKey:[NSString stringWithFormat:@"%@",_currentIndexPath]];
                [rowInfo setObject:dateString forKey:@"diary_time"];
            } else {
                NSMutableDictionary *rowInfo = [NSMutableDictionary dictionaryWithObjectsAndKeys:item.img_id,@"img_id",item.img_title,@"diary_time",item.img_description,@"img_description", nil];
                [editInfoDict setObject:rowInfo forKey:[NSString stringWithFormat:@"%@",_currentIndexPath]];
            }
        } else {
            if ([editInfoDict objectForKey:[NSString stringWithFormat:@"%@",_currentIndexPath]]) {
                NSMutableDictionary *rowInfo = [editInfoDict objectForKey:[NSString stringWithFormat:@"%@",_currentIndexPath]];
                if ([[dict objectForKey:@"img_description"] isEqualToString:[rowInfo objectForKey:@"img_description"]]) {
                    //
                    [editInfoDict removeObjectForKey:[NSString stringWithFormat:@"%@",_currentIndexPath]];
                }
                
            }
        }

    } else {
        //导航的时间
        self.nodeName = dateString;
        titleLabel.text = dateString;
    }
}
- (void)showAlertView:(UITapGestureRecognizer *)tagGes {
    
    [self resignFirstResponsder];
    
    UILabel *timeLabel = (UILabel *)[tagGes view];
    UIView * aView = [[timeLabel superview] superview] ;
   
    DiaryEditCell *editCell ;
    if ([aView isKindOfClass:[DiaryEditCell class]]) {
        editCell = (DiaryEditCell *)aView;
    } else {
        editCell = (DiaryEditCell *)[aView superview];
    }

    _currentIndexPath = editCell.indexPath;
    
    [self addDateSelectorWithData:[self dateArrayFromString:timeLabel.text]];
}
- (NSArray *)dateArrayFromString:(NSString *)dateS {

    NSString *dateString = dateS;
    
    NSString *year = @"",*month = @"",*day = @"",*before = @"0";
    
    BOOL bef =  [dateString hasPrefix:@"出生前"];
    before = [NSString stringWithFormat:@"%d",bef];
    
    dateString = [dateString stringByReplacingOccurrencesOfString:@"出生前" withString:@""];
    
    if ([dateString rangeOfString:@"岁"].location != NSNotFound) {
        NSRange range = [dateString rangeOfString:@"岁"];
        year = [dateString substringToIndex:range.location];
        NSString *s = [dateString substringWithRange:NSMakeRange(0, range.location+1)];
        dateString = [dateString stringByReplacingOccurrencesOfString:s withString:@""];
    }
    
    if ([dateString rangeOfString:@"年"].location != NSNotFound) {
        NSRange range = [dateString rangeOfString:@"年"];
        year = [dateString substringToIndex:range.location];
        NSString *s = [dateString substringWithRange:NSMakeRange(0, range.location+range.length)];
        dateString = [dateString stringByReplacingOccurrencesOfString:s withString:@""];
    }
    
    if ([dateString rangeOfString:@"个月"].location != NSNotFound) {
        NSRange range = [dateString rangeOfString:@"个月"];
        month = [dateString substringToIndex:range.location];
        NSString *s = [dateString substringWithRange:NSMakeRange(0, range.location+range.length)];
        dateString = [dateString stringByReplacingOccurrencesOfString:s withString:@""];
    }
    dateString = [dateString stringByReplacingOccurrencesOfString:@"零" withString:@""];
    if ([dateString rangeOfString:@"天"].location != NSNotFound) {
        NSRange range = [dateString rangeOfString:@"天"];
        day = [dateString substringToIndex:range.location];
    }
    
    return [[NSArray alloc] initWithObjects:year,month,day,before, nil];
}
@end
