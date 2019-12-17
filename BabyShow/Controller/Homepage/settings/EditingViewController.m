//
//  EditingViewController.m
//  BabyShow
//
//  Created by Lau on 13-12-26.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "EditingViewController.h"
#import "ModifyPasswordViewController.h"
#import "LoginViewController.h"
#import "EmailViewController.h"
#import "EditBabyViewController.h"
#import "ServieceViewController.h"

#import "UIImageView+WebCache.h"
#import "EditingAvatarCell.h"
#import "EditingNickNameCell.h"

@interface EditingViewController ()
{
    //是否在编辑头像,用来决定是否刷新
    BOOL isEditingAvatar;
}
@property(nonatomic,assign)BOOL isNet;
@end

@implementation EditingViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _nickName=[[NSString alloc]init];
        _avatar=[[UIImage alloc]init];
        
        dataArray=[[NSMutableArray alloc]init];
        sectionArray=[[NSMutableArray alloc]init];
        
        self.title=@"设置";
        isEditingAvatar = NO;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editSucceed) name:USER_EDIT_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(editFail:) name:USER_EDIT_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reorganizeData:) name:USER_GET_USERINFO_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_GET_USERINFO_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netError) name:USER_NET_ERROR object:nil];
    if (isEditingAvatar == NO) {
        [self getData];
    }
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [BBSColor hexStringToColor:@"f3f3f3"];
    
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 20, VIEWWIDTH, VIEWHEIGHT-20) style:UITableViewStyleGrouped];
    
    if([[[UIDevice currentDevice] systemVersion] floatValue]<7){
        
        _tableView.frame=CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-113);
        
    }
    
    [self setBackBtn];
    
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor = [BBSColor hexStringToColor:@"f3f3f3"];
    [self.view addSubview:_tableView];
    
}
-(void)setBackBtn{
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    self.view.backgroundColor =  [BBSColor hexStringToColor:@"f3f3f3"];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark NSNotification

//网络错误：
-(void)netError{
    NSLog(@"设置网络链接错误");
    _isNet = YES;
    [LoadingView stopOnTheViewController:self];
   // [BBSAlert showAlertWithContent:@"无网络链接" andDelegate:self];
    
}

//编辑：头像 或 昵称
-(void)editSucceed{
    
    [LoadingView stopOnTheViewController:self];
    
    [self getData];
}

-(void)editFail:(NSNotification *)not{
    
    [LoadingView stopOnTheViewController:self];
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}

-(void)reorganizeData:(NSNotification *) not{
    
    [dataArray removeAllObjects];
    [sectionArray removeAllObjects];
    
    NetAccess *net=[NetAccess sharedNetAccess];
    NSString *styleString=not.object;
    NSArray *userArray=[net getReturnDataWithNetStyle:[styleString intValue]];
    MyHomePageItem *item=[userArray objectAtIndex:0];
    
    [sectionArray addObject:@"用户资料"];
    
    EditingAvatarItem *avatarItem=[[EditingAvatarItem alloc]init];
    avatarItem.avatarStr=item.avatarStr;
    
    EditingNickNameItem *nickItem=[[EditingNickNameItem alloc]init];
    nickItem.nickName=item.userName;
    
    EditingRegisterUserNameItem *usernameItem=[[EditingRegisterUserNameItem alloc]init];
    usernameItem.userName=item.registerUserName;
    
    EditingRegiserEmailItem *emailItem=[[EditingRegiserEmailItem alloc]init];
    emailItem.email=item.registerEmail;
    
    EditingBindItem *bindItem = [[EditingBindItem alloc]init];
    
    NSArray *userMess=[NSArray arrayWithObjects:avatarItem,nickItem,usernameItem,emailItem,bindItem, nil];
    [dataArray addObject:userMess];
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSArray *babys=[userDefault objectForKey:USERBABYSARRAY];
    
    if (babys.count) {
        
        [sectionArray addObject:@"我的宝贝"];
        NSMutableArray *babyArray=[[NSMutableArray alloc]init];
        
        for (NSDictionary *babyDic in babys) {
            BabyInfoItem *babyItem=[[BabyInfoItem alloc]init];
            babyItem.babyName=[babyDic objectForKey:@"name"];
            babyItem.babyBirthday=[babyDic objectForKey:@"birthday"];
            babyItem.sex=[babyDic objectForKey:@"sex"];
            babyItem.babyId=[babyDic objectForKey:@"id"];
            [babyArray addObject:babyItem];
        }
        
        [dataArray addObject:babyArray];
        
    }
    
    [sectionArray addObject:@"系统"];
    NSArray *systemArray=[NSArray arrayWithObjects:@"修改密码",@"服务条款",@"联系我们", nil];
    [dataArray addObject:systemArray];
    
    [sectionArray addObject:@""];
    
    NSArray *logoutArray=[NSArray arrayWithObjects:@"退出登录", nil];
    [dataArray addObject:logoutArray];
    
    [_tableView reloadData];
    
    [LoadingView stopOnTheViewController:self];
    
}

-(void)getDataFail:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];
    NSString *errorString=not.object;
    
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}

