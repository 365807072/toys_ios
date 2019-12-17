//
//  ImageDetailViewController.m
//  BabyShow
//
//  Created by Lau on 14-1-3.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import "ImageDetailViewController.h"
#import "BBSNavigationController.h"
#import "BBSNavigationControllerNotTurn.h"

#import "UserInfoItem.h"
#import "SDWebImageManager.h"
#import "BBSEmojiInfo.h"
#import "ImageScale.h"
#import "Emoji.h"
#import "SVPullToRefresh.h"
#import "ShowAlertView.h"
#import "MyHomeNewVersionVC.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKExtension/SSEShareHelper.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
//#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

#import <ShareSDKExtension/ShareSDK+Extension.h>


@interface ImageDetailViewController ()

@end

@implementation ImageDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        _sectionArray=[[NSMutableArray alloc]init];
        _dataArray=[[NSMutableArray alloc]init];
        
        facesArray = [[NSArray alloc]initWithArray:[Emoji allEmoji]];
        facesDictionary = [[NSDictionary alloc]initWithDictionary:[Emoji allEmojiDictionary]];
        
        self.imgID=[[NSString alloc]init];
        self.userID=[[NSString alloc]init];
        _sectionUserDic=[[NSMutableDictionary alloc]init];
        self.title=@"详情";
        _PhotoArray=[[NSMutableArray alloc]init];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor=[BBSColor hexStringToColor:@"f9f3f3"];
    
    [self setBackButton];
    [self setPlayButton];
    
    _tableView=[[UITableView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_tableview_background.png"]];
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
}

-(void)setPlayButton{
    
    CGRect backBtnFrame=CGRectMake(0, 0, 32, 31);
    
    UIButton *_playBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_playBtn setTitle:@"播放" forState:UIControlStateNormal];
    _playBtn.titleLabel.font=[UIFont fontWithName:@"Helvetica-Bold" size:16];
    [_playBtn addTarget:self action:@selector(play) forControlEvents:UIControlEventTouchUpInside];
    _playBtn.frame=backBtnFrame;
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:_playBtn];
    self.navigationItem.rightBarButtonItem=right;
    
}

-(void)play{
    
    MyShowSectionItem *sectionItem=[_sectionArray objectAtIndex:0];
    
    MyShowDescribeItem *desItem;
    MyShowImageGroupItem *imgGroupItem;
    
    for (MyShowItem *item in _dataArray) {
        if ([item isKindOfClass:[MyShowDescribeItem class]]) {
            
            desItem=(MyShowDescribeItem *)item;
            
        }else if ([item isKindOfClass:[MyShowImageGroupItem class]]){
            
            imgGroupItem=(MyShowImageGroupItem *)item;
            
        }
    }
    
    NSMutableArray *imgArr = [[NSMutableArray alloc]init];
    for (MyShowImageItem *imgItem in imgGroupItem.photosArray) {
        
        NSMutableDictionary *imgDic=[[NSMutableDictionary alloc]init];
        [imgDic setObject:sectionItem.time forKey:kMyShowCreatTime];
        if (desItem) {
            [imgDic setObject:desItem.content forKey:kMyShowDescription];
        }
        [imgDic setObject:imgGroupItem.imgId forKey:kMyShowImgId];
        [imgDic setObject:imgItem.imageClearStr forKey:kMyShowImg];
        [imgDic setObject:imgItem.img_down forKey:kMyShowImgDown];
        [imgDic setObject:imgItem.img_width forKey:kMyShowImgWidth];
        [imgDic setObject:imgItem.img_height forKey:kMyShowImgHeight];
        [imgDic setObject:imgItem.imageStr forKey:kMyShowImgThumb];
        [imgDic setObject:imgItem.img_thumb_width forKey:kMyShowImgThumbWidth];
        [imgDic setObject:imgItem.img_thumb_height forKey:kMyShowImgThumbHeight];
        
        [imgArr addObject:imgDic];
        
    }
    
    PPTViewController *ppt=[[PPTViewController alloc]init];
    ppt.photosArray=imgArr;
    ppt.maxPlayNumOnce=3;
    BBSNavigationControllerNotTurn *nav=[[BBSNavigationControllerNotTurn alloc]initWithRootViewController:ppt];
    [self presentViewController:nav animated:YES completion:^{}];
    
}

