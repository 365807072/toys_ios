//
//  PostBarDetailReviewCell.h
//  BabyShow
//
//  Created by Monica on 10/23/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIAttributedLabel.h"

@interface PostBarDetailReviewCell : UITableViewCell

@property (nonatomic ,strong) NIAttributedLabel *reviewLabel;
-(void)resetLabelFrameWithContent:(NSString *)content;

@end
