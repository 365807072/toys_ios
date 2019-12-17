//
//  DiaryDetailDescribeCell.h
//  BabyShow
//
//  Created by Monica on 15-1-24.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIAttributedLabel.h"

@interface DiaryDetailDescribeCell : UITableViewCell

@property (nonatomic, strong) NIAttributedLabel *describeLabel;

-(void)resetLabelFrameWithContent:(NSString *) content;

@end
