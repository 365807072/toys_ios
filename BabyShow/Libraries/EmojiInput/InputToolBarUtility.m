//
//  InputToolBarUtility.m
//  EmojiDemo
//
//  Created by mayeon on 14-2-20.
//  Copyright (c) 2014年 北京美美科技有限公司. All rights reserved.
//

#import "InputToolBarUtility.h"
#import "PraiseAndReviewListViewController.h"

@implementation InputToolBarUtility
@synthesize  theSuperViewController = theSuperViewController;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame superViewController:(UIViewController *)superViewController{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        //初始化为NO
        keyboardIsShow=NO;
        self.hidden = YES;  //不知道为什么会多添加一个toobar,只好把这个隐藏
        self.theSuperViewController=superViewController;
        //默认toolBar在视图最下方
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0.0f,superViewController.view.bounds.size.height - toolBarHeight,superViewController.view.bounds.size.width,toolBarHeight)];
        toolBar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        [toolBar setBarStyle:UIBarStyleDefault];
        toolBar.backgroundColor = [BBSColor hexStringToColor:@"f1f1f1"];
        
        //可以自适应高度的文本输入框,UIView
        textView = [[UIExpandingTextView alloc] initWithFrame:CGRectMake(40, 0, 210+30, 55)];
        textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(4.0f, 0.0f, 10.0f, 0.0f);
        [textView.internalTextView setReturnKeyType:UIReturnKeyDefault];
        textView.delegate = self;
        textView.placeholder = @"评论";
        textView.maximumNumberOfLines=4;
        [toolBar addSubview:textView];

        //表情按钮
        faceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        faceButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        [faceButton setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
        [faceButton addTarget:self action:@selector(displayFaceKeyboard) forControlEvents:UIControlEventTouchUpInside];
        faceButton.frame =CGRectMake(5,toolBar.bounds.size.height-38.0f,buttonWh,buttonWh);
        [toolBar addSubview:faceButton];
        
        //发送按钮
        sendButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [sendButton setTitleColor:[BBSColor hexStringToColor:BACKCOLOR] forState:UIControlStateNormal];
        sendButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin;
        sendButton.enabled=NO;
        //        [sendButton setBackgroundImage:[UIImage imageNamed:@"send"] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
        sendButton.frame = CGRectMake(toolBar.bounds.size.width - 40.0f,toolBar.bounds.size.height-38.0f,buttonWh+4,buttonWh);
        [toolBar addSubview:sendButton];
        
        //给键盘注册通知
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(inputKeyboardChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeState:)
                                                     name:CHANGE_STATE_NOTI
                                                   object:nil];
        
        
        //创建表情键盘
        if (scrollView==nil) {
            scrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, superViewController.view.frame.size.height, superViewController.view.frame.size.width, keyboardHeight)];
            [scrollView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"facesBack"]]];
            for (int i=0; i<page_num; i++) {
                FacialView *fview=[[FacialView alloc] initWithFrame:CGRectMake(12+320*i, 15, facialViewWidth, facialViewHeight)];
                [fview setBackgroundColor:[UIColor clearColor]];
                [fview loadFacialView:i size:CGSizeMake(33, 43)];
                fview.delegate=self;
                [scrollView addSubview:fview];
            }
        }
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        scrollView.contentSize=CGSizeMake(320*page_num, keyboardHeight);
        scrollView.pagingEnabled=YES;
        scrollView.delegate=self;
        [superViewController.view addSubview:scrollView];
        
        pageControl=[[UIPageControl alloc]initWithFrame:CGRectMake(85, superViewController.view.frame.size.height-30, 150, 30)];
        [pageControl setCurrentPage:0];
        pageControl.pageIndicatorTintColor=RGBACOLOR(195, 179, 163, 1);
        pageControl.currentPageIndicatorTintColor=RGBACOLOR(132, 104, 77, 1);
        pageControl.numberOfPages = page_num;//指定页面个数
        [pageControl setBackgroundColor:[UIColor clearColor]];
        pageControl.hidden=YES;
        [pageControl addTarget:self action:@selector(changePage:)forControlEvents:UIControlEventValueChanged];
        [superViewController.view addSubview:pageControl];
        
        [superViewController.view addSubview:toolBar];
        // Do any additional setup after loading the view, typically from a nib.
    }
    return self;
}
#pragma mark - changestate Methods
-(void)changeState:(NSNotification *)notification{
//    {
//        "to_other" = 1;
//        "user_name" = guoguo;
//    }
    BOOL is_to_other = [[notification.userInfo objectForKey:@"to_other"] boolValue];
    if (is_to_other) {
        textView.placeholder = @"评论"; //[NSString stringWithFormat:@"回复:%@",[notification.userInfo objectForKey:@"user_name"]];
        textView.text = [NSString stringWithFormat:@"@%@:",[notification.userInfo objectForKey:@"user_name"]];
    }else{
        textView.placeholder = @"评论";
        [self resignFirstRes];
    }
}
-(void)keyboardRemove{
    [self resignFirstRes];
}
-(void)resignFirstRes{
    [textView.internalTextView resignFirstResponder];
    [scrollView setFrame:CGRectMake(0, self.theSuperViewController.view.frame.size.height, self.theSuperViewController.view.frame.size.width, keyboardHeight)];
    [toolBar setFrame:CGRectMake(0, self.theSuperViewController.view.frame.size.height-toolBar.frame.size.height,self.theSuperViewController.view.frame.size.width,toolBar.frame.size.height)];
}
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    int page = scrollView.contentOffset.x / 320;//通过滚动的偏移量来判断目前页面所对应的小白点
    pageControl.currentPage = page;//pagecontroll响应值的变化
}
//pagecontroll的委托方法

