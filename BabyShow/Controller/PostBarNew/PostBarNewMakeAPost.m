//
//  PostBarNewMakeAPost.m
//  BabyShow
//
//  Created by Monica on 10/28/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarNewMakeAPost.h"
#import "AlbumListViewController.h"
#import "CHTumblrMenuView.h"
#import "UIImageView+WebCache.h"
#import "UserInfoItem.h"
#import "PostBarNewVC.h"

#import <ShareSDK/ShareSDK.h>
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMedia/CoreMedia.h>
#import "SDWebImageManager.h"
#import "Reachability.h"
#import "PostBarNewMakeSecondVC.h"
#import "BBSCommonNavigationController.h"
#import "PostBarNewDetialV1VC.h"
#import "PostBarGroupMakeVC.h"


static float beginheight=10;
static float titleheight=40;
static float seperateviewheight=0.5;
static float describeheight=50;
static float photoheight=100;
static float urlheight=30;
static float seperateheight=1;

@interface PostBarNewMakeAPost ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ALRadialMenuDelegate>

//是否分享到微信,微博
@property (nonatomic ,assign)BOOL shareToWeixin;
@property (nonatomic ,assign)BOOL shareToWeibo;
@property(nonatomic,assign)BOOL isPhoto;//是选择视频还是照片
@property(nonatomic,strong)UIImage *imgUrl;
@property(nonatomic,strong)UIView *textBackView;//文字背景
@property(nonatomic,strong)UIView *photoBackView;//图片选择器

//是否直接发到个人群里面
@property(nonatomic,strong)UIView *personalGroupView;//个人群
@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UILabel *groupTitleLabel;//群名字btn

//添加图片view
@property(nonatomic,strong)UIView *imgView;
@property(nonatomic,strong)UIButton *addImgBtn;
@property(nonatomic,strong)UIButton *imgTextAddBtn;

//添加视频的view
@property(nonatomic,strong)UIView *videoView;
@property(nonatomic,strong)UIButton *addVideoBtn;
@property(nonatomic,strong)UIButton *videoTextAddBtn;
@property(nonatomic,strong)UIView *shareAndClassBackView;//分享和选择
@property(nonatomic,strong)UIImageView *videoImgBackView;//选择视频之后的图片

//我想建个群
@property(nonatomic,strong)UIView *groupView;
@property(nonatomic,strong)UIButton *addGroupBtn;
@property(nonatomic,strong)UIButton *videoGroupAddBtn;


@property(nonatomic,strong)UIView *btnBackView;//按钮的集合buttn
@property(nonatomic,strong)UIView *shareBtnBackView;//分享的按钮
@property(nonatomic,strong)NSString *video_url;//视频的url
@property(nonatomic,assign)BOOL isVideo;//是否是视频
@property(nonatomic,strong)NSMutableDictionary *paramDic;//参数的
@property(nonatomic,strong)NSString *netType;
@property(nonatomic,strong)NSString *groupType;
@property(nonatomic,strong)NSString *img_id;//发完之后的img_id
@property(nonatomic,strong)NSString *make_group_id;//发完生成群id
@property(nonatomic,strong)YLButton *textMakeOtherBtn;//查看如何发帖
@property(nonatomic,strong)UIImageView *lineImgView;//下划线
@property(nonatomic,strong)YLButton *makeOtherBtn;//查看帖子btn
@property(nonatomic,assign)BOOL isChooseGroup;//是否选择群

@end
#define SENDFRAME CGRectMake(280, 84, 20, 20);

@implementation PostBarNewMakeAPost
{
    UIScrollView *_scrollView;
    UIScrollView *_photoView;
    
    UITextView *_titleTextView;
    UIView *_seperateView;
    UITextView *_describeTextView;
    
    UIButton *_addPhotoBtn;
    UIButton *_addUrlBtn;
    UIButton *_shareWeixinBtn;  //分享到微信
    UIButton *_shareWeiboBtn;   //分享到微博
    UIButton *_sendBtn;

    UIImageView *imgView1;
    UIImageView *imgView2;
    UIImageView *imgView3;
    UIImageView *imgView4;
    NSArray *imageArray;
    NSArray *buttonArray;
    UILabel *textLabel;
    UITextField *groupTextField;
    UIView *textViewGroup ;
    float  imageWidth;
    //发完帖子之后弹出页面
    UIView *backViewAlert;
    UIImageView *backImgView;
    UIButton *endSendBtn;
    UIButton *goOnNextBtn;
    
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.pickedImagesArray=[NSMutableArray array];
        
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    self.navigationController.tabBarController.tabBar.hidden = YES;

    //注册通知，键盘通知的方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisapper:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    _scrollView=[[UIScrollView alloc]initWithFrame:self.view.frame];
    _scrollView.contentSize=CGSizeMake(SCREENWIDTH, 600);
    [self.view addSubview:_scrollView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [_scrollView addGestureRecognizer:singleTap];
    
    _menu=[[ALRadialMenu alloc]init];
    _menu.delegate=self;

    _shareToWeixin = YES;
    _shareToWeibo = NO;
    [self isHiddenGroupView];
    [self setLeftBtn];
    [self setRightBtn];
    if (!self.group_id) {
       // [self setTextField];
    }
    //完成一段图文帖子之后的提示，需要给他
    [self hideBackViewAlertView];
    BBSCommonNavigationController *nav = (BBSCommonNavigationController*)self.navigationController;
    nav.isNotGoBack = YES;

}
-(void)isHiddenGroupView{
    NSLog(@"iisisisisisiis = %d",_isHiddenGroup);
    
    [self setSubviews:YES];
}
-(void)hideBackViewAlertView{
    backViewAlert = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT)];
    backViewAlert.backgroundColor = [BBSColor hexStringToColor:@"9e9e9e" alpha:0.5];
    [self.view addSubview:backViewAlert];
    
    backImgView = [[UIImageView alloc]initWithFrame:CGRectMake(33, 188, 256, 179)];
    backImgView.image = [UIImage imageNamed:@"make_show_background"];
    backImgView.userInteractionEnabled = YES;
    [backViewAlert addSubview:backImgView];
    
    endSendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    endSendBtn.frame = CGRectMake(52, 35, 149,54);
    [endSendBtn setBackgroundImage:[UIImage imageNamed:@"make_show_end"] forState:UIControlStateNormal];
    [endSendBtn setTitle:@"完成此话题" forState:UIControlStateNormal];
    [endSendBtn addTarget:self action:@selector(endSendPost) forControlEvents:UIControlEventTouchUpInside];
    endSendBtn.titleLabel.textColor = [UIColor whiteColor];
    endSendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [backImgView addSubview:endSendBtn];
    
    goOnNextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goOnNextBtn.frame = CGRectMake(52, 35+54+13, 149,54);
    [goOnNextBtn setBackgroundImage:[UIImage imageNamed:@"make_show_end"] forState:UIControlStateNormal];
    [goOnNextBtn setTitle:@"继续下一段图文" forState:UIControlStateNormal];
    goOnNextBtn.titleLabel.textColor = [UIColor whiteColor];
    goOnNextBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [backImgView addSubview:goOnNextBtn];
    [goOnNextBtn addTarget:self action:@selector(pushNextPostMakeAShow) forControlEvents:UIControlEventTouchUpInside];
    backViewAlert.hidden = YES;
    
}
#pragma mark 上传一段成功后
-(void)pushNextPostMakeAShow{
    PostBarNewMakeSecondVC *postSecond = [[PostBarNewMakeSecondVC alloc]init];
    postSecond.img_id = self.img_id;
    postSecond.make_groupId = self.make_group_id;
    postSecond.isFromGroup = self.isFromGroup;
    [self.navigationController pushViewController:postSecond animated:NO];
}
-(void)endSendPost{
    self.update();
    [self back];
   // [self performSelector:@selector(back) withObject:nil afterDelay:1];

}
-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [self.view endEditing:YES];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_titleTextView resignFirstResponder];
    [_describeTextView resignFirstResponder];
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
#pragma mark HUD

