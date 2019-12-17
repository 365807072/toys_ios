//
//  EditBabyViewController.m
//  BabyShow
//
//  Created by 于 晓波 on 1/12/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "EditBabyViewController.h"
#import "EditingBabyInfoCell.h"

@interface EditBabyViewController ()
@property (strong, nonatomic) UIToolbar *toolbar;
//
@property (strong, nonatomic) UIDatePicker *customDatePicker;
@end

@implementation EditBabyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        _dataArray=[[NSMutableArray alloc]init];
        _babyId=[[NSNumber alloc]init];
        self.title=@"编辑宝贝";
    
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH-20) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    UIButton *deletBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    deletBtn.frame=CGRectMake(0, 0, 40, 33);
    [deletBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deletBtn.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
    [deletBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [deletBtn setTitleColor:[BBSColor hexStringToColor:@"c479dd"] forState:UIControlStateNormal];
    [deletBtn addTarget:self action:@selector(delete) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:deletBtn];
    self.navigationItem.rightBarButtonItem=right;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeletSucceed) name:USER_DELETE_BABY_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(DeletFail:) name:USER_DELETE_BABY_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)delete{
    
    [MobClick event:UMEVENTDELBABY];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请注意" message:@"如果删除宝贝，宝贝的相册也会一起删除哦，确定删除宝贝吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    alert.tag = 101;
    [alert show];
    
}

#pragma mark UITableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.dataArray count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditingBabyInfoCell *cell=[tableView dequeueReusableCellWithIdentifier:@"BABY"];
    if (!cell) {
        
        cell=[[EditingBabyInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BABY"];
    }
    if (indexPath.row==0) {
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.titleLabel.text=@"宝贝昵称";
        cell.backTF.userInteractionEnabled = NO;
    }else if(indexPath.row==1){
        cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        cell.backTF.userInteractionEnabled = YES;
        cell.backTF.inputView = [self customInputView];
        cell.backTF.inputAccessoryView = [self customInputAccessoryView];
        cell.titleLabel.text=@"出生日期";
    }else{
        cell.backTF.userInteractionEnabled = NO;
        cell.titleLabel.text=@"宝贝性别";
    }
    cell.contentLabel.text=[NSString stringWithFormat:@"%@",[self.dataArray objectAtIndex:indexPath.row]];
    if (indexPath.row==2) {
        if ([[self.dataArray objectAtIndex:indexPath.row] intValue]==0) {
            cell.contentLabel.text=@"男";
        }else{
            cell.contentLabel.text=@"女";
        }
        
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor whiteColor];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==0) {

        NSString *currentNick = [self.dataArray objectAtIndex:indexPath.row];
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil
                                                           message:@"修改昵称"
                                                          delegate:self
                                                 cancelButtonTitle:@"取消"
                                                 otherButtonTitles:@"完成", nil];
        alertView.alertViewStyle =UIAlertViewStylePlainTextInput;
        UITextField *tf = (UITextField *)[alertView textFieldAtIndex:0];
        tf.placeholder = @"输入宝贝昵称";
        tf.text = currentNick;
        alertView.tag = 100;
        [alertView show];
    
    } else if (indexPath.row == 1) {
        
    }
}

#pragma mark UIAlertDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 101) {
        
        if (buttonIndex==1) {
            //删除宝贝;
            [LoadingView startOnTheViewController:self];
            NSString *loginUserId=LOGIN_USER_ID;
            
            NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"user_id",self.babyId,@"baby_id",@"1",@"do_type", nil];
            
            NetAccess *net=[NetAccess sharedNetAccess];
            [net getDataWithStyle:NetStyleDeleteBaby andParam:param];
            
        }
    } else if (alertView.tag == 100) {
        if (buttonIndex == 1) {
            [MobClick event:UMEVENTEDITBABY];
            
            NSString *newName = [alertView textFieldAtIndex:0].text;
            
            [LoadingView startOnTheViewController:self];
            NSString *loginUserId=LOGIN_USER_ID;
            
            NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"user_id",self.babyId,@"baby_id",@"0",@"do_type",newName,@"baby_name", nil];
            __block EditBabyViewController *blockSelf = self;
            [[HTTPClient sharedClient] postNew:kEditBabys params:param success:^(NSDictionary *result) {
                [LoadingView stopOnTheViewController:self];

                if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
                    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:USERBABYUPDATE];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    [blockSelf.navigationController popViewControllerAnimated:YES];
                } else {
                    [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
                }
            } failed:^(NSError *error) {
                [LoadingView stopOnTheViewController:self];
                [BBSAlert showAlertWithContent:@"网络错误,请稍后重试" andDelegate:nil];
            }];
        } else {
            //
        }
        
    }
    
}

#pragma mark NSNotification

-(void)DeletSucceed{
    [LoadingView stopOnTheViewController:self];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:USERBABYUPDATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self.navigationController popToRootViewControllerAnimated:YES];

}

-(void)DeletFail:(NSNotification *)not{
    
    NSString *errorString=not.object;
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}

-(void)netFail{
    
    [LoadingView stopOnTheViewController:self];

    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:self];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark Private

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark - 定义出生日期键盘
//自定义输入键盘
- (UIView *)customInputView {
    if (!self.customDatePicker) {
        
        NSString *birth = [_dataArray objectAtIndex:1];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date =  [dateFormatter dateFromString:birth];
        
        self.customDatePicker = [[UIDatePicker alloc]init];
        self.customDatePicker.datePickerMode = UIDatePickerModeDate;
        self.customDatePicker.date = date;
        self.customDatePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:60*60*24*365];
        self.customDatePicker.backgroundColor = [UIColor whiteColor];
        
    }
    return self.customDatePicker;
}
//自定义辅助输入键盘
- (UIView *)customInputAccessoryView {
    
    if (!self.toolbar) {
        self.toolbar = [[UIToolbar alloc] init];
        self.toolbar.barStyle = UIBarStyleDefault;
        self.toolbar.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        [self.toolbar sizeToFit];
        CGRect frame = self.toolbar.frame;
        frame.size.height = 44.0f;
        self.toolbar.frame = frame;
        
        UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel:)];
        
        UIBarButtonItem *flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *doneBtn =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done:)];
        
        NSArray *array = [NSArray arrayWithObjects:cancelBtn,flexibleSpaceLeft, doneBtn, nil];
        [self.toolbar setItems:array];
    }
    return self.toolbar;
    
}
- (void)cancel:(id)sender {
    EditingBabyInfoCell *cell = (EditingBabyInfoCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if ([cell.backTF isFirstResponder]) {
        [cell.backTF resignFirstResponder];
    }
}
- (void)done :(id)sender {

    EditingBabyInfoCell *cell = (EditingBabyInfoCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    if ([cell.backTF isFirstResponder]) {
        [cell.backTF resignFirstResponder];
    }
    
    NSDate *date = [self.customDatePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:date];
    cell.contentLabel.text=dateAndTime;
    
    //request
    [LoadingView startOnTheViewController:self];
    [[HTTPClient sharedClient] postNew:kUpBabyBirthday params:@{@"baby_id":[NSString stringWithFormat:@"%@",_babyId],@"birth_date":dateAndTime} success:^(NSDictionary *result) {
        [LoadingView stopOnTheViewController:self];
        if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:USERBABYUPDATE];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
        [BBSAlert showAlertWithContent:@"网络连接错误请重试" andDelegate:nil];
    }];
}

@end
