//
//  PostBarNewReplyView.h
//  BabyShow
//
//  Created by Monica on 10/27/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacialView.h"
#import "ImageViewWithBtn.h"

@protocol PostBarNewReplyViewDelegate <NSObject>

-(void)send;
-(void)selectPhotos;
-(void)savePost;

@end

@interface PostBarNewReplyView : UIView<FacialViewDelegate,UIScrollViewDelegate,ImageViewWithBtnDelegate,UITextViewDelegate>

-(void)editContet;
-(void)selectEmoji;
-(void)moveDown;
-(void)moveUp;

-(void)changeToReviewToolBar;
-(void)changetoPostToolBar;

-(void)showPhotosWithArray:(NSArray *) photos;
-(void)remowSubviews;
-(void)initTextView;
-(void)hiddenPhotoBtn;
-(void)savePostBtn:(BOOL)isSave;
@property (nonatomic, assign) id <PostBarNewReplyViewDelegate> delegate;
@property (nonatomic, strong) UIButton *sendBtn;
@property (nonatomic, strong) UIButton *addPhotoBtn;
@property(nonatomic,strong)UIButton *savcBtn;
@property (nonatomic, strong) UITextField *textField;
@property(nonatomic,strong)UITextView *textView;

@property (nonatomic, strong) NSMutableArray *photosArray;
@property(nonatomic,assign)float keyFloat;
@property(nonatomic,assign)BOOL havePhotoBtn;


@end
