//
//  ImageView.h
//  BabyShow
//
//  Created by Mayeon on 14-3-3.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageView : UIImageView
{
    
}
//用户信息,主要需要往下一页传递user_id, 和img_id
@property (nonatomic ,strong)NSDictionary *imageInfo;

@end
