//
//  LoginHTMLVC.m
//  BabyShow
//
//  Created by WMY on 16/3/10.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "LoginHTMLVC.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <SMS_SDK/SMSSDK.h>
//#import <SMS_SDK/SMSSDKCountryAndAreaCode.h>
//#import <SMS_SDK/SMSSDK+DeprecatedMethods.h>
//#import <SMS_SDK/SMSSDK+ExtexdMethods.h>
#import <MOBFoundation/MOBFoundation.h>
#import "InputCheck.h"
#import "RegisterStep2ViewController.h"
#import "APService.h"
#import "MyHomeNewVersionVC.h"
#import <ShareSDKExtension/SSEThirdPartyLoginHelper.h>
#import "ChangePhoneNumber2VC.h"
#import <ShareSDKExtension/ShareSDK+Extension.h>

@interface LoginHTMLVC ()
@property (nonatomic,weak) JSContext * context;
@property(nonatomic,assign)BOOL isWeixin;
@property(nonatomic,strong)NSString *lat;
@property(nonatomic,strong)NSString *log;
@property(nonatomic,strong)NSString *identifierForVendor;
@property(nonatomic,strong)NSString *phoneNumber;

@end

@implementation LoginHTMLVC
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    
    //登陆第三方需要的
    NSUserDefaults *defaultlat = [NSUserDefaults standardUserDefaults];
    _lat = [defaultlat valueForKey:@"latitude"];
    NSUserDefaults *defaultlog = [NSUserDefaults standardUserDefaults];
    _log = [defaultlog valueForKey:@"longitude"];
    _identifierForVendor = [[UIDevice currentDevice].identifierForVendor UUIDString];
    _isWeixin = [self checkWeiXin];
    self.navigationController.navigationBarHidden = YES;
    
    _webView = [[UIWebView alloc]init];
//WithFrame:CGRectMake(0, -StatusBar_HEIGHT, SCREENWIDTH, SCREENHEIGHT+StatusBar_HEIGHT)];
    if (ISIPhoneX) {
        _webView.frame = CGRectMake(0, StatusBar_HEIGHT, SCREEN_WIDTH, SCREENHEIGHT);
    }else{
        _webView.frame = CGRectMake(0, -StatusBar_HEIGHT, SCREENWIDTH, SCREENHEIGHT+StatusBar_HEIGHT);
    }
    _webView.delegate = self;
    NSString *htmlPath = [[NSBundle mainBundle]pathForResource:@"bbss_login" ofType:@"html"];
    
    
    NSURL *url =[NSURL fileURLWithPath:htmlPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
    /*
     用这种方法加载没有办法返回
     NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
     NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
     //18519288893
     [_webView loadHTMLString:appHtml baseURL:baseURL];
     */
#ifdef __IPHONE_11_0
    if (@available(iOS 11.0, *)) {
        
    }
#endif
    
  
    

    [self.view addSubview:_webView];;
    // Do any additional setup after loading the view.
}

