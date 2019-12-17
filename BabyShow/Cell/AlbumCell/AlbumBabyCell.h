//
//  AlbumBabyCell.h
//  BabyShow
//
//  Created by Mayeon on 14-3-26.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumCell.h"
#import "ImageView.h"

@interface AlbumBabyCell :AlbumCell


@property (nonatomic ,strong)UIImageView   *leftImageView;
@property (nonatomic ,strong)ImageView *leftBackGroundImageView;
@property (nonatomic ,strong)UILabel     *leftAlbumNameLabel;

@property (nonatomic ,strong)UIImageView   *rightImageView;
@property (nonatomic ,strong)ImageView *rightBackGroundImageView;
@property (nonatomic ,strong)UILabel     *rightAlbumNameLabel;


@end
