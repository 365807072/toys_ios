//
//  ThreePictureSmallCell.h
//  BabyShow
//
//  Created by WMY on 16/8/1.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreePictureSmallCell : UITableViewCell
@property(nonatomic,strong)UIImageView *imgStore1;
@property(nonatomic,strong)UIImageView *imgStore2;
@property(nonatomic,strong)UIImageView *imgStore3;
@property(nonatomic,strong)UILabel *avatarNameLable;
@property(nonatomic,strong)UILabel *partakeLable;
@property(nonatomic,strong)UILabel *titleNameLabel;
@property(nonatomic,strong)UIImageView *imgLine;

- (void)resetFrameWithDescribeContent:(NSString *) content;


@end
