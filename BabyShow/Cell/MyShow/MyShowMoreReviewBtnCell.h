//
//  MyShowMoreReviewBtnCell.h
//  BabyShow
//
//  Created by Lau on 13-12-13.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyShowMoreReviewBtnCellDelegate <NSObject>

-(void)pressMoreReviewBtn:(UIButton *) button;

@end


@interface MyShowMoreReviewBtnCell : UITableViewCell

@property (nonatomic, strong) UIButton *reviewlistBtn;
@property (nonatomic, assign) id <MyShowMoreReviewBtnCellDelegate> delegate;
@end
