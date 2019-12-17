//
//  ToyListNewCell.m
//  BabyShow
//
//  Created by WMY on 17/1/11.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ToyListNewCell.h"
#import "WMYLabel.h"

@implementation ToyListNewCell

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
        self.contentView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        
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
        //self.arrowImg.backgroundColor = [UIColor redColor];
        
        
        UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 33, SCREENWIDTH, 1)];
        lineView.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [self.headView addSubview:lineView];
                //1
        
        self.toyView1 = [UIButton buttonWithType:UIButtonTypeCustom];
        
        self.toyView1.frame = CGRectMake(0, 34, SCREEN_WIDTH/3, SCREEN_WIDTH/3*1.3);
        [self.contentView addSubview:self.toyView1];
        
        _storeImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(0 ,0,105, 95)];
        _storeImg1 .userInteractionEnabled = YES;
        _storeImg1.contentMode = UIViewContentModeScaleAspectFit;
        _storeImg1.clipsToBounds = YES;
        [self.toyView1 addSubview:_storeImg1];
        
        
        self.toyNameLabel1 =  [[WMYLabel alloc]initWithFrame:CGRectMake(10 , _storeImg1.frame.origin.y+_storeImg1.frame.size.height+5, SCREENWIDTH/3-17, 15)];
        self.toyNameLabel1.numberOfLines = 1;
        self.toyNameLabel1.textAlignment = NSTextAlignmentCenter;
        self.toyNameLabel1.lineBreakMode =NSLineBreakByCharWrapping;    //
        [self.toyNameLabel1 setVerticalAlignment:VerticalAlignmentTop];
        self.toyNameLabel1.font = [UIFont systemFontOfSize:11];
        self.toyNameLabel1.textColor = [BBSColor hexStringToColor:@"333333"];
        [self.toyView1 addSubview:self.toyNameLabel1];
        
        self.priceShow1 = [[UILabel alloc]initWithFrame:CGRectMake(3, self.toyNameLabel1.frame.origin.y+self.toyNameLabel1.frame.size.height+3, SCREENWIDTH/3-10, 17)];
        self.priceShow1.textColor = [BBSColor hexStringToColor:@"fc4c57"];
        self.priceShow1.font = [UIFont systemFontOfSize:11];
        self.priceShow1.textAlignment = NSTextAlignmentCenter;
        
        self.priceMarkt1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.priceMarkt1.textColor = [BBSColor hexStringToColor:@"fc4c57"];
        self.priceMarkt1.font = [UIFont systemFontOfSize:10];
        [self.toyView1 addSubview:self.priceShow1];
        UIView *lineView1= [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/3-1, 0, 1, self.toyView1.frame.size.height)];
        lineView1.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [self.toyView1 addSubview:lineView1];

        
        //2
        self.toyView2 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/3, self.toyView1.frame.origin.y, SCREENWIDTH/3,self.toyView1.frame.size.height)];
        [self.contentView addSubview:self.toyView2];
        _storeImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(_storeImg1.frame.origin.x, _storeImg1.frame.origin.y,_storeImg1.frame.size.width, _storeImg1.frame.size.height)];
        _storeImg2 .userInteractionEnabled = YES;
        _storeImg2.contentMode = UIViewContentModeScaleAspectFit;
        _storeImg2.clipsToBounds = YES;
        [self.toyView2 addSubview:_storeImg2];
        
        self.toyNameLabel2 =  [[WMYLabel alloc]initWithFrame:CGRectMake(_toyNameLabel1.frame.origin.x , _toyNameLabel1.frame.origin.y,_toyNameLabel1.frame.size.width, _toyNameLabel1.frame.size.height)];
        self.toyNameLabel2.numberOfLines = 1;
        self.toyNameLabel2.textAlignment = NSTextAlignmentCenter;
        self.toyNameLabel2.font = [UIFont systemFontOfSize:11];
        [self.toyNameLabel2 setVerticalAlignment:VerticalAlignmentTop];
        self.toyNameLabel2.lineBreakMode =NSLineBreakByCharWrapping;

        self.toyNameLabel2.textColor =  [BBSColor hexStringToColor:@"333333"];
        [self.toyView2 addSubview:self.toyNameLabel2];
        
        self.priceShow2 = [[UILabel alloc]initWithFrame:CGRectMake(_priceShow1.frame.origin.x , _priceShow1.frame.origin.y, _priceShow1.frame.size.width, _priceShow1.frame.size.height)];
        self.priceShow2.textColor = [BBSColor hexStringToColor:@"fc4c57"];
        self.priceShow2.font = [UIFont systemFontOfSize:11];
        self.priceShow2.textAlignment = NSTextAlignmentCenter;
        [self.toyView2 addSubview:self.priceShow2];

        UIView *lineView2= [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/3-1, 0, 1, self.toyView1.frame.size.height)];
        lineView2.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [self.toyView2 addSubview:lineView2];
        
        //3
        self.toyView3 = [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH*2/3, self.toyView1.frame.origin.y, SCREENWIDTH/3,self.toyView1.frame.size.height)];
        [self.contentView addSubview:self.toyView3];
        _storeImg3 = [[UIImageView alloc]initWithFrame:CGRectMake(_storeImg1.frame.origin.x, _storeImg1.frame.origin.y,_storeImg1.frame.size.width, _storeImg1.frame.size.height)];
        _storeImg3 .userInteractionEnabled = YES;
        _storeImg3.contentMode = UIViewContentModeScaleAspectFit;
        _storeImg3.clipsToBounds = YES;

        [self.toyView3 addSubview:_storeImg3];
        
        
        self.toyNameLabel3 =  [[WMYLabel alloc]initWithFrame:CGRectMake(_toyNameLabel1.frame.origin.x , _toyNameLabel1.frame.origin.y, _toyNameLabel1.frame.size.width, _toyNameLabel1.frame.size.height)];
        self.toyNameLabel3.numberOfLines = 1;
        self.toyNameLabel3.textAlignment = NSTextAlignmentCenter;
        self.toyNameLabel3.font = [UIFont systemFontOfSize:11];
        [self.toyNameLabel3 setVerticalAlignment:VerticalAlignmentTop];
        self.toyNameLabel3.lineBreakMode =NSLineBreakByCharWrapping;

        self.toyNameLabel3.textColor =  [BBSColor hexStringToColor:@"333333"];
        [self.toyView3 addSubview:self.toyNameLabel3];
        
        self.priceShow3 = [[UILabel alloc]initWithFrame:CGRectMake(_priceShow1.frame.origin.x , _priceShow1.frame.origin.y, _priceShow1.frame.size.width, _priceShow1.frame.size.height)];
        self.priceShow3.textColor = [BBSColor hexStringToColor:@"fc4c57"];
        self.priceShow3.font = [UIFont systemFontOfSize:11];
        self.priceShow3.textAlignment = NSTextAlignmentCenter;
        [self.toyView3 addSubview:self.priceShow3];
        
        UIView *lineView4= [[UIView alloc]initWithFrame:CGRectMake(SCREENWIDTH/3-1, 0, 1, 165)];
        lineView4.backgroundColor = [BBSColor hexStringToColor:@"f5f5f5"];
        [self.toyView3 addSubview:lineView4];
        self.toyView1.backgroundColor = [UIColor whiteColor];
        self.toyView2.backgroundColor = [UIColor whiteColor];
        self.toyView3.backgroundColor = [UIColor whiteColor];

        
        
    }
    return self;
}
@end
