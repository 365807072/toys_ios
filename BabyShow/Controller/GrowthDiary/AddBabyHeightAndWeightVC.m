//
//  AddBabyHeightAndWeightVC.m
//  BabyShow
//
//  Created by WMY on 15/11/28.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "AddBabyHeightAndWeightVC.h"

@interface AddBabyHeightAndWeightVC ()<UITextFieldDelegate>
@property(nonatomic,strong)UITextField *heightTF;
@property(nonatomic,strong)UITextField *weightTF;
@property(nonatomic,strong)NSString *heightMessage;
@property(nonatomic,strong)NSString *weightMessage;

@end

@implementation AddBabyHeightAndWeightVC
-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = YES;
}
-(void)viewWillDisappear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"编辑身高体重";
    self.view.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
    [self setBackButton];
    [self setSubviews];
    // Do any additional setup after loading the view.
}

#pragma mark UI

//返回按钮
-(void)setBackButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _backBtn.adjustsImageWhenHighlighted = NO;
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)setSubviews{
    UIView *backView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 90)];
    backView1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView1];
    
    UILabel *heightLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 13, 40, 19)];
    heightLabel.text = @"身高";
    heightLabel.textColor = [BBSColor hexStringToColor:@"333333"];
    heightLabel.font = [UIFont systemFontOfSize:14];
    [backView1 addSubview:heightLabel];
    
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 45, SCREENWIDTH, 0.5)];
    lineView.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
    [backView1 addSubview:lineView];
    
    UILabel *weightLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 13+45, 40, 19)];
    weightLabel.text = @"体重";
    weightLabel.font = [UIFont systemFontOfSize:14];
    [backView1 addSubview:weightLabel];
    
    _heightTF = [[UITextField alloc]initWithFrame:CGRectMake(heightLabel.frame.origin.x+heightLabel.frame.size.width, 6, 90, 30)];
    if ([_babyHeightOld isEqualToString:@"0"]) {
        _heightTF.placeholder = @"请输入身高";
    }else{
        _heightTF.placeholder = [NSString stringWithFormat:@"%@",_babyHeightOld];
    }
    _heightTF.font = [UIFont systemFontOfSize:14];
    _heightTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _heightTF.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
    _heightTF.delegate = self;
    _heightTF.keyboardType = UIKeyboardTypeNumberPad;
    _heightTF.layer.masksToBounds = YES;
    _heightTF.layer.cornerRadius = 5;

    [backView1 addSubview:_heightTF];
    UILabel *CMLabel = [[UILabel alloc]initWithFrame:CGRectMake(_heightTF.frame.origin.x+_heightTF.frame.size.width+5, 13, 20, 19)];
    CMLabel.text = @"cm";
    CMLabel.textColor = [BBSColor hexStringToColor:@"333333"];
    CMLabel.font = [UIFont systemFontOfSize:14];
    [backView1 addSubview:CMLabel];
    
    _weightTF = [[UITextField alloc]initWithFrame:CGRectMake(heightLabel.frame.origin.x+heightLabel.frame.size.width,46+ 6, 90, 30)];
    if ([_babyWeightOld isEqualToString:@"0"]) {
        _weightTF.placeholder = @"请输入体重";
    }else{
        _weightTF.placeholder = [NSString stringWithFormat:@"%@",_babyWeightOld];
    }
    _weightTF.font = [UIFont systemFontOfSize:14];
    _weightTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    _weightTF.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
    _weightTF.layer.masksToBounds = YES;
    _weightTF.layer.cornerRadius = 5;
    _weightTF.keyboardType = UIKeyboardTypeDecimalPad;
    
    _weightTF.delegate = self;
    [backView1 addSubview:_weightTF];
    UILabel *KGLabel = [[UILabel alloc]initWithFrame:CGRectMake(_heightTF.frame.origin.x+_heightTF.frame.size.width+5,46+ 13, 20, 19)];
    KGLabel.text = @"kg";
    KGLabel.textColor = [BBSColor hexStringToColor:@"333333"];
    KGLabel.font = [UIFont systemFontOfSize:14];
    [backView1 addSubview:KGLabel];


    
    //日期
    UIView *backView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 164, SCREENWIDTH, 45)];
    backView2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView2];
    UILabel *dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(18, 13, 40, 19)];
    dateLabel.text = @"日期";
    dateLabel.textColor = [BBSColor hexStringToColor:@"333333"];
    dateLabel.font = [UIFont systemFontOfSize:14];
    [backView2 addSubview:dateLabel];
    
    NSDate *  senddate=[NSDate date];
    NSCalendar  * cal=[NSCalendar  currentCalendar];
    NSUInteger  unitFlags=NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents * conponent= [cal components:unitFlags fromDate:senddate];
    NSInteger year=[conponent year];
    NSInteger month=[conponent month];
    NSInteger day=[conponent day];
    NSString *nsDateString= [NSString  stringWithFormat:@"%ld年%ld月%ld日",year,month,day];
    
    UILabel *dateDetailLabel = [[UILabel alloc]initWithFrame:CGRectMake(58, 13, 150, 19)];
    dateDetailLabel.text = nsDateString;
    dateDetailLabel.textColor = [BBSColor hexStringToColor:@"666666"];
    dateDetailLabel.font = [UIFont systemFontOfSize:14];
    [backView2 addSubview:dateDetailLabel];

    
    UIButton *sumbitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sumbitButton.adjustsImageWhenHighlighted = NO;
    sumbitButton.frame = CGRectMake(18, 155+64, 283, 35);
    [sumbitButton addTarget:self action:@selector(sumbitMessageBaby) forControlEvents:UIControlEventTouchUpInside];
    [sumbitButton setBackgroundImage:[UIImage imageNamed:@"btn_diary_sumbitheight"] forState:UIControlStateNormal];
    
    
    [self.view addSubview:sumbitButton];
    
    }
//完成之后的提交
-(void)sumbitMessageBaby{
    _heightMessage = _heightTF.text;
    _weightMessage = _weightTF.text;
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.babyId,@"baby_id",_heightMessage,@"height",_weightMessage,@"weight", nil];
    [[HTTPClient sharedClient]getNew:kPublicGrowth params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess]boolValue] == YES) {
            NSLog(@"datadic = %@",result);
            self.refreshIngrowthVC();
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
#pragma mark UITextFieldDelegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger length = textField.text.length;
    if (length >= 20 && string.length > 0) {
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:nil message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertview show];
        
        return NO;
    }
    return YES;
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
