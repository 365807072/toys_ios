//
//  PlayVideoMyMainCell.m
//  BabyShow
//
//  Created by WMY on 16/8/1.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PlayVideoMyMainCell.h"

@implementation PlayVideoMyMainCell

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
        self.ImgBtn.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/2);
        [self.ImgBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.ImgBtn];
        
        self.grayView = [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.grayView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENWIDTH/2);
        [self.grayView setBackgroundImage:[UIImage imageNamed:@"back_video_blurry"] forState:UIControlStateNormal];
        [self.grayView addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.ImgBtn addSubview:self.grayView];
        self.grayView.hidden = YES;
        
        self.imgBigBtn = [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.imgBigBtn.frame = CGRectMake((SCREENWIDTH-((SCREENWIDTH*0.6+20)*49/58))/2, 0, (SCREENWIDTH*0.6+20)*49/58, SCREENWIDTH/2);
        [self.imgBigBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.ImgBtn addSubview:self.imgBigBtn];
        
        self.playSamllBtn = [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.playSamllBtn.frame = CGRectMake((SCREENWIDTH-56)/2, (SCREENWIDTH/2-56)/2,56, 56);
        [self.playSamllBtn addTarget:self action:@selector(playVideoInTheView:) forControlEvents:UIControlEventTouchUpInside];
        [self.playSamllBtn setBackgroundImage:[UIImage imageNamed:@"play_btn_make_show"] forState:UIControlStateNormal];
        [self.ImgBtn addSubview:self.playSamllBtn];
        
        //类型标题
        self.titleNameLabel =[[UILabel alloc]initWithFrame:CGRectMake(5, self.ImgBtn.frame.origin.y+self.ImgBtn.frame.size.height+10, SCREENWIDTH-10, 23)];
        self.titleNameLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        self.titleNameLabel.numberOfLines = 2;
        self.titleNameLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:self.titleNameLabel];
        
        
        self.imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
        self.imgLine.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.contentView addSubview:self.imgLine];
    }
    return self;

}
-(void)resetFrameWithDescribeContent:(NSString *)content{
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:13],NSParagraphStyleAttributeName:paragraphStyle.copy};
    
    CGSize size=[content boundingRectWithSize:CGSizeMake(self.titleNameLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float height=size.height;
    if (content.length <= 0) {
        self.titleNameLabel.frame=CGRectMake(5,  SCREENWIDTH/2+10,SCREENWIDTH-10, 0);
        self.imgLine.frame = CGRectMake(0, SCREENWIDTH/2, SCREENWIDTH, 0.5);

    }else{

        if (size.height <= 15.513672) {
            height = 18;
        }else{
            height=36;
            
        }
    self.titleNameLabel.frame=CGRectMake(5,  SCREENWIDTH/2+10,SCREENWIDTH-10, height);
    self.imgLine.frame = CGRectMake(0, SCREENWIDTH/2+10+height+9.5, SCREENWIDTH, 0.5);
    }
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
