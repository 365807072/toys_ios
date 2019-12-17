//
//  SortManagementCell.h
//  BabyShow
//
//  Created by WMY on 16/9/18.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SortManagementCell : UITableViewCell
@property(nonatomic,strong)UILabel *rankLabel;
@property(nonatomic,strong)UILabel *sortLabel;
@property(nonatomic,strong)UIImageView *editBtn;
@property(nonatomic,strong)YLButton *deleBtn;
@property(nonatomic,strong)YLButton *smallDeleBtn;

@end
