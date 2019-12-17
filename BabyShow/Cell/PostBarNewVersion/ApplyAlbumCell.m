//
//  ApplyAlbumCell.m
//  BabyShow
//
//  Created by Monica on 11/10/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "ApplyAlbumCell.h"

@implementation ApplyAlbumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.isSelected = NO;

        
        UIImage *image = [UIImage imageNamed:@"btn_share_unselected"];
        CGRect albumNameLabelFrame = CGRectMake(25, 5, SCREENWIDTH-100, 40);
        CGRect checkImageFrame = CGRectMake(SCREENWIDTH - 30, (50-image.size.height)/2, image.size.width, image.size.height);
        
        self.albumNameLabel = [[UILabel alloc]initWithFrame:albumNameLabelFrame];
        self.albumNameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.albumNameLabel];
        
        self.checkImageView = [[UIImageView alloc]initWithFrame:checkImageFrame];
        self.checkImageView.backgroundColor = [UIColor clearColor];
        self.checkImageView.image = image;
        [self.contentView addSubview:self.checkImageView];
        
        UIView *seperatorView = [[UIView alloc]initWithFrame:CGRectMake(0, 49, SCREENWIDTH, 1)];
        seperatorView.backgroundColor = [BBSColor hexStringToColor:@"e1e4e5"];
        [self.contentView addSubview:seperatorView];
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

@end
