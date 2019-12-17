//
//  MyOutPutSingleImgCell.h
//  BabyShow
//
//  Created by Monica on 9/17/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"

@protocol MyOutPutSingleImgCellDelegate <NSObject>

-(void)SeeTheSingleImage:(btnWithIndexPath *) btn;

@end

@interface MyOutPutSingleImgCell : UITableViewCell

@property (nonatomic, assign) id<MyOutPutSingleImgCellDelegate> delegate;
@property (nonatomic, strong) btnWithIndexPath *imgBtn;

@end
