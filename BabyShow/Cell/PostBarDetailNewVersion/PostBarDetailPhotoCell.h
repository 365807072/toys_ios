//
//  PostBarDetailPhotoCell.h
//  BabyShow
//
//  Created by Monica on 10/23/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"

@protocol PostBarDetailPhotoCellDelegate <NSObject>

-(void)showTheDetailOfThePhoto:(btnWithIndexPath *) btn;

@end

@interface PostBarDetailPhotoCell : UITableViewCell

@property (nonatomic, assign) id <PostBarDetailPhotoCellDelegate> delegate;
@property (nonatomic, strong) btnWithIndexPath *imgBtn;

@end
