//
//  PostBarNewMakeSecondVC.m
//  BabyShow
//
//  Created by WMY on 16/8/10.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarNewMakeSecondVC.h"
#import "Reachability.h"
#import "UIImageView+WebCache.h"
#import "AlbumListViewController.h"
#import "PostMyGroupDetailVController.h"
#import "BBSCommonNavigationController.h"
#import "PostBarNewDetialV1VC.h"
#import "PostBarGroupNewVC.h"
#import "PostBarNewGroupOnlyOneVC.h"

@interface PostBarNewMakeSecondVC ()
@property(nonatomic,strong)UIView *textBackView;//文字背景
@property(nonatomic,strong)UIView *photoBackView;//图片选择器
//添加图片view
@property(nonatomic,strong)UIView *imgView;
@property(nonatomic,strong)UIButton *addImgBtn;
@property(nonatomic,strong)UIButton *imgTextAddBtn;
@property(nonatomic,assign)BOOL isPhoto;//是选择视频还是照片


@end

@implementation PostBarNewMakeSecondVC{
        UIScrollView *_scrollView;
        UITextView *_describeTextView;
        float  imageWidth;
        UIButton *_sendBtn;
    
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
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    _scrollView=[[UIScrollView alloc]initWithFrame:self.view.frame];
    _scrollView.contentSize=CGSizeMake(SCREENWIDTH, 600);
    _scrollView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
    [self.view addSubview:_scrollView];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(fingerTapped:)];
    [_scrollView addGestureRecognizer:singleTap];
    
    [self setSubviews];
    [self setLeftBtn];
    [self setRightBtn];
    
    //完成一段图文帖子之后的提示，需要给他
    [self hideBackViewAlertView];
    
    BBSCommonNavigationController *nav = (BBSCommonNavigationController*)self.navigationController;
    nav.isNotGoBack = YES;


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
    endSendBtn.frame = CGRectMake(52, 40, 149,54);
    [endSendBtn setBackgroundImage:[UIImage imageNamed:@"make_show_end"] forState:UIControlStateNormal];
    [endSendBtn setTitle:@"完成此话题" forState:UIControlStateNormal];
    endSendBtn.titleLabel.textColor = [UIColor whiteColor];
    [endSendBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    endSendBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [backImgView addSubview:endSendBtn];
    
    goOnNextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    goOnNextBtn.frame = CGRectMake(52, 40+54+13, 149,54);
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
    postSecond.make_groupId  = self.make_groupId;
    postSecond.isFromGroup = self.isFromGroup;

    [self.navigationController pushViewController:postSecond animated:NO];
}

-(void)fingerTapped:(UITapGestureRecognizer *)gestureRecognizer

