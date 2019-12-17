//
//  PhotoCell.m
//  BabyShow
//
//  Created by Lau on 6/4/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PBPhotoCell.h"

@implementation PBPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect imgFrame1=CGRectMake(0, 0, 100, 100);
        CGRect imgFrame2=CGRectMake(105, 0, 100, 100);
        CGRect imgFrame3=CGRectMake(210, 0, 100, 100);
        CGRect labelFrame=CGRectMake(270, 80, 40, 20);
        

        self.imgView1=[[UIImageView alloc]initWithFrame:imgFrame1];
        [self.groundview addSubview:self.imgView1];
        
        self.imgView2=[[UIImageView alloc]initWithFrame:imgFrame2];
        [self.groundview addSubview:self.imgView2];
        
        self.imgView3=[[UIImageView alloc]initWithFrame:imgFrame3];
        [self.groundview addSubview:self.imgView3];
        
        self.imgViewArray=[[NSArray alloc]initWithObjects:self.imgView1,self.imgView2,self.imgView3, nil];
        
        self.countLabel=[[UILabel alloc]initWithFrame:labelFrame];
        self.countLabel.backgroundColor=[UIColor blackColor];
        self.countLabel.textColor=[UIColor whiteColor];
        self.countLabel.alpha=0.5;
        self.countLabel.font=[UIFont systemFontOfSize:11];
        self.countLabel.text=@"张数";
        self.countLabel.textAlignment=NSTextAlignmentRight;
        [self.groundview addSubview:self.countLabel];
        
    }
    return self;
}

- (void)awakeFromNib
{
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
