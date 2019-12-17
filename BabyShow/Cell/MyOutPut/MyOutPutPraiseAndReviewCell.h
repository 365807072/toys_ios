//
//  MyOutPutPraiseAndReviewCell.h
//  BabyShow
//
//  Created by Monica on 9/17/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyOutPutPraiseAndReviewCellDelegate <NSObject>

-(void)praise:(UIButton *) btn;
-(void)review:(UIButton *) btn;
-(void)more:(UIButton *) btn;
-(void)share:(UIButton *)btn;


@end

@interface MyOutPutPraiseAndReviewCell : UITableViewCell

@property (nonatomic, assign) id <MyOutPutPraiseAndReviewCellDelegate> delegate;
@property (nonatomic, strong) UIButton *praiseBtn;
@property (nonatomic, strong) UIButton *reviewBtn;
@property (nonatomic, strong) UIButton *moreBtn;
@property(nonatomic,strong)UIButton *shareButton;
@property(nonatomic,strong)UIView *seperateView;
@property(nonatomic,strong)UIImageView *typeView;

@end
