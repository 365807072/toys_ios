//
//  MyHomePageHeaderView.m
//  BabyShow
//
//  Created by Lau on 14-1-2.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyHomePageHeaderView.h"
#import "UIImageView+WebCache.h"
#import "ClickImage.h"
#import "ClickViewController.h"

static float Height = 25.0;
static float LabelHeight = 20.0;
static float space = 10.0;
static float avatarLength = 66.0;
static float labelLength = 206.0;

@implementation MyHomePageHeaderView


-(id)initWithDetails:(NSDictionary *)Detail{
    
    NSString *username=[Detail objectForKey:@"username"];
    NSArray *babys=[Detail objectForKey:@"babys"];
    NSString *avatarStr=[Detail objectForKey:@"avatarStr"];
    NSInteger type = [[Detail objectForKey:@"type"] integerValue];
    NSInteger relation = [[Detail objectForKey:@"relation"] integerValue];
    NSString *level_img = [Detail objectForKey:@"level_img"];
    
    NSUInteger count=babys.count;

    self=[super initWithFrame:CGRectMake(0, 0, 320, (count +2)*Height+2*space+1+ 400)];
    CGFloat height=(count +2)*Height+2*space+1;
    
    if (self) {
        CGRect contentFrame=CGRectMake(0, 0, 320, count*LabelHeight+2*Height+2*space+1+ 400);
        
        CGRect avatarFrame=CGRectMake(space, 21, avatarLength, avatarLength);
        CGRect nameFrame=CGRectMake(avatarLength+3*space, space, labelLength, Height);
        CGRect addBtnFrame=CGRectMake(avatarLength+3*space, count*LabelHeight +Height+space+4, 103, 23);
        
        CGRect sepView2Frame=CGRectMake(0, addBtnFrame.origin.y+23+18, SCREENWIDTH, 10);
        
        CGRect lineFrame=CGRectMake(0, count*LabelHeight+2*Height+2*space+1, 320, 0.5);
        CGRect lineFrame1=CGRectOffset(lineFrame, 0, 43);
        CGRect lineFrame2=CGRectOffset(lineFrame1, 0, 43);
        lineFrame2.size.height = 3.5;
        
        CGPoint center=CGPointMake(space+avatarLength/2, height/2);
        
        UIFont *font=[UIFont systemFontOfSize:14];
        
        UIView *conView=[[UIView alloc]initWithFrame:contentFrame];
        [self.contentView addSubview:conView];
        
        self.avatarImgView=[[UIImageView alloc]initWithFrame:avatarFrame];
        self.avatarImgView.layer.masksToBounds = YES;
        self.avatarImgView.layer.cornerRadius = 33;
        self.avatarImgView.center=center;
        [conView addSubview:self.avatarImgView];
        
        [self.avatarImgView sd_setImageWithURL:[NSURL URLWithString:avatarStr]];
        
        UIFont *nameFont = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        CGSize size = [username boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:nameFont} context:nil].size;
        nameFrame.size.width = size.width;
        nameFrame.size.height = size.height;
        
        self.nameLabel=[[UILabel alloc]initWithFrame:nameFrame];
        self.nameLabel.text=username;
        self.nameLabel.font= nameFont;
        self.nameLabel.textColor=[BBSColor hexStringToColor:@"3e3e3e"];
        self.nameLabel.backgroundColor=[UIColor clearColor];
        [conView addSubview:self.nameLabel];
        
        ClickImage *levelImageView = [[ClickImage alloc]initWithFrame:CGRectZero];
        levelImageView.backgroundColor = [UIColor clearColor];
        levelImageView.image = nil;
        if (!(level_img.length<= 0)) {
            [[SDWebImageManager sharedManager]downloadImageWithURL:[NSURL URLWithString:level_img] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                levelImageView.frame =CGRectMake(nameFrame.origin.x + size.width + 1, nameFrame.origin.y, image.size.width*0.8,image.size.height*0.8);
                levelImageView.image = image;
            }];
        }

        levelImageView.canClick = YES;
        ClickViewController *clickVC = [[ClickViewController alloc] init];
        [levelImageView setClickToViewController:clickVC];
        [conView addSubview:levelImageView];
        for (int i=0; i<count; i++) {
            NSString *text=[babys objectAtIndex:i];
            UILabel *kidLabel=[[UILabel alloc]initWithFrame:CGRectMake(avatarLength+3*space, i*LabelHeight+Height+space, labelLength, Height)];
            kidLabel.text=text;
            kidLabel.font=font;
            kidLabel.textColor=[BBSColor hexStringToColor:@"818181"];
            kidLabel.backgroundColor=[UIColor clearColor];
            [conView addSubview:kidLabel];
        }
        
        self.addKidBtn=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.addKidBtn.frame=addBtnFrame;
        [self.addKidBtn setBackgroundImage:[UIImage imageNamed:@"btn_myhomepage_addababy"] forState:UIControlStateNormal];
        [self.addKidBtn addTarget:self action:@selector(addBtnBePressed) forControlEvents:UIControlEventTouchUpInside];
        [conView addSubview:self.addKidBtn];
        
        self.seperateView2=[[UIView alloc]initWithFrame:sepView2Frame];
        self.seperateView2.backgroundColor=[BBSColor hexStringToColor:@"f5f5f5"];
        [conView addSubview:self.seperateView2];
        
        
        
        UIButton *albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        albumBtn.frame = CGRectMake(32,self.seperateView2.frame.origin.y+10+44 , 32, 44);
        albumBtn.tag = 1;
        [albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_homepage_album"] forState:UIControlStateNormal];
        [albumBtn addTarget:self action:@selector(funcClick:) forControlEvents:UIControlEventTouchUpInside];
        [conView addSubview:albumBtn];
        
        UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        saveBtn.frame = CGRectMake(32,albumBtn.frame.origin.y+10+44, 32, 44);
        saveBtn.tag = 5;
        [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_homepage_save"] forState:UIControlStateNormal];
        [saveBtn addTarget:self action:@selector(funcClick:) forControlEvents:UIControlEventTouchUpInside];
        [conView addSubview:saveBtn];

        
        UIButton *fabuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        fabuBtn.frame = CGRectMake(32,saveBtn.frame.origin.y+10+44, 59, 44);
        fabuBtn.tag = 2;
        [fabuBtn setBackgroundImage:[UIImage imageNamed:@"btn_homepage_fabu"] forState:UIControlStateNormal];
        [fabuBtn addTarget:self action:@selector(funcClick:) forControlEvents:UIControlEventTouchUpInside];
        [conView addSubview:fabuBtn];
        
        UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        orderBtn.frame = CGRectMake(32,fabuBtn.frame.origin.y+10+44, 59, 44);
        [orderBtn setBackgroundImage:[UIImage imageNamed:@"btn_homepage_order"] forState:UIControlStateNormal];
        [orderBtn addTarget:self action:@selector(funcClick:) forControlEvents:UIControlEventTouchUpInside];
        orderBtn.tag = 6;
        [conView addSubview:orderBtn];
        
        UIButton *friendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        friendBtn.frame = CGRectMake(32,orderBtn.frame.origin.y+10+44, 32, 44);
        friendBtn.tag = 3;
        [friendBtn setBackgroundImage:[UIImage imageNamed:@"btn_homepage_friend"] forState:UIControlStateNormal];
        [friendBtn addTarget:self action:@selector(funcClick:) forControlEvents:UIControlEventTouchUpInside];
        [conView addSubview:friendBtn];
        
        UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        shareBtn.frame = CGRectMake(32, friendBtn.frame.origin.y+10+18+44, 59, 44);
        shareBtn.tag = 4;
        [shareBtn setBackgroundImage:[UIImage imageNamed:@"btn_homepage_share"] forState:UIControlStateNormal];
        [shareBtn addTarget:self action:@selector(funcClick:) forControlEvents:UIControlEventTouchUpInside];
        [conView addSubview:shareBtn];
        
        UILabel *grayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, shareBtn.frame.origin.y+44+18, SCREENWIDTH, 10)];
        grayLabel.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [conView addSubview:grayLabel];
        
        
        if (type == 1) {
            [fabuBtn setBackgroundImage:[UIImage imageNamed:@"btn_homepage_fabu_ta"] forState:UIControlStateNormal];
            [orderBtn setBackgroundImage:[UIImage imageNamed:@"btn_homepage_order_ta"] forState:UIControlStateNormal];
            [shareBtn setBackgroundImage:[UIImage imageNamed:@"btn_homepage_share_gray"] forState:UIControlStateNormal];
            [saveBtn setBackgroundImage:[UIImage imageNamed:@"btn_homepage_save_gray"] forState:UIControlStateNormal];
            if ( (relation==0 || relation==1)) {
                [albumBtn setBackgroundImage:[UIImage imageNamed:@"btn_homepage_album_ta"] forState:UIControlStateNormal];
            }
        }
        
    }
    
    return self;
    
}

#pragma mark Delegate

-(void)addBtnBePressed{
    if ([self.delegate respondsToSelector:@selector(addAChild)]) {
        [self.delegate addAChild];
    }
}
- (void)funcClick:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(channelSelect:)]) {
        [self.delegate channelSelect:button.tag];
    }
}

@end
