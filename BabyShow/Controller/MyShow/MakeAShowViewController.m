//
//  MakeAShowViewController.m
//  BabyShow
//
//  Created by Lau on 13-12-13.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MakeAShowViewController.h"
#import "AlbumListViewController.h"
#import "SDWebImageManager.h"

#import <ShareSDK/ShareSDK.h>
#import "LoveBabyShowVC.h"
#import <AVFoundation/AVAsset.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVAssetImageGenerator.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreMedia/CoreMedia.h>
#import "Reachability.h"


@interface MakeAShowViewController ()

//是否分享到微博微信
@property (nonatomic ,assign)BOOL shareToWeixin;
@property (nonatomic ,assign)BOOL shareToWeibo;
//输入框的提示文字
@property (nonatomic ,retain)UILabel *tintLabel;
//添加秀秀文字
@property(nonatomic,strong)UIView *textView;
//添加图片和视频的view底
@property(nonatomic,strong)UIView *backView;

//添加图片view
@property(nonatomic,strong)UIView *imgView;
@property(nonatomic,strong)UIButton *addImgBtn;
@property(nonatomic,strong)UIButton *imgTextAddBtn;

//添加视频的view
@property(nonatomic,strong)UIView *videoView;
@property(nonatomic,strong)UIButton *addVideoBtn;
@property(nonatomic,strong)UIButton *videoTextAddBtn;
@property(nonatomic,strong)UIImageView *videoImgBackView;//选择完视频之后的图片

//我想建个群
@property(nonatomic,strong)UIView *groupView;
@property(nonatomic,strong)UIButton *addGroupBtn;
@property(nonatomic,strong)UIButton *videoGroupAddBtn;
//@property(nonatomic,strong)UIImageView *videoImgBackView;//选择完视频之后的图片

//分享微信或分享微博
@property(nonatomic,strong)UIButton *shareToWeixinButton;
@property(nonatomic,strong)UIButton *shareToWeiboButton;
//是否选择的相册
@property(nonatomic,assign)BOOL isPhoto;
@property(nonatomic,strong)UIImage *imgUrl;
@property(nonatomic,assign)BOOL isVideo;//是否是视频
@property(nonatomic,strong)NSMutableDictionary *paramDic;

@end

static float seperateSpace = 10.0;
static float imageWidth;
static float imageViewy    = 160.0;



#define SENDFRAME CGRectMake(280, 84, 20, 20);

