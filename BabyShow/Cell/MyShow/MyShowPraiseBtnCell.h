//
//  MyShowPraiseBtnCell.h
//  BabyShow
//
//  Created by Lau on 13-12-13.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyShowPraiseBtnCellDelegate <NSObject>

-(void)pressPraiseBtn:(UIButton *) button;
-(void)pressReviewBtn:(UIButton *) button;
-(void)pressReportBtn:(UIButton *) button;
-(void)pressShareBtn:(UIButton *)button;

@end

@interface MyShowPraiseBtnCell : UITableViewCell

@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, strong) UIButton *reviewBtn;
@property(nonatomic,strong)UIButton *shareBtn;
@property (nonatomic, strong) UIButton *reportBtn;
@property (nonatomic, assign) id <MyShowPraiseBtnCellDelegate> delegate;

@end