#pragma mark
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *userItem=[manager currentUserInfo];
    if ([userItem.isVisitor boolValue]==YES || LOGIN_USER_ID == NULL){
        //如果是游客身份的时候，没登录成功
        if (self.delegate && [self.delegate respondsToSelector:@selector(loginViewControllerDimissDelegate)]) {
            [self.delegate loginViewControllerDimissDelegate];
        }
    }
}
#pragma mark UIWebViewDelegate -
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([@"mytest" isEqualToString:request.URL.scheme]) {
        
        SEL selector = NSSelectorFromString(request.URL.host);
        
        if ([self respondsToSelector:selector]) {
            [self performSelector:selector];
        }
        return NO;
    }
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    //1、oc传到js的用户的历史登陆数据
    NSString *userName = [[NSUserDefaults standardUserDefaults]objectForKey:@"userNameLastLogin"];
    NSString *userPassword = [[NSUserDefaults standardUserDefaults]objectForKey:@"userPasswordLastLogin"];
    NSString *userAvatar = [[NSUserDefaults standardUserDefaults]objectForKey:@"userAvatarLastLogin"];
    NSLog(@"userName = %@,userPassword = %@,userAvatar = %@",userName,userPassword,userAvatar);
    if (userName != NULL) {
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"setUserNameAndPwdAndIconUrl('%@','%@','%@');",userName,userPassword,userAvatar]];
    }
    
    [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"inputChange()"]];
    
    //2、oc获取js传来的请求登陆的参数
    _context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    _context[@"callMethodLogin"] = ^(){
        NSArray *args = [JSContext currentArguments];
        NSString *userName = args[0];
        NSString *passWrd = args[1];
        //请求登陆
        [self userLogin:userName userPwd:passWrd];
    };
    //3、传值到js检查是否安装微信改变js页面布局
    if (_isWeixin) {
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"iconShow('%@','%@');",@"YES",@"YES"]];
    }else{
        [_webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"iconShow('%@','%@');",@"YES",@"NO"]];
    }
    //4、微博登陆
    _context[@"callMethodWeiboLogin"]=^(){
        [self weibo];
        
    };
    //5、微信登陆
    _context[@"callMethodWeixinLogin"]=^(){
        [self isHaveSSDKPLatformTypeWechat];
    };
    //6、点击左侧按钮取消js页面
    _context[@"callMethodFinish"] = ^(){
        [self callMethodFinish];
    };
    //7、点击注册更换html页面
    _context[@"updateTitleAndFrame"]=^(){
        NSArray *args = [JSContext currentArguments];
        BOOL isHiddenLeft = !args[0];
        BOOL isHiddenMid = !args[1];
        BOOL isHiddenRight = !args[2];
        NSString *titleMid = [NSString stringWithFormat:@"%@",args[3]];
        NSString *titleRight = [NSString stringWithFormat:@"%@",args[4]];
        [self updateTitleAndFrameIsHiddenLeft:(BOOL)isHiddenLeft  isHiddenMid:(BOOL)isHiddenMid isHiddenRight:(BOOL) isHiddenRight titleMid:(NSString *)titleMid titleRight:(NSString *)titleRight];
    };
    
    //在注册页面的交互
    //1、点击获取验证码
    _context[@"callMethodSendSms"]=^(){
        NSArray *argPhoneNumber = [JSContext currentArguments];
        NSString *phoneString = [NSString stringWithFormat:@"%@",argPhoneNumber[0]];
        [self sendPhoneNumber:(NSString*)phoneString];
    };
    //2、点击注册按钮
    _context[@"callMethodRegister"]=^(){
        NSArray *registerMes = [JSContext currentArguments];
        NSString *phoneNumber = [NSString stringWithFormat:@"%@",registerMes[0]];
        NSString *codeNumber = [NSString stringWithFormat:@"%@",registerMes[2]];
        NSString *pwdNumber = [NSString stringWithFormat:@"%@",registerMes[1]];
        NSString *pwdconNumber = [NSString stringWithFormat:@"%@",registerMes[1]];
        [self regiserUserPhoneNumber:phoneNumber code:codeNumber pwd:pwdNumber pwdconNumber:pwdconNumber];
        
    };
    //点击找回密码页面变化
    //点击下一步,获取验证码
    _context[@"callMethodCheckSms"]=^(){
        NSArray *smMes = [JSContext currentArguments];
        NSString *phoneNumber = [NSString stringWithFormat:@"%@",smMes[0]];
        NSString *phoneCore = [NSString stringWithFormat:@"%@",smMes[1]];
        [self checkNumberPhone:phoneNumber code:phoneCore];
        
    };
    //重置密码点击确定
    _context[@"callMethodResetPwd"]=^(){
        NSArray *passWord = [JSContext currentArguments];
        NSString *passWordString = [NSString stringWithFormat:@"%@",passWord[0]];
        [self resertPassWord:passWordString];
    };
    


}
#pragma mark  在找回密码页面的下一步验证手机号和验证码