#pragma mark UITableViewDelegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return [sectionArray objectAtIndex:section];
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [sectionArray count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 20;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0 && indexPath.row==0) {
        return 60;
    }
    return 45;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray *array=[dataArray objectAtIndex:section];
    return [array count];
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell;
    
        NSArray *array=[dataArray objectAtIndex:indexPath.section];
        id obj=[array objectAtIndex:indexPath.row];
        
        if ([obj isKindOfClass:[BabyInfoItem class]]) {
            
            BabyInfoItem *item=[array objectAtIndex:indexPath.row];
            UITableViewCell *newcell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BABYS"];
            
            newcell.textLabel.text=item.babyName;
            newcell.textLabel.font=[UIFont systemFontOfSize:14];
            newcell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell=newcell;
            
        }
        
        else if ([obj isKindOfClass:[EditingAvatarItem class]]) {
            
            EditingAvatarItem *item=[array objectAtIndex:indexPath.row];
            EditingAvatarCell *avatarCell=(EditingAvatarCell *)[[EditingAvatarCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AVATAR"];
            [avatarCell.avatarView sd_setImageWithURL:[NSURL URLWithString:item.avatarStr]];
            cell=avatarCell;
            
        }
        
        else if ([obj isKindOfClass:[EditingNickNameItem class]]) {
            
            EditingNickNameItem *item=[array objectAtIndex:indexPath.row];
            EditingNickNameCell *nicknamecell=[[EditingNickNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"NICKNAME"];
            
            NSString *usernickname=item.nickName;
            nicknamecell.nicknameLabel.text=usernickname;
            cell=nicknamecell;
            
        }
    
        else if ([obj isKindOfClass:[EditingRegisterUserNameItem class]]) {
            
            EditingRegisterUserNameItem *item=[array objectAtIndex:indexPath.row];
            EditingNickNameCell *nicknamecell=[[EditingNickNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"USERNAME"];
            
            NSString *usernickname=item.userName;
            nicknamecell.label.text=@"注册名";
            nicknamecell.nicknameLabel.text=usernickname;
            cell=nicknamecell;
            cell.accessoryType=UITableViewCellAccessoryNone;

        }
    
        else if ([obj isKindOfClass:[EditingRegiserEmailItem class]]) {
            
            EditingRegiserEmailItem *item=[array objectAtIndex:indexPath.row];
            EditingNickNameCell *nicknamecell=[[EditingNickNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EMAIL"];
            
            NSString *usernickname=item.email;
            nicknamecell.label.text=@"注册邮箱";
            nicknamecell.nicknameLabel.text=usernickname;
            cell=nicknamecell;
            cell.accessoryType=UITableViewCellAccessoryNone;
            
        } else if ([obj isKindOfClass:[EditingBindItem class]]) {
          
            EditingNickNameCell *newCell=[[EditingNickNameCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BINDIND"];
            newCell.label.text=@"绑定账号";
            newCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell=newCell;
            
        } else if ([[sectionArray objectAtIndex:indexPath.section] isEqualToString:@"系统"]){
            
            UITableViewCell *newCell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SYSTEM"];
            newCell.textLabel.text=[array objectAtIndex:indexPath.row];
            newCell.textLabel.font=[UIFont systemFontOfSize:14];
            newCell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
            cell=newCell;
            
        } else{
            
            UITableViewCell *logoutcell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LOGOUT"];
            logoutcell.textLabel.text=@"退出登录";
            logoutcell.textLabel.textAlignment=NSTextAlignmentCenter;
            logoutcell.textLabel.font=[UIFont systemFontOfSize:18];
            cell=logoutcell;
        }
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.backgroundColor =[UIColor whiteColor];

    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
        NSArray *array=[dataArray objectAtIndex:indexPath.section];
        id obj=[array objectAtIndex:indexPath.row];
        
        if ([obj isKindOfClass:[EditingAvatarItem class]]) {
            
            _chooseAcs=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选",@"拍摄一张", nil];
            [_chooseAcs showFromTabBar:self.tabBarController.tabBar];
            
        } else if ([obj isKindOfClass:[EditingBindItem class]]) {
            int bindindType = [[[NSUserDefaults standardUserDefaults] objectForKey:USERBINDINDTYPE] intValue];
           
            LoginViewController *loginViewController = [[LoginViewController alloc]init];
            if (bindindType == 0) {
                loginViewController.loginType = TYPE_NORMAL;
            } else {
                loginViewController.loginType = TYPE_BINDING;
            }
            [self.navigationController pushViewController:loginViewController animated:YES];
            
        } else if([obj isKindOfClass:[EditingNickNameItem class]]){
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"修改昵称" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"修改", nil];
            
            alert.alertViewStyle=UIAlertViewStylePlainTextInput;
            alert.tag=EDIT;
            [alert show];
    
        }else if([obj isKindOfClass:[BabyInfoItem class]]){
            
            BabyInfoItem *babyItem=(BabyInfoItem *)obj;
            
            EditBabyViewController *editBaby=[[EditBabyViewController alloc]init];
            editBaby.babyId=babyItem.babyId;
            [editBaby.dataArray addObject:babyItem.babyName];
            [editBaby.dataArray addObject:babyItem.babyBirthday];
            [editBaby.dataArray addObject:babyItem.sex];
            [self.navigationController pushViewController:editBaby animated:YES];
        
        }else if([[sectionArray objectAtIndex:indexPath.section] isEqualToString:@"系统"]){
            NSString *title=[array objectAtIndex:indexPath.row];
            if ([title isEqualToString:@"服务条款"]) {
                ServieceViewController *service=[[ServieceViewController alloc]init];
                [self.navigationController pushViewController:service animated:YES];
            }else if ([title isEqualToString:@"联系我们"]){
                
                EmailViewController *emailController=[[EmailViewController alloc]init];
                [self.navigationController pushViewController:emailController animated:YES];
            }else if ([title isEqualToString:@"修改密码"]){
                ModifyPasswordViewController *modifyViewController = [[ModifyPasswordViewController alloc]init];
                [self.navigationController pushViewController:modifyViewController animated:YES];
            }
            
        }
        else if ([obj isKindOfClass:[NSString class]]){
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"自由环球租赁" message:@"要退出当前用户吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"退出", nil];
            alert.tag=LOGOUT;
            [alert show];
            
        }
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0 && indexPath.row==1) {
        return YES;
    }
    return NO;
}

#pragma mark UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    _imagePicker=[[UIImagePickerController alloc]init];
    if (buttonIndex==0) {
        //从相册选取
//        _isCamera=0;
        _imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.allowsEditing=YES;
        _imagePicker.delegate=self;
        [self.navigationController presentViewController:_imagePicker animated:YES completion:^{}];
    }else if(buttonIndex==1){
        //拍摄一张
//        _isCamera=1;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            _imagePicker.delegate=self;
            _imagePicker.allowsEditing=YES;
            [self.navigationController presentViewController:_imagePicker animated:YES completion:^{}];
        }else{
            [BBSAlert showAlertWithContent:@"相机设备不可用" andDelegate:self];
        }
    }
    [_chooseAcs dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark UIImagePickerController

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    isEditingAvatar = YES;
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self setAvartarImage:image];
   
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}

-(void)setAvartarImage:(UIImage *) image{
    
    NSArray *userMessArray=[dataArray objectAtIndex:0];
    
    NSInteger i=0;
    for (id obj in userMessArray) {

        if ([obj isKindOfClass:[EditingAvatarItem class]]) {
            i=[userMessArray indexOfObject:obj];
        }
    }
    
    _avatar=image;
    NSIndexPath *indexpath=[NSIndexPath indexPathForRow:i inSection:0];
    EditingAvatarCell *cell=(EditingAvatarCell *)[_tableView cellForRowAtIndexPath:indexpath];
    cell.avatarView.image=image;
    
    [LoadingView startOnTheViewController:self];

    NSString *userid=LOGIN_USER_ID;
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:
                         _avatar,kRegistAvatar,
                         userid,@"user_id",nil];
    NetAccess *netAccess=[NetAccess sharedNetAccess];
    [netAccess getDataWithStyle:NetStyleEditUser andParam:param];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==EDIT) {
        if (buttonIndex==1) {
            //修改
            
            NSIndexPath *indexpath=[NSIndexPath indexPathForRow:1 inSection:0];
            EditingNickNameCell *cell=(EditingNickNameCell *)[_tableView cellForRowAtIndexPath:indexpath];
            cell.nicknameLabel.text=_textField.text;
            UITextField *nameField=[alertView textFieldAtIndex:0];
            _nickName=[NSString stringWithFormat:@"%@",nameField.text];
            
            [LoadingView startOnTheViewController:self];
            
            NSString *userid=LOGIN_USER_ID;
            
            NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:
                                 _nickName,@"nick_name",
                                 userid,@"user_id",nil];
            NetAccess *netAccess=[NetAccess sharedNetAccess];
            [netAccess getDataWithStyle:NetStyleEditUser andParam:param];
        }

    }else if (alertView.tag==LOGOUT){
        
        if (buttonIndex==1) {
            [self logout];
        }
        
    }
    
}
+(BOOL)isConnectionAvailable{
    BOOL isUseNetWork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NSParameterAssert([reach isKindOfClass:[Reachability class]]);
    NetworkStatus stats = [reach currentReachabilityStatus];
    if (stats == NotReachable) {
        isUseNetWork = NO;
    }else if (stats == ReachableViaWWAN){
        isUseNetWork = YES;
    }else if (stats == ReachableViaWiFi){
        isUseNetWork = YES;
    }else{
        isUseNetWork = YES;
    }
    if (!isUseNetWork) {
        
        return NO;
    }
    
    return isUseNetWork;
}

    
#pragma mark Private

