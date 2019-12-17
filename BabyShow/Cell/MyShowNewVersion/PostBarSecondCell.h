//
//  PostBarSecondCell.h
//  BabyShow
//
//  Created by WMY on 16/4/7.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostBarSecondCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *photoView;
@property(nonatomic,strong)UIImageView *videoView;
@property (nonatomic, strong) UILabel *praiseCountLabel;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIImageView *groupImgView;

- (void)resetFrameWithDescribeContent:(NSString *) content;


@end
