//
//  RegisterViewController.m
//  BabyShow
//
//  Created by Lau on 13-12-9.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "RegisterViewController.h"
#import "InputCheck.h"
#import "RegisterStep2ViewController.h"
#import "NSString+NSString_MD5.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController

static float TextFieldWidth = 240.0;
static float TextFieldHeight = 38.0;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isUploadAvar=NO;
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationController.navigationBarHidden=NO;
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIColor *backgroundColor=[BBSColor hexStringToColor:[NSString stringWithFormat:@"#F3F3F3"]];
    self.view.backgroundColor=backgroundColor;
    self.title=@"注册";

    CGRect imageRect = CGRectMake(128, 23, 64, 64);
    CGRect passwordTextFieldRect = CGRectMake(40, 223, TextFieldWidth, TextFieldHeight);
    CGRect emailTextFieldRect = CGRectMake(40, 107, TextFieldWidth, TextFieldHeight);
    CGRect nicknameTextFieldRect = CGRectMake(40, 165, TextFieldWidth, TextFieldHeight);
    CGRect btnBackRect = CGRectMake(0, 20, 49, 31);
    CGRect btnDoneRect = CGRectMake(0, 0, 51, 31);

    UIFont *font=[UIFont systemFontOfSize:14];
    
    _scrollView =[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.contentSize=[UIScreen mainScreen].bounds.size;
    [self.view addSubview:_scrollView];
    
    _btnBack=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *btnBackImage=[UIImage imageNamed:@"btn_back1"];
    _btnBack.frame=btnBackRect;
    [_btnBack setBackgroundImage:btnBackImage forState:UIControlStateNormal];
    [_btnBack addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_btnBack];
    self.navigationItem.leftBarButtonItem=left;
    
    _btnDone=[UIButton buttonWithType:UIButtonTypeCustom];
    [_btnDone setTitle:@"完成" forState:UIControlStateNormal];
    _btnDone.titleLabel.font = [UIFont boldSystemFontOfSize:15.8];
    _btnDone.frame=btnDoneRect;
    [_btnDone addTarget:self action:@selector(nextStep) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *spaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem.width = -10;
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:_btnDone];
    self.navigationItem.rightBarButtonItems = @[spaceItem,right];
    
    _imageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _imageBtn.frame=imageRect;
    [_imageBtn addTarget:self action:@selector(addAvatar) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_imageBtn];
    
    _imageView=[[UIImageView alloc]initWithFrame:imageRect];
    UIImage *avatar=[UIImage imageNamed:@"img_avatar.png"];
    _imageView.image=avatar;
    [_scrollView addSubview:_imageView];
    
    _passwordTextField=[[UITextField alloc]initWithFrame:passwordTextFieldRect];
    _passwordTextField.placeholder=@"密码：";
    _passwordTextField.delegate=self;
    _passwordTextField.font=font;
    _passwordTextField.keyboardType=UIKeyboardTypeDefault;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _passwordTextField.borderStyle=UITextBorderStyleRoundedRect;
    [_scrollView addSubview:_passwordTextField];

    _emailTextField=[[UITextField alloc]initWithFrame:emailTextFieldRect];
    _emailTextField.placeholder=@"邮箱：";
    _emailTextField.delegate=self;
    _emailTextField.font=font;
    _emailTextField.keyboardType=UIKeyboardTypeEmailAddress;
    _emailTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _emailTextField.borderStyle=UITextBorderStyleRoundedRect;
    [_scrollView addSubview:_emailTextField];


    _nickNameTextField=[[UITextField alloc]initWithFrame:nicknameTextFieldRect];
    _nickNameTextField.placeholder=@"昵称：";
    _nickNameTextField.delegate=self;
    _nickNameTextField.font=font;
    _nickNameTextField.keyboardType=UIKeyboardTypeDefault;
    _nickNameTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    _nickNameTextField.borderStyle=UITextBorderStyleRoundedRect;
    [_scrollView addSubview:_nickNameTextField];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchOnTheView)];
    [_scrollView addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoAddAChild) name:USER_REGIST_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registFail:) name:USER_REGIST_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark private

-(void)netFail{
   
    _btnDone.enabled=YES;
    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:self];
    [LoadingView stopOnTheViewController:self];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addAvatar{
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"拍摄一张", nil];
    [actionSheet showInView:self.view];
}

