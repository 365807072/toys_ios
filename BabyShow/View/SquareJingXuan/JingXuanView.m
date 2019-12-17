//
//  JingXuanView.m
//  BabyShow
//
//  Created by Mayeon on 14-5-5.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "JingXuanView.h"
#import "UIImage+Resize.h"
#import "ImageView.h"
#import "UIImageView+WebCache.h"

@implementation JingXuanView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithImageInfo:(NSDictionary *)imageInfo x:(float)x y:(float)y{
    self = [super initWithFrame:CGRectMake(0, y, 105, 105)];
    if (self) {
        self.imageDict = imageInfo;
        ImageView *imageView = [[ImageView alloc]initWithFrame:self.bounds];
        imageView.image = [UIImage imageNamed:@"img_imgloding"];
        imageView.imageInfo = imageInfo;
        [self addSubview:imageView];
        
        NSURL *url = [NSURL URLWithString:[imageInfo objectForKey:@"img_thumb"]];
        [imageView sd_setImageWithURL:url];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClick:)];
        [self addGestureRecognizer:tapGes];

    }
    return  self;
}
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
- (void)onClick:(UITapGestureRecognizer *)tapGes{
    if([self.delegate respondsToSelector:@selector(onClickImageInfo:)]){
        [self.delegate onClickImageInfo:self.imageDict];
    }
}
@end
