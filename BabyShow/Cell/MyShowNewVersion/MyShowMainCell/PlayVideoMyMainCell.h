//
//  PlayVideoMyMainCell.h
//  BabyShow
//
//  Created by WMY on 16/8/1.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"

@protocol PlayVideoMyMainCellDelegate <NSObject>

-(void)playVideoUrl:(btnWithIndexPath *) btn;
-(void)playVideoInTheView:(btnWithIndexPath*)btn;

@end



@interface PlayVideoMyMainCell : UITableViewCell
@property(nonatomic,assign)id<PlayVideoMyMainCellDelegate>delegate;
@property(nonatomic,strong)btnWithIndexPath  *ImgBtn;
@property(nonatomic,strong)btnWithIndexPath *playSamllBtn;
@property(nonatomic,strong)btnWithIndexPath *imgBigBtn;
@property(nonatomic,strong)btnWithIndexPath *grayView;
@property(nonatomic,strong)UILabel *avatarNameLable;
@property(nonatomic,strong)UILabel *partakeLable;
@property(nonatomic,strong)UILabel *titleNameLabel;
@property(nonatomic,strong)UIImageView *imgLine;
- (void)resetFrameWithDescribeContent:(NSString *) content;



@end
