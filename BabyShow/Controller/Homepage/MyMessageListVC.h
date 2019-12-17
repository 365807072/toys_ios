//
//  MyMessageListVC.h
//  BabyShow
//
//  Created by WMY on 15/11/16.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyHomePageItem.h"
@class NetAccess;
enum ACTION_TYPE{
    FOCUS_TYPE,
    CANCELFOCUS_TYPE,
    REQUESTSHARE_TYPE,
    CANCELSHARE_TYPE
};

@interface MyMessageListVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
    //0:无相关
    //1:我关注他
    //2:相互关注
    //3:他关注我
    NSInteger _relation;
    int actionType;
    NSInteger _praiseSection;
    NSInteger _deleteSection;
    NSMutableArray *_PhotoArray;
    NSArray *facesArray;
    NSDictionary *facesDictionary;
}
/**
 1：TA的主页；
 0：我的主页——有返回按钮；
 3：我的主页——没返回按钮。
 **/
@property (nonatomic, assign) NSInteger Type;
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic, strong) NSDictionary *messDic;
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) MyHomePageItem *item;
@property (nonatomic ,assign) NSInteger page;
@property (nonatomic ,strong) NSMutableArray *dataArray;


@end