-(void)checkNumberPhone:(NSString*)phoneNumber code:(NSString*)codePhone{
    
    [SMSSDK commitVerificationCode:codePhone phoneNumber:phoneNumber zone:@"86" result:^(NSError *error) {
        if (!error) {
            NSString *htmlPath = [[NSBundle mainBundle]pathForResource:@"bbss_resetPwd" ofType:@"html"];
            NSString *appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
            NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
            [_webView loadHTMLString:appHtml baseURL:baseURL];
            _phoneNumber = phoneNumber;
            
            
        }
        else
        {
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                            message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]]
                                                           delegate:self
                                                  cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                  otherButtonTitles:nil, nil];
            _phoneNumber = phoneNumber;
            [alert show];
        }
    }];
    
}

#pragma mark 在找回密码第二页上重置密码
-(void)resertPassWord:(NSString*)password{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:_phoneNumber,@"mobile",[password md5],kRegistPassword,[password md5],@"confirm_password",nil];
    [[HTTPClient sharedClient]postNew:kEditPassword params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            [BBSAlert showAlertWithContent:@"密码重置成功" andDelegate:nil];
            [self userLogin:_phoneNumber userPwd:password];
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
        
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"网络错误请稍后重试" andDelegate:nil];
        
    }];
    
    
    
    
}
#pragma mark 发送验证码
-(void)sendPhoneNumber:(NSString*)phoneString{
   // [LoadingView startOnTheViewController:self];
    if (phoneString.length!= 11) {
       // [LoadingView stopOnTheViewController:self];
        //手机号码不正确
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                        message:NSLocalizedString(@"手机号格式有误，请重新输入", nil)
                                                       delegate:self
                                              cancelButtonTitle:NSLocalizedString(@"知道了", nil)
                                              otherButtonTitles:nil, nil];
        [alert show];
        return;
        
    }else{
        
        [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneString
                                       zone:@"86"
                                      template:nil
                                     result:^(NSError *error)
         {
             if (!error)
             {
                // [LoadingView stopOnTheViewController:self];
                 [BBSAlert showAlertWithContent:@"验证码发送成功，注意查收" andDelegate:nil];
                 
             }
             else
             {
                 //[LoadingView stopOnTheViewController:self];
                 UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                                 message:[NSString stringWithFormat:@"错误描述：%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                                delegate:self
                                                       cancelButtonTitle:NSLocalizedString(@"知道了", nil)
                                                       otherButtonTitles:nil, nil];
                 
                 [alert show];
             }
             
         }];
        
    }
    
    
    
}
#pragma mark 点击注册时页面的变化
-(void)updateTitleAndFrameIsHiddenLeft:(BOOL)isHiddenLeft  isHiddenMid:(BOOL)isHiddenMid isHiddenRight:(BOOL) isHiddenRight titleMid:(NSString *)titleMid titleRight:(NSString *)titleRight{
    self.title = titleMid;
    NSMutableDictionary *textAttribute = [NSMutableDictionary dictionary];
    textAttribute[NSForegroundColorAttributeName] = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes =textAttribute;
    
    self.navigationController.navigationBarHidden = NO;
    
    //返回
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(dissmissRegister:) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    self.navigationController.navigationBar.barTintColor = [BBSColor hexStringToColor:NAVICOLOR];
    _webView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    
}

