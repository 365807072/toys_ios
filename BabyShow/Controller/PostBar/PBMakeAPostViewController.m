//
//  PBMakeAPostViewController.m
//  BabyShow
//
//  Created by Lau on 7/29/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PBMakeAPostViewController.h"
#import "SDWebImageManager.h"
#import "AlbumListViewController.h"
#import "CHTumblrMenuView.h"

@interface PBMakeAPostViewController ()

@property (nonatomic, strong) UIScrollView *scrollview;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) PostBarToolBarView *toolBarView;
@property (nonatomic, strong) UIView *photoAreaView;
@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, assign) int maxNum;
@property (nonatomic, strong) NSMutableArray *postPhotoArray;
@property (nonatomic, strong) NSString *urlStr;

@end

float basicy=35;
float imageviewWidth=75;
float imageviewSeperate=4;
float toolBarHeight=40;

@implementation PBMakeAPostViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.photoArray=[[NSMutableArray alloc]init];
        self.postPhotoArray=[[NSMutableArray alloc]init];
        self.maxNum=6;
        
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"ADD A TOPIC"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(succeed) name:USER_POSTBAR_ADD_TOPPIC_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fail:) name:USER_POSTBAR_ADD_TOPPIC_FAIL object:nil];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"ADD A TOPIC"];
    
    for (UIImageView *imgView in self.photoAreaView.subviews) {
        [imgView removeFromSuperview];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title=@"发一个";
    
    [self setBackBtn];
    [self setSendBtn];
    [self setScrollview];
    [self setTextView];
    [self setPhotoView];
    [self setGesture];
    self.view.backgroundColor = [UIColor greenColor];
    if (self.type==ADDATOPICDEFAULT) {
        [self setToolBarViewWithType:PostBarToolBarViewTypeNormal];
    }else if (self.type==ADDATOPICREPLY){
        [self setToolBarViewWithType:PostBarToolBarViewTypeReply];
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark UI

-(void)setToolBarViewWithType:(NSInteger ) type{
    
    self.toolBarView=[[PostBarToolBarView alloc]initWithType:type];
    self.toolBarView.delegate=self;
    [self.view addSubview:self.toolBarView];

}

-(void)setGesture{
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchOntheView)];
    [self.scrollview addGestureRecognizer:tap];

}

-(void)setPhotoView{
    
    CGRect photoAreaFrame=CGRectMake(0, basicy, SCREENWIDTH, SCREENHEIGHT-basicy-toolBarHeight);
    self.photoAreaView=[[UIView alloc]initWithFrame:photoAreaFrame];
    [self.scrollview addSubview:self.photoAreaView];

}

-(void)setTextView{
    
    CGRect textViewFrame=CGRectMake(5, 10, 310, 30);
    
    self.textView=[[UITextView alloc]initWithFrame:textViewFrame];
    self.textView.font=[UIFont systemFontOfSize:15];
    self.textView.delegate=self;
    self.textView.showsVerticalScrollIndicator=NO;
    [self.scrollview addSubview:self.textView];
    
    self.textView.text=@"说点什么吧……";

}

-(void)setScrollview{
    
    self.scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT-toolBarHeight)];
    self.scrollview.contentSize=CGSizeMake(SCREENWIDTH, SCREENHEIGHT-toolBarHeight);
    self.scrollview.backgroundColor=[UIColor whiteColor];
    self.scrollview.showsHorizontalScrollIndicator=NO;
    self.scrollview.showsVerticalScrollIndicator=NO;
    [self.view addSubview:self.scrollview];

}

-(void)setSendBtn{
    
    CGRect sendBtnFrame=CGRectMake(0, 0, 24, 24);

    self.sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    self.sendBtn.frame=sendBtnFrame;
    
    UIImage *sendImg=[UIImage imageNamed:@"btn_makeashow_send_square.png"];
    [_sendBtn setImage:sendImg forState:UIControlStateNormal];
    
    [self.sendBtn addTarget:self action:@selector(send) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:self.sendBtn];
    self.navigationItem.rightBarButtonItem=rightItem;

}

-(void)setBackBtn{
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}


#pragma mark UITextViewDelegate

