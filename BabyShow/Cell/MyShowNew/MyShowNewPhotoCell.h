//
//  MyShowNewPhotoCell.h
//  BabyShow
//
//  Created by Monica on 9/22/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"

@protocol MyShowNewPhotoCellDelegate <NSObject>

-(void)gotoTheDetail:(btnWithIndexPath *) btn;

@end

@interface MyShowNewPhotoCell : UITableViewCell

@property (nonatomic, assign) id <MyShowNewPhotoCellDelegate> delegate;
@property (nonatomic, strong) btnWithIndexPath *btn1;
@property (nonatomic, strong) btnWithIndexPath *btn2;
@property (nonatomic, strong) NSArray *btnArry;
@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UIImageView *imageview;

@end