-(void)showHUDWithMessage:(NSString *)message{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60,64+20+50+50+50+5 , 200, 30)];
    label.backgroundColor = [UIColor darkGrayColor];
    label.layer.cornerRadius = 3.0;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = message;
    label.textColor = [UIColor whiteColor];
    label.font=[UIFont systemFontOfSize:13];
    label.alpha=0.5;
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

//#pragma mark NSNotification
//
-(void)makeApostParams{
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    

    if ([self.isFromGroup isEqualToString:@"isfromGroup"]) {
        //来自群的
        delegate.isHaveUploadGroup = YES;
    }else{
        delegate.isHaveUpLoadPost = YES;

    }

        if ([self.isFromMain isEqualToString:@"isFromMain"]) {
        PostBarNewVC *postbarVC=[[PostBarNewVC alloc]init];
        postbarVC.login_user_id=LOGIN_USER_ID;
        postbarVC.post_create_time=NULL;
        postbarVC.type=POSTBARNEWTYPEDEFAULT;
        postbarVC.navigationItem.title=@"热点";
        postbarVC.isFromMain = @"isFromMain";
        [self.navigationController pushViewController:postbarVC animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
}
-(void)makeAPostBack{
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    //如果是来自群的
    if ([self.isFromGroup isEqualToString:@"isfromGroup"]) {
        delegate.isHaveUploadGroup = YES;
    }

    if ([self.isFromMain isEqualToString:@"isFromMain"]) {
        PostBarNewVC *postbarVC=[[PostBarNewVC alloc]init];
        postbarVC.login_user_id=LOGIN_USER_ID;
        postbarVC.post_create_time=NULL;
        postbarVC.type=POSTBARNEWTYPEDEFAULT;
        postbarVC.navigationItem.title=@"热点";
        postbarVC.isFromMain = @"isFromMain";
        [self.navigationController pushViewController:postbarVC animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}

-(void)netFail{
    
    _sendBtn.enabled=YES;
    [LoadingView stopOnTheViewController:self];
    
    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:self];
    
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
-(void)cancelback{
    if ([self.isFromMain isEqualToString:@"isFromMain"]) {
        [self.navigationController popViewControllerAnimated:YES];

    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
-(void)setRightBtn{
    CGRect sendBtnFrame=CGRectMake(0, 0, 24, 24);
    _sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame=sendBtnFrame;
    UIImage *sendImg=[UIImage imageNamed:@"btn_makeashow_send_square.png"];
    [_sendBtn setImage:sendImg forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(sendPostBar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_sendBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}
//建群的文字框
-(void)setTextField{
    textViewGroup= [[UIView alloc]initWithFrame:CGRectMake(5, SCREENHEIGHT-35, SCREENWIDTH,35)];
    textViewGroup.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
    
    [self.view addSubview:textViewGroup];
    UILabel *lineLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
    lineLabel.backgroundColor = [BBSColor hexStringToColor:@"#9d9d9d"];
    [textViewGroup addSubview:lineLabel];
    
    UIImageView *imageGroup = [[UIImageView alloc]initWithFrame:CGRectMake(5, 6, 22, 22)];
    imageGroup.image = [UIImage imageNamed:@"img_圆角矩形 30"];
    [textViewGroup addSubview:imageGroup];
    UILabel *labels = [[UILabel alloc]initWithFrame:CGRectMake(35, 0, 45, 35)];
    labels.text = @"建群";
    labels.font = [UIFont systemFontOfSize:18];
    labels.textColor = [BBSColor hexStringToColor:@"#9d9d9d"];
    [textViewGroup addSubview:labels];
    groupTextField = [[UITextField alloc]initWithFrame:CGRectMake(85, 0, SCREENWIDTH-85-5, 35)];
    groupTextField.placeholder = @"输入群主题";
    groupTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    groupTextField.delegate = self;
    [textViewGroup addSubview:groupTextField];
    
}
//分享
-(void)setSubviews:(BOOL)isHiddenGroupView{
    
    CGRect titleFrame = CGRectMake(5, beginheight, SCREENWIDTH-10, titleheight);
    CGRect seperateFrame = CGRectMake(9, beginheight+titleheight+seperateheight, SCREENWIDTH-18, seperateviewheight);
    CGRect describeFrame = CGRectMake(5,beginheight+titleheight+seperateheight+seperateviewheight,  SCREENWIDTH-10, describeheight);
    CGRect photoviewFrame = CGRectMake(5,beginheight+titleheight+seperateheight+describeheight+seperateviewheight,  SCREENWIDTH, 110);
    _textBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 102)];
    _textBackView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_textBackView];
    
    _titleTextView=[[UITextView alloc]initWithFrame:titleFrame];
    _titleTextView.text=@"标题（选填）：";
    _titleTextView.font=[UIFont systemFontOfSize:15];
    _titleTextView.textColor=[BBSColor hexStringToColor:@"#9b9b9b"];
    _titleTextView.delegate=self;
    [_textBackView addSubview:_titleTextView];
    
    _seperateView=[[UIView alloc]initWithFrame:seperateFrame];
    _seperateView.backgroundColor=[UIColor lightGrayColor];
    [_textBackView addSubview:_seperateView];
    
    _describeTextView=[[UITextView alloc]initWithFrame:describeFrame];
    _describeTextView.text=@"描述";
    _describeTextView.font=[UIFont systemFontOfSize:15];
    _describeTextView.delegate=self;
    [_textBackView addSubview:_describeTextView];
    
    //添加图片和视频的view
    imageWidth = (SCREENWIDTH-60)/5;
    if (!self.group_id) {
        //不是在群里面发的帖子
        if (_isHiddenGroup == YES) {
            _photoBackView = [[UIView alloc]initWithFrame:CGRectMake(0, _textBackView.frame.size.height, SCREENWIDTH, 160+80)];
   
        }else{
        _personalGroupView = [[UIView alloc]initWithFrame:CGRectMake(0, _textBackView.frame.size.height, SCREEN_WIDTH, 40)];
        [_scrollView addSubview:_personalGroupView];
        self.selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.selectBtn.frame = CGRectMake(10, 10, 20, 20);
        [self.selectBtn setImage:[UIImage imageNamed:@"toy_car_buy_select"] forState:UIControlStateNormal];
            [self.selectBtn addTarget:self action:@selector(chooseGroup) forControlEvents:UIControlEventTouchUpInside];
            self.group_id = [self.groupId integerValue];

            
        [_personalGroupView addSubview:self.selectBtn];
        self.groupTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(35, 10, SCREEN_WIDTH-45, 20)];
        self.groupTitleLabel.text = _groupName;
            
        self.groupTitleLabel.font = [UIFont systemFontOfSize:13];
        self.groupTitleLabel.textColor = [BBSColor hexStringToColor:@"666666"];
        [_personalGroupView addSubview:self.groupTitleLabel];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(chooseGroup)];
            [_personalGroupView addGestureRecognizer:singleTap];
            
            _isChooseGroup = YES;
        _photoBackView = [[UIView alloc]initWithFrame:CGRectMake(0, _textBackView.frame.size.height+40, SCREENWIDTH, 160+80)];
        }
        
    }else{
    _photoBackView = [[UIView alloc]initWithFrame:CGRectMake(0, _textBackView.frame.size.height, SCREENWIDTH, 160)];
    }
    _photoBackView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_photoBackView];
    //添加图片
    self.imgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, imageWidth+20)];
    self.imgView.backgroundColor = [UIColor whiteColor];
    [_photoBackView addSubview:self.imgView];

    //添加图片的按钮
    self.addImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addImgBtn.frame = CGRectMake(10, 10, imageWidth, imageWidth);
    [self.addImgBtn setImage:[UIImage imageNamed:@"make_img_select"] forState:UIControlStateNormal];
    
    self.addImgBtn.adjustsImageWhenDisabled = NO;
    [self.addImgBtn addTarget:self action:@selector(ChoosePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.imgView addSubview:self.addImgBtn];
    
    self.imgTextAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imgTextAddBtn.frame = CGRectMake(self.addImgBtn.frame.origin.x+imageWidth+10, 13, imageWidth+5, imageWidth);
    [self.imgTextAddBtn setTitle:@"添加图片" forState:UIControlStateNormal];
    self.imgTextAddBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.imgTextAddBtn setTitleColor:[BBSColor hexStringToColor:@"999999"] forState:UIControlStateNormal];
    [self.imgTextAddBtn addTarget:self action:@selector(ChoosePhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.imgView addSubview:self.imgTextAddBtn];
    //添加视频
    self.videoView = [[UIView alloc]initWithFrame:CGRectMake(0, self.imgView.frame.origin.y+self.imgView.frame.size.height, SCREENWIDTH, imageWidth+20)];
        [_photoBackView addSubview:self.videoView];
    
    //添加视频按钮
    self.addVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addVideoBtn.frame = CGRectMake(10, 10,imageWidth, imageWidth);
    [self.addVideoBtn setImage:[UIImage imageNamed:@"make_video_select"] forState:UIControlStateNormal];
    [self.addVideoBtn addTarget:self action:@selector(chooseVideoAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.addVideoBtn.adjustsImageWhenDisabled = NO;
    [self.videoView addSubview:self.addVideoBtn];
    
    self.videoTextAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoTextAddBtn.frame = CGRectMake(self.addVideoBtn.frame.origin.x+imageWidth+10, 13, imageWidth+5,imageWidth);
    [self.videoTextAddBtn setTitle:@"添加视频" forState:UIControlStateNormal];
    [self.videoTextAddBtn addTarget:self action:@selector(chooseVideoAction) forControlEvents:UIControlEventTouchUpInside];
    self.videoTextAddBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.videoTextAddBtn setTitleColor:[BBSColor hexStringToColor:@"999999"] forState:UIControlStateNormal];
    [self.videoView addSubview:self.videoTextAddBtn];
    self.videoImgBackView=[[UIImageView alloc]initWithFrame:CGRectMake(6+2*(imageWidth+10), 13, imageWidth, imageWidth)];
    self.videoImgBackView.hidden = YES;
    [self.videoView addSubview:self.videoImgBackView];
    //视频图片上的小按钮
    UIImageView *imgPlay = [[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 25, 25)];
    imgPlay.image = [UIImage imageNamed:@"play_btn_make_show"];
    [self.videoImgBackView addSubview:imgPlay];

    
    _photoView=[[UIScrollView alloc]initWithFrame:photoviewFrame];
    _photoView.contentSize=CGSizeMake(SCREENWIDTH+100, 110);
    _photoView.pagingEnabled=YES;
   // [_scrollView addSubview:_photoView];
    _addPhotoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _addPhotoBtn.frame=CGRectMake(0, 5, 100, 100);
    [_addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"btn_make_a_show_add_photo_gray"] forState:UIControlStateNormal];
    [_addPhotoBtn addTarget:self action:@selector(ChoosePhoto) forControlEvents:UIControlEventTouchUpInside];
    [_photoView addSubview:_addPhotoBtn];
    
    //我想建群
    if (!self.group_id) {
        self.groupView = [[UIView alloc]initWithFrame:CGRectMake(0, self.videoView.frame.origin.y+self.videoView.frame.size.height, SCREENWIDTH, imageWidth+20)];
        self.groupView.backgroundColor = [UIColor whiteColor];
        [_photoBackView addSubview:self.groupView];
        
        self.addGroupBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        self.addGroupBtn.frame = CGRectMake(10, 10,imageWidth, imageWidth);
        [self.addGroupBtn setImage:[UIImage imageNamed:@"make_group_select"] forState:UIControlStateNormal];
        [self.addGroupBtn addTarget:self action:@selector(creatNewGroup) forControlEvents:UIControlEventTouchUpInside];
        self.addGroupBtn.adjustsImageWhenDisabled = NO;
        [self.groupView addSubview:self.addGroupBtn];
        
        self.videoGroupAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.videoGroupAddBtn.frame = CGRectMake(self.addVideoBtn.frame.origin.x+imageWidth+10, 13, imageWidth+15,imageWidth);
        [self.videoGroupAddBtn setTitle:@"我想建个群" forState:UIControlStateNormal];
        [self.videoGroupAddBtn addTarget:self action:@selector(creatNewGroup) forControlEvents:UIControlEventTouchUpInside];
        self.videoGroupAddBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.videoGroupAddBtn setTitleColor:[BBSColor hexStringToColor:@"999999"] forState:UIControlStateNormal];
        [self.groupView addSubview:self.videoGroupAddBtn];

    }
    
    //分享的按钮
    _shareBtnBackView = [[UIView alloc]initWithFrame:CGRectMake(0,  _photoBackView.frame.origin.y+_photoBackView.frame.size.height, SCREENWIDTH, 40+25)];
    _shareBtnBackView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_shareBtnBackView];
    
    //分享微信
    _shareWeixinBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _shareWeixinBtn.frame=CGRectMake(10, 0, (SCREENWIDTH-30)/2, 34);
    [_shareWeixinBtn setBackgroundImage:[UIImage imageNamed:@"img_show_weixin_selected"] forState:UIControlStateNormal];
    _shareWeixinBtn.tag = 1;
    [_shareWeixinBtn addTarget:self action:@selector(shareTo:) forControlEvents:UIControlEventTouchUpInside];
    [_shareBtnBackView addSubview:_shareWeixinBtn];
    
    //分享微博
    UIImage *weiboImage = [UIImage imageNamed:@"img_show_weibo_unselected"];
    if ([ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo]) {
        _shareToWeibo = YES;
        weiboImage = [UIImage imageNamed:@"img_show_weibo_selected"];
        
    }
    _shareWeiboBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _shareWeiboBtn.frame=CGRectMake(20+(SCREENWIDTH-30)/2, 0, (SCREENWIDTH-30)/2, 34);
    [_shareWeiboBtn setBackgroundImage:weiboImage forState:UIControlStateNormal];
    _shareWeiboBtn.tag = 2;
    [_shareWeiboBtn addTarget:self action:@selector(shareTo:) forControlEvents:UIControlEventTouchUpInside];
    [_shareBtnBackView addSubview:_shareWeiboBtn];
    
    self.textMakeOtherBtn = [YLButton buttonWithFrame:CGRectMake(15+(SCREENWIDTH-30)/2, 40, 125, 20) type:UIButtonTypeCustom backImage:nil target:self action:@selector(pushNewOtherPost) forControlEvents:UIControlEventTouchUpInside];
    [self.textMakeOtherBtn setTitle:@"如何发图文并茂的帖子" forState:UIControlStateNormal];
    self.textMakeOtherBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.textMakeOtherBtn setTitleColor:[BBSColor hexStringToColor:@"a3a3a3"] forState:UIControlStateNormal];
    [_shareBtnBackView addSubview:self.textMakeOtherBtn];
    
    self.lineImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 19, 120, 1)];
    self.lineImgView.backgroundColor = [BBSColor hexStringToColor:@"d5d5d5"];
    [self.textMakeOtherBtn addSubview:self.lineImgView];
    
    self.makeOtherBtn = [YLButton buttonWithFrame:CGRectMake(self.textMakeOtherBtn.frame.origin.x+120+2, 40, 25, 25) type:UIButtonTypeCustom backImage:[UIImage imageNamed:@"postbar_otherpost"] target:self action:@selector(pushNewOtherPost) forControlEvents:UIControlEventTouchUpInside];
    [_shareBtnBackView addSubview:self.makeOtherBtn];
}
#pragma mark 发帖的时候是否发送到默认群里面
-(void)chooseGroup{
    _isChooseGroup = !_isChooseGroup;
    if (_isChooseGroup == YES) {
        [self.selectBtn setImage:[UIImage imageNamed:@"toy_car_buy_select"] forState:UIControlStateNormal];
        self.group_id = [self.groupId integerValue];
    }else{
        [self.selectBtn setImage:[UIImage imageNamed:@"toy_car_buy_unselect"] forState:UIControlStateNormal];
        self.group_id = 0;
    }
    
}
#pragma mark 我要建个群
-(void)creatNewGroup{
    PostBarGroupMakeVC *postMake = [[PostBarGroupMakeVC alloc]init];
    [self.navigationController pushViewController:postMake animated:YES];

}
-(void)pushNewOtherPost{
    //跳转帖子详情
    PostBarNewDetialV1VC *detailVC = [[PostBarNewDetialV1VC alloc]init];
    detailVC.img_id = @"74629";
    detailVC.login_user_id=LOGIN_USER_ID;
    detailVC.refreshInVC = ^(BOOL isRefresh){
    };
    [detailVC setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:detailVC animated:YES];

    
}
#pragma mark private