#pragma mark 消失注册或找回密码返回登陆
-(void)dissmissRegister:(id)sender{
    if ([_webView canGoBack]) {
        [_webView goBack];
        self.navigationController.navigationBarHidden = YES;
        _webView.frame = CGRectMake(0, -20, SCREENWIDTH, SCREENHEIGHT+20);
    }else{
        
    }
    
}
#pragma mark 点击注册的时候
-(void)regiserUserPhoneNumber:(NSString*)phoneNumber code:(NSString *)code pwd:(NSString *)pwd pwdconNumber:(NSString*)pwdconNumber{
    if(code.length != 4)
    {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                        message:NSLocalizedString(@"验证码格式有误请重新输入", nil)
                                                       delegate:self
                                              cancelButtonTitle:@"知道了"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        InputCheck *inputCheck=[[InputCheck alloc]init];
        NSString *firstPassWord = pwd;
        NSString *secondePassWord = pwdconNumber;
        if (firstPassWord.length <= 0) {
            
            [self showHUDWithMessage:@"设置密码不能为空"];
        }
        if (secondePassWord.length <= 0) {
            
            [self showHUDWithMessage:@"确认密码不能为空"];
            
            
        }
        if (![inputCheck passwordCheck:firstPassWord]) {
            
            [BBSAlert showAlertWithContent:@"请输入正确格式的密码哦：6~16个字母或数字" andDelegate:self];
            return;
        }
        if (![inputCheck passwordCompareCheck:firstPassWord withRePeat:secondePassWord]) {
            [self showHUDWithMessage:@"两次密码不一致"];
            return;
        }
        
        [SMSSDK commitVerificationCode:code phoneNumber:phoneNumber zone:@"86" result:^(NSError *error) {
            if (!error) {
                
                NSLog(@"成功成功啦");
                [self registerDataWithPhoneNumber:phoneNumber pwd:pwd confirm:pwdconNumber];
                
            }
            else
            {
                
                NSLog(@"验证失败失败啦");
                
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"提示", nil)
                                                                message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"commitVerificationCode"]]
                                                               delegate:self
                                                      cancelButtonTitle:NSLocalizedString(@"确定", nil)
                                                      otherButtonTitles:nil, nil];
                [alert show];
            }
        }];
    }
}
#pragma mark 注册用户
//注册用户
-(void)registerDataWithPhoneNumber:(NSString*)phoneNumber pwd:(NSString*)pwd confirm:(NSString*)confirmPwd{
    //[LoadingView startOnTheViewController:self];
    NSUserDefaults *defaultlat = [NSUserDefaults standardUserDefaults];
    NSString *lat = [defaultlat valueForKey:@"latitude"];
    NSUserDefaults *defaultlog = [NSUserDefaults standardUserDefaults];
    NSString *longitude = [defaultlog valueForKey:@"longitude"];
    NSMutableDictionary *param;
    param=[NSMutableDictionary dictionaryWithObjectsAndKeys:
           [pwd md5] ,kRegistPassword,[confirmPwd md5],@"confirm_password",phoneNumber,@"mobile",[NSString stringWithFormat:@"%@,%@",lat,longitude],@"mapsign",nil];
    
    [[HTTPClient sharedClient]postNewV1:kRegistMobile params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *dataDic = [result objectForKey:kBBSData];
            UserInfoItem *item = [[UserInfoItem alloc]init];
            item.avatarStr = [dataDic objectForKey:@"avatar"];
            item.email = [dataDic objectForKey:@"email"];
            item.nickname = [dataDic objectForKey:@"nick_name"];
            item.userId = [dataDic objectForKey:@"user_id"];
            item.city = [dataDic objectForKey:@"city"];
            
            item.isVisitor = [NSNumber numberWithBool:NO];
            //登陆成功的时候设置标签和别名
            //设置标签
            __autoreleasing NSMutableSet *tags = [NSMutableSet set];
            [self setTags:&tags addTag:item.city];
            //设置别名
            __autoreleasing NSString *alias = [NSString stringWithFormat:@"%@",item.userId];
            [self analyseInput:&alias tags:&tags];
            
            [APService setTags:tags
                         alias:alias
              callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                        target:self];
            
            UserInfoManager *manager = [[UserInfoManager alloc]init];
            [manager saveUserInfo:item];
            [[NSNotificationCenter defaultCenter]postNotificationName:USER_LOGIN_HTML_SUCCEED object:nil];
            [self gotoAddAChild];
            
        }else{
            
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
            
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"您的网络不给力，换一个吧！" andDelegate:nil];
    }];
}
#pragma mark  注册成功之后的添加宝宝
-(void)gotoAddAChild{
    [MobClick event:UMEVENTLOGIN];
    [MobClick event:UMEVENTREGISTER];
    //[LoadingView stopOnTheViewController:self];
    RegisterStep2ViewController *step2=[[RegisterStep2ViewController alloc]init];
    step2.Type=0;
    [self.navigationController pushViewController:step2 animated:YES];
    
}
#pragma mark 登陆请求

