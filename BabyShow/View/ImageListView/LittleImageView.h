//
//  LittleImageView.h
//  BabyShow
//
//  Created by Lau on 14-1-9.
//  Copyright (c) 2014年 Yuanyuanquanquan.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@protocol CheckOriginImage <NSObject>

-(void)clickOnImage:(NSDictionary *)imageDict atIndex:(NSInteger)tapindex;

@end

@interface LittleImageView : UIView<ASIHTTPRequestDelegate>
{

}


@property (nonatomic) id<CheckOriginImage>bigImageDelegate;
@property (nonatomic) NSInteger self_tag;
@property (nonatomic,strong)NSDictionary *imageDict;
@property (nonatomic) BOOL is_selected;     //是否选中

-(id)initWithImageInfo:(NSDictionary*)imageInfo y:(float)y is_show_album:(BOOL)is_show_album atIndex:(NSUInteger)arrayindex;
/**新版图片列表
-(id)initWithImageInfo:(NSDictionary*)imageInfo x:(float)x y:(float)y is_show_album:(BOOL)is_show_album atIndex:(NSUInteger)arrayindex;
*/
@end