-(void)setBackButton{
    
    CGRect backBtnFrame=CGRectMake(0, 0, 49, 31);
    
    UIButton *_backBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setBackgroundImage:[UIImage imageNamed:@"btn_back1.png"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame=backBtnFrame;
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:_backBtn];
    self.navigationItem.leftBarButtonItem=left;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableviewReloadData) name:USER_GET_IMG_INFO_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getDataFail:) name:USER_GET_IMG_INFO_FAIL object:nil];
    
    //赞成功与失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseSucceed) name:USER_MYSHOWPRAISE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(praiseFail:) name:USER_MYSHOWPRAISE_FAIL object:nil];
    
    //取消赞成功与失败
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelpraiseSucceed) name:USER_MYSHOWCANCELPRAISE_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelpraiseFail:) name:USER_MYSHOWCANCELPRAISE_FAIL object:nil];
    
    //改变赞的数量
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changePraiseCount:) name:USER_CHANGE_PRAISE_COUNT object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netFail) name:USER_NET_ERROR object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteShowSucceed:) name:USER_DELETE_SHOW_SUCCEED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteShowFail:) name:USER_DELETE_SHOW_FAIL object:nil];
    NSString *userID=LOGIN_USER_ID;
    
    
    NSDictionary *param=[NSDictionary dictionaryWithObjectsAndKeys:
                         //   self.userID,kImgInfoUser_id,
                         userID,kImgInfoLogin_user_id,
                         self.imgID,kImgInfoImg_id,nil];
    
    netAccess=[NetAccess sharedNetAccess];
    [netAccess getDataWithStyle:NetStyleImageDetail andParam:param];
    
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:userID,@"login_userid",self.imgID,@"imgid", nil];
    [MobClick event:UMEVENTSEEIMGDETAIL attributes:dic];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark NSNotification

-(void)netFail{
    
    [BBSAlert showAlertWithContent:@"网络链接失败" andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    
}

-(void)tableviewReloadData{
    
    [_sectionArray removeAllObjects];
    [_dataArray removeAllObjects];
    
    for (id obj in netAccess.sectionArray) {
        [_sectionArray addObject:obj];
    }
    
    for (id obj in netAccess.dataArray) {
        [_dataArray addObject:obj];
    }
    
    
    MyShowImageGroupItem *imgGroupItem;
    for (MyShowItem *item in _dataArray) {
        if ([item isKindOfClass:[MyShowImageGroupItem class]]){
            imgGroupItem=(MyShowImageGroupItem *)item;
        }
    }
    
    if (imgGroupItem.photosArray.count>1) {
        [self setPlayButton];
    }
    
    [_tableView reloadData];
    
}

-(void)getDataFail:(NSNotification *)not{
    
    NetAccess *net=not.object;
    [BBSAlert showAlertWithContent:net.message andDelegate:self];
    [LoadingView stopOnTheViewController:self];
    
    
}

-(void)deleteShowSucceed:(NSNotification *) note{
    
    [LoadingView stopOnTheViewController:self];
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)deleteShowFail:(NSNotification *) note{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=note.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:nil];
    
}

#pragma mark UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyShowItem *item=[_dataArray objectAtIndex:indexPath.row];
    if ([item isKindOfClass:[MyShowImageGroupItem class]]) {
        
        MyShowImageGroupItem *imgGroupItem=(MyShowImageGroupItem *)[_dataArray objectAtIndex:indexPath.row];
        
        if (imgGroupItem.photosArray.count==1) {
            
            MyShowImageItem *imgItem=[imgGroupItem.photosArray objectAtIndex:0];
            
            [_PhotoArray removeAllObjects];
            
            MWPhoto *photo=[[MWPhoto alloc]initWithURL:[NSURL URLWithString:imgItem.imageClearStr] info:nil];
            photo.img_info = @{@"description": @"1/1"};
            [_PhotoArray addObject:photo];
            
            MWPhotoBrowser *browser =[[ MWPhotoBrowser alloc]initWithDelegate:self];
            browser.imgstr=imgItem.imageStr;
            browser.displayActionButton = YES;
            browser.displayNavArrows = NO;
            browser.displaySelectionButtons = NO;
            browser.alwaysShowControls = NO;
            browser.zoomPhotosToFill = YES;
            browser.enableGrid = YES;
            browser.startOnGrid = NO;
            [browser setCurrentPhotoIndex:0];
            browser.type = 10;
            browser.is_show_album =NO;
            browser.user_id =self.userID;
            
            BBSNavigationController *nav=[[BBSNavigationController alloc]initWithRootViewController:browser];
            [self presentViewController:nav animated:YES completion:nil];
            
        }
        
    }
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    MyShowSectionItem *sectionItem=[_sectionArray objectAtIndex:section];
    
    
    MyShowSectionHeaderView *sectionview=[[MyShowSectionHeaderView alloc]init];
    sectionview.delegate=self;
    sectionview.avatarBtn.tag=section;
    
    SDWebImageManager *manager=[SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:sectionItem.avatarImageStr] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        sectionview.avatarImageView.image=image;
        
    }];
    
    sectionview.nameLabel.text=sectionItem.authorname;
    sectionview.timeLabel.text=[NSString stringWithFormat:@"%@",sectionItem.time];
    
    return sectionview;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [_sectionArray count];
    
}

