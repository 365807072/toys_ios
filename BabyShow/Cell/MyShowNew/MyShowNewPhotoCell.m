//
//  MyShowNewPhotoCell.m
//  BabyShow
//
//  Created by Monica on 9/22/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyShowNewPhotoCell.h"

@implementation MyShowNewPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect frame1=CGRectMake(1.5, 1.5, 157, 157);
        CGRect frame2=CGRectMake(161.5, 1.5, 157, 157);
        
        self.btn1=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.btn1.frame=frame1;
        [self.btn1 addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn1];
        
        self.btn2=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.btn2.frame=frame2;
        [self.btn2 addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.btn2];
        
        CGRect imgviewFrame=CGRectMake(108, 129.5, 44, 19.5);
        self.imageview=[[UIImageView alloc]initWithFrame:imgviewFrame];
        self.imageview.image=[UIImage imageNamed:@"img_myshownew_countlabel_background"];
        [self.btn2 addSubview:self.imageview];
        
        CGRect countLabelFrame=CGRectMake(0, 0, 40, 19.5);
        self.countLabel=[[UILabel alloc]initWithFrame:countLabelFrame];
        self.countLabel.font=[UIFont systemFontOfSize:10];
        self.countLabel.textColor=[UIColor whiteColor];
        self.countLabel.textAlignment=NSTextAlignmentRight;
        [self.imageview addSubview:self.countLabel];
        
        self.btnArry=[NSArray arrayWithObjects:self.btn1,self.btn2, nil];
        
        self.contentView.backgroundColor=[UIColor clearColor];
        
    }
    return self;
}

-(void)OnClick:(btnWithIndexPath *)btn{
    
    if ([self.delegate respondsToSelector:@selector(gotoTheDetail:)]) {
        [self.delegate gotoTheDetail:btn];
    }
    
}


@end
