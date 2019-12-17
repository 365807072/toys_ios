//
//  ImageDetailViewController.h
//  BabyShow
//
//  Created by Lau on 14-1-3.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyShowSectionHeaderView.h"
#import "MyShowPhotoCell.h"
#import "MyShowPraiseCountBtnCell.h"
#import "MyShowMessageCell.h"
#import "MyShowReviewLabelCell.h"
#import "MyShowMoreReviewBtnCell.h"
#import "MyShowPraiseBtnCell.h"

#import "MyShowSectionItem.h"
#import "MyShowImageItem.h"
#import "MyShowPraisecountItem.h"
#import "MyShowReviewItem.h"
#import "MyShowDescribeItem.h"
#import "MyShowReviewCountItem.h"
#import "MyShowItem.h"
#import "MyShowPraiseBtnItem.h"

#import "ImageScale.h"
#import "PraiseAndReviewListViewController.h"
#import "UrlMaker.h"
#import "Reachability.h"
#import "MoreBtnItem.h"
#import "ReportViewController.h"

//#import "FSBasicImage.h"
//#import "FSBasicImageSource.h"
//#import "FSImageViewerViewController.h"

#import "MWPhotoBrowser.h"
#import "MyShowImgCell.h"
#import "MyShowImageGroupItem.h"

#import "PPTViewController.h"
#import "UIImage+Scale.h"

@interface ImageDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,
//MyShowPraiseCountBtnCellDelegate,
MyShowMoreReviewBtnCellDelegate,
MyShowPraiseBtnCellDelegate,
MyShowSectionHeaderViewDelegate,
UIActionSheetDelegate,
UIAlertViewDelegate,
MWPhotoBrowserDelegate,
MyShowImgCellDelegate>

{
    UITableView *_tableView;
    NetAccess *netAccess;
    NSMutableArray *_sectionArray;
    NSMutableArray *_dataArray;
        
    MyShowPraiseBtnItem *_pItem;
    MyShowPraiseCountBtnCell *_praiseCountCell;
    MyShowPraisecountItem *_praiseCountItem;
    MyShowPraiseBtnCell *_praiseBtnCell;
    
    NSMutableDictionary *_sectionUserDic;

    
    NSArray *facesArray;
    NSDictionary *facesDictionary;

    
    int deleteNum;
    
    NSMutableArray *_PhotoArray;

}

@property (nonatomic, strong) NSString *imgID;
@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) BOOL  isPost;//失效参数
@property(nonatomic,strong)NSString *thumbString;
@property(nonatomic,strong)NSString *cateName;
@property(nonatomic,assign)NSInteger rsort;
@property(nonatomic,assign)BOOL isSpecial;


@end