-(void)disappear{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
-(void)back{
    NSLog(@"self.isfromMain = %@,%@",self.isFromGroup,self.isFromMain);
    if ([self.isFromMain isEqualToString:@"isFromMain"]) {
        
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }


    
}
-(void)sendPostBar{
    [self.view endEditing:YES];
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NSParameterAssert([reach isKindOfClass:[Reachability class]]);
    NetworkStatus stats = [reach currentReachabilityStatus];
    if (stats == NotReachable) {
        [BBSAlert showAlertWithContent:@"您似乎与网络断开，检查一下网络再发送吧" andDelegate:self];
    }else{
        NSString *description = _describeTextView.text;
        if ([description isEqualToString:@"描述"]&&[_titleTextView.text isEqualToString:@"标题（选填）："]&&(_isVideo!=YES)&&( _isPhoto != YES)&& groupTextField.text.length<=0) {
            [BBSAlert showAlertWithContent:@"什么都没有，完善一下吧!" andDelegate:self];
        }else{
            if (self.group_id) {
             [self sendData:@"1"];
                
            }else{
            if (_menu.itemIndex) {
                
                CGRect frame=SENDFRAME;
                [_menu buttonsWillAnimateFromButton:_sendBtn withFrame:frame inView:self.view];
                
            }else{
                
                CGRect frame=SENDFRAME;
                [_menu buttonsWillAnimateFromButton:_sendBtn withFrame:frame inView:self.view];
              }
            }
        }

    }
}
#pragma mark 点击所有人或好友
-(void)sendData:(NSString *)groupType{
    [self.view endEditing:YES];
    [MobClick event:UMEVENTSHOW];
    _sendBtn.enabled=NO;
    //如果不是在群里面发帖
    if (!self.group_id) {
        //网络请求，继续秀一下
        //将图片和url地址分别封装
        NSMutableArray *imgageArray=[[NSMutableArray alloc]init];
        NSMutableArray *imgStrArray=[[NSMutableArray alloc]init];
        for (id obj in self.pickedImagesArray) {
            if ([obj isKindOfClass:[UIImage class]]) {
                [imgageArray addObject:obj];
            }else if ( [obj isKindOfClass:[NSDictionary class]]){
                NSDictionary *imgDic=(NSDictionary *)obj;
                NSString *UrlStr=[imgDic objectForKey:@"img_down"];
                [imgStrArray addObject:UrlStr];
            }
        }
        NSMutableDictionary *param=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    
                                    LOGIN_USER_ID, @"login_user_id",nil];
        //是否有题目
        if (![_titleTextView.text isEqualToString:@"标题（选填）："]){
            [param setObject:_titleTextView.text forKey:@"img_title"];
        }
        //是否有描述
        NSString *description = _describeTextView.text;
        if (![description isEqualToString:@"描述"]) {
            [param setObject:description forKey:@"img_desc"];
        }
        //是否有图
        if (imgageArray.count) {
            [param setObject:[NSString stringWithFormat:@"%lu",(unsigned long)imgageArray.count] forKey:@"file_count"];
            [param setObject:imgageArray forKey:@"photos"];
        }
        
        if (imgStrArray.count) {
            [param setObject:imgStrArray forKey:@"img_urls"];
        }
        
        //是否建群
        if (groupTextField.text.length>0) {
            NSString *groupText1 = groupTextField.text;
            NSInteger a = 1;
            [param setObject:[NSString stringWithFormat:@"%ld",(long)a] forKey:@"is_group"];
            [param setObject:groupText1 forKey:@"group_name"];
            
        }else{
            NSInteger a = 0;
            [param setObject:[NSString stringWithFormat:@"%ld",(long)a] forKey:@"is_group"];
            
        }
        //群权限
        [param setObject:groupType forKey:@"group_type"];
        //是发布的视频，但是视频的videUrl还没压缩出来,这时候需要进行进一步处理
        if (_isVideo == YES && self.video_url.length <= 0) {
            [param setObject:@"1" forKey:@"is_video"];
            _paramDic = param;
            [self performSelector:@selector(back) withObject:nil afterDelay:1];
            [self appDelegate].postShareInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.shareToWeixin],@"weixin",[NSString stringWithFormat:@"%d",self.shareToWeibo],@"weibo", nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_MAKE_A_POSTING_SUCCEED object:nil];
            

        }else if(_isVideo == YES && self.video_url.length > 0){
            [param setObject:@"1" forKey:@"is_video"];
            [param setObject:self.video_url forKey:@"video_url"];
            [self postDataMakeAShow:param isGroup:NO];
            [self performSelector:@selector(back) withObject:nil afterDelay:1];
            [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_MAKE_A_POSTING_SUCCEED object:nil];
            
        [self appDelegate].postShareInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.shareToWeixin],@"weixin",[NSString stringWithFormat:@"%d",self.shareToWeibo],@"weibo", nil];
        }else if(_isVideo == NO){
            //不是视频的时候
            [param setObject:@"0" forKey:@"is_video"];
            [self postDataMakeAShow:param isGroup:NO];
            [self appDelegate].postShareInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.shareToWeixin],@"weixin",[NSString stringWithFormat:@"%d",self.shareToWeibo],@"weibo", nil];
          

        }
    }else{
        //在群里发帖
        //将图片和url地址分别封装
        NSMutableArray *imgageArray=[[NSMutableArray alloc]init];
        NSMutableArray *imgStrArray=[[NSMutableArray alloc]init];
        for (id obj in self.pickedImagesArray) {
            if ([obj isKindOfClass:[UIImage class]]) {
                [imgageArray addObject:obj];
            }else if ( [obj isKindOfClass:[NSDictionary class]]){
                NSDictionary *imgDic=(NSDictionary *)obj;
                NSString *UrlStr=[imgDic objectForKey:@"img_down"];
                [imgStrArray addObject:UrlStr];
            }
        }
        NSMutableDictionary *param=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                    
                                    LOGIN_USER_ID, @"login_user_id",nil];
        //是否有题目
        if (![_titleTextView.text isEqualToString:@"标题（选填）："]){
            [param setObject:_titleTextView.text forKey:@"img_title"];
        }
        //是否有描述
        NSString *description = _describeTextView.text;
        if (![description isEqualToString:@"描述"]) {
            [param setObject:description forKey:@"img_desc"];
        }
        //是否有图
        if (imgageArray.count) {
            [param setObject:[NSString stringWithFormat:@"%lu",(unsigned long)imgageArray.count] forKey:@"file_count"];
            [param setObject:imgageArray forKey:@"photos"];
        }
        
        if (imgStrArray.count) {
            [param setObject:imgStrArray forKey:@"img_urls"];
        }
        
            [param setObject:[NSString stringWithFormat:@"%ld",(long)self.group_id] forKey:@"group_id"];
        //群权限
        [param setObject:groupType forKey:@"group_type"];
        //是发布的视频，但是视频的videUrl还没压缩出来,这时候需要进行进一步处理
        if (_isVideo == YES && self.video_url.length <= 0) {
            [param setObject:@"1" forKey:@"is_video"];
            _paramDic = param;
            [self performSelector:@selector(back) withObject:nil afterDelay:1];
        [self appDelegate].postShareInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.shareToWeixin],@"weixin",[NSString stringWithFormat:@"%d",self.shareToWeibo],@"weibo", nil];
            theAppDelegate.isUpdateNow = YES;
        }else if(_isVideo == YES && self.video_url.length > 0){
            [param setObject:@"1" forKey:@"is_video"];
            [param setObject:self.video_url forKey:@"video_url"];
            [self postDataMakeAShow:param isGroup:YES];
            [self performSelector:@selector(back) withObject:nil afterDelay:1];
            theAppDelegate.isUpdateNow = YES;

        [self appDelegate].postShareInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.shareToWeixin],@"weixin",[NSString stringWithFormat:@"%d",self.shareToWeibo],@"weibo", nil];
        }else if(_isVideo == NO){
            [param setObject:@"0" forKey:@"is_video"];
            [self postDataMakeAShow:param isGroup:YES];
        [self appDelegate].postShareInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.shareToWeixin],@"weixin",[NSString stringWithFormat:@"%d",self.shareToWeibo],@"weibo", nil];
            
        }

    }
}
#pragma mark 数据上传请求
-(void)postDataMakeAShow:(NSDictionary *)Param isGroup:(BOOL)isGroup{
    UrlMaker *urlMaker;
    if (isGroup == YES) {
        urlMaker =[[UrlMaker alloc]initWithNewV1UrlStr:kPublicGroupListing Method:NetMethodPost andParam:Param];
    }else{
     urlMaker =[[UrlMaker alloc]initWithNewV1UrlStr:kPublicListing Method:NetMethodPost andParam:Param];
    }
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
    for (NSString *key in [Param allKeys]) {
        
        if ([key isEqualToString:@"photos"]) {
            
            NSArray *photoArray=[Param objectForKey:key];
            
            if (photoArray.count==1) {
                
                UIImage *image=[photoArray firstObject];
                NSData *basicImgData=UIImagePNGRepresentation(image);
                
                if (basicImgData.length/1024>300) {
                    
                    CGFloat scale=512/image.size.width;
                    CGSize size=CGSizeMake(512, image.size.height*scale);
                    UIImage *newImage=[image scaleToSize:image size:size];
                    
                    float quality=0.75;
                    NSData *imgData=UIImageJPEGRepresentation(newImage, quality);
                    [request setData:imgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",1]];
                    
                }else{
                    
                    [request setData:basicImgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",1]];
                    
                }
                
            }else{
                
                for (int i=0; i<[photoArray count] ; i++) {
                    
                    UIImage *image=[photoArray objectAtIndex:i];
                    NSData *basicImgData=UIImagePNGRepresentation(image);
                    
                    if (basicImgData.length/1024>200) {
                        
                        CGFloat scale=320/image.size.width;
                        CGSize size=CGSizeMake(320, image.size.height*scale);
                        UIImage *newImage=[image scaleToSize:image size:size];
                        
                        float quality=0.75;
                        NSData *imgData=UIImageJPEGRepresentation(newImage, quality);
                        [request setData:imgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                        
                    }else{
                        
                        [request setData:basicImgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                        
                    }
                    
                }
                
            }
            
        }else if ([key isEqualToString:@"img_urls"]){
            
            NSArray *urlArry=[Param objectForKey:key];
            NSString *urlJsonStr=[urlArry JSONRepresentation];
            [request setPostValue:urlJsonStr forKey:key];
            
        }else if ([key isEqualToString:@"video_url"]){
            NSString *urlString = [Param objectForKey:key];
            NSURL *url = [NSURL URLWithString:urlString];
            NSData *videoData = [NSData dataWithContentsOfURL:url];
            [request setData:videoData withFileName:@"video1.mp4" andContentType:@"video/quicktime" forKey:@"video1"];
        }else{
            
            NSString *value=[Param objectForKey:key];
            [request setPostValue:value forKey:key];
            
        }
        
    }
        [request setDownloadCache:[self appDelegate].myCache];
        [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
        [request setShouldAttemptPersistentConnection:NO];
        [request setTimeOutSeconds:120];
        [request startAsynchronous];
        __weak ASIFormDataRequest *blockRequest=request;
    //发送视频的时候
    if (_isVideo == YES) {
        [request setCompletionBlock:^{
            NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
            [LoadingView stopOnTheViewController:self];
            if ([[dic objectForKey:@"success"] integerValue]==1) {
                if (isGroup == NO) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_MAKE_A_POST_SUCCEED object:nil];
                }else{
                    theAppDelegate.isHaveNewGroupPost = YES;
                    theAppDelegate.isUpdateNow = NO;
                    [[NSNotificationCenter defaultCenter]postNotificationName:USER_POSTBAR_NEW_MAKE_A_GROUPPOST_SUCCEED object:nil];
                }
            }else{
                NSString *errorString=[dic objectForKey:@"reMsg"];
                [BBSAlert showAlertWithContent:errorString andDelegate:self];
                if (isGroup == NO) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_MAKE_A_POST_FAIL object:nil];
                }else{

                    
                }
            }
        }];
        
        
    }else{
        [request setCompletionBlock:^{
            NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
            [LoadingView stopOnTheViewController:self];
            if ([[dic objectForKey:@"success"] integerValue]==1) {
                NSDictionary *dataDict = [dic objectForKey:kBBSData];
                backViewAlert.hidden = NO;
                self.img_id = dataDict[@"img_id"];
                self.make_group_id = dataDict[@"group_id"];
                if (isGroup == NO) {
                    NSLog(@"成功发帖的方法");
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_MAKE_A_POST_SUCCEED object:dataDict];
                }else{
                    theAppDelegate.isHaveNewGroupPost = YES;
                }
            }else{
                NSString *errorString=[dic objectForKey:@"reMsg"];
                [BBSAlert showAlertWithContent:errorString andDelegate:self];
            }
        }];
    }
    [request setFailedBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
        });
        
    }];


    
}
#pragma mark 选择图片
-(void)ChoosePhoto{
    _isPhoto = YES;
    [_titleTextView resignFirstResponder];
    [_describeTextView resignFirstResponder];
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"自由环球租赁" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选",@"从手机相册选",@"拍一张", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}
#pragma mark 选择视频
-(void)chooseVideoAction{
    _isPhoto = NO;
    //小视频
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted
        || authStatus == AVAuthorizationStatusDenied) {
        [BBSAlert showAlertWithContent:@"摄像头已被禁用，您可在设置应用程序中进行开启" andDelegate:self];
        NSLog(@"摄像头已被禁用，您可在设置应用程序中进行开启");
        return;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        //1.创建UIImagePickerController对象
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;
        //2.设置选择来源 相册、照片库、还是相机
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        //3.设置资源类型: 是视频还是图片
        picker.mediaTypes = @[(NSString *)kUTTypeMovie];
        [self presentViewController:picker animated:YES completion:NULL];
    } else {
        NSLog(@"手机不支持摄像");
    }
    
    
}
-(void)ChangeUrl{
    
    [_titleTextView resignFirstResponder];
    [_describeTextView resignFirstResponder];
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"添加链接" message:@"" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"确定", nil];
    alertView.tag=1000;
    alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    UITextField *textField=[alertView textFieldAtIndex:0];
    textField.text=self.urlStr;
    [alertView show];
}

