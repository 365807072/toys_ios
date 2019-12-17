//
//  RefreshTopView.m
//
//  Copyright (c) 2014 YDJ ( https://github.com/ydj/RefreshControl )
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.



#import "RefreshGifView.h"

@implementation RefreshGifView


- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self)
    {
        
        [self initViews];
    }
    
    return self;
}

- (void)resetLayoutSubViews
{
    
    NSArray * temp=self.constraints;
    if ([temp count]>0)
    {
        [self removeConstraints:temp];
    }
    
    NSLayoutConstraint * aBottom1=[NSLayoutConstraint constraintWithItem:self.ylIamgeView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
    NSLayoutConstraint * aRight1=[NSLayoutConstraint constraintWithItem:self.ylIamgeView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:30];
    NSLayoutConstraint * aWith1=[NSLayoutConstraint constraintWithItem:self.ylIamgeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:55];
    NSLayoutConstraint * aHeight1=[NSLayoutConstraint constraintWithItem:self.ylIamgeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:40];
    
    NSArray * aList=@[aBottom1,aRight1,aWith1,aHeight1];
    
    [self addConstraints:aList];
    ////////////
    
    NSLayoutConstraint *vBottom=[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-13];
    NSLayoutConstraint *vRight=[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:30];
    NSLayoutConstraint *vWidth=[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:55];
    NSLayoutConstraint *vHeight=[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:40];
    
    NSArray * vList=@[vBottom,vRight,vWidth,vHeight];
    [self addConstraints:vList];
    //////////////
    NSLayoutConstraint * tLeft=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint * tBottom=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-13];
    NSLayoutConstraint * tRight=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:40];
    NSLayoutConstraint * tHeight=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:30];
    
    NSArray * tList=@[tLeft,tBottom,tRight,tHeight];
    
    [self addConstraints:tList];
    
}

- (void)initViews
{
    self.backgroundColor=[UIColor clearColor];//[UIColor colorWithRed:237.0/255.0 green:237.0/255.0 blue:237.0/255.0 alpha:237.0/255.0];
    
    
    _ylIamgeView = [[YLImageView alloc] init];
    _ylIamgeView.image = [YLGIFImage imageNamed:@"refresh2.gif"];
    _ylIamgeView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_ylIamgeView];
    _ylIamgeView.hidden = YES;
    

    NSLayoutConstraint * aBottom1=[NSLayoutConstraint constraintWithItem:self.ylIamgeView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-10];
    NSLayoutConstraint * aRight1=[NSLayoutConstraint constraintWithItem:self.ylIamgeView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:30];
    NSLayoutConstraint * aWith1=[NSLayoutConstraint constraintWithItem:self.ylIamgeView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:55];
    NSLayoutConstraint * aHeight1=[NSLayoutConstraint constraintWithItem:self.ylIamgeView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:40];
    
    NSArray *aList=@[aBottom1,aRight1,aWith1,aHeight1];
    
    [self addConstraints:aList];
    
    
    _imageView=[[UIImageView alloc] initWithFrame:CGRectZero];
    _imageView.image=[UIImage imageNamed:@"pull_refreshGif.png"];
    _imageView.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_imageView];
    
    
    NSLayoutConstraint *vBottom=[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-13];
    NSLayoutConstraint *vRight=[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:30];
    NSLayoutConstraint *vWidth=[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeWidth multiplier:0 constant:55];
    NSLayoutConstraint *vHeight=[NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:40];
    
    NSArray * vList=@[vBottom,vRight,vWidth,vHeight];
    [self addConstraints:vList];
    
    
    
    _promptLabel=[[UILabel alloc] initWithFrame:CGRectZero];
    _promptLabel.backgroundColor=[UIColor clearColor];
    _promptLabel.font=[UIFont systemFontOfSize:13];
    _promptLabel.translatesAutoresizingMaskIntoConstraints=NO;
    [self addSubview:_promptLabel];
    
    NSLayoutConstraint * tLeft=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint * tBottom=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:-13];
    NSLayoutConstraint * tRight=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0];
    NSLayoutConstraint * tHeight=[NSLayoutConstraint constraintWithItem:self.promptLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeHeight multiplier:0 constant:32];
    
    NSArray * tList=@[tLeft,tBottom,tRight,tHeight];
    
    [self addConstraints:tList];
    
    [self resetViews];
    
}

- (void)resetViews
{
    _imageView.hidden=NO;
    if (!_ylIamgeView.hidden)
    {
        _ylIamgeView.hidden = YES;
    }
  //  _promptLabel.text=@"下拉刷新";
    
}

- (void)canEngageRefresh
{
   // _promptLabel.text=@"松开刷新";
    
}

- (void)didDisengageRefresh
{
    [self resetViews];
}

- (void)startRefreshing
{
    _imageView.hidden=YES;
    _ylIamgeView.hidden = NO;
    //_promptLabel.text=@"正在加载...";
}

- (void)finishRefreshing
{
    [self resetViews];
}




@end
