//
//  EnterCooperateVC.m
//  BabyShow
//
//  Created by WMY on 16/2/22.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "EnterCooperateVC.h"
#import "BaseLabel.h"

@interface EnterCooperateVC (){
    UIScrollView *_scrollView;
    UIView *backView1;
    UIView *backView2;
    UIView *backView3;
    UIView *backView4;
    YLButton *sumbitBtn;
    
}
@property(nonatomic,strong)UITextField *storeNameTF;
@property(nonatomic,strong)UITextField *storeDescTF;
@property(nonatomic,strong)UIImageView *imgOnStore;
@property(nonatomic,strong)UIImageView *imgOffStore;
@property(nonatomic,strong)UIImageView *imgCoop;//区域合作
@property(nonatomic,strong)UIImageView *imgMyID;
@property(nonatomic,strong)UIImageView *imgUserID;
@property(nonatomic,strong)UITextField *phoneNumberTF;
@property(nonatomic,strong)UITextField *youMailTF;
@property(nonatomic,strong)UITextField *detailAddress;
@property(nonatomic,assign)NSInteger isCoompetation;
@property(nonatomic,assign)BOOL isUser;



@end

@implementation EnterCooperateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我要合作";
    [self setLeftButton];
    [self setSubViews];
    

    // Do any additional setup after loading the view.
}
#pragma mark UI
//返回按钮
-(void)setLeftButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)setSubViews{
    _scrollView =[[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _scrollView.contentSize=[UIScreen mainScreen].bounds.size;
    _scrollView.contentSize = CGSizeMake(0,[UIScreen mainScreen].bounds.size.height+100);
    _scrollView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f9"];
    [self.view addSubview:_scrollView];
    _scrollView.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    
    [_scrollView addGestureRecognizer:singleTap];
    //第一部分
    backView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 13, SCREENWIDTH, 79)];
    backView1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:backView1];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
    lineView1.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView1 addSubview:lineView1];
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(14, 39.5, SCREENWIDTH, 0.5)];
    lineView2.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView1 addSubview:lineView2];
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, 78.5, SCREENWIDTH, 0.5)];
    lineView3.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView1 addSubview:lineView3];

    BaseLabel *storeNameLabel = [BaseLabel makeFrame:CGRectMake(13, 10, 60, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"商家名称"];
    [backView1 addSubview:storeNameLabel];
    BaseLabel *storeDescribleLabel = [BaseLabel makeFrame:CGRectMake(13, 10+38.5, 60, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"简单描述"];
    [backView1 addSubview:storeDescribleLabel];
    
    _storeNameTF = [[UITextField alloc]initWithFrame:CGRectMake(75,11 , SCREENWIDTH-85, 20)];
    _storeNameTF.placeholder = @"如：自由环球租赁";
    _storeNameTF.delegate = self;
    _storeNameTF.font = [UIFont systemFontOfSize:14];
    _storeNameTF.borderStyle = UITextBorderStyleNone;
    [backView1 addSubview:_storeNameTF];
    
    _storeDescTF = [[UITextField alloc]initWithFrame:CGRectMake(75,11+38.5, SCREENWIDTH-85, 20)];
    _storeDescTF.placeholder = @"如：最大的亲子育儿社区";
    _storeDescTF.delegate = self;
    _storeDescTF.font = [UIFont systemFontOfSize:14];
    _storeDescTF.borderStyle = UITextBorderStyleNone;
    [backView1 addSubview:_storeDescTF];
    
    //第二部分
    backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, backView1.frame.origin.y+backView1.frame.size.height+11, SCREENWIDTH, 79+72)];
    backView2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:backView2];
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
    lineView4.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView2 addSubview:lineView4];
    
    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(14, 39.5, SCREENWIDTH, 0.5)];
    lineView5.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView2 addSubview:lineView5];
    
    UIView *lineView6 = [[UIView alloc]initWithFrame:CGRectMake(0, 78.5, SCREENWIDTH, 0.5)];
    lineView6.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView2 addSubview:lineView6];
    
    UIView *lineView14 = [[UIView alloc]initWithFrame:CGRectMake(0, 78.5+72, SCREENWIDTH, 0.5)];
    lineView14.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView2 addSubview:lineView14];
    
    
    BaseLabel *onLineLabel = [BaseLabel makeFrame:CGRectMake(13, 10, 60, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"线下商家"];
    [backView2 addSubview:onLineLabel];
    BaseLabel *offLineLabel = [BaseLabel makeFrame:CGRectMake(13, 10+38.5, 60, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"线上商家"];
    [backView2 addSubview:offLineLabel];
    
    BaseLabel *cooperationLabel = [BaseLabel makeFrame:CGRectMake(13, 10+38.5+39, 60, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"区域合作"];
    [backView2 addSubview:cooperationLabel];
    UILabel *smallLabel = [[UILabel alloc]initWithFrame:CGRectMake(13, cooperationLabel.frame.origin.y+cooperationLabel.frame.size.height+10, 10, 10)];
    smallLabel.font = [UIFont systemFontOfSize:14];
    smallLabel.text = @"*";
    smallLabel.textColor = [UIColor redColor];
    [backView2 addSubview:smallLabel];
    
    UILabel *smallLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(13, cooperationLabel.frame.origin.y+cooperationLabel.frame.size.height+13+18, 10, 10)];
    smallLabel2.font = [UIFont systemFontOfSize:14];
    smallLabel2.text = @"*";
    smallLabel2.textColor = [UIColor redColor];
    [backView2 addSubview:smallLabel2];

    UILabel *oneLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, cooperationLabel.frame.origin.y+cooperationLabel.frame.size.height+5, SCREENWIDTH-20, 15)];
    oneLabel.font = [UIFont systemFontOfSize:12];
    oneLabel.textColor = [BBSColor hexStringToColor:@"9a9a9a"];
    oneLabel.text = @"个人地域群与官方合作。（100关注起）";
    [backView2 addSubview:oneLabel];
    
    UILabel *twoLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, cooperationLabel.frame.origin.y+cooperationLabel.frame.size.height+10+15, SCREENWIDTH-20, 15)];
    twoLabel.font = [UIFont systemFontOfSize:12];
    twoLabel.textColor = [BBSColor hexStringToColor:@"9a9a9a"];
    twoLabel.text = @"将会得到自由环球租赁流量和资金支持";
    [backView2 addSubview:twoLabel];


    
    
    //线下商家
    UIButton *offButton = [UIButton buttonWithType:UIButtonTypeSystem];
    offButton.frame = CGRectMake(SCREENWIDTH-200, 10, 200, 20);
    offButton.tag = 1001;
    [offButton addTarget:self action:@selector(chooseOnOrOff:) forControlEvents:UIControlEventTouchUpInside];
    [backView2 addSubview:offButton];
    
    _imgOffStore = [[UIImageView alloc]initWithFrame:CGRectMake(200-18.5-10, 1, 18.5, 18.5)];
    _imgOffStore.image = [UIImage imageNamed:@"btn_select_pay"];
    [offButton addSubview:_imgOffStore];
    
    //线上商家
    UIButton *onButton = [UIButton buttonWithType:UIButtonTypeSystem];
    onButton.frame = CGRectMake(SCREENWIDTH-200, 10+39, 200, 20);
    onButton.tag = 1002;
    [onButton addTarget:self action:@selector(chooseOnOrOff:) forControlEvents:UIControlEventTouchUpInside];
    [backView2 addSubview:onButton];
    _imgOnStore = [[UIImageView alloc]initWithFrame:CGRectMake(200-18.5-10, 1, 18.5, 18.5)];
    _imgOnStore.image = [UIImage imageNamed:@"btn_unselect_pay"];
    [onButton addSubview:_imgOnStore];
    
    //区域合作
    UIButton *cooperationButton = [UIButton buttonWithType:UIButtonTypeSystem];
    cooperationButton.frame = CGRectMake(SCREENWIDTH-200, 10+39+39, 200, 20);
    cooperationButton.tag = 1005;
    [cooperationButton addTarget:self action:@selector(chooseOnOrOff:) forControlEvents:UIControlEventTouchUpInside];
    [backView2 addSubview:cooperationButton];
    
    _imgCoop = [[UIImageView alloc]initWithFrame:CGRectMake(200-18.5-10, 1, 18.5, 18.5)];
    _imgCoop.image = [UIImage imageNamed:@"btn_unselect_pay"];
    [cooperationButton addSubview:_imgCoop];

    
    
    //第三部分
    backView3 = [[UIView alloc]initWithFrame:CGRectMake(0, backView2.frame.origin.y+backView2.frame.size.height+11, SCREENWIDTH, 79)];
    backView3.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:backView3];
    
    UIView *lineView7 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
    lineView7.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView3 addSubview:lineView7];
    
    UIView *lineView8 = [[UIView alloc]initWithFrame:CGRectMake(14, 39.5, SCREENWIDTH, 0.5)];
    lineView8.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView3 addSubview:lineView8];
    
    UIView *lineView9 = [[UIView alloc]initWithFrame:CGRectMake(0, 78.5, SCREENWIDTH, 0.5)];
    lineView9.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView3 addSubview:lineView9];
    
    BaseLabel *storeMyIDLabel = [BaseLabel makeFrame:CGRectMake(13, 10, 60, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"我是商家"];
    [backView3 addSubview:storeMyIDLabel];
    
    BaseLabel *storeUserIDLabel = [BaseLabel makeFrame:CGRectMake(13, 10+38.5, 200, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"我是用户 推荐此商家"];
    [backView3 addSubview:storeUserIDLabel];
    
    //我是商家
    UIButton *MyIDButton = [UIButton buttonWithType:UIButtonTypeSystem];
    MyIDButton.frame = CGRectMake(SCREENWIDTH-200, 10, 200, 20);
    MyIDButton.tag = 1003;
    [MyIDButton addTarget:self action:@selector(chooseOnOrOff:) forControlEvents:UIControlEventTouchUpInside];
    [backView3 addSubview:MyIDButton];
    
    _imgMyID = [[UIImageView alloc]initWithFrame:CGRectMake(200-18.5-10, 1, 18.5, 18.5)];
    _imgMyID.image = [UIImage imageNamed:@"btn_select_pay"];
    [MyIDButton addSubview:_imgMyID];
    
    //我是用户
    UIButton *userIDButton = [UIButton buttonWithType:UIButtonTypeSystem];
    userIDButton.frame = CGRectMake(SCREENWIDTH-200, 10+39, 200, 20);
    userIDButton.tag = 1004;
    [userIDButton addTarget:self action:@selector(chooseOnOrOff:) forControlEvents:UIControlEventTouchUpInside];
    [backView3 addSubview:userIDButton];
    
    _imgUserID = [[UIImageView alloc]initWithFrame:CGRectMake(200-18.5-10, 1, 18.5, 18.5)];
    _imgUserID.image = [UIImage imageNamed:@"btn_unselect_pay"];
    [userIDButton addSubview:_imgUserID];

    //第四部分
    backView4 = [[UIView alloc]initWithFrame:CGRectMake(0, backView3.frame.origin.y+backView3.frame.size.height+11, SCREENWIDTH, 79+39.5)];
    backView4.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:backView4];
    
    UIView *lineView10 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
    lineView10.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView4 addSubview:lineView10];
    UIView *lineView11 = [[UIView alloc]initWithFrame:CGRectMake(14, 39.5, SCREENWIDTH, 0.5)];
    lineView11.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView4 addSubview:lineView11];
    
    UIView *lineView12 = [[UIView alloc]initWithFrame:CGRectMake(14, 78.5, SCREENWIDTH, 0.5)];
    lineView12.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView4 addSubview:lineView12];
    
    UIView *lineView13 = [[UIView alloc]initWithFrame:CGRectMake(0, 79+39, SCREENWIDTH, 0.5)];
    lineView13.backgroundColor = [BBSColor hexStringToColor:@"eaeaea"];
    [backView4 addSubview:lineView13];
    
    BaseLabel *phoneLabel = [BaseLabel makeFrame:CGRectMake(13, 10, 60, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"您的电话"];
    [backView4 addSubview:phoneLabel];
    
    BaseLabel *mailLabel = [BaseLabel makeFrame:CGRectMake(13, 10+38.5, 60, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"您的邮箱"];
    [backView4 addSubview:mailLabel];
    
    BaseLabel *adressLabel = [BaseLabel makeFrame:CGRectMake(13, 10+38.5+38.5, 60, 20) font:14 textColor:@"000000" textAlignment:NSTextAlignmentLeft text:@"详细地址"];
    [backView4 addSubview:adressLabel];
    
    _phoneNumberTF = [[UITextField alloc]initWithFrame:CGRectMake(75,11 , SCREENWIDTH-85, 20)];
    _phoneNumberTF.placeholder = @"输入您的手机号或座机号";
    _phoneNumberTF.delegate = self;
    _phoneNumberTF.font = [UIFont systemFontOfSize:14];
    _phoneNumberTF.borderStyle = UITextBorderStyleNone;
    [backView4 addSubview:_phoneNumberTF];
    
    _youMailTF = [[UITextField alloc]initWithFrame:CGRectMake(75,11+38.5, SCREENWIDTH-85, 20)];
    _youMailTF.placeholder = @"输入您的邮箱";
    _youMailTF.delegate = self;
    _youMailTF.font = [UIFont systemFontOfSize:14];
    _youMailTF.borderStyle = UITextBorderStyleNone;
    [backView4 addSubview:_youMailTF];
    
    _detailAddress =[[UITextField alloc]initWithFrame:CGRectMake(75,11+38.5+38.5, SCREENWIDTH-85, 20)];
    _detailAddress.placeholder = @"商铺地址或链接";
    _detailAddress.delegate = self;
    _detailAddress.font = [UIFont systemFontOfSize:14];
    _detailAddress.borderStyle = UITextBorderStyleNone;
    [backView4 addSubview:_detailAddress];
    
    BaseLabel *sumbitLabel = [BaseLabel makeFrame:CGRectMake(13, backView4.frame.origin.y+backView4.frame.size.height+10, 260, 15) font:13 textColor:@"999999" textAlignment:NSTextAlignmentLeft text:@"提交后，我们会在3-5个工作日联系您"];
    [_scrollView addSubview:sumbitLabel];
    
    sumbitBtn = [YLButton buttonEasyInitBackColor:[BBSColor hexStringToColor:@"fe6161"] frame:CGRectMake(15, sumbitLabel.frame.origin.y+sumbitLabel.frame.size.height+10, 280, 41) type:UIButtonTypeSystem backImage:nil target:self action:@selector(subitMessage) forControlEvents:UIControlEventTouchUpInside];
    sumbitBtn.layer.masksToBounds = YES;
    sumbitBtn.layer.cornerRadius = 20;
    [sumbitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_scrollView addSubview:sumbitBtn];
    
    
}
-(void)chooseOnOrOff:(UIButton*)sender{
    [_storeDescTF resignFirstResponder];
    [_storeNameTF resignFirstResponder];
    [_phoneNumberTF resignFirstResponder];
    [_youMailTF resignFirstResponder];
    [_detailAddress resignFirstResponder];

     UIButton *button = (UIButton*)sender;
    if (button.tag == 1001) {
        NSLog(@"%ld",(long)_isCoompetation);
        _isCoompetation = 0;
        _imgOffStore.image = [UIImage imageNamed:@"btn_select_pay"];
        _imgOnStore.image = [UIImage imageNamed:@"btn_unselect_pay"];
        _imgCoop.image = [UIImage imageNamed:@"btn_unselect_pay"];
    }else if(button.tag == 1002){
        _isCoompetation = 1;
        _imgOnStore.image = [UIImage imageNamed:@"btn_select_pay"];
        _imgOffStore.image = [UIImage imageNamed:@"btn_unselect_pay"];
        _imgCoop.image = [UIImage imageNamed:@"btn_unselect_pay"];
    }else if (button.tag == 1005){
        _isCoompetation = 2;
        _imgOnStore.image = [UIImage imageNamed:@"btn_unselect_pay"];
        _imgOffStore.image = [UIImage imageNamed:@"btn_unselect_pay"];
        _imgCoop.image = [UIImage imageNamed:@"btn_select_pay"];

    }
    if (button.tag == 1003) {
        _isUser = 0;
        _imgMyID.image = [UIImage imageNamed:@"btn_select_pay"];
        _imgUserID.image = [UIImage imageNamed:@"btn_unselect_pay"];

    }else if (button.tag == 1004){
        _isUser = 1;
        _imgMyID.image = [UIImage imageNamed:@"btn_unselect_pay"];
        _imgUserID.image = [UIImage imageNamed:@"btn_select_pay"];

    }
    
    
}
-(void)subitMessage{
    [_storeDescTF resignFirstResponder];
    [_storeNameTF resignFirstResponder];
    [_phoneNumberTF resignFirstResponder];
    [_youMailTF resignFirstResponder];
    [_detailAddress resignFirstResponder];
    NSString *mobile = _phoneNumberTF.text;
    NSString *cooperationName = _storeNameTF.text;
    NSString *cooperationDesc = _storeDescTF.text;
    NSString *email = _youMailTF.text;
    NSString * address = _detailAddress.text;
    NSLog(@"mobie =%@,coopera = %@,cooDe = %@,email = %@,address = %@",mobile,cooperationName,cooperationDesc,email,address);
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",mobile,@"mobile",cooperationName,@"cooperation_name",cooperationDesc,@"cooperation_description",[NSString stringWithFormat:@"%ld",(long)_isCoompetation],@"cooperation_state",[NSString stringWithFormat:@"%d",_isUser],@"user_state",email,@"email",address,@"address", nil];
    [[HTTPClient sharedClient]postNew:kAddCooperation params:param success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
            [self.navigationController popViewControllerAnimated:YES];


        }else{
            
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];

        }
    } failed:^(NSError *error) {
        
    }];
    
    
}
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UITextFieldDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return YES;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == _phoneNumberTF || textField == _youMailTF || textField == _detailAddress ) {
        _scrollView.contentOffset = CGPointMake(0, 150);
    }
    return YES;
}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [_scrollView endEditing:YES];
    
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
