//
//  PostBarNewWithOutImageCell.h
//  BabyShow
//
//  Created by Monica on 10/20/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostBarNewWithOutImageCell : UITableViewCell

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *describeLabel;
@property (nonatomic, strong) UILabel *praiseCountLabel;
@property (nonatomic, strong) UILabel *reviewCountLabel;
@property (nonatomic, strong) UIImageView *signImageView;
@property (nonatomic, strong) UIImageView *praiseImageView;

- (void)resetFrameWithDescribeContent:(NSString *) content;

@end
