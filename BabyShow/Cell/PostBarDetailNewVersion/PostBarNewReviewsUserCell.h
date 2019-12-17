//
//  PostBarNewReviewsUserCell.h
//  BabyShow
//
//  Created by WMY on 16/4/22.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"
@protocol PostBarNewReviewsUserCellDelegate<NSObject>
-(void)ClickOnTheAvatar:(btnWithIndexPath *) btn;
-(void)praise:(btnWithIndexPath *) sender;
-(void)review:(btnWithIndexPath *) sender;


@end


@interface PostBarNewReviewsUserCell : UITableViewCell
@property(nonatomic,strong)btnWithIndexPath *avatarBtn;
@property(nonatomic,strong)UILabel *userNameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)btnWithIndexPath *admireBtn;
@property(nonatomic,strong)btnWithIndexPath *reviewBtn;
@property(nonatomic,strong)btnWithIndexPath *reviewCountBtn;
@property(nonatomic,strong)btnWithIndexPath *admireCountBtn;
@property(nonatomic,strong)UILabel *reviewCountLabel;
@property(nonatomic,strong)UILabel *admireCountLabel;

@property(nonatomic,assign)id <PostBarNewReviewsUserCellDelegate>delegate;

@end
