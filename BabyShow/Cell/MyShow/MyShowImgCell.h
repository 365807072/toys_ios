//
//  MyShowImgCell.h
//  BabyShow
//
//  Created by Lau on 3/24/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"

@protocol MyShowImgCellDelegate <NSObject>

-(void)imgViewOnClick:(btnWithIndexPath *) btn;

@end

@interface MyShowImgCell : UITableViewCell


@property (nonatomic, strong) btnWithIndexPath *imgView1;
@property (nonatomic, strong) btnWithIndexPath *imgView2;
@property (nonatomic, strong) btnWithIndexPath *imgView3;
@property (nonatomic, strong) btnWithIndexPath *imgView4;
@property (nonatomic, strong) btnWithIndexPath *imgView5;
@property (nonatomic, strong) btnWithIndexPath *imgView6;

@property (nonatomic, strong) NSMutableArray *imgArray;
@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, assign) id <MyShowImgCellDelegate> delegate;

@end