-(void)userLogin:(NSString*)userName userPwd:(NSString *)userPwd{
    // [LoadingView startOnTheViewController:self];
    
    NSString *userPwds = [NSString stringWithFormat:@"%@",userPwd];
    
    NSDictionary *paramDic = [NSDictionary dictionaryWithObjectsAndKeys:userName,kUserName,[userPwds md5],kPassword,_identifierForVendor,@"imin",[NSString stringWithFormat:@"%@,%@",_lat,_log],@"mapsign",nil];
    [[HTTPClient sharedClient]postNewV1:kLogin params:paramDic success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSDictionary *dataDic=[result objectForKey:@"data"];
            UserInfoItem *userItem=[[UserInfoItem alloc]init];
            userItem.userId=[dataDic objectForKey:@"user_id"];
            userItem.email=[dataDic objectForKey:@"email"];
            userItem.userName=[dataDic objectForKey:@"user_name"];
            userItem.nickname=[dataDic objectForKey:@"nick_name"];
            userItem.avatarStr=[dataDic objectForKey:@"avatar"];
            userItem.city = [dataDic objectForKey:@"city"];
            userItem.isVisitor=[NSNumber numberWithBool:NO];
            userItem.password = [NSString stringWithFormat:@"%@",userPwd];
            UserInfoManager *userInfoManager=[[UserInfoManager alloc]init];
            [userInfoManager saveUserInfo:userItem];
            //登陆成功的时候设置标签和别名
            [[NSNotificationCenter defaultCenter]postNotificationName:USER_LOGIN_HTML_SUCCEED object:nil];
            
            //设置标签
            __autoreleasing NSMutableSet *tags = [NSMutableSet set];
            [self setTags:&tags addTag:userItem.city];
            //设置别名
            __autoreleasing NSString *alias = [NSString stringWithFormat:@"%@",userItem.userId];
            [self analyseInput:&alias tags:&tags];
            
            [APService setTags:tags
                         alias:alias
              callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                        target:self];
            //[LoadingView stopOnTheViewController:self];
            [self dismissViewControllerAnimated:YES completion:^{
            }];
            
            
        }else{
            //[LoadingView stopOnTheViewController:self];
            NSString *errorString=[result objectForKey:@"reMsg"];
            [BBSAlert showAlertWithContent:errorString andDelegate:self];
        }
        
    } failed:^(NSError *error) {
        //[LoadingView stopOnTheViewController:self];
        [BBSAlert showAlertWithContent:@"您的网络不给力，换一个吧！" andDelegate:nil];
        
    }];
}
#pragma mark 微博登陆
-(void)weibo{
    [LoadingView startOnTheViewController:self];
    [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        if (state == SSDKResponseStateSuccess) {
            NSDictionary *ParamDic;
            ParamDic=[NSDictionary dictionaryWithObjectsAndKeys:user.uid,@"uid",
                      user.nickname,@"user_name",
                      @"1",@"user_type",
                      user.icon,@"protrait",
                      @"1",@"client_type",_identifierForVendor,@"imin",[NSString stringWithFormat:@"%@,%@",_lat,_log],@"mapsign",nil];
            UrlMaker *_urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kLoginV1 Method:NetMethodPost andParam:ParamDic];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:_urlMaker.url];
            for (NSString *key in [ParamDic allKeys]) {
                [request setPostValue:[ParamDic objectForKey:key] forKey:key];}
            __weak ASIFormDataRequest *blockRequest = request;
            [request startAsynchronous];
            [request setCompletionBlock:^{
                NSDictionary *dic=[blockRequest.responseString objectFromJSONString];
                BOOL success=[[dic objectForKey:@"success"] boolValue];
                if (success==YES) {
                    NSDictionary *dataDic=[dic objectForKey:@"data"];
                    UserInfoItem *userItem=[[UserInfoItem alloc]init];
                    userItem.userId=[dataDic objectForKey:@"user_id"];
                    userItem.email=[dataDic objectForKey:@"email"];
                    userItem.userName=[dataDic objectForKey:@"user_name"];
                    userItem.nickname=[dataDic objectForKey:@"nick_name"];
                    userItem.avatarStr=[dataDic objectForKey:@"avatar"];
                    userItem.city = [dataDic objectForKey:@"city"];
                    userItem.isVisitor=[NSNumber numberWithBool:YES];
                    userItem.loginType = LOGINUSERTYPESINAWEIBOUSER;
                    userItem.isMobile = [dataDic objectForKey:@"is_mobile"];
                    NSLog(@"微博登陆的各项信息 = %@,%@",dataDic,userItem.isMobile);
                    //dataDic[@"is_mobile"];
                    //source ,0绑定过老账户,1微博(没绑定过)
                    userItem.bindingType = [[dataDic objectForKey:@"source"] integerValue];
                    UserInfoManager *userInfoManager=[[UserInfoManager alloc]init];
                    [userInfoManager saveUserInfo:userItem];
                    
                    [LoadingView stopOnTheViewController:self];
                    if ([userItem.isMobile isEqualToString:@"0"]) {
                        ChangePhoneNumber2VC *change2VC = [[ChangePhoneNumber2VC alloc]init];
                        change2VC.typeChangeOrBing = 1;//之前没有手机号现在绑定
                        change2VC.fromLogin = @"login";
                        if ([self.fromTabBar isEqualToString:@"fromTabBar"]) {
                            change2VC.isFromTab = YES;
                        }
                        [self.navigationController pushViewController:change2VC animated:YES];
                    }else{
                        userItem.isVisitor=[NSNumber numberWithBool:NO];
                        [userInfoManager saveUserInfo:userItem];
                        [[NSNotificationCenter defaultCenter]postNotificationName:USER_LOGIN_HTML_SUCCEED object:nil];
                        [self dismissViewControllerAnimated:YES completion:^{
                        }];
                    }
//                    [[NSNotificationCenter defaultCenter]postNotificationName:USER_LOGIN_HTML_SUCCEED object:nil];
//                    [self dismissViewControllerAnimated:YES completion:^{}];
                    //登陆微博成功的时候设置标签和别名
                    //设置标签
                    __autoreleasing NSMutableSet *tags = [NSMutableSet set];
                    [self setTags:&tags addTag:userItem.city];
                    //设置别名
                    __autoreleasing NSString *alias = [NSString stringWithFormat:@"%@",userItem.userId];
                    [self analyseInput:&alias tags:&tags];
                    
                    [APService setTags:tags
                                 alias:alias
                      callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                                target:self];
                    
                }else{
                    [LoadingView stopOnTheViewController:self];
                    [BBSAlert showAlertWithContent:[dic objectForKey:kBBSReMsg] andDelegate:self];
                }
                
            }];
            [request setFailedBlock:^{
                [LoadingView stopOnTheViewController:self];
                [BBSAlert showAlertWithContent:@"您的网络不给力，换一个吧！" andDelegate:nil];
            }];
        }
        else{
            [LoadingView stopOnTheViewController:self];
            [BBSAlert showAlertWithContent:@"微博无反应" andDelegate:self];
            
        }
    }];
}
#pragma mar 微信登陆
#pragma mar 微信登陆
-(void)isHaveSSDKPLatformTypeWechat{
    if ([ShareSDK hasAuthorized:SSDKPlatformTypeWechat] == YES) {
        
        [self weixin];
    }else{
        [ShareSDK cancelAuthorize:SSDKPlatformTypeWechat];
        
        [self weixin];
    }
    
}

