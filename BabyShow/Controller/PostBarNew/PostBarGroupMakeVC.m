//
//  PostBarGroupMakeVC.m
//  BabyShow
//
//  Created by WMY on 16/11/23.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarGroupMakeVC.h"
#import "Reachability.h"
#import "PostBarGroupNewVC.h"
#import "PostBarNewGroupOnlyOneVC.h"
@interface PostBarGroupMakeVC ()

@end

@implementation PostBarGroupMakeVC{
    UIView *textViewGroup ;
    UITextField *groupTextField;
     UITextView *_describeTextView;
    UIView *backView;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[BBSColor hexStringToColor:@"f4f4f4"];
    backView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, SCREENWIDTH, 195)];
    backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:backView];
    [self setTextField];
    [self setLeftBtn];
    [self setRightBtn];
    
    // Do any additional setup after loading the view.
}

//建群的文字框
-(void)setTextField{
    textViewGroup= [[UIView alloc]initWithFrame:CGRectMake(5, 10, SCREENWIDTH,35)];
    textViewGroup.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
    [backView addSubview:textViewGroup];
    
    UIImageView *imageGroup = [[UIImageView alloc]initWithFrame:CGRectMake(5, 6, 40, 20)];
    imageGroup.image = [UIImage imageNamed:@"img_group_logo"];
    [textViewGroup addSubview:imageGroup];
    UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(50, 0, 45, 35)];
    labels.text = @"建群";
    labels.font = [UIFont systemFontOfSize:18];
    labels.textColor = [BBSColor hexStringToColor:@"#9d9d9d"];
    [textViewGroup addSubview:labels];
    groupTextField = [[UITextField alloc]initWithFrame:CGRectMake(95, 0, SCREENWIDTH-85-5, 35)];
    groupTextField.placeholder = @"输入群主题";
    //groupTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    groupTextField.delegate = self;
    [textViewGroup addSubview:groupTextField];
    
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,45, SCREENWIDTH, 0.5)];
    lineLabel.backgroundColor = [BBSColor hexStringToColor:@"#9d9d9d"];
    [textViewGroup addSubview:lineLabel];
    
    _describeTextView=[[UITextView alloc]initWithFrame:CGRectMake(5, 45, SCREENWIDTH-10, 150)];
    _describeTextView.text=@"描述";
    _describeTextView.font=[UIFont systemFontOfSize:15];
    _describeTextView.delegate=self;
    [backView addSubview:_describeTextView];
    
    
}

#pragma mark UI

-(void)setLeftBtn{
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(cancelback) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
-(void)setRightBtn{
    CGRect sendBtnFrame=CGRectMake(0, 0, 40, 24);
    UIButton *sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame=sendBtnFrame;
    [sendBtn setTitle:@"创建" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendPostBar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}
-(void)sendPostBar{
    [self.view endEditing:YES];
    [MobClick event:UMEVENTSHOW];
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NSParameterAssert([reach isKindOfClass:[Reachability class]]);
    NetworkStatus stats = [reach currentReachabilityStatus];
    if (stats == NotReachable) {
        [BBSAlert showAlertWithContent:@"您似乎与网络断开，检查一下网络再发送吧" andDelegate:self];
    }else{
        NSString *description = _describeTextView.text;
        NSString *groupName = groupTextField.text;
        if (groupName.length<=0) {
            [BBSAlert showAlertWithContent:@"给自己的群起个名字吧!" andDelegate:self];
        }else{
            NSMutableDictionary *param=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        LOGIN_USER_ID, @"login_user_id",nil];
            [param setObject:groupTextField.text forKey:@"group_title"];
            if (description.length > 0&&![description isEqualToString:@"描述"]) {
                [param setObject:_describeTextView.text forKey:@"description"];

            }
            [self postGroupName:param];
        }
    }

}
-(void)postGroupName:(NSDictionary*)param{
    UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewV1UrlStr:@"publicGroup" Method:NetMethodPost andParam:param];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlMaker.url];
    for (NSString *key in [param allKeys]) {
        
        id obj = [param objectForKey:key];
        [request setPostValue:obj forKey:key];
    }
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:10];
    [request startAsynchronous];
    __weak ASIFormDataRequest *blockRequest = request;
    [request setCompletionBlock:^{
        NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
        if ([[dic objectForKey:kBBSSuccess] integerValue] == YES) {
            NSDictionary *dataDic = [dic objectForKey:kBBSData];
            PostBarNewGroupOnlyOneVC *postBarVC = [[PostBarNewGroupOnlyOneVC alloc]init];
            postBarVC.group_id = [dataDic[@"group_id"] intValue];
            postBarVC.isFromMakeGroup = @"isFromMakeGroup";
            [self.navigationController pushViewController:postBarVC animated:YES];

        }
    }];


    
}
-(void)cancelback{
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
        UIAlertView *alertview = [[UIAlertView alloc]initWithTitle:nil message:@"群主题不能超过20字哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertview show];
        
        return NO;
    }
    return YES;
}
#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
 if (textView==_describeTextView){
        
        if ([textView.text isEqualToString:@"描述"]) {
            textView.text=@"";
        }
        
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
if (textView==_describeTextView){
        
        if (textView.text.length==0) {
            textView.text=@"描述";
        }
        
    }
    
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
 if (textView==_describeTextView){
        if (textView.text.length>=500) {
            [BBSAlert showAlertWithContent:@"描述最多500字哟！" andDelegate:self];
            textView.text=[textView.text substringToIndex:500];
        }
        
    }
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
