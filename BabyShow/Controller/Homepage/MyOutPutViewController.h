//
//  MyOutPutViewController.h
//  BabyShow
//
//  Created by Monica on 9/18/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOutPutTitleTodayCell.h"
#import "MyOutPutTitleNotTodayCell.h"
#import "MyShowNewDescribeCell.h"
#import "MyOutPutUrlCell.h"
#import "MyOutPutGroupImgCell.h"
#import "MyOutPutSingleImgCell.h"
#import "MyOutPutPraiseAndReviewCell.h"
#import "MWPhotoBrowser.h"

@interface MyOutPutViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MyOutPutUrlCellDelegate,myOutPutGroupImgCellDelegate,MyOutPutSingleImgCellDelegate,MyOutPutPraiseAndReviewCellDelegate,MWPhotoBrowserDelegate,UIActionSheetDelegate,ClickLabelDelegate>

{
    UITableView *_tableview;
    NSMutableArray *_dataArray;
    
    //用来判断是不是刷新操作，需不需要传lastid
    BOOL _isFresh;
    //用来判断是更新数据，还是在已有数据上加载更多内容
    BOOL _isGetMore;
    //用来判断，是不是已经没有更多数据，还要不要上来加载更多
    BOOL _isFinished;
    
    NSInteger _praiseSection;
    NSInteger _deleteSection;
    NSInteger _page;
    
    NSMutableArray *_PhotoArray;
    NSArray *facesArray;
    NSDictionary *facesDictionary;

}

@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *loginUserid;

@end
