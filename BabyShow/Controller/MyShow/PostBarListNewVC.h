//
//  PostBarListNewVC.h
//  BabyShow
//
//  Created by WMY on 16/8/8.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostBarListNewVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (nonatomic, strong) NSString *login_user_id;
@property (nonatomic, strong) NSString *post_create_time;
@property(nonatomic,assign) NSInteger tag_id;
@property(nonatomic,strong)NSString *img_ids;
@property(nonatomic,strong)NSString *type;
@property(nonatomic,strong)NSString *titleNav;
@property(nonatomic,strong)NSString *fromFouce;//来着我关注的群
@property(nonatomic,assign)BOOL isThrid;//如果是yes，用接口“getOwnGroupList”


@end
