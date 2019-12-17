//
//  EmojiLabel.h
//  BabyShow
//
//  Created by WMY on 16/4/28.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmojiLabel : UILabel
- (void)insertImage:(UIImage *)image atIndex:(NSInteger)index margins:(UIEdgeInsets)margins;
@property (nonatomic, strong) NSMutableArray *images;


@end
