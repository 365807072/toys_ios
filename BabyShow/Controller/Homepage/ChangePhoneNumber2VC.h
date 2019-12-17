//
//  ChangePhoneNumber2VC.h
//  BabyShow
//
//  Created by WMY on 15/12/10.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChangePhoneNumber2VC : UIViewController<UITextFieldDelegate>
@property(nonatomic,assign)NSInteger typeChangeOrBing;
@property(nonatomic,strong)NSString *fromLogin;//来自登录的绑定,如果是登录的绑定，可以跳过如果是正常绑定手机号不能跳过
@property(nonatomic,assign)BOOL isFromTab;//是点击tabbar还是其他,yes是来自tabbar

@end
