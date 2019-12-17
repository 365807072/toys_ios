//
//  ThreePictureSmallCell.m
//  BabyShow
//
//  Created by WMY on 16/8/1.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ThreePictureSmallCell.h"

@implementation ThreePictureSmallCell

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
        
        self.imgStore1 = [[UIImageView alloc]initWithFrame:CGRectMake(5,12,102, 86)];
        self.imgStore1.image = [UIImage imageNamed:@"img_myshow_back"];
        [self.contentView addSubview:self.imgStore1];
        [self.imgStore1 setContentMode:UIViewContentModeScaleAspectFill];
        self.imgStore1.clipsToBounds = YES;

        
        self.imgStore2 = [[UIImageView alloc]initWithFrame:CGRectMake(5+102+2,12,102, 86)];
        self.imgStore2.image = [UIImage imageNamed:@"img_myshow_back"];
        [self.imgStore2 setContentMode:UIViewContentModeScaleAspectFill];
        self.imgStore2.clipsToBounds = YES;

        [self.contentView addSubview:self.imgStore2];
        
        self.imgStore3 = [[UIImageView alloc]initWithFrame:CGRectMake(5+102+2+102+2,12,102, 86)];
        self.imgStore3.image = [UIImage imageNamed:@"img_myshow_back"];
        [self.imgStore3 setContentMode:UIViewContentModeScaleAspectFill];
        self.imgStore3.clipsToBounds = YES;

        [self.contentView addSubview:self.imgStore3];
        
        
        //类型标题
        self.titleNameLabel =[[UILabel alloc]initWithFrame:CGRectMake(5, self.imgStore1.frame.origin.y+self.imgStore1.frame.size.height+10, SCREENWIDTH-10, 23)];
        self.titleNameLabel.textColor = [BBSColor hexStringToColor:@"999999"];
        self.titleNameLabel.font = [UIFont systemFontOfSize:13];
        self.titleNameLabel.numberOfLines = 2;
        self.titleNameLabel.lineBreakMode = 1;
        [self.contentView addSubview:self.titleNameLabel];

        
        self.imgLine = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 0)];
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
        self.titleNameLabel.frame=CGRectMake(5, 12+86,SCREENWIDTH-10, 0);
        self.imgLine.frame = CGRectMake(0, 12+86+9.5, SCREENWIDTH, 0.5);
    }else{
    if (size.height <= 15.513672) {
        height = 18;
        
    }else{
        height = 36;
    }
        self.titleNameLabel.frame=CGRectMake(5, 12+86+5,SCREENWIDTH-10, height);
        self.imgLine.frame = CGRectMake(0, self.titleNameLabel.frame.origin.y+self.titleNameLabel.frame.size.height+9.5, SCREENWIDTH, 0.5);

    }
    

    
}

@end
