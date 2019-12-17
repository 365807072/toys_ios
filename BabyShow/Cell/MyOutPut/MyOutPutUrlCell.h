//
//  MyOutPutUrlCell.h
//  BabyShow
//
//  Created by Monica on 9/17/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"

@protocol MyOutPutUrlCellDelegate <NSObject>

-(void)jumpToTheWebView:(btnWithIndexPath *) btn;

@end

@interface MyOutPutUrlCell : UITableViewCell

@property (nonatomic, assign) id <MyOutPutUrlCellDelegate> delegate;
@property (nonatomic, strong) btnWithIndexPath *backGroundBtn;
@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) UILabel *titleLabel;

@end
