//
//  MakeAvtivityViewController.m
//  BabyShow
//
//  Created by WMY on 15/5/21.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MakeAvtivityViewController.h"
#import "AlbumListViewController.h"
#import "SpecialDetailTVC.h"


#import <ShareSDK/ShareSDK.h>



@interface MakeAvtivityViewController ()
//是否分享到微博微信
@property (nonatomic ,assign)BOOL shareToWeixin;
@property (nonatomic ,assign)BOOL shareToWeibo;
//输入框的提示文字
@property (nonatomic ,retain)UILabel *tintLabel;
@property(nonatomic,assign)BOOL isPhoto;//是选择视频还是照片
//添加秀秀文字
@property(nonatomic,strong)UIView *textView;
//添加图片和视频的view底
@property(nonatomic,strong)UIView *backView;

//添加图片view
@property(nonatomic,strong)UIView *imgView;
@property(nonatomic,strong)UIButton *addImgBtn;
@property(nonatomic,strong)UIButton *imgTextAddBtn;
//分享微信或分享微博
@property(nonatomic,strong)UIButton *shareToWeixinButton;
@property(nonatomic,strong)UIButton *shareToWeiboButton;


@end
static float seperateSpace = 10;
static float imageWidth;
static float imageViewy    = 160.0;
static float imageViewy2   = 238.0;
static float imageViewy3   = 316.0;
static float imageViewy4   = 394.0;
static float imageViewy5   = 472.0;
static float imageViewy6   = 550.0;

static float describWidth   = 304.0;
static float describHeight  = 130.0;

#define SENDFRAME CGRectMake(280, 84, 20, 20);


@implementation MakeAvtivityViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.photo=[[UIImage alloc]init];
        
        _imageViewArray=[[NSMutableArray alloc]init];
        _pickedImagesArray=[[NSMutableArray alloc]init];
        self.imageArray=[[NSMutableArray alloc]init];
        self.navigationItem.title=@"参加活动";
        
    }
    return self;
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.navigationItem.hidesBackButton=YES;
    self.tabBarController.tabBar.hidden = YES;
    
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
    CGRect describeFrame=CGRectMake(seperateSpace, 8, describWidth, describHeight);
    CGRect weixinFrame = CGRectMake(seperateSpace,  8+describHeight+seperateSpace, 153, 30);
    CGRect weiboFrame = CGRectMake(seperateSpace+155, 8+describHeight+seperateSpace, 153, 30);
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
    
    self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, self.textView.frame.origin.y+self.textView.frame.size.height, SCREENWIDTH, 80)];
    [_scrollView addSubview:self.backView];
     imageWidth = (SCREENWIDTH-60)/5;
    
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
    self.imgTextAddBtn.frame = CGRectMake(self.addImgBtn.frame.origin.x+imageWidth+10, 13, imageWidth, imageWidth);
    [self.imgTextAddBtn setTitle:@"添加图片" forState:UIControlStateNormal];
    
    self.imgTextAddBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.imgTextAddBtn setTitleColor:[BBSColor hexStringToColor:@"999999"] forState:UIControlStateNormal];
    [self.imgTextAddBtn addTarget:self action:@selector(changeImage) forControlEvents:UIControlEventTouchUpInside];
    [self.imgView addSubview:self.imgTextAddBtn];


    
    self.shareToWeixinButton =[ UIButton buttonWithType:UIButtonTypeCustom];
    _shareToWeixinButton.frame =CGRectMake(10, self.backView.frame.origin.y+self.backView.frame.size.height+10,(SCREENWIDTH-30)/2, 34);
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
    _shareToWeiboButton.frame =CGRectMake(20+(SCREENWIDTH-30)/2, self.backView.frame.origin.y+self.backView.frame.size.height+10,(SCREENWIDTH-30)/2, 34);
    [_shareToWeiboButton setBackgroundImage:weiboImage forState:UIControlStateNormal];
    [_shareToWeiboButton addTarget:self action:@selector(shareToThird:) forControlEvents:UIControlEventTouchUpInside];
    _shareToWeiboButton.tag = 2;
    [_scrollView addSubview:_shareToWeiboButton];
    
    //加号+
    _photoView=[[UIImageView alloc]initWithFrame:photoFrame];
    //_addPhotoImg=[UIImage imageNamed:@"btn_add_photo_make_a_show1.png"];
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
-(void)send
{
    [self NetAccessWithType:[NSString stringWithFormat:@"%d",2]];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    _photoView.image=_addPhotoImg;
    _describeField.text=@"";
    
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
    
    [self.imageArray removeAllObjects];
    [self.imageArray addObjectsFromArray:_pickedImagesArray];
    [_describeField resignFirstResponder];
    
    UIActionSheet *acs=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从我的相册",@"从手机相册",@"拍摄一张", nil];
    [acs showInView:[UIApplication sharedApplication].keyWindow];
    
}
-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)sends{
    
    [_describeField resignFirstResponder];
    
    if (_menu.itemIndex) {
        
        CGRect frame=SENDFRAME;
        [_menu buttonsWillAnimateFromButton:_sendBtn withFrame:frame inView:self.view];
        
    }else{
        
        CGRect frame=SENDFRAME;
        [_menu buttonsWillAnimateFromButton:_sendBtn withFrame:frame inView:self.view];
        
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
        if (_pickedImagesArray.count<9) {
            
            self.content=_describeField.text;
            
            for (UIImageView *imageview in _imageViewArray) {
                [imageview removeFromSuperview];
            }
            
            [_imageViewArray removeAllObjects];
            
            
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            elcPicker.maximumImagesCount = 9-_pickedImagesArray.count;
            elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
            elcPicker.imagePickerDelegate = self;
            
            [self presentViewController:elcPicker animated:YES completion:nil];
            
        }else{
            
            NSString *alertStr=[NSString stringWithFormat:@"每次只能上传%d张照片哦",9];
            [BBSAlert showAlertWithContent:alertStr andDelegate:self];
            
        }
        
        
    }else if (buttonIndex==2){
        //拍摄
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] ){
            
            if (_pickedImagesArray.count<9) {
                
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
                NSString *alertStr=[NSString stringWithFormat:@"每次只能上传%d张照片哦",9];
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
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
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
    //    _photoView.image=image;
    _describeField.text=self.content;
    [_pickedImagesArray removeAllObjects];
    [_pickedImagesArray addObjectsFromArray:self.imageArray];
    [_pickedImagesArray addObject:image];
    
    [self makeImageViewWithPickedImagesArray:_pickedImagesArray];
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    _describeField.text=self.content;
    [_pickedImagesArray addObjectsFromArray:self.imageArray];
    [self makeImageViewWithPickedImagesArray:_pickedImagesArray];
    [self dismissViewControllerAnimated:YES completion:nil];
    
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

#pragma mark - 根据选择的图片张数创建imageview

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
        [self.imgView addSubview:imageview];
        //图片的上传个数影响的布局
        self.imgView.frame = CGRectMake(0, 0, SCREENWIDTH, imageviewFrame.origin.y+imageviewFrame.size.height+10);
        self.backView.frame = CGRectMake(0,self.textView.frame.origin.y+self.textView.frame.size.height, SCREENWIDTH, self.imgView.frame.size.height);
        _shareToWeixinButton.frame = CGRectMake(10, self.backView.frame.origin.y+self.backView.frame.size.height+10,(SCREENWIDTH-30)/2, 34);
        _shareToWeiboButton.frame =  CGRectMake(20+(SCREENWIDTH-30)/2, self.backView.frame.origin.y+self.backView.frame.size.height+10,(SCREENWIDTH-30)/2, 34);
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
    return 3;
}

-(NSInteger)arcRadiusForRadialMenu:(ALRadialMenu *)radialMenu{
    
    return 0;
    
}

-(NSInteger)arcSizeForRadialMenu:(ALRadialMenu *)radialMenu{
    
    return 0;
    
}

-(float)buttonSizeForRadialMenu:(ALRadialMenu *)radialMenu{
    
    return 40;
}

-(UIImage *)radialMenu:(ALRadialMenu *)radialMenu imageForIndex:(NSInteger)index{
    UIImage *_shareImg=[UIImage imageNamed:@"btn_make_a_show_share"];
    UIImage *_focusImg=[UIImage imageNamed:@"btn_make_a_show_focus"];
    UIImage *_publicImg=[UIImage imageNamed:@"btn_make_a_show_public"];
    
    if (index==1) {
        return _shareImg;
    }else if (index==2){
        return _focusImg;
    }else if (index==3){
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
        
        //        if (index==1) {
        [self NetAccessWithType:[NSString stringWithFormat:@"%d",2]];
        //        }else if (index==2){
        //            [self NetAccessWithType:[NSString stringWithFormat:@"%d",1]];
        //        }else if (index==3){
        //            [self NetAccessWithType:[NSString stringWithFormat:@"%d",0]];
        //        }
        
    });
    
}

