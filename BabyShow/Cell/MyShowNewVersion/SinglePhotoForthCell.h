//
//  SinglePhotoForthCell.h
//  BabyShow
//
//  Created by WMY on 16/4/12.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SinglePhotoForthCell : UITableViewCell
@property(nonatomic,strong)UIImageView *photoView;
@property(nonatomic,strong)UILabel *avatarNameLable;
@property(nonatomic,strong)UILabel *partakeLable;
@property(nonatomic,strong)UILabel *titleNameLabel;
@property(nonatomic,strong)UIImageView *imgLine;
- (void)resetFrameWithDescribeContent:(NSString *) content;

@end
