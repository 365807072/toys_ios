//
//  PostBarNewDetailV1AdmireCell.m
//  BabyShow
//
//  Created by WMY on 16/4/21.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarNewDetailV1AdmireCell.h"

@implementation PostBarNewDetailV1AdmireCell

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
        self.lookView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 50)];
        [self.contentView addSubview:self.lookView];
        
        self.lookOriginalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.lookOriginalBtn.frame = CGRectMake(15.5*0.85, 15.5*0.85, 90, 25);
        self.lookOriginalBtn.layer.masksToBounds = YES;
        self.lookOriginalBtn.backgroundColor = [UIColor whiteColor];
        self.lookOriginalBtn.layer.cornerRadius = 12.5;
        self.lookOriginalBtn.titleLabel.font = [UIFont systemFontOfSize:11];
        [self.lookView addSubview:self.lookOriginalBtn];
        
        self.admireView = [[UIView alloc]initWithFrame:CGRectMake(0, 50, SCREENWIDTH, 10*0.6*2+(SCREENWIDTH-10*0.6*2-6*2)/3*0.32)];
        [self.contentView addSubview:self.admireView];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,0.5)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"dddddd"];
        [self.admireView addSubview:lineView];
        self.imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(15.5*0.85, 15*0.85, (SCREENWIDTH-15.5*0.85*2-6*2)/3, (SCREENWIDTH-15.5*0.85*2-6*2)/3*0.32)];
        self.imgBack.image = [UIImage imageNamed:@"post_bar_detail_back"];
        self.imgBack.userInteractionEnabled = YES;
        [self.admireView addSubview:self.imgBack];
        
        self.admireBigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.admireBigBtn.frame = CGRectMake(15.5*0.85, 15*0.85, (SCREENWIDTH-15.5*0.85*2-6*2)/3, (SCREENWIDTH-15.5*0.85*2-6*2)/3*0.32);
        [self.admireView addSubview:self.admireBigBtn];
        
        
        self.admireBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.admireBtn.frame = CGRectMake(self.imgBack.frame.size.width/2-20, (self.imgBack.frame.size.height-14)/2, 14, 14);
        [self.admireBtn setImage:[UIImage imageNamed:@"postmain_bar_admire_gray"] forState:UIControlStateNormal];
        [self.imgBack addSubview:self.admireBtn];
        
        self.admireCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.admireBtn.frame.origin.x+14+4, self.admireBtn.frame.origin.y, 45, 15)];
        self.admireCountLabel.font = [UIFont systemFontOfSize:12];
        [self.imgBack addSubview:self.admireCountLabel];
        
        self.shareWeixin  = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareWeixin.frame = CGRectMake(self.imgBack.frame.origin.x+self.imgBack.frame.size.width+6, self.imgBack.frame.origin.y, self.imgBack.frame.size.width, self.imgBack.frame.size.height);
        [self.shareWeixin setImage:[UIImage imageNamed:@"post_bar_weixin_share"] forState:UIControlStateNormal];
        [self.admireView addSubview:self.shareWeixin];
        
        self.shareWeixinQuan = [UIButton buttonWithType:UIButtonTypeCustom];
        self.shareWeixinQuan.frame = CGRectMake(self.shareWeixin.frame.origin.x+self.shareWeixin.frame.size.width+6, self.imgBack.frame.origin.y, self.imgBack.frame.size.width, self.imgBack.frame.size.height);
        [self.shareWeixinQuan setImage:[UIImage imageNamed:@"post_bar_weixinquan_share"] forState:UIControlStateNormal];
        [self.admireView addSubview:self.shareWeixinQuan];
        
        
    }
    return self;
}
-(void)hidenLookViewRestFrame:(BOOL)ishidden goStore:(NSString *)storeOrWeb{
    if (ishidden == YES) {
        self.lookView.hidden = YES;
        self.admireView.frame = CGRectMake(0, 0, SCREENWIDTH, 10*0.6*2+(SCREENWIDTH-10*0.6*2-6*2)/3*0.32);

    }else{
        self.lookView.hidden = NO;
      [self.lookOriginalBtn setTitle:storeOrWeb forState:UIControlStateNormal];
      [self.lookOriginalBtn setTitleColor:[BBSColor hexStringToColor:@"ff0000"] forState:UIControlStateNormal];

        
    }
}
@end
