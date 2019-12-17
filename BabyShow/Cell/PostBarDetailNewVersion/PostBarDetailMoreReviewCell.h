//
//  PostBarDetailMoreReviewCell.h
//  BabyShow
//
//  Created by Monica on 10/23/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"

@protocol PostBarDetailMoreReviewCellDelegate <NSObject>

-(void)moreReviews:(btnWithIndexPath *) sender;

@end

@interface PostBarDetailMoreReviewCell : UITableViewCell

@property (nonatomic, assign) id <PostBarDetailMoreReviewCellDelegate> delegate;
@property (nonatomic, strong) btnWithIndexPath *moreReviewBtn;

@end
