//
//  PPTViewController.h
//  BabyShow
//
//  Created by Lau on 3/31/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImage+Scale.h"
#import "ASIDownloadCache.h"
#import <QuartzCore/QuartzCore.h>
#import "AnimationType.h"

@interface PPTViewController : UIViewController<UIAlertViewDelegate>

{
    
    NSMutableArray *_playPhotosArray;
    NSMutableArray *_requestPhotosArray;
    
    UIButton *_playBtn;
    UIView *_playView;
    UIImageView *_imageview;
    UIView *_navView;
    
    NSTimer *_timer;
    
    AVAudioPlayer *_player;
    
    CGRect wideFrame;
    CGRect heightFrame;
    
    BOOL _isNavHidden;
    
    int index;
    int currentIndex;
    
    ASIDownloadCache *_cache;
    UIImageView *_postview;
    
}

@property (nonatomic ,strong) NSMutableArray *photosArray;
@property (nonatomic ,assign) int maxPlayNumOnce;

@end
