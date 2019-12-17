//
//  LoginViewController.m
//  BabyShow
//
//  Created by Lau on 13-12-9.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "LoginViewController.h"
#import "NSString+NSString_MD5.h"
#import "FindPwdStep1ViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "APService.h"
@interface LoginViewController ()<UIAlertViewDelegate>
{
    UITextField *_nameTextField;
    
    UITextField *_passwordTextField;
    
    UIButton *_loginBtn;
    UIButton *_backBtn;
    UIButton *_findPwdBtn;
    
    NSArray *_listsArray;
    //当前定位的装态
    
}
@property(nonatomic,assign)float latitude;//纬度
@property(nonatomic,assign)float longitude;//经度

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _loginType = TYPE_LOGIN;
        _listsArray = [[NSArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    

    //self.view.backgroundColor = [BBSColor hexStringToColor:[NSString stringWithFormat:@"#F5f5f5"]];
    [self setBackButton];
    
    if (self.loginType != TYPE_NORMAL) {
        [self setWithLoginOrBindType];
    } else {
        //request
        [self getBindingList];
    }
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchOnTheView)];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucceed:) name:USER_LOGIN_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFail:) name:USER_LOGIN_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    
}
- (void)setBackButton {
    CGRect backBtnFrame = CGRectMake(0, 0, 49, 31);
    
    _backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [_backBtn setFrame:backBtnFrame];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_backBtn];
}
- (void)setWithNormalType:(NSArray *)array {
    
    for (UIView *subView in self.view.subviews) {
        [subView removeFromSuperview];
    }
    
    self.title = @"绑定信息";
   // self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"img_tableview_background.png"]];
    
    CGRect tintLabelFrame = CGRectMake(10, 65, SCREENWIDTH-20, 50);
    UILabel *tintLabel = [[UILabel alloc]initWithFrame:tintLabelFrame];
    tintLabel.numberOfLines = 0;
    tintLabel.font = [UIFont systemFontOfSize:16];
    tintLabel.textColor = [BBSColor hexStringToColor:@"0A0A0A"];
    if (array.count <= 0) {
        tintLabel.text = @"您没有绑定任何账号,如需绑定,请登录您的微博或微信账号";
    }
    
    [self.view addSubview:tintLabel];
    
    for (int i = 0; i < array.count; i++) {
        
        NSDictionary *dict = [array objectAtIndex:i];
        
        NSInteger type = [[dict objectForKey:@"user_type"] integerValue];
        NSString *nick_name = [dict objectForKey:@"nick_name"];
        
        UIView *aView = [[UIView alloc]initWithFrame:CGRectMake(0, 65 + i*60, SCREENWIDTH, 60)];
        aView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:aView];
        
        CGRect imageViewFrame = CGRectMake(15, 13.25 , 33.5, 33.5);
        CGRect thirdNameFrame = CGRectMake(55, 8 , 130, 30);
        CGRect nicknameFrame = CGRectMake(57.5, 28 , 130, 30);
        CGRect cancelBindFrame = CGRectMake(SCREENWIDTH - 70, 17.5 , 53, 25);
        CGRect seperatorLineFrame = CGRectMake(0, 59, SCREENWIDTH, 1);
        
        UIImageView *imageV = [[UIImageView alloc]initWithFrame:imageViewFrame];
        imageV.backgroundColor = [UIColor clearColor];
        [aView addSubview:imageV];
        
        UILabel *thirdNameLabel = [[UILabel alloc]initWithFrame:thirdNameFrame];
        thirdNameLabel.backgroundColor = [UIColor clearColor];
        thirdNameLabel.textColor = [BBSColor hexStringToColor:@"060606"];
        thirdNameLabel.font = [UIFont systemFontOfSize:15.0];
        [aView addSubview:thirdNameLabel];
        
        if (type == 1) {
            thirdNameLabel.text = @"新浪微博";
            imageV.image = [UIImage imageNamed:@"img_weibo_icon"];
        } else if (type == 2) {
            thirdNameLabel.text = @"微信";
            imageV.image = [UIImage imageNamed:@"img_weixin_icon"];
        }
        
        UILabel *nicknameLabel = [[UILabel alloc]initWithFrame:nicknameFrame];
        nicknameLabel.backgroundColor = [UIColor clearColor];
        nicknameLabel.textColor = [BBSColor hexStringToColor:@"929292"];
        nicknameLabel.font = [UIFont systemFontOfSize:12.0];
        nicknameLabel.text = nick_name;
        [aView addSubview:nicknameLabel];
        
        UIButton *cancelBindBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        cancelBindBtn.frame = cancelBindFrame;
        [cancelBindBtn setBackgroundImage:[UIImage imageNamed:@"btn_cancelBind"] forState:UIControlStateNormal];
        cancelBindBtn.tag = i;
        [cancelBindBtn addTarget:self action:@selector(cancelBind:) forControlEvents:UIControlEventTouchUpInside];
        [aView addSubview:cancelBindBtn];
        
        UIView *seperatorView = [[UIView alloc]initWithFrame:seperatorLineFrame];
        seperatorView.backgroundColor = [BBSColor hexStringToColor:@"f0f0f0"];
        [aView addSubview:seperatorView];
    }
    
    
}
- (void)setWithLoginOrBindType {
    self.title = @"登录";
    
    CGRect nameTextFieldFrame = CGRectMake(40, 85, VIEWWIDTH-80, 38);
    CGRect passwordTextFieldFrame = CGRectMake(40, 143, VIEWWIDTH-80, 38);
    CGRect findBtnFrame = CGRectMake(215, 190, 70, 20);
    
    UIImage *loginImage = [UIImage imageNamed:@"btn_login.png"];
    CGRect loginBtnFrame = CGRectMake((SCREENWIDTH-loginImage.size.width)/2, 220, loginImage.size.width, loginImage.size.height);
    
    UIFont *font=[UIFont systemFontOfSize:14];
    
    _nameTextField=[[UITextField alloc]initWithFrame:nameTextFieldFrame];
    _nameTextField.font=font;
    _nameTextField.borderStyle=UITextBorderStyleRoundedRect;
    _nameTextField.placeholder=@"用户名/注册邮箱：";
    _nameTextField.delegate=self;
    _nameTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:_nameTextField];
    
    _passwordTextField=[[UITextField alloc]initWithFrame:passwordTextFieldFrame];
    _passwordTextField.font=font;
    _passwordTextField.placeholder=@"密码：";
    _passwordTextField.delegate=self;
    _passwordTextField.secureTextEntry=YES;
    _passwordTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _passwordTextField.borderStyle=UITextBorderStyleRoundedRect;
    [self.view addSubview:_passwordTextField];
    
    _loginBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _loginBtn.titleLabel.font=font;
    [_loginBtn setBackgroundImage:loginImage forState:UIControlStateNormal];
    [_loginBtn setFrame:loginBtnFrame];
    [_loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    _findPwdBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_findPwdBtn setTitle:@"忘记密码?" forState:UIControlStateNormal];
    _findPwdBtn.titleLabel.font=font;
    [_findPwdBtn setTitleColor:[BBSColor hexStringToColor:BACKCOLOR] forState:UIControlStateNormal];
    [_findPwdBtn setFrame:findBtnFrame];
    [_findPwdBtn addTarget:self action:@selector(gotoFindPwd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_findPwdBtn];
    
    if (self.loginType == TYPE_BINDING) {
        self.title = @"绑定";
        [_loginBtn setBackgroundImage:[UIImage imageNamed:@"btn_binding"] forState:UIControlStateNormal];
        _findPwdBtn.hidden = YES;
    }
    
}
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [super viewWillAppear:animated];
}
-(void)gotoFindPwd{
    FindPwdStep1ViewController *step1ViewController = [[FindPwdStep1ViewController alloc]init];
    [self.navigationController pushViewController:step1ViewController animated:YES];
}
#pragma mark private

