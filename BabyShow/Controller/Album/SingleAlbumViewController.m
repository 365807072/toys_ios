//
//  SingleAlbumViewController.m
//  BabyShow
//
//  Created by Lau on 14-1-7.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "SingleAlbumViewController.h"
#import "JSONKit.h"
#import "LittleImageView.h"
#import "AlbumListViewController.h"
#import "BBSNavigationController.h"
#import "MakeAShowViewController.h"
#import "MWPhoto.h"
#import "PBMakeAPostViewController.h"
//#import "PostBarNewDetailVC.h"
#import "PostBarNewMakeAPost.h"
#import "GrowthEditViewController.h"
#import "ImageDetailViewController.h"
#import "MakeAvtivityViewController.h"
#import "PostBarNewDetialV1VC.h"

@interface SingleAlbumViewController ()
{
    BOOL is_moving;     //是否在移动,以确定是否要刷新界面
    NSUInteger currentIndex;
}
@end

@implementation SingleAlbumViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _summaryDictionary =[[NSDictionary alloc] init];
        _imgsArray =[[NSMutableArray alloc] init];
        _mwphotosArray =[[NSMutableArray alloc] init];
        _type = 0;
    }
    return self;
}
-(void)setBackButton{
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
}
-(void)back{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:RENAME_REMARK_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:DELETE_IMAGE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:NOTI_TO_LOAD_MORE object:nil];
        
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setEditBarButton{
    UIButton *editBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [editBtn setFrame:CGRectMake(0, 0, 40, 30)];
    NSString *title = self.isChoosing ? @"完成":@"编辑";
    [editBtn setTitle:title forState:UIControlStateNormal];
    [editBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [editBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(clickEdit:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:editBtn];
    
    if ([[self.summaryDictionary objectForKey:@"is_show_album"] integerValue] == 1 ) {
        self.navigationItem.rightBarButtonItem = nil;
    } else {
        self.navigationItem.rightBarButtonItem = rightBtnItem;
    }
    if (self.type == 1 || self.type == 2) {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    if (self.isChoosing) {
        self.uploadButton.hidden = self.isChoosing;
        self.deleteButton.hidden = self.isChoosing;
        self.moveButton.hidden = self.isChoosing;
        self.shareButton.hidden = self.isChoosing;
    }
    
    
    
}
-(void)clickEdit:(id)sender{
    if (self.isChoosing) {
        //从相册选,完成

        for (UIViewController *viewController in self.navigationController.viewControllers) {
            if ([viewController isKindOfClass:[MakeAShowViewController class]]) {
                
                NSUInteger chosedCount = [self selectedImageURLArray].count;
                if (chosedCount > (9-self.currentCount)) {
                    NSString *message ;
#ifdef __LP64__
                    message = [NSString stringWithFormat:@"当前可选%lu张,已选%lu张",9-self.currentCount,chosedCount];

#else
                    message = [NSString stringWithFormat:@"当前可选%d张,已选%d张",9-self.currentCount,chosedCount];

#endif
                    
                    [BBSAlert showAlertWithContent:message andDelegate:nil];
                    return;
                }

                MakeAShowViewController *makeAShowVC = (MakeAShowViewController *)viewController;
                [makeAShowVC.imageArray addObjectsFromArray:[self selectedImageURLArray]];
                [makeAShowVC.pickedImagesArray addObjectsFromArray: makeAShowVC.imageArray];
                [makeAShowVC makeImageViewWithPickedImagesArray:makeAShowVC.pickedImagesArray];
                makeAShowVC.describeField.text=makeAShowVC.content;
                [self.navigationController popToViewController:makeAShowVC animated:YES];
                ////////////////////////////////
            }else if ([viewController isKindOfClass:[MakeAvtivityViewController class]]){
                
                NSUInteger chosedCount = [self selectedImageURLArray].count;
                if (chosedCount > (6-self.currentCount)) {
                    NSString *message ;
#ifdef __LP64__
                    message = [NSString stringWithFormat:@"当前可选%lu张,已选%lu张",6-self.currentCount,chosedCount];
                    
#else
                    message = [NSString stringWithFormat:@"当前可选%d张,已选%d张",6-self.currentCount,chosedCount];
                    
#endif
                    [BBSAlert showAlertWithContent:message andDelegate:nil];
                    return;
                }
                
                MakeAvtivityViewController *makeAShowVC=(MakeAvtivityViewController *) viewController;
                [makeAShowVC.imageArray addObjectsFromArray:[self selectedImageURLArray]];
                [makeAShowVC.pickedImagesArray addObjectsFromArray: makeAShowVC.imageArray];
                makeAShowVC.describeField.text=makeAShowVC.content;

                [makeAShowVC makeImageViewWithPickedImagesArray:makeAShowVC.pickedImagesArray];
                
                [self.navigationController popToViewController:makeAShowVC animated:YES];
            }else if ([viewController isKindOfClass:[PBMakeAPostViewController class]]){
                
                NSUInteger chosedCount = [self selectedImageURLArray].count;
                if (chosedCount > (6-self.currentCount)) {
                    NSString *message ;
#ifdef __LP64__
                    message = [NSString stringWithFormat:@"当前可选%lu张,已选%lu张",6-self.currentCount,chosedCount];
                    
#else
                    message = [NSString stringWithFormat:@"当前可选%d张,已选%d张",6-self.currentCount,chosedCount];
                    
#endif
                    [BBSAlert showAlertWithContent:message andDelegate:nil];
                    return;
                }

                PBMakeAPostViewController *makeAShowVC=(PBMakeAPostViewController *) viewController;
                [makeAShowVC.photoArray addObjectsFromArray:[self selectedImageURLArray]];
                [makeAShowVC makeImageViewsWithPhotosArray:makeAShowVC.photoArray];
                [self.navigationController popToViewController:makeAShowVC animated:YES];
            }else if ([viewController isKindOfClass:[PostBarNewDetialV1VC class]]){
                
                NSUInteger chosedCount = [self selectedImageURLArray].count;
                if (chosedCount > (6-self.currentCount)) {
                    NSString *message ;
#ifdef __LP64__
                    message = [NSString stringWithFormat:@"当前可选%lu张,已选%lu张",6-self.currentCount,chosedCount];
                    
#else
                    message = [NSString stringWithFormat:@"当前可选%d张,已选%d张",6-self.currentCount,chosedCount];
                    
#endif
                    [BBSAlert showAlertWithContent:message andDelegate:nil];
                    return;
                }
                
                PostBarNewDetialV1VC *postBarDetailVC=(PostBarNewDetialV1VC *)viewController;
                [postBarDetailVC.toolBaView.photosArray addObjectsFromArray:[self selectedImageURLArray]];
                [postBarDetailVC.toolBaView remowSubviews];
                [postBarDetailVC.toolBaView showPhotosWithArray:postBarDetailVC.toolBaView.photosArray];
                
                [self.navigationController popToViewController:postBarDetailVC animated:YES];

            }else if ([viewController isKindOfClass:[PostBarNewMakeAPost class]]){
                
                NSUInteger chosedCount = [self selectedImageURLArray].count;
                if (chosedCount > (6-self.currentCount)) {
                    NSString *message ;
#ifdef __LP64__
                    message = [NSString stringWithFormat:@"当前可选%lu张,已选%lu张",6-self.currentCount,chosedCount];
                    
#else
                    message = [NSString stringWithFormat:@"当前可选%d张,已选%d张",6-self.currentCount,chosedCount];
                    
#endif
                    [BBSAlert showAlertWithContent:message andDelegate:nil];
                    return;
                }
                
                PostBarNewMakeAPost *makePostVC=(PostBarNewMakeAPost *)viewController;
                [makePostVC.pickedImagesArray addObjectsFromArray:[self selectedImageURLArray]];
                [makePostVC removeImageViews];
                [makePostVC showImagesWithPhotosArray:makePostVC.pickedImagesArray];
                [self.navigationController popToViewController:makePostVC animated:YES];
                
            }else if ([viewController isKindOfClass:[GrowthEditViewController class]]){
                
                NSUInteger chosedCount = [self selectedImageURLArray].count;
                if (chosedCount > (6-self.currentCount)) {
                    NSString *message ;
#ifdef __LP64__
                    message = [NSString stringWithFormat:@"当前可选%lu张,已选%lu张",20-self.currentCount,chosedCount];
                    
#else
                    message = [NSString stringWithFormat:@"当前可选%d张,已选%d张",20-self.currentCount,chosedCount];
                    
#endif
                    [BBSAlert showAlertWithContent:message andDelegate:nil];
                    return;
                }
                
                GrowthEditViewController *editViewController=(GrowthEditViewController *)viewController;
                editViewController.uploadUrls = YES;
                editViewController.urlsArray = [self selectedImageURLArray];
                [self.navigationController popToViewController:editViewController animated:YES];
            }
            
            
        }
        
    } else {
        UIButton *editBtn = (UIButton *)sender;
        self.isEditing = !self.isEditing;
        
        self.uploadButton.hidden = self.isEditing;
        self.deleteButton.hidden = !self.isEditing;
        self.moveButton.hidden = !self.isEditing;
        self.shareButton.hidden = !self.isEditing;
        
        if (self.isEditing) {
            [editBtn setTitle:@"完成" forState:UIControlStateNormal];
        }else{
            [editBtn setTitle:@"编辑" forState:UIControlStateNormal];
            is_moving = NO;
        }
        BOOL refresh = YES;
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",self.isEditing],@"editing",[NSString stringWithFormat:@"%d",refresh],@"refresh", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeEditState" object:self userInfo:dict];
    }
    
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isEditing = self.isChoosing;
    self.navigationItem.title = [self.summaryDictionary objectForKey:@"album_name"];
    
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self setBackButton];
    
    self.automaticallyAdjustsScrollViewInsets =NO;
    
    self.uploadButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.uploadButton.frame = CGRectMake(0, self.view.frame.size.height-40, 320, 40);
    [self.uploadButton setBackgroundImage:[UIImage imageNamed:@"img_upload_back"] forState:UIControlStateNormal];
    [self.uploadButton setImage:[UIImage imageNamed:@"btn_upload"] forState:UIControlStateNormal];
    self.uploadButton.hidden = self.isEditing;
    [self.uploadButton addTarget:self action:@selector(uploadImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.uploadButton];
    
    if ([[self.summaryDictionary objectForKey:@"is_show_album"] integerValue] == 1 ) {
        self.uploadButton.hidden = YES;
    } else {
        self.uploadButton.hidden = NO;
    }
    if (self.type == 1 || self.type == 2) {
        self.uploadButton.hidden = YES;
    }
    
    self.shareButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.shareButton.frame = CGRectMake(0, self.view.frame.size.height-40, 106, 40);
    [self.shareButton setBackgroundImage:[UIImage imageNamed:@"img_upload_back"] forState:UIControlStateNormal];
    [self.shareButton setImage:[UIImage imageNamed:@"btn_makeAshow"] forState:UIControlStateNormal];
    self.shareButton.hidden = !self.isEditing;
    [self.shareButton addTarget:self action:@selector(shareImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.shareButton];
    
    self.deleteButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteButton.frame = CGRectMake(106, self.view.frame.size.height-40, 106, 40);
    [self.deleteButton setBackgroundImage:[UIImage imageNamed:@"img_upload_back"] forState:UIControlStateNormal];
    [self.deleteButton setImage:[UIImage imageNamed:@"btn_delete"] forState:UIControlStateNormal];
    self.deleteButton.hidden = !self.isEditing;
    [self.deleteButton addTarget:self action:@selector(deleteImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.deleteButton];
    
    self.moveButton =[UIButton buttonWithType:UIButtonTypeCustom];
    self.moveButton.frame = CGRectMake(106*2, self.view.frame.size.height-40, 106+2, 40);
    [self.moveButton setBackgroundImage:[UIImage imageNamed:@"img_upload_back"] forState:UIControlStateNormal];
    [self.moveButton setImage:[UIImage imageNamed:@"btn_move3"] forState:UIControlStateNormal];
    self.moveButton.hidden = !self.isEditing;
    [self.moveButton addTarget:self action:@selector(moveImage:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.moveButton];
    
    [self setEditBarButton];
    
    [self requestImgList];

    //
    [self addObservers];
}
-(void)addObservers{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afterRenameImage:) name:RENAME_REMARK_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(afterDeleteImage:) name:DELETE_IMAGE_SUCCEED object:nil];
    //加载更多,但不刷新视图,仅限MWPhotoBrowser使用
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiToLoadMoreImgList:) name:NOTI_TO_LOAD_MORE object:nil];

}
-(void)layoutWithImagesArray:(NSMutableArray *)imgArray{
    if (imgArray.count == 0) {
        //没有图片
        if (self.mainScrollView) {
            [self.mainScrollView removeFromSuperview];
            self.mainScrollView.imageDelegate = nil;
            self.mainScrollView = nil;
        }
        if (self.tipLabel) {
            [self.tipLabel removeFromSuperview];
            self.tipLabel = nil;
        }
        self.tipLabel= [[UILabel alloc] initWithFrame:CGRectMake(80, 150, 160, 40)];
        self.tipLabel.text = @"该照片夹还没有相片";
        self.tipLabel.backgroundColor =[ UIColor clearColor];
        self.tipLabel.font =[UIFont systemFontOfSize:16];
        self.tipLabel.textColor =[ UIColor lightGrayColor];
        self.tipLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:self.tipLabel];

    }else{

        if (self.tipLabel) {
            [self.tipLabel removeFromSuperview];
            self.tipLabel = nil;
        }

        if (self.mainScrollView) {
            [self.mainScrollView removeFromSuperview];
            self.mainScrollView.imageDelegate = nil;
            self.mainScrollView = nil;
        }
        CGFloat scrollHeight = 0;
        if (([[self.summaryDictionary objectForKey:@"is_show_album"] integerValue] == 1) || self.type == 1 || self.type == 2) {
            scrollHeight = self.view.frame.size.height-64;
        } else {
            scrollHeight = self.view.frame.size.height-(64+40);
        }
        scrollHeight += (self.isChoosing?40:0);
        self.mainScrollView = [[ImageListScrollView alloc]initWithImageArray:imgArray withFrame:CGRectMake(0, 64, self.view.frame.size.width,scrollHeight) is_show_album:[[self.summaryDictionary objectForKey:@"is_show_album"] integerValue]];
        self.mainScrollView.imageDelegate = self;
        [self.view addSubview:self.mainScrollView];
        [self.view sendSubviewToBack:self.mainScrollView];
        __block int last_id =0;
        __weak SingleAlbumViewController *blockSelf = self;
    
        [self.mainScrollView addInfiniteScrollingWithActionHandler:^{
            last_id = blockSelf.mainScrollView.last_id;

            [LoadingView startOnTheViewController:blockSelf];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:blockSelf.user_id,kImgListUser_id,LOGIN_USER_ID,kImgListLogin_user_id,[blockSelf.summaryDictionary objectForKey:@"id"],kImgListAlbum_id,[NSString stringWithFormat:@"%d",last_id],kImgListLast_id, nil];
            //第一次加载
            [[HTTPClient sharedClient] getNewV1:kImgLists params:params success:^(NSDictionary *result) {
                [LoadingView stopOnTheViewController:blockSelf];
                if ([[result objectForKey:kBBSSuccess] boolValue] == YES) {
                    NSMutableArray *copyImgsArray  =[[NSMutableArray alloc]initWithArray:blockSelf.imgsArray];
                    NSUInteger firstIndex = blockSelf.imgsArray.count;
                    NSMutableArray * tempArray = (NSMutableArray *)[result objectForKey:kBBSData];
                    [copyImgsArray addObjectsFromArray:tempArray];
                    blockSelf.imgsArray = copyImgsArray;
                    if (tempArray.count <= 0) {
                        [blockSelf.mainScrollView.infiniteScrollingView removeFromSuperview];
                    }else{//传递索引值
                        [blockSelf.mainScrollView loadNextPage:tempArray firstIndex:firstIndex];
                    }
                }else{
                    [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
                }
                [[blockSelf.mainScrollView infiniteScrollingView]stopAnimating];
                //下拉刷新的时候是否将之前已经选中的清除(保持不刷新)
                BOOL refresh = NO;
                NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",blockSelf.isEditing],@"editing",[NSString stringWithFormat:@"%d",refresh],@"refresh", nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeEditState" object:blockSelf userInfo:dict];

            } failed:^(NSError *error) {
                [LoadingView stopOnTheViewController:blockSelf];
            }];
            

        }];
        BOOL refresh = NO;
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%d",blockSelf.isEditing],@"editing",[NSString stringWithFormat:@"%d",refresh],@"refresh", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeEditState" object:blockSelf userInfo:dict];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    if (is_moving) {
        [self requestImgList];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadSucceed) name:USER_UPLOAD_PHOTOS_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(uploadFail:) name:USER_UPLOAD_PHOTOS_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USER_UPLOAD_PHOTOS_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USER_UPLOAD_PHOTOS_FAIL object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:USER_NET_ERROR object:nil];

    
}
#pragma mark - 点击代理查看图片详情
-(void)clickToCheckBigImage:(NSDictionary *)imageDict atIndex:(NSUInteger)indexOfObject{
    if (self.isEditing) {

    }else{
        currentIndex = indexOfObject;

        if ([[self.summaryDictionary objectForKey:@"is_show_album"] boolValue] == NO) {
            
            //进入大图模式
            [self.mwphotosArray removeAllObjects];
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            for (int i =0; i < self.imgsArray.count; i++) {
                NSDictionary *dict = (NSDictionary *)[self.imgsArray objectAtIndex:i];
                if (dict) {
                    MWPhoto *photo =[[MWPhoto alloc]initWithURL:[NSURL URLWithString:[dict objectForKey:@"img"]] info:dict];
                    [arr addObject:photo];
                }
            }
            self.mwphotosArray = arr;
            arr = nil;
            
            MWPhotoBrowser *browser =[[ MWPhotoBrowser alloc]initWithDelegate:self];
            browser.displayActionButton = YES;
            browser.displayNavArrows = NO;
            browser.displaySelectionButtons = NO;
            browser.alwaysShowControls = NO;
            browser.zoomPhotosToFill = YES;
            browser.enableGrid = YES;
            browser.startOnGrid = NO;
            [browser setCurrentPhotoIndex:currentIndex];
            browser.type = self.type;
            browser.needRefresh = YES;
            browser.is_show_album =[[self.summaryDictionary objectForKey:@"is_show_album"]boolValue];
            browser.user_id =self.user_id;
            browser.needPlay = YES;     //需要播放
            browser.imgArr = self.imgsArray;    //播放需要的东西
//        [self.navigationController pushViewController:browser animated:YES];
            BBSNavigationController *nav=[[BBSNavigationController alloc]initWithRootViewController:browser];
            [self presentViewController:nav animated:YES completion:nil];
        } else {
            NSDictionary *dict = (NSDictionary *)[self.imgsArray objectAtIndex:currentIndex];

            PostBarNewDetialV1VC *detail = [[PostBarNewDetialV1VC alloc]init];
            detail.img_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"img_id"]];
           // detail.login_user_id = [NSString stringWithFormat:@"%@",[dict objectForKey:@"user_id"]];
            detail.hidesBottomBarWhenPushed = YES;
            detail.refreshInVC = ^(BOOL isRefresh){
                
            };

            [self.navigationController pushViewController:detail animated:YES];
        }
    }
    
}
#pragma mark - MWPhotoBrowserDelegate
-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    return self.mwphotosArray.count;
}
-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    if (index < self.mwphotosArray.count) {
        return [self.mwphotosArray objectAtIndex:index];
    }
    return nil;
}
#pragma mark - 监听-删除,修改备注
-(void)afterDeleteImage:(NSNotification *)noti{

    NSMutableArray *tempImgsArray = [[NSMutableArray alloc]initWithArray:self.imgsArray];
    for (int i =0; i< self.mwphotosArray.count; i++) {
        id<MWPhoto>photo = [self.mwphotosArray objectAtIndex:i];
        if ([photo.img_info isEqualToDictionary:noti.userInfo]) {
            [self.mwphotosArray removeObjectAtIndex:i];
            [tempImgsArray  removeObjectAtIndex:i];
            self.imgsArray = tempImgsArray;
            
            [self layoutWithImagesArray:self.imgsArray];
//            [self requestImgList];
            //MWPhotoBrowser 更新视图,显示下一张
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_MWPHOTO_BROWSER object:nil];
            break;
        }
    }
}

