//
//  SingleAlbumViewController.h
//  BabyShow
//
//  Created by Lau on 14-1-7.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//
///单个相册

#import <UIKit/UIKit.h>
#import "ImageListScrollView.h"
#import "SVPullToRefresh.h"
#import "ELCImagePickerController.h"
#import "MWPhotoBrowser.h"

#define DELETE_ALERTVIEW_TAG    101
#define MOVE_ALERTVIEW_TAG      102
#define MESSAGE_ALERTVIEW_TAG   103

@interface SingleAlbumViewController : UIViewController<ImageDelegate,UIAlertViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,ELCImagePickerControllerDelegate,MWPhotoBrowserDelegate>
{
}
@property (nonatomic ,strong)ImageListScrollView *mainScrollView;
@property (nonatomic ,strong)UIToolbar *bottomToolBar;

@property (nonatomic) int type;                                 //我的相册0还是他的相册1或者他的但已共享2
@property (nonatomic ,strong)NSString *user_id;
@property (nonatomic ,strong)NSDictionary *summaryDictionary;   //一个相册的基本信息,从上一个页面传递过来
@property (nonatomic,strong) NSMutableArray *imgsArray;      //  这个相册的全部图片信息(元素为字典型)
@property (nonatomic ,strong)NSMutableArray *mwphotosArray;
@property (nonatomic)BOOL   isEditing;                      //是否在编辑

@property (nonatomic ,strong)UIButton *uploadButton;        //上传
@property (nonatomic ,strong)UIButton *deleteButton;        //删除
@property (nonatomic ,strong)UIButton *moveButton;          //移动
@property (nonatomic ,strong)UIButton *shareButton;         //秀一下

@property (nonatomic ,strong)UILabel *tipLabel;             //显示文字

/**
 *  从相册选,
 */
@property (nonatomic)BOOL isChoosing;               //是否是在我的相册选择
@property (nonatomic)NSUInteger currentCount;       //已经选择的图片数量
@end
