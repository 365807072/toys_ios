//
//  PPTViewController.m
//  BabyShow
//
//  Created by Lau on 3/31/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PPTViewController.h"

@interface PPTViewController ()

@end

@implementation PPTViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.photosArray=[[NSMutableArray alloc]init];

    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _playPhotosArray=[[NSMutableArray alloc]init];
    _requestPhotosArray=[[NSMutableArray alloc]init];
    
    _cache=[[ASIDownloadCache alloc]init];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    NSString *documentDirectory = [paths objectAtIndex:0];
    [_cache setStoragePath:[documentDirectory stringByAppendingPathComponent:@"resource"]];
    [[ASIDownloadCache sharedCache]setShouldRespectCacheControlHeaders:NO];
    
    [self setBackBtn];
    self.view.backgroundColor=[UIColor blackColor];
    
    wideFrame=CGRectMake(0, 0, 320, 240);
    heightFrame=CGRectMake(0, 0, 320, 420);
    CGRect playBtnFrame=CGRectMake(0, 0, 32, 32);
    CGRect navFrame=CGRectMake(SCREENWIDTH-44, 0, 44, SCREENHEIGHT);
    
    _playView=[[UIView alloc]initWithFrame:self.view.frame];
    _playView.backgroundColor=[UIColor blackColor];
    [self.view addSubview:_playView];
    
    UIImage *navImage = [UIImage imageNamed:@"img_ppt_nav_background.png"];
    
    _navView=[[UIView alloc]initWithFrame:navFrame];
    _navView.backgroundColor=[UIColor colorWithPatternImage:navImage];
    CGRect backBtnFrame=CGRectMake(10, 25, 24, 38);
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backImage=[UIImage imageNamed:@"btn_ppt_back2.png"];
//    backImage=[self imageTurnRight:backImage];
    [_backBtn setBackgroundImage:backImage forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    [_navView addSubview:_backBtn];
    _navView.hidden=YES;
    [self.view addSubview:_navView];
    
    _playBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn.frame=playBtnFrame;
    _playBtn.center=self.view.center;
    UIImage *playImg=[UIImage imageNamed:@"btn_play.png"];
    playImg=[self imageTurnRight:playImg];
    [_playBtn setBackgroundImage:playImg forState:UIControlStateNormal];
    [_playBtn addTarget:self action:@selector(loadPhotos) forControlEvents:UIControlEventTouchUpInside];
    [_playView addSubview:_playBtn];

    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchOnTheView)];
    [self.view addGestureRecognizer:tap];
    
    [self loadPhotos];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    [self stopPlay];
    [[UIApplication sharedApplication] setStatusBarHidden:NO];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark private

