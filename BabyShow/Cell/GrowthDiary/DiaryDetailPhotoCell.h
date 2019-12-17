//
//  DiaryDetailPhotoCell.h
//  BabyShow
//
//  Created by Monica on 15-1-24.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"

@protocol DiaryDetailPhotoCellDelegate <NSObject>

@optional
-(void)showTheDetailOfThePhoto:(btnWithIndexPath *) btn;

@end

@interface DiaryDetailPhotoCell : UITableViewCell

@property (nonatomic, assign) id <DiaryDetailPhotoCellDelegate> delegate;
@property (nonatomic, strong) btnWithIndexPath *imgBtn;


@end
