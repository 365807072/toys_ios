//
//  MoreSpecialModel.h
//  BabyShow
//
//  Created by Monica on 15-5-14.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoreSpecialModel : NSObject
@property(nonatomic,assign)NSInteger cate_id;
@property(nonatomic,assign)NSInteger renshu;
@property(nonatomic,strong)NSMutableArray *imgs;
@property(nonatomic,strong)NSString *img_thumb;
@property(nonatomic,strong)NSString *cate_name;
@property(nonatomic,strong)NSString *firstImge;
@property(nonatomic,strong)NSString *secondImge;
@property(nonatomic,strong)NSString *thirdImge;
@property(nonatomic,strong)NSString *fourImge;
@property(nonatomic,assign)NSInteger rank;

-(id)initWithAttributes:(NSDictionary *)attributes;

@end
