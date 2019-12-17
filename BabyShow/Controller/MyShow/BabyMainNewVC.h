//
//  BabyMainNewVC.h
//  BabyShow
//
//  Created by WMY on 16/7/26.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SpecialHeadListModel.h"
#import "SpecialHeaderListImagesView.h"
#import "RefreshControl.h"


@interface BabyMainNewVC : UIViewController<UITableViewDataSource,UITableViewDelegate,RefreshControlDelegate>{
    //用来记录赞的组
    NSInteger _praiseSection;
    //用来记录删除的组
    NSInteger _deleteSection;
    NSInteger currentPage;
    NSTimer *timer;


}
@property(nonatomic,strong)SpecialHeadListModel *specialHeadListModel;
@property(nonatomic,strong)SpecialHeaderListImagesView *specialTopView;

@end