-(NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [_dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 43;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat height=30;
    MyShowItem *item=[_dataArray objectAtIndex:indexPath.row];
    height=item.height;
    return height;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MyShowItem *item=[_dataArray objectAtIndex:indexPath.row];
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:item.identify];
    
    if (!cell) {
        
        if ([item isKindOfClass:[MyShowImageGroupItem class]]) {
            
            MyShowImageGroupItem *imgGroupItem=[_dataArray objectAtIndex:indexPath.row];
            UITableViewCell *returnCell;
            if (imgGroupItem.photosArray.count!=1) {
                
                MyShowImgCell *newcell=[[MyShowImgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imgGroupItem.identify];
                newcell.delegate=self;
                returnCell=newcell;
                
            }else if ( imgGroupItem.photosArray.count==1 ){
                
                MyShowPhotoCell *newcell=[[MyShowPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imgGroupItem.identify];
                returnCell=newcell;
                
            }
            
            returnCell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell=returnCell;
            
        }else if([item isKindOfClass:[MyShowPraisecountItem class]]){
            
            MyShowPraisecountItem *praiseitem=[_dataArray objectAtIndex:indexPath.row];
            MyShowPraiseCountBtnCell *newCell=[[MyShowPraiseCountBtnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:praiseitem.identify];
            newCell.selectionStyle=UITableViewCellSelectionStyleNone;
            newCell.praiseListBtn.tag=indexPath.section;
            cell=newCell;
            
        }else if([item isKindOfClass:[MyShowReviewCountItem class]]){
            
            MyShowReviewCountItem *reviewcountItem=[_dataArray objectAtIndex:indexPath.row];
            MyShowMoreReviewBtnCell *newcell=[[MyShowMoreReviewBtnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewcountItem.identify];
            newcell.selectionStyle=UITableViewCellSelectionStyleNone;
            newcell.reviewlistBtn.tag=indexPath.section;
            cell=newcell;
            
        }else if([item isKindOfClass:[MyShowDescribeItem class]]){
            MyShowDescribeItem *describeItem=[_dataArray objectAtIndex:indexPath.row];
            MyShowMessageCell *newcell=[[MyShowMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:describeItem.identify];
            newcell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell=newcell;
            
        }else if([item isKindOfClass:[MyShowReviewItem class]]){
            
            MyShowReviewItem *reviewItem=[_dataArray objectAtIndex:indexPath.row];
            MyShowReviewLabelCell *newcell=[[MyShowReviewLabelCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reviewItem.identify];
            newcell.selectionStyle=UITableViewCellSelectionStyleNone;
            cell=newcell;
            
        }else if([item isKindOfClass:[MyShowPraiseBtnItem class]]){
            MyShowPraiseBtnItem *btnitem=[_dataArray objectAtIndex:indexPath.row];
            MyShowPraiseBtnCell *newcell=[[MyShowPraiseBtnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:btnitem.identify];
            newcell.selectionStyle=UITableViewCellSelectionStyleNone;
            newcell.praiseBtn.tag=indexPath.section;
            newcell.reviewBtn.tag=indexPath.section;
            newcell.reportBtn.tag=indexPath.row;
            if (_isSpecial == YES) {
                newcell.shareBtn.hidden = NO;
                newcell.shareBtn.tag = indexPath.section;
            }
            
            cell=newcell;
        }else if([item isKindOfClass:[MyShowPraisecountItem class]]){
            
            MyShowPraisecountItem *praiseitem=[_dataArray objectAtIndex:indexPath.row];
            MyShowPraiseCountBtnCell *newCell=[[MyShowPraiseCountBtnCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:praiseitem.identify];
            newCell.selectionStyle=UITableViewCellSelectionStyleNone;
            newCell.praiseListBtn.tag=indexPath.section;
            cell=newCell;
        }
        else{
            UITableViewCell *newcell=[[UITableViewCell alloc]init];
            cell=newcell;
        }
    }
    
    
    
    if ([item isKindOfClass:[MyShowImageGroupItem class]]) {
        
        MyShowImageGroupItem *imgGroupItem=[_dataArray objectAtIndex:indexPath.row];
        
        if (imgGroupItem.photosArray.count==1) {
            
            MyShowPhotoCell *newcell=(MyShowPhotoCell *)cell;
            newcell.photoImageView.frame=imgGroupItem.frame;
            newcell.photoImageView.backgroundColor=[BBSColor hexStringToColor:@"e6e6e6"];
            newcell.photoImageView.image=nil;
            [LoadingView startOntheView:newcell.photoImageView];
            
            MyShowImageItem *imgItem=[imgGroupItem.photosArray objectAtIndex:0];
            NSURL *url=[NSURL URLWithString:imgItem.imageStr];
            [LoadingView startOntheView:newcell.photoImageView];
            
            SDWebImageManager *manager=[SDWebImageManager sharedManager];
            [manager downloadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                
            } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                image=[MyShowImgFrame resizeImage:image ToSize:imgGroupItem.frame.size];
                
                CATransition *animation = [CATransition animation];
                [animation setDuration:0.1];
                [animation setFillMode:kCAFillModeForwards];
                [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
                [newcell.photoImageView.layer addAnimation:animation forKey:nil];
                
                [LoadingView stopOnTheView:newcell.photoImageView];
                newcell.photoImageView.image=image;
                
                
            }];
            
        }else{
            
            MyShowImgCell *newcell=(MyShowImgCell *)cell;
            [newcell.imgArray removeAllObjects];
            
            for (btnWithIndexPath *btn in newcell.contentView.subviews) {
                
                btn.hidden=YES;
                [btn setBackgroundImage:nil forState:UIControlStateNormal];
                [btn setBackgroundColor:[BBSColor hexStringToColor:@"e6e6e6"]];
                
            }
            
            
            if (imgGroupItem.photosArray.count==4) {
                
                for ( int i=0 ; i<imgGroupItem.photosArray.count ; i++ ) {
                    
                    MyShowImageItem *imgItem =[imgGroupItem.photosArray objectAtIndex:i];
                    btnWithIndexPath *imageview=[newcell.contentView.subviews objectAtIndex:i];
                    imageview.indexpath=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                    
                    if (i==2) {
                        
                        imageview=[newcell.contentView.subviews objectAtIndex:3];
                        imageview.indexpath=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                        
                    }
                    
                    if (i==3) {
                        
                        imageview=[newcell.contentView.subviews objectAtIndex:4];
                        imageview.indexpath=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                        
                    }
                    
                    [newcell.imgArray addObject:imgItem.imageClearStr];
                    
                    NSURL *imageUrl=[NSURL URLWithString:imgItem.imageStr];
                    
                    imageview.hidden=NO;
                    [LoadingView startOntheView:imageview];
                    
                    SDWebImageManager *manager=[SDWebImageManager sharedManager];
                    [manager downloadImageWithURL:imageUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                        
                    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                        image=[MyShowImgFrame scaleSmallImage:image];
                        
                        CATransition *animation = [CATransition animation];
                        [animation setDuration:0.1];
                        [animation setFillMode:kCAFillModeForwards];
                        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
                        [imageview.layer addAnimation:animation forKey:nil];
                        
                        [imageview setBackgroundImage:image forState:UIControlStateNormal];
                        [LoadingView stopOnTheView:imageview];
                        
                        
                    }];
                    
                }
                
            }else{
                
                NSUInteger max = imgGroupItem.photosArray.count;
                
                for (MyShowImageItem *item in imgGroupItem.photosArray) {
                    [newcell.imgArray addObject:item.imageClearStr];
                }
                
                if (imgGroupItem.photosArray.count>6) {
                    
                    max=6;
                    
                }
                
                for ( int i=0 ; i<max ; i++ ) {
                    
                    if (i==5) {
                        
                        btnWithIndexPath *imageview=[newcell.contentView.subviews objectAtIndex:i];
                        imageview.indexpath=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                        [imageview setBackgroundColor:[UIColor clearColor]];
                        UIImage *image=[UIImage imageNamed:@"img_myshow_more.png"];
                        [imageview setBackgroundImage:image forState:UIControlStateNormal];
                        imageview.hidden=NO;
                        
                    }else{
                        
                        MyShowImageItem *imgItem =[imgGroupItem.photosArray objectAtIndex:i];
                        btnWithIndexPath *imageview=[newcell.contentView.subviews objectAtIndex:i];
                        imageview.indexpath=[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
                        
                        //                        [newcell.imgArray addObject:imgItem.imageClearStr];
                        
                        NSURL *imageUrl=[NSURL URLWithString:imgItem.imageStr];
                        
                        imageview.hidden=NO;
                        [LoadingView startOntheView:imageview];
                        
                        SDWebImageManager *manager=[SDWebImageManager sharedManager];
                        [manager downloadImageWithURL:imageUrl options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                            
                        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                            
                            image=[MyShowImgFrame scaleSmallImage:image];
                            
                            CATransition *animation = [CATransition animation];
                            [animation setDuration:0.1];
                            [animation setFillMode:kCAFillModeForwards];
                            [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn]];
                            [imageview.layer addAnimation:animation forKey:nil];
                            
                            [imageview setBackgroundImage:image forState:UIControlStateNormal];
                            [LoadingView stopOnTheView:imageview];
                            
                        }];
                        
                    }
                    
                }
                
            }
            
        }
        
    }else if([item isKindOfClass:[MyShowPraisecountItem class]]){
        
        MyShowPraisecountItem *praiseitem=[_dataArray objectAtIndex:indexPath.row];
        int count=[praiseitem.count intValue];
        MyShowPraiseCountBtnCell *newcell=(MyShowPraiseCountBtnCell *)cell;
        newcell.praiseListBtn.tag=indexPath.section;
        //newcell.delegate=self;
        [newcell.praiseListBtn setTitle:[NSString stringWithFormat:@"%d条称赞",count] forState:UIControlStateNormal];
        newcell.groupImgView.hidden=YES;
        newcell.titleLabel.hidden=YES;
        
    }else if([item isKindOfClass:[MyShowReviewCountItem class]]){
        
        MyShowReviewCountItem *reviewcountItem=[_dataArray objectAtIndex:indexPath.row];
        MyShowMoreReviewBtnCell *newcell=(MyShowMoreReviewBtnCell *)cell;
        newcell.reviewlistBtn.tag=indexPath.section;
        newcell.delegate=self;
        [newcell.reviewlistBtn setTitle:reviewcountItem.reviewCount forState:UIControlStateNormal];
        
    }else if([item isKindOfClass:[MyShowDescribeItem class]]){
        
        MyShowDescribeItem *describeItem=[_dataArray objectAtIndex:indexPath.row];
        MyShowMessageCell *newcell=(MyShowMessageCell *)cell;
        newcell.reviewcontentLabel.text=describeItem.content;
        newcell.reviewcontentLabel.frame=CGRectMake(20, 0, 290, describeItem.height);
        
    }else if([item isKindOfClass:[MyShowReviewItem class]]){
        
        MyShowReviewItem *reviewItem=[_dataArray objectAtIndex:indexPath.row];
        MyShowReviewLabelCell *newcell=(MyShowReviewLabelCell *)cell;
        if ([[_dataArray objectAtIndex:0] isKindOfClass:[MyShowDescribeItem class]] && indexPath.row==3) {
            newcell.reviewImageView.hidden=NO;
        }else if([[_dataArray objectAtIndex:0] isKindOfClass:[MyShowImageItem class]] && indexPath.row==2){
            newcell.reviewImageView.hidden=NO;
        }else{
            newcell.reviewImageView.hidden=YES;
        }
        NSString *reviewcontent =[NSString stringWithFormat:@"%@:%@",reviewItem.username,reviewItem.content];
        CGRect frame = newcell.reviewcontentLabel.frame;
        frame.size.height = reviewItem.height;
        newcell.reviewcontentLabel.frame = frame;
        
        NSDictionary *dictionary =[BBSEmojiInfo detailContentWithStringAndEmoji:reviewcontent fromArray:facesArray];
        NSString *content = [dictionary objectForKey:@"content"];
        NSArray *tNumArray = [dictionary objectForKey:@"emoji"];
        
        newcell.reviewcontentLabel.text=content;
        [newcell.reviewcontentLabel setTextColor:[BBSColor hexStringToColor:BACKCOLOR] range:[content rangeOfString:[NSString stringWithFormat:@"%@:",reviewItem.username]]];
        
        for (NSInteger i = tNumArray.count-1; i >=0; i--) {
            NSDictionary *dict = [tNumArray objectAtIndex:i];
            int numid = [[dict objectForKey:@"location"] intValue];
            NSString * emojiText = [dict objectForKey:@"emojiText"];
            UIImage *image = [UIImage imageNamed:[facesDictionary objectForKey:emojiText]];
            image = [ImageScale scale:image toSize:CGSizeMake(20, 20)];
            [newcell.reviewcontentLabel insertImage:image atIndex:(numid-i*4) margins:UIEdgeInsetsMake(-2, 0, -2, 0)];
            
        }
        
        
    }else if([item isKindOfClass:[MyShowPraiseBtnItem class]]){
        
        MyShowPraiseBtnCell *newcell=(MyShowPraiseBtnCell *)cell;
        [newcell.praiseBtn setBackgroundImage:[UIImage imageNamed:@"btn_praise.png"] forState:UIControlStateNormal];
        MyShowPraiseBtnItem *praiseBtnItem=[_dataArray objectAtIndex:indexPath.row];
        if (praiseBtnItem.isAdmire) {
            UIImage *praiseimg=[UIImage imageNamed:@"btn_myshow_praised.png"];
            [newcell.praiseBtn setBackgroundImage:praiseimg forState:UIControlStateNormal];
        }
        newcell.praiseBtn.tag=indexPath.section;
        newcell.reviewBtn.tag=indexPath.section;
        newcell.reportBtn.tag=indexPath.row;
        newcell.shareBtn.tag = indexPath.section;
        newcell.delegate=self;
        
        
    }else if([item isKindOfClass:[MyShowReviewCountItem class]]){
        
        MyShowReviewCountItem *reviewcountItem=[_dataArray objectAtIndex:indexPath.row];
        MyShowMoreReviewBtnCell *newcell=(MyShowMoreReviewBtnCell *)cell;
        newcell.reviewlistBtn.tag=indexPath.section;
        newcell.delegate=self;
        [newcell.reviewlistBtn setTitle:reviewcountItem.reviewCount forState:UIControlStateNormal];
    }
    
    cell.contentView.backgroundColor=[UIColor clearColor];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

#pragma mark CellDelegate

-(void)imgViewOnClick:(btnWithIndexPath *)btn{
    
    MyShowImgCell *cell=(MyShowImgCell *)[_tableView cellForRowAtIndexPath:btn.indexpath];
    
    if (cell.imgArray.count==4) {
        
        if (cell.selectedIndex==3) {
            cell.selectedIndex=2;
        }
        
        if (cell.selectedIndex==4) {
            cell.selectedIndex=3;
        }
        
    }
    
    [_PhotoArray removeAllObjects];
    
    //---------------------------------------------------模板相册代码----------------------------------------------------------------------
    
    MyShowSectionItem *sectionItem=[_sectionArray objectAtIndex:btn.indexpath.section];
    
    MyShowDescribeItem *desItem;
    MyShowImageGroupItem *imgGroupItem;
    
    
    for (MyShowItem *item in _dataArray) {
        if ([item isKindOfClass:[MyShowDescribeItem class]]) {
            
            desItem=(MyShowDescribeItem *)item;
            
        }else if ([item isKindOfClass:[MyShowImageGroupItem class]]){
            
            imgGroupItem=(MyShowImageGroupItem *)item;
            
        }
    }
    
    NSMutableArray *imgArr = [[NSMutableArray alloc]init];
    for (MyShowImageItem *imgItem in imgGroupItem.photosArray) {
        
        NSMutableDictionary *imgDic=[[NSMutableDictionary alloc]init];
        [imgDic setObject:sectionItem.time forKey:kMyShowCreatTime];
        if (desItem) {
            [imgDic setObject:desItem.content forKey:kMyShowDescription];
        }
        [imgDic setObject:imgGroupItem.imgId forKey:kMyShowImgId];
        [imgDic setObject:imgItem.imageClearStr forKey:kMyShowImg];
        [imgDic setObject:imgItem.img_down forKey:kMyShowImgDown];
        [imgDic setObject:imgItem.img_width forKey:kMyShowImgWidth];
        [imgDic setObject:imgItem.img_height forKey:kMyShowImgHeight];
        [imgDic setObject:imgItem.imageStr forKey:kMyShowImgThumb];
        [imgDic setObject:imgItem.img_thumb_width forKey:kMyShowImgThumbWidth];
        [imgDic setObject:imgItem.img_thumb_height forKey:kMyShowImgThumbHeight];
        
        [imgArr addObject:imgDic];
        
    }
    int i = 0;
    for (NSString *imgClearStr in cell.imgArray) {
        
        MWPhoto *photo=[[MWPhoto alloc]initWithURL:[NSURL URLWithString:imgClearStr] info:nil];
        photo.img_info =@{@"description": [NSString stringWithFormat:@"%d/%lu",i+1,(unsigned long)cell.imgArray.count]};
        [_PhotoArray addObject:photo];
        i++;
    }
    
    MWPhotoBrowser *browser =[[ MWPhotoBrowser alloc]initWithDelegate:self];
    //    browser.imgstr=imgItem.imageStr;
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    [browser setCurrentPhotoIndex:cell.selectedIndex];
    browser.type = 10;
    browser.needPlay = YES;     //需要播放
    browser.imgArr = imgArr;    //播放需要的东西
    browser.is_show_album =NO;
    browser.user_id =self.userID;
    
    BBSNavigationController *nav=[[BBSNavigationController alloc]initWithRootViewController:browser];
    [self presentViewController:nav animated:YES completion:nil];
    
    
}


-(void)pressReportBtn:(UIButton *)button{
    
    UIActionSheet *act;
    
    UserInfoManager *manager=[[UserInfoManager alloc]init];
    UserInfoItem *currentUserInfo=[manager currentUserInfo];
    NSArray *userArray = [BABYSHOWSUPERGRANTUSER componentsSeparatedByString:@","];
    
    BOOL isSuperGrant = NO;
    for (int i = 0 ; i < userArray.count; i++) {
        NSString *user = [userArray objectAtIndex:i];
        if ([currentUserInfo.userId integerValue] == [user integerValue] )  {
            isSuperGrant = YES;
            break;
        }
    }
    MyShowSectionItem *sectionItem=[_sectionArray firstObject];
    
    if ( ([currentUserInfo.userId integerValue] ==[sectionItem.userid integerValue]) || isSuperGrant) {
        
        //自己发布的、或者自由环球租赁客服
        act=[[UIActionSheet alloc]initWithTitle:@"自由环球租赁" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil];
        [act showFromTabBar:self.tabBarController.tabBar];
        
    }else{
        
        //别人发布的
        act=[[UIActionSheet alloc]initWithTitle:@"自由环球租赁" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:nil];
        [act showFromTabBar:self.tabBarController.tabBar];
        
    }
    
    act.tag=button.tag;
    
}



-(void)pressMoreReviewBtn:(UIButton *)button{
    //这个是当前详情的发起人,self.user_id是消息列表中发出消息的那个人,不是发秀秀的人
    MyShowSectionItem *sectionItem=[_sectionArray firstObject];
    
    PraiseAndReviewListViewController *reviewsListVC=[[PraiseAndReviewListViewController alloc]init];
    reviewsListVC.imgID=self.imgID;
    reviewsListVC.isPost = self.isPost;
    reviewsListVC.useridBePraised=sectionItem.userid;
    reviewsListVC.ownerId = sectionItem.userid;
    reviewsListVC.type=MyShowReviewList;
    [self.navigationController pushViewController:reviewsListVC animated:YES];
    
}

-(void)pressPraiseBtn:(UIButton *)button{
    
    [LoadingView startOnTheViewController:self];
    NetAccess *praiseAccess=[NetAccess sharedNetAccess];
    
    MyShowPraiseBtnItem *pItem;
    
    for (MyShowItem *item in _dataArray) {
        
        if ([item isKindOfClass:[MyShowPraiseBtnItem class]]) {
            
            pItem=(MyShowPraiseBtnItem *)item;
            _pItem=pItem;
            
            NSInteger i=[_dataArray indexOfObject:item];
            NSIndexPath *indexpath=[NSIndexPath indexPathForRow:i inSection:0];
            _praiseBtnCell=(MyShowPraiseBtnCell *)[_tableView cellForRowAtIndexPath:indexpath];
            
        }
        
        if ([item isKindOfClass:[MyShowPraisecountItem class]]) {
            NSInteger i=[_dataArray indexOfObject:item];
            NSIndexPath *indexpath=[NSIndexPath indexPathForRow:i inSection:0];
            
            _praiseCountCell=(MyShowPraiseCountBtnCell *)[_tableView cellForRowAtIndexPath:indexpath];
            _praiseCountItem=(MyShowPraisecountItem *)[_dataArray objectAtIndex:i];
        }
        
    }
    
    NSString *loginUserId=LOGIN_USER_ID;
    MyShowSectionItem *sectionItem=[_sectionArray firstObject];
    NSDictionary *admireparam=[NSDictionary dictionaryWithObjectsAndKeys:
                               loginUserId,kAdmireUserId,
                               sectionItem.userid,kAdmireAdmireId,
                               self.imgID,kAdmireImgId,
                               [NSString stringWithFormat:@"%d",self.isPost],@"ispost",nil];
    
    if (!pItem.isAdmire) {
        
        [praiseAccess getDataWithStyle:NetStyleAdmire andParam:admireparam];
        
    }else if(pItem.isAdmire){
        
        [praiseAccess getDataWithStyle:NetStyleCancelAdmire andParam:admireparam];
        
    }
    
}

-(void)pressReviewBtn:(UIButton *)button{
    MyShowSectionItem *sectionItem=[_sectionArray firstObject];
    PraiseAndReviewListViewController *reviewsListVC=[[PraiseAndReviewListViewController alloc]init];
    reviewsListVC.imgID=self.imgID;
    reviewsListVC.isPost = self.isPost;
    reviewsListVC.useridBePraised = sectionItem.userid;
    reviewsListVC.ownerId = sectionItem.userid;
    reviewsListVC.type=MyShowAddReview;
    [self.navigationController pushViewController:reviewsListVC animated:YES];
    
}
-(void)pressShareBtn:(UIButton *)button
{
    [self shareToThird];
}
-(void)shareToThird
{
    MyShowSectionItem *sectionItem=[_sectionArray firstObject];
    self.userID = sectionItem.userid;
    NSString *desc = [NSString stringWithFormat:@"我在自由环球租赁参与了【%@】活动，我是%ld号，请大家帮我投一票吧！爱你呦",self.cateName,(long)self.rsort];
    //1、创建分享参数（必要）
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray;
    if (self.thumbString == nil) {
        imageArray = @[[UIImage imageNamed:@"img_default"]];
    } else {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.thumbString]];
        UIImage *shareImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
        NSData *basicImgData = UIImagePNGRepresentation(shareImg);
        if (basicImgData.length/1024>150) {
            shareImg =[self scaleToSize:shareImg size:CGSizeMake(30, 30)];
        }
        imageArray = @[shareImg];
    }
    NSString *titleStr = [NSString stringWithFormat:@"我参与了自由环球租赁【%@】活动",self.cateName];
    
    NSString *urlString = [NSString stringWithFormat:@"%@img_id=%@&user_id=%@",AppShareUrl,self.imgID,self.userID];
    [shareParams SSDKSetupShareParamsByText:desc
                                     images:imageArray
                                        url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]
                                      title:titleStr
                                       type:SSDKContentTypeAuto];
    NSString *contentSina = [NSString stringWithFormat:@"%@%@",desc,[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]]];
    [shareParams SSDKSetupSinaWeiboShareParamsByText:contentSina title:titleStr image:imageArray url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",urlString]] latitude:0.0 longitude:0.0 objectID:nil type:SSDKContentTypeAuto];
    //分享
    [ShareSDK showShareActionSheet:nil items:nil shareParams:shareParams onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
        switch (state) {
            case SSDKResponseStateBegin:
            {
                //  [storeVC showLoadingView:YES];
                break;
            }
            case SSDKResponseStateSuccess:
            {
                //Facebook Messenger、WhatsApp等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
//                
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
                break;
            }
            case SSDKResponseStateFail:
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                message:[NSString stringWithFormat:@"%@",error]
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                [alert show];
                break;
                break;
            }
            case SSDKResponseStateCancel:
            {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
//                                                                    message:nil
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"确定"
//                                                          otherButtonTitles:nil];
//                [alertView show];
                break;
            }
                
            default:
                break;
        }
    }];
    
    
    
}
- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)size{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}
- (void)copyURL:(NSString *)string {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [pasteboard setString:string];
}


