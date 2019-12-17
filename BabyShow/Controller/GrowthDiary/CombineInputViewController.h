//
//  CombineInputViewController.h
//  BabyShow
//
//  Created by Monica on 15-4-7.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
/*!
 *  合并要输入用户名,密码,和登陆页面逻辑差不多
 */
@interface CombineInputViewController : UIViewController

/*!
 *  要合并人的user_id
 */
@property (nonatomic ,strong) NSString *user_id;

/*!
 *  我当前选择的baby_id;
 */
@property (nonatomic ,strong) NSString *baby_id;

/*!
 *  要合并的对方的baby_id
 */
@property (nonatomic ,strong) NSString *share_baby_id;
@end
