//
//  PlayVideoCell.h
//  BabyShow
//
//  Created by WMY on 16/6/28.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"

@protocol PlayVideoCellDelegate <NSObject>

-(void)playVideoUrl:(btnWithIndexPath *) btn;
-(void)playVideoInTheView:(btnWithIndexPath*)btn;

@end

@interface PlayVideoCell : UITableViewCell
@property(nonatomic,assign)id<PlayVideoCellDelegate>delegate;
@property(nonatomic,strong)btnWithIndexPath  *ImgBtn;
@property(nonatomic,strong)btnWithIndexPath *playSamllBtn;
@property(nonatomic,strong)btnWithIndexPath *imgBigBtn;
@property(nonatomic,strong)btnWithIndexPath *grayView;

@end
