//
//  PostBarDetailTitleCell.h
//  BabyShow
//
//  Created by Monica on 10/23/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostBarDetailTitleCell : UITableViewCell

-(void)resetFrameWithContent:(NSString *) content;

@property (nonatomic, strong) UILabel *titleLabel;

@end
