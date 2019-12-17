//
//  PostBarSecondCell.m
//  BabyShow
//
//  Created by WMY on 16/4/7.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarSecondCell.h"

@implementation PostBarSecondCell

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
        self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10, SCREENWIDTH-104-20, 40)];
        self.titleLabel.textColor = [BBSColor hexStringToColor:@"212121"];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.titleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.titleLabel];
        
        self.praiseCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 10+self.titleLabel.frame.size.height+12,  SCREENWIDTH-140-10, 12)];
        self.praiseCountLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        self.praiseCountLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.praiseCountLabel];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
        self.lineView.backgroundColor = [BBSColor hexStringToColor:@"e8e8e8"];
        [self.contentView addSubview:self.lineView];
        
        self.photoView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-107, 7, 102, 75)];
        [self.photoView setContentMode:UIViewContentModeScaleAspectFill];
        self.photoView.clipsToBounds = YES;

        [self.contentView addSubview:self.photoView];
        
        self.videoView =[[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-107+50, 10, 67*0.7, 67*0.7)];
        self.videoView.image = [UIImage imageNamed:@"play_btn_make_show"];
        [self.contentView addSubview:self.videoView];
        
        self.groupImgView = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-157, 60, 40, 20)];
        self.groupImgView.image = [UIImage imageNamed:@"img_group_logo"];
        [self.contentView addSubview:self.groupImgView];
        self.groupImgView.hidden = YES;

    }
    return self;
}
-(void)resetFrameWithDescribeContent:(NSString *)content{
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle.copy};

    CGSize size=[content boundingRectWithSize:CGSizeMake(self.titleLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float height=size.height;

    if (size.height <= 17.900391) {
        height = 20;

    }else{
        height=40;

    }
    self.titleLabel.frame=CGRectMake(5, 10,SCREENWIDTH-104-20, height);
    self.titleLabel.lineBreakMode = 1;
    self.praiseCountLabel.frame = CGRectMake(5, 63, SCREENWIDTH-140-10, 12);
    self.lineView.frame = CGRectMake(0, 89.5, SCREENWIDTH, 0.5);
    
}


@end
