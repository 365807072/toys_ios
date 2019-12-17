//
//  CombineInputViewController.m
//  BabyShow
//
//  Created by Monica on 15-4-7.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "CombineInputViewController.h"
#import "GrowthDiaryViewController.h"

@interface CombineInputViewController ()<UITextFieldDelegate>

@property (nonatomic ,strong) UITextField *nameTextField;
@property (nonatomic ,strong) UITextField *passwordTextField;
@property (nonatomic ,strong) UIButton    *combineBtn;

@end

@implementation CombineInputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"同步";
    [self setLeftBarButton];
    [self setupView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchOnTheView)];
    [self.view addGestureRecognizer:tap];
}
#pragma mark -
- (void)setLeftBarButton {
    CGRect backBtnFrame = CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame = backBtnFrame;
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    
    self.navigationItem.leftBarButtonItem = left;
}
- (void)setupView {
    
    CGRect nameTextFieldFrame = CGRectMake(40, 95, VIEWWIDTH-80, 36);
    CGRect passwordTextFieldFrame = CGRectMake(40, 150, VIEWWIDTH-80, 36);
    
    CGRect loginBtnFrame = CGRectMake((SCREENWIDTH-239)/2, 205, 239, 38);
    
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 70, SCREENWIDTH - 80, 20)];
    hintLabel.text = @"请输入对方的用户名/邮箱和密码";
    hintLabel.font = [UIFont systemFontOfSize:14];
    hintLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:hintLabel];
    
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
    
    _combineBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    _combineBtn.titleLabel.font= [UIFont boldSystemFontOfSize:15];
    _combineBtn.layer.cornerRadius = 3;
    _combineBtn.layer.masksToBounds = YES;
    [_combineBtn setFrame:loginBtnFrame];
    [_combineBtn setBackgroundColor:[BBSColor hexStringToColor:@"ec6762"]];
    [_combineBtn setTitle:@"同 步" forState:UIControlStateNormal];
    [_combineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_combineBtn addTarget:self action:@selector(combineHim) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_combineBtn];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 245, SCREENWIDTH-10, 60)];
    textLabel.text = @"  如确定同步,双方已有的成长记录将进行同步；未来一方上传将同时记录在双方的成长记录中。有疑问或需解除同步,请与客服联系。";
    textLabel.font = [UIFont systemFontOfSize:14];
    textLabel.numberOfLines = 0;
    textLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:textLabel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)combineHim {
    [_nameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
    if (_nameTextField.text.length <= 0 || _passwordTextField.text.length <=0 ) {
        [BBSAlert showAlertWithContent:@"请输入用户名或密码" andDelegate:nil];
        return;
    }
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",_user_id,@"share_user_id",_baby_id,@"baby_id",_share_baby_id,@"share_baby_id",_nameTextField.text,kUserName,[_passwordTextField.text md5],kPassword, nil];
    [LoadingView startOnTheViewController:self];
    [[HTTPClient sharedClient] postNew:kCombineDiary params:params success:^(NSDictionary *result) {
        [LoadingView stopOnTheViewController:self];
        [MobClick event:UMEVENTCOMBINE];

        if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
            for (UIViewController *viewC in self.navigationController.viewControllers) {
                if ([viewC isKindOfClass:[GrowthDiaryViewController class]]) {
                    GrowthDiaryViewController *viewController = (GrowthDiaryViewController *)viewC;
                    viewController.refresh = YES;
                    [self.navigationController popToViewController:viewController animated:YES];
                }
             }
        } else {
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
        [BBSAlert showAlertWithContent:@"网络连接错误" andDelegate:nil];
    }];
}
- (void)back {
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchOnTheView{
    [_nameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}
@end
