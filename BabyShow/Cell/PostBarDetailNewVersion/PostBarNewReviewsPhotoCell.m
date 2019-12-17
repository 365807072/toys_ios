//
//  PostBarNewReviewsPhotoCell.m
//  BabyShow
//
//  Created by WMY on 16/4/22.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarNewReviewsPhotoCell.h"

@implementation PostBarNewReviewsPhotoCell

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
        self.btn1 = [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.btn1.frame = CGRectMake(15*0.6*2+32, 0, (SCREENWIDTH-15*0.6*3-32-15)/4, (SCREENWIDTH-15*0.6*3-32-15)/4);
        [self.btn1 addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn1];
        
        self.btn2 = [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.btn2.frame = CGRectMake(15*0.6*2+32+self.btn1.frame.size.width+5, 0, (SCREENWIDTH-15*0.6*3-32-15)/4, (SCREENWIDTH-15*0.6*3-32-15)/4);
        [self.btn2 addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn2];
        
        self.btn3 = [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.btn3.frame = CGRectMake(self.btn2.frame.origin.x+self.btn1.frame.size.width+5, 0, (SCREENWIDTH-15*0.6*3-32-15)/4, (SCREENWIDTH-15*0.6*3-32-15)/4);
        [self.btn3 addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn3];
        
        self.btn4 = [btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.btn4.frame = CGRectMake(self.btn3.frame.origin.x+self.btn1.frame.size.width+5, 0, (SCREENWIDTH-15*0.6*3-32-15)/4, (SCREENWIDTH-15*0.6*3-32-15)/4);
        [self.btn4 addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn4];



        
    }
    return self;
}
-(void)OnClick:(btnWithIndexPath *)btn{
    
    if ([self.delegate respondsToSelector:@selector(gotoDetailPhotos:)]) {
        [self.delegate gotoDetailPhotos:btn];
    }
    
}

@end
