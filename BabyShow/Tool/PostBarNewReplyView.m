//
//  PostBarNewReplyView.m
//  BabyShow
//
//  Created by Monica on 10/27/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "PostBarNewReplyView.h"
#import "UIImageView+WebCache.h"

#define  facialViewWidth 300
#define facialViewHeight 170
#define kEmojiTextLength            4
#define kCommonTextLength           1

@implementation PostBarNewReplyView

{
    UIView *_editView;
    
    UIView *_photoView;
    UIScrollView *_emojiView;
    UIButton *_photoBtn;
    
    UIPageControl *pageControl;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.photosArray=[NSMutableArray array];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillDisapper:) name:UIKeyboardWillHideNotification object:nil];
        
        self.frame=CGRectMake(0, SCREENHEIGHT-40, SCREENWIDTH, 256);
        self.backgroundColor=[UIColor whiteColor];
        
        _editView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 40)];
        _editView.backgroundColor = [BBSColor hexStringToColor:@"f4f5f6"];
        
        //输入框
        self.textField=[[UITextField alloc]initWithFrame:CGRectMake(12, 4, 133, 32)];
        self.textView = [[UITextView alloc]initWithFrame:CGRectMake(12, 4, 133, 32)];
        self.textView.layer.borderColor = [UIColor grayColor].CGColor;
        self.textView.font = [UIFont systemFontOfSize:14];
        self.textView.layer.borderWidth = 0.5;
        self.textView.layer.cornerRadius = 15;
        self.textView.text = @" 写评论...";
        self.textView.textColor = [UIColor lightGrayColor];
        self.textView.delegate = self;
        
        [_editView addSubview:self.textView];
        
        //照片
        _photoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _photoBtn.frame=CGRectMake(self.textField.frame.origin.x+self.textField.frame.size.width+16, 10,18, 19);
        [_photoBtn setBackgroundImage:[UIImage imageNamed:@"btn_make_a_post_add_photo"] forState:UIControlStateNormal];
        [_photoBtn addTarget:self action:@selector(PhotosOnClick) forControlEvents:UIControlEventTouchUpInside];
        [_editView addSubview:_photoBtn];
        
        
        //表情
        UIButton *_emojiBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _emojiBtn.frame=CGRectMake(_photoBtn.frame.origin.x+_photoBtn.frame.size.width+16, 10, 19,19);
        [_emojiBtn setBackgroundImage:[UIImage imageNamed:@"btn_make_a_post_emoji"] forState:UIControlStateNormal];
        [_emojiBtn addTarget:self action:@selector(selectEmoji) forControlEvents:UIControlEventTouchUpInside];
        [_editView addSubview:_emojiBtn];
        
        _savcBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        _savcBtn.frame=CGRectMake(_emojiBtn.frame.origin.x+_emojiBtn.frame.size.width+14, 10,18, 19);
        [_savcBtn setBackgroundImage:[UIImage imageNamed:@"post_unsave"] forState:UIControlStateNormal];
        [_savcBtn addTarget:self action:@selector(savePostClick) forControlEvents:UIControlEventTouchUpInside];
        [_editView addSubview:_savcBtn];

        
        //发送
        
        self.sendBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.sendBtn.frame=CGRectMake(_savcBtn.frame.origin.x+_savcBtn.frame.size.width+14 , 6, 56, 26);
        [self.sendBtn setBackgroundImage:[UIImage imageNamed:@"btn_postbar_new_send"] forState:UIControlStateNormal];
        [self.sendBtn addTarget:self action:@selector(OnClick) forControlEvents:UIControlEventTouchUpInside];
        [_editView addSubview:self.sendBtn];
        
        [self addSubview:_editView];
        
        _photoView=[[UIView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 216)];
        _photoView.backgroundColor=[UIColor whiteColor];
        
        [self addSubview:_photoView];
        
        self.addPhotoBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.addPhotoBtn.frame=CGRectMake(5, 5, 100, 100);
        [self.addPhotoBtn setBackgroundImage:[UIImage imageNamed:@"btn_make_a_show_add_photo_gray"] forState:UIControlStateNormal];
        [self.addPhotoBtn addTarget:self action:@selector(addPhoto) forControlEvents:UIControlEventTouchUpInside];
        [_photoView addSubview:self.addPhotoBtn];
        
        _emojiView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, SCREENWIDTH, 216)];
        _emojiView.contentSize=CGSizeMake(SCREENWIDTH*3, 216);
        _emojiView.pagingEnabled=YES;
        _emojiView.backgroundColor=[UIColor whiteColor];
        _emojiView.showsVerticalScrollIndicator=NO;
        _emojiView.showsHorizontalScrollIndicator=NO;
        _emojiView.scrollsToTop=NO;
        _emojiView.delegate=self;
        [self addSubview:_emojiView];
        
        for (int i=0; i<3; i++) {
            FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+320*i, 15, facialViewWidth, facialViewHeight)];
            [fview setBackgroundColor:[UIColor clearColor]];
            [fview loadFacialView:i size:CGSizeMake(33, 43)];
            fview.delegate=self;
            [_emojiView addSubview:fview];
        }
        
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(85, 226, 150, 30)];
        [pageControl setCurrentPage:0];
        pageControl.pageIndicatorTintColor=RGBACOLOR(195, 179, 163, 1);
        pageControl.currentPageIndicatorTintColor=RGBACOLOR(132, 104, 77, 1);
        pageControl.numberOfPages = 3;//指定页面个数
        [pageControl setBackgroundColor:[UIColor clearColor]];
        pageControl.hidden=NO;
        [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
        [self addSubview:pageControl];
        
    }
    return self;
}
-(void)hiddenPhotoBtn{
    _photoBtn.hidden = YES;
    self.textView.frame = CGRectMake(12, 4, 170, 32);
    
}
-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = _emojiView.contentOffset.x / 320;//通过滚动的偏移量来判断目前页面所对应的小白点
    pageControl.currentPage = page;//pagecontroll响应值的变化
}

