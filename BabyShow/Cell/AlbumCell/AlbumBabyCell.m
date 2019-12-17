//
//  AlbumBabyCell.m
//  BabyShow
//
//  Created by Mayeon on 14-3-26.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "AlbumBabyCell.h"

@implementation AlbumBabyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect leftFrame = CGRectMake(33, 7.5+2.5, 106, 106);
        CGRect leftBackFrame = CGRectMake(6.5, 0+2.5, 148, 126);
        CGRect leftLabelFrame = CGRectMake(0, 126.5+2.5, 160, 20);
        
        CGRect rightFrame = CGRectMake(191, 7.5+2.5, 106, 106);
        CGRect rightBackFrame = CGRectMake(164.5,0+2.5, 148, 126);
        CGRect rightLabelFrame = CGRectMake(160, 126.5+2.5, 160, 20);
        
        UIFont *font = [UIFont systemFontOfSize:15.0];
        self.backgroundColor = [UIColor clearColor];
        
        self.leftImageView = [[UIImageView alloc]initWithFrame:leftFrame];
        self.leftImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.leftImageView];
        
        self.leftAlbumNameLabel = [[UILabel alloc]initWithFrame:leftLabelFrame];
        self.leftAlbumNameLabel.textAlignment = NSTextAlignmentCenter;
        self.leftAlbumNameLabel.backgroundColor =[UIColor clearColor];
        self.leftAlbumNameLabel.textColor = [BBSColor hexStringToColor:kAlbum_Color];
        self.leftAlbumNameLabel.font = font;
        [self.contentView addSubview:self.leftAlbumNameLabel];
        
        self.rightImageView = [[UIImageView alloc]initWithFrame:rightFrame];
        self.rightImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.rightImageView];
        
        self.rightAlbumNameLabel = [[UILabel alloc]initWithFrame:rightLabelFrame];
        self.rightAlbumNameLabel.backgroundColor =[UIColor clearColor];
        self.rightAlbumNameLabel.textColor = [BBSColor hexStringToColor:kAlbum_Color];
        self.rightAlbumNameLabel.textAlignment = NSTextAlignmentCenter;
        self.rightAlbumNameLabel.font = font;
        [self.contentView addSubview:self.rightAlbumNameLabel];
        
        self.leftBackGroundImageView = [[ImageView alloc]initWithFrame:leftBackFrame];
        self.leftBackGroundImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.leftBackGroundImageView];
        
        self.rightBackGroundImageView = [[ImageView alloc]initWithFrame:rightBackFrame];
        self.rightBackGroundImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.rightBackGroundImageView];
        
        UITapGestureRecognizer *tapGes1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        UITapGestureRecognizer *tapGes2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        
        [self.leftBackGroundImageView addGestureRecognizer:tapGes1];
        [self.rightBackGroundImageView addGestureRecognizer:tapGes2];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - UITapGestureRecognizer Methods
-(void)tapImageView:(UITapGestureRecognizer *)tapGes{
    ImageView *imageView  = (ImageView *)tapGes.view;
    if ([self.delegate respondsToSelector:@selector(selectAlbumInfo:cell:isLeft:)]) {
        [self.delegate selectAlbumInfo:imageView.imageInfo cell:self isLeft:YES];
    }
}
@end
