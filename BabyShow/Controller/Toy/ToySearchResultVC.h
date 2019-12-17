//
//  ToySearchResultVC.h
//  BabyShow
//
//  Created by 美美 on 2018/2/8.
//  Copyright © 2018年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyAllListCell.h"

@interface ToySearchResultVC : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property(nonatomic,strong)NSString *businessId;


@end
