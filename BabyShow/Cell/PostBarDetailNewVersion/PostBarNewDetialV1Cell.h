//
//  PostBarNewDetialV1Cell.h
//  BabyShow
//
//  Created by WMY on 16/4/21.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostBarNewDetialV1Cell : UITableViewCell
@property(nonatomic,strong)UILabel *descriptionLabel;

-(NSInteger)resetLayOutSubviews:(NSInteger)imgCount;
-(NSInteger)resetFrameWithContent:(NSString*)content;


@end
