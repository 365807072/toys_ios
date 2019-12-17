//
//  PostBarDetailDescribeCell.h
//  BabyShow
//
//  Created by Monica on 10/23/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NIAttributedLabel.h"
#import "EmojiLabel.h"
@interface PostBarDetailDescribeCell : UITableViewCell

@property (nonatomic, strong) NIAttributedLabel *describeLabel;
@property(nonatomic,strong)EmojiLabel *emojiLabel;

-(void)resetLabelFrameWithContent:(NSString *) content;

@end
