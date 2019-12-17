//
//  ThreePictureOneBigCell.h
//  BabyShow
//
//  Created by WMY on 16/8/1.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreePictureOneBigCell : UITableViewCell
@property(nonatomic,strong)UIImageView *firstSmallImg;
@property(nonatomic,strong)UIImageView *grayImg;
@property(nonatomic,strong)UIImageView *firstPicBtn;
@property(nonatomic,strong)UIImageView *secondPicBtn;
@property(nonatomic,strong)UIImageView *thridPicBtn;
@property(nonatomic,strong)UILabel *avatarNameLable;
@property(nonatomic,strong)UILabel *partakeLable;
@property(nonatomic,strong)UILabel *titleNameLabel;
@property(nonatomic,strong)UIImageView *imgLine;
- (void)resetFrameWithDescribeContent:(NSString *) content;



@end
