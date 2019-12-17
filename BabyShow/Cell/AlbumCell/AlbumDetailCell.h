//
//  AlbumDetailCell.h
//  BabyShow
//
//  Created by Mayeon on 14-3-26.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumCell.h"
#import "ImageView.h"
#import "NIAttributedLabel.h"

@interface AlbumDetailCell :AlbumCell

@property (nonatomic ,strong)UIImageView  *leftImageView;
@property (nonatomic ,strong)ImageView  *leftBackGroundImageView;
@property (nonatomic ,strong)NIAttributedLabel    *leftAlbumNameLabel;
@property (nonatomic ,strong)UILabel    *leftCreateTimeLabel;
@property (nonatomic ,strong)UIImageView *leftSelectImageView;  //编辑模式下(删除或重命名)的选择圈圈

@property (nonatomic ,strong)UIImageView  *rightImageView;
@property (nonatomic ,strong)ImageView  *rightBackGroundImageView;
@property (nonatomic ,strong)UILabel    *rightAlbumNameLabel;
@property (nonatomic ,strong)UILabel    *rightCreateTimeLabel;
@property (nonatomic ,strong)UIImageView *rightSelectImageView;

@end
