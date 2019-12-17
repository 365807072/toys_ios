//
//  PhotosEditCell.h
//  BabyShow
//
//  Created by Lau on 5/7/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotosEditTextField.h"

@protocol PhotosEditCellDelegate <NSObject>

-(void)timeBtnOnClick:(UIButton *) btn;

@end

@interface PhotosEditCell : UITableViewCell<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *photoView;
@property (nonatomic, strong) PhotosEditTextField *titleField;
@property (nonatomic, strong) UIButton *timeBtn;
@property (nonatomic, strong) PhotosEditTextField *areaField;

@property (nonatomic, strong) UIImageView *seperateView;

@property (nonatomic, assign) id <PhotosEditCellDelegate> delegate;

@end
