//
//  LoveBabyFirstVC.h
//  BabyShow
//
//  Created by WMY on 16/4/11.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialHeadListModel.h"
#import "SpecialHeaderListImagesView.h"
#import "SpecialHeadHotModel.h"
#import "SpecialHeadHotView.h"


@interface LoveBabyFirstVC : UIViewController<UITableViewDelegate,UITableViewDataSource>{
    
}
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *loginUserid;
@property (nonatomic, strong) NSString *lastId;
@property(nonatomic,strong)NSString *post_creat_time;
@property(nonatomic,strong)NSString *postcrestTime;
@property(nonatomic,strong)UITableView *tableViewNew;

@end