#pragma mark MYShowSectionViewDelegate

-(void)ClickOnTheAvatar:(UIButton *) avatar{
    MyShowSectionItem *sectionItem=[_sectionArray firstObject];
    
    
    MyHomeNewVersionVC *myHomePage=[[MyHomeNewVersionVC alloc]init];
    
    myHomePage.userid=sectionItem.userid;
    
    NSString *loginUserId=LOGIN_USER_ID;
    
    if ([loginUserId integerValue]==[myHomePage.userid integerValue]) {
        
        myHomePage.Type=0;
        
    }else{
        
        myHomePage.Type=1;
        
    }
    
    [self.navigationController pushViewController:myHomePage animated:YES];
    
}

#pragma mark praise

-(void)praiseSucceed{
    
    if (_pItem.isAdmire==0) {
        _pItem.isAdmire=1;
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_CHANGE_PRAISE_COUNT object:_pItem];
    
}

-(void)praiseFail:(NSNotification *) not{
    [LoadingView stopOnTheViewController:self];
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
}

-(void)changePraiseCount:(NSNotification *)not{
    
    if (_pItem.isAdmire==1) {
        
        int count=(int)[_praiseCountItem.count integerValue];
        _praiseCountItem.count=[NSString stringWithFormat:@"%d",count+1];
        [_praiseCountCell.praiseListBtn setTitle:[NSString stringWithFormat:@"%d条称赞",count+1] forState:UIControlStateNormal];
        
        UIImage *praiseimg=[UIImage imageNamed:@"btn_myshow_praised.png"];
        [_praiseBtnCell.praiseBtn setBackgroundImage:praiseimg forState:UIControlStateNormal];
        
    }
    if (_pItem.isAdmire==0) {
        
        int count=(int)[_praiseCountItem.count integerValue];
        _praiseCountItem.count=[NSString stringWithFormat:@"%d",count-1];
        [_praiseCountCell.praiseListBtn setTitle:[NSString stringWithFormat:@"%d条称赞",count-1] forState:UIControlStateNormal];
        
        UIImage *praiseimg=[UIImage imageNamed:@"btn_praise.png"];
        [_praiseBtnCell.praiseBtn setBackgroundImage:praiseimg forState:UIControlStateNormal];
    }
    
    [LoadingView stopOnTheViewController:self];
}

