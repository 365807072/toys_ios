//
//  LeadingViewController.h
//  BabyShow
//
//  Created by 于 晓波 on 15/4/26.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeadingViewController : UIViewController
{
    NSInteger _index;
}

@property (nonatomic, strong) NSMutableArray *photosArray;
@property (nonatomic, strong) UIImageView *imageView;

@end
