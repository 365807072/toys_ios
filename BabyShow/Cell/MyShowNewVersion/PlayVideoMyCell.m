//
//  PlayVideoMyCell.m
//  BabyShow
//
//  Created by WMY on 16/7/7.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PlayVideoMyCell.h"

@implementation PlayVideoMyCell

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
        self.dateLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 300, 30)];
        self.dateLable.font = [UIFont systemFontOfSize:20];
        self.dateLable.textColor = [BBSColor hexStringToColor:@"999999"];
        [self.contentView addSubview:self.dateLable];
        //底图
        self.ImgBtn = [[UIImageView alloc]init];
        self.ImgBtn.frame = CGRectMake(0, 40, SCREENWIDTH, SCREENWIDTH*0.6+20);
        //[self.ImgBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.ImgBtn];
        UIView *backview = [[UIView alloc]initWithFrame:CGRectMake(0, SCREENWIDTH*0.6+20+45, SCREENWIDTH, 10)];
        backview.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [self.contentView addSubview:backview];
        //毛玻璃效果
        self.grayView = [[UIImageView alloc]init];
        self.grayView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH*0.6+20);
        self.grayView.image = [UIImage imageNamed:@"back_video_blurry"];
        [self.ImgBtn addSubview:self.grayView];
        self.grayView.hidden = YES;
        //中间的清晰图片
        self.imgBigBtn = [[UIImageView alloc]init];
        self.imgBigBtn.frame = CGRectMake((SCREENWIDTH-((SCREENWIDTH*0.6+20)*49/58))/2, 0, (SCREENWIDTH*0.6+20)*49/58, SCREENWIDTH*0.6+20);
        [self.ImgBtn addSubview:self.imgBigBtn];
        //小按钮
        self.playSamllBtn = [[UIImageView alloc]init];
        self.playSamllBtn.frame = CGRectMake((SCREENWIDTH-67*0.7)/2, (SCREENWIDTH*0.6+20-67*0.7)/2, 67*0.7, 67*0.7);
        self.playSamllBtn.image = [UIImage imageNamed:@"play_btn_make_show"];
        
        [self.ImgBtn addSubview:self.playSamllBtn];


        
        
        
    }
    return self;
}

@end