-(void)cancelpraiseSucceed{
    if (_pItem.isAdmire==1) {
        _pItem.isAdmire=0;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_CHANGE_PRAISE_COUNT object:_pItem];
    //    [BBSAlert showAlertWithContent:@"取消赞成功" andDelegate:self];
    
}

-(void)cancelpraiseFail:(NSNotification *) not{
    
    [LoadingView stopOnTheViewController:self];
    
    NSString *errorString=not.object;
    [BBSAlert showAlertWithContent:errorString andDelegate:self];
    
}


#pragma mark UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex==0){
        
        UserInfoManager *manager=[[UserInfoManager alloc]init];
        UserInfoItem *currentUserInfo=[manager currentUserInfo];
        NSArray *userArray = [BABYSHOWSUPERGRANTUSER componentsSeparatedByString:@","];
        
        BOOL isSuperGrant = NO;
        for (int i = 0 ; i < userArray.count; i++) {
            NSString *user = [userArray objectAtIndex:i];
            if ([currentUserInfo.userId integerValue] == [user integerValue] )  {
                isSuperGrant = YES;
                break;
            }
        }
        MyShowSectionItem *sectionItem=[_sectionArray firstObject];
        
        if ( ([currentUserInfo.userId integerValue]==[sectionItem.userid integerValue]) || isSuperGrant) {
            
            //自己发布的、登录用户是自由环球租赁客服
            self.userID = currentUserInfo.userId;
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"自由环球租赁" message:@"确定要删除这条秀秀吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
            alert.tag=actionSheet.tag;
            [alert show];
            
        }else{
            
            //别人发布的
            [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
            //举报
            
            ReportViewController *report=[[ReportViewController alloc]init];
            report.imgId=self.imgID;
            report.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:report animated:YES];
            
        }
        
    }
    
}