- (IBAction)changePage:(id)sender {
    NSInteger page = pageControl.currentPage;//获取当前pagecontroll的值
    [scrollView setContentOffset:CGPointMake(320 * page, 0)];//根据pagecontroll的值来改变scrollview的滚动位置，以此切换到指定的页面
}
#pragma mark - ClickDelegate Methods
-(void)clickToResignFirstResponder{
    [self resignFirstRes];
}

#pragma mark -
#pragma mark UIExpandingTextView delegate
//改变键盘高度
-(void)expandingTextView:(UIExpandingTextView *)expandingTextView willChangeHeight:(float)height
{
    /* Adjust the height of the toolbar when the input component expands */
    float diff = (textView.frame.size.height - height);
//    float diff = -30;
    CGRect r = toolBar.frame;
    r.origin.y += diff;
    r.size.height -= diff;
    toolBar.frame = r;
    if (expandingTextView.text.length>2&&[[Emoji allEmoji] containsObject:[expandingTextView.text substringFromIndex:expandingTextView.text.length-2]])
    {
        textView.internalTextView.contentOffset=CGPointMake(0,textView.internalTextView.contentSize.height-textView.internalTextView.frame.size.height );
    }
    
}
//return方法
- (BOOL)expandingTextViewShouldReturn:(UIExpandingTextView *)expandingTextView{
//    [self sendAction];
//    [expandingTextView resignFirstResponder];
    return YES;
}
//文本是否改变
-(void)expandingTextViewDidChange:(UIExpandingTextView *)expandingTextView
{
//    NSLog(@"文本的长度%d",textView.text.length);
    /* Enable/Disable the button */
    if ([expandingTextView.text length] > 0)
        sendButton.enabled = YES;
    else
        sendButton.enabled = NO;
}
- (void)expandingTextViewDidChangeSelection:(UIExpandingTextView *)expandingTextView{
    
}
#pragma mark -
#pragma mark ActionMethods  发送sendAction  显示表情 displayFaceKeyboard
-(void)sendAction{

//    NSString *sendText = [textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    sendText = [sendText stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
    if (textView.text.length>0) {

        PraiseAndReviewListViewController *controller = (PraiseAndReviewListViewController *)self.theSuperViewController;
        if ([controller respondsToSelector:@selector(sendText:)]) {
            [controller sendText:textView.text];
            [textView clearText];
        }
    }
}