-(void)weixin{
    [LoadingView startOnTheViewController:self];
    [ShareSDK getUserInfo:SSDKPlatformTypeWechat onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
        
        if (state == SSDKResponseStateSuccess) {
            NSDictionary *ParamDic;
          
            NSDictionary *unionidic = user.credential.rawData;
            NSString *unionString = unionidic[@"unionid"];
            NSString *uid = user.uid;
            NSString *nick_name = user.nickname;
            NSString *imgUrl = user.icon;
            
            ParamDic=[NSDictionary dictionaryWithObjectsAndKeys:
                      @"0",@"source",@"1",@"client_type",_identifierForVendor,@"imin",uid,@"uid",nick_name,@"nick_name",imgUrl,@"headimgurl",unionString,@"unionid",[NSString stringWithFormat:@"%@,%@",_lat,_log],@"mapsign",nil];
            
            UrlMaker *_urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:@"wxLogin" Method:NetMethodPost andParam:ParamDic];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:_urlMaker.url];
            for (NSString *key in [ParamDic allKeys]) {
                [request setPostValue:[ParamDic objectForKey:key] forKey:key];
            }
            __weak ASIFormDataRequest *blockRequest = request;
            [request startAsynchronous];
            [request setCompletionBlock:^{
                NSDictionary *dic=[blockRequest.responseString objectFromJSONString];
                BOOL success=[[dic objectForKey:@"success"] boolValue];
                if (success==YES) {
                    NSDictionary *dataDic=[dic objectForKey:@"data"];
                    NSLog(@"datadic = %@",dataDic);
                    UserInfoItem *userItem=[[UserInfoItem alloc]init];
                    userItem.userId=[dataDic objectForKey:@"user_id"];
                    userItem.email=[dataDic objectForKey:@"email"];
                    userItem.userName=[dataDic objectForKey:@"user_name"];
                    userItem.nickname=[dataDic objectForKey:@"nick_name"];
                    userItem.avatarStr=[dataDic objectForKey:@"avatar"];
                    userItem.city = [dataDic objectForKey:@"city"];
                    userItem.isVisitor=[NSNumber numberWithBool:YES];
                    userItem.loginType = LOGINUSERTYPESINAWEIBOUSER;
                    userItem.isMobile = [dataDic objectForKey:@"is_mobile"];
                    //source ,0绑定过老账户,1微博(没绑定过)
                    userItem.bindingType = [[dataDic objectForKey:@"source"] integerValue];
                    NSLog(@"weixindatadicdatadidcda = %@",dataDic);

                    NSLog(@"是否绑定手机号了呢？%@",userItem.isMobile);
                    UserInfoManager *userInfoManager=[[UserInfoManager alloc]init];
                    [userInfoManager saveUserInfo:userItem];
                    [LoadingView stopOnTheViewController:self];

                    if ([userItem.isMobile isEqualToString:@"0"]) {
                        ChangePhoneNumber2VC *change2VC = [[ChangePhoneNumber2VC alloc]init];
                        change2VC.typeChangeOrBing = 1;//之前没有手机号现在绑定
                        change2VC.fromLogin = @"login";
                        if ([self.fromTabBar isEqualToString:@"fromTabBar"]) {
                            change2VC.isFromTab = YES;
                        }
                        
                        [self.navigationController pushViewController:change2VC animated:YES];

                    }else{
                        [LoadingView stopOnTheViewController:self];

                        userItem.isVisitor=[NSNumber numberWithBool:NO];
                        [userInfoManager saveUserInfo:userItem];
                        [[NSNotificationCenter defaultCenter]postNotificationName:USER_LOGIN_HTML_SUCCEED object:nil];
                        [self dismissViewControllerAnimated:YES completion:^{
                            
                        }];

                    }
                   //                    [[NSNotificationCenter defaultCenter]postNotificationName:USER_LOGIN_HTML_SUCCEED object:nil];
                    //登陆微博成功的时候设置标签和别名
                    //设置标签
                    __autoreleasing NSMutableSet *tags = [NSMutableSet set];
                    [self setTags:&tags addTag:userItem.city];
                    //设置别名
                    __autoreleasing NSString *alias = [NSString stringWithFormat:@"%@",userItem.userId];
                    [self analyseInput:&alias tags:&tags];
                    
                    [APService setTags:tags
                                 alias:alias
                      callbackSelector:@selector(tagsAliasCallback:tags:alias:)
                                target:self];
                    
                }else{
                    [LoadingView stopOnTheViewController:self];

                    [BBSAlert showAlertWithContent:[dic objectForKey:kBBSReMsg] andDelegate:self];
                }
                
            }];
            [request setFailedBlock:^{
                [LoadingView stopOnTheViewController:self];
                [BBSAlert showAlertWithContent:@"您的网络不给力，换一个吧！" andDelegate:nil];
            }];
            
            
        }
        
        else{
            [LoadingView stopOnTheViewController:self];
  
        }
    }];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}
