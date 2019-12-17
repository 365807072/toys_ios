//
//  StoreListThridCell.h
//  BabyShow
//
//  Created by WMY on 16/4/7.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeleLineBuy.h"
#import "DeleteLineLabel.h"

@interface StoreListThridCell : UITableViewCell
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UILabel *describleLabel;
@property(nonatomic,strong)UIView *backView1;
@property(nonatomic,strong)UIView *backView2;
@property(nonatomic,strong)UIView *backView3;
@property(nonatomic,strong)UIImageView *img1;
@property(nonatomic,strong)UIImageView *img2;
@property(nonatomic,strong)UIImageView *img3;
@property(nonatomic,strong)UILabel *priceLabel1;
@property(nonatomic,strong)UILabel *priceLabel2;
@property(nonatomic,strong)UILabel *priceLabel3;
@property(nonatomic,strong)DeleteLineLabel *priceMark1;
@property(nonatomic,strong)DeleteLineLabel *priceMark2;
@property(nonatomic,strong)DeleteLineLabel *priceMark3;
@property(nonatomic,strong)UILabel *userNameLabel1;
@property(nonatomic,strong)UILabel *userNameLabel2;
@property(nonatomic,strong)UILabel *userNameLabel3;
@property(nonatomic,strong)UIImageView *imgArrow;

-(void)resetFrameWithDescribeContent:(NSString *) content;
-(void)resetWidth1:(NSString*)content;
-(void)resetWidth2:(NSString*)content;
-(void)resetWidth3:(NSString*)content;

-(void)hideSomeControlsIsOrNo:(BOOL)isHide;



@end
