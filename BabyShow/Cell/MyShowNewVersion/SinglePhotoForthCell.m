//
//  SinglePhotoForthCell.m
//  BabyShow
//
//  Created by WMY on 16/4/12.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "SinglePhotoForthCell.h"

@implementation SinglePhotoForthCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0,0, SCREENWIDTH, SCREENWIDTH/3)];
        [self.contentView addSubview:self.photoView];
        
        //类型标题
        self.titleNameLabel =[[UILabel alloc]initWithFrame:CGRectMake(5,SCREENWIDTH/3+10, SCREENWIDTH-10, 23)];
        self.titleNameLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        self.titleNameLabel.font = [UIFont systemFontOfSize:13];
        self.titleNameLabel.numberOfLines = 2;
        [self.contentView addSubview:self.titleNameLabel];
        
        
        //用户名或标签名

        
        self.imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,0)];
        self.imgLine.backgroundColor = [BBSColor hexStringToColor:@"e8e8e8"];
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
        self.titleNameLabel.frame=CGRectMake(5,  SCREENWIDTH/3,SCREENWIDTH-10, 0);
        self.imgLine.frame = CGRectMake(0, SCREENWIDTH/3, SCREENWIDTH, 0.5);

    }else{
    if (size.height <= 15.513672) {
        height = 18;
    }else{
        height=36;
        
    }
    self.titleNameLabel.frame=CGRectMake(5,  SCREENWIDTH/3+10,SCREENWIDTH-0, height);
    self.imgLine.frame = CGRectMake(0, self.titleNameLabel.frame.origin.y+self.titleNameLabel.frame.size.height+9.5, SCREENWIDTH, 0.5);
    }

}

@end