- (void)getBindingList {
    [LoadingView startOnTheViewController:self];
    NSString *userId = LOGIN_USER_ID;
    [[HTTPClient sharedClient] getNew:kBindShowUserList params:@{@"user_id":userId} success:^(NSDictionary *result) {
        [LoadingView stopOnTheViewController:self];
        if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
            NSArray *array = [result objectForKey:kBBSData];
            _listsArray = array;
            [self setWithNormalType:array];
        } else {
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
        [BBSAlert showAlertWithContent:@"网络连接失败,请稍后重试" andDelegate:nil];
    }];
}

-(void)netFail{
    
    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    
}

-(void)touchOnTheView{
    [_nameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)login{
    
    [MobClick event:UMEVENTLOGIN];
    
    [_nameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
    if (_nameTextField.text.length <= 0 || _passwordTextField.text.length <=0 ) {
        [BBSAlert showAlertWithContent:@"请输入用户名或密码" andDelegate:nil];
        return;
    }
    
    if (self.loginType == TYPE_LOGIN) {
        NSUserDefaults *defaultlat = [NSUserDefaults standardUserDefaults];
        NSString *lat = [defaultlat valueForKey:@"latitude"];
        NSUserDefaults *defaultlog = [NSUserDefaults standardUserDefaults];
        NSString *longitude = [defaultlog valueForKey:@"longitude"];
        NSString *identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];

        NSDictionary *param ;
        if (!lat||!longitude) {
            param=[NSDictionary dictionaryWithObjectsAndKeys:_nameTextField.text,kUserName,
                   [_passwordTextField.text md5],kPassword,identifierForVendor,@"imin",@"",@"mapsign",nil];
        }else{
            
            param=[NSDictionary dictionaryWithObjectsAndKeys:_nameTextField.text,kUserName,[_passwordTextField.text md5],kPassword,identifierForVendor,@"imin",[NSString stringWithFormat:@"%@,%@",lat,longitude],@"mapsign",nil];
        }
        [[NetAccess sharedNetAccess] getDataWithStyle:NetStyleLogin andParam:param];
        [LoadingView startOnTheViewController:self];
    } else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"绑定成功" message:nil delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.tag = 100;
        
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        NSString *userLoginType = [userDefaults objectForKey:USERLOGINTYPE];
        NSString *userId = [userDefaults objectForKey:USERID];
        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:userId,kBindUID,userLoginType,kBindUser_type,_nameTextField.text,kBindUser_name,[_passwordTextField.text md5],kBindPassword, nil];
        [[HTTPClient sharedClient] postNew:kBindUser params:param success:^(NSDictionary *result) {
            [LoadingView startOnTheViewController:self];
            if ([[result objectForKey:kBBSSuccess] integerValue]==1) {
                NSDictionary *dataDic=[result objectForKey:@"data"];
                [userDefaults setObject:[dataDic objectForKey:@"user_id"] forKey:USERID];
                [userDefaults setObject:[dataDic objectForKey:@"user_name"] forKey:USERNAME];
                [userDefaults setObject:[dataDic objectForKey:@"nick_name"] forKey:USERNICKNAME];
                [userDefaults setObject:[dataDic objectForKey:@"email"] forKey:USEREMAIL];
                [userDefaults setObject:[dataDic objectForKey:@"avatar"] forKey:USERAVATARSTR];
                [userDefaults setObject:[NSNumber numberWithBool:NO] forKey:USERISAVISIVOR];
                [userDefaults setObject:[NSNumber numberWithInteger:0] forKey:USERBINDINDTYPE];
                [userDefaults synchronize];
                NSLog(@"%@",[userDefaults objectForKey:USERBINDINDTYPE]);
                [alertView show];
                
            } else {
                [LoadingView stopOnTheViewController:self];
            }
            
        } failed:^(NSError *error) {
            [LoadingView stopOnTheViewController:self];
            [BBSAlert showAlertWithContent:@"网络连接失败,请稍后重试" andDelegate:nil];
        }];
    }
}