-(void)nextStep{

    InputCheck *inputCheck=[[InputCheck alloc]init];
    
    if(![inputCheck emailChek:_emailTextField.text]){
        [BBSAlert showAlertWithContent:@"请输入正确的邮箱地址" andDelegate:self];
        return;
    }
    if(![inputCheck nicknameCheck:_nickNameTextField.text]){
        [BBSAlert showAlertWithContent:@"请输入正确格式的昵称：长度不大于10的汉字或者字母" andDelegate:self];
    }
    
    if(![inputCheck passwordCheck:_passwordTextField.text]){
        [BBSAlert showAlertWithContent:@"请输入正确格式的密码哦：6~16个字母或数字" andDelegate:self];
        return;
    }
   
    //开始注册ing
    [LoadingView startOnTheViewController:self];
    _btnDone.enabled=NO;
    NSUserDefaults *defaultlat = [NSUserDefaults standardUserDefaults];
    NSString *lat = [defaultlat valueForKey:@"latitude"];
    NSUserDefaults *defaultlog = [NSUserDefaults standardUserDefaults];
    NSString *longitude = [defaultlog valueForKey:@"longitude"];
    NSMutableDictionary *param;
    if (!lat||!longitude) {
        param=[NSMutableDictionary dictionaryWithObjectsAndKeys:
               [_passwordTextField.text md5] ,kRegistPassword,
               _emailTextField.text,kRegistEmail,
               _nickNameTextField.text,kRegistNickName,@"",@"mapsign",nil];

    }else{
        param=[NSMutableDictionary dictionaryWithObjectsAndKeys:
               [_passwordTextField.text md5] ,kRegistPassword,
               _emailTextField.text,kRegistEmail,
               _nickNameTextField.text,kRegistNickName,[NSString stringWithFormat:@"%@,%@",lat,longitude],@"mapsign",nil];
    }

    //kRegistAvatar:_imageView.image
    if (isUploadAvar) {
        [param setObject:_imageView.image forKey:kRegistAvatar];
    }

    [[NetAccess sharedNetAccess] getDataWithStyle:NetStyleRegister andParam:param];
}

-(void)gotoAddAChild{
    
    [MobClick event:UMEVENTLOGIN];
    [MobClick event:UMEVENTREGISTER];
    
    [LoadingView stopOnTheViewController:self];
    
    RegisterStep2ViewController *step2=[[RegisterStep2ViewController alloc]init];
    step2.Type=0;
    [self.navigationController pushViewController:step2 animated:YES];
}

-(void)registFail:(NSNotification *) not{
    
    _btnDone.enabled=YES;
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}

-(void)touchOnTheView{
    [_passwordTextField resignFirstResponder];
    [_emailTextField resignFirstResponder];
    [_nickNameTextField resignFirstResponder];
}

-(void)setAvartarImage:(UIImage *) img{
    
    _imageView.image=img;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.cornerRadius = 32;
}

#pragma mark UIActionSheet

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    _imagePicker=[[UIImagePickerController alloc]init];
    if (buttonIndex==0) {
        //从相册选取
        _imagePicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.allowsEditing=YES;
        _imagePicker.delegate=self;
        [self.navigationController presentViewController:_imagePicker animated:YES completion:^{}];
    }else if(buttonIndex==1){
        //拍摄一张
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            _imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            _imagePicker.delegate=self;
            _imagePicker.allowsEditing=YES;
            [self.navigationController presentViewController:_imagePicker animated:YES completion:^{}];
        }else{
            [BBSAlert showAlertWithContent:@"相机设备不可用" andDelegate:self];
        }
    }
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}

#pragma mark UIImagePickerControllerDelegate
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    isUploadAvar=YES;
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    [self setAvartarImage:image];
  
    [picker dismissViewControllerAnimated:YES completion:^{}];

}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.layer.borderWidth = 1.0;
    textField.layer.borderColor=[[BBSColor hexStringToColor:BACKCOLOR] CGColor];
    
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    CGSize result = [[UIScreen mainScreen] bounds].size;

    if (result.height<500) {
        _scrollView.contentOffset=CGPointMake(0, 20);
    }else{
        _scrollView.contentOffset=CGPointMake(0, 20);
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.layer.borderWidth=0;
    textField.layer.borderColor=[[UIColor darkGrayColor] CGColor];

    _scrollView.contentOffset=CGPointMake(0, 0);
    
    return YES;
}
@end
