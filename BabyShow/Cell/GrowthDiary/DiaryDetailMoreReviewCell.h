//
//  DiaryDetailMoreReviewCell.h
//  BabyShow
//
//  Created by Monica on 15-1-24.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"

@protocol DiaryDetailMoreReviewCellDelegate <NSObject>

@optional
-(void)moreReviews:(btnWithIndexPath *) sender;

@end

@interface DiaryDetailMoreReviewCell : UITableViewCell

@property (nonatomic, assign) id <DiaryDetailMoreReviewCellDelegate> delegate;

@property (nonatomic, strong) btnWithIndexPath *moreReviewBtn;

@end
