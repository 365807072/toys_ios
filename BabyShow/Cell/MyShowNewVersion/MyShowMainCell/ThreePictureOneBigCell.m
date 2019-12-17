//
//  ThreePictureOneBigCell.m
//  BabyShow
//
//  Created by WMY on 16/8/1.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ThreePictureOneBigCell.h"

@implementation ThreePictureOneBigCell

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
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.firstPicBtn = [[UIImageView alloc]init];
        self.firstPicBtn.frame = CGRectMake(0, 0, 212, 169);
        [self.firstPicBtn setContentMode:UIViewContentModeScaleAspectFill];
        self.firstPicBtn.clipsToBounds = YES;
        [self.contentView addSubview:self.firstPicBtn];
        
        
        self.secondPicBtn = [[UIImageView alloc]init];
        self.secondPicBtn.frame = CGRectMake(212+1, 0, 109, 168/2);
        [self.secondPicBtn setContentMode:UIViewContentModeScaleAspectFill];
        self.secondPicBtn.clipsToBounds = YES;

        [self.contentView addSubview:self.secondPicBtn];
        
        self.thridPicBtn = [[UIImageView alloc]init];
        self.thridPicBtn.frame = CGRectMake(self.secondPicBtn.frame.origin.x, self.secondPicBtn.frame.size.height+1, self.secondPicBtn.frame.size.width, self.secondPicBtn.frame.size.height);
        [self.thridPicBtn setContentMode:UIViewContentModeScaleAspectFill];
        self.thridPicBtn.clipsToBounds = YES;
        [self.contentView addSubview:self.thridPicBtn];
        
        //类型标题
        self.titleNameLabel =[[UILabel alloc]initWithFrame:CGRectMake(5, self.firstPicBtn.frame.origin.y+self.firstPicBtn.frame.size.height+10, SCREENWIDTH-10, 23)];
        self.titleNameLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        self.titleNameLabel.font = [UIFont systemFontOfSize:13];
        self.titleNameLabel.numberOfLines = 2;
        self.titleNameLabel.lineBreakMode = 1;
        
        [self.contentView addSubview:self.titleNameLabel];
        
        self.imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 207.5, SCREENWIDTH, 0.5)];
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
    if (content.length<=0) {
        height = 0;
        self.titleNameLabel.frame=CGRectMake(5, 169+10,SCREENWIDTH-10,0);
        self.imgLine.frame = CGRectMake(0, 169, SCREENWIDTH, 0.5);
    }else{
    if (size.height <= 15.513672) {
        height = 18;
    }else{
        height=36;
    }
        self.titleNameLabel.frame=CGRectMake(5, 169+10,SCREENWIDTH-10, height);
        self.imgLine.frame = CGRectMake(0, self.titleNameLabel.frame.origin.y+self.titleNameLabel.frame.size.height+9.5, SCREENWIDTH, 0.5);
    }
}


@end
