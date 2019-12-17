//
//  DiaryDetailCountCell.h
//  BabyShow
//
//  Created by Monica on 15-1-24.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"

@protocol DiaryDetailCountCellDelegate <NSObject>

@optional
-(void)praise:(btnWithIndexPath *) sender;
-(void)review:(btnWithIndexPath *) sender;
-(void)more:(btnWithIndexPath *) sender;

@end
@interface DiaryDetailCountCell : UITableViewCell

@property (nonatomic, assign) id <DiaryDetailCountCellDelegate> delegate;
@property (nonatomic, strong) btnWithIndexPath *praiseBtn;
@property (nonatomic, strong) btnWithIndexPath *reviewBtn;
@property (nonatomic, strong) btnWithIndexPath *moreBtn;

@end