-(void)shareTo:(UIButton *)sender{
    
    [_titleTextView resignFirstResponder];
    [_describeTextView resignFirstResponder];
    
    if (sender.tag == 1) {
        //微信
        if (_shareToWeixin) {
            _shareToWeixin = NO;
            [sender setBackgroundImage:[UIImage imageNamed:@"img_show_weixin_unselected"] forState:UIControlStateNormal];
        } else {
            _shareToWeixin = YES;
            [sender setBackgroundImage:[UIImage imageNamed:@"img_show_weixin_selected"] forState:UIControlStateNormal];
        }
    } else {
        //微博
        if (_shareToWeibo) {
            _shareToWeibo = NO;
            [sender setBackgroundImage:[UIImage imageNamed:@"img_show_weibo_unselected"] forState:UIControlStateNormal];
        } else {
            if ([ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo]) {
                _shareToWeibo = YES;
                [sender setBackgroundImage:[UIImage imageNamed:@"img_show_weibo_selected"] forState:UIControlStateNormal];
            } else {
                //授权
                [ShareSDK getUserInfo:SSDKPlatformTypeSinaWeibo onStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                    if (state == SSDKResponseStateSuccess) {
                        _shareToWeibo = YES;
                        [sender setBackgroundImage:[UIImage imageNamed:@"img_show_weibo_selected"] forState:UIControlStateNormal];
                        NSString *user_id = LOGIN_USER_ID;
                        NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:user.uid,kCheckWeiboUid,user_id,kCheckWeiboUser_id,@"1",kCheckWeiboUser_type, nil];
                        [[HTTPClient sharedClient] postNew:kCheckWeibo params:param success:^(NSDictionary *result) {
                            
                        } failed:^(NSError *error) {
                            
                        }];
                    }
                    
                    
                }];
            }
        }
    }
}

