//
//  LittleImageView.m
//  BabyShow
//
//  Created by Lau on 14-1-9.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "LittleImageView.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Resize.h"

@implementation LittleImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

-(id)initWithImageInfo:(NSDictionary*)imageInfo y:(float)y is_show_album:(BOOL)is_show_album atIndex:(NSUInteger)arrayindex
{
    //间距spage + 图片高height+labelHeight +(uibutton)高
    self = [self initWithFrame:CGRectMake(0, y, 100, 100+5)];
    if (self) {

        self.is_selected = NO;
        
        float width  = 100;            //图片的宽
        float height = 100;            //图片的高
        
        self.tag = [[imageInfo objectForKey:@"img_id"] integerValue];
        self.self_tag = arrayindex;
        self.imageDict = imageInfo;
//        self.backgroundColor =[UIColor whiteColor];
        self.backgroundColor =[UIColor clearColor];
        
        NSURL *url = [NSURL URLWithString:[imageInfo objectForKey:@"img_thumb"]];

        //图片
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0 , 5, width, height)];
        imageView.tag =self.tag+2;
        imageView.image =[UIImage imageNamed:@"img_imgloding"];
        [self addSubview:imageView];
        
        [imageView sd_setImageWithURL:url];
        
        UIView *backGroundView = [[UIView alloc]initWithFrame:imageView.frame];
        backGroundView.backgroundColor = [UIColor clearColor];
        backGroundView.hidden = YES;
        backGroundView.tag =self.tag+3;
        [self addSubview:backGroundView];
        
        UIImageView *checkImageView =[[ UIImageView alloc] initWithFrame:CGRectMake(80, 5, 20, 20)];
        checkImageView.tag = self.tag+1;
        checkImageView.hidden = YES;
        checkImageView.backgroundColor =[UIColor clearColor];
        checkImageView.image =[UIImage imageNamed:@"unselected"];
        [self addSubview:checkImageView];
        
        
        //图片描述
//        UILabel *labe = [[UILabel alloc]initWithFrame:CGRectMake( 0, 100+2.5, 100, 20)];
////        labe.backgroundColor = [UIColor clearColor];
//        labe.backgroundColor = [BBSColor hexStringToColor:@"f9f3f3"];
//        labe.text = [NSString stringWithFormat:@"%@",[imageInfo objectForKey:@"description"]];
//        labe.font =[ UIFont systemFontOfSize:13.0f];
//        labe.textAlignment = NSTextAlignmentCenter;
//        labe.hidden = is_show_album;
////        labe.lineBreakMode =NSLineBreakByWordWrapping;
////        labe.numberOfLines = 0;
////        [self addSubview:labe];
        
        
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        [self addGestureRecognizer:tapGes];
        
    }
    return self;
}
 
//新版
/**
-(id)initWithImageInfo:(NSDictionary*)imageInfo x:(float)x y:(float)y is_show_album:(BOOL)is_show_album atIndex:(NSUInteger)arrayindex
{
    //间距spage + 图片高height+labelHeight +(uibutton)高
    self = [self initWithFrame:CGRectMake(0, y, 160, 138 +20)];
    if (self) {
        
        self.is_selected = NO;
        
        float width  = 138;            //图片的宽
        float height = 138;            //图片的高
        
        self.tag = [[imageInfo objectForKey:@"img_id"] integerValue];
        self.self_tag = arrayindex;
        self.imageDict = imageInfo;
        self.backgroundColor =[UIColor clearColor];
        
        NSURL *url = [NSURL URLWithString:[imageInfo objectForKey:@"img_thumb"]];
//        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
//        [request setDownloadCache:[self appDelegate].myCache];
//        [request setCachePolicy:ASIAskServerIfModifiedWhenStaleCachePolicy];
//        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
//        [request setSecondsToCache:60*60*24*30];
//        [request setDelegate:self];
//        [request setTag:self.tag+1000+2];
//        [request startAsynchronous];
        
        //图片
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x+2.5, 16-2.5, width, height)];
        imageView.tag =self.tag+2;
        imageView.image =[UIImage imageNamed:@"img_imgloding"];
        [self addSubview:imageView];
        
        [[SDWebImageManager sharedManager]downloadWithURL:url options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {//截了 1:3
            imageView.image = image;//[self imageFromImage:image containerSize:imageView.frame.size originSize:image.size];
        }];
        
        UIImageView *backimageView = [[UIImageView alloc]initWithFrame:CGRectMake(x , 11, 143, 143)];
//        backimageView.tag =self.tag+2;
        backimageView.image =[UIImage imageNamed:@"white_border"];
        [self addSubview:backimageView];
        
        UIView *backGroundView = [[UIView alloc]initWithFrame:imageView.frame];
        backGroundView.backgroundColor = [UIColor clearColor];
        backGroundView.hidden = YES;
        backGroundView.tag =self.tag+3;
        [self addSubview:backGroundView];
        
        UIImageView *checkImageView =[[ UIImageView alloc] initWithFrame:CGRectMake(x+121.5, 16-2.5, 20, 20)];
        checkImageView.tag = self.tag+1;
        checkImageView.hidden = YES;
        checkImageView.backgroundColor =[UIColor clearColor];
        checkImageView.image =[UIImage imageNamed:@"unselected"];
        [self addSubview:checkImageView];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(click:)];
        [self addGestureRecognizer:tapGes];
        
    }
    return self;
}
*/
-(void)click:(UITapGestureRecognizer *)tapGes{
//    NSLog(@"%s-%d",__FUNCTION__,__LINE__);
    self.is_selected = !self.is_selected;
    UIImageView *checkImageView = (UIImageView *)[self viewWithTag:[[self.imageDict objectForKey:@"img_id"] integerValue] +1];
    UIView *backGroundView = (UIView *)[self viewWithTag:[[self.imageDict objectForKey:@"img_id"] integerValue] +3];
    
    if (self.is_selected) {
        checkImageView.image =[UIImage imageNamed:@"img_selected"];
        backGroundView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.4];

    }else{
       checkImageView.image =[UIImage imageNamed:@"img_unselected"];
        backGroundView.backgroundColor = [UIColor clearColor];
    }
    [self.bigImageDelegate clickOnImage:self.imageDict atIndex:self.self_tag];
}
/*
-(void)requestStarted:(ASIHTTPRequest *)request{
    
}
-(void)requestFinished:(ASIHTTPRequest *)request{
    if (request.tag>1000) {
        UIImageView *imageView = (UIImageView *)[self viewWithTag:request.tag-1000];
        [imageView setImage:[UIImage imageWithData:[request responseData]]];
 
    }
    
}
-(void)requestFailed:(ASIHTTPRequest *)request
{
    
}
 */
-(UIImage *)imageFromImage:(UIImage *)originImage containerSize:(CGSize)containerSize originSize:(CGSize)originSize{
    UIImage *image = originImage;
    
    //容器的宽高,就是imageview的宽和高
    CGFloat width = containerSize.width;
    CGFloat height = containerSize.height;
    CGFloat needHeight = (originSize.height / originSize.width) * width;
    if (needHeight >= height) {
        image = [image resizedImage:CGSizeMake(width, needHeight) interpolationQuality:3];
        CGFloat difference = needHeight-height;
        CGRect cropRect = CGRectMake(0, difference/4, width, height);
        image = [image croppedImage:cropRect];
    }else{
        //高度小于要显示的,那么直接拉长
        image = [image resizedImage:CGSizeMake(width, height) interpolationQuality:3];
    }
    return image;
}
@end
