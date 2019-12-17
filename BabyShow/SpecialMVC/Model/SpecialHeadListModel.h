//
//  SpecialHeadListModel.h
//  BabyShow
//
//  Created by Monica on 15-5-12.
//  Copyright (c) 2015年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpecialHeadListModel : NSObject
//@property(nonatomic,strong)NSString *cate_name;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,assign)BOOL isClick;
@property(nonatomic,assign)NSInteger cateId;
@property(nonatomic,strong)NSString *cateName;
@property(nonatomic,assign)NSInteger img_id;
@property(nonatomic,strong)NSString *businessUrl;
@property(nonatomic,assign)NSInteger group_id;
@property(nonatomic,strong)NSString *groupName;
@property(nonatomic,strong)NSArray *img;
@property(nonatomic,assign)NSString *businessId;
@property(nonatomic,strong)NSString *businessName;
@property(nonatomic,strong)NSString *video_url;//视频的url
@property(nonatomic,strong)NSString *is_jump;
@property(nonatomic,strong)NSString *postUrl;
@property(nonatomic,strong)NSString *title;




-(void)setValue:(id)value forUndefinedKey:(NSString *)key;
-(id)initWithAttributes:(NSDictionary *)attributes;

@end