-(void)textViewDidChange:(UITextView *)textView{
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[textView.text boundingRectWithSize:CGSizeMake(310, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    
    float height =ceilf(size.height);
    if (height>30) {
        basicy=height+15;
        CGRect newframe=CGRectMake(5, 10, 310, height+10);
        self.photoAreaView.frame=CGRectMake(0, basicy, SCREENWIDTH, SCREENHEIGHT-basicy-toolBarHeight);
        self.textView.frame=newframe;
    }
    
    if (textView.text.length>=200) {
        textView.text=[textView.text substringWithRange:NSMakeRange(0, 200)];
    }
    
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.text.length==0) {
        textView.text=@"说点什么吧……";
    }
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"说点什么吧……"]) {
        textView.text=@"";
    }
}

#pragma mark private

-(void)send{
    
    [MobClick event:UMEVENTSENDPOST];
    
    CHTumblrMenuView *menu=[[CHTumblrMenuView alloc]init];
    
    [self.textView resignFirstResponder];
    
    [menu addMenuItemWithTitle:@"只到话题" andIcon:[UIImage imageNamed:@"btn_postbar_postbar_only"] andSelectedBlock:^{
        
        [LoadingView startOnTheViewController:self];
        
        dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), ^{
            [self netWithType:@"1"];

        });
        
    }];
    
    
    [menu addMenuItemWithTitle:@"同时发布到秀秀" andIcon:[UIImage imageNamed:@"btn_postbar_myshow_also"] andSelectedBlock:^{
        
        [LoadingView startOnTheViewController:self];
        dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), ^{
            [self netWithType:@"2"];
        });
    }];
    
    [menu addMenuItemWithTitle:@"不用了" andIcon:nil andSelectedBlock:^{}];
//
//    [menu addMenuItemWithTitle:nil andIcon:nil andSelectedBlock:^{}];
//    
//    [menu addMenuItemWithTitle:nil andIcon:nil andSelectedBlock:^{}];
//    
//    [menu addMenuItemWithTitle:nil andIcon:nil andSelectedBlock:^{}];
    
    [menu show];
    
}

