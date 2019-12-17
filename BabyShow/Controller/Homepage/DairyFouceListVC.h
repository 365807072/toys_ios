//
//  DairyFouceListVC.h
//  BabyShow
//
//  Created by WMY on 15/12/15.
//  Copyright © 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DairyFouceListVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate>{
     UIView *_emptyView;
}
@property(nonatomic,strong)NSString *login_user_id;

@end
