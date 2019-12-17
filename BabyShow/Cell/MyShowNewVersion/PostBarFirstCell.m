//
//  PostBarFirstCell.m
//  BabyShow
//
//  Created by WMY on 16/4/7.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarFirstCell.h"

@implementation PostBarFirstCell

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
        self.describleLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 12, SCREENWIDTH-10, 40)];
        self.describleLabel.textColor = [BBSColor hexStringToColor:@"212121"];
        self.describleLabel.font = [UIFont systemFontOfSize:15];
        self.describleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.describleLabel];
        
        self.praiseCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, 12+self.describleLabel.frame.size.height+12, SCREENWIDTH-10, 12)];
        self.praiseCountLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        self.praiseCountLabel.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.praiseCountLabel];
        
        self.lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0.5)];
        self.lineView.backgroundColor = [BBSColor hexStringToColor:@"e8e8e8"];
        [self.contentView addSubview:self.lineView];
        
        self.groupImgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.groupImgView.image = [UIImage imageNamed:@"img_group_logo"];
        [self.contentView addSubview:self.groupImgView];
        self.groupImgView.hidden = YES;
        
        self.essImgView =  [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        self.essImgView.image = [UIImage imageNamed:@"btn_essence_state"];
        [self.contentView addSubview:self.essImgView];
        self.essImgView.hidden = YES;

        
    }
    return self;
}
-(void)resetFrameWithDescribeContent:(NSString *)content{
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float height=size.height;
 
    if (content.length <= 0) {
        self.describleLabel.frame=CGRectMake(5, 12,SCREENWIDTH-10, 0);
        self.praiseCountLabel.frame = CGRectMake(5, 12, SCREENWIDTH-10, 12);
    }else{
    if (size.height>17.900391) {
        
        height=40;
    }else{
        height =20;
    }
        self.describleLabel.frame=CGRectMake(5, 12,SCREENWIDTH-10, height);
        self.praiseCountLabel.frame = CGRectMake(5, 12+self.describleLabel.frame.size.height+12, SCREENWIDTH-10, 12);
    }
    self.essImgView.frame = CGRectMake(0, 0, 0, 0);
    self.groupImgView.frame = CGRectMake(SCREENWIDTH-50, self.praiseCountLabel.frame.origin.y+12+11.5-30, 40, 20);
    self.lineView.frame = CGRectMake(0, self.praiseCountLabel.frame.origin.y+12+11.5, SCREENWIDTH, 0.5);
    
}
-(void)resetFrameWithDescribeContent:(NSString *)content isHide:(BOOL)isHide{
    
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[content boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-10, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float height=size.height;
    
    if (content.length <= 0) {
        self.describleLabel.frame=CGRectMake(5, 12,SCREENWIDTH-10, 0);
        self.praiseCountLabel.frame = CGRectMake(15, 12, SCREENWIDTH-20, 12);
    }else{
        if (size.height>17.900391) {
            
            height=40;
        }else{
            height =20;
        }
        self.describleLabel.frame=CGRectMake(5, 12,SCREENWIDTH-10, height);
        self.praiseCountLabel.frame = CGRectMake(30, 12+self.describleLabel.frame.size.height+12, SCREENWIDTH-10, 12);
    }
    self.essImgView.frame = CGRectMake(5, self.praiseCountLabel.frame.origin.y-3,20, 17);
    self.essImgView.hidden = NO;
    self.groupImgView.frame = CGRectMake(SCREENWIDTH-50, self.praiseCountLabel.frame.origin.y+12+11.5-30, 40, 20);
    self.lineView.frame = CGRectMake(0, self.praiseCountLabel.frame.origin.y+12+11.5, SCREENWIDTH, 0.5);
    
}
@end