@implementation MakeAShowViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.photo=[[UIImage alloc]init];
        
        _imageViewArray=[[NSMutableArray alloc]init];
        _pickedImagesArray=[[NSMutableArray alloc]init];
        NSLog(@"imgigmimgimii = %@",self.imageArray);
        
        self.navigationItem.title=@"秀一下";
        
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [UIApplication sharedApplication].statusBarStyle=UIStatusBarStyleLightContent;
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton=YES;
    if (self.imageArray ) {
        
    }else{
        self.imageArray=[[NSMutableArray alloc]init];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _shareToWeixin = YES;
    _shareToWeibo = NO;
    
    _clearView=[[UIView alloc]initWithFrame:self.view.frame];
    _clearView.backgroundColor=[UIColor clearColor];
    
    self.view.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, VIEWWIDTH, VIEWHEIGHT)];
    _scrollView.contentSize=CGSizeMake(VIEWWIDTH, VIEWHEIGHT);
    _scrollView.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    _scrollView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_tableview_background.png" ]];
    [self.view addSubview:_scrollView];
    
    _menu=[[ALRadialMenu alloc]init];
    _menu.delegate=self;
    
    CGRect tintFrame = CGRectMake(seperateSpace+4, 14, SCREENWIDTH-seperateSpace*2, 20);
    CGRect photoFrame=CGRectMake(seperateSpace, imageViewy+20, imageWidth, imageWidth);
    
    //文字
    self.textView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 130)];
    self.textView.backgroundColor =[UIColor whiteColor];
    [_scrollView addSubview:self.textView];
    
    _describeField=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 130)];
    _describeField.font=[UIFont systemFontOfSize:14];
    _describeField.layer.cornerRadius = 5.0;
    _describeField.delegate=self;
    [self.textView addSubview:_describeField];
    
    _tintLabel = [[UILabel alloc]initWithFrame:tintFrame];
    _tintLabel.hidden = NO;
    _tintLabel.font = [UIFont systemFontOfSize:14];
    _tintLabel.backgroundColor = [UIColor clearColor];
    _tintLabel.text = @"说点什么...";
    _tintLabel.textColor = [UIColor lightGrayColor];
    [self.textView addSubview:_tintLabel];
    
    imageWidth = (SCREENWIDTH-60)/5;
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, self.textView.frame.origin.y+self.textView.frame.size.height, SCREENWIDTH, 100+imageWidth)];
    [_scrollView addSubview:self.backView];
    
    
    //添加图片
    self.imgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, imageWidth+20)];
    self.imgView.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:self.imgView];
    
    //添加图片的按钮
    self.addImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addImgBtn.frame = CGRectMake(10, 10, imageWidth, imageWidth);
    [self.addImgBtn setImage:[UIImage imageNamed:@"make_img_select"] forState:UIControlStateNormal];
    self.addImgBtn.adjustsImageWhenDisabled = NO;
    [self.addImgBtn addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
    [self.imgView addSubview:self.addImgBtn];
    
    self.imgTextAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imgTextAddBtn.frame = CGRectMake(self.addImgBtn.frame.origin.x+imageWidth+10, 13, imageWidth+8, imageWidth);
    [self.imgTextAddBtn setTitle:@"添加图片" forState:UIControlStateNormal];
    self.imgTextAddBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.imgTextAddBtn setTitleColor:[BBSColor hexStringToColor:@"999999"] forState:UIControlStateNormal];
    [self.imgTextAddBtn addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
    [self.imgView addSubview:self.imgTextAddBtn];
    
    
    //添加视频
    self.videoView = [[UIView alloc]initWithFrame:CGRectMake(0, self.imgView.frame.origin.y+self.imgView.frame.size.height, SCREENWIDTH, imageWidth+20)];
    self.videoView.backgroundColor = [UIColor whiteColor];
    [self.backView addSubview:self.videoView];
    //添加视频按钮
    self.addVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.addVideoBtn.frame = CGRectMake(10, 10,imageWidth, imageWidth);
    [self.addVideoBtn setImage:[UIImage imageNamed:@"make_video_select"] forState:UIControlStateNormal];
    [self.addVideoBtn addTarget:self action:@selector(chooseVideoAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.addVideoBtn.adjustsImageWhenDisabled = NO;
    [self.videoView addSubview:self.addVideoBtn];
    
    self.videoTextAddBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.videoTextAddBtn.frame = CGRectMake(self.addVideoBtn.frame.origin.x+imageWidth+10, 13, imageWidth+8,imageWidth);
    [self.videoTextAddBtn setTitle:@"添加视频" forState:UIControlStateNormal];
    [self.videoTextAddBtn addTarget:self action:@selector(chooseVideoAction) forControlEvents:UIControlEventTouchUpInside];
    self.videoTextAddBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.videoTextAddBtn setTitleColor:[BBSColor hexStringToColor:@"999999"] forState:UIControlStateNormal];
    [self.videoView addSubview:self.videoTextAddBtn];
    
    self.videoImgBackView = [[UIImageView alloc]initWithFrame:CGRectMake(6+2*(imageWidth+seperateSpace), 13, imageWidth, imageWidth)];
    [self.videoView addSubview:self.videoImgBackView];
    
    self.videoImgBackView.hidden = YES;
    //视频图片上的小按钮
    UIImageView *imgPlay = [[UIImageView alloc]initWithFrame:CGRectMake(13, 13, 25, 25)];
    imgPlay.image = [UIImage imageNamed:@"play_btn_make_show"];
    [self.videoImgBackView addSubview:imgPlay];
    
    //我想建群
    self.groupView = [[UIView alloc]initWithFrame:CGRectMake(0, self.videoView.frame.origin.y+self.videoView.frame.size.height, SCREENWIDTH, 20)];
    [self.backView addSubview:self.groupView];
    
    
    self.shareToWeixinButton =[ UIButton buttonWithType:UIButtonTypeCustom];
    _shareToWeixinButton.frame = CGRectMake(10, self.backView.frame.origin.y+self.backView.frame.size.height+10,(SCREENWIDTH-30)/2, 34);
    [_shareToWeixinButton setBackgroundImage:[UIImage imageNamed:@"img_show_weixin_selected"] forState:UIControlStateNormal];
    [_shareToWeixinButton addTarget:self action:@selector(shareToThird:) forControlEvents:UIControlEventTouchUpInside];
    _shareToWeixinButton.tag = 1;
    [_scrollView addSubview:_shareToWeixinButton];
    
    UIImage *weiboImage = [UIImage imageNamed:@"img_show_weibo_unselected"];
    if ([ShareSDK hasAuthorized:SSDKPlatformTypeSinaWeibo]) {
        _shareToWeibo = YES;
        weiboImage = [UIImage imageNamed:@"img_show_weibo_selected"];
    }
    _shareToWeiboButton =[ UIButton buttonWithType:UIButtonTypeCustom];
    _shareToWeiboButton.frame = CGRectMake(20+(SCREENWIDTH-30)/2, self.backView.frame.origin.y+self.backView.frame.size.height+10,(SCREENWIDTH-30)/2, 34);
    [_shareToWeiboButton setBackgroundImage:weiboImage forState:UIControlStateNormal];
    [_shareToWeiboButton addTarget:self action:@selector(shareToThird:) forControlEvents:UIControlEventTouchUpInside];
    _shareToWeiboButton.tag = 2;
    [_scrollView addSubview:_shareToWeiboButton];
    
    //加号+
    _photoView=[[UIImageView alloc]initWithFrame:photoFrame];
    _photoView.image=_addPhotoImg;
    
    NSData *imgData=UIImagePNGRepresentation(self.photo);
    
    if (imgData.length) {
        _photoView.image=self.photo;
    }
    //[_scrollView addSubview:_photoView];
    
    UIButton *imageBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    imageBtn.frame=photoFrame;
    [imageBtn addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
    //[_scrollView addSubview:imageBtn];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchOnTheView)];
    [_scrollView addGestureRecognizer:tap];
    
    [self setSendButton];
    [self setBackButton];
    
    if (self.Type==1) {
        //相册秀一下，下载相片
        [LoadingView startOnTheViewController:self];
        _sendBtn.enabled=NO;
        [_pickedImagesArray addObjectsFromArray:self.imageArray];
        [self makeImageViewWithPickedImagesArray:self.imageArray];
    }
    
}

-(void)setBackButton{
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}

-(void)setSendButton{
    
    CGRect sendBtnFrame=CGRectMake(0, 0, 24, 24);
    
    _sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _sendBtn.frame=sendBtnFrame;
    
    UIImage *sendImg=[UIImage imageNamed:@"btn_makeashow_send_square.png"];
    [_sendBtn setImage:sendImg forState:UIControlStateNormal];
    [_sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:_sendBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    _photoView.image=_addPhotoImg;
    
    [_pickedImagesArray removeAllObjects];
    
    for (UIImageView *imageview in _imageViewArray) {
        [imageview removeFromSuperview];
    }
    
    [_imageViewArray removeAllObjects];
    
    if (_menu.itemIndex) {
        
        CGRect frame=SENDFRAME;
        [_menu buttonsWillAnimateFromButton:_sendBtn withFrame:frame inView:self.view];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
#pragma mark NSNotification


-(void)netFail{
    
    [LoadingView stopOnTheViewController:self];
    [BBSAlert showAlertWithContent:@"您的网络不给力，换一个吧！" andDelegate:self];
    
}

#pragma mark ButtonAction
- (void)shareToThird:(UIButton *)sender {
    
    [_describeField resignFirstResponder];
    
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

-(void)changeImage{
    _isPhoto = YES;
    [self.imageArray removeAllObjects];
    [self.imageArray addObjectsFromArray:_pickedImagesArray];
    [_describeField resignFirstResponder];
    
    UIActionSheet *acs=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从我的相册",@"从手机相册",@"拍摄一张", nil];
    [acs showInView:[UIApplication sharedApplication].keyWindow];
    
}

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
-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)send{
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NSParameterAssert([reach isKindOfClass:[Reachability class]]);
    NetworkStatus stats = [reach currentReachabilityStatus];
    if (stats == NotReachable) {
        [BBSAlert showAlertWithContent:@"您似乎与网络断开，检查一下网络再发送吧" andDelegate:self];
    }else{
        
        [_describeField resignFirstResponder];
        
        if (_menu.itemIndex) {
            
            CGRect frame=SENDFRAME;
            [_menu buttonsWillAnimateFromButton:_sendBtn withFrame:frame inView:self.view];
            
        }else{
            
            CGRect frame=SENDFRAME;
            [_menu buttonsWillAnimateFromButton:_sendBtn withFrame:frame inView:self.view];
            
        }
    }
    
}

-(void)touchOnTheView{
    
    [_describeField resignFirstResponder];
    
}

-(AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

#pragma mark UITextViewDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        _tintLabel.hidden = YES;
    } else {
        _tintLabel.hidden = NO;
    }
}
#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    imagePicker=[[UIImagePickerController alloc]init];
    
    UIColor *color=[UIColor whiteColor];
    NSDictionary *dic=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    imagePicker.navigationBar.titleTextAttributes=dic;
    
    
    if (buttonIndex==1) {
        //从手机相册
        if (_pickedImagesArray.count<maxNumberOfImages) {
            
            self.content=_describeField.text;
            
            for (UIImageView *imageview in _imageViewArray) {
                [imageview removeFromSuperview];
            }
            
            [_imageViewArray removeAllObjects];
            
            
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            elcPicker.maximumImagesCount = maxNumberOfImages-_pickedImagesArray.count;
            elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
            elcPicker.imagePickerDelegate = self;
            
            [self presentViewController:elcPicker animated:YES completion:nil];
            
        }else{
            
            NSString *alertStr=[NSString stringWithFormat:@"每次只能上传%d张照片哦",maxNumberOfImages];
            [BBSAlert showAlertWithContent:alertStr andDelegate:self];
            
        }
        
        
    }else if (buttonIndex==2){
        //拍摄
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
            
            if (_pickedImagesArray.count<maxNumberOfImages) {
                
                [_pickedImagesArray removeAllObjects];
                
                for (UIImageView *imageview in _imageViewArray) {
                    [imageview removeFromSuperview];
                }
                
                [_imageViewArray removeAllObjects];
                self.content=_describeField.text;
                self.photo=_photoView.image;
                
                imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;
                imagePicker.delegate=self;
                imagePicker.allowsEditing=NO;
                imagePicker.videoQuality=UIImagePickerControllerQualityType640x480;
                [self.navigationController presentViewController:imagePicker animated:YES completion:^{}];
                
            }else{
                
                NSString *alertStr=[NSString stringWithFormat:@"每次只能上传%d张照片哦",maxNumberOfImages];
                [BBSAlert showAlertWithContent:alertStr andDelegate:self];
                
            }
            
            
        }else{
            
            [BBSAlert showAlertWithContent:@"相机设备不可用，请到手机 设置->隐私->相机选项卡 打开自由环球租赁的开关" andDelegate:self];
            
        }
    }
    else if (buttonIndex==0){
        //从应用相册
        self.content=_describeField.text;
        
        AlbumListViewController *albumListVC = [[AlbumListViewController alloc] init];
        NSUInteger currentCount = _pickedImagesArray.count;
        NSDictionary *movingDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"isChoosing",[NSNumber numberWithUnsignedInteger:currentCount],@"currentCount", nil];
        albumListVC.title = @"选择";
        albumListVC.movingInfo = movingDict;
        albumListVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:albumListVC animated:YES];
        
    } else {
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        //        self.tabBarController.selectedIndex=0;
        
    }
}

