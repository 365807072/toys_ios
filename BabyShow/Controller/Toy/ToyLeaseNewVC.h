//
//  ToyLeaseNewVC.h
//  BabyShow
//
//  Created by WMY on 17/1/11.
//  Copyright © 2017年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToyAllListCell.h"

@interface ToyLeaseNewVC : UIViewController<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>{
    UILabel *_badgeValueLabel;
}
@property(nonatomic, assign) BOOL hideBottomTab;
@property(nonatomic,assign)NSInteger inTheViewData;

@property(nonatomic,strong)NSString *fromDetail;
@property(nonatomic,strong)NSString *orderIdFromDetail;
@property(nonatomic,strong)NSString *fromMain;//从哪进的玩具列表，main，是指主页
@property(nonatomic,assign)BOOL isAfterPay;//yes是支付完成后，no不是

-(void)changeData:(NSInteger)tag;

@end
