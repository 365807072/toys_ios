//
//  RegisterStep2ViewController.m
//  BabyShow
//
//  Created by Lau on 13-12-10.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "RegisterStep2ViewController.h"
#import "BabyInfoItem.h"
#import "BabyTextFieldItem.h"


@interface RegisterStep2ViewController ()

@property (strong, nonatomic) UIToolbar *toolbar;
//
@property (strong, nonatomic) UIDatePicker *customDatePicker;
@end
@implementation RegisterStep2ViewController

static float begin = 40;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _babyArray=[[NSMutableArray alloc]init];
        _babyTextFieldArray=[[NSMutableArray alloc]init];
        isFirst=YES;
        Count=0;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden=NO;
    self.navigationController.navigationBar.barTintColor=[BBSColor hexStringToColor:NAVICOLOR];
    
    NSMutableDictionary *textAttribute = [NSMutableDictionary dictionary];
    textAttribute[NSForegroundColorAttributeName] = [UIColor whiteColor];
    self.navigationController.navigationBar.titleTextAttributes =textAttribute;

    self.title=@"添加宝贝";

    //添加宝贝：
    if (self.Type==1) {
        
        CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
        
        UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        _backBtn.frame=backBtnFrame;
        UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
        self.navigationItem.leftBarButtonItem=left;
        
    }else if (self.Type==0){
        //注册：
 
        _btnIgnore=[UIButton buttonWithType:UIButtonTypeCustom];
        [_btnIgnore setTitle:@"      跳过" forState:UIControlStateNormal];
        _btnIgnore.titleLabel.font = [UIFont boldSystemFontOfSize:15.8];
        _btnIgnore.frame=CGRectMake(0, 0, 61, 31);
        [_btnIgnore addTarget:self action:@selector(ignore) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_btnIgnore];
        self.navigationItem.rightBarButtonItem=rightItem;
        
        self.navigationItem.hidesBackButton=YES;

    }
    
    UIColor *backgroundColor=[BBSColor hexStringToColor:[NSString stringWithFormat:@"#F3F3F3"]];
    self.view.backgroundColor=backgroundColor;
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT)];
    _scrollView.contentSize=CGSizeMake(VIEWWIDTH, VIEWHEIGHT);
    [self.view addSubview:_scrollView];
    
    _addChildBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIImage *addChildImage=[UIImage imageNamed:@"btn_add_another_baby.png"];
    [_addChildBtn setBackgroundImage:addChildImage forState:UIControlStateNormal];
    [_addChildBtn addTarget:self action:@selector(addAChild) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_addChildBtn];
    
    _submitBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];

    [_submitBtn setBackgroundColor:[BBSColor hexStringToColor:BACKCOLOR]];
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_submitBtn];
    
    begin = 40;

    [self addAChild];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchOnTheView)];
    [_scrollView addGestureRecognizer:tap];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addSucceed:) name:USER_ADDBABY_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addFail:) name:USER_ADDBABY_FAIL object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillApear:) name:UIKeyboardWillShowNotification object:nil];
     
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisapear:) name:UIKeyboardWillHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}
#pragma mark - 定义出生日期键盘
//自定义输入键盘
- (UIView *)customInputView {
    if (!self.customDatePicker) {
        self.customDatePicker = [[UIDatePicker alloc]init];
        self.customDatePicker.datePickerMode = UIDatePickerModeDate;
        self.customDatePicker.date = [NSDate date];
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
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
}
- (void)done :(id)sender {
    
    if ([_textField isFirstResponder]) {
        [_textField resignFirstResponder];
    }
    NSDate *date = [self.customDatePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateAndTime =  [dateFormatter stringFromDate:date];
    _textField.text=dateAndTime;
    
}
#pragma mark -
#pragma mark private

-(void)netFail{
    
    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    
}

-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)keyboardWillApear:(NSNotification *)not{
    
    NSDictionary *info = [not userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]>=7){
        
        _scrollView.frame=CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT-kbSize.height);
    }else{
        _scrollView.frame=CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT-kbSize.height);
    }
     
}
     
-(void)keyboardWillDisapear:(NSNotification *)not{
    
    _scrollView.frame=CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT);
}

-(void)touchOnTheView{
    
    for (id obj in _scrollView.subviews) {
        
        if ([obj isKindOfClass:[UITextField class]]) {
            
            [obj resignFirstResponder];
        }
    }
}


-(void)ignore{
    [self dismissViewControllerAnimated:YES completion:nil];
        
}

