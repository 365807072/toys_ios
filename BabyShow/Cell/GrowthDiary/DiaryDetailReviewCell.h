//
//  DiaryDetailReviewCell.h
//  BabyShow
//
//  Created by Monica on 15-1-24.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIAttributedLabel.h"

@interface DiaryDetailReviewCell : UITableViewCell

@property (nonatomic ,strong) NIAttributedLabel *reviewLabel;
-(void)resetLabelFrameWithContent:(NSString *)content;

@end
