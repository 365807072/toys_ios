//
//  TA_AlbumListViewController.h
//  BabyShow
//
//  Created by Lau on 14-1-18.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "AlbumBabyCell.h"

#define SHARE_REQUEST_TAG  401
#define CANCEL_SHARE_REQUEST_TAG 501

@interface TA_AlbumListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate,AlbumCellDelegate>
{
    
}
@property (nonatomic,strong)UITableView *albumListTableView;    //相册列表
@property (nonatomic,strong)NSMutableArray *dataSourceArray;    //数据源
@property (nonatomic ,strong)NSString *ta_user_id ; // 他的user_id

@property (nonatomic ,strong)UIButton *askForShareButton;       //请求共享
@property (nonatomic ,strong)ASIFormDataRequest *askForShareRequest;
@property (nonatomic ,strong)ASIFormDataRequest *cancelShareRequest;    //取消共享

@property (nonatomic)BOOL isShare;                              //是否是共享关系0否,1是

@end
