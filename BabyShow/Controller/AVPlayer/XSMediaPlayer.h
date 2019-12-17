//
//  XSMediaPlayer.h
//  MovieDemo
//
//  Created by zhao on 16/3/25.
//  Copyright © 2016年 Mega. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "LoveBabySecondVC.h"
//#import "XibView.h"


@interface XSMediaPlayer : UIView
/** 视频URL */
@property (nonatomic, strong) NSURL   *videoURL;
@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,assign)BOOL isFromList;//是在列表播放的时候才会有这个
@property(nonatomic,strong)NSString *imgID;
@property(nonatomic,strong)UINavigationController *nav;
@property(nonatomic,strong)UINavigationController *navFromSmall;//小屏播放的时候nav
@property(nonatomic,strong)NSString *videoUrlString;
@property(nonatomic,assign)BOOL isHV;
@property(nonatomic,strong)NSString *imgTitle;//视频的题目
//-(void)orientationChanged:(NSNotification *)noc;
-(void)setHorizontalOrVerticalScreen:(BOOL)isHV;//横屏还是竖屏
-(void)playOrPause:(BOOL)isPlay;
-(void)playRelease;
-(void)settingBackgroupImg:(UIImage*)img;

@end



