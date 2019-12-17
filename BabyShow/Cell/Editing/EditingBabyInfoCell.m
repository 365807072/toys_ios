//
//  EditingBabyInfoCell.m
//  BabyShow
//
//  Created by 于 晓波 on 1/12/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "EditingBabyInfoCell.h"

@implementation EditingBabyInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLabel=[[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 30)];
        self.titleLabel.font=[UIFont systemFontOfSize:14];
        [self.contentView addSubview:self.titleLabel];
        
        self.contentLabel=[[UILabel alloc]initWithFrame:CGRectMake(110, 10, 180, 30)];
        self.contentLabel.font=[UIFont systemFontOfSize:14];
        self.contentLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.contentLabel];
        
        self.backTF = [[UITextField alloc]initWithFrame:CGRectMake(110, 10, 180, 30)];
        self.backTF.font=[UIFont systemFontOfSize:14];
        self.backTF.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.backTF];
        
    
        UIImageView *seperateView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 49.5, 320, 0.5)];
        seperateView.backgroundColor=[BBSColor hexStringToColor:@"b7b7b7"];
        [self.contentView addSubview:seperateView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
