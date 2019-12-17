//
//  ToySecondStyleCell.m
//  BabyShow
//
//  Created by 美美 on 2018/1/30.
//  Copyright © 2018年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToySecondStyleCell.h"

@implementation ToySecondStyleCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
        //头部
        self.headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 34)];
        self.headView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.headView];
        
        UIImageView *firstMark = [[UIImageView alloc]initWithFrame:CGRectMake(10, 9, 3, 15)];
        firstMark.image = [UIImage imageNamed:@"ToyFirstMark1"];
        [self.headView addSubview:firstMark];
        self.selectionName = [[UILabel alloc]initWithFrame:CGRectMake(18, 10, 300, 14)];
        self.selectionName.textColor = [BBSColor hexStringToColor:@"333333"];
        self.selectionName.font = [UIFont systemFontOfSize:11];
        [self.headView addSubview:self.selectionName];
        
        
        self.moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.moreButton.frame = CGRectMake(SCREENWIDTH-100, 0, 95, 34);
        [self.headView addSubview:self.moreButton];
        self.moreLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREENWIDTH-150 ,10, 145-15, 14)];
        self.moreLabel.font = [UIFont systemFontOfSize:11];
        self.moreLabel.textColor = RGBACOLOR(153, 153, 153, 1);
        self.moreLabel.textAlignment = NSTextAlignmentRight;
        [self.headView addSubview:self.moreLabel];
        
        self.arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-15, 11, 6, 11)];
        self.arrowImg.image = [UIImage imageNamed:@"arrowToy@3x"];
        [self.headView addSubview:self.arrowImg];
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 33, SCREENWIDTH, 1)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [self.headView addSubview:lineView];
        
        //第一个大图
        self.toyView1 =  [UIButton buttonWithType:UIButtonTypeCustom];
        self.toyView1.frame = CGRectMake(0, 34, SCREEN_WIDTH*0.42, SCREENWIDTH*0.52+28);
        self.toyView1.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.toyView1];
        UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH*0.42-1, 0, 1, self.toyView1.frame.size.height)];
        lineView2.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [self.toyView1 addSubview:lineView2];
        //第一个名称
        self.toyNameLabel1 = [[WMYLabel alloc]initWithFrame:CGRectMake(10, 10, 76, 40)];
        self.toyNameLabel1.textColor = [BBSColor hexStringToColor:@"333333"];
        self.toyNameLabel1.font = [UIFont systemFontOfSize:15];
        self.toyNameLabel1.numberOfLines = 2;
        self.toyNameLabel1.lineBreakMode =NSLineBreakByCharWrapping;

        [self.toyView1 addSubview:self.toyNameLabel1];
        
        self.priceShow1 = [[UILabel alloc]initWithFrame:CGRectMake(8, self.toyNameLabel1.frame.origin.y+self.toyNameLabel1.frame.size.height+2, 70, 17)];
        self.priceShow1.textColor = RGBACOLOR(253, 99, 99, 1);
        self.priceShow1.font = [UIFont systemFontOfSize:11];
        self.priceShow1.textAlignment = NSTextAlignmentLeft;
                [self.toyView1 addSubview:self.priceShow1];
        
        _storeImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(1, (self.toyView1.frame.size.height-50-20-121)/2+50+20,132, 120)];
        _storeImg1 .userInteractionEnabled = YES;
        _storeImg1.contentMode = UIViewContentModeScaleAspectFit;
        _storeImg1.backgroundColor = [UIColor whiteColor];
        _storeImg1.clipsToBounds = YES;
        [self.toyView1 addSubview:_storeImg1];
        
        //第二种
        self.toyView2 =  [UIButton buttonWithType:UIButtonTypeCustom];
        self.toyView2.frame = CGRectMake(self.toyView1.frame.size.width, self.toyView1.frame.origin.y, SCREENWIDTH-self.toyView1.frame.size.width, (self.toyView1.frame.size.height-28)/2);
        [self.contentView addSubview:self.toyView2];
        UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, self.toyView2.frame.size.height-1,self.toyView2.frame.size.width, 1)];
        lineView3.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [self.toyView2 addSubview:lineView3];
        
        self.toyNameLabel2 = [[WMYLabel alloc]initWithFrame:CGRectMake(10, 3, 76, 28)];
        self.toyNameLabel2.textColor = [BBSColor hexStringToColor:@"333333"];
        self.toyNameLabel2.font = [UIFont systemFontOfSize:11];
        self.toyNameLabel2.numberOfLines = 2;
        [self.toyView2 addSubview:self.toyNameLabel2];
        self.toyNameLabel2.lineBreakMode =NSLineBreakByCharWrapping;

        self.makeSureBtn = [[UIImageView alloc]initWithFrame: CGRectMake(self.toyNameLabel2.frame.origin.x, self.toyNameLabel2.frame.origin.y+self.toyNameLabel2.frame.size.height+2, 46, 20)];
        //self.makeSureBtn.frame = CGRectMake(self.toyNameLabel2.frame.origin.x, self.toyNameLabel2.frame.origin.y+self.toyNameLabel2.frame.size.height+2, 46, 20);
        self.makeSureBtn.image = [UIImage imageNamed:@"makSureRentToy@3x"];
        self.makeSureBtn.userInteractionEnabled = YES;

        [self.toyView2 addSubview:self.makeSureBtn];
        self.toyView2.backgroundColor = [UIColor  whiteColor];
        
        self.priceShow2 = [[UILabel alloc]initWithFrame:CGRectMake(self.toyNameLabel2.frame.origin.x, self.makeSureBtn.frame.origin.y+self.makeSureBtn.frame.size.height+2, 70, 17)];
        self.priceShow2.textColor = RGBACOLOR(253, 99, 99, 1);
        self.priceShow2.font = [UIFont systemFontOfSize:11];
        self.priceShow2.textAlignment = NSTextAlignmentLeft;
        [self.toyView2 addSubview:self.priceShow2];
        
        _storeImg2 = [[UIImageView alloc]initWithFrame:CGRectMake((self.toyView2.frame.size.width-self.toyNameLabel2.frame.size.width-self.toyNameLabel2.frame.origin.x-4-87)/2+self.toyNameLabel2.frame.origin.x+self.toyNameLabel2.frame.size.width+4,(self.toyView2.frame.size.height-79)/2,87, 79)];
        _storeImg2 .userInteractionEnabled = YES;
        _storeImg2.contentMode = UIViewContentModeScaleAspectFit;
        //_storeImg2.backgroundColor = [UIColor redColor];
        _storeImg2.clipsToBounds = YES;

        [self.toyView2 addSubview:_storeImg2];
        //第三种
        self.toyView3 =  [UIButton buttonWithType:UIButtonTypeCustom];
        self.toyView3.frame = CGRectMake(self.toyView1.frame.size.width, self.toyView2.frame.size.height+self.toyView2.frame.origin.y,(SCREENWIDTH-self.toyView1.frame.size.width)/2, self.toyView1.frame.size.height-self.toyView2.frame.size.height);
        self.toyView3.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.toyView3];
        UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(self.toyView3.frame.size.width-1, 0,1,self.toyView3.frame.size.height)];
        lineView4.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [self.toyView3 addSubview:lineView4];
        
        self.toyNameLabel3 = [[UILabel alloc]initWithFrame:CGRectMake(7, 3,_toyView3.frame.size.width-14, 13)];
        self.toyNameLabel3.textColor = [BBSColor hexStringToColor:@"333333"];
        self.toyNameLabel3.font = [UIFont systemFontOfSize:11];
        //self.toyNameLabel3.numberOfLines = 1;
        self.toyNameLabel3.lineBreakMode =NSLineBreakByCharWrapping;
        


        [self.toyView3 addSubview:self.toyNameLabel3];
        
        self.priceShow3 = [[UILabel alloc]initWithFrame:CGRectMake(self.toyNameLabel3.frame.origin.x, self.toyNameLabel3.frame.origin.y+self.toyNameLabel3.frame.size.height, self.toyNameLabel3.frame.size.width, 17)];
        self.priceShow3.textColor = RGBACOLOR(253, 99, 99, 1);
        self.priceShow3.font = [UIFont systemFontOfSize:11];
        self.priceShow3.textAlignment = NSTextAlignmentCenter;
        [self.toyView3 addSubview:self.priceShow3];
        
        _storeImg3 = [[UIImageView alloc]initWithFrame:CGRectMake((self.toyView3.frame.size.width-87)/2, (self.toyView3.frame.size.height-self.priceShow3.frame.origin.y-self.priceShow3.frame.size.height-79)/2+self.priceShow3.frame.origin.y+self.priceShow3.frame.size.height-2, 87, 79)];
        _storeImg3 .userInteractionEnabled = YES;
        _storeImg3.contentMode = UIViewContentModeScaleAspectFit;
        //_storeImg3.backgroundColor = [UIColor redColor];
        _storeImg3.clipsToBounds = YES;

        [self.toyView3 addSubview:_storeImg3];




       //第四种
        
        self.toyView4 =  [UIButton buttonWithType:UIButtonTypeCustom];
        self.toyView4.frame = CGRectMake(self.toyView3.frame.size.width+self.toyView3.frame.origin.x, self.toyView3.frame.origin.y, self.toyView3.frame.size.width, self.toyView3.frame.size.height);
        self.toyView4.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.toyView4];
        
        self.toyNameLabel4 = [[WMYLabel alloc]initWithFrame:CGRectMake(7, 3,_toyView3.frame.size.width-14, 15)];
        self.toyNameLabel4.textColor =[BBSColor hexStringToColor:@"333333"];
        self.toyNameLabel4.font = [UIFont systemFontOfSize:11];
        //self.toyNameLabel4.numberOfLines = 1;
        self.toyNameLabel4.lineBreakMode =NSLineBreakByCharWrapping;

        [self.toyView4 addSubview:self.toyNameLabel4];
        self.priceShow4 = [[UILabel alloc]initWithFrame:CGRectMake(self.toyNameLabel3.frame.origin.x, self.toyNameLabel3.frame.origin.y+self.toyNameLabel3.frame.size.height+2, self.toyNameLabel3.frame.size.width, 17)];
        self.priceShow4.textColor = RGBACOLOR(253, 99, 99, 1);
        self.priceShow4.font = [UIFont systemFontOfSize:11];
        self.priceShow4.textAlignment = NSTextAlignmentCenter;
        [self.toyView4 addSubview:self.priceShow4];
        _storeImg4 = [[UIImageView alloc]initWithFrame:CGRectMake((self.toyView3.frame.size.width-87)/2, (self.toyView3.frame.size.height-self.priceShow3.frame.origin.y-self.priceShow3.frame.size.height-79)/2+self.priceShow3.frame.origin.y+self.priceShow3.frame.size.height-1, 87, 79)];
        _storeImg4 .userInteractionEnabled = YES;
        _storeImg4.contentMode = UIViewContentModeScaleAspectFit;
       // _storeImg4.backgroundColor = [UIColor redColor];
        _storeImg4.clipsToBounds = YES;

        [self.toyView4 addSubview:_storeImg4];
        self.contentView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        
        
        
        
    }
    return self;
}
@end
