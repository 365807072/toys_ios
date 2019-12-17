//
//  LoveBabySecondVC.h
//  BabyShow
//
//  Created by WMY on 16/4/11.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
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
#import "MakeAShowViewController.h"
#import "SpecialHeadListModel.h"
#import "SpecialHeaderListImagesView.h"
#import "SpecialHeadHotModel.h"
#import "SpecialHeadHotView.h"
#import <CoreLocation/CoreLocation.h>
#import "BBSTabBarViewController.h"

@protocol PostToSpecialDetailVCDelegate<NSObject>
-(void)setCate_idWithSpecialVC:(NSInteger)cateID selectIndex:(NSInteger)selectIndex;
@end


@interface LoveBabySecondVC : UIViewController<UITableViewDelegate,UITableViewDataSource,MyOutPutUrlCellDelegate,
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
UIAlertViewDelegate,UIScrollViewDelegate,CLLocationManagerDelegate>
{
   
    
    //用来记录赞的组
    NSInteger _praiseSection;
    //用来记录删除的组
    NSInteger _deleteSection;
    //用来记录加关注的组
    NSInteger _focusSection;
    //用来记录评论的组
    NSInteger _reviewSection;
    //用来查看大图
    NSMutableArray *_PhotoArray;
    UIButton *_addTopicBtn;
    UIScrollView *topNewScrollView;
    UIPageControl *topPageControl;
    NSInteger currentPage;
    NSTimer *timer;
    
    
    
}
@property (nonatomic, strong) NSString *userid;
@property (nonatomic, strong) NSString *loginUserid;
@property(nonatomic,strong)UITableView *tableViewSpecial;

@property(nonatomic,strong)UITableView *tableViewNew;
@property(nonatomic,assign)BOOL isFreshNew;
@property(nonatomic,assign)BOOL isFinishedNew;
@property(nonatomic,assign)BOOL isGetMoreNew;
@property(nonatomic,strong)NSString *postCreateTimeNew;
@property(nonatomic,strong)NSMutableArray *dataArrayNew;
@property(nonatomic,strong)NSMutableArray *dataArraySpecial;
@property(nonatomic,assign)id<PostToSpecialDetailVCDelegate>delegate;
@property(nonatomic,strong)SpecialHeadListModel *specialHeadListModel;
@property(nonatomic,strong)SpecialHeaderListImagesView *specialTopView;
@property(nonatomic,strong)CLLocationManager *locationManager;
@property(nonatomic,assign)BOOL isFreshSpecial;
@property(nonatomic,assign)BOOL isFinishedSpecial;
@property(nonatomic,assign)BOOL isGetMoreSpecial;
@property(nonatomic,assign)BOOL isIntheVCReview;
@property(nonatomic,strong)NSString *from;
@property(nonatomic,strong)NSString *babyId;
@property(nonatomic,strong)NSString *babyTitle;


-(void)playVideoUrl:(btnWithIndexPath *)btn;

@end
