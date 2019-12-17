//
//  SuggestVC.m
//  BabyShow
//
//  Created by WMY on 17/5/24.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "SuggestVC.h"

@interface SuggestVC ()<UITextViewDelegate>
@property(nonatomic,strong)UIScrollView *bottomScrollView;//整体的底色

@property(nonatomic,strong)UITextView *tfSuggest;
@property(nonatomic,strong)UIButton *sureBtn;

@end

@implementation SuggestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setLeftBtn];
    [self setSubviews];
    // Do any additional setup after loading the view.
}
-(void)setLeftBtn{
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(cancelback) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
-(void)cancelback{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)setSubviews{
    _bottomScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,64, SCREENWIDTH,self.view.bounds.size.height)];
    _bottomScrollView.contentSize = CGSizeMake(SCREENWIDTH, SCREEN_HEIGHT*2);
    _bottomScrollView.alwaysBounceVertical = YES;
    _bottomScrollView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.view addSubview:_bottomScrollView];

    _tfSuggest = [[UITextView alloc]initWithFrame:CGRectMake(20,40, SCREENWIDTH-40, 100)];
    _tfSuggest.textColor = [BBSColor hexStringToColor:@"9b9b9b"];
    _tfSuggest.delegate = self;
    _tfSuggest.layer.borderColor = [UIColor grayColor].CGColor;
    _tfSuggest.backgroundColor = [UIColor whiteColor];
    _tfSuggest.font = [UIFont systemFontOfSize:16.0];
    _tfSuggest.layer.borderWidth = 0.5;
    [_bottomScrollView addSubview:_tfSuggest];
    
    _sureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _sureBtn.frame = CGRectMake(20, 160, SCREENWIDTH-40, 40);
    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.cornerRadius = 19;
    [_sureBtn setTitle:@"确认" forState:UIControlStateNormal];
    _sureBtn.backgroundColor = [BBSColor hexStringToColor:@"fd6363"];
    [_sureBtn setTitleColor:[BBSColor hexStringToColor:@"ffffff"] forState:UIControlStateNormal];
    [_bottomScrollView addSubview:_sureBtn];
    [_sureBtn addTarget:self action:@selector(postdatSuggest) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)postdatSuggest{
    [_tfSuggest resignFirstResponder];
    NSString *suggestString = _tfSuggest.text;
    if (suggestString.length <= 0) {
        [BBSAlert showAlertWithContent:@"您未填写任何反馈哦！" andDelegate:self];

    }else{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.orderId,@"order_id",suggestString,@"suggest", nil];
        [[HTTPClient sharedClient]postNewV1:@"editOrderSuggest" params:param success:^(NSDictionary *result) {
            if ([[result objectForKey:kBBSSuccess]boolValue]==YES) {
                [BBSAlert showAlertWithContent:@"感谢反馈" andDelegate:self];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
            }
        } failed:^(NSError *error) {
            [BBSAlert showAlertWithContent:@"网络错误,请稍后重试" andDelegate:nil];
        }];
    }
}
#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
        [textView resignFirstResponder];
    
}

#pragma mark - UITextView Delegate Methods
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
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
