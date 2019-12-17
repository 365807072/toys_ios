  //
//  StoreMoreListVC.h
//  BabyShow
//
//  Created by WMY on 15/9/2.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DropdownButton.h"
#import "ConditionDoubleTableView.h"
#import <CoreLocation/CoreLocation.h>
@protocol dropdownDelegate <NSObject>

@optional
- (void)dropdownSelectedLeftIndex:(NSString *)left RightIndex:(NSString *)right;

@end

@interface StoreMoreListVC : UIViewController<UITableViewDataSource,UITableViewDelegate,showMenuDelegate,ConditionDoubleTableViewDelegate,CLLocationManagerDelegate>{
    DropdownButton *_button;
    ConditionDoubleTableView *_tableViewSelect;
    NSInteger _lastIndex;
    
    NSInteger _buttonSelectedIndex;
    NSMutableArray *_buttonIndexArray;

}
@property (nonatomic, strong) NSString *login_user_id;
@property (nonatomic, strong) NSString *post_create_time;
@property (assign, nonatomic) id<dropdownDelegate>delegate;
@property(nonatomic,strong)NSString *cityId;
@property(nonatomic,strong)NSString *fromGroup;




@end
