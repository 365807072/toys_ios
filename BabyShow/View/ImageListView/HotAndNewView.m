//
//  HotAndNewView.m
//  BabyShow
//
//  Created by Mayeon on 14-5-8.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "HotAndNewView.h"

#import "UIImage+Resize.h"
#import "ImageView.h"
#import "SDWebImageManager.h"

@implementation HotAndNewView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithImageInfo:(NSDictionary *)imageInfo x:(float)x y:(float)y{
    self = [super initWithFrame:CGRectMake(0, y, 160, 190)];
    if (self) {
        self.imageDict = imageInfo;
        
        //图片
        CGRect imageFrame = CGRectMake(x, 2, 150, 150);
        ImageView *imageView = [[ImageView alloc]initWithFrame:imageFrame];
        imageView.image = [UIImage imageNamed:@"img_imgloding"];
        imageView.imageInfo = imageInfo;
        [self addSubview:imageView];
        
        NSURL *url = [NSURL URLWithString:[imageInfo objectForKey:@"img_thumb"]];
//        [[SDWebImageManager sharedManager]downloadWithURL:url options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
//            
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//            imageView.image = [self imageFromImage:image containerSize:imageView.frame.size originSize:image.size];
//        }];
        [[SDWebImageManager sharedManager]downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            imageView.image = [self imageFromImage:image containerSize:imageView.frame.size originSize:image.size];
        }];
        
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClick:)];
        [imageView addGestureRecognizer:tapGes];
        
        //头像
        CGRect avatarFrame = CGRectMake(x+1.5, 152+5, 25, 25);
        UIImageView *avatarImageView = [[UIImageView alloc]initWithFrame:avatarFrame];
        avatarImageView.userInteractionEnabled = YES;
        avatarImageView.layer.masksToBounds = YES;
        avatarImageView.layer.cornerRadius = 12.50;
        avatarImageView.image = [UIImage imageNamed:@"img_message_avatar_100"];
        [self addSubview:avatarImageView];
        NSURL *avatarURL = [imageInfo objectForKey:@"avatar"];
//        [[SDWebImageManager sharedManager]downloadWithURL:avatarURL options:0 progress:^(NSUInteger receivedSize, long long expectedSize) {
//            
//        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
//            avatarImageView.image = image;
//        }];
        [[SDWebImageManager sharedManager]downloadImageWithURL:avatarURL options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            avatarImageView.image = image;
        }];
        
        UITapGestureRecognizer *tapGes1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickAvatar:)];
        [avatarImageView addGestureRecognizer:tapGes1];

        NSUInteger length =[NSString stringWithFormat:@"%@",[imageInfo objectForKey:@"admire_count"]].length;
        //赞以及赞数
        UIImage *zanImg = [UIImage imageNamed:@"img_praise_nobg"];
        CGRect zanImageFrame = CGRectMake(x+150-21-length*5, 152+13, zanImg.size.width, zanImg.size.height);
        UIImageView *zanImageView = [[UIImageView alloc]initWithFrame:zanImageFrame];
        zanImageView.image = zanImg;
        [self addSubview:zanImageView];
        
        CGRect zanLabelFrame = CGRectMake(x+150-8-length*5, 152+12.5, 55, 10);
        UILabel *zanCountLabel = [[UILabel alloc]initWithFrame:zanLabelFrame];
        zanCountLabel.backgroundColor = [UIColor clearColor];
        zanCountLabel.textColor = [UIColor lightGrayColor];
        zanCountLabel.font = [UIFont systemFontOfSize:11.0f];
        //开始直接写的zanCountLabel.text =[imageInfo objectForKey:@"admire_count"],报 -[__NSCFNumber length]: unrecognized selector sent to instance崩溃错误
        zanCountLabel.text = [NSString stringWithFormat:@"%@",[imageInfo objectForKey:@"admire_count"]];
        [self addSubview:zanCountLabel];
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
    if([self.delegate respondsToSelector:@selector(clickOnTheImageView:)]){
        [self.delegate clickOnTheImageView:self.imageDict];
    }
}
- (void)onClickAvatar:(UITapGestureRecognizer *)tapGes{
    if ([self.delegate respondsToSelector:@selector(clickOnTheAvatar:)]) {
        [self.delegate clickOnTheAvatar:[self.imageDict objectForKey:@"user_id"]];
    }
}
@end
