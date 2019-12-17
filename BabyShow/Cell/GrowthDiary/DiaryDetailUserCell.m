//
//  DiaryDetailUserCell.m
//  BabyShow
//
//  Created by Monica on 15-1-24.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import "DiaryDetailUserCell.h"

@implementation DiaryDetailUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGRect avatarViewFrame=CGRectMake(6, 4, 33, 33);
        CGRect nameLabelFrame=CGRectMake(44, 4, 150, 33);
        CGRect timeLabelFrame=CGRectMake(SCREENWIDTH-180, 4, 175, 33);
        
        self.avatarView=[[UIImageView alloc]initWithFrame:avatarViewFrame];
        self.avatarView.layer.masksToBounds=YES;
        self.avatarView.layer.cornerRadius=16.5;
        [self.contentView addSubview:self.avatarView];
        
        self.nameLabel=[[UILabel alloc]initWithFrame:nameLabelFrame];
        self.nameLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:15];
        self.nameLabel.textColor=[BBSColor hexStringToColor:BACKCOLOR];
        [self.contentView addSubview:self.nameLabel];
        
        self.timeLabel=[[UILabel alloc]initWithFrame:timeLabelFrame];
        self.timeLabel.font=[UIFont systemFontOfSize:13];
        self.timeLabel.textColor=[BBSColor hexStringToColor:@"#959595"];
        self.timeLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLabel];
        
        self.synchroImg=[[UIImageView alloc]initWithFrame:CGRectMake(SCREENWIDTH-31, 15, 18.5, 18.5)];
        self.synchroImg.image = [UIImage imageNamed:@"btn_unselect_pay"];
        [self.contentView addSubview:self.synchroImg];
        self.synchroImg.hidden = YES;
    }
    return self;
}
- (void)setChecked:(BOOL)checked{
    if (checked)
    {
        self.synchroImg.image = [UIImage imageNamed:@"btn_select_pay"];
        
    }
    else
    {
        self.synchroImg.image = [UIImage imageNamed:@"btn_unselect_pay"];
}
    isClick = checked;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