//图片权限 0关注的人 1互相关注的人 2共享相册的人
-(void)NetAccessWithType:(NSString *) type{
    
    [MobClick event:UMEVENTSHOW];
    
    //处理描述文字
    NSString *temptext = [_describeField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *text =_describeField.text;
    
    //    text=[text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    //    text=[text stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    //    text=[text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
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
        
        if (imgageArray.count || imgStrArray.count ) {
            
            NSString *count=[NSString stringWithFormat:@"%lu",(unsigned long)imgageArray.count];
            NSMutableDictionary *param=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        imgageArray,@"photos",
                                        count, @"file_count",
                                        LOGIN_USER_ID, @"login_user_id",
                                        @"0",@"img_cate",
                                        text, @"img_desc",
                                        [NSString stringWithFormat:@"%ld",(long)self.cate_id],@"cate_id",
                                        imgStrArray,@"img_urls",nil];
            
            [[NetAccess sharedNetAccess] getDataWithStyle:NetStyleMakeASpecialShowNew andParam:param];
            dispatch_async(dispatch_get_main_queue(), ^{
                [LoadingView stopOnTheViewController:self];
                [self appDelegate].showShareInfo = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.shareToWeixin],@"weixin",[NSString stringWithFormat:@"%d",self.shareToWeibo],@"weibo", nil];
                
                NSString *login_user_id =LOGIN_USER_ID;
                [self.navigationController popViewControllerAnimated:YES];
                self.refreshSpecialNewBlock(login_user_id,self.cate_id);
                
            });
        }
        else{
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [LoadingView stopOnTheViewController:self];
                [BBSAlert showAlertWithContent:@"图片不能为空哦" andDelegate:self];
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

@end
