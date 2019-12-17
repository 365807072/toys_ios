//
//  AlbumDetailCell.m
//  BabyShow
//
//  Created by Mayeon on 14-3-26.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "AlbumDetailCell.h"

@implementation AlbumDetailCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        CGRect leftFrame = CGRectMake(30, 18, 106, 106);
        CGRect leftBackFrame = CGRectMake(20.5, 11.5-2.5, 124, 124);
        CGRect leftNameLabel = CGRectMake(0, 132, 160, 20);
        CGRect leftTimeLabel = CGRectMake(0, 155, 160, 15);
        CGRect leftSelect = CGRectMake(116, 18, 20, 20);

        CGRect rightFrame = CGRectMake(185.5, 18, 106, 106);
        CGRect rightBackFrame = CGRectMake(176.5, 11.5-2.5, 124, 124);
        CGRect rightNameLabel = CGRectMake(160, 132, 160, 20);
        CGRect rightTimeLabel = CGRectMake(160, 155, 160, 15);
        CGRect rightSelect = CGRectMake(271.5, 18, 20, 20);

        CGRect seperatorLineFrame = CGRectMake(0, 171, SCREENWIDTH, 1);
        
        self.backgroundColor = [UIColor clearColor];
        
        self.leftBackGroundImageView = [[ImageView alloc]initWithFrame:leftBackFrame];
        self.leftBackGroundImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.leftBackGroundImageView];
        
        self.rightBackGroundImageView = [[ImageView alloc]initWithFrame:rightBackFrame];
        self.rightBackGroundImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.rightBackGroundImageView];
        
        self.leftImageView = [[UIImageView alloc]initWithFrame:leftFrame];
        self.leftImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.leftImageView];
        
        self.leftSelectImageView = [[UIImageView alloc]initWithFrame:leftSelect];
        self.leftSelectImageView.backgroundColor = [UIColor clearColor];
        self.leftSelectImageView.hidden = YES;
        [self.contentView addSubview:self.leftSelectImageView];
        
        self.leftAlbumNameLabel = [[NIAttributedLabel alloc]initWithFrame:leftNameLabel];
        self.leftAlbumNameLabel.textAlignment = NSTextAlignmentCenter;
        self.leftAlbumNameLabel.backgroundColor =[UIColor clearColor];
        self.leftAlbumNameLabel.autoDetectLinks = NO;
        self.leftAlbumNameLabel.textColor = [BBSColor hexStringToColor:kAlbum_Color];
        self.leftAlbumNameLabel.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:self.leftAlbumNameLabel];
        
        self.leftCreateTimeLabel = [[UILabel alloc]initWithFrame:leftTimeLabel];
        self.leftCreateTimeLabel.backgroundColor =[UIColor clearColor];
        self.leftCreateTimeLabel.textColor = [BBSColor hexStringToColor:@"bbaf9b"];
        self.leftCreateTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.leftCreateTimeLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:self.leftCreateTimeLabel];
        
        self.rightImageView = [[UIImageView alloc]initWithFrame:rightFrame];
        self.rightImageView.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.rightImageView];
        
        self.rightSelectImageView = [[UIImageView alloc]initWithFrame:rightSelect];
        self.rightSelectImageView.backgroundColor = [UIColor clearColor];
        self.rightSelectImageView.hidden = YES;
        [self.contentView addSubview:self.rightSelectImageView];
        
        self.rightAlbumNameLabel = [[UILabel alloc]initWithFrame:rightNameLabel];
        self.rightAlbumNameLabel.backgroundColor =[UIColor clearColor];
        self.rightAlbumNameLabel.textColor = [BBSColor hexStringToColor:kAlbum_Color];
        self.rightAlbumNameLabel.textAlignment = NSTextAlignmentCenter;
        self.rightAlbumNameLabel.font = [UIFont systemFontOfSize:15.0];
        [self.contentView addSubview:self.rightAlbumNameLabel];
        
        self.rightCreateTimeLabel = [[UILabel alloc]initWithFrame:rightTimeLabel];
        self.rightCreateTimeLabel.backgroundColor =[UIColor clearColor];
        self.rightCreateTimeLabel.textColor = [BBSColor hexStringToColor:@"bbaf9b"];
        self.rightCreateTimeLabel.textAlignment = NSTextAlignmentCenter;
        self.rightCreateTimeLabel.font = [UIFont systemFontOfSize:12.0];
        [self.contentView addSubview:self.rightCreateTimeLabel];
        
        UITapGestureRecognizer *tapGes1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        UITapGestureRecognizer *tapGes2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageView:)];
        
        [self.leftBackGroundImageView addGestureRecognizer:tapGes1];
        [self.rightBackGroundImageView addGestureRecognizer:tapGes2];

        UIView *seperatorLine = [[UIView alloc]initWithFrame:seperatorLineFrame];
        seperatorLine.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"line"]];
        [self.contentView addSubview:seperatorLine];
                    
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
    BOOL isLeft = NO;//点击的是左侧还是右侧
    if ([imageView isEqual:self.leftBackGroundImageView]) {
        isLeft = YES;
    }else {
        isLeft = NO;
    }
    if ([self.delegate respondsToSelector:@selector(selectAlbumInfo:cell:isLeft:)]) {
        [self.delegate selectAlbumInfo:imageView.imageInfo cell:self isLeft:isLeft];
    }
}
@end