-(void)afterRenameImage:(NSNotification *)noti{

    NSMutableArray *tempImgsArray = [[NSMutableArray alloc]initWithArray:self.imgsArray];
    for (int i =0; i< self.mwphotosArray.count; i++) {
        id<MWPhoto>photo = [self.mwphotosArray objectAtIndex:i];
        if ([photo.img_info isEqualToDictionary:[noti.userInfo objectForKey:@"img_info"]]) {
            NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc]initWithDictionary:photo.img_info];
            [mutableDict setValue:[noti.userInfo objectForKey:@"remark"] forKey:@"description"];
            [photo setImg_info:mutableDict];
            
            [tempImgsArray replaceObjectAtIndex:i withObject:mutableDict];
            self.imgsArray = tempImgsArray;
            
            //MWPhotoBrowser 更新title
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_NAVI_TITLE object:nil];
            break;
        }
    }
   
}

#pragma mark - upload

-(void)uploadImage:(id)sender{
    
    [MobClick event:UMEVENTUPLOAD];
    
//    NSLog(@"%s--row:%d",__FUNCTION__,__LINE__);
    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"我们上传的是高清无损图片,请尽量使用WIFI/3G网络" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"上传", nil];
    alertView.tag = MESSAGE_ALERTVIEW_TAG;
    [alertView show];

}

