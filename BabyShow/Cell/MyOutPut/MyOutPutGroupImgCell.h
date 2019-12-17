//
//  MyOutPutGroupImgCell.h
//  BabyShow
//
//  Created by Monica on 9/17/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"

@protocol myOutPutGroupImgCellDelegate <NSObject>

-(void)SeeTheDetailOfThePhoto:(btnWithIndexPath *) btn;

@end

@interface MyOutPutGroupImgCell : UITableViewCell

@property (nonatomic, assign) id<myOutPutGroupImgCellDelegate> delegate;

@property (nonatomic, strong) btnWithIndexPath *btn1;
@property (nonatomic, strong) btnWithIndexPath *btn2;
@property (nonatomic, strong) btnWithIndexPath *btn3;
@property (nonatomic, strong) btnWithIndexPath *btn4;
@property (nonatomic, strong) btnWithIndexPath *btn5;
@property (nonatomic, strong) btnWithIndexPath *btn6;

@property (nonatomic, strong) NSArray *btnArry;

@end
