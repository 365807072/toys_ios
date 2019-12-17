//
//  InputToolBarUtility.h
//  EmojiDemo
//
//  Created by mayeon on 14-2-20.
//  Copyright (c) 2014年 北京美美科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FacialView.h"
#import "UIExpandingTextView.h"
#import "PraiseAndReviewListViewController.h"

#define  Time  0.25
#define  keyboardHeight 216
#define  toolBarHeight 44
#define  choiceBarHeight 35
#define  facialViewWidth 300
#define  facialViewHeight 170
#define  buttonWh 34

//表情的字符串长度为4,普通的字符串长度为1
#define kEmojiTextLength            4
#define kCommonTextLength           1

#define page_num  3

@protocol FaceToolBarDelegate <NSObject>
-(void)sendTextAction:(NSString *)inputText;
@end

@interface InputToolBarUtility : UIToolbar<FacialViewDelegate,UIExpandingTextViewDelegate,UIScrollViewDelegate,ClickDelegate>
{
    UIToolbar *toolBar;//工具栏
    UIExpandingTextView *textView;//文本输入框
    UIButton *faceButton ;
    UIButton *sendButton;
    
    BOOL keyboardIsShow;//键盘是否显示
    
    UIScrollView *scrollView;//表情滚动视图
    UIPageControl *pageControl;
    
    UIViewController *theSuperViewController;
//    CGFloat currkeyBoardHeight;
    id <FaceToolBarDelegate> tooldelegate;
}
@property(nonatomic,retain)UIViewController *theSuperViewController;
@property (assign) id<FaceToolBarDelegate> tooldelegate;
@property (nonatomic ,strong)UIExpandingTextView *textView;//文本输入框

-(id)initWithFrame:(CGRect)frame superViewController:(UIViewController *)superViewController;
-(void)keyboardRemove;
@end
