//
//  AlbumList2ViewController.h
//  BabyShow
//
//  Created by Lau on 14-1-13.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumDetailCell.h"

#define GLOBAL_REQUEST              200
#define NEW_ALBUM_ALERTVIEW_TAG     201     //新建相册
#define DELETE_ALBUM_ALERTVIEW_TAG  202     //删除相册
#define RENAME_ALBUM_ALERTVIEW_TAG  203     //重命名
#define MOVE_IMG_ALERTVIEW_TAG      204     //移动到:弹出AlertView

//编辑类型
typedef enum {
    Edit_Type_Delete =1,
    Edit_Type_Rename =2,
}Edit_Type;

@interface AlbumList2ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,UIAlertViewDelegate,AlbumCellDelegate>
{
    
}

@property (nonatomic)int type;                      //我的相册,ＴＡ的相册
@property (nonatomic ,strong)NSString *user_id;     //我的或他的user_id

@property (nonatomic) BOOL isEditingMode;                   //是否处于编辑模式
@property (nonatomic) BOOL isChecked;                       //是否选中
@property (nonatomic) Edit_Type edit_type;                           //编辑的类型(删除,重命名)

@property (nonatomic ,strong)NSDictionary *movingInfo;          //图片移动的相关信息

@property (nonatomic,strong)NSDictionary *formerDict;           //  前一页传递的字典
@property (nonatomic,strong)UITableView *albumList2TableView;    //二级相册列表
@property (nonatomic,strong)NSMutableArray *dataSourceArray;    //数据源

//@property (nonatomic ,strong)UIButton *uploadButton;            //智能上传
@property (nonatomic ,strong)UIButton *editButton;              //编辑按钮

@end

