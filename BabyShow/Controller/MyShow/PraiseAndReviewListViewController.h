//
//  PraiseAndReviewListViewController.h
//  BabyShow
//
//  Created by Lau on 13-12-18.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReviewListCell.h"
#import "PraiseListCell.h"
#import "MyShowReviewItem.h"
#import "MyShowPraiseItem.h"

@class InputToolBarUtility;
#import "Emoji.h"
#import "NimbusAttributedLabel.h"

@protocol ClickDelegate <NSObject>

-(void)clickToResignFirstResponder;

@end
@interface PraiseAndReviewListViewController : UIViewController<UITableViewDataSource,
UITableViewDelegate,
UITextFieldDelegate,
ReviewListCellDelegate,
UIGestureRecognizerDelegate,
UIActionSheetDelegate>

{
    UITableView *_tableview;
    NSMutableArray *_dataArray;
    UIView *_addReviewView;
    NetAccess *netAccess;
    
    UIView *_emptyView;
    BOOL _isEmptyViewExist;
        
    NSMutableDictionary *_userDic;
    MyShowReviewItem *_selectedReviewItem;
    MyShowPraiseItem *_selectedPraiseItem;
    
    NSArray *facesArray;
    NSDictionary *facesDictionary;
    
    NSMutableArray *numArray;   // 记录判断表情所在的位置和表情字符串(内容为字典类型emojiInfo)
    
}
@property (nonatomic ,strong)UITableView *tableview;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSString *imgID;
@property (nonatomic, strong) NSString *useridBePraised;
@property (nonatomic, strong) NSNumber *lastId;
@property(nonatomic,strong)NSString *reviewId;

@property (nonatomic, assign) BOOL isPost;
@property (nonatomic, assign) BOOL isDiary;     //成长日记
@property (nonatomic, assign) BOOL isWorthBuy;

 /**
 *  reviewType=0：我的秀秀的回复；
    reviewType=1：贴吧的回复。
    reviewType=2：图片详情的回复。
 */

@property (nonatomic ,strong) InputToolBarUtility *toolBar;
@property (nonatomic ,assign)id<ClickDelegate>clickDelegate;

//发该条秀秀(话题,值得买)的拥有者
@property (nonatomic ,strong)NSString *ownerId;

-(void)sendText:(NSString *)text;



@end
