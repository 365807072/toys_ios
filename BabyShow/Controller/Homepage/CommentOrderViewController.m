//
//  CommentOrderViewController.m
//  BabyShow
//
//  Created by WMY on 15/10/29.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "CommentOrderViewController.h"

@interface CommentOrderViewController ()<UITextViewDelegate>
@property(nonatomic,strong)UITextView *commentTextView;
@property(nonatomic,strong)UIButton *sumbitButton;
@property(nonatomic,assign)NSInteger starLevel;
@property(nonatomic,strong)UIScrollView *scrollView;
@end

@implementation CommentOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [BBSColor hexStringToColor:@"f2f2f2"];
    [self setLeftButton];
    [self setSubviews];
    
    // Do any additional setup after loading the view.
}
-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

#pragma mark UI布局
-(void)setLeftButton{
    //返回按钮
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImageView *imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 49, 31)];
    imagev.image = [UIImage imageNamed:@"btn_back1.png"];
    [_backBtn addSubview:imagev];
    UILabel *cateName = [[UILabel alloc]initWithFrame:CGRectMake(20, 0, 150, 31)];
    cateName.textColor = [UIColor whiteColor];
    cateName.text = @"评价订单";
    [_backBtn addSubview:cateName];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
-(void)setSubviews{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT+200)];
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(0, SCREENHEIGHT+200);
    UIView *whiteView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 90)];
    whiteView1.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:whiteView1];
    UILabel *scoresLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 150, 20)];
    scoresLabel.text = @"评价打分";
    scoresLabel.font = [UIFont systemFontOfSize:15];
    [whiteView1 addSubview:scoresLabel];
    UILabel *fiveStar = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-100, 12, 85, 17)];
    fiveStar.text = @"满意请给5星";
    fiveStar.textColor = [BBSColor hexStringToColor:@"999999"];
    fiveStar.font = [UIFont systemFontOfSize:13];
    [whiteView1 addSubview:fiveStar];
    UIImageView *imgLine1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 1)];
    imgLine1.backgroundColor = [BBSColor hexStringToColor:@"f2f2f2"];
    [whiteView1 addSubview:imgLine1];
    UILabel *likeLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 51, 120, 18)];
    likeLabel.font = [UIFont systemFontOfSize:14];
    likeLabel.text = @"小孩子喜欢程度：";
    [whiteView1 addSubview:likeLabel];
    for (int i = 0; i < 5; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(15+likeLabel.frame.size.width+(25*i), 51, 19.5, 18.5);
        [button setBackgroundImage:[UIImage imageNamed:@"btn_order_star"] forState:UIControlStateNormal];
        button.tag = 3001+i;
        [button addTarget:self action:@selector(giveScore:) forControlEvents:UIControlEventTouchUpInside];
        [whiteView1 addSubview:button];
    }
    UIView *whiteView2 = [[UIView alloc]initWithFrame:CGRectMake(0, 100, SCREENWIDTH, 120)];
    whiteView2.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:whiteView2];
    self.commentTextView = [[UITextView alloc]initWithFrame:CGRectMake(10, 10, SCREENWIDTH-20, 100)];
    self.commentTextView.text = @"告诉宝妈们怎么样";
    self.commentTextView.font = [UIFont systemFontOfSize:15];
    self.commentTextView.delegate = self;
    [whiteView2 addSubview:self.commentTextView];
    self.sumbitButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.sumbitButton.frame = CGRectMake(SCREENWIDTH-97, 220+20, 82, 30);
    [self.sumbitButton setBackgroundImage:[UIImage imageNamed:@"btn_order_sumbit"] forState:UIControlStateNormal];
    [_scrollView addSubview:self.sumbitButton];
    [self.sumbitButton addTarget:self action:@selector(sumbitComment) forControlEvents:UIControlEventTouchUpInside];
}
-(void)giveScore:(id)sender{
    [_commentTextView resignFirstResponder];
    UIButton *button = (UIButton*)sender;
    UIButton *button0 = (UIButton*)[self.view viewWithTag:3001];
    UIButton *button1 = (UIButton*)[self.view viewWithTag:3002];
    UIButton *button2 = (UIButton*)[self.view viewWithTag:3003];
    UIButton *button3 = (UIButton*)[self.view viewWithTag:3004];
    UIButton *button4 = (UIButton*)[self.view viewWithTag:3005];
    
    
    if (button.tag == 3001) {
        [button setBackgroundImage:[UIImage imageNamed:@"btn_order_stars"] forState:UIControlStateNormal];
        [button1 setBackgroundImage:[UIImage imageNamed:@"btn_order_star"] forState:UIControlStateNormal];
        [button2 setBackgroundImage:[UIImage imageNamed:@"btn_order_star"] forState:UIControlStateNormal];
        [button3 setBackgroundImage:[UIImage imageNamed:@"btn_order_star"] forState:UIControlStateNormal];
        [button4 setBackgroundImage:[UIImage imageNamed:@"btn_order_star"] forState:UIControlStateNormal];
    }else if(button.tag == 3002){
        [button setBackgroundImage:[UIImage imageNamed:@"btn_order_stars"] forState:UIControlStateNormal];
        [button0 setBackgroundImage:[UIImage imageNamed:@"btn_order_stars"] forState:UIControlStateNormal];
        [button2 setBackgroundImage:[UIImage imageNamed:@"btn_order_star"] forState:UIControlStateNormal];
        [button3 setBackgroundImage:[UIImage imageNamed:@"btn_order_star"] forState:UIControlStateNormal];
        [button4 setBackgroundImage:[UIImage imageNamed:@"btn_order_star"] forState:UIControlStateNormal];

    }else if (button.tag == 3003){
        [button setBackgroundImage:[UIImage imageNamed:@"btn_order_stars"] forState:UIControlStateNormal];
        [button0 setBackgroundImage:[UIImage imageNamed:@"btn_order_stars"] forState:UIControlStateNormal];
        [button1 setBackgroundImage:[UIImage imageNamed:@"btn_order_stars"] forState:UIControlStateNormal];
        [button3 setBackgroundImage:[UIImage imageNamed:@"btn_order_star"] forState:UIControlStateNormal];
        [button4 setBackgroundImage:[UIImage imageNamed:@"btn_order_star"] forState:UIControlStateNormal];
        
    }else if(button.tag == 3004){
        [button setBackgroundImage:[UIImage imageNamed:@"btn_order_stars"] forState:UIControlStateNormal];
        [button0 setBackgroundImage:[UIImage imageNamed:@"btn_order_stars"] forState:UIControlStateNormal];
        [button1 setBackgroundImage:[UIImage imageNamed:@"btn_order_stars"] forState:UIControlStateNormal];
        [button2 setBackgroundImage:[UIImage imageNamed:@"btn_order_stars"] forState:UIControlStateNormal];
        [button4 setBackgroundImage:[UIImage imageNamed:@"btn_order_star"] forState:UIControlStateNormal];


    }else if(button.tag == 3005){
        [button setBackgroundImage:[UIImage imageNamed:@"btn_order_stars"] forState:UIControlStateNormal];
        [button0 setBackgroundImage:[UIImage imageNamed:@"btn_order_stars"] forState:UIControlStateNormal];
        [button1 setBackgroundImage:[UIImage imageNamed:@"btn_order_stars"] forState:UIControlStateNormal];
        [button2 setBackgroundImage:[UIImage imageNamed:@"btn_order_stars"] forState:UIControlStateNormal];
        [button3 setBackgroundImage:[UIImage imageNamed:@"btn_order_stars"] forState:UIControlStateNormal];
            }
    self.starLevel = button.tag-3000;
    NSLog(@"star = %ld",self.starLevel);

}
-(void)sumbitComment{
    NSLog(@"star = %ld",self.starLevel);
    [_commentTextView resignFirstResponder];
    if (self.starLevel<=0) {
        [BBSAlert showAlertWithContent:@"忘记给商家打分了哟" andDelegate:self];
        NSLog(@"没评分");
    }else {

        NSString *commentString =self.commentTextView.text;
        if (commentString.length <9){
            [BBSAlert showAlertWithContent:@"写点评价吧！对其他小伙伴帮着很大呦" andDelegate:self];

        }else{
            NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"login_user_id",self.business_id,@"business_id",[NSString stringWithFormat:@"%ld",self.starLevel],@"like_level",self.order_id,@"order_id",commentString,@"comment_description", nil];
            [[HTTPClient sharedClient]postNew:kPublicOrderComment params:param success:^(NSDictionary *result) {
                if ([[result objectForKey:kBBSSuccess]boolValue]==YES) {
                    [BBSAlert showAlertWithContent:@"感谢评论" andDelegate:self];
                    [self.navigationController popViewControllerAnimated:YES];
                    NSLog(@"评论够，字少");
                }else{
                    [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:self];
                    
                }
            } failed:^(NSError *error) {
                [BBSAlert showAlertWithContent:@"网络错误,请稍后重试" andDelegate:nil];
            }];
        }
    }
    
}
#pragma mark back返回
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
  if (textView==self.commentTextView){
        
        if ([textView.text isEqualToString:@"告诉宝妈们怎么样"]) {
            textView.text=@"";
        }
        
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
  if (textView==self.commentTextView){
        
        if (textView.text.length==0) {
            textView.text=@"告诉宝妈们怎么样";
        }
      [textView resignFirstResponder];
    }
    
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
