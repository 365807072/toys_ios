//
//  PostBarDetailCountCell.h
//  BabyShow
//
//  Created by Monica on 10/23/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"

@protocol PostBarDetailCountCellDelegate <NSObject>

-(void)praise:(btnWithIndexPath *) sender;
-(void)review:(btnWithIndexPath *) sender;
-(void)more:(btnWithIndexPath *) sender;

@end

@interface PostBarDetailCountCell : UITableViewCell

@property (nonatomic, assign) id <PostBarDetailCountCellDelegate> delegate;
@property (nonatomic, strong) btnWithIndexPath *praiseBtn;
@property (nonatomic, strong) btnWithIndexPath *reviewBtn;
@property (nonatomic, strong) btnWithIndexPath *moreBtn;

@end
