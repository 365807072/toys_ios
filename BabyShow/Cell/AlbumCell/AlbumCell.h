//
//  AlbumCell.h
//  BabyShow
//
//  Created by Mayeon on 14-3-26.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlbumCellDelegate <NSObject>

@optional
-(void)selectAlbumInfo:(NSDictionary *)imageInfo cell:(UITableViewCell *)cell isLeft:(BOOL)isLeft;

@end

@interface AlbumCell : UITableViewCell

@property (nonatomic , strong)id<AlbumCellDelegate>delegate;

@end
