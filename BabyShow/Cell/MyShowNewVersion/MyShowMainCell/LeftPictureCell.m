//
//  LeftPictureCell.m
//  BabyShow
//
//  Created by WMY on 16/8/1.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "LeftPictureCell.h"

@implementation LeftPictureCell

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
        
        self.contentView.backgroundColor = [BBSColor hexStringToColor:@"f7f7f7"];
        self.hotDataLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 7, SCREENWIDTH, 19)];
        self.hotDataLabel.textAlignment = NSTextAlignmentCenter;
        self.hotDataLabel.font = [UIFont systemFontOfSize:15];
        self.hotDataLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        [self.contentView addSubview:self.hotDataLabel];
        
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 33, SCREENWIDTH, 160)];
        whiteView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:whiteView];
        
        self.imgViewBig = [[UIImageView alloc]initWithFrame:CGRectMake(5, 8.5, 176, 143)];
        self.imgViewBig.image = [UIImage imageNamed:@"img_message_photo"];
        [self.imgViewBig setContentMode:UIViewContentModeScaleAspectFill];
        self.imgViewBig.clipsToBounds = YES;

        [whiteView addSubview:self.imgViewBig];
        
        self.dateLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.imgViewBig.frame.origin.x+self.imgViewBig.frame.size.width+10, 50, SCREENWIDTH-(self.imgViewBig.frame.origin.x+self.imgViewBig.frame.size.width+10)-10, 13)];
        self.dateLabel.font = [UIFont systemFontOfSize:11];
        self.dateLabel.textAlignment = NSTextAlignmentLeft;
        self.dateLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        [whiteView addSubview:self.dateLabel];
        
        self.titleLabel = [[WMYLabel alloc]initWithFrame:CGRectMake(self.imgViewBig.frame.origin.x+self.imgViewBig.frame.size.width+10,10, 125, 40)];
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.textColor = [BBSColor hexStringToColor:@"494949"];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.titleLabel setVerticalAlignment:VerticalAlignmentTop];
        self.titleLabel.numberOfLines = 0;
        [whiteView addSubview:self.titleLabel];
        
        
        self.subuTitleLabel = [[WMYLabel alloc]initWithFrame:CGRectMake(self.imgViewBig.frame.origin.x+self.imgViewBig.frame.size.width+10,self.titleLabel.frame.origin.y+self.titleLabel.frame.size.height+10, 125, 45)];
        self.subuTitleLabel.numberOfLines = 3;
        self.subuTitleLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        self.subuTitleLabel.font = [UIFont systemFontOfSize:12];
        [self.subuTitleLabel setVerticalAlignment:VerticalAlignmentTop];
        [whiteView addSubview:self.subuTitleLabel];
        
        self.lookOrginBtn = [[UIImageView alloc]init];
        self.lookOrginBtn.frame = CGRectMake(SCREENWIDTH-100, 115, 88, 25);
        self.lookOrginBtn.image = [UIImage imageNamed:@"btn_look_orgin"];
        [whiteView addSubview:self.lookOrginBtn];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 159.5, SCREENWIDTH, 0.5)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"e4e4e4"];
        [self.contentView addSubview:lineView];
        
    }
    return self;
}
@end