-(void)removeImageViews{
    
    for (id obj in _photoView.subviews) {
        if ([obj isKindOfClass:[UIImageView class]]) {
            [obj removeFromSuperview];
        }
    }
    
}

-(void)showImagesWithPhotosArray:(NSArray *) photosArray{
   
    for (id obj in photosArray) {
        NSInteger i = [photosArray indexOfObject:obj];
        CGRect imageviewFrame;
        if (i<3) {
            imageviewFrame=CGRectMake(10+(i+2)*(imageWidth+10), 10, imageWidth, imageWidth);
            
        }else if (i<7){
            
            imageviewFrame=CGRectMake(10+(i-2)*(imageWidth+10), imageWidth+20, imageWidth, imageWidth);
            
        }
        UIImageView *photoView = [[UIImageView alloc]initWithFrame:imageviewFrame];
        if ([obj isKindOfClass:[UIImage class]]) {
            photoView.image = (UIImage *)obj;
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            NSDictionary *imgDic = (NSDictionary *)obj;
            NSString *thumbUrlStr=[imgDic objectForKey:@"img_thumb"];
            [photoView sd_setImageWithURL:[NSURL URLWithString:thumbUrlStr]];
        }
        _isVideo = NO;
        [_imgView addSubview:photoView];
        _imgView.frame =  CGRectMake(0, 0, SCREENWIDTH, imageviewFrame.origin.y+imageviewFrame.size.height+10);
        if (_isHiddenGroup == YES) {
        _photoBackView.frame = CGRectMake(0, _textBackView.frame.size.height,SCREENWIDTH, imageviewFrame.origin.y+imageviewFrame.size.height+10);
        }else{
        _photoBackView.frame = CGRectMake(0, _textBackView.frame.size.height+40,SCREENWIDTH, imageviewFrame.origin.y+imageviewFrame.size.height+10);
        }
        _videoView.hidden = YES;
        _groupView.hidden = YES;
        self.imgTextAddBtn.frame = CGRectMake(self.addImgBtn.frame.origin.x+imageWidth+10, 10, imageWidth, imageWidth);
        [self.imgTextAddBtn setBackgroundImage:[UIImage imageNamed:@"btn_add_img_makeshow"] forState:UIControlStateNormal];
        [self.imgTextAddBtn setTitle:nil forState:UIControlStateNormal];

        _shareBtnBackView.frame = CGRectMake(0, _photoBackView.frame.origin.y+_photoBackView.frame.size.height, SCREENWIDTH, 40+25);
    }
    
}
#pragma mark 选择视频之后上传的图片
-(void)chooseVideoPhoto:(NSArray *) photosArray{
    self.videoImgBackView.image = photosArray[0];
    self.videoImgBackView.hidden = NO;
    
}
-(void)makeParamVideo{
    
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

#pragma mark - 分享到第三方
- (AppDelegate *)appDelegate {
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
#pragma mark - UITextViewDelegate

-(void)textViewDidBeginEditing:(UITextView *)textView{
    
    if (textView==_titleTextView) {
        
        if ([textView.text isEqualToString:@"标题（选填）："]) {
            textView.text=@"";
        }
        
    }else if (textView==_describeTextView){
        
        if ([textView.text isEqualToString:@"描述"]) {
            textView.text=@"";
        }
        
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView==_titleTextView) {
        
        if (textView.text.length==0) {
            textView.text=@"标题（选填）：";
        }
        
    }else if (textView==_describeTextView){
        
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
    if (textView==_titleTextView) {
        
        if (textView.text.length>=30) {
            [BBSAlert showAlertWithContent:@"标题最多30字哟！" andDelegate:self];
            textView.text=[textView.text substringToIndex:30];
        }
    }else if (textView==_describeTextView){
//        if (textView.text.length>=500) {
//            [BBSAlert showAlertWithContent:@"描述最多500字哟！" andDelegate:self];
//            textView.text=[textView.text substringToIndex:500];
//        }
        
    }
}
#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc]init];
    
    UIColor *color=[UIColor whiteColor];
    NSDictionary *dic=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    imagePicker.navigationBar.titleTextAttributes=dic;
    
    
    if (buttonIndex==1) {
        //从手机相册
        _isPhoto = YES;//是从相册里选
        if (self.pickedImagesArray.count<6) {
            
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            elcPicker.maximumImagesCount = 6-self.pickedImagesArray.count;
            elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
            elcPicker.imagePickerDelegate = self;
            
            [self presentViewController:elcPicker animated:YES completion:nil];
            
        }else{
            
            NSString *alertStr=[NSString stringWithFormat:@"每次只能上传%d张照片哦",6];
            [BBSAlert showAlertWithContent:alertStr andDelegate:self];
            
        }
        
        
    }else if (buttonIndex==2){
        //拍摄
        _isPhoto = YES;//是从相册里选

        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
            
            if (self.pickedImagesArray.count<6) {
                
                [self.pickedImagesArray removeAllObjects];
                
                imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate=self;
                imagePicker.allowsEditing=NO;
                imagePicker.videoQuality=UIImagePickerControllerQualityType640x480;
                [self.navigationController presentViewController:imagePicker animated:YES completion:^{}];
                
            }else{
                
                NSString *alertStr=[NSString stringWithFormat:@"每次只能上传%d张照片哦",6];
                [BBSAlert showAlertWithContent:alertStr andDelegate:self];
                
            }
            
            
        }else{
            
            [BBSAlert showAlertWithContent:@"相机设备不可用，请到手机 设置->隐私->相机选项卡 打开自由环球租赁的开关" andDelegate:self];
            
        }
    }
    else if (buttonIndex==0){
        //从应用相册
        _isPhoto = YES;//是从相册里选
        UserInfoManager *manager=[[UserInfoManager alloc]init];
        UserInfoItem *userItem=[manager currentUserInfo];
        if (userItem.userId && [userItem.isVisitor intValue]==1 ){
            //游客没有相册
            [BBSAlert showAlertWithContent:@"您是游客，请登录/注册" andDelegate:nil];
            return;
        }
        
        AlbumListViewController *albumListVC = [[AlbumListViewController alloc] init];
        NSUInteger currentCount = self.pickedImagesArray.count;
        NSDictionary *movingDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"isChoosing",[NSNumber numberWithUnsignedInteger:currentCount],@"currentCount", nil];
        albumListVC.title = @"选择";
        albumListVC.movingInfo = movingDict;
        albumListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:albumListVC animated:YES];
        
   }
 //       else if (buttonIndex ==3){