#pragma mark ELCImagePickerControllerDelegate

-(void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info{
    
    [picker dismissViewControllerAnimated:YES completion:nil];

    [LoadingView startOnTheViewController:self];

    dispatch_async(dispatch_queue_create(DISPATCH_QUEUE_PRIORITY_DEFAULT, NULL), ^{
        
        NSString *album_id = [self.summaryDictionary objectForKey:@"id"];
        NSMutableArray *photoArray=[[NSMutableArray alloc]init];
        
        for (NSDictionary *dict in info) {
            
            UIImage *image = [dict objectForKey:UIImagePickerControllerOriginalImage];
            [photoArray addObject:image];
            
        }
        NSString *count = [NSString stringWithFormat:@"%lu",(unsigned long)photoArray.count];
        NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:LOGIN_USER_ID,@"user_id",album_id,@"album_id",photoArray,@"photos", count,@"file_count", nil];
        

        NetAccess *net=[NetAccess sharedNetAccess];
        [net getDataWithStyle:NetStyleUploadPhoto andParam:param];
        dispatch_async(dispatch_get_main_queue(), ^{
            [LoadingView stopOnTheViewController:self];
        });
    });
    
}

-(void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark NSNotification

-(void)uploadSucceed{
    
    [LoadingView stopOnTheViewController: self];
    //需要刷新界面
    [self requestImgList];
}

-(void)uploadFail:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController: self];
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}

