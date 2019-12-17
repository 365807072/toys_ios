//
//  MyOutPutGroupImgCell.m
//  BabyShow
//
//  Created by Monica on 9/17/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyOutPutGroupImgCell.h"

@implementation MyOutPutGroupImgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect frame1=CGRectMake(5, 5, 100, 100);
        CGRect frame2=CGRectMake(110, 5, 100, 100);
        CGRect frame3=CGRectMake(215, 5, 100, 100);
        
        CGRect frame4=CGRectMake(5, 110, 100, 100);
        CGRect frame5=CGRectMake(110, 110, 100, 100);
        CGRect frame6=CGRectMake(215, 110, 100, 100);
        
        self.btn1=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.btn1.frame=frame1;
        self.btn1.tag=0;
        [self.btn1 addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn1];
        
        self.btn2=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.btn2.frame=frame2;
        self.btn2.tag=1;
        [self.btn2 addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn2];
        
        self.btn3=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.btn3.frame=frame3;
        self.btn3.tag=2;
        [self.btn3 addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn3];
        
        self.btn4=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.btn4.frame=frame4;
        self.btn4.tag=3;
        [self.btn4 addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn4];
        
        self.btn5=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.btn5.frame=frame5;
        self.btn5.tag=4;
        [self.btn5 addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn5];
        
        self.btn6=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.btn6.frame=frame6;
        self.btn6.tag=5;
        [self.btn6 addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn6];
        
        self.btnArry=[NSArray arrayWithObjects:self.btn1,self.btn2,self.btn3,self.btn4,self.btn5,self.btn6, nil];
        
        self.backgroundColor=[UIColor clearColor];
        self.contentView.backgroundColor=[UIColor clearColor];
        
    }
    return self;
}

-(void)OnClick:(btnWithIndexPath *) btn{
    if ([self.delegate respondsToSelector:@selector(SeeTheDetailOfThePhoto:)]) {
        [self.delegate SeeTheDetailOfThePhoto:btn];
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