-(void)netWithType:(NSString *) type{
    
    //处理描述文字
    NSString *temptext = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *description = [temptext stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
    description=[description stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    description=[description stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    description=[description stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([description isEqualToString:@"说点什么吧……"]) {
        description=@"";
    }
    
    //进行网络请求判断
    if (description.length>200) {
        
        dispatch_queue_t queue=dispatch_get_main_queue();
        dispatch_async(queue, ^{
            [LoadingView stopOnTheViewController:self];
            [BBSAlert showAlertWithContent:@"描述最多只能200字" andDelegate:self];

        });
        
    }else{
        
        //网络请求，继续秀一下
        
        //将图片和url地址分别封装
        
        NSMutableArray *imgageArray=[[NSMutableArray alloc]init];
        NSMutableArray *imgStrArray=[[NSMutableArray alloc]init];
        
        for (id obj in self.postPhotoArray) {
            if ([obj isKindOfClass:[UIImage class]]) {
                [imgageArray addObject:obj];
            }else if ( [obj isKindOfClass:[NSString class]]){
                [imgStrArray addObject:obj];
            }
        }
        
        NetAccess *netAccess=[NetAccess sharedNetAccess];
        
        NSString *userid=LOGIN_USER_ID;
        
        if (imgageArray.count || imgStrArray.count || description.length ) {
            
            NSString *count=[NSString stringWithFormat:@"%lu",(unsigned long)imgageArray.count];
            
            NSMutableDictionary *param=[NSMutableDictionary dictionaryWithObjectsAndKeys:
                                        imgageArray, @"photos",
                                        count, @"file_count",
                                        @"0", @"is_forward",
                                        userid, @"user_id",
                                        @"0",@"img_cate",
                                        description, @"img_desc",
                                        imgStrArray,@"img_urls",
                                        type,@"type",nil];
            
            if (self.rootImgId) {
                
                [param setObject:self.rootImgId forKey:@"root_img_id"];
                
            }
            
            if (self.urlStr.length) {
                
                NSString *tempUrlStr = [self.urlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                NSString *urlStr = [tempUrlStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet ]];
                urlStr=[urlStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
                urlStr=[urlStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
                urlStr=[urlStr stringByReplacingOccurrencesOfString:@" " withString:@""];
                
                if (urlStr.length) {
                    
                    [param setObject:urlStr forKey:@"post_url"];
                    
                }
                
            }
            
            if (self.type==ADDATOPICDEFAULT) {
                
                if (self.post_class) {
                    [param setObject:self.post_class forKey:@"post_class"];
                }else{
                    dispatch_queue_t queue=dispatch_get_main_queue();
                    dispatch_async(queue, ^{
                        [LoadingView stopOnTheViewController:self];
                        [BBSAlert showAlertWithContent:@"不能不选类别哦" andDelegate:self];
                        self.sendBtn.enabled=YES;
                    });
                    return;
                }

            }
            
            [netAccess getDataWithStyle:NetStylePostBarAddTopic andParam:param];
            
            AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
            delegate.tabbarcontroller.tabBar.userInteractionEnabled = NO;
            
        }else{
            
            dispatch_queue_t queue=dispatch_get_main_queue();
            dispatch_async(queue, ^{
                [LoadingView stopOnTheViewController:self];
                [BBSAlert showAlertWithContent:@"描述和图片不能全为空哦" andDelegate:self];
                self.sendBtn.enabled=YES;

            });
            
        }
        
    }

}

-(void)back{
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

-(void)touchOntheView{
    
    [self.textView resignFirstResponder];
    
}

#pragma mark 展示图片

-(void)makeImageViewsWithPhotosArray:(NSArray *) PhotoArray{
    
    [self.postPhotoArray removeAllObjects];
    
    for (int i=0; i<PhotoArray.count; i++) {
    
        CGRect imageviewFrame;
        float blockWidth=imageviewWidth+imageviewSeperate;
        int j=i%4;
        
        if (i<=3) {

            imageviewFrame=CGRectMake(blockWidth*j+imageviewSeperate, imageviewSeperate+10, imageviewWidth, imageviewWidth);
            
        }else if (i<=5){
            
            imageviewFrame=CGRectMake(blockWidth*j+imageviewSeperate, blockWidth+imageviewSeperate+10, imageviewWidth, imageviewWidth);
            
        }
        
        UIImageView *imgview=[[UIImageView alloc]initWithFrame:imageviewFrame];
        [self.photoAreaView addSubview:imgview];
        
        id obj=[PhotoArray objectAtIndex:i];
        
        [self.postPhotoArray addObject:obj];
        
        if ([obj isKindOfClass:[UIImage class]]) {

            UIImage *image=[PhotoArray objectAtIndex:i];
            imgview.image=image;
            
        }else if ([obj isKindOfClass:[NSString class]]){
            
            [LoadingView startOntheView:imgview];
            
            SDWebImageManager *manager=[SDWebImageManager sharedManager];
//            [manager downloadWithURL:[NSURL URLWithString:[PhotoArray objectAtIndex:i]] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
//            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//                [LoadingView stopOnTheView:imgview];
//                imgview.image=image;
//            }];
           [manager downloadImageWithURL:[NSURL URLWithString:[PhotoArray objectAtIndex:i]] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
               
           } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
               [LoadingView stopOnTheView:imgview];
               imgview.image=image;

           }];
            
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            
            NSDictionary *imgDic=[PhotoArray objectAtIndex:i];
            
            NSString *thumbUrlStr=[imgDic objectForKey:@"img_thumb"];
            NSString *imgUrlStr=[imgDic objectForKey:@"img_down"];

//            [self.photoArray replaceObjectAtIndex:i withObject:thumbUrlStr];
            [self.postPhotoArray replaceObjectAtIndex:i withObject:imgUrlStr];
            
            SDWebImageManager *manager=[SDWebImageManager sharedManager];
//            [manager downloadWithURL:[NSURL URLWithString:thumbUrlStr] options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
//            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//                [LoadingView stopOnTheView:imgview];
//                imgview.image=image;
//            }];
            [manager downloadImageWithURL:[NSURL URLWithString:thumbUrlStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                [LoadingView stopOnTheView:imgview];
                imgview.image=image;

            }];

            
        }
        
    }
    
}

#pragma mark PostBarToolBarViewDelegate

-(void)takeAPhoto{
    
    if (self.photoArray.count<self.maxNum) {
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
            UIImagePickerController *imgPicker=[[UIImagePickerController alloc]init];
            imgPicker.sourceType=UIImagePickerControllerSourceTypeCamera;
            imgPicker.delegate=self;
            imgPicker.allowsEditing=NO;
            imgPicker.videoQuality=UIImagePickerControllerQualityType640x480;
            [self.navigationController presentViewController:imgPicker animated:YES completion:^{}];
            
        }else{
            
            [BBSAlert showAlertWithContent:@"相机设备不可用，请到手机 设置->隐私->相机选项卡 打开自由环球租赁的开关" andDelegate:self];
            
        }

    }else{
        
        [BBSAlert showAlertWithContent:[NSString stringWithFormat:@"每次最多只能发%d张图哦",self.maxNum] andDelegate:self];
        
    }
    
}

-(void)selectFromAlbum{
    
    AlbumListViewController *albumListVC = [[AlbumListViewController alloc] init];
    NSUInteger currentCount = self.photoArray.count;
    NSDictionary *movingDict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1",@"isChoosing",[NSNumber numberWithUnsignedInteger:currentCount],@"currentCount", nil];
    albumListVC.title = @"选择";
    albumListVC.movingInfo = movingDict;
    albumListVC.hidesBottomBarWhenPushed = YES;
    albumListVC.type=AlbumListViewControllerTypePostBar;
    
    [self.navigationController pushViewController:albumListVC animated:YES];
    
}

-(void)selectFromPhone{
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
//    elcPicker.maximumImagesCount = self.maxNum;
    elcPicker.maximumImagesCount=self.maxNum-self.photoArray.count;
    elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
    
}

-(void)addUrl{
    
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"添加链接" message:@"" delegate:self cancelButtonTitle:@"删除" otherButtonTitles:@"确定", nil];
    alertView.tag=1000;
    alertView.alertViewStyle=UIAlertViewStylePlainTextInput;
    UITextField *textField=[alertView textFieldAtIndex:0];
    textField.text=self.urlStr;
    [alertView show];
    
}


-(void)selectGrow{
    self.post_class=@"1";
}

-(void)selectBabyLife{
    self.post_class=@"2";
}

-(void)selectOthers{
    self.post_class=@"3";
}

#pragma mark ELCImagePickerControllerDelegate

-(void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    
    for (NSDictionary *dict in info) {
        
        UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
        [self.photoArray addObject:image];
        
    }

    [self makeImageViewsWithPhotosArray:self.photoArray];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}

-(void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    
    [self makeImageViewsWithPhotosArray:self.photoArray];
    [picker dismissViewControllerAnimated:YES completion:^{}];

}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.photoArray addObject:image];
    [self makeImageViewsWithPhotosArray:self.photoArray];
    [picker dismissViewControllerAnimated:YES completion:^{}];

}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self makeImageViewsWithPhotosArray:self.photoArray];
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
}

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag==1000) {
        if (buttonIndex==1) {
            //确定
            
            UITextField *textField=[alertView textFieldAtIndex:0];
            self.urlStr=textField.text;
            
            if (textField.text.length) {
                [self.toolBarView.linkBtn setBackgroundImage:[UIImage imageNamed:@"btn_postbar_add_a_url_added"] forState:UIControlStateNormal];
            }else{
                
                [self.toolBarView.linkBtn setBackgroundImage:[UIImage imageNamed:@"btn_postbar_add_a_url"] forState:UIControlStateNormal];
                
            }
            
        }else if (buttonIndex==0){
            //取消
            
            UITextField *textField=[alertView textFieldAtIndex:0];
            self.urlStr=textField.text=@"";
            [self.toolBarView.linkBtn setBackgroundImage:[UIImage imageNamed:@"btn_postbar_add_a_url"] forState:UIControlStateNormal];
            
        }

    }
    
    
}

#pragma mark Notification_send

-(void)succeed{
    
    [LoadingView stopOnTheViewController:self];
    UIApplication *app=[UIApplication sharedApplication];
    AppDelegate *delegate=(AppDelegate *)app.delegate;
    delegate.tabbarcontroller.tabBar.userInteractionEnabled = YES;
    delegate.postbarHasNewTopic=YES;
    
    [self showHUDWithMessage:@"发送成功，系统审核需要几秒钟哦"];
    [self performSelector:@selector(disappear) withObject:nil afterDelay:2];

}

-(void)fail:(NSNotification *) not{
    
    self.sendBtn.enabled=YES;
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    
    UIApplication *app=[UIApplication sharedApplication];
    AppDelegate *delegate=(AppDelegate *)app.delegate;
    delegate.tabbarcontroller.tabBar.userInteractionEnabled = YES;
    
}

-(void)disappear{
    
    [self dismissViewControllerAnimated:YES completion:^{}];

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

@end
