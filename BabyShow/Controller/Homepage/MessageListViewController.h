//
//  MessageListViewController.h
//  BabyShow
//
//  Created by Lau on 14-1-13.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageCell.h"
#import "MessageItem.h"
#import "MessageListRequestCell.h"
#import "MessageListRequestItem.h"
#import "ImageDetailViewController.h"

enum ACTIONTYPE{
    FOCUS,
    CANCELFOCUS,
    REQUESTSHARE,
    CANCELSHARE
};

@interface MessageListViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,MessageCellDelegate,MessageListRequestCellDelegate,UIAlertViewDelegate>

{
    
    NSMutableArray *dataArray;
    
    UIView *_emptyView;
    
    int actionType;

    UIButton *titleBtn;
    
}

@property (nonatomic, strong) NSNumber *lastId;
@property (nonatomic, assign) int Type;

@end