#pragma mark Delegate
//点击收藏按钮
-(void)savePostClick{
    if ([self.delegate respondsToSelector:@selector(savePost)]) {
        [self.delegate savePost];
    }

}
//判断话题是否收藏

-(void)savePostBtn:(BOOL)isSave{
    if (isSave == YES) {
        
        [_savcBtn setBackgroundImage:[UIImage imageNamed:@"post_save"] forState:UIControlStateNormal];
    }else{
        [_savcBtn setBackgroundImage:[UIImage imageNamed:@"post_unsave"] forState:UIControlStateNormal];

    }
}

-(void)OnClick{
    
    if ([self.delegate respondsToSelector:@selector(send)]) {
        [self.delegate send];
    }
    
}

-(void)addPhoto{
    
    if ([self.delegate respondsToSelector:@selector(selectPhotos)]) {
        [self.delegate selectPhotos];
    }
    
}

-(void)PhotosOnClick{
    
    [_textView resignFirstResponder];
    [self moveUp];
    [self bringSubviewToFront:_photoView];
    
}

-(void)selectEmoji{
    
    [_textView resignFirstResponder];
    if ([_textView.text isEqualToString:@" 写评论..."]) {
        _textView.text = nil;
        //字体颜色
        _textView.textColor = [UIColor blackColor];
    }
    
    _emojiView.frame = CGRectMake(0, _editView.frame.origin.y+_editView.frame.size.height, SCREENWIDTH, 216);
    [self moveUp];
    pageControl.frame = CGRectMake(85, self.frame.size.height-30, 150, 30);
    [self bringSubviewToFront:_emojiView];
    [self bringSubviewToFront:pageControl];
    
}

-(void)editContet{
    
    [self moveUp];
    
}

#pragma mark publick

-(void)changeToReviewToolBar{
    
    _photoBtn.hidden=YES;
    self.textField.frame=CGRectMake(12, 3,133, 32);
    
}

-(void)changetoPostToolBar{
    [_textView resignFirstResponder];
    self.frame=CGRectMake(0, SCREENHEIGHT-40, SCREENWIDTH, 40);
    _textView.text = @" 写评论...";
    _textView.textColor = [UIColor lightGrayColor];
    _editView.frame = CGRectMake(0, 0, self.frame.size.width, 40);
    if (_havePhotoBtn == YES) {
        _textView.frame = CGRectMake(12, 4, 190, 32);
      _photoBtn.hidden=YES;
    }else{
        _textView.frame = CGRectMake(12, 4, 133, 32);
        _photoBtn.hidden=NO;

    }
    self.textField.frame=CGRectMake(12, 3,133, 32);
    
    
}

-(void)moveUp{
   self.frame =CGRectMake(0, SCREENHEIGHT-(216+_editView.frame.size.height), SCREENWIDTH, 216+_editView.frame.size.height);
//_textView.text = @"";
}

-(void)moveDown{
    
    [_textView resignFirstResponder];
    self.frame=CGRectMake(0, SCREENHEIGHT-40, SCREENWIDTH, 40);
    if (_havePhotoBtn == YES) {
        _textView.frame = CGRectMake(12, 4, 190, 32);

    }else{
    _textView.frame = CGRectMake(12, 4, 133, 32);
    }
}

-(void)showPhotosWithArray:(NSArray *)photos{
    
    for (int i=0; i<photos.count; i++) {
        
        int section=i/3;
        int row=i%3;
        CGRect frame=CGRectMake(5+row*105, 5+105*section, 100, 100);
        ImageViewWithBtn *imgView=[[ImageViewWithBtn alloc]initWithFrame:frame];
        imgView.deleteBtn.tag=i;
        imgView.delegate=self;
        
        id obj=[photos objectAtIndex:i];
        if ([obj isKindOfClass:[UIImage class]]) {
            UIImage *image=(UIImage *)obj;
            imgView.image=image;
        }else if ([obj isKindOfClass:[NSDictionary class]]){
            
            NSDictionary *imgDic=(NSDictionary *)obj;
            NSString *thumbUrlStr=[imgDic objectForKey:@"img_thumb"];
            
            [imgView sd_setImageWithURL:[NSURL URLWithString:thumbUrlStr]];
        }
        
        [_photoView addSubview:imgView];
        
        int addSection=(i+1)/3;
        int addRow=(i+1)%3;
        self.addPhotoBtn.frame=CGRectMake(5+addRow*105, 5+105*addSection, 100, 100);
        
    }
    
}

