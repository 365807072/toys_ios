//
//  WorthBuyCell.h
//  BabyShow
//
//  Created by Lau on 8/25/14.
//  Copyright (c) 2014 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BtnWithPhotos.h"
#import "DeleteLineLabel.h"
#import "NIAttributedLabel.h"

@protocol WorthBuyCellDelegate <NSObject>

-(void)seeThePhotos:(BtnWithPhotos *) btn;
/**
-(void)praise:(UIButton *)btn;
-(void)review:(UIButton *)btn;
*/
@end

@interface WorthBuyCell : UITableViewCell

@property (nonatomic, assign) id <WorthBuyCellDelegate> delegate;

@property (nonatomic, strong) BtnWithPhotos *imgBtn;                        //图片
@property (nonatomic, strong) UIImageView *classLogoImgV;                   //分类Logo
@property (nonatomic, strong) UILabel *shopLabel;                           //商场名字
@property (nonatomic, strong) UILabel *describeLabel;                       //描述
@property (nonatomic, strong) UILabel *remainTimeLabel;                     //剩余时间
@property (nonatomic, strong) NIAttributedLabel *priceLabel;                //现价
@property (nonatomic, strong) DeleteLineLabel *originPriceLabel;            //原价
@property (nonatomic, strong) UILabel *latestStateLabel;                    //最新动态

@end