//        _isPhoto = NO;
//        //小视频
//        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
//        if (authStatus == AVAuthorizationStatusRestricted
//            || authStatus == AVAuthorizationStatusDenied) {
//            NSLog(@"摄像头已被禁用，您可在设置应用程序中进行开启");
//            return;
//        }
//        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
//            //1.创建UIImagePickerController对象
//            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//            picker.delegate = self;
//            picker.allowsEditing = YES;
//            //2.设置选择来源 相册、照片库、还是相机
//            picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//            //3.设置资源类型: 是视频还是图片
//            picker.mediaTypes = @[(NSString *)kUTTypeMovie];
//            [self presentViewController:picker animated:YES completion:NULL];
//        } else {
//            NSLog(@"手机不支持摄像");
//        }
//
//        
//    }
        else {
        
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        
    }
    
}

#pragma mark ELCImagePickerControllerDelegate

-(void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    for (NSDictionary *dict in info) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        [self.pickedImagesArray addObject:image];
        
    }
    
    [self removeImageViews];
    [self showImagesWithPhotosArray:self.pickedImagesArray];
    
}

-(void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark notification keyboard
//键盘变化的监听方法
-(void)keyboardWillShow:(NSNotification *) note{
    
    NSDictionary *userInfoDic=[note userInfo];
    NSValue *framenValue=[userInfoDic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame=[framenValue CGRectValue];
    //判断是否是第一响应者
    if ([groupTextField isFirstResponder]) {
        textViewGroup.frame=CGRectMake(0, SCREENHEIGHT-frame.size.height-40, SCREENWIDTH, frame.size.height+40);
    }
}

-(void)keyboardWillDisapper:(NSNotification *) note{
    
    // textView.frame=CGRectMake(0, SCREENHEIGHT-40, SCREENWIDTH, 40);
    textViewGroup.frame = CGRectMake(5, SCREENHEIGHT-35, SCREENWIDTH, 35);
    
}

#pragma mark UIImagePickerViewDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
     [picker dismissViewControllerAnimated:YES completion:^{}];
    if (_isPhoto == YES) {
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp)
        {
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        }
        
        [self.pickedImagesArray addObject:image];
        [self showImagesWithPhotosArray:self.pickedImagesArray];

    }else{
        //在代理方法中拿到视频的URl
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        if ([self fileSize:videoURL]>100) {
            NSLog(@"开始压缩,压缩前大小 %f MB",[self fileSize:videoURL]);

            [BBSAlert showAlertWithContent:@"视频超过100M不能上传哦！换一个吧" andDelegate:self];
        }else{
        //7.创建AVAsset对象
        AVAsset *asset = [AVAsset assetWithURL:videoURL];
        
        //8.创建AVAssetExportSession对象 AVAssetExportPresetMediumQuality 压缩的质量    AVAssetExportSession
        AVAssetExportSession* session = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
        //9.拼接输出文件路径 为了防止同名 可以根据日期拼接名字 或者对名字进行MD5加密
        NSString* path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"hello.mp4"];
        //10.判断文件是否存在，如果已经存在删除
        [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
        //11.设置输出路径
        session.outputURL = [NSURL fileURLWithPath:path];
        //12.设置输出类型
        //     session.outputFileType = @"public.mpeg-4";
        session.outputFileType = AVFileTypeMPEG4;
        __weak PostBarNewMakeAPost *videoVC = self;
        self.imgView.hidden = YES;
            _groupView.hidden = YES;
        [self.videoTextAddBtn setBackgroundImage:[UIImage imageNamed:@"btn_add_img_makeshow"] forState:UIControlStateNormal];
        [self.videoTextAddBtn setTitle:nil forState:UIControlStateNormal];
            
        self.videoView.frame =  CGRectMake(0, 0, SCREENWIDTH, imageWidth+20);
            if (_isHiddenGroup == YES) {
                _photoBackView.frame = CGRectMake(0, _textBackView.frame.size.height, SCREENWIDTH, 85);
            }else{
                _photoBackView.frame = CGRectMake(0, _textBackView.frame.size.height+40, SCREENWIDTH, 85);

            }
        _isVideo = YES;
        _shareBtnBackView.frame = CGRectMake(0, _photoBackView.frame.origin.y+_photoBackView.frame.size.height, SCREENWIDTH, 40+25);
            _shareBtnBackView.hidden = NO;
            //可以建群的发帖页面

        [self centerFrameImageWithVideoURL:videoURL completion:^(UIImage *image) {
            
            videoVC.imgUrl = image;
            [self.pickedImagesArray removeAllObjects];
            [self.pickedImagesArray addObject:image];
            [self chooseVideoPhoto:self.pickedImagesArray];
        }];

        [session exportAsynchronouslyWithCompletionHandler:^{
            if (session.status == AVAssetExportSessionStatusCompleted) {
                self.video_url = [NSString stringWithFormat:@"%@",session.outputURL];
                if (_paramDic) {
                    NSLog(@"_paramdic = %@",_paramDic);
                    [_paramDic setValue:self.video_url forKey:@"video_url"];
                    if (!self.group_id) {
                        //如果没有群id
                        [self postDataMakeAShow:_paramDic isGroup:NO];
                    }else{
                        [self postDataMakeAShow:_paramDic isGroup:YES];
                    }
                }
                NSLog(@"压缩完毕,压缩后大小 %f MB",[self fileSize:[self compressedURL]]);
            }else{
                [BBSAlert showAlertWithContent:[NSString stringWithFormat:@"%@",[session error]] andDelegate:self];
                NSLog(@"压缩失败，原因：%@",[session error]);
            }
        }];
        }
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

// 异步获取帧图片，可以一次获取多帧图片
- (void)centerFrameImageWithVideoURL:(NSURL *)videoURL completion:(void (^)(UIImage *image))completion {
    // AVAssetImageGenerator
    AVAsset *asset = [AVAsset assetWithURL:videoURL];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    
    // calculate the midpoint time of video
    Float64 duration = CMTimeGetSeconds([asset duration]);
    // 取某个帧的时间，参数一表示哪个时间（秒），参数二表示每秒多少帧
    // 通常来说，600是一个常用的公共参数，苹果有说明:
    // 24 frames per second (fps) for film, 30 fps for NTSC (used for TV in North America and
    // Japan), and 25 fps for PAL (used for TV in Europe).
    // Using a timescale of 600, you can exactly represent any number of frames in these systems
    CMTime midpoint = CMTimeMakeWithSeconds(1, 600);
    
    // 异步获取多帧图片
    NSValue *midTime = [NSValue valueWithCMTime:midpoint];
    [imageGenerator generateCGImagesAsynchronouslyForTimes:@[midTime] completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
        if (result == AVAssetImageGeneratorSucceeded && image != NULL) {
            UIImage *centerFrameImage = [[UIImage alloc] initWithCGImage:image];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(centerFrameImage);
                }
            });
            
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(nil);
                }
            });
        }
    }];
}
#pragma mark 保存压缩
- (NSURL *)compressedURL
{
    return [NSURL fileURLWithPath:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject] stringByAppendingPathComponent:[NSString stringWithFormat:@"hello.mp4"]]];
}