-(void)touchOnTheView{
    
    CATransition *animation = [CATransition animation];
    [animation setDuration:0.5];
    [animation setFillMode:kCAFillModeForwards];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [animation setType:@"fade"];
    [animation setSubtype:kCATransitionFromRight];
    [_navView.layer addAnimation:animation forKey:nil];
    
    if (_isNavHidden) {
        
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
        _navView.hidden=NO;
        _isNavHidden=NO;
        
    }else if (!_isNavHidden){
        
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
        _navView.hidden=YES;
        _isNavHidden=YES;
        
    }
    
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

-(void)back{
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

#pragma mark 停止播放
-(void)stopPlay{
    
    [_playView bringSubviewToFront:_playBtn];
    [_timer invalidate];
    [_player stop];
    _playBtn.enabled=YES;
    _playBtn.hidden=NO;
    
}

#pragma mark 下载图片

-(void)loadPhotos{
    
    index=0;
    currentIndex=0;
    [_playPhotosArray removeAllObjects];
    [_requestPhotosArray removeAllObjects];
    
    if(self.photosArray.count){
        
        [LoadingView startOnTheViewController:self];
        
        if (self.photosArray.count>self.maxPlayNumOnce) {
            
            for (int i=0; i<currentIndex+self.maxPlayNumOnce; i++) {
                
                id obj=[self.photosArray objectAtIndex:i];
                
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary *imgDic=[self.photosArray objectAtIndex:i];
                    NSString *imgStr=[imgDic objectForKey:@"img"];
                    [self downLoadImageWithUrlString:imgStr];

                }else if ([obj isKindOfClass:[NSString class]]){
                    
                    NSString *imgStr=(NSString *) obj;
                    [self downLoadImageWithUrlString:imgStr];
                    
                }
                
            }
            
        }else{
            
            for (id obj in self.photosArray) {
                
                if ([obj isKindOfClass:[NSDictionary class]]) {
                    
                    NSDictionary *imgDic=(NSDictionary *) obj;
                    NSString *imgStr=[imgDic objectForKey:@"img"];
                    [self downLoadImageWithUrlString:imgStr];
                    
                }else if ([obj isKindOfClass:[NSString class]]){
                    
                    NSString *imgStr=(NSString *) obj;
                    [self downLoadImageWithUrlString:imgStr];
                    
                }
                
            }

        }
        
        if (_requestPhotosArray.count) {
            
            [_playPhotosArray addObjectsFromArray:_requestPhotosArray];
            [self playPhotos];
            _playBtn.hidden=YES;

        }else{
            
            [self stopPlay];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"自由环球租赁" message:@"网络不太好，稍后再试一下吧" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
            [alert show];

        }
        
        [LoadingView stopOnTheViewController:self];
        
    }
    
}

-(void)downLoadImageWithUrlString:(NSString *) urlStr{
    
    ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [request setDelegate:self];
    [request setDownloadCache:_cache];
    [request setTimeOutSeconds:10];
    [request startSynchronous];
    
    if (request.responseData.length) {
                
        UIImage *image=[UIImage imageWithData:request.responseData];
        image=[self imageTurnRight:image];
        [_requestPhotosArray addObject:image];
        
    }
    
    
}

#pragma mark 图片旋转
-(UIImage *)imageTurnRight:(UIImage *) image{
    
    if ( image.imageOrientation==UIImageOrientationUp ) {
        
        UIImage *newImg=[UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:UIImageOrientationRight];
//        UIGraphicsBeginImageContext(newImg.size);
//        [image drawInRect:CGRectMake(0, 0, image.size.width, image.size.height)];
//        image = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
        image=newImg;
    }

    return image;
}

#pragma mark 加载更多图
-(void)searchMorePhotos{
    
    [_requestPhotosArray removeAllObjects];
    
    [LoadingView startOnTheViewController:self];
    
    if (self.photosArray.count-currentIndex-1>self.maxPlayNumOnce) {
        
        for (int i=currentIndex; i< currentIndex+self.maxPlayNumOnce; i++) {
            
            NSLog(@"i:%d",i);
            
            id obj=[self.photosArray objectAtIndex:i];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *imgDic=[self.photosArray objectAtIndex:i];
                NSString *imgStr=[imgDic objectForKey:@"img"];
                [self downLoadImageWithUrlString:imgStr];
                
            }else if ([obj isKindOfClass:[NSString class]]){
                
                NSString *imgStr=(NSString *)obj;
                [self downLoadImageWithUrlString:imgStr];
                
            }
            
        }
        
    }else{
        
        for (int i=currentIndex; i< self.photosArray.count; i++) {
            NSLog(@"i:%d",i);
            
            id obj=[self.photosArray objectAtIndex:i];
            if ([obj isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *imgDic=[self.photosArray objectAtIndex:i];
                NSString *imgStr=[imgDic objectForKey:@"img"];
                [self downLoadImageWithUrlString:imgStr];
                
            }else if ([obj isKindOfClass:[NSString class]]){
                
                NSString *imgStr=(NSString *)obj;
                [self downLoadImageWithUrlString:imgStr];
                
            }
            
        }
        
    }
    
    [LoadingView stopOnTheViewController:self];
    
    if (_requestPhotosArray.count) {
        
        [_playPhotosArray addObjectsFromArray:_requestPhotosArray];
        [_timer setFireDate:[NSDate date]];
        
    }else{
        
        [self stopPlay];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"自由环球租赁" message:@"网络不太好，稍后再试一下吧" delegate:self cancelButtonTitle:@"好的" otherButtonTitles: nil];
        [alert show];

    }
    
}

#pragma mark 播放图片

-(void)playPhotos{
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    _isNavHidden=YES;
    if (_imageview) {
        [_imageview removeFromSuperview];
    }
    _imageview=[[UIImageView alloc]initWithFrame:wideFrame];
    [_playView addSubview:_imageview];
    
    index=0;
    currentIndex=0;
    
    int randomNum=arc4random()%8;
    
    NSString *musicName=[NSString stringWithFormat:@"0%d",randomNum];
    NSString *path=[[NSBundle mainBundle] pathForResource:musicName ofType:@"mp3"];
    NSError *error;
    _player=[[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL fileURLWithPath:path] error:&error];
    _player.volume=1.0;
    _player.numberOfLoops=100;
    [_player play];
    
    _timer=[NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(playNext) userInfo:nil repeats:YES];
    
    [_timer setFireDate:[NSDate distantPast]];
    
}

-(void)playNext{
    
    if (index < _playPhotosArray.count) {
        
        NSLog(@"index:%d",index);

        if (_postview) {
            
            [_postview removeFromSuperview];
            
        }
        
        CATransition *animation = [CATransition animation];
        [animation setDuration:4.0];
        [animation setFillMode:kCAFillModeForwards];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
        [animation setType:[AnimationType randomAnimationTypeString]];
        [animation setSubtype:kCATransitionFromRight];
        [_imageview.layer addAnimation:animation forKey:nil];
        _imageview.image=nil;
        UIImage *image=[_playPhotosArray objectAtIndex:index];
        index++;
        
        if (image.size.width>=image.size.height) {
            //宽图
            _imageview.frame=wideFrame;
            image=[image scaleToSize:image size:wideFrame.size];
            
        }else if(image.size.width<image.size.height){
            //长图
            _imageview.frame=heightFrame;
            image=[image scaleToSize:image size:heightFrame.size];
            
        }
        
        _imageview.image=image;
        
        _imageview.center=self.view.center;
              
    }else{
        
        currentIndex=index;
        NSLog(@"currentIndex:%d",currentIndex);
        
        if (currentIndex <= self.photosArray.count-1) {
            
            [_timer setFireDate:[NSDate distantFuture]];
            [self searchMorePhotos];

        }else{
            
            [self stopPlay];
            
        }
        
    }

}

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

@end
