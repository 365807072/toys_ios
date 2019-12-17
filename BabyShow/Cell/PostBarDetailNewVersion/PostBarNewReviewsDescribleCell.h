//
//  PostBarNewReviewsDescribleCell.h
//  BabyShow
//
//  Created by WMY on 16/4/22.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIAttributedLabel.h"

@interface PostBarNewReviewsDescribleCell : UITableViewCell
@property(nonatomic,strong)NIAttributedLabel *describeLabel;
-(void)resetFrameWithContent:(NSString*)content;

@end