- (CGFloat)fileSize:(NSURL *)path
{
    return [[NSData dataWithContentsOfURL:path] length]/1024.00 /1024.00;
}


#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==1000) {
        if (buttonIndex==1) {
            //确定
            
            UITextField *textField=[alertView textFieldAtIndex:0];
            self.urlStr=textField.text;
            
            if (textField.text.length) {
                [_addUrlBtn setBackgroundImage:[UIImage imageNamed:@"btn_make_a_post_change_url"] forState:UIControlStateNormal];
            }else{
                
                [_addUrlBtn setBackgroundImage:[UIImage imageNamed:@"btn_make_a_post_addurl"] forState:UIControlStateNormal];
                
            }
            
        }else if (buttonIndex==0){
            //取消
            
            UITextField *textField=[alertView textFieldAtIndex:0];
            self.urlStr=textField.text=@"";
            [_addUrlBtn setBackgroundImage:[UIImage imageNamed:@"btn_make_a_post_addurl"] forState:UIControlStateNormal];
            
        }
        
    }
    
}
#pragma mark ALRadialMenuDelegate

-(NSInteger)numberOfItemsInRadialMenu:(ALRadialMenu *)radialMenu{
    return 2;
}

-(NSInteger)arcRadiusForRadialMenu:(ALRadialMenu *)radialMenu{
    
    return 40;
    
}

