//
//  PostBarFirstCell.h
//  BabyShow
//
//  Created by WMY on 16/4/7.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostBarFirstCell : UITableViewCell
@property(nonatomic,strong)UILabel *describleLabel;
@property (nonatomic, strong) UILabel *praiseCountLabel;
@property (nonatomic, strong) UILabel *reviewCountLabel;
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)UIImageView *groupImgView;
@property(nonatomic,strong)UIImageView *essImgView;
- (void)resetFrameWithDescribeContent:(NSString *) content;
-(void)resetFrameWithDescribeContent:(NSString *)content isHide:(BOOL)isHide;

@end
