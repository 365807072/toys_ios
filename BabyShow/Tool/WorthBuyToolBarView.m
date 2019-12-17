//
//  WorthBuyToolBarView.m
//  BabyShow
//
//  Created by Lau on 8/28/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import "WorthBuyToolBarView.h"

@implementation WorthBuyToolBarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)init{
    
    self = [super init];
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveUp:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveDown:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(change:) name:UIKeyboardDidChangeFrameNotification object:nil];
        
        CGRect toolBarViewFrame=CGRectMake(0, SCREENHEIGHT-70, SCREENWIDTH, 70);
        self.frame=toolBarViewFrame;
        self.backgroundColor=[UIColor whiteColor];

        UIView *btnView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREENWIDTH,30)];
        btnView.backgroundColor=[UIColor whiteColor];
        
        UIView *photoView=[[UIView alloc]initWithFrame:CGRectMake(0, 30, SCREENWIDTH, 40)];
        photoView.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"img_postbar_post_toolbar"]];
        
        [self addSubview:btnView];
        [self addSubview:photoView];
        
        CGRect frame1=CGRectMake(22.5, 6.5, 35, 27);
        CGRect frame2=CGRectMake(102.5, 6.5, 35, 27);
        CGRect frame3=CGRectMake(182.5, 6.5, 35, 27);
        CGRect frame4=CGRectMake(262.5, 6.5, 35, 27);
        
        UIButton *btn1=[UIButton buttonWithType:UIButtonTypeCustom];
        btn1.frame=frame1;
        btn1.tag=1;
        [btn1 setBackgroundImage:[UIImage imageNamed:@"btn_postbar_select_from_album"] forState:UIControlStateNormal];
        [btn1 addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [photoView addSubview:btn1];
        
        UIButton *btn2=[UIButton buttonWithType:UIButtonTypeCustom];
        btn2.frame=frame2;
        btn2.tag=2;
        [btn2 setBackgroundImage:[UIImage imageNamed:@"btn_postbar_take_a_photo"] forState:UIControlStateNormal];
        [btn2 addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [photoView addSubview:btn2];
        
        UIButton *btn3=[UIButton buttonWithType:UIButtonTypeCustom];
        btn3.frame=frame3;
        btn3.tag=3;
        [btn3 setBackgroundImage:[UIImage imageNamed:@"btn_postbar_select_from_phone"] forState:UIControlStateNormal];
        [btn3 addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [photoView addSubview:btn3];
        
        self.linkBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.linkBtn.frame=frame4;
        self.linkBtn.tag=4;
        [self.linkBtn setBackgroundImage:[UIImage imageNamed:@"btn_postbar_add_a_url"] forState:UIControlStateNormal];
        [self.linkBtn addTarget:self action:@selector(action:) forControlEvents:UIControlEventTouchUpInside];
        [photoView addSubview:self.linkBtn];
        
        CGRect lifeBtnFrame=CGRectMake(10, 2, 89, 26);
        CGRect studyBtnFrame=CGRectMake(10+89+16.5, 2, 89, 26);
        CGRect othersBtnFrame=CGRectMake(10+89+16.5+89+16.5, 2, 89, 26);
        
        self.lifeBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.lifeBtn.frame=lifeBtnFrame;
        self.lifeBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [self.lifeBtn setTitle:@"为宝宝买" forState:UIControlStateNormal];
        [self.lifeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.lifeBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.lifeBtn setBackgroundImage:[UIImage imageNamed:@"btn_worthbuy_select"] forState:UIControlStateNormal];
        [btnView addSubview:self.lifeBtn];
        
        self.studyBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.studyBtn.frame=studyBtnFrame;
        self.studyBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [self.studyBtn setTitle:@"为我家买" forState:UIControlStateNormal];
        [self.studyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.studyBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.studyBtn setBackgroundImage:[UIImage imageNamed:@"btn_worthbuy_select"] forState:UIControlStateNormal];
        [btnView addSubview:self.studyBtn];
        
        self.othersBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        self.othersBtn.frame=othersBtnFrame;
        self.othersBtn.titleLabel.font=[UIFont systemFontOfSize:14];
        [self.othersBtn setTitle:@"为自己买" forState:UIControlStateNormal];
        [self.othersBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.othersBtn addTarget:self action:@selector(OnClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.othersBtn setBackgroundImage:[UIImage imageNamed:@"btn_worthbuy_select"] forState:UIControlStateNormal];
        [btnView addSubview:self.othersBtn];
        
        self.state=WorthBuyToolBarViewStateNormal;
        
    }
    
    return self;
    
}

#pragma mark delegateMethod

-(void)action:(UIButton *) btn{
    
    if (btn.tag==1) {
        if ([self.delegate respondsToSelector:@selector(selectFromAlbum)]) {
            [self.delegate selectFromAlbum];
        }
    }else if (btn.tag==2){
        if ([self.delegate respondsToSelector:@selector(takeAPhoto)]) {
            [self.delegate takeAPhoto];
        }
    }else if (btn.tag==3){
        if ([self.delegate respondsToSelector:@selector(selectFromPhone)]) {
            [self.delegate selectFromPhone];
        }
    }else if (btn.tag==4){
        if ([self.delegate respondsToSelector:@selector(addUrl)]) {
            [self.delegate addUrl];
        }
    }
    
}

-(void)OnClick:(UIButton *) btn{
    
    if (btn==self.lifeBtn) {
        
        [self.lifeBtn setTitleColor:[BBSColor hexStringToColor:@"#e9645f"] forState:UIControlStateNormal];
        [self.lifeBtn setBackgroundImage:[UIImage imageNamed:@"btn_worthbuy_selected"] forState:UIControlStateNormal];
        
        [self.studyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.studyBtn setBackgroundImage:[UIImage imageNamed:@"btn_worthbuy_select"] forState:UIControlStateNormal];
        
        [self.othersBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.othersBtn setBackgroundImage:[UIImage imageNamed:@"btn_worthbuy_select"] forState:UIControlStateNormal];
        
        if ([self.delegate respondsToSelector:@selector(selectLife)]) {
            [self.delegate selectLife];
        }
    }else if (btn==self.studyBtn){
        
        [self.studyBtn setTitleColor:[BBSColor hexStringToColor:@"#e9645f"] forState:UIControlStateNormal];
        [self.studyBtn setBackgroundImage:[UIImage imageNamed:@"btn_worthbuy_selected"] forState:UIControlStateNormal];
        
        [self.lifeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.lifeBtn setBackgroundImage:[UIImage imageNamed:@"btn_worthbuy_select"] forState:UIControlStateNormal];
        
        [self.othersBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.othersBtn setBackgroundImage:[UIImage imageNamed:@"btn_worthbuy_select"] forState:UIControlStateNormal];

        if ([self.delegate respondsToSelector:@selector(selectStudy)]) {
            [self.delegate selectStudy];
        }
    }else if (btn==self.othersBtn){
        
        [self.othersBtn setTitleColor:[BBSColor hexStringToColor:@"#e9645f"] forState:UIControlStateNormal];
        [self.othersBtn setBackgroundImage:[UIImage imageNamed:@"btn_worthbuy_selected"] forState:UIControlStateNormal];
        
        [self.lifeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.lifeBtn setBackgroundImage:[UIImage imageNamed:@"btn_worthbuy_select"] forState:UIControlStateNormal];
        
        [self.studyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.studyBtn setBackgroundImage:[UIImage imageNamed:@"btn_worthbuy_select"] forState:UIControlStateNormal];

        if ([self.delegate respondsToSelector:@selector(selectOthers)]) {
            [self.delegate selectOthers];
        }
    }
    
}


#pragma mark method

-(void)moveUp:(NSNotification *) note{
    
    if ( self && self.state==WorthBuyToolBarViewStateNormal) {
        
        NSValue *value=[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect frame=[value CGRectValue];
        float newy=self.frame.origin.y-frame.size.height;
        self.frame=CGRectMake(self.frame.origin.x, newy, self.frame.size.width, self.frame.size.height);
        self.state=WorthBuyToolBarViewStateUp;
        
    }
    
}

-(void)moveDown:(NSNotification *) note{
    
    if ( self && self.state==WorthBuyToolBarViewStateUp) {
        
        NSValue *value=[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect frame=[value CGRectValue];
        float newy=self.frame.origin.y+frame.size.height;
        self.frame=CGRectMake(self.frame.origin.x, newy, self.frame.size.width, self.frame.size.height);
        self.state=WorthBuyToolBarViewStateNormal;
        
    }
    
}

-(void)change:(NSNotification *) note{
    
    if (self && self.state==WorthBuyToolBarViewStateUp) {
        
        NSValue *value=[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
        CGRect frame=[value CGRectValue];
        self.frame=CGRectMake(0, SCREENHEIGHT-70-frame.size.height, SCREENWIDTH, 70);
        self.state=WorthBuyToolBarViewStateUp;
        
    }
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

@end
