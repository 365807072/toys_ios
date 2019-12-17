//
//  PlayVideoCell.m
//  BabyShow
//
//  Created by WMY on 16/6/28.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PlayVideoCell.h"

@implementation PlayVideoCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [BBSColor whiteColor];
        self.ImgBtn = [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.ImgBtn.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.6+20);
        [self.ImgBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.ImgBtn];
        
        self.grayView = [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.grayView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.6+20);
        [self.grayView setBackgroundImage:[UIImage imageNamed:@"back_video_blurry"] forState:UIControlStateNormal];
        [self.grayView addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.ImgBtn addSubview:self.grayView];
        self.grayView.hidden = YES;
        
        self.imgBigBtn = [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.imgBigBtn.frame = CGRectMake((SCREENWIDTH-((SCREENWIDTH*0.6+20)*49/58))/2, 0, (SCREENWIDTH*0.6+20)*49/58, SCREENWIDTH*0.6+20);
        [self.imgBigBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.ImgBtn addSubview:self.imgBigBtn];
        
        self.playSamllBtn = [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.playSamllBtn.frame = CGRectMake((SCREENWIDTH-67*0.7)/2, (SCREENWIDTH*0.6+20-67*0.7)/2, 67*0.7, 67*0.7);
        [self.playSamllBtn addTarget:self action:@selector(playVideoInTheView:) forControlEvents:UIControlEventTouchUpInside];
        [self.playSamllBtn setBackgroundImage:[UIImage imageNamed:@"play_btn_make_show"] forState:UIControlStateNormal];
        [self.ImgBtn addSubview:self.playSamllBtn];

        
        
    }
    return self;
}
-(void)OnClick:(btnWithIndexPath *) btn{
    if ([self.delegate respondsToSelector:@selector(playVideoUrl:)]) {
        [self.delegate playVideoUrl:btn];
    }
    
}
-(void)playVideoInTheView:(btnWithIndexPath*)btn{
    if ([self.delegate respondsToSelector:@selector(playVideoInTheView:)]) {
        [self.delegate playVideoInTheView:btn];
    }
}
@end
