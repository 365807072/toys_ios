//
//  MyShowPraiseCountBtnCell.h
//  BabyShow
//
//  Created by Lau on 13-12-13.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyShowPraiseCountBtnCellDelegate <NSObject>

-(void)pressPraiseCountBtn:(UIButton *) button;

@end

@interface MyShowPraiseCountBtnCell : UITableViewCell

@property (nonatomic, strong) UIButton *praiseListBtn;
@property (nonatomic, strong) UIImageView *praiseImageView;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *groupImgView;

@property (nonatomic, assign) id <MyShowPraiseCountBtnCellDelegate> delegate;

@end