-(NSInteger)arcSizeForRadialMenu:(ALRadialMenu *)radialMenu{
    
    return 0;
    
}

-(float)buttonSizeForRadialMenu:(ALRadialMenu *)radialMenu{
    
    return 40;
}

-(UIImage *)radialMenu:(ALRadialMenu *)radialMenu imageForIndex:(NSInteger)index{
    // UIImage *_shareImg=[UIImage imageNamed:@"btn_make_a_show_share"];
    UIImage *_focusImg=[UIImage imageNamed:@"btn_make_a_show_focus"];
    UIImage *_publicImg=[UIImage imageNamed:@"btn_make_a_show_public"];
    
    if (index==1){
        return _focusImg;
    }else if (index==2){
        return _publicImg;
    }
    return nil;
    
}
-(void)radialMenu:(ALRadialMenu *)radialMenu didSelectItemAtIndex:(NSInteger)index{
    //    图片权限 0关注的人 1互相关注的人 2共享相册的人
    CGRect frame=SENDFRAME;
    
    [LoadingView startOnTheViewController:self];
    [_menu buttonsWillAnimateFromButton:_sendBtn withFrame:frame inView:self.view];
    [_titleTextView resignFirstResponder];
    [_describeTextView resignFirstResponder];
    _sendBtn.enabled=NO;
    //0gognkai
    if (index == 1) {
        [self sendData:@"1"];
    }else{
        [self sendData:@"0"];
    }
    
}


@end
