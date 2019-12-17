//
//  ThemeAlbumCell.m
//  BabyShow
//
//  Created by Mayeon on 14-4-8.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ThemeAlbumCell.h"

@implementation ThemeAlbumCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier imageArray:(NSArray *)imageArray
//{
//    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        for (int i = 0; i < imageArray.count; i++) {
//            NSDictionary *imageInfo = [imageArray objectAtIndex:i];
//        }
//    }
//    return self;
//}
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
