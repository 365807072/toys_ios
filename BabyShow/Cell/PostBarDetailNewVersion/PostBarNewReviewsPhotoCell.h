//
//  PostBarNewReviewsPhotoCell.h
//  BabyShow
//
//  Created by WMY on 16/4/22.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"
@protocol PostBarNewReviewsPhotoCellDelegate<NSObject>
-(void)gotoDetailPhotos:(btnWithIndexPath*)btn;
@end
@interface PostBarNewReviewsPhotoCell : UITableViewCell
@property(nonatomic,assign)id <PostBarNewReviewsPhotoCellDelegate> delegate;
@property(nonatomic,strong)btnWithIndexPath *btn1;
@property(nonatomic,strong)btnWithIndexPath *btn2;
@property(nonatomic,strong)btnWithIndexPath *btn3;
@property(nonatomic,strong)btnWithIndexPath *btn4;




@end