#pragma mark  点击取消本页面
-(void)callMethodFinish{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    });
}
#pragma mark 检测微信安装否
-(BOOL)checkWeiXin{
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue]>=9.0) {
        if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
            return YES;
        }else{
            return NO;
        }
        
    }else{
        if ([ShareSDK  isClientInstalled:SSDKPlatformTypeWechat]) {
            return YES;
        }else{
            return NO;
        }
    }
}

#pragma mark 推送涉及到的
- (void)setTags:(NSMutableSet **)tags addTag:(NSString *)tag {
    //  if ([tag isEqualToString:@""]) {
    // }
    [*tags addObject:tag];
}
- (void)analyseInput:(NSString **)alias tags:(NSSet **)tags {
    // alias analyse
    if (![*alias length]) {
        // ignore alias
        *alias = nil;
    }
    // tags analyse
    if (![*tags count]) {
        *tags = nil;
    } else {
        __block int emptyStringCount = 0;
        [*tags enumerateObjectsUsingBlock:^(NSString *tag, BOOL *stop) {
            if ([tag isEqualToString:@""]) {
                emptyStringCount++;
            } else {
                emptyStringCount = 0;
                *stop = YES;
            }
        }];
        if (emptyStringCount == [*tags count]) {
            *tags = nil;
        }
    }
}
- (void)tagsAliasCallback:(int)iResCode
                     tags:(NSSet *)tags
                    alias:(NSString *)alias {
    NSString *callbackString =
    [NSString stringWithFormat:@"%d, \ntags: %@, \nalias: %@\n", iResCode,
     [self logSet:tags], alias];
    NSLog(@"TagsAlias回调:%@", callbackString);
}
- (NSString *)logSet:(NSSet *)dic {
    if (![dic count]) {
        return nil;
    }
    NSString *tempStr1 =
    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str =
    [NSPropertyListSerialization propertyListFromData:tempData
                                     mutabilityOption:NSPropertyListImmutable
                                               format:NULL
                                     errorDescription:NULL];
    return str;
}

-(void)showHUDWithMessage:(NSString *)message{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60,64+20+50+50+50+5 , 200, 30)];
    label.backgroundColor = [UIColor darkGrayColor];
    label.layer.cornerRadius = 3.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.textColor = [UIColor whiteColor];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [self.view addSubview:label];
    [UIView commitAnimations];
    [self performSelector:@selector(remove:) withObject:label afterDelay:1.5];
    
}
-(void)remove:(UILabel *)label{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [label removeFromSuperview];
    [UIView commitAnimations];
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
