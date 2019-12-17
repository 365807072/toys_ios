//
//  PostMyInterestCell.m
//  BabyShow
//
//  Created by WMY on 15/6/12.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostMyInterestCell.h"


@implementation PostMyInterestCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //左边大图
        //self.photoView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8, 75, 75 )];
        self.photoView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.photoView];
        
        self.videoView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 8,60, 60)];
        self.videoView.backgroundColor = [UIColor clearColor];
        self.videoView.image = [UIImage imageNamed:@"play_btn_make_show"];
        [self.contentView addSubview:self.videoView];
     
        //群标和群名
        self.titleLabel = [[UILabel alloc]init];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        //[self.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        
        
        [self.contentView addSubview:self.titleLabel];
        //参与人数和评论人数
        self.reviewLabel = [[UILabel alloc]init];
       // [self.reviewLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        self.reviewLabel.font = [UIFont systemFontOfSize:14.5];
        self.reviewLabel.textColor = [BBSColor hexStringToColor:@"#878787"];
        [self.contentView addSubview:self.reviewLabel];
        //群标识
        self.groupImageV = [[UIImageView alloc]init];
        
        [self.titleLabel addSubview:self.groupImageV];
        //群名
        self.titleLabelS = [[UILabel alloc]init];
        //[self.titleLabelS setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
        self.titleLabelS.font = [UIFont systemFontOfSize:16];
        [self.titleLabel addSubview:self.titleLabelS];
        //描述
        //self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(94, 65, 213, 18)];
        self.descriptionLabel = [[UILabel alloc]init];
        //[self.descriptionLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        self.descriptionLabel.font = [UIFont systemFontOfSize:13];
        //self.descriptionLabel.backgroundColor = [UIColor redColor];
        self.descriptionLabel.textColor = [BBSColor hexStringToColor:@"#a1a1a1"];
        [self.contentView addSubview:self.descriptionLabel];
        
        //UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 77, SCREENWIDTH, 1)];
        self.label = [[UILabel alloc]init];
        self.label.backgroundColor = [BBSColor hexStringToColor:@"#f4f4f4"];
        [self.contentView addSubview:self.label];
        
        self.butTop = [UIButton buttonWithType:UIButtonTypeCustom];
        self.butTop.hidden = YES;
        [self.contentView addSubview:self.butTop];
        self.imgViewTop = [[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 12, 12)];
        self.imgViewTop.image = [UIImage imageNamed:@"btn_qun_toppost"];
        [self.butTop addSubview:self.imgViewTop];
        self.labelTop = [[UILabel alloc]initWithFrame:CGRectMake(15, 1, 60, 16)];
        self.labelTop.text = @"置顶";
        self.labelTop.font = [UIFont systemFontOfSize:14];
        self.labelTop.textColor = [BBSColor hexStringToColor:@"#479fde"];
        [self.butTop addSubview:self.labelTop];
        
        self.butDele = [UIButton buttonWithType:UIButtonTypeCustom];
        self.butDele.hidden = YES;
        [self.contentView addSubview:self.butDele];
        self.imgViewDele =[[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 12, 12)];
        self.imgViewDele.image = [UIImage imageNamed:@"btn_qun_delpost"];
        [self.butDele addSubview:self.imgViewDele];
        self.labelDele = [[UILabel alloc]initWithFrame:CGRectMake(15, 1, 28, 16)];
        self.labelDele.text = @"删除";
        self.labelDele.font = [UIFont systemFontOfSize:14];
        self.labelDele.textColor = [BBSColor hexStringToColor:@"#ea3232"];
        [self.butDele addSubview:self.labelDele];
        //精华
        self.btnJingHua = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnJingHua.hidden = YES;
        [self.contentView addSubview:self.btnJingHua];
        self.imgJingHua =[[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 10, 12)];
        self.imgJingHua.image = [UIImage imageNamed:@"btn_qun_jinghua"];
        [self.btnJingHua addSubview:self.imgJingHua];
        self.labelJinghua = [[UILabel alloc]initWithFrame:CGRectMake(15, 1, 28, 16)];
        self.labelJinghua.text = @"精华";
        self.labelJinghua.font = [UIFont systemFontOfSize:14];
        self.labelJinghua.textColor = [BBSColor hexStringToColor:@"999999"];
        [self.btnJingHua addSubview:self.labelJinghua];
        
        //公告
        self.btnGongGao = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnGongGao.hidden = YES;
        [self.contentView addSubview:self.btnGongGao];
        self.imgGongGao =[[UIImageView alloc]initWithFrame:CGRectMake(0, 3, 12, 12)];
        self.imgGongGao.image = [UIImage imageNamed:@"btn_qun_gonggao"];
        [self.btnGongGao addSubview:self.imgGongGao];
        self.labelGongGao = [[UILabel alloc]initWithFrame:CGRectMake(15, 1, 28, 16)];
        self.labelGongGao.text = @"公告";
        self.labelGongGao.font = [UIFont systemFontOfSize:14];
        self.labelGongGao.textColor = [BBSColor hexStringToColor:@"999999"];
        [self.btnGongGao addSubview:self.labelGongGao];

        
        
    }
    return self;
}

@end
