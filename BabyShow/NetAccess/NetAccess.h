//
//  NetAccess.h
//  BabyShow
//
//  Created by Lau on 13-12-9.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UrlMaker.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

#import "MyShowSectionItem.h"
#import "MyShowImageItem.h"
#import "MyShowPraisecountItem.h"
#import "MyShowReviewItem.h"
#import "MyShowDescribeItem.h"
#import "MyShowReviewCountItem.h"
#import "MyShowItem.h"
#import "MyShowPraiseBtnItem.h"
#import "MyShowImageGroupItem.h"

#import "NSString+NSString_MD5.h"
#import "UserInfoItem.h"
#import "BabyInfoItem.h"
#import "MyShowPraiseItem.h"
#import "MyHomePageItem.h"
#import "IdolListItem.h"
#import "MessageItem.h"
#import "MessageListRequestItem.h"

#import "ShareItem.h"
#import "UIImage+Scale.h"

#import "UserInfoManager.h"

#import "PBUserInfoItem.h"
#import "PBPhotoItem.h"
#import "PBPraiseAndReviewItem.h"
#import "PBTopitem.h"
#import "PBTopPhotoItem.h"

#import "ASIHTTPRequest.h"
#import "MyShowImgFrame.h"
#import "MyShowUrlItem.h"

#import "WorthBuyItem.h"
#import "WorthBuyImageItem.h"


@interface NetAccess : NSObject

{
    NSMutableData *_data;
    UrlMaker *_urlMaker;
    
    ASIHTTPRequest *_Getrequset;
    
    NSMutableDictionary *_responseDataDic;
    
}

@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, assign) int Style;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSNumber *messCount;


@property (strong, nonatomic) NSMutableArray *specialDetailRequests;
//@property (strong, nonatomic) ASIHTTPRequest *specialDetailRequest;

+(NetAccess *)sharedNetAccess;
-(void)getDataWithStyle:(int)Style andParam:(NSDictionary *)Param;

-(id)getReturnDataWithNetStyle:(int) Style;

@end
