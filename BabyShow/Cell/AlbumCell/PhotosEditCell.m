//
//  PhotosEditCell.m
//  BabyShow
//
//  Created by Lau on 5/7/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PhotosEditCell.h"

@implementation PhotosEditCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect photoViewFrame=CGRectMake(10, 10, 100, 100);
        
        CGRect titleFieldFrame=CGRectMake(126, 10, 100, 32.5);
        CGRect titleShadowFrame=CGRectMake(126, 42.5, 182, 0.5);
        
        CGRect areaFieldFrame=CGRectMake(126, 43, 100, 41.5);
        CGRect areaShadowFrame=CGRectMake(126, 84.5, 146, 0.5);

        CGRect timeFieldFrame=CGRectMake(126, 85, 100, 24.5);
        CGRect timeShadowFrame=CGRectMake(126, 109.5, 146, 0.5);
        
        CGRect seperateViewFrame=CGRectMake(0, 119.5, 320, 0.5);
        
        UIImage *shadowImageShort=[UIImage imageNamed:@"img_photos_edit_shadowline_short.png"];
        UIImage *shadowImageLong=[UIImage imageNamed:@"img_photos_edit_shadowline_long.png"];
        UIImage *seperateImage=[UIImage imageNamed:@"img_photos_edit_seperateline"];

        self.photoView=[[UIImageView alloc]initWithFrame:photoViewFrame];
        self.photoView.backgroundColor=[UIColor grayColor];
        [self.contentView addSubview:self.photoView];
        
        self.titleField=[[PhotosEditTextField alloc]initWithFrame:titleFieldFrame];
        self.titleField.placeholder=@"标题";
        self.titleField.textColor=[BBSColor hexStringToColor:@"#b4a48f"];
        self.titleField.font=[UIFont systemFontOfSize:15];
        self.titleField.contentVerticalAlignment=UIControlContentVerticalAlignmentBottom;
        self.titleField.delegate=self;
        [self.contentView addSubview:self.titleField];
    
        UIImageView *titleShadowView=[[UIImageView alloc]initWithFrame:titleShadowFrame];
        titleShadowView.image=shadowImageLong;
        [self.contentView addSubview:titleShadowView];
        
        self.timeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.timeBtn.frame=timeFieldFrame;
        [self.timeBtn setTitle:@"时间" forState:UIControlStateNormal];
        [self.timeBtn setTitleColor:[BBSColor hexStringToColor:@"#b4a48f"] forState:UIControlStateNormal];
        self.timeBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        self.timeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        self.timeBtn.contentVerticalAlignment=UIControlContentVerticalAlignmentBottom;
        [self.timeBtn addTarget:self action:@selector(btnOnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.timeBtn];
        

        
//        self.timeField.placeholder=@"时间";
//        self.timeField.textColor=[BBSColor hexStringToColor:@"#b4a48f"];
//        self.timeField.font=[UIFont systemFontOfSize:14];
//        self.timeField.contentVerticalAlignment=UIControlContentVerticalAlignmentBottom;
//        [self.contentView addSubview:self.timeField];
        
        UIImageView *timeShadowView=[[UIImageView alloc]initWithFrame:timeShadowFrame];
        timeShadowView.image=shadowImageShort;
        [self.contentView addSubview:timeShadowView];
        
        self.areaField=[[PhotosEditTextField alloc]initWithFrame:areaFieldFrame];
        self.areaField.placeholder=@"地点";
        self.areaField.textColor=[BBSColor hexStringToColor:@"#b4a48f"];
        self.areaField.font=[UIFont systemFontOfSize:14];
        self.areaField.contentVerticalAlignment=UIControlContentVerticalAlignmentBottom;
        self.areaField.delegate=self;
        [self.contentView addSubview:self.areaField];
        
        UIImageView *areaShadowView=[[UIImageView alloc]initWithFrame:areaShadowFrame];
        areaShadowView.image=shadowImageShort;
        [self.contentView addSubview:areaShadowView];
        
        self.seperateView=[[UIImageView alloc]initWithFrame:seperateViewFrame];
        self.seperateView.image=seperateImage;
        [self.contentView addSubview:self.seperateView];
    
        
        self.backgroundColor=[UIColor whiteColor];
        self.contentView.backgroundColor=[UIColor whiteColor];
        
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

-(void)btnOnClick:(UIButton *) sender{
    
    if([self.delegate respondsToSelector:@selector(timeBtnOnClick:)]){
        
        [self.delegate timeBtnOnClick:sender];
        
    }
    
}



-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    int maxLenth;
    
    if (textField==self.titleField) {
        
        maxLenth=6;
        if (textField.text.length>maxLenth) {
            
            NSString *message=[NSString stringWithFormat:@"标题最多只能写%d个字",maxLenth];
            [BBSAlert showAlertWithContent:message andDelegate:self.superview];
            
            return NO;
            
        }
        
    }else {
        
        maxLenth=4;
        if (textField.text.length>maxLenth) {
            
            NSString *message=[NSString stringWithFormat:@"地点最多只能写%d个字",maxLenth];
            [BBSAlert showAlertWithContent:message andDelegate:self.superview];
            
            return NO;
            
        }
        
    }
    
    return YES;
    
}

@end
