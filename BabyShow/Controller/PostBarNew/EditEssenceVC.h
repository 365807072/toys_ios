//
//  EditEssenceVC.h
//  BabyShow
//
//  Created by WMY on 16/9/23.
//  Copyright © 2016年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol EditEssenceDelegate <NSObject>


@end


@interface EditEssenceVC : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    UITableView *_firstTableView;
    NSInteger arrayCount;
    
}
@property(nonatomic,strong)NSArray *leftArray;
@property (nonatomic, strong) id <EditEssenceDelegate>delegate;
@property(nonatomic,assign)NSInteger groupId;
@property(nonatomic,strong)NSString *imgId;
@property(nonatomic,assign)NSInteger fromModel;//是来自哪个需要，1代表是来自图片模式，2是来自管理分类
- (void)hideTableView;
@end