#pragma mark Private

#pragma mark 剪裁图片

-(UIImage *)scaleImage:(UIImage *) image{
    
    if (image.size.width>image.size.height) {
        //宽图
        
        float x=image.size.width/2-image.size.height/2;
        CGRect rect=CGRectMake(x, 0, image.size.height, image.size.height);
        
        CGImageRef imageRef = image.CGImage;
        CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
        
        CGSize size=CGSizeMake(image.size.height, image.size.height);
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, rect, subImageRef);
        image = [UIImage imageWithCGImage:subImageRef];
        UIGraphicsEndImageContext();
        
    }else if (image.size.width<image.size.height){
        //长图
        
        float y=image.size.height/3-image.size.width/3;
        CGRect rect=CGRectMake(0, y, image.size.width, image.size.width);
        
        CGImageRef imageRef = image.CGImage;
        CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, rect);
        
        CGSize size=CGSizeMake(image.size.width, image.size.width);
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextDrawImage(context, rect, subImageRef);
        image = [UIImage imageWithCGImage:subImageRef];
        UIGraphicsEndImageContext();
        
    }
    
    return image;
}


-(void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser{
    
    return _PhotoArray.count;
    
}
-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index{
    
    if (index < _PhotoArray.count) {
        
        return [_PhotoArray objectAtIndex:index];
        
    }
    
    return nil;
    
}

#pragma mark UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        //删除
        
        [LoadingView startOnTheViewController:self];
        NSLog(@"self.user_id = %@",self.userID);
        
        NSDictionary *delParam=[NSDictionary dictionaryWithObjectsAndKeys:self.imgID,@"img_ids",
                                self.userID,@"user_id", nil];
        
        NetAccess *net=[NetAccess sharedNetAccess];
        if (_isSpecial == YES) {
            [net getDataWithStyle:NetStyleDelSpecial andParam:delParam];
        }else{
            [net getDataWithStyle:NetStyleDelShow andParam:delParam];
        }
        
    }
    
}

@end