-(void)addAChild{
    
    if (!isFirst) {
        
        UIImageView *lineView=[[UIImageView alloc]initWithFrame:CGRectMake(0, begin, 320, 1)];
        lineView.backgroundColor=[BBSColor hexStringToColor:BACKCOLOR];
        lineView.alpha=0.5;
        [_scrollView addSubview:lineView];
        
    }
    
    UIFont *font=[UIFont systemFontOfSize:14];
    
    BabyTextFieldItem *textfieldItem=[[BabyTextFieldItem alloc]init];
    
    textfieldItem.nameTextField=[[UITextField alloc]initWithFrame:CGRectMake(40, begin+21, 240, 38)];
    textfieldItem.nameTextField.placeholder=@"宝贝名字：";
    textfieldItem.nameTextField.borderStyle=UITextBorderStyleRoundedRect;
    textfieldItem.nameTextField.font=font;
    textfieldItem.nameTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    textfieldItem.nameTextField.tag=3*Count;
    textfieldItem.nameTextField.delegate=self;
    [_scrollView addSubview:textfieldItem.nameTextField];
    
    textfieldItem.birthdayTextField=[[UITextField alloc]initWithFrame:CGRectMake(40, begin+79, 240, 38)];
    textfieldItem.birthdayTextField.placeholder=@"出生日期：";
    textfieldItem.birthdayTextField.font=font;
    textfieldItem.birthdayTextField.borderStyle=UITextBorderStyleRoundedRect;
    textfieldItem.birthdayTextField.delegate=self;
    textfieldItem.birthdayTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    textfieldItem.birthdayTextField.tag=3*Count+1;
    [_scrollView addSubview:textfieldItem.birthdayTextField];
    
    textfieldItem.sexTextField=[[UITextField alloc] initWithFrame:CGRectMake(40, begin+137, 240, 38)];
    textfieldItem.sexTextField.placeholder=@"宝贝性别：";
    textfieldItem.sexTextField.font=font;
    textfieldItem.sexTextField.borderStyle=UITextBorderStyleRoundedRect;
    textfieldItem.sexTextField.delegate=self;
    textfieldItem.sexTextField.tag=3*Count+2;
    textfieldItem.sexTextField.contentVerticalAlignment=UIControlContentVerticalAlignmentCenter;
    [_scrollView addSubview:textfieldItem.sexTextField];
    
    [_babyTextFieldArray addObject:textfieldItem];
    
    _addChildBtn.frame=CGRectMake(160, begin+194, 126, 22);
    _submitBtn.frame=CGRectMake(40, begin+233, 240, 36);
    _submitBtn.titleLabel.font=font;
    _submitBtn.titleLabel.textColor=[UIColor whiteColor];
    
    begin+=205;
    
    if (_scrollView.contentSize.height<begin+205) {
        _scrollView.contentSize=CGSizeMake(_scrollView.contentSize.width,begin+205);
    }
    
    isFirst=NO;
    Count+=1;
    
}

-(void)submit{
    
    [MobClick event:UMEVENTADDBABY];
    
    [_babyArray removeAllObjects];
    
    for (BabyTextFieldItem *textfieldItem in _babyTextFieldArray) {
        
        BabyInfoItem *babyItem=[[BabyInfoItem alloc]init];
        
        if (textfieldItem.nameTextField.text.length && textfieldItem.birthdayTextField.text.length  && textfieldItem.sexTextField.text.length) {
            babyItem.babyName=textfieldItem.nameTextField.text;
            babyItem.babyBirthday=textfieldItem.birthdayTextField.text;
            if ([textfieldItem.sexTextField.text isEqualToString:@"男"]) {
                babyItem.sex=[NSNumber numberWithInt:0];

            }else if([textfieldItem.sexTextField.text isEqualToString:@"女"]){
                babyItem.sex=[NSNumber numberWithInt:1];
            }
            
            [_babyArray addObject:babyItem];
            
        }
        
    }
    if (_babyArray.count) {
        
        NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:_babyArray,@"babys", nil];
        NetAccess *netAccess=[NetAccess sharedNetAccess];
        [netAccess getDataWithStyle:NetStyleAddAChild andParam:param];
        [LoadingView startOnTheViewController:self];
        
    }else{
        
        if (self.Type==0){
            
            [self ignore];

        }else if (self.Type==1){
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    }

}
//添加宝宝成功后
-(void)addSucceed:(NSNotification *)not{
    
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:USERBABYUPDATE];
    [[NSUserDefaults standardUserDefaults] synchronize];
    if (self.Type==0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(self.Type==1){
        //个人主页
        [self.navigationController popToRootViewControllerAnimated:YES];
        
    }
}

-(void)addFail:(NSNotification *)not{
    
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    
}

#pragma mark UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField.tag%3==1) {
        //birthday
        for (BabyTextFieldItem *item in _babyTextFieldArray) {
            if ([item.sexTextField isFirstResponder]) {
                [item.sexTextField resignFirstResponder];
            }
            if ([item.nameTextField isFirstResponder]) {
                [item.nameTextField resignFirstResponder];
            }
        }
        _textField=textField;
//        [_textField resignFirstResponder];
        textField.inputView = [self customInputView];
        textField.inputAccessoryView = [self customInputAccessoryView];
        [textField reloadInputViews];//if do not reload,then the above two lines will not work
    }
    else if(textField.tag%3==2){
        //sex
        for (BabyTextFieldItem *item in _babyTextFieldArray) {
            if ([item.birthdayTextField isFirstResponder]) {
                [item.birthdayTextField resignFirstResponder];
            }
            if ([item.nameTextField isFirstResponder]) {
                [item.nameTextField resignFirstResponder];
            }
        }
        
        _textField=textField;
        [textField resignFirstResponder];
        UIActionSheet  *acs2=[[UIActionSheet alloc]initWithTitle:@"宝贝性别" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
        acs2.tag=textField.tag;
        [acs2 showInView:self.view];

    } else {
        //name
        for (BabyTextFieldItem *item in _babyTextFieldArray) {
            if ([item.sexTextField isFirstResponder]) {
                [item.sexTextField resignFirstResponder];
            }
            if ([item.birthdayTextField isFirstResponder]) {
                [item.birthdayTextField resignFirstResponder];
            }
        }
    }

}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex==1) {
        _textField.text=@"女";
    }else{
        _textField.text=@"男";
    }
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}


-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    textField.layer.borderWidth = 1.0;
    textField.layer.borderColor=[[BBSColor hexStringToColor: BACKCOLOR] CGColor];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    textField.layer.borderWidth=0;
    textField.layer.borderColor=[[UIColor darkGrayColor] CGColor];
    return YES;
}

-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    UINavigationController *nav=(UINavigationController *)viewController;
    [nav popToRootViewControllerAnimated:YES];
    
}



@end