#pragma mark UIImagePickerViewDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    NSLog(@"info = %@",info);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    if (_isPhoto == YES) {
        UIImageOrientation imageOrientation=image.imageOrientation;
        if(imageOrientation!=UIImageOrientationUp)
        {
            // 原始图片可以根据照相时的角度来显示，但UIImage无法判定，于是出现获取的图片会向左转９０度的现象。
            // 以下为调整图片角度的部分
            UIGraphicsBeginImageContext(image.size);
            [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
            image = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            // 调整图片角度完毕
        }
        self.photo=image;
        _describeField.text=self.content;
        [_pickedImagesArray removeAllObjects];
        [_pickedImagesArray addObjectsFromArray:self.imageArray];
        [_pickedImagesArray addObject:image];
        [self makeImageViewWithPickedImagesArray:_pickedImagesArray];
    }else{
        //在代理方法中拿到视频的URl
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        if ([self fileSize:videoURL] > 100) {
            [BBSAlert showAlertWithContent:@"视频超过100M不能上传哦！换一个吧" andDelegate:self];
        }else{
            NSLog(@"开始压缩,压缩前大小 %f MB",[self fileSize:videoURL]);
            //7.创建AVAsset对象
            AVAsset *asset = [AVAsset assetWithURL:videoURL];
            //8.创建AVAssetExportSession对象 AVAssetExportPresetMediumQuality 压缩的质量    AVAssetExportSession
            AVAssetExportSession* session = [[AVAssetExportSession alloc]
                                             initWithAsset:asset presetName:AVAssetExportPresetMediumQuality];
            //9.拼接输出文件路径 为了防止同名 可以根据日期拼接名字 或者对名字进行MD5加密
            NSString* path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"hello.mp4"];
            //10.判断文件是否存在，如果已经存在删除
            [[NSFileManager defaultManager]removeItemAtPath:path error:nil];
            //11.设置输出路径
            session.outputURL = [NSURL fileURLWithPath:path];
            //12.设置输出类型
            session.outputFileType = AVFileTypeQuickTimeMovie;
            __weak MakeAShowViewController *videoVC = self;
            //压缩前的视图变化
            self.imgView.hidden = YES;
            [self.videoTextAddBtn setBackgroundImage:[UIImage imageNamed:@"btn_add_img_makeshow"] forState:UIControlStateNormal];
            [self.videoTextAddBtn setTitle:nil forState:UIControlStateNormal];
            self.backView.frame = CGRectMake(0,self.textView.frame.origin.y+self.textView.frame.size.height, SCREENWIDTH, 85);
            _shareToWeixinButton.frame = CGRectMake(10, self.backView.frame.origin.y+self.backView.frame.size.height+10,(SCREENWIDTH-30)/2, 34);
            _shareToWeiboButton.frame =  CGRectMake(20+(SCREENWIDTH-30)/2, self.backView.frame.origin.y+self.backView.frame.size.height+10,(SCREENWIDTH-30)/2, 34);
            _shareToWeiboButton.hidden = NO;
            _shareToWeixinButton.hidden = NO;
            self.videoView.frame =  CGRectMake(0, 0, SCREENWIDTH, imageWidth+20);
            
            [self centerFrameImageWithVideoURL:videoURL completion:^(UIImage *image) {
                videoVC.imgUrl = image;
                [self.pickedImagesArray addObject:image];
                [self showImagesWithPhotosArray:self.pickedImagesArray];
            }];
            
            [session exportAsynchronouslyWithCompletionHandler:^{
                if (session.status == AVAssetExportSessionStatusCompleted) {
                    self.videoUrl = [NSString stringWithFormat:@"%@",session.outputURL];
                    if (_paramDic && self.videoUrl.length>0) {
                        [_paramDic setValue:self.videoUrl forKey:@"video_url"];
                        [[NetAccess sharedNetAccess] getDataWithStyle:NetStyleMakeAShowNew andParam:_paramDic];
                    }
                    NSLog(@"压缩完毕,压缩后大小 %f MB，%@",[self fileSize:[self compressedURL]],_paramDic);
                    
                }else{
                    [LoadingView stopOnTheViewController:self];
                    [BBSAlert showAlertWithContent:[NSString stringWithFormat:@"%@",[session error]] andDelegate:self];
                }
            }];
            
            
        }
    }
    
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
    CMTime midpoint = CMTimeMakeWithSeconds(0, 600);
    
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


