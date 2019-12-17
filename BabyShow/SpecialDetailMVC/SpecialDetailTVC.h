//
//  SpecialDetailTVC.h
//  BabyShow
//
//  Created by WMY on 15/5/19.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOutPutUrlCell.h"
#import "MyOutPutSingleImgCell.h"
#import "MyShowNewPhotoCell.h"
#import "MyOutPutPraiseAndReviewCell.h"
#import "MyShowNewTitleTodayCell.h"
#import "MyShowNewTitleNotTodayCell.h"
#import "MyShowNewDescribeCell.h"
#import "MyShowNewPickedTitleCell.h"
#import "MyShowNewPickedTitleFriendsCell.h"
#import "MyShowNewPickedTitleNotTodayCell.h"
#import "MyShowPickedBabyCell.h"
#import "MWPhotoBrowser.h"
#import "MyShowNewPickedTitleNotTodayCell.h"
#import "MyShowPickedBabyCell.h"
#import "MWPhotoBrowser.h"
#import "SpecialDetailGridItem.h"
#import "MakeAvtivityViewController.h"

@interface SpecialDetailTVC : UIViewController
<UITableViewDelegate,
UITableViewDataSource,
MyOutPutUrlCellDelegate,
MyOutPutSingleImgCellDelegate,
MyOutPutPraiseAndReviewCellDelegate,
MWPhotoBrowserDelegate,UIActionSheetDelegate,
MyShowNewPhotoCellDelegate,
MyShowNewTitleTodayCellDelegate,
MyShowNewTitleNotTodayCellDelegate,
MyShowNewPickedTitleCellDelegate,
MyShowNewPickedTitleFriendsCellDelegate,
MyShowNewPickedTitleNotTodayCellDelegate,
MyShowPickedBabyCellDelegate,
UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate>


{
    UICollectionView *_collectionView;
    
    NSMutableArray *_dataArray;
    NSMutableArray *_newDataArray;
    UITableView *_tableview;
    //用来判断是不是刷新操作，需不需要传lastid
    BOOL _isFresh;
    //用来判断是更新数据，还是在已有数据上加载更多内容
    BOOL _isGetMore;
    //用来判断，是不是已经没有更多数据，还要不要上来加载更多
    BOOL _isFinished;
    
    BOOL _isFreshInCollectionView;
    BOOL _isGetMoreInCollectionView;
    BOOL _isFinishedInCollectionView;
    //用来记录赞的组
    NSInteger _praiseSection;
    //用来记录删除的组
    NSInteger _deleteSection;
    //用来记录加关注的组
    NSInteger _focusSection;
    //用来记录评论的组
    NSInteger _reviewSection;
    //用来控制选择的频
    NSMutableArray *_channelViewArray;
    
    //页码
    NSInteger _page;
    //用来查看大图
    NSMutableArray *_PhotoArray;
    UIButton        *_backBtn;
    
    
}
@property(nonatomic,strong)UISegmentedControl *segment;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,assign)NSInteger cate_id;
@property(nonatomic,strong)NSString *login_user_id;
@property(nonatomic,strong)NSString *last_id;
@property(nonatomic,assign)NSInteger is_pic;
@property(nonatomic,assign)NSInteger picture_id;
@property(nonatomic,strong)NSString *cateName;
@property(nonatomic,assign)BOOL isFromMyShow;
//用来记录选择的频道
@property NSInteger selectedIndex;
@property(nonatomic,assign)NSInteger recievedIndex;
-(void)delayShowNewestViewController;
@end
