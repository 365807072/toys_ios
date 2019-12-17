//
//  SpecialHeadHotModel.h
//  BabyShow
//
//  Created by Monica on 15-5-14.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialHeadHotModel : NSObject
@property(nonatomic,strong)NSString *cate_name;
@property(nonatomic,strong)NSString *img_thumb;
@property(nonatomic,assign)NSInteger cate_id;
@property(nonatomic,strong)NSArray *imgs;

-(void)setValue:(id)value forUndefinedKey:(NSString *)key;


@end