-(void)loginSucceed:(NSNotification *) not{
    
    UIApplication *app=[UIApplication sharedApplication];
    AppDelegate *delegate=(AppDelegate *)app.delegate;
    [delegate setBBSTabBarController];

        
}

-(void)loginFail:(NSNotification *) not{
    
    NSString *errorString=not.object;
    
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:errorString andDelegate:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (void)cancelBind:(UIButton *)sender {
    
//    NSDictionary *dict = [_listsArray objectAtIndex:sender.tag];
//    NSString *user_type = [dict objectForKey:@"user_type"];
//    NSString *user_id = [[NSUserDefaults standardUserDefaults] objectForKey:USERID];
//    
//    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:user_id,kCancelBindUser_id,user_type,kCancelBindUser_type, nil];
//    [LoadingView startOnTheViewController:self];
//    [[HTTPClient sharedClient] postNew:kCancelBind params:param success:^(NSDictionary *result) {
//        [LoadingView stopOnTheViewController:self];
//        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
//            if ([user_type integerValue] == 1) {
//                //微博取消授权
//                if ([ShareSDK hasAuthorizedWithType:ShareTypeSinaWeibo]) {
//                    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
//                }
//            } else if ([user_type integerValue] == 2) {
//                //微信取消授权
//                if ([ShareSDK hasAuthorizedWithType:ShareTypeWeixiSession]) {
//                    [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
//                }
//            }
//            [self getBindingList];
//        } else {
//            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
//        }
//    } failed:^(NSError *error) {
//        [LoadingView stopOnTheViewController:self];
//        [BBSAlert showAlertWithContent:@"网络连接失败,请稍后重试" andDelegate:nil];
//    }];
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.layer.borderWidth = 1.0;
    textField.layer.borderColor=[[BBSColor hexStringToColor:BACKCOLOR] CGColor];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.layer.borderWidth=0;
    textField.layer.borderColor=[[UIColor darkGrayColor] CGColor];
    
    return YES;
}

#pragma mark UITabBarControllerDelegate

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    UINavigationController *nav=(UINavigationController *)tabBarController.selectedViewController;
    
    [nav popToRootViewControllerAnimated:YES];
    
}
#pragma mark - UIAlertView
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 100) {
        [self loginSucceed:nil];
    }
}

@end
