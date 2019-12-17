//
//  ReviewReviewCell.h
//  BabyShow
//
//  Created by WMY on 16/11/16.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIAttributedLabel.h"
#import "EmojiLabel.h"

@interface ReviewReviewCell : UITableViewCell
@property(nonatomic,strong)NIAttributedLabel *describleLabel;

@property(nonatomic,strong)UIView *grayView;
-(void)resetFrameWithContent:(NSString*)content;

@end
