//
//  StoreListMyshowCell.m
//  BabyShow
//
//  Created by WMY on 15/11/13.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "StoreListMyshowCell.h"

@implementation StoreListMyshowCell

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
        self.contentView.backgroundColor = [BBSColor hexStringToColor:@"e6e6e6"];
       // [UILabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        
        self.imgBack = [[UIImageView alloc]initWithFrame:CGRectMake(0, 8, SCREENWIDTH, 45)];
        self.imgBack.image = [UIImage imageNamed:@"img_myshow_back"];
        [self.contentView addSubview:self.imgBack];
        
        self.selectLine = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 3, 17)];
        self.selectLine.backgroundColor = [BBSColor hexStringToColor:@"ffffff"];
        [self.imgBack addSubview:self.selectLine];
        
        self.selectionName = [[UILabel alloc]initWithFrame:CGRectMake(7, self.selectLine.frame.origin.y, 140, 16)];
        [self.selectionName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15]];
        //self.selectionName.font = [UIFont systemFontOfSize:15];
        self.selectionName.textColor = [BBSColor hexStringToColor:@"ffffff"];
        self.selectionName.text = @"附近值得去";
        [self.imgBack addSubview:self.selectionName];
        
        self.subLabel = [[UILabel alloc]initWithFrame:CGRectMake(7, self.selectionName.frame.origin.y+self.selectionName.frame.size.height+3, 200, 11)];
        [self.subLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10]];
        self.subLabel.textColor = [BBSColor hexStringToColor:@"ffffff"];
        self.subLabel.text = @"汇集最全的商业新消息较大";
        [self.imgBack addSubview:self.subLabel];
        
        
        _arrowImg = [[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-19,18, 8, 14)];
        _arrowImg.image = [UIImage imageNamed:@"img_myshow_arrowmyshow"];
        [self.imgBack addSubview:_arrowImg];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,  self.imgBack.frame.origin.y+self.imgBack.frame.size.height, SCREENWIDTH, 232-self.imgBack.frame.origin.y-self.imgBack.frame.size.height+2)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        
        
        _storeImg1 = [[UIImageView alloc]initWithFrame:CGRectMake(6, 0,152.5, 152.5)];
        _storeImg1 .userInteractionEnabled = YES;
        _storeImg1 .image = [UIImage imageNamed:@"s"];
        [backView addSubview:_storeImg1];
        
        _storeImg2 = [[UIImageView alloc]initWithFrame:CGRectMake(161,_storeImg1.frame.origin.y,152.5, 152.5)];
        _storeImg2 .userInteractionEnabled = YES;
        _storeImg2 .image = [UIImage imageNamed:@"img_message_photo"];
        [backView addSubview:_storeImg2];

        
        _priceBackView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 123,152.5 , 30)];
        _priceBackView1.image = [UIImage imageNamed:@"img_myshownew_backview"];
        [_storeImg1 addSubview:_priceBackView1];
        _priceBackView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 123,152.5 , 30)];
        _priceBackView2.image = [UIImage imageNamed:@"img_myshownew_backview"];
        [_storeImg2 addSubview:_priceBackView2];

        
        _priceBaby1= [[UILabel alloc]initWithFrame:CGRectMake(7, 5, 35, 19)];
        _priceBaby1.text = @"秀秀价";
        _priceBaby1.font = [UIFont systemFontOfSize: 10];
        _priceBaby1.textColor = [UIColor whiteColor];
       // [_priceBackView1 addSubview:_priceBaby1];
        _priceBaby2= [[UILabel alloc]initWithFrame:CGRectMake(7, 5, 35, 19)];
        _priceBaby2.text = @"秀秀价";
        _priceBaby2.font = [UIFont systemFontOfSize: 10];
        _priceBaby2.textColor = [UIColor whiteColor];
        //[_priceBackView2 addSubview:_priceBaby2];

        
        _priceShow1 = [[UILabel alloc]initWithFrame:CGRectMake(14, 8, 90, 20)];
        _priceShow1.textColor = [BBSColor hexStringToColor:@"ff5e5e"];
        _priceShow1.font = [UIFont systemFontOfSize:16];
        _priceShow1.text = @"";
        [_priceBackView1 addSubview:_priceShow1];
        
        _priceShow2 = [[UILabel alloc]initWithFrame:CGRectMake(14, 8, 90, 20)];
        _priceShow2.textColor = [BBSColor hexStringToColor:@"ff5e5e"];
        _priceShow2.font = [UIFont systemFontOfSize:16];
        _priceShow2.text = @"";
        [_priceBackView2 addSubview:_priceShow2];

        
        _priceMarkt1 = [[UILabel alloc]initWithFrame:CGRectMake(153-80, _priceShow1.frame.origin.y, 48, 19)];
        _priceMarkt1.text = @"门店价：";
        _priceMarkt1.font = [UIFont systemFontOfSize:12];
        _priceMarkt1.textColor = [UIColor whiteColor];
        [_priceBackView1 addSubview:_priceMarkt1];
        
        _priceMarkD1 = [[DeleteLineLabel alloc]initWithFrame:CGRectMake(_priceMarkt1.frame.origin.x+40, _priceMarkt1.frame.origin.y, 45, 19)];
        _priceMarkD1.font = [UIFont systemFontOfSize:10];
        _priceMarkD1.textColor = [UIColor whiteColor];
        [_priceBackView1 addSubview:_priceMarkD1];
        
        _priceMarkt2 = [[UILabel alloc]initWithFrame:CGRectMake(153-80, _priceShow2.frame.origin.y,48, 19)];
        _priceMarkt2.text = @"门店价：";
        _priceMarkt2.font = [UIFont systemFontOfSize:12];
        _priceMarkt2.textColor = [UIColor whiteColor];
        [_priceBackView2 addSubview:_priceMarkt2];
        
        _priceMarkD2 = [[DeleteLineLabel alloc]initWithFrame:CGRectMake(_priceMarkt2.frame.origin.x+40, _priceMarkt2.frame.origin.y, 45, 19)];
        _priceMarkD2.font = [UIFont systemFontOfSize:10];
        _priceMarkD2.textColor = [UIColor whiteColor];
        [_priceBackView2 addSubview:_priceMarkD2];

        
        _storeNameLabel1 = [[UILabel alloc]initWithFrame:CGRectMake(8, _storeImg1.frame.origin.y+_storeImg1.frame.size.height+4, _storeImg1.frame.size.width, 20)];
        _storeNameLabel1.font = [UIFont systemFontOfSize:12];
        _storeNameLabel1.text = @"完美试管";
        [backView addSubview:_storeNameLabel1];
        
        _storeNameLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(_storeImg2.frame.origin.x+2, _storeImg1.frame.origin.y+_storeImg1.frame.size.height+4, _storeImg1.frame.size.width, 20)];
        _storeNameLabel2.font = [UIFont systemFontOfSize:12];
        _storeNameLabel2.text = @"完美试管";
        [backView addSubview:_storeNameLabel2];
        
        _imgUpBack= [[UIImageView alloc]initWithFrame:CGRectMake(0, 232+2, SCREENWIDTH, 6)];
        _imgUpBack.image = [UIImage imageNamed:@"img_myshow_upback"];
        [self.contentView addSubview:_imgUpBack];
        
   
    }
    
    return self;
}

@end