{
    [self.view endEditing:YES];
    
}
#pragma mark 布局
-(void)setSubviews{
    _textBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 60)];
    _textBackView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_textBackView];
    
    _describeTextView=[[UITextView alloc]initWithFrame:CGRectMake(5, 5, SCREENWIDTH-10, 50)];
    _describeTextView.text=@"描述";
    _describeTextView.font=[UIFont systemFontOfSize:15];
    _describeTextView.delegate=self;
    [_textBackView addSubview:_describeTextView];
    
    //添加图片和视频的view
    imageWidth = (SCREENWIDTH-60)/5;
    _photoBackView = [[UIView alloc]initWithFrame:CGRectMake(0, _textBackView.frame.size.height, SCREENWIDTH, 80)];
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
    
    
}
-(void)setLeftBtn{
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}
-(void)back{
    NSArray *controllerCount = self.navigationController.viewControllers;
    for (int i = 0; i < controllerCount.count; i++) {
        if ([self.isFromGroup isEqualToString:@"isfromPost"]) {
            //来自话题编辑
            NSLog(@"来自话题编辑");
            if ([[controllerCount objectAtIndex:i]isKindOfClass:[PostBarNewDetialV1VC class]]) {
                    [self.navigationController popToViewController:[controllerCount objectAtIndex:i] animated:YES];
                break;
            }
        }else{
            //来自群里面发帖
        if ([[controllerCount objectAtIndex:i]isKindOfClass:[PostBarGroupNewVC class]]||[[controllerCount objectAtIndex:i]isKindOfClass:[PostBarNewGroupOnlyOneVC class]]) {
            [self.navigationController popToViewController:[controllerCount objectAtIndex:i] animated:YES];
            break;
        }
            //来自主页的发帖
            NSLog(@"来自主页的发帖");
            theAppDelegate.tabbarcontroller.selectedIndex = 0;
            theAppDelegate.window.rootViewController = theAppDelegate.tabbarcontroller;
            [theAppDelegate.tabbarcontroller setBBStabbarSelectedIndex:0];
            [self dismissViewControllerAnimated:YES completion:^{
                
            }];

     }
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
-(void)sendPostBar{
    [self.view endEditing:YES];
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NSParameterAssert([reach isKindOfClass:[Reachability class]]);
    NetworkStatus stats = [reach currentReachabilityStatus];
    if (stats == NotReachable) {
        [BBSAlert showAlertWithContent:@"您似乎与网络断开，检查一下网络再发送吧" andDelegate:self];
    }else{
        if ([_describeTextView.text isEqualToString:@"标题（选填）："]&&( _isPhoto != YES)) {
            [BBSAlert showAlertWithContent:@"什么都没有，完善一下吧!" andDelegate:self];
        }else{
            [self sendData];
        }
        
    }
}
#pragma mark 数据请求
-(void)sendData{
    [MobClick event:UMEVENTSHOW];
    //如果不是在群里面发帖
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
        //跟帖
        [param setObject:self.img_id forKey:@"root_img_id"];
            [self postDataMakeAShow:param];
    
    
}
#pragma mark 数据上传请求
-(void)postDataMakeAShow:(NSDictionary *)Param{
    [LoadingView startOnTheViewController:self];
    UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kPublicListing Method:NetMethodPost andParam:Param];
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
            
        }else{
            
            NSString *value=[Param objectForKey:key];
            [request setPostValue:value forKey:key];
            
        }
        
    }
    [request setDownloadCache:theAppDelegate.myCache];
    [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
    [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    [request setShouldAttemptPersistentConnection:NO];
    [request setTimeOutSeconds:120];
    [request startAsynchronous];
    __weak ASIFormDataRequest *blockRequest=request;
        [request setCompletionBlock:^{
            NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
            [LoadingView stopOnTheViewController:self];
            if ([[dic objectForKey:@"success"] integerValue]==1) {
                NSDictionary *dataDict = [dic objectForKey:kBBSData];
                backViewAlert.hidden = NO;
                //如果来自帖子的编辑页面，表示是需要在帖子详情刷新
                theAppDelegate.isHaveNewEditPost = YES;
            }else{
                NSString *errorString=[dic objectForKey:@"reMsg"];
                [BBSAlert showAlertWithContent:errorString andDelegate:self];
            }
        }];
    [request setFailedBlock:^{
        [LoadingView stopOnTheViewController:self];
    }];
 
}
#pragma mark 选择图片
-(void)ChoosePhoto{
    _isPhoto = YES;
    [_describeTextView resignFirstResponder];
    
    UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"自由环球租赁" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选",@"从手机相册选",@"拍一张", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
    
}
#pragma mark ELCImagePickerControllerDelegate

-(void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    for (NSDictionary *dict in info) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        [self.pickedImagesArray addObject:image];
        
    }
    
   // [self removeImageViews];
    [self showImagesWithPhotosArray:self.pickedImagesArray];
    
}

-(void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
        [_imgView addSubview:photoView];
        _imgView.frame =  CGRectMake(0, 0, SCREENWIDTH, imageviewFrame.origin.y+imageviewFrame.size.height+10);
        _photoBackView.frame = CGRectMake(0, _textBackView.frame.size.height,SCREENWIDTH, imageviewFrame.origin.y+imageviewFrame.size.height+10);
        self.imgTextAddBtn.frame = CGRectMake(self.addImgBtn.frame.origin.x+imageWidth+10, 10, imageWidth, imageWidth);
        [self.imgTextAddBtn setBackgroundImage:[UIImage imageNamed:@"btn_add_img_makeshow"] forState:UIControlStateNormal];
        [self.imgTextAddBtn setTitle:nil forState:UIControlStateNormal];
        
    }
    
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
        
    }else {
        
        [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
        
    }
    
}
#pragma mark notification keyboard
//键盘变化的监听方法
-(void)keyboardWillShow:(NSNotification *) note{
    
    NSDictionary *userInfoDic=[note userInfo];
    NSValue *framenValue=[userInfoDic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame=[framenValue CGRectValue];
    }

-(void)keyboardWillDisapper:(NSNotification *) note{
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark UIImagePickerViewDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:^{}];
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
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
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