-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    _describeField.text=self.content;
    [_pickedImagesArray addObjectsFromArray:self.imageArray];
    
    [self makeImageViewWithPickedImagesArray:_pickedImagesArray];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark 视频选取之后的图片
-(void)showImagesWithPhotosArray:(NSArray *) photosArray{
    _isVideo = YES;
    self.videoImgBackView.hidden = NO;
    self.videoImgBackView.image = photosArray[0];
    
}
-(UIImage*)imageWithImageSimple:(UIImage*)image scaledToWidth:(CGFloat)newWidth
{
    
    CGSize newSize=CGSizeMake(newWidth, image.size.height*newWidth/image.size.width);
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    // End the context
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}

#pragma mark - 根据选择的图片张数创建imageviewparamDic

-(void)makeImageViewWithPickedImagesArray:(NSArray *) imageArray{
    
    NSInteger count=imageArray.count;
    
    for (int i=0; i<count; i++) {
        
        CGRect imageviewFrame;
        
        if (i<3) {
            
            imageviewFrame=CGRectMake(seperateSpace+(i+2)*(imageWidth+seperateSpace), 10, imageWidth, imageWidth);
            
        }else if (i<7){
            
            imageviewFrame=CGRectMake(seperateSpace+(i-2)*(imageWidth+seperateSpace), imageWidth+20, imageWidth, imageWidth);
            
        }else if (i<11){
            
            imageviewFrame=CGRectMake(seperateSpace+(i-6)*(imageWidth+seperateSpace), imageWidth*2+30, imageWidth, imageWidth);
            
        }else if (i<15){
            
            imageviewFrame=CGRectMake(seperateSpace+(i-10)*(imageWidth+seperateSpace), imageWidth*3+40, imageWidth, imageWidth);
            
        }else if (i<19){
            imageviewFrame=CGRectMake(seperateSpace+(i-14)*(imageWidth+seperateSpace), imageWidth*4+50, imageWidth, imageWidth);
            
        }else if (i<22){
            
            imageviewFrame=CGRectMake(seperateSpace+(i-18)*(imageWidth+seperateSpace), imageWidth*5+60, imageWidth, imageWidth);
            
        }
        
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:imageviewFrame];
        imageview.tag=i;
        imageview.userInteractionEnabled=YES;
        
        id obj=[imageArray objectAtIndex:i];
        
        if ([obj isKindOfClass:[UIImage class]]) {
            
            imageview.image=[imageArray objectAtIndex:i];
            [LoadingView stopOnTheViewController:self];
            _sendBtn.enabled=YES;
            
        }
        else if ([obj isKindOfClass:[NSString class]]){
            
            NSString *imgStr=(NSString *)obj;
            SDWebImageManager *manager=[[SDWebImageManager alloc]init];
            [manager downloadImageWithURL:[NSURL URLWithString:imgStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                imageview.image=image;
                [self.imageArray replaceObjectAtIndex:i withObject:image];
                for (id obj in imageArray) {
                    
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        break ;
                    }
                    [LoadingView stopOnTheViewController:self];
                    _sendBtn.enabled=YES;
                }
                
                
            }];
            
        }
        else if ([obj isKindOfClass:[NSDictionary class]]){
            
            
            NSDictionary *imgDic=[imageArray objectAtIndex:i];
            
            NSString *thumbUrlStr=[imgDic objectForKey:@"img_thumb"];
            NSString *imgUrlStr=[imgDic objectForKey:@"img_down"];
            
            [_pickedImagesArray replaceObjectAtIndex:i withObject:imgUrlStr];
            
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:thumbUrlStr]];
            __block ASIHTTPRequest *blockRequest=request;
            [request setCompletionBlock:^{
                
                UIImage *image=[UIImage imageWithData:blockRequest.responseData];
                [self.imageArray replaceObjectAtIndex:i withObject:image];
                imageview.image=image;
                
                for (id obj in imageArray) {
                    
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        break ;
                    }
                    [LoadingView stopOnTheViewController:self];
                    _sendBtn.enabled=YES;
                }
                
            }];
            [request startAsynchronous];
            
        }
        _isVideo = NO;
        [self.imgView addSubview:imageview];
        //图片的上传个数影响的布局
        self.imgView.frame = CGRectMake(0, 0, SCREENWIDTH, imageviewFrame.origin.y+imageviewFrame.size.height+10);
        self.backView.frame = CGRectMake(0,self.textView.frame.origin.y+self.textView.frame.size.height, SCREENWIDTH, self.imgView.frame.size.height);
        _shareToWeixinButton.frame = CGRectMake(10, self.backView.frame.origin.y+self.backView.frame.size.height+10,(SCREENWIDTH-30)/2, 34);
        _shareToWeiboButton.frame =  CGRectMake(20+(SCREENWIDTH-30)/2, self.backView.frame.origin.y+self.backView.frame.size.height+10,(SCREENWIDTH-30)/2, 34);
        self.videoView.hidden = YES;
        self.imgTextAddBtn.frame = CGRectMake(self.addImgBtn.frame.origin.x+imageWidth+10, 10, imageWidth, imageWidth);
        [self.imgTextAddBtn setBackgroundImage:[UIImage imageNamed:@"btn_add_img_makeshow"] forState:UIControlStateNormal];
        [self.imgTextAddBtn setTitle:nil forState:UIControlStateNormal];
        if (imageview.frame.origin.y+imageWidth > _scrollView.contentSize.height) {
            _scrollView.contentSize=CGSizeMake(VIEWWIDTH, imageview.frame.origin.y+imageWidth+seperateSpace);
        }
        [_imageViewArray addObject:imageview];
    }
    
}