-(void)netFail{
    
    [LoadingView stopOnTheViewController: self];
    [BBSAlert showAlertWithContent:@"网络错误，请稍后重试" andDelegate:self];
    
}


#pragma mark - 选中的图片(id)数组
-(NSMutableArray *)selectedImageArray{
    NSMutableArray *subViews  = [NSMutableArray arrayWithArray:[self.mainScrollView.leftView subviews]];
    subViews = (NSMutableArray *)[subViews arrayByAddingObjectsFromArray:[self.mainScrollView.centerView subviews]];
    subViews = (NSMutableArray *)[subViews arrayByAddingObjectsFromArray:[self.mainScrollView.rightView subviews]];
    
    NSMutableArray *selectedImg_idArray  =[[ NSMutableArray alloc] init];
    for (int i =0 ; i< [subViews count]; i ++) {
        LittleImageView *littleImageView = (LittleImageView *)[subViews objectAtIndex:i];
        if ([littleImageView is_selected]) {
            [selectedImg_idArray addObject:[NSString stringWithFormat:@"%ld",(long)littleImageView.tag]];
        }
    }
    return selectedImg_idArray;
}
#pragma mark - 选中的图片的URLString,主要用于秀一下
- (NSMutableArray *)selectedImageURLArray{
    NSMutableArray *selectedURLArray = [[NSMutableArray alloc]init];
    NSArray *selectedImgArray  = [self selectedImageArray];
    
    for (NSDictionary *imageInfo in self.imgsArray) {
        NSString *imgId = [NSString stringWithFormat:@"%@",[imageInfo objectForKey:@"img_id"]];
        if ([selectedImgArray containsObject:imgId]) {
            
            NSString *imgThumbUrl=[imageInfo objectForKey:@"img_thumb"];
            NSString *imgUrl=[imageInfo objectForKey:@"img_down"];
            NSDictionary *imgDic=[NSDictionary dictionaryWithObjectsAndKeys:imgThumbUrl,@"img_thumb",
                                  imgUrl,@"img_down",nil];
            [selectedURLArray addObject:imgDic];
        }
    }
    
    return selectedURLArray;
}
#pragma mark - share秀一下
- (void)shareImage:(id)sender{
    [MobClick event:UMEVENTSHARE];
    
    if ([self selectedImageURLArray].count <= 0) {
        NSString *message = @"您未选中任何照片!";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }
    if ([self selectedImageURLArray].count > 9) {
        NSString *message = @"一次最多选择9张!";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"确定", nil];
        [alertView show];
        return;
    }

    MakeAShowViewController *makeAshow=[[MakeAShowViewController alloc]init];
    makeAshow.Type=1;
    makeAshow.imageArray=[self selectedImageURLArray];
    makeAshow.refreshMyBlock = ^(){
        
    };

    [self.navigationController pushViewController:makeAshow animated:YES];
}
#pragma mark - delete
-(void)deleteImage:(id)sender{
    NSString *message = @"";
    if([[self selectedImageArray]count] == 0 ){
       message = @"您未选择任何照片!";
    }else{
        message = [NSString stringWithFormat:@"确定删除%lu张照片?",(unsigned long)[[self selectedImageArray]count]];
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = DELETE_ALERTVIEW_TAG;
    [alertView show];
}
#pragma mark - move
-(void)moveImage:(id)sender{
    NSString *message = @"";
    if([[self selectedImageArray]count] == 0 ){
        message = @"您未选择任何照片!";
    }else{
        message = [NSString stringWithFormat:@"确定移动%lu张照片?",(unsigned long)[[self selectedImageArray]count]];
    }

    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:@"确定", nil];
    alertView.tag = MOVE_ALERTVIEW_TAG;
    [alertView show];
}
#pragma mark - UIAlertView Delegate Methods
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == MESSAGE_ALERTVIEW_TAG) {
        if (buttonIndex == 1) {
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
            elcPicker.maximumImagesCount = 10;
            elcPicker.returnsOriginalImage = NO; //Only return the fullScreenImage, not the fullResolutionImage
            elcPicker.imagePickerDelegate = self;
            
            [self presentViewController:elcPicker animated:YES completion:nil];
            
        }
        return;
    }
    
    if ([[self selectedImageArray]count] ==0) {
        return;
    }
    NSString *img_ids = [[self selectedImageArray] componentsJoinedByString:@","];
