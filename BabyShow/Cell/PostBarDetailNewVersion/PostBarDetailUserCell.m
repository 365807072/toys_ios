//
//  PostBarDetailUserCell.m
//  BabyShow
//
//  Created by Monica on 10/23/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarDetailUserCell.h"

@implementation PostBarDetailUserCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        CGRect avatarViewFrame=CGRectMake(6, 4, 33, 33);
        CGRect nameLabelFrame=CGRectMake(44, 4, 200, 33);
        CGRect timeLabelFrame=CGRectMake(SCREENWIDTH-6-60, 4, 60, 33);
        
        self.avatarView=[[UIImageView alloc]initWithFrame:avatarViewFrame];
        self.avatarView.layer.masksToBounds=YES;
        self.avatarView.layer.cornerRadius=16.5;
        [self.contentView addSubview:self.avatarView];
    
        self.nameLabel=[[UILabel alloc]initWithFrame:nameLabelFrame];
        self.nameLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:15];
        self.nameLabel.textColor=[BBSColor hexStringToColor:BACKCOLOR];
        [self.contentView addSubview:self.nameLabel];
        
        self.timeLabel=[[UILabel alloc]initWithFrame:timeLabelFrame];
        self.timeLabel.font=[UIFont systemFontOfSize:11];
        self.timeLabel.textColor=[BBSColor hexStringToColor:@"#959595"];
        self.timeLabel.textAlignment=NSTextAlignmentRight;
        [self.contentView addSubview:self.timeLabel];
    
    }
    return self;
}

@end
