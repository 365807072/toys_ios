//
//  PostBarNewDetailV1AdmireCell.h
//  BabyShow
//
//  Created by WMY on 16/4/21.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "btnWithIndexPath.h"
//@protocol postBarNewDetailAdmireCellDelegate<NSObject>
//-(void)praise:(btnWithIndexPath *) sender;
//@end

@interface PostBarNewDetailV1AdmireCell : UITableViewCell
@property(nonatomic,strong)UIView *lookView;
@property(nonatomic,strong)UIView *admireView;
@property(nonatomic,strong)UIButton *lookOriginalBtn;
@property(nonatomic,strong)UIButton *admireBtn;
@property(nonatomic,strong)UILabel *admireCountLabel;
@property(nonatomic,strong)UIImageView *imgBack;
@property(nonatomic,strong)UIButton *shareWeixin;
@property(nonatomic,strong)UIButton *shareWeixinQuan;
@property(nonatomic,strong)UIButton *admireBigBtn;
-(void)hidenLookViewRestFrame:(BOOL)ishidden goStore:(NSString *)storeOrWeb;


@end