//    NSLog(@"img_id(string):%@",img_ids);
    NSString *user_id  = LOGIN_USER_ID;
    if (buttonIndex == 1) {//确定
        if (alertView.tag == DELETE_ALERTVIEW_TAG) {

            [LoadingView startOnTheViewController:self];
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:user_id,kDoImgUser_id,img_ids,kDoImgImg_id,@"1",kDoImgDo_type, nil];
            [[HTTPClient sharedClient] postNew:kDoImg params:params success:^(NSDictionary *result) {
                [LoadingView stopOnTheViewController:self];
                if ([[result objectForKey:kBBSSuccess] integerValue] == 1) {
                    [self requestImgList];
                }else{
                    [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
                }
            } failed:^(NSError *error) {
                [LoadingView stopOnTheViewController:self];
                [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
            }];
            
        }else if (alertView.tag == MOVE_ALERTVIEW_TAG){
            is_moving = YES;
            NSString *album_id = [self.summaryDictionary objectForKey:@"id"];
//            NSLog(@"from album_id:%@,img_ids:%@",album_id,img_ids);
            AlbumListViewController *albumListVC = [[AlbumListViewController alloc] init];
            NSDictionary *movingDict = [[NSDictionary alloc] initWithObjectsAndKeys:album_id,@"album_id",img_ids,@"img_ids",@"1",@"isMoving", nil];
            albumListVC.title = @"移动到";
            albumListVC.movingInfo = movingDict;
            [self.navigationController pushViewController:albumListVC animated:YES];
        }

    }else{  //取消
        
    }
}
-(AppDelegate *)appDelegate{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
#pragma mark - 请求
-(void)requestImgList{
    //第二次请求这个jiek
    [LoadingView startOnTheViewController:self];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.user_id,kImgListUser_id,LOGIN_USER_ID,kImgListLogin_user_id,[self.summaryDictionary objectForKey:@"id"],kImgListAlbum_id, nil];
    [[HTTPClient sharedClient] getNewV1:kImgLists params:params success:^(NSDictionary *result) {
        [LoadingView stopOnTheViewController:self];
        if ([[result objectForKey:kBBSSuccess] integerValue] == 1) {
            self.imgsArray = [result objectForKey:kBBSData];
            [self layoutWithImagesArray:self.imgsArray];
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [LoadingView stopOnTheViewController:self];
        [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
    }];
    
}
//监听通知,加载更多一页,但是这一页不更新视图,更新在MWPhotoBrowser中,修改数据源urlArray
-(void)notiToLoadMoreImgList:(NSNotification *)noti{
   
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:self.user_id,kImgListUser_id,LOGIN_USER_ID,kImgListLogin_user_id,[self.summaryDictionary objectForKey:@"id"],kImgListAlbum_id,[noti.userInfo objectForKey:@"img_id"],kImgListLast_id, nil];
    [[HTTPClient sharedClient]getNewV1:kImgLists params:params success:^(NSDictionary *result) {
        if ([[result objectForKey:kBBSSuccess] integerValue] == 1) {
            NSMutableArray *tempArray = [[NSMutableArray alloc]initWithArray:self.imgsArray];
            NSUInteger firstIndex = self.imgsArray.count;
            NSArray *dataArray = [result objectForKey:kBBSData];
            [tempArray addObjectsFromArray:dataArray];
            self.imgsArray = tempArray;
            for (int i =0; i < dataArray.count; i++) {
                NSDictionary *dict = (NSDictionary *)[dataArray objectAtIndex:i];
                if (dict) {
                    MWPhoto *photo =[[MWPhoto alloc]initWithURL:[NSURL URLWithString:[dict objectForKey:@"img"]] info:dict];
                    [self.mwphotosArray addObject:photo];
                }
            }
            [self.mainScrollView loadNextPage:(NSMutableArray *)dataArray firstIndex:firstIndex];
//            NSLog(@"noti -- count:%d",self.imgsArray.count);
            [[NSNotificationCenter defaultCenter]postNotificationName:NOTI_AFTER_LOAD_MORE object:nil userInfo:@{@"imgArr": self.imgsArray}];
        }else{
            [BBSAlert showAlertWithContent:[result objectForKey:kBBSReMsg] andDelegate:nil];
        }
    } failed:^(NSError *error) {
        [BBSAlert showAlertWithContent:@"网络连接失败" andDelegate:nil];
    }];
    
}

@end
