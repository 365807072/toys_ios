//
//  StoreListThridCell.m
//  BabyShow
//
//  Created by WMY on 16/4/7.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "StoreListThridCell.h"

@implementation StoreListThridCell

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
        
        self.contentView.backgroundColor = [BBSColor hexStringToColor:@"deeaff"];
        
        self.describleLabel = [[UILabel alloc]initWithFrame:CGRectMake(10,11, SCREENWIDTH-20-40-7, 40)];
        self.describleLabel.textColor = [BBSColor hexStringToColor:@"212121"];
        self.describleLabel.font = [UIFont systemFontOfSize:15];
        self.describleLabel.numberOfLines = 0;
        [self.contentView addSubview:self.describleLabel];
        
        self.imgArrow = [[UIImageView alloc]initWithFrame:CGRectMake(self.describleLabel.frame.origin.x+self.describleLabel.frame.size.width+7, 12, 38,13)];
        self.imgArrow.image = [UIImage imageNamed:@"img_arrow_main"];
        [self.contentView addSubview:self.imgArrow];

       
        //第一套
        self.backView1 = [[UIView alloc]initWithFrame:CGRectMake(10, 11+self.describleLabel.frame.size.height+8, (SCREENWIDTH-20-5)/3, 99)];
        self.backView1.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
        [self.contentView addSubview:self.backView1];
        
        
        self.img1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.backView1.frame.size.width, self.backView1.frame.size.width*74/115)];
        self.img1.image = [UIImage imageNamed:@"img_message_photo"];
        [self.backView1 addSubview:self.img1];
        
        self.priceLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(5, self.img1.frame.origin.y+self.img1.frame.size.height+5, 70, 15)];
        self.priceLabel1.textColor = [BBSColor hexStringToColor:@"ff5b5c"];
        self.priceLabel1.font = [UIFont systemFontOfSize:14];
        [self.backView1 addSubview:self.priceLabel1];
        
        self.priceMark1 =[[DeleteLineLabel alloc]initWithFrame:CGRectMake(self.backView1.frame.size.width-35-5, self.priceLabel1.frame.origin.y+3, 35, 10)];
        self.priceMark1.font = [UIFont systemFontOfSize:10];
        self.priceMark1.textColor = [BBSColor hexStringToColor:@"999999"];
        
       self.priceMark1.textAlignment = NSTextAlignmentRight;
        [self.backView1 addSubview:self.priceMark1];
        
        self.userNameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(0,self.img1.frame.origin.y+self.img1.frame.size.height+5, self.backView1.frame.size.width, 15)];
        self.userNameLabel1.textColor = [BBSColor hexStringToColor:@"212121"];
        self.userNameLabel1.font = [UIFont systemFontOfSize:13];
        self.userNameLabel1.textAlignment = NSTextAlignmentCenter;
        [self.backView1 addSubview:self.userNameLabel1];
        
        //第二套
        self.backView2 = [[UIView alloc]initWithFrame:CGRectMake(self.backView1.frame.origin.x+self.backView1.frame.size.width+2.5, self.backView1.frame.origin.y ,(SCREENWIDTH-20-5)/3,99)];
        self.backView2.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
        [self.contentView addSubview:self.backView2];
        
        
        self.img2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.backView2.frame.size.width,self.backView2.frame.size.width*74/115)];
        self.img2.image = [UIImage imageNamed:@"img_message_photo"];
        [self.backView2 addSubview:self.img2];
        
        self.priceLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(5,self.img2.frame.origin.y+self.img2.frame.size.height+5, 70, 15)];
        self.priceLabel2.textColor = [BBSColor hexStringToColor:@"ff5b5c"];
        self.priceLabel2.font = [UIFont systemFontOfSize:14 ];
        [self.backView2 addSubview:self.priceLabel2];
        
        self.priceMark2 =[[DeleteLineLabel alloc]initWithFrame:CGRectMake(self.backView2.frame.size.width-35-5, self.priceLabel2.frame.origin.y+3, 35, 10)];
        self.priceMark2.font = [UIFont systemFontOfSize:10];
        self.priceMark2.textColor = [BBSColor hexStringToColor:@"999999"];
        
        self.priceMark2.textAlignment = NSTextAlignmentRight;
        [self.backView2 addSubview:self.priceMark2];
        
        self.userNameLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.img2.frame.origin.y+self.img2.frame.size.height+5, self.backView2.frame.size.width, 15)];
        self.userNameLabel2.textColor = [BBSColor hexStringToColor:@"212121"];
        self.userNameLabel2.font = [UIFont systemFontOfSize:13];
        self.userNameLabel2.textAlignment = NSTextAlignmentCenter;
        [self.backView2 addSubview:self.userNameLabel2];
        
        //第三套
        self.backView3 = [[UIView alloc]initWithFrame:CGRectMake(self.backView2.frame.origin.x+self.backView2.frame.size.width+2.5, self.backView1.frame.origin.y, (SCREENWIDTH-20-5)/3, 99)];
        self.backView3.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
        [self.contentView addSubview:self.backView3];
        
        
        self.img3 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.backView3.frame.size.width,self.backView3.frame.size.width*74/115)];
        self.img3.image = [UIImage imageNamed:@"img_message_photo"];
        [self.backView3 addSubview:self.img3];
        
        self.priceLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(8, self.img3.frame.origin.y+self.img3.frame.size.height+5, 70, 15)];
        self.priceLabel3.textColor = [BBSColor hexStringToColor:@"ff5b5c"];
        self.priceLabel3.font = [UIFont systemFontOfSize:14];
        [self.backView3 addSubview:self.priceLabel3];
        
        self.priceMark3 =[[DeleteLineLabel alloc]initWithFrame:CGRectMake(self.backView3.frame.size.width-35-5, self.priceLabel3.frame.origin.y+3, 35, 10)];
        
        self.priceMark3.font = [UIFont systemFontOfSize:10];
        self.priceMark3.textColor = [BBSColor hexStringToColor:@"999999"];
        
        self.priceMark3.textAlignment = NSTextAlignmentRight;
        [self.backView3 addSubview:self.priceMark3];
        
        self.userNameLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(0, self.img3.frame.origin.y+self.img3.frame.size.height+5, self.backView3.frame.size.width, 15)];
        self.userNameLabel3.textColor = [BBSColor hexStringToColor:@"212121"];
        self.userNameLabel3.font = [UIFont systemFontOfSize:13];
        self.userNameLabel3.textAlignment = NSTextAlignmentCenter;
        [self.backView3 addSubview:self.userNameLabel3];
        
    }
    return self;
}
-(void)resetWidth1:(NSString *)content{
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[content boundingRectWithSize:CGSizeMake(35, 10) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float width = size.width;
    if (width > 30) {
        width = width+7;
        if (width > 40) {
            width = 40;
        }
    }else{
        width = size.width;
    }
    self.priceMark1.frame = CGRectMake(self.backView1.frame.size.width-width-5, self.priceLabel1.frame.origin.y+2, width, 10);
    
}
-(void)resetWidth2:(NSString *)content{
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[content boundingRectWithSize:CGSizeMake(35, 10) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float width = size.width;
    if (width > 30) {
        width = width+7;
        if (width > 40) {
            width = 40;
        }
    }else{
        width = size.width;
    }
    self.priceMark2.frame = CGRectMake(self.backView2.frame.size.width-width-5, self.priceLabel2.frame.origin.y+2, width, 10);
}
-(void)resetWidth3:(NSString *)content{
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:10],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[content boundingRectWithSize:CGSizeMake(35, 10) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float width = size.width;
    if (width > 30) {
        width = width+7;
        if (width > 40) {
            width = 40;
        }
    }else{
        width = size.width;
    }
    self.priceMark3.frame = CGRectMake(self.backView3.frame.size.width-width-5, self.priceLabel2.frame.origin.y+2, width, 10);
}

-(void)resetFrameWithDescribeContent:(NSString *)content{
    
    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize size=[content boundingRectWithSize:CGSizeMake(self.describleLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
    float height=size.height;
    if (size.height>17.900391) {
        height=37;
    self.imgArrow.frame = CGRectMake(self.describleLabel.frame.origin.x+self.describleLabel.frame.size.width+7, 12+9, 38,13);
    
    }else{
        height = 18;
    self.imgArrow.frame = CGRectMake(self.describleLabel.frame.origin.x+self.describleLabel.frame.size.width+7, 12, 38,13);
    }
    self.describleLabel.frame=CGRectMake(10, 11,SCREENWIDTH-20-47, height);
    self.backView1.frame =CGRectMake(10, 11+height+8, (SCREENWIDTH-20-5)/3, (self.backView1.frame.size.width*74/115)+5+15+5);
    self.backView2.frame =CGRectMake(self.backView1.frame.origin.x+self.backView1.frame.size.width+2.5, 11+height+8, (SCREENWIDTH-20-5)/3, self.backView1.frame.size.width*74/115+5+15+5);
    self.backView3.frame =CGRectMake(self.backView2.frame.origin.x+self.backView1.frame.size.width+2.5, 11+height+8, (SCREENWIDTH-20.5-5)/3,self.backView1.frame.size.width*74/115+5+15+5);
}
-(void)hideSomeControlsIsOrNo:(BOOL)isHide{
    if (isHide==YES) {
        self.userNameLabel1.hidden = YES;
        self.priceLabel1.hidden = NO;
        self.priceMark1.hidden = NO;
        
        self.userNameLabel2.hidden = YES;
        self.priceLabel2.hidden = NO;
        self.priceMark2.hidden = NO;
        
        self.userNameLabel3.hidden = YES;
        self.priceLabel3.hidden = NO;
        self.priceMark3.hidden = NO;
        
    }else{
        self.priceLabel1.hidden = YES;
        self.priceMark1.hidden = YES;
        self.userNameLabel1.hidden = NO;
        self.priceLabel2.hidden = YES;
        self.priceMark2.hidden = YES;
        self.userNameLabel2.hidden = NO;
        self.priceLabel3.hidden = YES;
        self.priceMark3.hidden = YES;
        self.userNameLabel3.hidden = NO;

        
    }
}


@end