#pragma mark ELCImagePickerControllerDelegate

-(void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    
    _describeField.text=self.content;
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    [_pickedImagesArray addObjectsFromArray:self.imageArray];
    
    for (NSDictionary *dict in info) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        [_pickedImagesArray addObject:image];
        NSLog(@"imgimgimgigm = %@",image);
        
    }
    
    [self makeImageViewWithPickedImagesArray:_pickedImagesArray];
    
}

-(void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    
    _describeField.text=self.content;
    [_pickedImagesArray addObjectsFromArray:self.imageArray];
    [self makeImageViewWithPickedImagesArray:_pickedImagesArray];
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
    [_describeField resignFirstResponder];
    _sendBtn.enabled=NO;
    
    dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), ^{
        if (index==1){
            [self NetAccessWithType:[NSString stringWithFormat:@"%d",1]];//好友
        }else if (index==2){
            [self NetAccessWithType:[NSString stringWithFormat:@"%d",0]];//公开
        }
        
    });
    
}

//图片权限 0关注的人 1互相关注的人 2共享相册的人
-(void)NetAccessWithType:(NSString *) type{
    
    [MobClick event:UMEVENTSHOW];
    //处理描述文字
    NSString *text = _describeField.text;
    
    if (text.length<=200) {
        //网络请求，继续秀一下
        //将图片和url地址分别封装
        NSMutableArray *imgageArray=[[NSMutableArray alloc]init];
        NSMutableArray *imgStrArray=[[NSMutableArray alloc]init];
        
        for (id obj in _pickedImagesArray) {
            if ([obj isKindOfClass:[UIImage class]]) {
                [imgageArray addObject:obj];
            }else if ( [obj isKindOfClass:[NSString class]]){
                
                [imgStrArray addObject:obj];
            }
        }
        
        if (imgageArray.count || imgStrArray.count || text.length>0) {
            
            NSString *count=[NSString stringWithFormat:@"%lu",(unsigned long)imgageArray.count];
            NSMutableDictionary *param=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        imgageArray, @"photos",
                                        count, @"file_count",
                                        LOGIN_USER_ID, @"login_user_id",
                                        type,@"img_cate",
                                        text, @"img_desc",
                                        imgStrArray,@"img_urls",[NSString stringWithFormat:@"%ld",(long)_isVideo],@"is_video",self.videoUrl,@"video_url",nil];
            if (self.tag_id) {
                [param setObject:self.tag_id forKey:@"tag_id"];
            }
            
            _paramDic = param;
            
            
            if (_isVideo && self.videoUrl.length<=0) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LoadingView stopOnTheViewController:self];
                    [self makeShowBack];
                });
                
            }else{
                
                [[NetAccess sharedNetAccess] getDataWithStyle:NetStyleMakeAShowNew andParam:param];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [LoadingView stopOnTheViewController:self];
                    //如果是正常的照片或已经压缩好的视频
                    [self makeShowBack];
//                    if (_isVideo == YES) {
//                        //如果有视频，不分享
//                        [self appDelegate].showShareInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",NO],@"weixin",[NSString stringWithFormat:@"%d",NO],@"weibo", nil];
//                    }else{
                        [self appDelegate].showShareInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.shareToWeixin],@"weixin",[NSString stringWithFormat:@"%d",self.shareToWeibo],@"weibo", nil];
//                    }
                });
            }
        }else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [LoadingView stopOnTheViewController:self];
                [BBSAlert showAlertWithContent:@"图片或视频选一样吧" andDelegate:self];
                _sendBtn.enabled=YES;
            });
        }
    }else{
        //提示文字超长
        dispatch_async(dispatch_get_main_queue(), ^{
            [LoadingView stopOnTheViewController:self];
            [BBSAlert showAlertWithContent:@"描述长度不能超过200字哦" andDelegate:self];
            _sendBtn.enabled=YES;
            
        });
        
    }
}
//视频url导出时或图片上传这时不需传参数
-(void)makeShowBack{
    
    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    delegate.isHaveUpLoad = YES;
    if ([self.backType isEqualToString:@"FromMain"]) {
        LoveBabyShowVC *loveBabyShowVC = [[LoveBabyShowVC alloc]init];
        loveBabyShowVC.from = self.backType;
        [self.navigationController pushViewController:loveBabyShowVC animated:YES];
        return;
    }
    [self.navigationController popViewControllerAnimated:YES];
    self.refreshMyBlock(nil);
    
}

@end