-(void)getData{
    
    [LoadingView startOnTheViewController:self];
    
    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
    NSString *loginUserId=LOGIN_USER_ID;
    
    NSDictionary *newparam=[NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"user_id", nil];

    [[HTTPClient sharedClient] getNew:kGetBabys params:newparam success:^(NSDictionary *result) {
        
        if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
            NSArray *dataArr=[result objectForKey:@"data"];
            NSMutableArray *babysArray=[NSMutableArray array];
            
            if (dataArr.count) {
                
                for (NSDictionary *babyDic in dataArr) {
                    
                    BabyInfoItem *babyItem=[[BabyInfoItem alloc]init];
                    babyItem.babyName=[babyDic objectForKey:@"baby_name"];
                    babyItem.babyBirthday=[babyDic objectForKey:@"born_date"];
                    babyItem.sex=[babyDic objectForKey:@"baby_sex"];
                    babyItem.babyId=[babyDic objectForKey:@"id"];
                    NSDictionary *baby=[NSDictionary dictionaryWithObjectsAndKeys:babyItem.babyName,@"name",babyItem.babyBirthday,@"birthday",babyItem.sex,@"sex",babyItem.babyId,@"id", nil];
                    [babysArray addObject:baby];
                    
                }
                [userDefault setObject:babysArray forKey:USERBABYSARRAY];
                [userDefault synchronize];
                if (_tableView) {
                    [_tableView reloadData];
                }
            } else {
                //
                [userDefault removeObjectForKey:USERBABYSARRAY];
                [userDefault synchronize];

            }
        } else {
            //
        }
        
    } failed:^(NSError *error) {
        
    }];
 
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:loginUserId,@"user_id",loginUserId,@"idol_id",@"0",@"is_idoled", nil];
    
    NetAccess *netAccess=[NetAccess sharedNetAccess];
    [netAccess getDataWithStyle:NetStyleMyHomePage andParam:param];

}

-(void)logout{
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NSParameterAssert([reach isKindOfClass:[Reachability class]]);
    NetworkStatus stats = [reach currentReachabilityStatus];
    if (stats == NotReachable) {
        [BBSAlert showAlertWithContent:@"退出登录失败，当前网络未连接，请检查网络状态" andDelegate:nil];

    }else{
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *item = [manager currentUserInfo];
        NSLog(@"itemitem = %@",item.password);
    //退出登录前保存用户最后登录的信息
    [[NSUserDefaults standardUserDefaults]objectForKey:USERPASSWORD];
    NSUserDefaults *lastUserMess = [NSUserDefaults standardUserDefaults];
    [lastUserMess setObject:item.userName forKey:@"userNameLastLogin"];
    [lastUserMess setObject:item.password forKey:@"userPasswordLastLogin"];
    [lastUserMess setObject:item.avatarStr forKey:@"userAvatarLastLogin"];
    [manager removeCurrentUserInfo];
    
    UIApplication *app=[UIApplication sharedApplication];
    AppDelegate *delegate=(AppDelegate *)app.delegate;
    delegate.isNewLogin=1;
    [delegate  setVistorLogin];
    }
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
