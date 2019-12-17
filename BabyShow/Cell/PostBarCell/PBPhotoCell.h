//
//  PhotoCell.h
//  BabyShow
//
//  Created by Lau on 6/4/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PBBasicCell.h"

@interface PBPhotoCell : PBBasicCell

@property (nonatomic, strong) UIImageView *imgView1;
@property (nonatomic, strong) UIImageView *imgView2;
@property (nonatomic, strong) UIImageView *imgView3;
@property (nonatomic, strong) NSArray *imgViewArray;
@property (nonatomic, strong) UILabel *countLabel;

@end
