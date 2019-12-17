//
//  MyShowImgCell.m
//  BabyShow
//
//  Created by Lau on 3/24/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "MyShowImgCell.h"


static float seperateSpace = 5.0;
static float imgWidth      = 100.0;
@implementation MyShowImgCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.imgArray=[[NSMutableArray alloc]init];
        
        CGRect frameV1=CGRectMake(seperateSpace, seperateSpace, imgWidth, imgWidth);
        CGRect frameV2=CGRectMake(seperateSpace*2 + imgWidth, seperateSpace, imgWidth, imgWidth);
        CGRect frameV3=CGRectMake(seperateSpace*3 + 2*imgWidth, seperateSpace, imgWidth, imgWidth);
        
        CGRect frameV4=CGRectMake(seperateSpace, seperateSpace*2+imgWidth, imgWidth, imgWidth);
        CGRect frameV5=CGRectMake(seperateSpace*2 + imgWidth, seperateSpace*2+imgWidth, imgWidth, imgWidth);
        CGRect frameV6=CGRectMake(seperateSpace*3 + 2*imgWidth, seperateSpace*2+imgWidth, imgWidth, imgWidth);
        
        UIImage *holdImg=[UIImage imageNamed:@"img_message_photo.png"];
        
        self.imgView1=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.imgView1.frame=frameV1;
        [self.imgView1 setBackgroundImage:holdImg forState:UIControlStateNormal];
        self.imgView1.tag=0;
        [self.imgView1 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.imgView1];
        
        self.imgView2=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.imgView2.frame=frameV2;
        [self.imgView2 setBackgroundImage:holdImg forState:UIControlStateNormal];
        self.imgView2.tag=1;
        [self.imgView2 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.imgView2];

        
        self.imgView3=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.imgView3.frame=frameV3;
        [self.imgView3 setBackgroundImage:holdImg forState:UIControlStateNormal];
        self.imgView3.tag=2;
        [self.imgView3 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.imgView3];
        
        self.imgView4=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.imgView4.frame=frameV4;
        [self.imgView4 setBackgroundImage:holdImg forState:UIControlStateNormal];
        self.imgView4.tag=3;
        [self.imgView4 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.imgView4];
        
        self.imgView5=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.imgView5.frame=frameV5;
        [self.imgView5 setBackgroundImage:holdImg forState:UIControlStateNormal];
        self.imgView5.tag=4;
        [self.imgView5 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.imgView5];
        
        
        self.imgView6=[btnWithIndexPath buttonWithType:UIButtonTypeCustom];
        self.imgView6.frame=frameV6;
        [self.imgView6 setBackgroundImage:holdImg forState:UIControlStateNormal];
        self.imgView6.tag=5;
        [self.imgView6 addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.imgView6];
        
        self.imgView1.hidden=YES;
        self.imgView2.hidden=YES;
        self.imgView3.hidden=YES;
        self.imgView4.hidden=YES;
        self.imgView5.hidden=YES;
        self.imgView6.hidden=YES;

        // Initialization code
    }
    return self;
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

-(void)onClick:(btnWithIndexPath *) sender{
    
    
    self.selectedIndex=sender.tag;
    
    if ([self.delegate respondsToSelector:@selector(imgViewOnClick:)]) {
        [self.delegate imgViewOnClick:sender];
    }
    
}

@end
