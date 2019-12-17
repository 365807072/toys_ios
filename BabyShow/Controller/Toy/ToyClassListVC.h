//
//  ToyClassListVC.h
//  BabyShow
//
//  Created by WMY on 17/1/10.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyAllListCell.h"

@interface ToyClassListVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSString *businessId;

@end