-(void)displayFaceKeyboard{
    
    PraiseAndReviewListViewController *controller = (PraiseAndReviewListViewController *)self.theSuperViewController;
    
    //如果直接点击表情，通过toolbar的位置来判断
    if (toolBar.frame.origin.y== self.theSuperViewController.view.bounds.size.height - toolBarHeight&&toolBar.frame.size.height==toolBarHeight) {
       
        [UIView animateWithDuration:Time animations:^{
            toolBar.frame = CGRectMake(0, self.theSuperViewController.view.frame.size.height-keyboardHeight-toolBarHeight,  self.theSuperViewController.view.bounds.size.width,toolBarHeight);
            controller.tableview.frame =CGRectMake(0, 0, controller.view.frame.size.width, controller.view.frame.size.height-toolBarHeight-keyboardHeight);
            [scrollView setFrame:CGRectMake(0, self.theSuperViewController.view.frame.size.height-keyboardHeight,self.theSuperViewController.view.frame.size.width, keyboardHeight)];
        } completion:^(BOOL finished) {
//            if (controller.dataArray.count >1) {
//                [chatViewController.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:chatViewController.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//            }
        }];
        [pageControl setHidden:NO];
        [faceButton setBackgroundImage:[UIImage imageNamed:@"Text"] forState:UIControlStateNormal];
        return;
    }
    //如果键盘没有显示，点击表情了，隐藏表情，显示键盘
    if (!keyboardIsShow) {
        [UIView animateWithDuration:Time animations:^{
            [scrollView setFrame:CGRectMake(0, self.theSuperViewController.view.frame.size.height, self.theSuperViewController.view.frame.size.width, keyboardHeight)];
        }];
        [textView becomeFirstResponder];
        [pageControl setHidden:YES];
        
    }else{
        
        //键盘显示的时候，toolbar需要还原到正常位置，并显示表情
        [UIView animateWithDuration:Time animations:^{
            toolBar.frame = CGRectMake(0, self.theSuperViewController.view.frame.size.height-keyboardHeight-toolBar.frame.size.height,  self.theSuperViewController.view.bounds.size.width,toolBar.frame.size.height);
            controller.tableview.frame =CGRectMake(0, 0, controller.view.frame.size.width, controller.view.frame.size.height-toolBar.frame.size.height-keyboardHeight);
            [scrollView setFrame:CGRectMake(0, self.theSuperViewController.view.frame.size.height-keyboardHeight,self.theSuperViewController.view.frame.size.width, keyboardHeight)];
        }];
    
        [pageControl setHidden:NO];
        [textView resignFirstResponder];
    }
    
}

#pragma mark 监听键盘的显示与隐藏 ,中英文的切换的时候会有一个36的显示汉字的条条
-(void)inputKeyboardChangeFrame:(NSNotification *)noti{
    NSValue *value = [noti.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    PraiseAndReviewListViewController *controller = (PraiseAndReviewListViewController *)self.theSuperViewController;
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        controller.tableview.frame =CGRectMake(0, 0, controller.view.frame.size.width, controller.view.frame.size.height-toolBarHeight-keyboardSize.height);
    } completion:^(BOOL finished) {
//        if (controller.dataArray.count >1) {
//            [chatViewController.contentTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:chatViewController.dataArray.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//        }
    }];
}
-(void)inputKeyboardWillShow:(NSNotification *)notification{
    //键盘显示，设置toolbar的frame跟随键盘的frame
    CGFloat animationTime = [[[notification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    
    [UIView animateWithDuration:animationTime animations:^{
        CGRect keyBoardFrame = [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        //多行文字,toolbar的frame会改变
        if (toolBar.frame.size.height>toolBarHeight) {
            toolBar.frame = CGRectMake(0, keyBoardFrame.origin.y-toolBar.frame.size.height,  self.theSuperViewController.view.bounds.size.width,toolBar.frame.size.height);
        }else{
            toolBar.frame = CGRectMake(0, keyBoardFrame.origin.y-toolBarHeight,  self.theSuperViewController.view.bounds.size.width,toolBarHeight);
        }
    }];
    [faceButton setBackgroundImage:[UIImage imageNamed:@"face"] forState:UIControlStateNormal];
    keyboardIsShow=YES;
    [pageControl setHidden:YES];
}
-(void)inputKeyboardWillHide:(NSNotification *)notification{
    [faceButton setBackgroundImage:[UIImage imageNamed:@"Text"] forState:UIControlStateNormal];
    keyboardIsShow=NO;
}

#pragma mark -
#pragma mark facialView delegate 点击表情键盘上的文字
-(void)selectedFacialView:(NSString*)str emojiArray:(NSArray *)array
{
    if ([str isEqualToString:@"删除"]) {
        NSInteger currenttextlength = textView.text.length;
        
        if (currenttextlength) {
            //当前删除的是表情
            if ([textView.text hasSuffix:@"]"]) {
                NSString *rangtext = [textView.text substringFromIndex:currenttextlength -kEmojiTextLength ];
                BOOL isEmojiText =  [array containsObject:rangtext];
                
                if (isEmojiText) {
                    textView.text = [textView.text substringWithRange:NSMakeRange(0, currenttextlength - kEmojiTextLength)];
                } else {
                    textView.text = [textView.text substringWithRange:NSMakeRange(0, currenttextlength - kCommonTextLength)];
                }
            } else {
                //当前删除的是普通字符串
                textView.text = [textView.text substringWithRange:NSMakeRange(0, currenttextlength - kCommonTextLength)];
            }
        }
    }else{
        NSString *newStr=[NSString stringWithFormat:@"%@%@",textView.text,str];
        [textView setText:newStr];
    }
   

}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
//    [super dealloc];
}
@end
