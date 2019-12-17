//
//  PBTopPhotoCell.m
//  BabyShow
//
//  Created by Lau on 6/6/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PBTopPhotoCell.h"

@implementation PBTopPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.photoView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 95)];
        [self.contentView addSubview:self.photoView];

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