-(void)remowSubviews{
    
    for (id obj in _photoView.subviews) {
        if ([obj isKindOfClass:[ImageViewWithBtn class]]) {
            [obj removeFromSuperview];
        }
    }
    
    self.addPhotoBtn.frame=CGRectMake(5, 5, 100, 100);
    
}

#pragma mark notification

-(void)keyboardWillShow:(NSNotification *) note{
    if ([_textView.text isEqualToString:@" 写评论..."]) {
        _textView.text = nil;
        //字体颜色
        _textView.textColor = [UIColor blackColor];
      
    }
    NSDictionary *userInfoDic=[note userInfo];
    NSValue *framenValue=[userInfoDic objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect frame=[framenValue CGRectValue];
    self.keyFloat = frame.size.height;
    self.frame =CGRectMake(0, SCREENHEIGHT-frame.size.height-_editView.frame.size.height, SCREENWIDTH, frame.size.height+_editView.frame.size.height);
}

-(void)keyboardWillDisapper:(NSNotification *) note{
    NSLog(@"nsno = %@",note);
    if ([_textView.text isEqualToString:@""]||_textView.text == nil) {
        _textView.text = @" 写评论...";
        //字体颜色
        _textView.textColor = [UIColor lightGrayColor];
        
    }
    NSLog(@"键盘消失的时候");
    self.frame=CGRectMake(0, SCREENHEIGHT-40, SCREENWIDTH, 40);
    
}

#pragma mark UIPageControl

- (IBAction)changePage:(id)sender {
    NSInteger page = pageControl.currentPage;//获取当前pagecontroll的值
    [_emojiView setContentOffset:CGPointMake(320 * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}

#pragma mark facialView delegate 点击表情键盘上的文字

-(void)selectedFacialView:(NSString*)str emojiArray:(NSArray *)array
{
    if ([str isEqualToString:@"删除"]) {
        NSInteger currenttextlength = _textView.text.length;
        
        if (currenttextlength) {
            //当前删除的是表情
            if ([_textView.text hasSuffix:@"]"]) {
                NSString *rangtext = [_textView.text substringFromIndex:currenttextlength -kEmojiTextLength ];
                BOOL isEmojiText =  [array containsObject:rangtext];
                
                if (isEmojiText) {
                    _textView.text = [_textView.text substringWithRange:NSMakeRange(0, currenttextlength - kEmojiTextLength)];
                } else {
                    _textView.text = [_textView.text substringWithRange:NSMakeRange(0, currenttextlength - kCommonTextLength)];
                }
            } else {
                //当前删除的是普通字符串
                _textView.text = [_textView.text substringWithRange:NSMakeRange(0, currenttextlength - kCommonTextLength)];
            }
        }
    }else{
        NSString *newStr=[NSString stringWithFormat:@"%@%@",_textView.text,str];
        [_textView setText:newStr];
    }
    
    
}

-(void)DeleteOnClick:(UIButton *)btn{
    
    NSInteger index=btn.tag;
    
    [self.photosArray removeObjectAtIndex:index];
    
    [self remowSubviews];
    
    [self showPhotosWithArray:self.photosArray];
    
}
-(void)textViewDidChange:(UITextView *)textView{
    CGRect bounds = textView.bounds;
    CGSize maxSize;
    if (_havePhotoBtn == YES) {
        maxSize = CGSizeMake(190, CGFLOAT_MAX);
    }else{
        maxSize = CGSizeMake(133, CGFLOAT_MAX);
    }
    CGSize newSize = [textView sizeThatFits:maxSize];
    bounds.size = newSize;
    textView.bounds = bounds;
    float height;
    if (newSize.height >66.5) {
        textView.scrollEnabled = YES;
        height = 66.5;
    }else{
        textView.scrollEnabled = NO;
        height = newSize.height;
    }
    self.frame=CGRectMake(0, SCREENHEIGHT-self.keyFloat-height, self.frame.size.width,self.keyFloat+height);
    _editView.frame = CGRectMake(0 ,0, _editView.frame.size.width, height+8);
    if (_havePhotoBtn == YES) {
        textView.frame=CGRectMake(12, 4,190,height);

    }else{
        textView.frame=CGRectMake(12, 4,133,height);

    }
    _photoView.frame = CGRectMake(0, _editView.frame.origin.y+_editView.frame.size.height, SCREENWIDTH, 216);
    _emojiView.frame = CGRectMake(0, _editView.frame.origin.y+_editView.frame.size.height, SCREENWIDTH, 216);
    
}
@end
