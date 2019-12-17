    //
//  NetAccess.m
//  BabyShow
//
//  Created by Lau on 13-12-9.
//  Copyright (c) 2013年 Yuanyuanquanquan.com. All rights reserved.
//

#import "NetAccess.h"
#import "MyOutPutTitleItem.h"
#import "MyOutPutDescribeItem.h"
#import "MyOutPutUrlItem.h"
#import "MyOutPutImgGroupItem.h"
#import "MyOutPutPraiseAndReviewItem.h"
#import "MyOutPutTitleItemNotToday.h"

#import "MyShowNewTitleItemToday.h"
#import "MyShowNewTitleItemNotToday.h"

#import "MyShowNewPickedTitleFocusItem.h"
#import "MyShowNewPickedTitleTodayItem.h"
#import "MyShowNewPickedTitleNotTodayItem.h"

#import "PostBarWithPhotoItem.h"
#import "PostBarWithOutPhotoItem.h"

#import "PostBarDetailNewTitleItem.h"
#import "PostBarDetailNewUserItem.h"
#import "PostBarDetailNewDescribeItem.h"
#import "PostBarDetailNewPhotoItem.h"
#import "PostBarDetailNewReviewItem.h"
#import "PostBarDetailNewMoreReviewItem.h"
#import "PostBarDetailNewPraiseItem.h"
#import "PostBarDetailNewUrlItem.h"
#import "PostBarHeaderItem.h"

#import "GrowthDiaryBasicItem.h"
#import "GrowthDiaryEditItem.h"
#import "SpecialHeadListModel.h"
#import "SpecialPartPeopleItem.h"
#import "MoreSpecialModel.h"
#import "WorthBuyNewListItem.h"
#import "WorthBuyNewListImageItem.h"
#import "SpecialDetailGridItem.h"
#import "PostMyInterestItem.h"
#import "PostMyGroupDetailItem.h"
#import "PostMyInterestV3Item.h"
#import "StoreMoreListItem.h"
#import "MyOrdersItem.h"
#import "StoreOrdersItem.h"
#import "BusinessCommentListItem.h"
#import "MyShowNewVersionItem.h"
#import "MyShowNewVersionItem2.h"
#import "RedBagListItem.h"
#import "DairyFouceItem.h"
#import "NIAttributedLabel.h"

static NetAccess *netAccess=nil;

@interface NetAccess ()

@end

@implementation NetAccess

+(NetAccess *)sharedNetAccess{
    
    if (netAccess==nil) {
        netAccess=[[NetAccess alloc]init];
    }
    return netAccess;
    
}

-(id)init{
    
    if (self=[super init]) {
        
        self.dataArray=[[NSMutableArray alloc]init];
        self.sectionArray=[[NSMutableArray alloc]init];
        
        _data=[[NSMutableData alloc]init];
        
        self.message=[[NSString alloc]init];
        
        self.messCount=[[NSNumber alloc]init];
        
        _responseDataDic=[NSMutableDictionary dictionary];
        
    }
    
    return self;
    
}
- (AppDelegate *)appDelegate {
    return  (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
-(void)getDataWithStyle:(int)Style andParam:(NSDictionary *)Param{
    
    self.Style=Style;
    
    switch (Style) {
            
        case NetStyleRegister:{
            
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kRegist Method:NetMethodPost andParam:Param];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                
                if ([key isEqualToString:kRegistAvatar]) {
                    
                    [request setData:UIImageJPEGRepresentation([Param objectForKey:kRegistAvatar], 1.0) withFileName:@"image.png" andContentType:@"image/png" forKey:kRegistAvatar];
                    
                }else{
                    
                    [request setPostValue:[Param objectForKey:key] forKey:key];
                    
                }
                
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    
                    NSDictionary *dataDic = [dic objectForKey:kBBSData];
                    
                    UserInfoItem *item = [[UserInfoItem alloc]init];
                    
                    item.avatarStr = [dataDic objectForKey:@"avatar"];
                    item.email = [dataDic objectForKey:@"email"];
                    item.nickname = [dataDic objectForKey:@"nick_name"];
                    item.userId = [dataDic objectForKey:@"user_id"];
                    item.isVisitor = [NSNumber numberWithBool:NO];
                    
                    UserInfoManager *manager = [[UserInfoManager alloc]init];
                    [manager saveUserInfo:item];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_REGIST_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorDescription = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_REGIST_FAIL object:errorDescription];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
           //登录
        case NetStyleLogin:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kLogin Method:NetMethodPost andParam:Param];
            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                
                [request setPostValue:[Param objectForKey:key] forKey:key];
            
                
            }
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:kBBSSuccess] integerValue]==1) {
                    
                    NSDictionary *dataDic=[dic objectForKey:@"data"];
                    UserInfoItem *userItem=[[UserInfoItem alloc]init];
                    userItem.userId=[dataDic objectForKey:@"user_id"];
                    userItem.email=[dataDic objectForKey:@"email"];
                    userItem.userName=[dataDic objectForKey:@"user_name"];
                    userItem.nickname=[dataDic objectForKey:@"nick_name"];
                    userItem.avatarStr=[dataDic objectForKey:@"avatar"];
                    userItem.city = [dataDic objectForKey:@"city"];
                    userItem.isVisitor=[NSNumber numberWithBool:NO];
                    UserInfoManager *userInfoManager=[[UserInfoManager alloc]init];
                    [userInfoManager saveUserInfo:userItem];
                    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:userItem.userId,@"user_id", userItem.city,@"city",nil];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_SUCCEED object:userDic];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_LOGIN_FAIL object:errorString];
                    
                }
                
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
        case NetStyleAddAChild:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kAddBaby Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            NSString *userid=LOGIN_USER_ID;
            
            [request setPostValue:userid forKey:@"user_id"];
            
            //babys:
            NSMutableArray *babyItemsArray=[Param objectForKey:@"babys"];
            NSMutableArray *babys=[[NSMutableArray alloc]init];
            
            for (BabyInfoItem *babyItem in babyItemsArray) {
                
                NSDictionary *babydic=[NSDictionary dictionaryWithObjectsAndKeys:
                                       babyItem.babyName, @"baby_name",
                                       babyItem.babyBirthday, @"baby_birth",
                                       babyItem.sex,@"sex",nil];
                
                [babys addObject:babydic];
                
            }
            
            NSString *jsonStr = [babys JSONRepresentation];
            
            [request setPostValue:jsonStr forKey:@"babys"];
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_ADDBABY_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_ADDBABY_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
        case NetStyleAdmire:{
            
            UrlMaker *urlMaker;
            
            NSMutableDictionary *newParam = [NSMutableDictionary dictionary];
            
            NSArray *allkeys = [Param allKeys];
            
            for (NSString *key in allkeys) {
                
                if ((![key isEqualToString:@"ispost"]) && (![key isEqualToString:@"isdiary"])) {
                    
                    [newParam setObject:[Param objectForKey:key] forKey:key];
                }
            }
            
            if ([[Param objectForKey:@"isdiary"] isEqualToString:@"1"]) {
                
                urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kDiaryAdmire Method:NetMethodPost andParam:newParam];
                
            } else if ([[Param objectForKey:@"ispost"] isEqualToString:@"1"]) {
                
                urlMaker = [[UrlMaker alloc]initWithNewV1UrlStr:kPublicListingAdmire Method:NetMethodPost andParam:newParam];
                
            }else{
                
                urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kAdmire Method:NetMethodPost andParam:newParam];
                
            }
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [newParam allKeys]) {
                
                id obj = [newParam objectForKey:key];
                [request setPostValue:obj forKey:key];
                
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:kBBSSuccess] integerValue] == YES) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWPRAISE_SUCCEED object:self];
                }else{
                    
                    NSString *errorString=[dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWPRAISE_FAIL object:errorString];
                }
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
            }];
            
            break;
        }
            
        case NetStylePostBarWorthBuyAdmire:{
            
           // UrlMaker *urlMaker=[[UrlMaker alloc]initWithUrlStr:kBuyAdmire Method:NetMethodPost andParam:Param];
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kBuyAdmire Method:NetMethodPost andParam:Param];

            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            for (NSString *key in [Param allKeys]) {
                id obj=[Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:blockRequest.responseData options:0 error:nil];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_WORTHBUY_PRAISE_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_WORTHBUY_PRAISE_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
        case NetStyleCancelAdmire:{
            
            UrlMaker *urlMaker;
            
            NSMutableDictionary *newParam = [NSMutableDictionary dictionary];
            
            NSArray *allkeys = [Param allKeys];
            
            for (NSString *key in allkeys) {
                if ((![key isEqualToString:@"ispost"]) && (![key isEqualToString:@"isdiary"])) {
                    
                    [newParam setObject:[Param objectForKey:key] forKey:key];
                }
            }
            if ([[Param objectForKey:@"isdiary"] isEqualToString:@"1"]) {
                
                urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kDiaryCancelAdmire Method:NetMethodPost andParam:newParam];
                
            } else if ([[Param objectForKey:@"ispost"] isEqualToString:@"1"]) {
                
                urlMaker = [[UrlMaker alloc]initWithNewV1UrlStr:kCancelListingAdmire   Method:NetMethodPost andParam:newParam];
                
            }else{
                
                urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kCancelAdmire Method:NetMethodPost andParam:Param];
                
            }
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [newParam allKeys]) {
                id obj = [newParam objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWCANCELPRAISE_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWCANCELPRAISE_FAIL object:errorString];
                }
            }];
            
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
            }];
            
            break;
        }
            
        case NetStylePostBarWorthBuyCancelAdmire:{
            
            //UrlMaker *urlMaker=[[UrlMaker alloc]initWithUrlStr:kCancelBuyAdmire Method:NetMethodPost andParam:Param];
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithUrlStr:kCancelBuyAdmire Method:NetMethodPost andParam:Param];
            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                id obj=[Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:blockRequest.responseData options:0 error:nil];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_WORTHBUY_PRAISE_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_WORTHBUY_PRAISE_FAIL object:errorString];
                    
                }
                
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            
        case NetStyleReviewList:{
            
            UrlMaker *urlMaker;
            
            NSMutableDictionary *newParam = [NSMutableDictionary dictionary];
            
            NSArray *allkeys = [Param allKeys];
            
            for (NSString *key in allkeys) {
                
                if ((![key isEqualToString:@"ispost"]) && (![key isEqualToString:@"isdiary"])) {
                    
                    [newParam setObject:[Param objectForKey:key] forKey:key];
                    
                }
                
            }
            
            if ([[Param objectForKey:@"ispost"] isEqualToString:@"1"]) {
                //话题评论列表
                urlMaker = [[UrlMaker alloc]initWithNewV1UrlStr:kPostReviewList Method:NetMethodGet andParam:newParam];
                
            }else if ([[Param objectForKey:@"isdiary"] isEqualToString:@"1"]) {
                //成长日记评论列表
                urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kDiaryReviewList Method:NetMethodGet andParam:newParam];
                
            } else {
                //秀秀评论列表
                urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kReviewList Method:NetMethodGet andParam:newParam];
                
            }
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    
                    NSArray *data = [dic objectForKey:kBBSData];
                    NSMutableArray *dataArray = [NSMutableArray array];
                    
                    for (NSDictionary *dataDic in data) {
                        MyShowReviewItem *reviewItem = [[MyShowReviewItem alloc]init];
                        
                        reviewItem.content = [dataDic objectForKey:kReviewListDemand];
                        //                        reviewItem.reviewUser=[dataDic objectForKey:kReviewListReviewName];
                        reviewItem.username = [dataDic objectForKey:kReviewListUserName];
                        reviewItem.avatarStr = [dataDic objectForKey:kReviewListAvatar];
                        reviewItem.userid = [dataDic objectForKey:kReviewListUserId];
                        NIAttributedLabel *label = [[NIAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, 270, 0)];
                        label.text = reviewItem.content;
                        label.font = [UIFont systemFontOfSize:14];
                        label.numberOfLines = 0;
                        [label sizeToFit];
                        CGFloat height = label.frame.size.height;

//                        NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
//                        CGFloat height = [reviewItem.content boundingRectWithSize:CGSizeMake(270, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:attr context:nil].size.height;
                        reviewItem.height = height;
                        
                        NSNumber *time = [dataDic objectForKey:@"post_create_time"];
                        reviewItem.time = [self getTimeStrFromNow:time];
                        reviewItem.reviewId = [dataDic objectForKey:kReviewListID];
                        reviewItem.postCreatTime = dataDic[@"post_create_time"];
                        [dataArray addObject:reviewItem];
                    }
                    
                    [_responseDataDic setObject:dataArray forKey:[NSString stringWithFormat:@"%d",Style]];
                    NSNumber *styleNumber = [NSNumber numberWithInteger:Style];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_REVIEW_LIST_SUCCEED object:styleNumber];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_REVIEW_LIST_FAIL object:errorString];
                    
                }
                
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
        }
            break;
            
        case NetStylePostBarWorthBuyReviewList:{
            
           // UrlMaker *urlMaker=[[UrlMaker alloc]initWithUrlStr:kBuyReviewList Method:NetMethodGet andParam:Param];
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kBuyReviewList Method:NetMethodGet andParam:Param];
            
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            
            __weak ASIHTTPRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:blockRequest.responseData options:0 error:nil];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    NSArray *data=[dic objectForKey:@"data"];
                    
                    NSMutableArray *dataArray=[NSMutableArray array];
                    
                    for (NSDictionary *dataDic in data) {
                        
                        MyShowReviewItem *reviewItem=[[MyShowReviewItem alloc]init];
                        
                        reviewItem.content=[dataDic objectForKey:kReviewListDemand];
                        //                        reviewItem.reviewUser=[dataDic objectForKey:kReviewListReviewName];
                        reviewItem.username=[dataDic objectForKey:kReviewListUserName];
                        reviewItem.avatarStr=[dataDic objectForKey:kReviewListAvatar];
                        reviewItem.userid=[dataDic objectForKey:kReviewListUserId];
                        
                        NSDictionary *attr = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil];
                        CGFloat height = [reviewItem.content boundingRectWithSize:CGSizeMake(280, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:attr context:nil].size.height;
                        reviewItem.height=height;
                        
                        NSNumber *time=[dataDic objectForKey:kReviewListCreatTime];
                        reviewItem.time=[self getTimeStrFromNow:time];
                        reviewItem.reviewId=[dataDic objectForKey:kReviewListID];
                        
                        [dataArray addObject:reviewItem];
                        
                    }
                    
                    [_responseDataDic setObject:dataArray forKey:[NSString stringWithFormat:@"%d",Style]];
                    NSNumber *styleNumber=[NSNumber numberWithInteger:Style];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_REVIEW_LIST_SUCCEED object:styleNumber];
                    
                }else{
                    
                    self.message=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_REVIEW_LIST_FAIL object:self];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
        case NetStyleReview:{
            
            UrlMaker *urlMaker;
            
            NSMutableDictionary *newParam = [NSMutableDictionary dictionary];
            
            NSArray *allkeys = [Param allKeys];
            
            for (NSString *key in allkeys) {
                
                if ((![key isEqualToString:@"ispost"]) && (![key isEqualToString:@"isdiary"])) {
                    
                    [newParam setObject:[Param objectForKey:key] forKey:key];
                }
            }
            
            if ([[Param objectForKey:@"ispost"] isEqualToString:@"1"]) {
                //话题评论
                urlMaker = [[UrlMaker alloc]initWithNewV1UrlStr:kPostReview Method:NetMethodPost andParam:newParam];
            }else if ([[Param objectForKey:@"isdiary"] isEqualToString:@"1"]) {
                //成长日记评论
                urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kDiaryReview Method:NetMethodPost andParam:newParam];
            }else{
                //秀秀评论
                urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kReview Method:NetMethodPost andParam:newParam];
            }
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [newParam allKeys]) {
                id obj = [newParam objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_REVIEW_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_REVIEW_FAIL object:errorString];
                    
                }
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
        }
            break;
            
        case NetStylePostBarWorthBuyReview:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kBuyReview Method:NetMethodPost andParam:Param];
            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                id obj=[Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_REVIEW_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_REVIEW_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
        case NetStylePraiseList:{
            
            UrlMaker *urlMaker;
            
            NSMutableDictionary *newParam=[NSMutableDictionary dictionary];
            
            NSArray *allkeys=[Param allKeys];
            
            for (NSString *key in allkeys) {
                
                if (![key isEqualToString:@"ispost"]) {
                    
                    [newParam setObject:[Param objectForKey:key] forKey:key];
                    
                }
                
            }
            
            if ([[Param objectForKey:@"ispost"] isEqualToString:@"1"]) {
                
                urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kPostAdmireList Method:NetMethodGet andParam:newParam];
                
            }else{
                
                urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kAdmireList Method:NetMethodGet andParam:newParam];
                
            }
            
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:blockRequest.responseData options:0 error:nil];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    NSArray *dataArray= [dic objectForKey:@"data"];
                    
                    NSMutableArray *praiseListArray=[NSMutableArray array];
                    
                    for (NSDictionary *dataDic in dataArray) {
                        
                        MyShowPraiseItem *praiseItem=[[MyShowPraiseItem alloc]init];
                        praiseItem.avatarStr=[dataDic objectForKey:@"avatar"];
                        praiseItem.authorname=[dataDic objectForKey:@"user_name"];
                        praiseItem.userid=[dataDic objectForKey:@"user_id"];
                        NSNumber *time=[dataDic objectForKey:@"admire_time"];
                        praiseItem.time=[self getTimeStrFromNow:time];
                        praiseItem.praiseId=[dataDic objectForKey:@"id"];
                        
                        [praiseListArray addObject:praiseItem];
                        
                    }
                    
                    [_responseDataDic setObject:praiseListArray forKey:[NSString stringWithFormat:@"%d",Style]];
                    NSString *StyleString=[NSString stringWithFormat:@"%d",Style];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_PRAISE_LIST_SUCCEED object:StyleString];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_PRAISE_LIST_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            
        case NetStyleEditUser:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kEditUser Method:NetMethodPost andParam:Param];
            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                
                if ([key isEqualToString:kRegistAvatar]) {
                    
                    [request setData:UIImageJPEGRepresentation([Param objectForKey:key], 1.0) withFileName:@"image.png" andContentType:@"image/png" forKey:kRegistAvatar];
                    
                }else{
                    
                    [request setPostValue:[Param objectForKey:key] forKey:key];
                    
                }
                
            }
            
            //            [request setDownloadCache:[self appDelegate].myCache];
            //            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            //            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    NSDictionary *dataDic=[dic objectForKey:@"data"];
                    NSUserDefaults *userDefault=[NSUserDefaults standardUserDefaults];
                    [userDefault setObject:[dataDic objectForKey:@"nick_name"] forKey:USERNICKNAME];
                    [userDefault setObject:[dataDic objectForKey:@"avatar"] forKey:USERAVATARSTR];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_EDIT_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_EDIT_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
        case NetStyleEditGroupHead:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:keditGroupHead Method:NetMethodPost andParam:Param];
            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                
                if ([key isEqualToString:@"cover"]) {
                    
                    [request setData:UIImageJPEGRepresentation([Param objectForKey:key], 1.0) withFileName:@"image.png" andContentType:@"image/png" forKey:@"cover"];
                    
                }else{
                    
                    [request setPostValue:[Param objectForKey:key] forKey:key];
                    
                }
                
            }
            
            //            [request setDownloadCache:[self appDelegate].myCache];
            //            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            //            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {

                    [[NSNotificationCenter defaultCenter] postNotificationName:EDITGROUPHEAD_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:EDITGROUPHEAD_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
  
        case NetStyleMyHomePage:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kUserInfo Method:NetMethodGet andParam:Param];
            
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:blockRequest.responseData options:0 error:nil];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    NSDictionary *dataDic=[dic objectForKey:@"data"];
                    NSMutableArray *homePageArray=[NSMutableArray array];
                    
                    MyHomePageItem *MHPItem=[[MyHomePageItem alloc]init];
                    MHPItem.showCount=[dataDic objectForKey:@"show_count"];
                    MHPItem.idolCount=[dataDic objectForKey:@"idol_count"];
                    MHPItem.fansCount=[dataDic objectForKey:@"funs_count"];
                    MHPItem.sharemeCount=[dataDic objectForKey:@"share_me_count"];
                    MHPItem.myshareCount=[dataDic objectForKey:@"my_share_count"];
                    MHPItem.relation=[dataDic objectForKey:@"relation"];
                    MHPItem.messCount=[dataDic objectForKey:@"latest_total_count"];
                    MHPItem.userName=[dataDic objectForKey:@"nick_name"];
                    MHPItem.avatarStr=[dataDic objectForKey:@"avatar"];
                    MHPItem.babys=[dataDic objectForKey:@"signature"];
                    MHPItem.registerUserName=[dataDic objectForKey:@"user_name"];
                    MHPItem.registerEmail=[dataDic objectForKey:@"email"];
                    
                    [[NSUserDefaults standardUserDefaults] setObject:MHPItem.registerUserName forKey:USERNAME];
                    [[NSUserDefaults standardUserDefaults] setObject:MHPItem.registerEmail forKey:USEREMAIL];
                    
                    [homePageArray addObject:MHPItem];
                    
                    NSString *styleString=[NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:homePageArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_USERINFO_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_USERINFO_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
        case NetStylegetIdolList:{
            
            UrlMaker *urlMaker =[[UrlMaker alloc]initWithNewUrlStr:kIdolListV2 Method:NetMethodGet andParam:Param];
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    
                    NSArray *dataArray = [dic objectForKey:kBBSData];
                    
                    NSMutableArray *IdoListArray = [NSMutableArray array];
                    
                    for (NSDictionary *idolDic in dataArray) {
                        
                        IdolListItem *idolItem = [[IdolListItem alloc]init];
                        idolItem.nickName = [idolDic objectForKey:@"nick_name"];
                        idolItem.avatarStr = [idolDic objectForKey:@"avatar"];
                        idolItem.relation = [idolDic objectForKey:@"relation"];
                        idolItem.userid = [idolDic objectForKey:@"user_id"];
                        idolItem.itemId = [idolDic objectForKey:@"id"];
                        [IdoListArray addObject:idolItem];
                        
                    }
                    
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:IdoListArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_IDOLLIST_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_IDOLLIST_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            //消息里面的动态,点击
        case NetStyleImageDetail:{
            
            _urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kPostImgInfo Method:NetMethodGet andParam:Param];
            
            _Getrequset=[ASIHTTPRequest requestWithURL:_urlMaker.url];
            
            [_Getrequset setDownloadCache:[self appDelegate].myCache];
            [_Getrequset setDelegate:self];
            [_Getrequset setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [_Getrequset setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [_Getrequset setShouldAttemptPersistentConnection:NO];
            [_Getrequset setTimeOutSeconds:10];
            [_Getrequset startAsynchronous];
            
            break;
            
        }
            
        case NetStyleFocusOn:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kFocusOn Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                id obj=[Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                NSLog(@"dic = %@",dic);
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_FOCUS_ON_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_FOCUS_ON_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            
        case NetStyleCancelFocus:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kCancelFocus Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                id obj=[Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_CANCEL_FOCUS_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_CANCEL_FOCUS_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
        case NetStyleRePort:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kReport Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                NSLog(@"key:%@",key);
                id obj=[Param objectForKey:key];
                NSLog(@"value:%@",obj);
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:blockRequest.responseData options:0 error:nil];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_REPORT_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_REPORT_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
        case NetStyleDeleteBaby:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kEditBabys Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                id obj=[Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DELETE_BABY_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DELETE_BABY_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            //消息中的动态
        case NetStyleGetMessList:{
            UrlMaker *urlMaker =[ [UrlMaker alloc]initWithNewV1UrlStr:kPostMyMessage Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:15];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest = request;
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    
                    NSArray *dataArray = [dic objectForKey:kBBSData];
                    NSMutableArray *MessListArray = [NSMutableArray array];
                    
                    for (NSDictionary *messDic in dataArray) {
                        
//                        if ([[messDic objectForKey:@"msg_type"] integerValue] == 3 || [[messDic objectForKey:@"msg_type"] integerValue] == 6 ||[[messDic objectForKey:@"msg_type"] integerValue] == 15){
                        if ([[messDic objectForKey:@"point"]isEqualToString:@"41"]||[[messDic objectForKey:@"point"]isEqualToString:@"42"] ||[[messDic objectForKey:@"point"]isEqualToString:@"31"]) {
                            
                            //消息
                            MessageListRequestItem *item = [[MessageListRequestItem alloc]init];
                            item.avatarStr = [messDic objectForKey:@"avatar"];
                            item.name = [messDic objectForKey:@"nick_name"];
                            item.message = [messDic objectForKey:@"message"];
                            item.messId = [messDic objectForKey:@"id"];
                            item.userid = [messDic objectForKey:@"user_id"];
                            item.msgType = [messDic objectForKey:@"msg_type"];
                            item.isAgreed = [messDic objectForKey:@"is_agree"];
                            item.relation = [messDic objectForKey:@"relation"];
                            item.isRead = [messDic objectForKey:@"is_read"];
                            item.root_imgid = [messDic objectForKey:@"root_img_id"];
                            item.share_userid = [messDic objectForKey:@"share_user_id"];
                            item.img_id = [messDic objectForKey:@"img_id"];
                            item.point = [messDic objectForKey:@"point"];
                            item.video_url = [messDic objectForKey:@"video_url"];
                            item.img_height = [messDic objectForKey:@"img_height"];
                            item.img_width = [messDic objectForKey:@"img_width"];
                            [MessListArray addObject:item];
                        } else {
                            //动态
                            MessageItem *item = [[MessageItem alloc]init];
                            item.avatarStr = [messDic objectForKey:@"avatar"];
                            item.nickName = [messDic objectForKey:@"nick_name"];
                            item.message = [messDic objectForKey:@"message"];
                            NSNumber *time = [messDic objectForKey:@"create_time"];
                            item.time = [self getTimeStrFromNow:time];
                            item.photoStr = [messDic objectForKey:@"img_thumb"];
                            item.messId = [messDic objectForKey:@"id"];
                            item.userId = [messDic objectForKey:@"user_id"];
                            item.imgId = [messDic objectForKey:@"img_id"];
                            item.isRead = [messDic objectForKey:@"is_read"];
                            item.rootImgId = [messDic objectForKey:@"root_img_id"];
                            item.target = [messDic objectForKey:@"target"];
                            item.isPost = [[messDic objectForKey:@"is_post"] boolValue];
                            item.isSave = [[messDic objectForKey:@"is_save"] boolValue];
                            item.msgType = [messDic objectForKey:@"msg_type"];
                            item.point = [messDic objectForKey:@"point"];
                            item.levelImg = [messDic objectForKey:@"level_img"];
                            item.video_url = [messDic objectForKey:@"video_url"];
                            item.img_height = [messDic objectForKey:@"img_height"];
                            item.img_width = [messDic objectForKey:@"img_width"];
                            [MessListArray addObject:item];
                        }
                        
                    }
                    
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:MessListArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_MESSLIST_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_MESSLIST_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            //消息好友动态
        case NetStylePostFriendsMessage:{
            UrlMaker *urlMaker =[ [UrlMaker alloc]initWithNewV1UrlStr:kPostFriendsMessage Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:15];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest = request;
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    
                    NSArray *dataArray = [dic objectForKey:kBBSData];
                    NSMutableArray *MessListArray = [NSMutableArray array];
                    
                    for (NSDictionary *messDic in dataArray) {
                        
                        //                        if ([[messDic objectForKey:@"msg_type"] integerValue] == 3 || [[messDic objectForKey:@"msg_type"] integerValue] == 6 ||[[messDic objectForKey:@"msg_type"] integerValue] == 15){
                        if ([[messDic objectForKey:@"point"]isEqualToString:@"41"]||[[messDic objectForKey:@"point"]isEqualToString:@"42"] ||[[messDic objectForKey:@"point"]isEqualToString:@"31"]) {
                            
                            //消息
                            MessageListRequestItem *item = [[MessageListRequestItem alloc]init];
                            item.avatarStr = [messDic objectForKey:@"avatar"];
                            item.name = [messDic objectForKey:@"nick_name"];
                            item.message = [messDic objectForKey:@"message"];
                            item.messId = [messDic objectForKey:@"id"];
                            item.userid = [messDic objectForKey:@"user_id"];
                            item.msgType = [messDic objectForKey:@"msg_type"];
                            item.isAgreed = [messDic objectForKey:@"is_agree"];
                            item.relation = [messDic objectForKey:@"relation"];
                            item.isRead = [messDic objectForKey:@"is_read"];
                            item.root_imgid = [messDic objectForKey:@"root_img_id"];
                            item.share_userid = [messDic objectForKey:@"share_user_id"];
                            item.img_id = [messDic objectForKey:@"img_id"];
                            item.point = [messDic objectForKey:@"point"];
                            item.video_url = [messDic objectForKey:@"video_url"];
                            item.img_height = [messDic objectForKey:@"img_height"];
                            item.img_width = [messDic objectForKey:@"img_width"];
                            
                            [MessListArray addObject:item];
                        } else {
                            //动态
                            MessageItem *item = [[MessageItem alloc]init];
                            item.avatarStr = [messDic objectForKey:@"avatar"];
                            item.nickName = [messDic objectForKey:@"nick_name"];
                            item.message = [messDic objectForKey:@"message"];
                            NSNumber *time = [messDic objectForKey:@"create_time"];
                            item.time = [self getTimeStrFromNow:time];
                            item.photoStr = [messDic objectForKey:@"img_thumb"];
                            item.messId = [messDic objectForKey:@"id"];
                            item.userId = [messDic objectForKey:@"user_id"];
                            item.imgId = [messDic objectForKey:@"img_id"];
                            item.isRead = [messDic objectForKey:@"is_read"];
                            item.rootImgId = [messDic objectForKey:@"root_img_id"];
                            item.target = [messDic objectForKey:@"target"];
                            item.isPost = [[messDic objectForKey:@"is_post"] boolValue];
                            item.isSave = [[messDic objectForKey:@"is_save"] boolValue];
                            item.msgType = [messDic objectForKey:@"msg_type"];
                            item.point = [messDic objectForKey:@"point"];
                            item.levelImg = [messDic objectForKey:@"level_img"];
                            item.video_url = [messDic objectForKey:@"video_url"];
                            item.img_height = [messDic objectForKey:@"img_height"];
                            item.img_width = [messDic objectForKey:@"img_width"];

                            [MessListArray addObject:item];
                        }
                        
                    }
                    
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:MessListArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYHOMEPAGE_MYFRIEND_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYHOMEPAGE_MYFRIEND_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            //红包列表
        case NetStylePacketList:{
            UrlMaker *urlMaker =[ [UrlMaker alloc]initWithNewUrlStr:kPacketList Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:15];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest = request;
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    
                    NSArray *dataArray = [dic objectForKey:kBBSData];
                    NSMutableArray *redListArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in dataArray) {
                        RedBagListItem *item = [[RedBagListItem alloc]init];
                        [item  setValuesForKeysWithDictionary:dataDic];
                        [redListArray addObject:item];

                    }
                    
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:redListArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYHOME_PACKLIST_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYHOME_PACKLIST_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }


            //消息中的消息
        case NetStyleGetMessRequestList:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kMessage Method:NetMethodGet andParam:Param];
            
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString] ;
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    NSArray *dataArray=[dic objectForKey:@"data"];
                    
                    NSMutableArray *messArray=[NSMutableArray array];
                    
                    for (NSDictionary *messDic in dataArray) {
                        
                        MessageListRequestItem *item=[[MessageListRequestItem alloc]init];
                        item.avatarStr=[messDic objectForKey:@"avatar"];
                        item.name=[messDic objectForKey:@"nick_name"];
                        item.message=[messDic objectForKey:@"message"];
                        item.messId=[messDic objectForKey:@"id"];
                        item.userid=[messDic objectForKey:@"user_id"];
                        item.msgType=[messDic objectForKey:@"msg_type"];
                        item.isAgreed=[messDic objectForKey:@"is_agree"];
                        item.relation=[messDic objectForKey:@"relation"];
                        item.isRead=[messDic objectForKey:@"is_read"];
                        
                        [messArray addObject:item];
                        
                    }
                    
                    NSString *styleString=[NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:messArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_MESSLIST_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_MESSLIST_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            //我发布的,他发布的
        case NetStylemyImgs:{
            
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewV1UrlStr:kMyImgs Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    
                    NSArray *dataArray = [dic objectForKey:kBBSData];
                    
                    NSMutableArray *myImgsArray = [NSMutableArray array];
                    
                    for (NSDictionary *dic in dataArray) {
                        
                        NSMutableArray *singleArray = [[NSMutableArray alloc]init];
                        
                        NSDictionary *imgDic = [dic objectForKey:kMyShowImg];
                        
                        NSNumber *time=[imgDic objectForKey:kMyShowCreatTime];
                        
                        if ([self isToday:time] == YES) {
                            
                            MyOutPutTitleItem *titleItem = [[MyOutPutTitleItem alloc]init];
                            titleItem.imgid = [imgDic objectForKey:kMyShowImgId];
                            titleItem.userid = [imgDic objectForKey:@"user_id"];
                            titleItem.time = @"今天";
                            titleItem.come_from = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"come_from"]];
                            titleItem.height = 42;
                            titleItem.identify = @"TITLETODAY";
                            titleItem.create_time = [imgDic objectForKey:kMyShowCreatTime];
                            titleItem.video_url = [imgDic objectForKey:@"video_url"];
                            [singleArray addObject:titleItem];
                            
                        }else{
                            
                            MyOutPutTitleItemNotToday *titleItem=[[MyOutPutTitleItemNotToday alloc]init];
                            
                            titleItem.imgid=[imgDic objectForKey:kMyShowImgId];
                            titleItem.come_from=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"come_from"]];
                            titleItem.userid = [imgDic objectForKey:@"user_id"];
                            MyOutPutTitleItemNotToday *item=[self MyOutPutGetTime:time];
                            titleItem.day=item.day;
                            titleItem.month=item.month;
                            titleItem.year=item.year;
                            titleItem.height=42;
                            titleItem.identify=@"TITLENOTTODAY";
                            titleItem.create_time = [imgDic objectForKey:kMyShowCreatTime];
                            titleItem.video_url = [imgDic objectForKey:@"video_url"];
                            [singleArray addObject:titleItem];
                            
                        }
                        
                        NSArray *photoArray=[imgDic objectForKey:@"img"];
                        if (photoArray.count) {
                            
                            MyOutPutImgGroupItem *imgItem=[[MyOutPutImgGroupItem alloc]init];
                            imgItem.video_url = [imgDic objectForKey:@"video_url"];
                            imgItem.imgid = [imgDic objectForKey:@"img_id"];
                            
                            for (NSDictionary *photoDic in photoArray) {
                                
                                MyShowImageItem *imageItem=[[MyShowImageItem alloc]init];
                                imageItem.imageStr=[photoDic objectForKey:kMyShowImgThumb];
                                imageItem.imgId=[photoDic objectForKey:kMyShowImgId];
                                imageItem.imageClearStr=[photoDic objectForKey:kMyShowImg];
                                imageItem.img_down=[photoDic objectForKey:kMyShowImgDown];
                                imageItem.img_height=[photoDic objectForKey:kMyShowImgWidth];
                                imageItem.img_width=[photoDic objectForKey:kMyShowImgHeight];
                                imageItem.img_thumb_width=[photoDic objectForKey:kMyShowImgThumbWidth];
                                imageItem.img_thumb_height=[photoDic objectForKey:kMyShowImgThumbHeight];
                                [imgItem.photosArray addObject:imageItem];
                                
                            }
                            
                            if (photoArray.count==1) {
                                
                                imgItem.identify=@"IMGONE";
                                
                                NSDictionary *singleImgDic=[photoArray objectAtIndex:0];
                                float height=[[singleImgDic objectForKey:kMyShowImgThumbHeight] floatValue];
                                float width=[[singleImgDic objectForKey:kMyShowImgThumbWidth] floatValue];
                                if (imgItem.video_url.length > 0) {
                                    imgItem.height = SCREENWIDTH*0.6+20;
                                }else{
                                imgItem.frame=[MyShowImgFrame getFrameWithTheImageWidth:width AndHeight:height];
                                imgItem.height=imgItem.frame.size.height;
                                }
                            }else{
                                
                                imgItem.identify=@"IMG";
                                
                                if (photoArray.count<4) {
                                    imgItem.height=110;
                                }else{
                                    imgItem.height=215;
                                }
                                
                            }
                            if (imgItem.height) {
                                
                                [singleArray addObject:imgItem];
                                
                            }
                            
                        }
                        
                        MyOutPutUrlItem *urlItem=[[MyOutPutUrlItem alloc]init];
                        urlItem.url_string=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"post_url"]];
                        if (urlItem.url_string.length) {
                            
                            urlItem.url_img_string=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"post_url_image"]];
                            urlItem.title=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"post_url_title"]];
                            urlItem.identify=@"URLITEM";
                            urlItem.height=0;
                            
                            [singleArray addObject:urlItem];
                            
                        }
                        
                        MyOutPutDescribeItem *desItem=[[MyOutPutDescribeItem alloc]init];
                        desItem.desContent=[imgDic objectForKey:kMyShowDescription];
                        if (desItem.desContent.length) {
                            
                            desItem.identify=@"DESCRIBE";
                            NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                            paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                            NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle.copy};
                            CGSize size=[desItem.desContent boundingRectWithSize:CGSizeMake(292, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                            
                            if (size.height>18) {
                                desItem.height = size.height+6;
                            }else{
                                desItem.height=24;
                            }
                            
                            [singleArray addObject:desItem];
                            
                        }
                        
                        MyOutPutPraiseAndReviewItem *praiseItem=[[MyOutPutPraiseAndReviewItem alloc]init];
                        praiseItem.praise_count=[imgDic objectForKey:kMyShowAdmireCount];
                        praiseItem.review_count=[imgDic objectForKey:kMyShowReviewCount];
                        praiseItem.isPraised=[[imgDic objectForKey:kMyShowImgIsAdmired] boolValue];
                        praiseItem.imgid=[imgDic objectForKey:kMyShowImgId];
                        praiseItem.cate_name = imgDic[@"cate_name"];
                        NSNumber *cate_id = imgDic[@"cate_id"];
                        praiseItem.cate_id = [cate_id integerValue];
                        praiseItem.height=40;
                        praiseItem.identify=@"PRAISE";
                        praiseItem.videoUrl = [imgDic objectForKey:@"video_url"];
                        
                        [singleArray addObject:praiseItem];
                        
                        [myImgsArray addObject:singleArray];
                        
                    }
                    
                    NSString *styleString=[NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:myImgsArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWGET_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWGET_FAIL object:errorString];
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            
            
        case NetStyleUploadPhoto:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kUpImgs Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                
                if ([key isEqualToString:@"photos"]) {
                    
                    NSArray *photoArray=[Param objectForKey:key];
                    
                    [request setPostValue:[NSString stringWithFormat:@"%d", (int)photoArray.count] forKey:@"file_count"];
                    
                    for (int i=0; i<[photoArray count] ; i++) {
                        
                        UIImage *image=[photoArray objectAtIndex:i];
                        
                        [request setData:UIImageJPEGRepresentation(image, 1.0) withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                        
                    }
                    
                }else{
                    
                    NSString *value=[Param objectForKey:key];
                    [request setPostValue:value forKey:key];
                    
                }
                
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:60];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:blockRequest.responseData options:0 error:nil];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_UPLOAD_PHOTOS_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_UPLOAD_PHOTOS_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
        case NetStyleAgreeShare:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kDoShare Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                id obj=[Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:blockRequest.responseData options:0 error:nil];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_AGREE_SHARE_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_AGREE_SHARE_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
        case NetStyleShareList:{
            
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kShareListV2 Method:NetMethodGet andParam:Param];
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    
                    NSArray *messArray = [dic objectForKey:kBBSData];
                    NSMutableArray *shareListArray = [NSMutableArray array];
                    
                    for (NSDictionary *dataDic in messArray) {
                        ShareItem *item = [[ShareItem alloc]init];
                        
                        item.avatar = [dataDic objectForKey:@"avatar"];
                        item.isShare = [dataDic objectForKey:@"is_share"];
                        item.nickName = [dataDic objectForKey:@"nick_name"];
                        item.userId = [dataDic objectForKey:@"user_id"];
                        
                        [shareListArray addObject:item];
                        
                    }
                    
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:shareListArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_SHARE_LIST_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_SHARE_LIST_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
        case NetStyleCancelShare:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kCancelShare Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                id obj=[Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_CANCEL_SHARE_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_CANCEL_SHARE_FAIL object:errorString];
                    
                }
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            //删除秀秀和话题,成长日记
        case NetStyleDelShow:{
            
            NSMutableDictionary *newParam = [NSMutableDictionary dictionary];
            
            NSArray *allkeys = [Param allKeys];
            
            for (NSString *key in allkeys) {
                
                if ((![key isEqualToString:@"ispost"]) && (![key isEqualToString:@"isdiary"])) {
                    
                    [newParam setObject:[Param objectForKey:key] forKey:key];
                    
                }
                
            }
            
            UrlMaker *urlMaker;
            
            if ([[Param objectForKey:@"ispost"] isEqualToString:@"1"]) {
                
                urlMaker = [[UrlMaker alloc]initWithNewV1UrlStr:kDelPostShow Method:NetMethodPost andParam:newParam];
                
            }else if ([[Param objectForKey:@"isdiary"] isEqualToString:@"1"]) {
                
                urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kDelDiary Method:NetMethodPost andParam:newParam];
                
            }else{
                
                urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kDelShow Method:NetMethodPost andParam:newParam];
                
            }
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [newParam allKeys]) {
                
                id obj = [newParam objectForKey:key];
                [request setPostValue:obj forKey:key];
                
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DELETE_SHOW_SUCCEED object:self];
                }else{
                    NSString *errorString = [dic objectForKey:kBBSData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DELETE_SHOW_FAIL object:errorString];
                }
            }];
            
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
            }];
            break;
        }
            //删除专题
        case NetStyleDelSpecial:{
            
            NSMutableDictionary *newParam = [NSMutableDictionary dictionary];
            
            NSArray *allkeys = [Param allKeys];
            for (NSString *key in allkeys) {
                [newParam setObject:[Param objectForKey:key] forKey:key];
            }
            
            UrlMaker *urlMaker;
            
            
            urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kDelSpecial Method:NetMethodPost andParam:newParam];
            
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [newParam allKeys]) {
                
                id obj = [newParam objectForKey:key];
                [request setPostValue:obj forKey:key];
                
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DELETE_SHOW_SUCCEED object:self];
                }else{
                    NSString *errorString = [dic objectForKey:kBBSData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DELETE_SHOW_FAIL object:errorString];
                }
            }];
            
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
            }];
            break;
        }
            
        case NetStyleWorthBuyDeletShow:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithUrlStr:kDelBuyShow Method:NetMethodPost andParam:Param];
            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                
                id obj=[Param objectForKey:key];
                NSLog(@"value:%@,key:%@",obj,key);
                [request setPostValue:obj forKey:key];
                
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:blockRequest.responseData options:0 error:nil];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DELETE_SHOW_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DELETE_SHOW_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
        case NetStyleWorthBuyDelReview:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kDelBuyReview Method:NetMethodPost andParam:Param];
            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                id obj=[Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:blockRequest.responseData options:0 error:nil];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DELETE_REVIEW_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DELETE_REVIEW_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            //删除评论，秀秀和话题,成长日记
        case NetStyleDelReview:{
            
            NSMutableDictionary *newParam = [NSMutableDictionary dictionary];
            
            NSArray *allkeys = [Param allKeys];
            
            for (NSString *key in allkeys) {
                
                if ((![key isEqualToString:@"ispost"]) && (![key isEqualToString:@"isdiary"])) {
                    
                    [newParam setObject:[Param objectForKey:key] forKey:key];
                    
                }
            }
            
            UrlMaker *urlMaker;
            
            if ([[Param objectForKey:@"isdiary"] isEqualToString:@"1"]) {
                //删除成长日记评论
                urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kDelDiaryReview Method:NetMethodPost andParam:newParam];
                
            }else if ([[Param objectForKey:@"ispost"] isEqualToString:@"1"]) {
                //删除话题评论
                urlMaker = [[UrlMaker alloc]initWithUrlStr:kDelPostReview Method:NetMethodPost andParam:newParam];
                
            }else{
                //删除秀秀评论
                urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kDelReview Method:NetMethodPost andParam:newParam];
                
            }
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [newParam allKeys]) {
                id obj = [newParam objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DELETE_REVIEW_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DELETE_REVIEW_FAIL object:errorString];
                    
                }
            }];
            
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
            }];
            break;
        }
            
        case NetStylePostBarRefreshReviews:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kPostInfo Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            NSMutableArray *rowArray=[NSMutableArray array];
            NSMutableArray *sectionArray=[NSMutableArray array];
            NSMutableDictionary *returnDic=[NSMutableDictionary dictionary];
            
            __weak ASIHTTPRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:blockRequest.responseData options:0 error:nil];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    NSArray *dataArray=[dic objectForKey:@"data"];
                    
                    NSDictionary *dataDic=[dataArray objectAtIndex:0];
                    NSDictionary *imgDic=[dataDic objectForKey:@"img"];
                    
                    MyShowSectionItem *sectionItem=[[MyShowSectionItem alloc]init];
                    sectionItem.userid=[imgDic objectForKey:@"user_id"];
                    sectionItem.authorname=[imgDic objectForKey:@"user_name"];
                    sectionItem.avatarImageStr=[imgDic objectForKey:@"avatar"];
                    NSNumber *time=[imgDic objectForKey:@"create_time"];
                    sectionItem.time=[self getTimeStrFromNow:time];
                    sectionItem.resourceType=@"2";
                    [sectionArray addObject:sectionItem];
                    
                    MyShowDescribeItem *describItem=[[MyShowDescribeItem alloc]init];
                    describItem.content=[imgDic objectForKey:@"description"];
                    static NSString *DESCRIBE=@"DESCRIBE";
                    describItem.identify=DESCRIBE;
                    
                    NSString *urlStr=[imgDic objectForKey:@"post_url"];
                    if (urlStr.length) {
                        
                        MyShowUrlItem *urlItem=[[MyShowUrlItem alloc]init];
                        urlItem.url_string=urlStr;
                        urlItem.url_img_string=[imgDic objectForKey:@"post_url_image"];
                        urlItem.title=[imgDic objectForKey:@"post_url_title"];
                        urlItem.identify=@"URL";
                        urlItem.height=67;
                        
                        
                        [rowArray addObject:urlItem];
                        
                    }
                    
                    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle.copy};
                    CGSize size=[describItem.content boundingRectWithSize:CGSizeMake(290, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                    describItem.height =ceilf(size.height);
                    
                    if (describItem.content.length) {
                        [rowArray addObject:describItem];
                    }
                    
                    NSArray *photosArray;
                    if ([imgDic objectForKey:@"img"]) {
                        photosArray=[imgDic objectForKey:@"img"];
                    }
                    
                    if ( photosArray && photosArray.count ){
                        
                        MyShowImageGroupItem *imgGroupItem=[[MyShowImageGroupItem alloc]init];
                        if ([imgDic objectForKey:kMyShowImgId]) {
                            imgGroupItem.imgId=[imgDic objectForKey:kMyShowImgId];
                        }
                        static NSString *IMAGE=@"IMAGE";
                        imgGroupItem.identify=IMAGE;
                        static NSString *IMAGEONE=@"IMAGEONE";
                        
                        if (photosArray.count==1) {
                            
                            imgGroupItem.identify=IMAGEONE;
                            
                            NSDictionary *singleImgDic=[photosArray objectAtIndex:0];
                            
                            if ([singleImgDic objectForKey:kMyShowImgThumbHeight] && [singleImgDic objectForKey:kMyShowImgThumbWidth]) {
                                
                                float avatarHeight=[[singleImgDic objectForKey:kMyShowImgThumbHeight] floatValue];
                                imgGroupItem.width=[[singleImgDic objectForKey:kMyShowImgThumbWidth] floatValue];
                                
                                imgGroupItem.frame=[MyShowImgFrame getFrameWithTheImageWidth:imgGroupItem.width AndHeight:avatarHeight];
                                imgGroupItem.height=imgGroupItem.frame.size.height;
                                imgGroupItem.width=imgGroupItem.frame.size.height;
                                
                            }
                            
                        }else if ( photosArray.count<4 ){
                            
                            imgGroupItem.height=110;
                            
                        }else{
                            
                            imgGroupItem.height=220;
                            
                        }
                        
                        for ( NSDictionary *photoDic in photosArray ) {
                            
                            MyShowImageItem *imageItem=[[MyShowImageItem alloc]init];
                            
                            if ([photoDic objectForKey:kMyShowImgThumb] && [photoDic objectForKey:kMyShowImg]) {
                                
                                imageItem.imageStr=[photoDic objectForKey:kMyShowImgThumb];
                                imageItem.imageClearStr=[photoDic objectForKey:kMyShowImg];
                                imageItem.img_down=[photoDic objectForKey:kMyShowImgDown];
                                imageItem.img_height=[photoDic objectForKey:kMyShowImgWidth];
                                imageItem.img_width=[photoDic objectForKey:kMyShowImgHeight];
                                imageItem.img_thumb_width=[photoDic objectForKey:kMyShowImgThumbWidth];
                                imageItem.img_thumb_height=[photoDic objectForKey:kMyShowImgThumbHeight];
                                [imgGroupItem.photosArray addObject:imageItem];
                                
                            }
                            
                            
                        }
                        
                        if (imgGroupItem.photosArray.count) {
                            
                            [rowArray addObject:imgGroupItem];
                            
                        }
                        
                    }
                    
                    
                    MyShowPraisecountItem *praiseCItem=[[MyShowPraisecountItem alloc]init];
                    praiseCItem.count=[imgDic objectForKey:@"admire_count"];
                    praiseCItem.height=30;
                    static NSString *PRAISECOUNT=@"PRAISECOUNT";
                    praiseCItem.identify=PRAISECOUNT;
                    [rowArray addObject:praiseCItem];
                    
                    NSArray *reviews=[dataDic objectForKey:@"reviews"];
                    
                    if ([[imgDic objectForKey:@"review_count"] intValue]>4) {
                        for (int i=0 ; i<reviews.count ; i++) {
                            if (i==0 || i==1 || i==reviews.count-2 || i==reviews.count-1) {
                                NSDictionary *review=[reviews objectAtIndex:i];
                                MyShowReviewItem *reviewItem=[[MyShowReviewItem alloc]init];
                                reviewItem.username=[review objectForKey:kMyShowReviewUserName];
                                reviewItem.content=[review objectForKey:kMyShowReviewDemand];
                                static NSString *REVIEW=@"REVIEW";
                                reviewItem.identify=REVIEW;
                                reviewItem.height=30;
                                [rowArray addObject:reviewItem];
                                
                                if (i==1) {
                                    MyShowReviewCountItem *reviewcountItem=[[MyShowReviewCountItem alloc]init];
                                    reviewcountItem.reviewCount=[NSString stringWithFormat:@"查看所有%@条评论",[imgDic objectForKey:@"review_count"]];
                                    static NSString *REVIEWCOUNT=@"REVIEWCOUNT";
                                    reviewcountItem.identify=REVIEWCOUNT;
                                    reviewcountItem.height=30;
                                    [rowArray addObject:reviewcountItem];
                                }
                            }
                        }
                    }else{
                        for (NSDictionary *review in reviews) {
                            MyShowReviewItem *reviewItem=[[MyShowReviewItem alloc]init];
                            reviewItem.username=[review objectForKey:kMyShowReviewUserName];
                            reviewItem.content=[review objectForKey:kMyShowReviewDemand];
                            static NSString *REVIEW=@"REVIEW";
                            reviewItem.identify=REVIEW;
                            reviewItem.height=30;
                            [rowArray addObject:reviewItem];
                        }
                    }
                    
                    MyShowPraiseBtnItem *praiseBtnItem=[[MyShowPraiseBtnItem alloc]init];
                    praiseBtnItem.height=30;
                    praiseBtnItem.isAdmire=[[imgDic objectForKey:@"is_admire"] intValue];
                    static NSString *PRAISEBTN=@"PRAISEBTN";
                    praiseBtnItem.identify=PRAISEBTN;
                    [rowArray addObject:praiseBtnItem];
                    
                    [returnDic setObject:sectionArray forKey:@"section"];
                    [returnDic setObject:rowArray forKey:@"row"];
                    NSString *styleString=[NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnDic forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWGET_REFRESH_REVIEW_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWGET_REFRESH_REVIEW_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            
        case NetStylePostBarAddTopic:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kPostImage  Method:NetMethodPost andParam:Param];
            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            NSLog(@"all keys:%@",[Param allKeys]);
            
            for (NSString *key in [Param allKeys]) {
                
                if ([key isEqualToString:@"photos"]) {
                    
                    NSArray *photoArray=[Param objectForKey:key];
                    
                    if (photoArray.count==1) {
                        
                        UIImage *image=[photoArray firstObject];
                        NSData *basicImgData=UIImagePNGRepresentation(image);
                        
                        if (basicImgData.length/1024>300) {
                            
                            CGFloat scale=512/image.size.width;
                            CGSize size=CGSizeMake(512, image.size.height*scale);
                            UIImage *newImage=[image scaleToSize:image size:size];
                            
                            float quality=0.75;
                            NSData *imgData=UIImageJPEGRepresentation(newImage, quality);
                            [request setData:imgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",1]];
                            
                        }else{
                            
                            [request setData:basicImgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",1]];
                            
                        }
                        
                    }else{
                        
                        for (int i=0; i<[photoArray count] ; i++) {
                            
                            UIImage *image=[photoArray objectAtIndex:i];
                            NSData *basicImgData=UIImagePNGRepresentation(image);
                            
                            if (basicImgData.length/1024>200) {
                                
                                CGFloat scale=320/image.size.width;
                                CGSize size=CGSizeMake(320, image.size.height*scale);
                                UIImage *newImage=[image scaleToSize:image size:size];
                                
                                float quality=0.75;
                                NSData *imgData=UIImageJPEGRepresentation(newImage, quality);
                                [request setData:imgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                                
                            }else{
                                
                                [request setData:basicImgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                                
                            }
                            
                        }
                        
                    }
                    
                }else if ([key isEqualToString:@"img_urls"]){
                    
                    NSArray *urlArry=[Param objectForKey:key];
                    NSString *urlJsonStr=[urlArry JSONRepresentation];
                    [request setPostValue:urlJsonStr forKey:key];
                    
                }else{
                    
                    NSString *value=[Param objectForKey:key];
                    [request setPostValue:value forKey:key];
                    
                }
                
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:120];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:blockRequest.responseData options:0 error:nil];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_ADD_TOPPIC_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_ADD_TOPPIC_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
            //新版值得买发布
        case NetStylePostBarAddTopicWorthBuy: {
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kWorthBuyImageNew Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            NSArray *keys=[Param allKeys];
            for (NSString *key in keys) {
                [request setPostValue:[Param objectForKey:key] forKey:key];
            }
            [request setTimeOutSeconds:60];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_PUBLISH_WORTHBUY_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_PUBLISH_WORTHBUY_FAIL object:errorString];
                    
                }
                
            }];
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:nil];
                
            }];
            break;
        }
            
        case NetStyleMakeAShowNew:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kPublicListing Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            NSString *isVideo;
            
            for (NSString *key in [Param allKeys]) {
                
                if ([key isEqualToString:@"photos"]) {
                    
                    NSArray *photoArray=[Param objectForKey:key];
                    
                    if (photoArray.count==1) {
                        
                        UIImage *image=[photoArray firstObject];
                        NSData *basicImgData=UIImagePNGRepresentation(image);
                        
                        if (basicImgData.length/1024>300) {
                            
                            CGFloat scale=512/image.size.width;
                            CGSize size=CGSizeMake(512, image.size.height*scale);
                            UIImage *newImage=[image scaleToSize:image size:size];
                            
                            float quality=0.75;
                            NSData *imgData=UIImageJPEGRepresentation(newImage, quality);
                            [request setData:imgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",1]];
                            
                        }else{
                            
                            [request setData:basicImgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",1]];
                            
                        }
                        
                    }else{
                        
                        for (int i=0; i<[photoArray count] ; i++) {
                            
                            UIImage *image=[photoArray objectAtIndex:i];
                            NSData *basicImgData=UIImagePNGRepresentation(image);
                            
                            if (basicImgData.length/1024>200) {
                                
                                CGFloat scale=320/image.size.width;
                                CGSize size=CGSizeMake(320, image.size.height*scale);
                                UIImage *newImage=[image scaleToSize:image size:size];
                                
                                float quality=0.75;
                                NSData *imgData=UIImageJPEGRepresentation(newImage, quality);
                                [request setData:imgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                                
                            }else{
                                
                                [request setData:basicImgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                                
                            }
                            
                        }
                        
                    }
                    
                }else if ([key isEqualToString:@"img_urls"]){
                    
                    NSArray *urlArry=[Param objectForKey:key];
                    NSString *urlJsonStr=[urlArry JSONRepresentation];
                    [request setPostValue:urlJsonStr forKey:key];
                    
                }else if ([key isEqualToString:@"video_url"]){
                    NSString *urlString = [Param objectForKey:key];
                    NSURL *url = [NSURL URLWithString:urlString];
                    
                    NSData *videoData = [NSData dataWithContentsOfURL:url];
                    isVideo = @"1";
                    [request setData:videoData withFileName:@"video1.mp4" andContentType:@"video/quicktime" forKey:@"video1"];
                }else{
                    
                    NSString *value=[Param objectForKey:key];
                    [request setPostValue:value forKey:key];
                    
                }
                
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:120];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
               // dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                    
                    if ([[dic objectForKey:@"success"] integerValue]==1) {
                        NSDictionary *dataDict = [dic objectForKey:kBBSData];
                        AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                        delegate.hasNewShow = YES;
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:dataDict];
                        if ([isVideo isEqualToString:@"1"]) {
                            [dic setObject:isVideo forKey:@"isVideo"];
                        }
                        [[NSNotificationCenter defaultCenter] postNotificationName:USER_MAKEASHOW_SUCCEED object:dic];
                        
                    }else{

                        NSString *errorString=[dic objectForKey:@"reMsg"];

                        [[NSNotificationCenter defaultCenter] postNotificationName:USER_MAKEASHOW_FAIL object:errorString];
                        //62
                    }
             //  });
            }];
            
            [request setFailedBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"网络连接发秀秀失败啦");

                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                });
                
            }];
            
            break;
            
            
        }
            //发专题秀秀
        case NetStyleMakeASpecialShowNew:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kMakeAShowWithType Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                
                if ([key isEqualToString:@"photos"]) {
                    NSArray *photoArray=[Param objectForKey:key];
                    
                    if (photoArray.count==1) {
                        
                        UIImage *image=[photoArray firstObject];
                        NSData *basicImgData=UIImagePNGRepresentation(image);
                        
                        if (basicImgData.length/1024>300) {
                            
                            CGFloat scale=512/image.size.width;
                            CGSize size=CGSizeMake(512, image.size.height*scale);
                            UIImage *newImage=[image scaleToSize:image size:size];
                            
                            float quality=0.75;
                            NSData *imgData=UIImageJPEGRepresentation(newImage, quality);
                            [request setData:imgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",1]];
                            
                        }else{
                            
                            [request setData:basicImgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",1]];
                            
                        }
                        
                    }else{
                        
                        for (int i=0; i<[photoArray count] ; i++) {
                            
                            UIImage *image=[photoArray objectAtIndex:i];
                            NSData *basicImgData=UIImagePNGRepresentation(image);
                            
                            if (basicImgData.length/1024>200) {
                                
                                CGFloat scale=320/image.size.width;
                                CGSize size=CGSizeMake(320, image.size.height*scale);
                                UIImage *newImage=[image scaleToSize:image size:size];
                                
                                float quality=0.75;
                                NSData *imgData=UIImageJPEGRepresentation(newImage, quality);
                                [request setData:imgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                                
                            }else{
                                
                                [request setData:basicImgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                                
                            }
                            
                        }
                        
                    }
                    
                }else if ([key isEqualToString:@"img_urls"]){
                    
                    NSArray *urlArry=[Param objectForKey:key];
                    NSString *urlJsonStr=[urlArry JSONRepresentation];
                    [request setPostValue:urlJsonStr forKey:key];
                    
                }else if ([key isEqualToString:@"video_url"]){
                    NSString *urlString = [Param objectForKey:key];
                    NSURL *url = [NSURL URLWithString:urlString];
                    
                    NSData *videoData = [NSData dataWithContentsOfURL:url];
                    [request setData:videoData withFileName:@"video1.mp4" andContentType:@"video/quicktime" forKey:@"video1"];
                }else{
                    
                    NSString *value=[Param objectForKey:key];
                    [request setPostValue:value forKey:key];
                    
                }
                
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:120];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                // dispatch_async(dispatch_get_main_queue(), ^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    NSDictionary *dataDict = [dic objectForKey:kBBSData];
                    AppDelegate *delegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                    delegate.hasNewShow = YES;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MAKEASHOWSPECIAL_SUCCEED object:dataDict];
                    
                }else{
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MAKEASHOWSPECIAL_FAIL object:errorString];
                    //62
                }
                //  });
                
            }];
            
            [request setFailedBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                });
                
            }];
            
            break;
            
            
        }

           //游客
        case NetStyleVisitorRegist:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kVisitorRegist Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            for (NSString *key in [Param allKeys]) {
                [request setPostValue:[Param objectForKey:key] forKey:key];
            }
            [request setTimeOutSeconds:60];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    NSDictionary *dataDic=[dic objectForKey:@"data"];
                    UserInfoItem *userItem=[[UserInfoItem alloc]init];
                    userItem.userId=[dataDic objectForKey:@"user_id"];
                    userItem.nickname=[dataDic objectForKey:@"nick_name"];
                    userItem.city = [dataDic objectForKey:@"city"];
                    userItem.isVisitor=[NSNumber numberWithDouble:YES];
                    UserInfoManager *manager=[[UserInfoManager alloc]init];
                    [manager saveUserInfo:userItem];
                    NSDictionary *userDic = [NSDictionary dictionaryWithObjectsAndKeys:userItem.userId,@"user_id", userItem.city,@"city",nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_VISITOR_MESSAGE_SUCCEED object:userDic];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_VISITOR_MESSAGE_FAIL object:errorString];
                    
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NETVISTOR_ERROR object:self];
                
            }];
            
            break;
            
        }
            
            //值得买列表详情
        case NetStylePostBarWorthBuy:{
            
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kBuyList Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] integerValue]==1) {
                    
                    NSArray *dataArray=[dic objectForKey:kBBSData];
                    NSMutableArray *returnArray=[NSMutableArray array];
                    
                    for (NSDictionary *dataDic in dataArray) {
                        
                        NSDictionary *imgDic=[dataDic objectForKey:@"img"];
                        
                        WorthBuyItem *item=[[WorthBuyItem alloc]init];
                        
                        item.good_id = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_id"]];
                        item.shopName=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"business"]];
                        item.remainTime=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"between_time"]];
                        item.descript=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"description"]];
                        item.currentPrice=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"current_price"]];
                        item.isPostage=[[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"is_postage"]]boolValue];
                        item.good_type=[[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"good_type"]]intValue];
                        item.originPrice=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"original_price"]];
                        item.latestState=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"reason"]];
                        item.time=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"post_create_time"]];
                        item.urlstring=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"post_url"]];
                        
                        NSArray *photosArray=[imgDic objectForKey:@"img"];
                        
                        if (photosArray.count) {
                            
                            NSMutableArray *returnArray=[NSMutableArray array];
                            
                            for (NSDictionary *singleImgDic in photosArray) {
                                
                                WorthBuyImageItem *imgItem=[[WorthBuyImageItem alloc]init];
                                imgItem.imgThumbStr=[singleImgDic objectForKey:@"img_thumb"];
                                imgItem.imgStr1280=[singleImgDic objectForKey:@"img"];
                                imgItem.imgClearStr=[singleImgDic objectForKey:@"img_down"];
                                [returnArray addObject:imgItem];
                                
                            }
                            
                            item.photoArray=returnArray;
                            
                        }
                        
                        [returnArray addObject:item];
                        
                    }
                    
                    NSString *styleString = [NSString stringWithFormat:@"%ld",(long)Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_WORTHBUY_DATA_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_WORTHBUY_DATA_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
            //值得买更多列表
        case NetStyleBuyNewList:{
            
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kBuyNewList Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] integerValue]==1) {
                    
                    NSArray *dataArray=[dic objectForKey:kBBSData];
                    NSMutableArray *returnArray=[NSMutableArray array];
                    
                    for (NSDictionary *dataDic in dataArray) {
                        
                        WorthBuyNewListItem *item = [[WorthBuyNewListItem alloc]init];
                        item.buy_List = [[dataDic objectForKey:@"buy_list" ]intValue];
                        item.cate_name = dataDic[@"cate_name"];
                        NSArray *imgsArray =[dataDic objectForKey:@"imgs"];
                        if (imgsArray.count) {
                            NSMutableArray *returnArray=[NSMutableArray array];
                            
                            for (NSDictionary *imgDic in imgsArray) {
                                WorthBuyNewListImageItem *imgItem = [[WorthBuyNewListImageItem alloc]init];
                                
                                imgItem.img_thumb = imgDic[@"img_thumb"];
                                imgItem.current_price = imgDic[@"current_price"];
                                imgItem.original_price = imgDic[@"original_price"];
                                imgItem.img_description = imgDic[@"img_description"];
                                [returnArray addObject:imgItem];
                                
                            }
                            item.imgs = returnArray;
                        }
                        
                        [returnArray addObject:item];
                        
                    }
                    
                    NSString *styleString = [NSString stringWithFormat:@"%ld",(long)Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_WORTHBUYNEWLIST_DATA_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_WORTHBUYNEWLIST_DATA_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
            //更多专题
        case NetStyleSpecialList:{
          //  UrlMaker *urlMaker = [[UrlMaker alloc]initWithUrlStr:kSpecialList Method:NetMethodGet andParam:Param];
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kSpecialList Method:NetMethodGet andParam:Param];

            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy| ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIHTTPRequest *blockRequest = request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:kBBSSuccess]integerValue] == 1) {
                    NSDictionary *dataArray = [dic objectForKey:kBBSData];
                    NSMutableArray *returnArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in dataArray) {
                        MoreSpecialModel *moreSpecialModel = [[MoreSpecialModel alloc]init];
                        moreSpecialModel.rank = [[dataDic objectForKey:@"rank"]integerValue];
                        moreSpecialModel.cate_name = [dataDic objectForKey:@"cate_name"];
                        moreSpecialModel.cate_id = [[dataDic objectForKey:@"cate_id"]integerValue];
                        moreSpecialModel.renshu = [[dataDic objectForKey:@"renshu"]integerValue];
                        NSArray *imgsArray = [dataDic objectForKey:@"imgs"];
                        NSMutableArray *imgssArray = [NSMutableArray array];
                        if (imgsArray.count) {
                            //  NSMutableArray *returnArray = [NSMutableArray array];
                            for (NSDictionary *imgDic in imgsArray) {
                                NSString *imgString = imgDic[@"img_thumb"];
                                [imgssArray addObject:imgString];
                            }
                            moreSpecialModel.firstImge = imgssArray[0];
                            moreSpecialModel.secondImge = imgssArray[1];
                            moreSpecialModel.thirdImge = imgssArray[2];
                            moreSpecialModel.fourImge = imgssArray[3];
                        }
                        
                        [returnArray addObject:moreSpecialModel];
                        
                    }
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:USER_MYSHOWNEW_GET_SUCCEED object:styleString];
                }else
                {
                    NSString *errorString=[dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWNEW_GET_FAIL object:errorString];
                }
                
            }];
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:USER_NET_ERROR object:self];
            }];
            break;
        }
            
            
            
            //话题收藏
        case NetStylePostBarAddToBeMyFocus:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kSavePost Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            NSArray *keys=[Param allKeys];
            for (NSString *key in keys) {
                [request setPostValue:[Param objectForKey:key] forKey:key];
            }
            [request setTimeOutSeconds:60];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_ADDTOBEMYFOCUS_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_ADDTOBEMYFOCUS_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            //话题取消收藏
        case NetStylePostBarCancelFocus:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kCancelPost Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            NSArray *keys=[Param allKeys];
            for (NSString *key in keys) {
                [request setPostValue:[Param objectForKey:key] forKey:key];
            }
            [request setTimeOutSeconds:60];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_CANCELFOCUS_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_CANCELFOCUS_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
            
            //最新和我的圈子合并
        case NetStyleNewTheme:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kNewThemeV1 Method:NetMethodGet andParam:Param];
            
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:15];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    NSArray *dataArray=[dic objectForKey:@"data"];
                    
                    NSMutableArray *returnArray=[NSMutableArray array];
                    
                    for (NSDictionary *dic in dataArray) {
                        
                        NSMutableArray *singleArray=[[NSMutableArray alloc]init];
                        
                        NSDictionary *imgDic=[dic objectForKey:kMyShowImg];
                        
                        NSNumber *time=[imgDic objectForKey:kMyShowCreatTime];
                        //未关注
                        if ([[imgDic objectForKey:@"is_focus"] intValue]==0) {
                            
                            MyShowNewPickedTitleFocusItem *titleItem=[[MyShowNewPickedTitleFocusItem alloc]init];
                            titleItem.imgid=[imgDic objectForKey:kMyShowImgId];
                            titleItem.height=43;
                            titleItem.create_time = [imgDic objectForKey:kMyShowCreatTime];
//titleItem.is_recommend = [[imgDic objectForKey:@"recommend"] boolValue];
                            titleItem.avatarStr=[imgDic objectForKey:@"avatar"];
                            titleItem.username=[imgDic objectForKey:@"user_name"];
                            titleItem.userid=[imgDic objectForKey:@"user_id"];
                            titleItem.identify=@"TITLEFOCUS";
                            titleItem.level_img = [imgDic objectForKey:@"level_img"];
                            [singleArray addObject:titleItem];
                        }else if ([self isToday:time]==YES){
                            //xx小时前
                            MyShowNewPickedTitleTodayItem *titleItem=[[MyShowNewPickedTitleTodayItem alloc]init];
                            titleItem.imgid=[imgDic objectForKey:kMyShowImgId];
                            titleItem.time=[self getTimeStrFromNow:time];
                            titleItem.create_time = [imgDic objectForKey:kMyShowCreatTime];
                            titleItem.height=43;
                           // titleItem.is_recommend = [[imgDic objectForKey:@"recommend"] boolValue];
                            titleItem.avatarStr=[imgDic objectForKey:@"avatar"];
                            titleItem.username=[imgDic objectForKey:@"user_name"];
                            titleItem.userid=[imgDic objectForKey:@"user_id"];
                            titleItem.identify=@"PICKEDTITLETODAY";
                            titleItem.level_img = [imgDic objectForKey:@"level_img"];
                            titleItem.img_cate = [[imgDic objectForKey:@"img_cate"]stringValue];
                            [singleArray addObject:titleItem];
                            
                        }else if ([self isToday:time]==NO){
                            //xx年月日
                            MyShowNewPickedTitleNotTodayItem *titleItem=[[MyShowNewPickedTitleNotTodayItem alloc]init];
                            titleItem.imgid=[imgDic objectForKey:kMyShowImgId];
                            titleItem.avatarStr=[imgDic objectForKey:@"avatar"];
                            titleItem.username=[imgDic objectForKey:@"user_name"];
                            titleItem.userid=[imgDic objectForKey:@"user_id"];
                            titleItem.create_time = [imgDic objectForKey:kMyShowCreatTime];
                            MyOutPutTitleItemNotToday *item=[self MyOutPutGetTime:time];
                            titleItem.day=item.day;
                            titleItem.month=item.month;
                            titleItem.year=item.year;
                            titleItem.height=42;
                           // titleItem.is_recommend = [[imgDic objectForKey:@"recommend"] boolValue];
                            titleItem.identify=@"PICKEDTITLENOTTODAY";
                            titleItem.level_img = [imgDic objectForKey:@"level_img"];
                            titleItem.img_cate = [[imgDic objectForKey:@"img_cate"]stringValue];
                            [singleArray addObject:titleItem];
                            
                        }
                        
                        NSArray *photoArray=[imgDic objectForKey:@"img"];
                        if (photoArray.count) {
                            
                            MyOutPutImgGroupItem *imgItem=[[MyOutPutImgGroupItem alloc]init];
                            
                            for (NSDictionary *photoDic in photoArray) {
                                
                                MyShowImageItem *imageItem=[[MyShowImageItem alloc]init];
                                imageItem.imageStr=[photoDic objectForKey:kMyShowImgThumb];
                                //                                imageItem.imgId=[photoDic objectForKey:kMyShowImgId];
                                imageItem.imageClearStr=[photoDic objectForKey:kMyShowImg];
                                
                                imageItem.img_down=[photoDic objectForKey:kMyShowImgDown];
                                imageItem.img_height=[photoDic objectForKey:kMyShowImgWidth];
                                imageItem.img_width=[photoDic objectForKey:kMyShowImgHeight];
                                imageItem.img_thumb_width=[photoDic objectForKey:kMyShowImgThumbWidth];
                                imageItem.img_thumb_height=[photoDic objectForKey:kMyShowImgThumbHeight];
                                
                                [imgItem.photosArray addObject:imageItem];
                                
                            }
                            
                            if (photoArray.count==1) {
                                //单张
                                imgItem.identify=@"IMGONE";
                                
                                NSDictionary *singleImgDic=[photoArray objectAtIndex:0];
                                float height=[[singleImgDic objectForKey:kMyShowImgThumbHeight] floatValue];
                                float width=[[singleImgDic objectForKey:kMyShowImgThumbWidth] floatValue];
                                
                                imgItem.frame=[MyShowImgFrame getFrameWithTheImageWidth:width AndHeight:height];
                                imgItem.height=imgItem.frame.size.height;
                                
                            }else{
                                //多张
                                imgItem.identify=@"IMG";
                                imgItem.height=160;
                                
                            }
                            
                            [singleArray addObject:imgItem];
                            
                        }
                        
                        
                        MyOutPutDescribeItem *desItem=[[MyOutPutDescribeItem alloc]init];
                        desItem.desContent=[imgDic objectForKey:kMyShowDescription];
                        if (desItem.desContent.length) {
                            
                            desItem.identify=@"DESCRIBE";
                            NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                            paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                            NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle.copy};
                            CGSize size=[desItem.desContent boundingRectWithSize:CGSizeMake(292, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                            
                            if (size.height>18) {
                                desItem.height = size.height+6;
                            }else{
                                desItem.height=24;
                            }
                            
                            [singleArray addObject:desItem];
                            
                        }
                        
                        MyOutPutPraiseAndReviewItem *praiseItem=[[MyOutPutPraiseAndReviewItem alloc]init];
                        praiseItem.praise_count=[imgDic objectForKey:kMyShowAdmireCount];
                        praiseItem.review_count=[imgDic objectForKey:kMyShowReviewCount];
                        praiseItem.isPraised=[[imgDic objectForKey:kMyShowImgIsAdmired] boolValue];
                        praiseItem.imgid=[imgDic objectForKey:kMyShowImgId];
                        praiseItem.img_cate = [[imgDic objectForKey:@"img_cate"]stringValue];
                        
                        praiseItem.userid=[imgDic objectForKey:@"user_id"];
                        praiseItem.cate_name = imgDic[@"cate_name"];
                        NSNumber *cate_id = imgDic[@"cate_id"];
                        praiseItem.cate_id = [cate_id integerValue];
                        praiseItem.create_time = imgDic[@"create_time"];
                        praiseItem.height=40;
                        praiseItem.identify=@"PRAISE";
                        praiseItem.groupId = [[imgDic objectForKey:@"group_id"]integerValue];
                        
                        [singleArray addObject:praiseItem];
                        
                        [returnArray addObject:singleArray];
                        
                    }
                    
                    NSString *styleString=[NSString stringWithFormat:@"%d",Style];
                    
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWNEW_GET_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWNEW_GET_FAIL object:errorString];
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }

            //话题顶部今日推荐
        case NetStylePostAlbumList:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kPostCoverListV1 Method:NetMethodGet andParam:Param];
            
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] integerValue]==1) {
                    
                    NSDictionary *dataArray = [dic objectForKey:kBBSData];
                    NSMutableArray *returnArray=[NSMutableArray array];
                    
                    for (NSDictionary *dataDic in dataArray) {
                        PostBarHeaderItem *item = [[PostBarHeaderItem alloc]init];
                        item.itemID = [dataDic  objectForKey:@"id"];
                        item.img = [dataDic objectForKey:@"post_album"];
                        item.img_id = [dataDic objectForKey:@"img_id"];
                        item.title = [dataDic objectForKey:@"post_title"];
                        item.user_id = [dataDic objectForKey:@"user_id"];
                        item.is_saved = [[dataDic objectForKey:@"is_save"] boolValue];
                        NSNumber *isGroup = [dataDic objectForKey:@"is_group"];
                        item.is_group = [isGroup integerValue];
                        item.groupId = [[dataDic objectForKey:@"group_id"]integerValue];
                        item.groupName = [dataDic objectForKey:@"group_name"];
                        item.is_bjCity = [dataDic[@"is_bj_city"]boolValue];
                        [returnArray addObject:item];
                    }
                    NSString *styleString=[NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_GET_HEADER_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_GET_HEADER_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            //我的兴趣列表
        case  NetStylePostMyInterest:{
            UrlMaker *urlMarker = [[UrlMaker alloc]initWithNewUrlStr:kPostMyInterest Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMarker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIHTTPRequest *blockRequest=request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"]integerValue ]==1) {
                    NSArray *dataArray = dic[@"data"];
                    NSMutableArray *returnArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in dataArray) {
                        PostMyInterestV3Item *pMyItemV3 = [[PostMyInterestV3Item alloc]init];
                        pMyItemV3.titleInSection = dataDic[@"title"];
                        pMyItemV3.moreInterest = dataDic[@"more_interest"];
                        pMyItemV3.interest_type = [[dataDic objectForKey:@"interest_type"]integerValue];
                        NSArray *imgArray = [dataDic objectForKey:@"img"];
                        if (imgArray.count) {
                            NSMutableArray *returnArray = [NSMutableArray array];
                            for (NSDictionary *imgDic in imgArray) {
                                PostMyInterestItem *pMyItem = [[PostMyInterestItem alloc]init];
                              //  pMyItem.img_thumb = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_thumb"]];
                                pMyItem.img_thumb = imgDic[@"img_thumb"];
                                
                                pMyItem.imgId = imgDic[@"img_id"];
                                pMyItem.userid = imgDic[@"user_id"];
                                pMyItem.img_title = imgDic[@"img_title"];
                                pMyItem.describe = imgDic[@"description"];
                                pMyItem.create_time = imgDic[@"create_time"];
                                pMyItem.post_create_time = imgDic[@"post_create_time"];
                                NSNumber *group_id = imgDic[@"group_id"];
                                pMyItem.group_id = [group_id integerValue];
                                pMyItem.group_name = imgDic[@"group_name"];
                                NSNumber *is_group = imgDic[@"is_group"];
                                pMyItem.is_group = [is_group integerValue];
                                pMyItem.reviewCount = [imgDic objectForKey:@"review_count"];
                                pMyItem.postCount = [imgDic objectForKey:@"post_count"];
                                [returnArray addObject:pMyItem];

                            }
                            pMyItemV3.imgsArray = returnArray;
                        }
                        [returnArray addObject:pMyItemV3];
                    }
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    [[NSNotificationCenter  defaultCenter ]postNotificationName:USER_POSTMYINTEREST_GET_SUCCEED object:styleString];
                    
                    
                }else{
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter]postNotificationName:USER_POSTMYINTEREST_GET_FAIL object:errorString];
                    
                }
                
            }];
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:USER_NET_ERROR object:self];
            }];
            break;
        }
            //热点下面的列表
        case  NetStylePostMyInterestListV1:{

            UrlMaker *urlMarker = [[UrlMaker alloc]initWithNewV1UrlStr:kPostMyInterestListV3 Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMarker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIHTTPRequest *blockRequest=request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"]integerValue ]==1) {
                    NSArray *dataArray = dic[@"data"];
                    NSMutableArray *returnArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in dataArray) {
                        NSDictionary * imgDic = dataDic[@"img"];
                        PostMyInterestItem *pMyItem = [[PostMyInterestItem alloc]init];
                        pMyItem.img = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img"]];
                        pMyItem.imgId = imgDic[@"img_id"];
                        pMyItem.userid = imgDic[@"user_id"];
                        pMyItem.img_title = imgDic[@"img_title"];
                        pMyItem.describe = imgDic[@"description"];
                        pMyItem.create_time = imgDic[@"create_time"];
                        pMyItem.post_create_time = imgDic[@"post_create_time"];
                        NSNumber *group_id = imgDic[@"group_id"];
                        pMyItem.group_id = [group_id integerValue];
                        pMyItem.group_name = imgDic[@"group_name"];
                        NSNumber *is_group = imgDic[@"is_group"];
                        pMyItem.is_group = [is_group integerValue];
                        NSNumber *is_share = imgDic[@"is_share"];
                        pMyItem.is_share = [is_share integerValue];
                        pMyItem.reviewCount = [imgDic objectForKey:@"review_count"];
                        pMyItem.postCount = [imgDic objectForKey:@"post_count"];
                        pMyItem.video_url = [imgDic objectForKey:@"video_url"];
                        [returnArray addObject:pMyItem];
                        
                    }
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    [[NSNotificationCenter  defaultCenter ]postNotificationName:USER_POSTMYINTEREST_GET_SUCCEED object:styleString];
                }else{
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter]postNotificationName:USER_POSTMYINTEREST_GET_FAIL object:errorString];
                    
                }
                
            }];
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:USER_NET_ERROR object:self];
            }];
            break;
        }
   
            //新版话题分类
        case  NetStylePostListV5:{
            UrlMaker *urlMarker = [[UrlMaker alloc]initWithNewV1UrlStr:kPostListV6 Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMarker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIHTTPRequest *blockRequest=request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"]integerValue ]==1) {
                    NSArray *dataArray = dic[@"data"];
                    NSMutableArray *returnArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in dataArray) {
                        NSDictionary * imgDic = dataDic[@"img"];
                        PostMyInterestItem *pMyItem = [[PostMyInterestItem alloc]init];
                        pMyItem.img = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img"]];
                        pMyItem.imgId = imgDic[@"img_id"];
                        pMyItem.userid = imgDic[@"user_id"];
                        pMyItem.img_title = imgDic[@"img_title"];
                        pMyItem.describe = imgDic[@"description"];
                        pMyItem.create_time = imgDic[@"create_time"];
                        pMyItem.post_create_time = imgDic[@"post_create_time"];
                        NSNumber *group_id = imgDic[@"group_id"];
                        pMyItem.group_id = [group_id integerValue];
                        pMyItem.group_name = imgDic[@"group_name"];
                        NSNumber *is_group = imgDic[@"is_group"];
                        pMyItem.is_group = [is_group integerValue];
                        NSNumber *is_share = imgDic[@"is_share"];
                        pMyItem.is_share = [is_share integerValue];
                        pMyItem.reviewCount = [imgDic objectForKey:@"review_count"];
                        pMyItem.video_url = [imgDic objectForKey:@"video_url"];
                        pMyItem.postCount = [imgDic objectForKey:@"post_count"];
                        [returnArray addObject:pMyItem];
                        
                    }
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    [[NSNotificationCenter  defaultCenter ]postNotificationName:USER_POSTLISTV5_GET_SUCCEED object:styleString];
                    
                    
                }else{
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter]postNotificationName:USER_POSTLISTV5_GET_FAIL object:errorString];
                    
                }
                
            }];
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:USER_NET_ERROR object:self];
            }];
            break;
        }
            //新版话题更多的群和帖子
        case  NetStylePostMyInterestList:{
            UrlMaker *urlMarker = [[UrlMaker alloc]initWithNewUrlStr:KPostMyInterestList Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMarker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIHTTPRequest *blockRequest=request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"]integerValue ]==1) {
                    NSArray *dataArray = dic[@"data"];
                    NSMutableArray *returnArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in dataArray) {
                        NSDictionary * imgDic = dataDic[@"img"];
                        PostMyInterestItem *pMyItem = [[PostMyInterestItem alloc]init];
                        pMyItem.img = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img"]];
                        pMyItem.imgId = imgDic[@"img_id"];
                        pMyItem.userid = imgDic[@"user_id"];
                        pMyItem.img_title = imgDic[@"img_title"];
                        pMyItem.describe = imgDic[@"description"];
                        pMyItem.create_time = imgDic[@"create_time"];
                        pMyItem.post_create_time = imgDic[@"post_create_time"];
                        NSNumber *group_id = imgDic[@"group_id"];
                        pMyItem.group_id = [group_id integerValue];
                        pMyItem.group_name = imgDic[@"group_name"];
                        NSNumber *is_group = imgDic[@"is_group"];
                        pMyItem.is_group = [is_group integerValue];
                        NSNumber *is_share = imgDic[@"is_share"];
                        pMyItem.is_share = [is_share integerValue];
                        pMyItem.reviewCount = [imgDic objectForKey:@"review_count"];
                        pMyItem.postCount = [imgDic objectForKey:@"post_count"];
                        [returnArray addObject:pMyItem];
                        
                    }
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    [[NSNotificationCenter  defaultCenter ]postNotificationName:USER_POSTMYINTERESTLIST_GET_SUCCEED object:styleString];
                }else{
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter]postNotificationName:USER_POSTMYINTERESTLIST_GET_FAIL object:errorString];
                    
                }
                
            }];
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:USER_NET_ERROR object:self];
            }];
            break;
        }
            //首页跳转到群列表
        case  NetStylePostGetGroupList:{
            UrlMaker *urlMarker = [[UrlMaker alloc]initWithNewUrlStr:kGetGroupList Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMarker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIHTTPRequest *blockRequest=request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"]integerValue ]==1) {
                    NSArray *dataArray = dic[@"data"];
                    NSMutableArray *returnArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in dataArray) {
                        NSDictionary * imgDic = dataDic[@"img"];
                        PostMyInterestItem *pMyItem = [[PostMyInterestItem alloc]init];
                        pMyItem.img = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img"]];
                        pMyItem.imgId = imgDic[@"img_id"];
                        pMyItem.userid = imgDic[@"user_id"];
                        pMyItem.img_title = imgDic[@"img_title"];
                        pMyItem.describe = imgDic[@"description"];
                        pMyItem.create_time = imgDic[@"create_time"];
                        pMyItem.post_create_time = imgDic[@"post_create_time"];
                        NSNumber *group_id = imgDic[@"group_id"];
                        pMyItem.group_id = [group_id integerValue];
                        pMyItem.group_name = imgDic[@"group_name"];
                        NSNumber *is_group = imgDic[@"is_group"];
                        pMyItem.is_group = [is_group integerValue];
                        NSNumber *is_share = imgDic[@"is_share"];
                        pMyItem.is_share = [is_share integerValue];
                        pMyItem.reviewCount = [imgDic objectForKey:@"review_count"];
                        pMyItem.postCount = [imgDic objectForKey:@"post_count"];
                        [returnArray addObject:pMyItem];
                        
                    }
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    [[NSNotificationCenter  defaultCenter ]postNotificationName:USER_POSTMYINTERESTLIST_GET_SUCCEED object:styleString];
                }else{
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter]postNotificationName:USER_POSTMYINTERESTLIST_GET_FAIL object:errorString];
                    
                }
                
            }];
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:USER_NET_ERROR object:self];
            }];
            break;
        }

            //新版点击更多商家列表
        case  NetStyleGetBusinessList:{
            UrlMaker *urlMarker = [[UrlMaker alloc]initWithNewV1UrlStr:kGetBusinessListV3 Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMarker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIHTTPRequest *blockRequest=request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"]integerValue ]==1) {
                    NSArray *dataArray = dic[@"data"];
                    NSMutableArray *returnArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in dataArray) {
                        NSDictionary * imgDic = dataDic[@"img"];
                        StoreMoreListItem *storeMoreListItem = [[StoreMoreListItem alloc]init];
                        storeMoreListItem.businessId = imgDic[@"business_id"];
                        storeMoreListItem.businessPic = imgDic[@"business_pic"];
                        storeMoreListItem.businessTitle = imgDic[@"business_title"];
                        storeMoreListItem.post_create_time = imgDic[@"post_create_time"];
                        storeMoreListItem.subtitle = imgDic[@"subtitle"];
                        storeMoreListItem.distance = imgDic[@"distance"];
                        storeMoreListItem.business_babyshow_price1 = imgDic[@"business_babyshow_price1"];
                        storeMoreListItem.business_market_price1 = imgDic[@"business_market_price1"];
                        [returnArray addObject:storeMoreListItem];
                        
                    }
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    [[NSNotificationCenter  defaultCenter ]postNotificationName:USER_POSTBAR_NEW_GETBUSINESSLIST_SUCCEED object:styleString];
                    
                }else{
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter]postNotificationName:USER_POSTBAR_NEW_GETBUSINESSLIST_FAIL object:errorString];
                    
                }
                
            }];
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:USER_NET_ERROR object:self];
            }];
            break;
        }
            //新版我的订单列表
        case  NetStyleUserOrderList:{
           UrlMaker *urlMarker = [[UrlMaker alloc]initWithNewV1UrlStr:kUserOrderList Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMarker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIHTTPRequest *blockRequest=request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"]integerValue ]==1) {
                    NSArray *dataArray = dic[@"data"];
                    NSMutableArray *returnArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in dataArray) {
                        MyOrdersItem *myOrdersItem = [[MyOrdersItem alloc]init];
                        myOrdersItem.order_id = dataDic[@"order_id"];
                        myOrdersItem.businessTitle = dataDic[@"business_title"];
                        myOrdersItem.businessTime = dataDic[@"business_time"];
                        myOrdersItem.orderNum = dataDic[@"order_num"];
                        myOrdersItem.verification = dataDic[@"verification"];
                        myOrdersItem.package = dataDic[@"package"];
                        myOrdersItem.price =dataDic[@"price"];
                        myOrdersItem.status = dataDic[@"status"];
                        myOrdersItem.postCreatTime = dataDic[@"post_create_time"];
                        myOrdersItem.businessId = dataDic[@"business_id"];
                        myOrdersItem.order_role = dataDic[@"order_role"];
                        myOrdersItem.package_name = dataDic[@"package_name"];
                        myOrdersItem.business_contact = dataDic[@"business_contact"];
                        [returnArray addObject:myOrdersItem];
                        
                    }
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    [[NSNotificationCenter  defaultCenter ]postNotificationName:USER_ORDER_MYORDER_GETMYORDERLIST_SUCCEED object:styleString];
                    
                }else{
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter]postNotificationName:USER_ORDER_MYORDER_GETMYORDERLIST_FAIL object:errorString];
                    
                }
                
            }];
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:USER_NET_ERROR object:self];
            }];
            break;
        }
            //新版商家的订单列表
        case  NetStyleBusinessOrderList:{
            UrlMaker *urlMarker = [[UrlMaker alloc]initWithNewV1UrlStr:kBusinessOrderList Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMarker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIHTTPRequest *blockRequest=request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"]integerValue ]==1) {
                    NSArray *dataArray = dic[@"data"];
                    NSMutableArray *returnArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in dataArray) {
                        StoreOrdersItem *myOrdersItem = [[StoreOrdersItem alloc]init];
                        myOrdersItem.order_id = dataDic[@"order_id"];
                        myOrdersItem.orderNum = dataDic[@"order_num"];
                        myOrdersItem.package = dataDic[@"package"];
                        myOrdersItem.price =dataDic[@"price"];
                        myOrdersItem.status = dataDic[@"status"];
                        myOrdersItem.postCreatTime = dataDic[@"post_create_time"];
                        myOrdersItem.verification = dataDic[@"verification"];
                        myOrdersItem.package_name = dataDic[@"package_name"];
                        
                        [returnArray addObject:myOrdersItem];
                        
                    }
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    [[NSNotificationCenter  defaultCenter ]postNotificationName:USER_ORDER_BUSINESS_GETMYORDERLIST_SUCCEED object:styleString];
                    
                }else{
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter]postNotificationName:USER_ORDER_BUSINESS_GETMYORDERLIST_FAIL object:errorString];
                    
                }
                
            }];
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:USER_NET_ERROR object:self];
            }];
            break;
        }
            //我的首页专题
        case  NetStyleSpecialRevision:{
            UrlMaker *urlMarker = [[UrlMaker alloc]initWithNewUrlStr:kSpecialRevision Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMarker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIHTTPRequest *blockRequest=request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"]integerValue ]==1) {
                    NSArray *dataArray = dic[@"data"];
                    NSMutableArray *returnArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in dataArray) {
                        MyShowNewVersionItem *myShowNewVItem = [[MyShowNewVersionItem alloc]init];
                        myShowNewVItem.special_name = dataDic[@"special_name"];
                        myShowNewVItem.special_type = dataDic[@"special_type"];
                        myShowNewVItem.more_special = dataDic[@"more_special"];
                        myShowNewVItem.type = [dataDic[@"type"]integerValue];
                        myShowNewVItem.isClick = [dataDic[@"is_click"]boolValue];
                        myShowNewVItem.vice_special_name = dataDic[@"vice_special_name"];
                        if(dataDic[@"cate_id"] !=nil &&dataDic[@"cate_id"]!= NULL){
                            myShowNewVItem.cateId = [dataDic[@"cate_id"]integerValue];
                        }
                        if (dataDic[@"cate_name"]!= nil && dataDic[@"cate_name"] != NULL) {
                            myShowNewVItem.cateName = dataDic[@"cate_name"];
                        }
                        if (dataDic[@"img_id"]!=nil &&dataDic
                            [@"img_id"]!= NULL) {
                           myShowNewVItem.img_id = [dataDic[@"img_id"]integerValue];
                        }
                        if (dataDic[@"business_url"]!=nil &&dataDic
                            [@"business_url"]!= NULL) {
                            myShowNewVItem.businessUrl = dataDic[@"business_url"];
                        }
                        if (dataDic[@"group_id"]!=nil &&dataDic
                            [@"group_id"]!= NULL) {
                            myShowNewVItem.group_id = [dataDic[@"group_id"]integerValue];
                        }
                        if (dataDic[@"group_name"]!=nil &&dataDic
                            [@"group_name"]!= NULL) {
                            myShowNewVItem.groupName = dataDic[@"group_name"];
                        }
                        if (dataDic[@"business_id"]!=nil &&dataDic
                            [@"business_id"]!= NULL) {
                           myShowNewVItem.businessId = dataDic[@"business_id"] ;
                        }
                        if (dataDic[@"business_name"]!=nil &&dataDic[@"business_name"]!= NULL) {
                            myShowNewVItem.businessName = dataDic[@"business_name"];
                        }

                        myShowNewVItem.imgArray = dataDic[@"img"];
                        if (myShowNewVItem.imgArray.count) {
                            NSMutableArray *returnArray = [NSMutableArray array];
                            for (NSDictionary *imgDic in myShowNewVItem.imgArray) {
                                MyShowNewVersionItem2 *pMyItem = [[MyShowNewVersionItem2 alloc]init];
                                pMyItem.img_thumb = imgDic[@"img_thumb"];
                                pMyItem.img_id= imgDic[@"img_id"];
                                pMyItem.user_id = imgDic[@"user_id"];
                                pMyItem.img_title = imgDic[@"img_title"];
                                pMyItem.business_babyshow_price1 = imgDic[@"business_babyshow_price1"];
                                pMyItem.business_market_price1 = imgDic[@"business_market_price1"];
                                pMyItem.current_price = imgDic[@"current_price"];
                                [returnArray addObject:pMyItem];
                                
                            }
                            myShowNewVItem.imgArray = returnArray;
                        }
                        [returnArray addObject:myShowNewVItem];
                    }
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    [[NSNotificationCenter  defaultCenter ]postNotificationName:USER_MYSHOWSPECIANEW_SPECIALREVISION_SUCCEED object:styleString];
                    
                    
                }else{
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter]postNotificationName:USER_MYSHOWSPECIANEW_SPECIALREVISION_FAIL object:errorString];
                    
                }
                
            }];
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:USER_NET_ERROR object:self];
            }];
            break;
        }

            //商家评论列表
        case NetStyleBusinessCommentList:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kBusinessCommentList Method:NetMethodGet andParam:Param];
            
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            
            __weak ASIHTTPRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:blockRequest.responseData options:0 error:nil];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    NSArray *data=[dic objectForKey:@"data"];
                    
                    NSMutableArray *dataArray=[NSMutableArray array];
                    
                    for (NSDictionary *dataDic in data) {
                        
                        BusinessCommentListItem *reviewItem=[[BusinessCommentListItem alloc]init];
                        
                        reviewItem.userMsg=[dataDic objectForKey:@"user_msg"];
                        reviewItem.userName=[dataDic objectForKey:kReviewListUserName];
                        reviewItem.postCreatetime = dataDic[@"post_create_time"];
                        reviewItem.grade3 = dataDic[@"grade3"];
                        reviewItem.userTime = dataDic[@"user_time"];
                        NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:15]};
                        CGFloat height = [reviewItem.userMsg boundingRectWithSize:CGSizeMake(SCREENWIDTH-25, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:dic context:nil].size.height;
                        reviewItem.height=height;
                        
                        [dataArray addObject:reviewItem];
                        
                    }
                    
                    [_responseDataDic setObject:dataArray forKey:[NSString stringWithFormat:@"%d",Style]];
                    NSNumber *styleNumber=[NSNumber numberWithInteger:Style];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_ORDER_BUSINESS_GETCOMMENTLIST_SUCCEED object:styleNumber];
                    
                }else{
                    
                    self.message=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_ORDER_BUSINESS_GETCOMMENTLIST_FAIL object:self];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }

            //商家列表上传验证码
        case NetStyleBusinessVerification:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kBusinessVerification Method:NetMethodGet andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                id obj=[Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_ORDER_BUSINESS_GETBUSINESSVERIFICATION_SUCCEED object:self];
                    NSLog(@"成功了");
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_ORDER_BUSINESS_GETBUSINESSVERIFICATION_FAIL  object:errorString];
                    NSLog(@"验证失败了");
                    

                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }

            //新版话题圈子详情
        case  NetStyleGroupDetailList:{
            UrlMaker *urlMarker = [[UrlMaker alloc]initWithNewV1UrlStr:kGroupDetailListV8 Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMarker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIHTTPRequest *blockRequest=request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"]integerValue ]==1) {
                    NSArray *dataArray = dic[@"data"];
                    NSMutableArray *returnArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in dataArray) {
                        NSDictionary * imgDic = dataDic[@"img"];
                        PostMyGroupDetailItem *pMyItem = [[PostMyGroupDetailItem alloc]init];
                        pMyItem.img = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img"]];
                        pMyItem.imgId = imgDic[@"img_id"];
                        pMyItem.userid = imgDic[@"user_id"];
                        pMyItem.img_title = imgDic[@"img_title"];
                        pMyItem.describe = imgDic[@"description"];
                        pMyItem.create_time = imgDic[@"create_time"];
                        pMyItem.post_create_time = imgDic[@"post_create_time"];
                        pMyItem.reviewCount = [imgDic objectForKey:@"review_count"];
                        pMyItem.postCount = [imgDic objectForKey:@"post_count"];
                        pMyItem.is_group = [[imgDic objectForKey:@"is_group"]integerValue];
                        NSNumber *is_recommend = [imgDic objectForKey:@"is_recommend"];
                        pMyItem.is_recommend = [is_recommend integerValue];
                        pMyItem.is_top = [[imgDic objectForKey:@"is_top"]integerValue];
                        pMyItem.isNotice = [[imgDic objectForKey:@"is_notice"]integerValue];
                        pMyItem.isEssence = [[imgDic objectForKey:@"is_essence"]integerValue];
                        pMyItem.distinguish = [imgDic objectForKey:@"distinguish"];
                        pMyItem.videoUrl = [imgDic objectForKey:@"video_url"];
                        [returnArray addObject:pMyItem];
                        
                    }
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    [[NSNotificationCenter  defaultCenter ]postNotificationName: USER_GROUPDETAILLIST_GET_SUCCEED object:styleString];
                    
                }else{
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter]postNotificationName:USER_GROUPDETAILLIST_GET_FAIL object:errorString];
                    
                }
                
            }];
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:USER_NET_ERROR object:self];
            }];
            break;
        }
            //群主管理帖子
        case  NetStyleGroupDetailListEdit:{
            UrlMaker *urlMarker = [[UrlMaker alloc]initWithNewV1UrlStr:kGroupDetailListV7 Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMarker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIHTTPRequest *blockRequest=request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"]integerValue ]==1) {
                    NSArray *dataArray = dic[@"data"];
                    NSMutableArray *returnArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in dataArray) {
                        NSDictionary * imgDic = dataDic[@"img"];
                        PostMyGroupDetailItem *pMyItem = [[PostMyGroupDetailItem alloc]init];
                        pMyItem.img = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img"]];
                        pMyItem.imgId = imgDic[@"img_id"];
                        pMyItem.userid = imgDic[@"user_id"];
                        pMyItem.img_title = imgDic[@"img_title"];
                        pMyItem.describe = imgDic[@"description"];
                        pMyItem.create_time = imgDic[@"create_time"];
                        pMyItem.post_create_time = imgDic[@"post_create_time"];
                        pMyItem.reviewCount = [imgDic objectForKey:@"review_count"];
                        pMyItem.postCount = [imgDic objectForKey:@"post_count"];
                        pMyItem.is_group = [[imgDic objectForKey:@"is_group"]integerValue];
                        NSNumber *is_recommend = [imgDic objectForKey:@"is_recommend"];
                        pMyItem.is_recommend = [is_recommend integerValue];
                        pMyItem.is_top = [[imgDic objectForKey:@"is_top"]integerValue];
                        pMyItem.isNotice = [[imgDic objectForKey:@"is_notice"]integerValue];
                        pMyItem.isEssence = [[imgDic objectForKey:@"is_essence"]integerValue];
                        
                        [returnArray addObject:pMyItem];
                        
                    }
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    [[NSNotificationCenter  defaultCenter ]postNotificationName: USER_GROUPDETAILLIST_GET_SUCCEED object:styleString];
                    
                }else{
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter]postNotificationName:USER_GROUPDETAILLIST_GET_FAIL object:errorString];
                    
                }
                
            }];
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:USER_NET_ERROR object:self];
            }];
            break;
        }
            //群主管理精华和公告列表
        case  NetStyleNoticeRecGroupList:{
            UrlMaker *urlMarker = [[UrlMaker alloc]initWithNewV1UrlStr:kNoticeRecGroupList Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMarker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIHTTPRequest *blockRequest=request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"]integerValue ]==1) {
                    NSArray *dataArray = dic[@"data"];
                    NSMutableArray *returnArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in dataArray) {
                        NSDictionary * imgDic = dataDic[@"img"];
                        PostMyGroupDetailItem *pMyItem = [[PostMyGroupDetailItem alloc]init];
                        pMyItem.img = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img"]];
                        pMyItem.imgId = imgDic[@"img_id"];
                        pMyItem.userid = imgDic[@"user_id"];
                        pMyItem.img_title = imgDic[@"img_title"];
                        pMyItem.describe = imgDic[@"description"];
                        pMyItem.create_time = imgDic[@"create_time"];
                        pMyItem.post_create_time = imgDic[@"post_create_time"];
                        pMyItem.reviewCount = [imgDic objectForKey:@"review_count"];
                        pMyItem.postCount = [imgDic objectForKey:@"post_count"];
                        pMyItem.is_group = [[imgDic objectForKey:@"is_group"]integerValue];
                        NSNumber *is_recommend = [imgDic objectForKey:@"is_recommend"];
                        pMyItem.is_recommend = [is_recommend integerValue];
                        pMyItem.is_top = [[imgDic objectForKey:@"is_top"]integerValue];
                        pMyItem.isNotice = [[imgDic objectForKey:@"is_notice"]integerValue];
                        pMyItem.isEssence = [[imgDic objectForKey:@"is_essence"]integerValue];
                        pMyItem.img_thumb_height = [imgDic objectForKey:@"img_height"];
                        pMyItem.img_thumb_width = [imgDic objectForKey:@"img_width"];
                        pMyItem.videoUrl = imgDic[@"video_url"];
                        [returnArray addObject:pMyItem];
                        
                    }
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    [[NSNotificationCenter  defaultCenter ]postNotificationName: USER_POST_NOTICERECGROUPLIST_SUCCEED object:styleString];
                    
                }else{
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter]postNotificationName:USER_POST_NOTICERECGROUPLIST_FAIL object:errorString];
                    
                }
                
            }];
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:USER_NET_ERROR object:self];
            }];
            break;
        }


            //圈子添加关注
        case NetStylePostIdol:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kPostIdol Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                id obj=[Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_POSTIDOLS_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_POSTIDOLS_FAIL  object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            
            
            //圈子取消关注
        case NetStyleCancelPostIdol:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kCancelPostIdol Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                id obj=[Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_CANCELPOSTIDOL_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_CANCELPOSTIDOL_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            //圈子里修改群名
        case NetStyleDoGroup:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kDoGroup Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                id obj=[Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_DOGROUP_SUCCEED object:self];
//                    UIApplication *app=[UIApplication sharedApplication];
//                    AppDelegate *delegate=(AppDelegate *)app.delegate;
//                    delegate.tabbarcontroller.tabBar.userInteractionEnabled = YES;
//                    delegate.postbarHasNewTopic=YES;

                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_DOGROUP_FAIL  object:errorString];
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
 
            
            //圈子里帖子置顶
        case NetStyleTopGroupPost:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kTopGroupPost Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                id obj=[Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_DELGROUPPOST_SUCCEED object:self];
                    
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_DELGROUPPOST_FAIL  object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            //圈子里删除某个帖子
        case NetStyleDelGroupPost:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kDelGroupPost Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                id obj=[Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_DELGROUPPOST_SUCCEED object:self];
                    UIApplication *app=[UIApplication sharedApplication];
                    AppDelegate *delegate=(AppDelegate *)app.delegate;
                    delegate.tabbarcontroller.tabBar.userInteractionEnabled = YES;
                    delegate.postbarHasNewTopic=YES;

                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_DELGROUPPOST_FAIL  object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            
            
            //话题列表
        case NetStylePostBarNew:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kPostListV4 Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIHTTPRequest *blockRequest=request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    NSArray *dataArray=[dic objectForKey:@"data"];
                    NSMutableArray *returnArray=[NSMutableArray array];
                    
                    for (NSDictionary *dataDic in dataArray) {
                        
                        NSDictionary *imgDic=[dataDic objectForKey:@"img"];
                        NSArray *imgArray=[imgDic objectForKey:@"img"];
                        //话题有图
                        if (imgArray.count) {
                            
                            PostBarWithPhotoItem *PBItem=[[PostBarWithPhotoItem alloc]init];
                            
                            PBItem.imgId=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_id"]];
                            NSNumber *time=[imgDic objectForKey:@"post_create_time"];
                            PBItem.time=[self getTimeStrFromNow:time];
                            PBItem.post_create_time=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"post_create_time"]];
                            PBItem.title=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_title"]];
                            PBItem.username=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_name"]];
                            PBItem.describe=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"description"]];
                            PBItem.praiseCount=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"admire_count"]];
                            PBItem.reviewCount=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"review_count"]];
                            PBItem.isSaved=[[imgDic objectForKey:@"is_save"] boolValue];
                            PBItem.isSigned=[[imgDic objectForKey:@"is_recommend"] boolValue];
                            PBItem.userid=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_id"]];
                            PBItem.isAdmired = [[imgDic objectForKey:@"is_admire"] boolValue];
                            PBItem.height=133;
                            
                            NSDictionary *firstImgDic=[imgArray firstObject];
                            PBItem.photoURLString=[NSString stringWithFormat:@"%@",[firstImgDic objectForKey:@"img_thumb"]];
                            
                            [returnArray addObject:PBItem];
                            
                        }else{
                            
                            PostBarWithOutPhotoItem *PBItem=[[PostBarWithOutPhotoItem alloc]init];
                            
                            PBItem.imgId=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_id"]];
                            NSNumber *time=[imgDic objectForKey:@"post_create_time"];
                            PBItem.time=[self getTimeStrFromNow:time];
                            PBItem.post_create_time=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"post_create_time"]];
                            PBItem.title=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_title"]];
                            PBItem.username=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_name"]];
                            PBItem.describe=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"description"]];
                            PBItem.praiseCount=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"admire_count"]];
                            PBItem.reviewCount=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"review_count"]];
                            PBItem.isSigned=[[imgDic objectForKey:@"is_recommend"] boolValue];
                            PBItem.isSaved=[[imgDic objectForKey:@"is_save"] boolValue];
                            PBItem.userid=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_id"]];
                            PBItem.isAdmired = [[imgDic objectForKey:@"is_admire"] boolValue];
                            PBItem.height=75;
                            
                            if (PBItem.describe.length) {
                                
                                NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                                paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                                NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle.copy};
                                CGSize size=[PBItem.describe boundingRectWithSize:CGSizeMake(308, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                if (size.height<43) {
                                    PBItem.height+=size.height;
                                }else{
                                    PBItem.height+=37;
                                }
                                
                            }
                            
                            [returnArray addObject:PBItem];
                            
                        }
                        
                    }
                    
                    NSString *styleString=[NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_GET_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_GET_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
            //话题详情
        case NetStylePostBarNewDetail:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kPostReplyListV1 Method:NetMethodGet andParam:Param];
            
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    NSArray *dataArray=[dic objectForKey:@"data"];
                    NSMutableArray *returnArray=[NSMutableArray array];
                    
                    for (NSDictionary *dataDic in dataArray) {
                        
                        NSMutableArray *singleArray=[NSMutableArray array];
                        
                        NSDictionary *imgDic=[dataDic objectForKey:@"img"];
                        NSArray *imgArray=[imgDic objectForKey:@"img"];
                        NSArray *reviewsArray=[dataDic objectForKey:@"reviews"];
                        
                        PostBarDetailNewTitleItem *titleItem=[[PostBarDetailNewTitleItem alloc]init];
                        if ([imgDic objectForKey:@"img_title"]) {
                            
                            titleItem.titleContent=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_title"]];
                            titleItem.identify=@"TITLE";
                            
                            if (titleItem.titleContent.length) {
                                
                                NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                                paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                                NSDictionary *attributes=@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17],NSParagraphStyleAttributeName:paragraphStyle.copy};
                                CGSize size=[titleItem.titleContent boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                float height=size.height;
                                
                                titleItem.height=height+8;
                                
                                [singleArray addObject:titleItem];
                            }
                            
                        }
                        
                        PostBarDetailNewUserItem *userItem=[[PostBarDetailNewUserItem alloc]init];
                        userItem.userid=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_id"]];
                        userItem.avatarString=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"avatar"]];
                        userItem.username=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_name"]];
                        NSNumber *time=[imgDic objectForKey:@"create_time"];
                        userItem.time=[self getTimeStrFromNow:time];
                        userItem.identify=@"USER";
                        userItem.height=45;
                        [singleArray addObject:userItem];
                        
                        PostBarDetailNewDescribeItem *describeItem=[[PostBarDetailNewDescribeItem alloc]init];
                        describeItem.describeString=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"description"]];
                        describeItem.identify=@"DESCRIBE";
                        if (describeItem.describeString.length) {
                            NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                            paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                            NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle.copy};
                            CGSize size=[describeItem.describeString boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                            float height=size.height;
                            if (height < 20) {
                                height = 20;
                            }
                            describeItem.height = height + 4;
                            [singleArray addObject:describeItem];
                            
                        }
                        
                        PostBarDetailNewUrlItem *urlItem=[[PostBarDetailNewUrlItem alloc]init];
                        
                        urlItem.url_img_string=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"post_url_image"]];
                        urlItem.url_string=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"post_url"]];
                        urlItem.title=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"post_url_title"]];
                        urlItem.height=67;
                        
                        if (urlItem.url_string.length) {
                            [singleArray addObject:urlItem];
                        }
                        
                        for (NSDictionary *singleImgDic in imgArray) {
                            
                            PostBarDetailNewPhotoItem *photoItem=[[PostBarDetailNewPhotoItem alloc]init];
                            photoItem.thumbString=[NSString stringWithFormat:@"%@",[singleImgDic objectForKey:@"img_thumb"]];
                            photoItem.index=[imgArray indexOfObject:singleImgDic];
                            float width=[[singleImgDic objectForKey:@"img_thumb_width"] floatValue];
                            float height=[[singleImgDic objectForKey:@"img_thumb_height"] floatValue];
                            
                            if (width>=height) {
                                photoItem.frame=CGRectMake(0, 1.5, SCREENWIDTH, height*SCREENWIDTH/width);
                            }else{
                                photoItem.frame=CGRectMake(SCREENWIDTH/2-115, 1.5, 230, height*230/width);
                            }
                            
                            NSMutableArray *photosArray=[NSMutableArray array];
                            for (NSDictionary *dic in imgArray) {
                                NSString *clearString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"img"]];
                                [photosArray addObject:clearString];
                            }
                            photoItem.clearPhotosArray=photosArray;
                            photoItem.identify=@"PHOTO";
                            photoItem.height=photoItem.frame.size.height+3;
                            [singleArray addObject:photoItem];
                            
                        }
                        
                        int reviewCount=[[imgDic objectForKey:@"review_count"] intValue];
                        
                        if (reviewCount>4) {
                            
                            for (int i=0; i<5; i++) {
                                
                                if (i==2) {
                                    PostBarDetailNewMoreReviewItem *moreReviewItem=[[PostBarDetailNewMoreReviewItem alloc]init];
                                    moreReviewItem.titleString=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"查看所有%d条评论",reviewCount]];
                                    moreReviewItem.identify=@"MORE";
                                    moreReviewItem.height=20;
                                    [singleArray addObject:moreReviewItem];
                                }else{
                                    int j=i;
                                    if (i>2) {
                                        j=i-1;
                                    }
                                    
                                    NSDictionary *reviewDic=[reviewsArray objectAtIndex:j];
                                    
                                    PostBarDetailNewReviewItem *reviewItem=[[PostBarDetailNewReviewItem alloc]init];
                                    reviewItem.username=[NSString stringWithFormat:@"%@",[reviewDic objectForKey:@"user_name"]];
                                    reviewItem.reviewContent=[NSString stringWithFormat:@"%@",[reviewDic objectForKey:@"demand"]];
                                    reviewItem.identify=@"REVIEW";
                                    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                                    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                                    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle.copy};
                                    CGSize size=[[NSString stringWithFormat:@"%@:%@",reviewItem.username,reviewItem.reviewContent] boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                    reviewItem.height=size.height;
                                    if (reviewItem.height < 20) {
                                        reviewItem.height = 20;
                                    }
                                    reviewItem.height += 5;
                                    [singleArray addObject:reviewItem];
                                    
                                }
                                
                            }
                            
                        }else{
                            
                            for (NSDictionary *reviewDic in reviewsArray) {
                                
                                PostBarDetailNewReviewItem *reviewItem=[[PostBarDetailNewReviewItem alloc]init];
                                reviewItem.username=[NSString stringWithFormat:@"%@",[reviewDic objectForKey:@"user_name"]];
                                reviewItem.reviewContent=[NSString stringWithFormat:@"%@",[reviewDic objectForKey:@"demand"]];
                                reviewItem.identify=@"REVIEW";
                                NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                                paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                                NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle.copy};
                                CGSize size=[[NSString stringWithFormat:@"%@:%@",reviewItem.username,reviewItem.reviewContent] boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                reviewItem.height=size.height;
                                if (reviewItem.height < 20) {
                                    reviewItem.height = 20;
                                }
                                reviewItem.height += 5;
                                [singleArray addObject:reviewItem];
                                
                            }
                            
                        }
                        
                        PostBarDetailNewPraiseItem *praiseItem=[[PostBarDetailNewPraiseItem alloc]init];
                        praiseItem.praiseCount=[[imgDic objectForKey:@"admire_count"] integerValue];
                        praiseItem.reviewCount=[[imgDic objectForKey:@"review_count"] integerValue];
                        praiseItem.imgid=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_id"]];
                        praiseItem.isPraised=[[imgDic objectForKey:@"is_admire"] boolValue];
                        praiseItem.userid=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_id"]];
                        praiseItem.identify=@"PRAISE";
                        praiseItem.height=30;
                        [singleArray addObject:praiseItem];
                        
                        [returnArray addObject:singleArray];
                        
                    }
                    
                    NSString *styleString=[NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBARDETAIL_NEW_GET_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBARDETAIL_NEW_GET_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            
        case NetStylePostBarNewDetailOnlyHost:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kPostMasterV1 Method:NetMethodGet andParam:Param];
            
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    NSArray *dataArray=[dic objectForKey:@"data"];
                    NSMutableArray *returnArray=[NSMutableArray array];
                    
                    for (NSDictionary *dataDic in dataArray) {
                        
                        NSMutableArray *singleArray=[NSMutableArray array];
                        
                        NSDictionary *imgDic=[dataDic objectForKey:@"img"];
                        NSArray *imgArray=[imgDic objectForKey:@"img"];
                        NSArray *reviewsArray=[dataDic objectForKey:@"reviews"];
                        
                        PostBarDetailNewTitleItem *titleItem=[[PostBarDetailNewTitleItem alloc]init];
                        if ([imgDic objectForKey:@"img_title"]) {
                            
                            titleItem.titleContent=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_title"]];
                            titleItem.identify=@"TITLE";
                            
                            if (titleItem.titleContent.length) {
                                
                                NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                                paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                                NSDictionary *attributes=@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:16],NSParagraphStyleAttributeName:paragraphStyle.copy};
                                CGSize size=[titleItem.titleContent boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                float height=size.height;
                                
                                titleItem.height=height+8;
                                
                                [singleArray addObject:titleItem];
                            }
                            
                        }
                        
                        PostBarDetailNewUserItem *userItem=[[PostBarDetailNewUserItem alloc]init];
                        userItem.userid=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_id"]];
                        userItem.avatarString=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"avatar"]];
                        userItem.username=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_name"]];
                        NSNumber *time=[imgDic objectForKey:@"create_time"];
                        userItem.time=[self getTimeStrFromNow:time];
                        userItem.identify=@"USER";
                        userItem.height=45;
                        [singleArray addObject:userItem];
                        
                        PostBarDetailNewDescribeItem *describeItem=[[PostBarDetailNewDescribeItem alloc]init];
                        describeItem.describeString=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"description"]];
                        describeItem.identify=@"DESCRIBE";
                        if (describeItem.describeString.length) {
                            [singleArray addObject:describeItem];
                            NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                            paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                            NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle.copy};
                            CGSize size=[describeItem.describeString boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                            float height=size.height;
                            
                            if (height < 20) {
                                height = 20;
                            }
                            describeItem.height= height + 4;
                            
                        }
                        
                        PostBarDetailNewUrlItem *urlItem=[[PostBarDetailNewUrlItem alloc]init];
                        
                        urlItem.url_img_string=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"post_url_image"]];
                        urlItem.url_string=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"post_url"]];
                        urlItem.title=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"post_url_title"]];
                        urlItem.height=67;
                        
                        if (urlItem.url_string.length) {
                            [singleArray addObject:urlItem];
                        }
                        
                        for (NSDictionary *singleImgDic in imgArray) {
                            
                            PostBarDetailNewPhotoItem *photoItem=[[PostBarDetailNewPhotoItem alloc]init];
                            photoItem.thumbString=[NSString stringWithFormat:@"%@",[singleImgDic objectForKey:@"img_thumb"]];
                            photoItem.index=[imgArray indexOfObject:singleImgDic];
                            float width=[[singleImgDic objectForKey:@"img_thumb_width"] floatValue];
                            float height=[[singleImgDic objectForKey:@"img_thumb_height"] floatValue];
                            
                            if (width>=height) {
                                photoItem.frame=CGRectMake(0, 1.5, SCREENWIDTH, height*SCREENWIDTH/width);
                            }else{
                                photoItem.frame=CGRectMake(SCREENWIDTH/2-115, 1.5, 230, height*230/width);
                            }
                            
                            NSMutableArray *photosArray=[NSMutableArray array];
                            for (NSDictionary *dic in imgArray) {
                                NSString *clearString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"img"]];
                                [photosArray addObject:clearString];
                            }
                            photoItem.clearPhotosArray=photosArray;
                            photoItem.identify=@"PHOTO";
                            photoItem.height=photoItem.frame.size.height+3;
                            [singleArray addObject:photoItem];
                            
                        }
                        
                        int reviewCount=[[imgDic objectForKey:@"review_count"] intValue];
                        
                        if (reviewCount>4) {
                            
                            for (int i=0; i<5; i++) {
                                
                                if (i==2) {
                                    
                                    PostBarDetailNewMoreReviewItem *moreReviewItem=[[PostBarDetailNewMoreReviewItem alloc]init];
                                    moreReviewItem.titleString=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"查看所有%d条评论",reviewCount]];
                                    moreReviewItem.identify=@"MORE";
                                    moreReviewItem.height=20;
                                    [singleArray addObject:moreReviewItem];
                                    
                                }else{
                                    
                                    int j=i;
                                    if (i>2) {
                                        j=i-1;
                                    }
                                    
                                    NSDictionary *reviewDic=[reviewsArray objectAtIndex:j];
                                    
                                    PostBarDetailNewReviewItem *reviewItem=[[PostBarDetailNewReviewItem alloc]init];
                                    reviewItem.username=[NSString stringWithFormat:@"%@",[reviewDic objectForKey:@"user_name"]];
                                    reviewItem.reviewContent=[NSString stringWithFormat:@"%@",[reviewDic objectForKey:@"demand"]];
                                    reviewItem.identify=@"REVIEW";
                                    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                                    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                                    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle.copy};
                                    CGSize size=[[NSString stringWithFormat:@"%@:%@",reviewItem.username,reviewItem.reviewContent] boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                    reviewItem.height=size.height;
                                    if (reviewItem.height < 20) {
                                        reviewItem.height = 20;
                                    }
                                    reviewItem.height += 5;
                                    [singleArray addObject:reviewItem];
                                    
                                }
                                
                            }
                            
                        }else{
                            
                            for (NSDictionary *reviewDic in reviewsArray) {
                                
                                PostBarDetailNewReviewItem *reviewItem=[[PostBarDetailNewReviewItem alloc]init];
                                reviewItem.username=[NSString stringWithFormat:@"%@",[reviewDic objectForKey:@"user_name"]];
                                reviewItem.reviewContent=[NSString stringWithFormat:@"%@",[reviewDic objectForKey:@"demand"]];
                                reviewItem.identify=@"REVIEW";
                                NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                                paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                                NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle.copy};
                                CGSize size=[[NSString stringWithFormat:@"%@:%@",reviewItem.username,reviewItem.reviewContent] boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                reviewItem.height=size.height;
                                if (reviewItem.height <20) {
                                    reviewItem.height = 20;
                                }
                                reviewItem.height += 5;
                                [singleArray addObject:reviewItem];
                                
                            }
                            
                        }
                        
                        PostBarDetailNewPraiseItem *praiseItem=[[PostBarDetailNewPraiseItem alloc]init];
                        praiseItem.praiseCount=[[imgDic objectForKey:@"admire_count"] integerValue];
                        praiseItem.reviewCount=[[imgDic objectForKey:@"review_count"] integerValue];
                        praiseItem.imgid=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_id"]];
                        praiseItem.isPraised=[[imgDic objectForKey:@"is_admire"] boolValue];
                        praiseItem.userid=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_id"]];
                        praiseItem.identify=@"PRAISE";
                        praiseItem.height=30;
                        [singleArray addObject:praiseItem];
                        [returnArray addObject:singleArray];
                        
                    }
                    
                    NSString *styleString=[NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBARDETAIL_NEW_ONLYHOST_GET_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBARDETAIL_NEW_ONLYHOST_GET_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            //帖子评论
        case NetStylePostBarNewMakeAPost:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kPostImageNew  Method:NetMethodPost andParam:Param];
            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            
            for (NSString *key in [Param allKeys]) {
                
                if ([key isEqualToString:@"photos"]) {
                    
                    NSArray *photoArray=[Param objectForKey:key];
                    
                    if (photoArray.count==1) {
                        
                        UIImage *image=[photoArray firstObject];
                        NSData *basicImgData=UIImagePNGRepresentation(image);
                        
                        if (basicImgData.length/1024>300) {
                            
                            CGFloat scale=512/image.size.width;
                            CGSize size=CGSizeMake(512, image.size.height*scale);
                            UIImage *newImage=[image scaleToSize:image size:size];
                            
                            float quality=0.75;
                            NSData *imgData=UIImageJPEGRepresentation(newImage, quality);
                            [request setData:imgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",1]];
                            
                        }else{
                            
                            [request setData:basicImgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",1]];
                            
                        }
                        
                    }else{
                        
                        for (int i=0; i<[photoArray count] ; i++) {
                            
                            UIImage *image=[photoArray objectAtIndex:i];
                            NSData *basicImgData=UIImagePNGRepresentation(image);
                            
                            if (basicImgData.length/1024>200) {
                                
                                CGFloat scale=320/image.size.width;
                                CGSize size=CGSizeMake(320, image.size.height*scale);
                                UIImage *newImage=[image scaleToSize:image size:size];
                                
                                float quality=0.75;
                                NSData *imgData=UIImageJPEGRepresentation(newImage, quality);
                                [request setData:imgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                                
                            }else{
                                
                                [request setData:basicImgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                                
                            }
                            
                        }
                        
                    }
                    
                }else if ([key isEqualToString:@"img_urls"]){
                    
                    NSArray *urlArry=[Param objectForKey:key];
                    NSString *urlJsonStr=[urlArry JSONRepresentation];
                    [request setPostValue:urlJsonStr forKey:key];
                    
                }else{
                    
                    NSString *value=[Param objectForKey:key];
                    [request setPostValue:value forKey:key];
                    
                }
                
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:120];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
              //  dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                    
                    if ([[dic objectForKey:@"success"] integerValue]==1) {
                        NSDictionary *dataDict = [dic objectForKey:kBBSData];
                        [[NSNotificationCenter defaultCenter] postNotificationName:USER_POST_REVIEW_MAKE_A_SUCCEED object:dataDict];
                        
                    }else{
                        
                        NSString *errorString=[dic objectForKey:@"reMsg"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:USER_POST_REVIEW_MAKE_A_FAIL object:errorString];
                        
                    }
              //  });北京的天气终于好了
                
            }];
            
            [request setFailedBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                });
            }];
            
            break;
            
        }
            //新版发话题
            
        case NetStylePublicPost:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kPublicPost  Method:NetMethodPost andParam:Param];
            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            
            for (NSString *key in [Param allKeys]) {
                
                if ([key isEqualToString:@"photos"]) {
                    
                    NSArray *photoArray=[Param objectForKey:key];
                    
                    if (photoArray.count==1) {
                        
                        UIImage *image=[photoArray firstObject];
                        NSData *basicImgData=UIImagePNGRepresentation(image);
                        
                        if (basicImgData.length/1024>300) {
                            
                            CGFloat scale=512/image.size.width;
                            CGSize size=CGSizeMake(512, image.size.height*scale);
                            UIImage *newImage=[image scaleToSize:image size:size];
                            
                            float quality=0.75;
                            NSData *imgData=UIImageJPEGRepresentation(newImage, quality);
                            [request setData:imgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",1]];
                            
                        }else{
                            
                            [request setData:basicImgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",1]];
                            
                        }
                        
                    }else{
                        
                        for (int i=0; i<[photoArray count] ; i++) {
                            
                            UIImage *image=[photoArray objectAtIndex:i];
                            NSData *basicImgData=UIImagePNGRepresentation(image);
                            
                            if (basicImgData.length/1024>200) {
                                
                                CGFloat scale=320/image.size.width;
                                CGSize size=CGSizeMake(320, image.size.height*scale);
                                UIImage *newImage=[image scaleToSize:image size:size];
                                
                                float quality=0.75;
                                NSData *imgData=UIImageJPEGRepresentation(newImage, quality);
                                [request setData:imgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                                
                            }else{
                                
                                [request setData:basicImgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                                
                            }
                            
                        }
                        
                    }
                    
                }else if ([key isEqualToString:@"img_urls"]){
                    
                    NSArray *urlArry=[Param objectForKey:key];
                    NSString *urlJsonStr=[urlArry JSONRepresentation];
                    [request setPostValue:urlJsonStr forKey:key];
                    
                }else if ([key isEqualToString:@"video_url"]){
                    NSString *urlString = [Param objectForKey:key];
                    NSURL *url = [NSURL URLWithString:urlString];
                    
                    NSData *videoData = [NSData dataWithContentsOfURL:url];
                    [request setData:videoData withFileName:@"video1.mp4" andContentType:@"video/quicktime" forKey:@"video1"];
                }else{
                    
                    NSString *value=[Param objectForKey:key];
                    [request setPostValue:value forKey:key];
                }
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:120];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
             //   dispatch_async(dispatch_get_main_queue(), ^{
                
                    NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                    if ([[dic objectForKey:@"success"] integerValue]==1) {
                        NSDictionary *dataDict = [dic objectForKey:kBBSData];
                        [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_MAKE_A_POST_SUCCEED object:dataDict];
                        NSLog(@"发送话题成功了恶魔");
                            UIApplication *app=[UIApplication sharedApplication];
                            AppDelegate *delegate=(AppDelegate *)app.delegate;
                            delegate.tabbarcontroller.tabBar.userInteractionEnabled = YES;
                            delegate.postbarHasNewTopic=YES;
                        
                    }else{
                        NSLog(@"发送话题失败啦");

                        NSString *errorString=[dic objectForKey:@"reMsg"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_MAKE_A_POST_FAIL object:errorString];
                        UIApplication *app=[UIApplication sharedApplication];
                        AppDelegate *delegate=(AppDelegate *)app.delegate;
                        delegate.tabbarcontroller.tabBar.userInteractionEnabled = YES;
                        delegate.postbarHasNewTopic=YES;

                    }
                
            }];
            
            [request setFailedBlock:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                });
            }];
            
            break;
            
        }
            
            //新版群里发话题  
            
        case NetStylePublicGroupPost:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kPublicGroupPost  Method:NetMethodPost andParam:Param];
            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            
            for (NSString *key in [Param allKeys]) {
                
                if ([key isEqualToString:@"photos"]) {
                    
                    NSArray *photoArray=[Param objectForKey:key];
                    
                    if (photoArray.count==1) {
                        
                        UIImage *image=[photoArray firstObject];
                        NSData *basicImgData=UIImagePNGRepresentation(image);
                        
                        if (basicImgData.length/1024>300) {
                            
                            CGFloat scale=512/image.size.width;
                            CGSize size=CGSizeMake(512, image.size.height*scale);
                            UIImage *newImage=[image scaleToSize:image size:size];
                            
                            float quality=0.75;
                            NSData *imgData=UIImageJPEGRepresentation(newImage, quality);
                            [request setData:imgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",1]];
                            
                        }else{
                            
                            [request setData:basicImgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",1]];
                            
                        }
                        
                    }else{
                        
                        for (int i=0; i<[photoArray count] ; i++) {
                            
                            UIImage *image=[photoArray objectAtIndex:i];
                            NSData *basicImgData=UIImagePNGRepresentation(image);
                            
                            if (basicImgData.length/1024>200) {
                                
                                CGFloat scale=320/image.size.width;
                                CGSize size=CGSizeMake(320, image.size.height*scale);
                                UIImage *newImage=[image scaleToSize:image size:size];
                                
                                float quality=0.75;
                                NSData *imgData=UIImageJPEGRepresentation(newImage, quality);
                                [request setData:imgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                                
                            }else{
                                
                                [request setData:basicImgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                                
                            }
                            
                        }
                        
                    }
                    
                }else if ([key isEqualToString:@"img_urls"]){
                    
                    NSArray *urlArry=[Param objectForKey:key];
                    NSString *urlJsonStr=[urlArry JSONRepresentation];
                    [request setPostValue:urlJsonStr forKey:key];
                    
                }else if ([key isEqualToString:@"video_url"]){
                    NSString *urlString = [Param objectForKey:key];
                    NSURL *url = [NSURL URLWithString:urlString];
                    NSData *videoData = [NSData dataWithContentsOfURL:url];
                    [request setData:videoData withFileName:@"video1.mp4" andContentType:@"video/quicktime" forKey:@"video1"];
                }else{
                    NSString *value=[Param objectForKey:key];
                    [request setPostValue:value forKey:key];
                    
                }
                
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:120];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
            //   dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                    
                    if ([[dic objectForKey:@"success"] integerValue]==1) {
                        NSDictionary *dataDict = [dic objectForKey:kBBSData];
                        [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_MAKE_A_POST_SUCCEED object:dataDict];
                        UIApplication *app=[UIApplication sharedApplication];
                        AppDelegate *delegate=(AppDelegate *)app.delegate;
                        delegate.tabbarcontroller.tabBar.userInteractionEnabled = YES;
                        delegate.postbarHasNewTopic=YES;
                        

                    }else{
                        
                        NSString *errorString=[dic objectForKey:@"reMsg"];
                        [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_MAKE_A_POST_FAIL object:errorString];
                        
                    }
             //  });
                
            }];
            
            [request setFailedBlock:^{
               // dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
              //  });
            }];
            
            break;
            
        }
            
            
            
        case NetStylePostBarNewRefreshReviews:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kPostInfoV4 Method:NetMethodGet andParam:Param];
            
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    NSArray *dataArray=[dic objectForKey:@"data"];
                    NSMutableArray *returnArray=[NSMutableArray array];
                    
                    for (NSDictionary *dataDic in dataArray) {
                        
                        NSMutableArray *singleArray=[NSMutableArray array];
                        
                        NSDictionary *imgDic=[dataDic objectForKey:@"img"];
                        NSArray *imgArray=[imgDic objectForKey:@"img"];
                        NSArray *reviewsArray=[dataDic objectForKey:@"reviews"];
                        
                        PostBarDetailNewTitleItem *titleItem=[[PostBarDetailNewTitleItem alloc]init];
                        if ([imgDic objectForKey:@"img_title"]) {
                            
                            titleItem.titleContent=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_title"]];
                            titleItem.identify=@"TITLE";
                            
                            if (titleItem.titleContent.length) {
                                
                                NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                                paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                                NSDictionary *attributes=@{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:16],NSParagraphStyleAttributeName:paragraphStyle.copy};
                                CGSize size=[titleItem.titleContent boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                float height=size.height;
                                
                                titleItem.height=height+8;
                                
                                [singleArray addObject:titleItem];
                            }
                            
                        }
                        
                        PostBarDetailNewUserItem *userItem=[[PostBarDetailNewUserItem alloc]init];
                        userItem.userid=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_id"]];
                        userItem.avatarString=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"avatar"]];
                        userItem.username=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_name"]];
                        NSNumber *time=[imgDic objectForKey:@"create_time"];
                        userItem.time=[self getTimeStrFromNow:time];
                        userItem.identify=@"USER";
                        userItem.height=45;
                        [singleArray addObject:userItem];
                        
                        PostBarDetailNewDescribeItem *describeItem=[[PostBarDetailNewDescribeItem alloc]init];
                        describeItem.describeString=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"description"]];
                        describeItem.identify=@"DESCRIBE";
                        if (describeItem.describeString.length) {
                            [singleArray addObject:describeItem];
                            NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                            paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                            NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle.copy};
                            CGSize size=[describeItem.describeString boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                            float height=size.height;
                            
                            if (height>25) {
                                
                                describeItem.height=height+3;
                                
                            }else{
                                
                                describeItem.height=28;
                                
                            }
                            
                        }
                        
                        for (NSDictionary *singleImgDic in imgArray) {
                            
                            PostBarDetailNewPhotoItem *photoItem=[[PostBarDetailNewPhotoItem alloc]init];
                            photoItem.thumbString=[NSString stringWithFormat:@"%@",[singleImgDic objectForKey:@"img_thumb"]];
                            photoItem.index=[imgArray indexOfObject:singleImgDic];
                            float width=[[singleImgDic objectForKey:@"img_thumb_width"] floatValue];
                            float height=[[singleImgDic objectForKey:@"img_thumb_height"] floatValue];
                            
                            if (width>=height) {
                                photoItem.frame=CGRectMake(0, 1.5, SCREENWIDTH, height*SCREENWIDTH/width);
                            }else{
                                photoItem.frame=CGRectMake(SCREENWIDTH/2-115, 1.5, 230, height*230/width);
                            }
                            
                            NSMutableArray *photosArray=[NSMutableArray array];
                            for (NSDictionary *dic in imgArray) {
                                NSString *clearString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"img"]];
                                [photosArray addObject:clearString];
                            }
                            photoItem.clearPhotosArray=photosArray;
                            photoItem.identify=@"PHOTO";
                            photoItem.height=photoItem.frame.size.height+3;
                            [singleArray addObject:photoItem];
                            
                        }
                        
                        int reviewCount=[[imgDic objectForKey:@"review_count"] intValue];
                        
                        if (reviewCount>4) {
                            
                            for (int i=0; i<5; i++) {
                                
                                if (i==2) {
                                    
                                    PostBarDetailNewMoreReviewItem *moreReviewItem=[[PostBarDetailNewMoreReviewItem alloc]init];
                                    moreReviewItem.titleString=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"查看所有%d条评论",reviewCount]];
                                    moreReviewItem.identify=@"MORE";
                                    moreReviewItem.height=20;
                                    [singleArray addObject:moreReviewItem];
                                    
                                }else{
                                    
                                    int j=i;
                                    if (i>2) {
                                        j=i-1;
                                    }
                                    
                                    NSDictionary *reviewDic=[reviewsArray objectAtIndex:j];
                                    
                                    PostBarDetailNewReviewItem *reviewItem=[[PostBarDetailNewReviewItem alloc]init];
                                    reviewItem.username=[NSString stringWithFormat:@"%@",[reviewDic objectForKey:@"user_name"]];
                                    reviewItem.reviewContent=[NSString stringWithFormat:@"%@",[reviewDic objectForKey:@"demand"]];
                                    reviewItem.identify=@"REVIEW";
                                    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                                    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                                    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle.copy};
                                    CGSize size=[[NSString stringWithFormat:@"%@:%@",reviewItem.username,reviewItem.reviewContent] boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                    reviewItem.height=size.height;
                                    if (reviewItem.height<25) {
                                        reviewItem.height=25;
                                    }
                                    [singleArray addObject:reviewItem];
                                    
                                }
                                
                            }
                            
                        }else{
                            
                            for (NSDictionary *reviewDic in reviewsArray) {
                                
                                PostBarDetailNewReviewItem *reviewItem=[[PostBarDetailNewReviewItem alloc]init];
                                reviewItem.username=[NSString stringWithFormat:@"%@",[reviewDic objectForKey:@"user_name"]];
                                reviewItem.reviewContent=[NSString stringWithFormat:@"%@",[reviewDic objectForKey:@"demand"]];
                                reviewItem.identify=@"REVIEW";
                                NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                                paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                                NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle.copy};
                                CGSize size=[[NSString stringWithFormat:@"%@:%@",reviewItem.username,reviewItem.reviewContent] boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                reviewItem.height=size.height;
                                if (reviewItem.height<25) {
                                    reviewItem.height=25;
                                }
                                //                            reviewItem.height=30;
                                [singleArray addObject:reviewItem];
                                
                            }
                            
                        }
                        
                        PostBarDetailNewPraiseItem *praiseItem=[[PostBarDetailNewPraiseItem alloc]init];
                        praiseItem.praiseCount=[[imgDic objectForKey:@"admire_count"] integerValue];
                        praiseItem.reviewCount=[[imgDic objectForKey:@"review_count"] integerValue];
                        praiseItem.imgid=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_id"]];
                        praiseItem.isPraised=[[imgDic objectForKey:@"is_admire"] boolValue];
                        praiseItem.userid=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_id"]];
                        praiseItem.identify=@"PRAISE";
                        praiseItem.height=30;
                        [singleArray addObject:praiseItem];
                        
                        [returnArray addObject:singleArray];
                        
                    }
                    
                    NSString *styleString=[NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_REFRESH_REVIEWS_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_REFRESH_REVIEWS_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            
            break;
        }
            
        case  NetStylePostBarNewHeaderView:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kHotImgList Method:NetMethodGet andParam:Param];
            
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    NSDictionary *dataDic=[dic objectForKey:@"data"];
                    
                    NSString *userName=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"user_name"]];
                    NSString *albumName=[NSString stringWithFormat:@"%@",[dataDic objectForKey:@"album_description"]];
                    NSString *avatarStr = [NSString stringWithFormat:@"%@",[dataDic objectForKey:@"avatar"]];
                    NSArray *imgArray=[dataDic objectForKey:@"img"];
                    
                    NSMutableArray *playImgArray=[NSMutableArray array];
                    
                    for (NSDictionary *imgDic in imgArray) {
                        
                        NSString *img_string=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_thumb"]];
                        [playImgArray addObject:img_string];
                        
                    }
                    
                    NSDictionary *returnDic=[NSDictionary dictionaryWithObjectsAndKeys:userName,@"user_name",albumName,@"album_name",
                                             avatarStr,@"avatar",
                                             [playImgArray firstObject],@"thumb",
                                             playImgArray,@"imgArray", nil];
                    
                    NSString *styleString=[NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnDic forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_HEADERVIEW_GET_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTBAR_NEW_HEADERVIEW_GET_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            //收藏列表
        case NetStylePostBarNewSaveList:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewV1UrlStr:kPostSaveListV1 Method:NetMethodGet andParam:Param];
            
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    NSArray *dataArray=[dic objectForKey:@"data"];
                    NSMutableArray *returnArray=[NSMutableArray array];
                    
                    for (NSDictionary *dataDic in dataArray) {
                        
                        NSDictionary *imgDic=[dataDic objectForKey:@"img"];
                        NSArray *imgArray=[imgDic objectForKey:@"img"];
                        
                        if (imgArray.count) {
                            
                            PostBarWithPhotoItem *PBItem=[[PostBarWithPhotoItem alloc]init];
                            
                            PBItem.imgId=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_id"]];
                            NSNumber *time=[imgDic objectForKey:@"post_create_time"];
                            PBItem.time=[self getTimeStrFromNow:time];
                            PBItem.post_create_time=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"post_create_time"]];
                            PBItem.create_time=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"create_time"]];
                            PBItem.title=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_title"]];
                            PBItem.username=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_name"]];
                            PBItem.describe=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"description"]];
                            PBItem.praiseCount=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"admire_count"]];
                            PBItem.reviewCount=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"review_count"]];
                            PBItem.isSaved=[[imgDic objectForKey:@"is_save"] boolValue];
                            PBItem.isSigned=[[imgDic objectForKey:@"is_recommend"] boolValue];
                            PBItem.userid=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_id"]];
                            PBItem.isAdmired = [[imgDic objectForKey:@"is_admire"] boolValue];
                            PBItem.height=133;
                            
                            NSDictionary *firstImgDic=[imgArray firstObject];
                            PBItem.photoURLString=[NSString stringWithFormat:@"%@",[firstImgDic objectForKey:@"img_thumb"]];
                            PBItem.videoUrl = imgDic[@"video_url"];
                            
                            [returnArray addObject:PBItem];
                            
                        }else{
                            
                            PostBarWithOutPhotoItem *PBItem=[[PostBarWithOutPhotoItem alloc]init];
                            
                            PBItem.imgId=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_id"]];
                            NSNumber *time=[imgDic objectForKey:@"post_create_time"];
                            PBItem.time=[self getTimeStrFromNow:time];
                            PBItem.post_create_time=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"post_create_time"]];
                            PBItem.create_time=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"create_time"]];
                            PBItem.title=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_title"]];
                            PBItem.username=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_name"]];
                            PBItem.describe=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"description"]];
                            PBItem.praiseCount=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"admire_count"]];
                            PBItem.reviewCount=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"review_count"]];
                            PBItem.isSigned=[[imgDic objectForKey:@"is_recommend"] boolValue];
                            PBItem.isSaved=[[imgDic objectForKey:@"is_save"] boolValue];
                            PBItem.userid=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_id"]];
                            PBItem.isAdmired = [[imgDic objectForKey:@"is_admire"] boolValue];
                            PBItem.height=75;
                            PBItem.videoUrl = imgDic[@"video_url"];
                            
                            if (PBItem.describe.length) {
                                
                                NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                                paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                                NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle.copy};
                                CGSize size=[PBItem.describe boundingRectWithSize:CGSizeMake(308, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                if (size.height<43) {
                                    PBItem.height+=size.height;
                                }else{
                                    PBItem.height+=37;
                                }
                            }
                            
                            
                            [returnArray addObject:PBItem];
                            
                        }
                        
                    }
                    
                    NSString *styleString=[NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTMYINTEREST_GET_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_POSTMYINTEREST_GET_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            //成长日记一键导入
        case NetStyleImportToDiary:{
            
            UrlMaker *urlMaker;
            
            NSMutableDictionary *newParam = [NSMutableDictionary dictionary];
            
            NSArray *allkeys = [Param allKeys];
            
            for (NSString *key in allkeys) {
                
                if (![key isEqualToString:@"isedit"]) {
                    
                    [newParam setObject:[Param objectForKey:key] forKey:key];
                }
            }
            
            if ([[Param objectForKey:@"isedit"] isEqualToString:@"1"]) {
                
                urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kImportToDiaryV1 Method:NetMethodPost andParam:newParam];
                
            } else{
                
                urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kImportToDiary Method:NetMethodPost andParam:newParam];
                
            }
            
            ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [newParam allKeys]) {
                
                if ([key isEqualToString:@"photos"]) {
                    
                    NSArray *photoArray=[Param objectForKey:key];
                    for (int i=0; i<[photoArray count] ; i++) {
                        
                        UIImage *image=[photoArray objectAtIndex:i];
                        NSData *basicImgData=UIImagePNGRepresentation(image);
                        
                        if (basicImgData.length/1024>200) {
                            
                            CGFloat scale=320/image.size.width;
                            CGSize size=CGSizeMake(320, image.size.height*scale);
                            UIImage *newImage=[image scaleToSize:image size:size];
                            
                            float quality=0.75;
                            NSData *imgData=UIImageJPEGRepresentation(newImage, quality);
                            [request setData:imgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                            
                        }else{
                            
                            [request setData:basicImgData  withFileName:@"image.png" andContentType:@"image/png" forKey:[NSString stringWithFormat:@"img%d",i+1]];
                            
                        }
                        
                    }
                }else{
                    
                    NSString *value=[Param objectForKey:key];
                    [request setPostValue:value forKey:key];
                    
                }
                
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:120];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:IMPORT_TO_DIARY_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:IMPORT_TO_DIARY_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            //成长日记列表
        case NetStyleDiaryAlbumList:{
            
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kDiaryAlbumList Method:NetMethodGet andParam:Param];
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    
                    NSArray *dataArray = [dic objectForKey:kBBSData];
                    NSMutableArray *returnArray = [NSMutableArray array];
                    for (NSDictionary *dict in dataArray) {
                        
                        GrowthDiaryBasicItem *basicItem = [[GrowthDiaryBasicItem alloc] init];
                        
                        basicItem.nodeName = [dict objectForKey:@"album_name"];
                        basicItem.tag_type = [[dict objectForKey:@"tag_type"] integerValue];
                        if (basicItem.tag_type == 0 || basicItem.tag_type == 4) {
                            //0普通,4带标签
                            basicItem.nodeID = [dict objectForKey:@"album_id"];
                            basicItem.nodeDescription = [dict objectForKey:@"album_description"];
                            basicItem.nodeImageCount = [[dict objectForKey:@"img_count"] integerValue];
                            basicItem.tag_name = [dict objectForKey:@"tag_name"];
                            
                            NSDictionary *imgDict = [[dict objectForKey:@"img"] firstObject];
                            basicItem.nodeThumbString = [imgDict objectForKey:@"img_thumb"];
                        }
                        if (basicItem.tag_type == 3) {
                            basicItem.nodeDescription = [dict objectForKey:@"album_description"];
                        }
                        
                        [returnArray addObject:basicItem];
                        
                    }
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DIARY_ALBUM_LIST_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DIARY_ALBUM_LIST_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            //成长日记详情列表
        case NetStyleDiaryImgsList:{
            
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kDiaryImgsList Method:NetMethodGet andParam:Param];
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest = request;
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    
                    NSArray *dataArray = [dic objectForKey:kBBSData];
                    NSMutableArray *returnArray = [NSMutableArray array];
                    
                    for (NSDictionary *dataDic in dataArray) {
                        
                        NSMutableArray *singleArray = [NSMutableArray array];
                        
                        NSDictionary *imgDic = [dataDic objectForKey:@"img"];
                        NSArray *imgArray = [imgDic objectForKey:@"img"];
                        NSArray *reviewsArray = [dataDic objectForKey:@"reviews"];
                        
                        PostBarDetailNewTitleItem *titleItem = [[PostBarDetailNewTitleItem alloc]init];
                        if ([imgDic objectForKey:@"img_title"]) {
                            
                            titleItem.titleContent = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_title"]];
                            titleItem.identify = @"TITLE";
                            
                            if (titleItem.titleContent.length) {
                                
                                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                                paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                                NSDictionary *attributes = @{NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:17],NSParagraphStyleAttributeName:paragraphStyle.copy};
                                CGSize size = [titleItem.titleContent boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                float height = size.height;
                                
                                titleItem.height = height+8;
                                
                                [singleArray addObject:titleItem];
                            }
                            
                        }
                        
                        PostBarDetailNewUserItem *userItem = [[PostBarDetailNewUserItem alloc]init];
                        userItem.userid = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_id"]];
                        userItem.imgid = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_id"]];
                        userItem.avatarString = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"avatar"]];
                        userItem.username = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_name"]];
                        userItem.time = [imgDic objectForKey:@"diaryTime"];
                        userItem.identify = @"USER";
                        userItem.height = 45;
                        userItem.isClick = NO;
                        userItem.is_type = [[imgDic objectForKey:@"is_type"]boolValue];
                        userItem.babys_idol_id = [imgDic objectForKey:@"babys_idol_id"];
                        userItem.babysCount = [[imgDic objectForKey:@"babys_count"]integerValue];
                        userItem.babysArray = imgDic[@"babys"];
                        userItem.tag_name = imgDic[@"tag_name"];
                        [singleArray addObject:userItem];
                        
                        PostBarDetailNewDescribeItem *describeItem = [[PostBarDetailNewDescribeItem alloc]init];
                        describeItem.describeString = [NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_description"]];
                        describeItem.identify = @"DESCRIBE";
                        if (describeItem.describeString.length) {
                            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
                            paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
                            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle.copy};
                            CGSize size = [describeItem.describeString boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                            float height = size.height;
                            if (height < 20) {
                                height = 20;
                            }
                            describeItem.height = height + 4;
                            [singleArray addObject:describeItem];
                            
                        }
                        
                        for (NSDictionary *singleImgDic in imgArray) {
                            
                            PostBarDetailNewPhotoItem *photoItem=[[PostBarDetailNewPhotoItem alloc]init];
                            photoItem.thumbString=[NSString stringWithFormat:@"%@",[singleImgDic objectForKey:@"img_thumb"]];
                            photoItem.index=[imgArray indexOfObject:singleImgDic];
                            float width=[[singleImgDic objectForKey:@"img_thumb_width"] floatValue];
                            float height=[[singleImgDic objectForKey:@"img_thumb_height"] floatValue];
                            
                            if (width>=height) {
                                photoItem.frame=CGRectMake(0, 1.5, SCREENWIDTH, height*SCREENWIDTH/width);
                            }else{
                                photoItem.frame=CGRectMake(SCREENWIDTH/2-115, 1.5, 230, height*230/width);
                            }
                            
                            NSMutableArray *photosArray=[NSMutableArray array];
                            for (NSDictionary *dic in imgArray) {
                                NSString *clearString=[NSString stringWithFormat:@"%@",[dic objectForKey:@"img_down"]];
                                [photosArray addObject:clearString];
                            }
                            photoItem.clearPhotosArray=photosArray;
                            photoItem.identify=@"PHOTO";
                            photoItem.height=photoItem.frame.size.height+3;
                            [singleArray addObject:photoItem];
                            
                        }
                        
                        int reviewCount=[[imgDic objectForKey:@"diaryReview"] intValue];
                        
                        if (reviewCount>4) {
                            
                            for (int i=0; i<5; i++) {
                                
                                if (i==2) {
                                    
                                    PostBarDetailNewMoreReviewItem *moreReviewItem=[[PostBarDetailNewMoreReviewItem alloc]init];
                                    moreReviewItem.titleString=[NSString stringWithFormat:@"%@",[NSString stringWithFormat:@"查看所有%d条评论",reviewCount]];
                                    moreReviewItem.identify=@"MORE";
                                    moreReviewItem.height=20;
                                    [singleArray addObject:moreReviewItem];
                                    
                                }else{
                                    
                                    int j=i;
                                    if (i>2) {
                                        j=i-1;
                                    }
                                    
                                    NSDictionary *reviewDic=[reviewsArray objectAtIndex:j];
                                    
                                    PostBarDetailNewReviewItem *reviewItem=[[PostBarDetailNewReviewItem alloc]init];
                                    reviewItem.username=[NSString stringWithFormat:@"%@",[reviewDic objectForKey:@"user_name"]];
                                    reviewItem.reviewContent=[NSString stringWithFormat:@"%@",[reviewDic objectForKey:@"demand"]];
                                    reviewItem.identify=@"REVIEW";
                                    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                                    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                                    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle.copy};
                                    CGSize size=[[NSString stringWithFormat:@"%@:%@",reviewItem.username,reviewItem.reviewContent] boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                    reviewItem.height=size.height;
                                    if (reviewItem.height < 20) {
                                        reviewItem.height = 20;
                                    }
                                    reviewItem.height += 5;
                                    [singleArray addObject:reviewItem];
                                    
                                }
                                
                            }
                            
                        }else{
                            
                            for (NSDictionary *reviewDic in reviewsArray) {
                                
                                PostBarDetailNewReviewItem *reviewItem=[[PostBarDetailNewReviewItem alloc]init];
                                reviewItem.username=[NSString stringWithFormat:@"%@",[reviewDic objectForKey:@"user_name"]];
                                reviewItem.reviewContent=[NSString stringWithFormat:@"%@",[reviewDic objectForKey:@"demand"]];
                                reviewItem.identify=@"REVIEW";
                                NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                                paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                                NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle.copy};
                                CGSize size=[[NSString stringWithFormat:@"%@:%@",reviewItem.username,reviewItem.reviewContent] boundingRectWithSize:CGSizeMake(SCREENWIDTH-12, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                                reviewItem.height=size.height;
                                if (reviewItem.height < 20) {
                                    reviewItem.height = 20;
                                }
                                reviewItem.height += 5;
                                [singleArray addObject:reviewItem];
                                
                            }
                            
                        }
                        
                        PostBarDetailNewPraiseItem *praiseItem=[[PostBarDetailNewPraiseItem alloc]init];
                        praiseItem.praiseCount=[[imgDic objectForKey:@"diaryAdmire"] integerValue];
                        praiseItem.reviewCount=[[imgDic objectForKey:@"diaryReview"] integerValue];
                        praiseItem.imgid=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"img_id"]];
                        praiseItem.isPraised=[[imgDic objectForKey:@"is_admire"] boolValue];
                        praiseItem.userid=[NSString stringWithFormat:@"%@",[imgDic objectForKey:@"user_id"]];
                        praiseItem.identify=@"PRAISE";
                        praiseItem.height=30;
                        [singleArray addObject:praiseItem];
                        
                        [returnArray addObject:singleArray];
                        
                    }
                    
                    NSString *styleString=[NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DIARY_IMGS_LIST_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DIARY_IMGS_LIST_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            //合并成长记录
        case  NetStyleCombineSendMail:{
            
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kCombineSendMail Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlMaker.url];
            NSArray *keys = [Param allKeys];
            for (NSString *key in keys) {
                [request setPostValue:[Param objectForKey:key] forKey:key];
            }
            [request setTimeOutSeconds:60];
            [request startAsynchronous];
            __weak ASIFormDataRequest *blockRequest = request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DIARY_COMBINESENDMAIL_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DIARY_COMBINESENDMAIL_FAIL object:errorString];
                }
            }];
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            //同意合并成长记录
        case  NetStyleCombineDiary:{
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kCombineDiary Method:NetMethodPost andParam:Param];
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlMaker.url];
            NSArray *keys = [Param allKeys];
            for (NSString *key in keys) {
                [request setPostValue:[Param objectForKey:key] forKey:key];
            }
            [request setTimeOutSeconds:60];
            [request startAsynchronous];
            __weak ASIFormDataRequest *blockRequest = request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DIARY_COMBINEDIARY_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_DIARY_COMBINEDIARY_FAIL object:errorString];
                }
            }];
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
        }
            
        case NetStyleUpdateDiaryList:{
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kUpdateDiaryList Method:NetMethodGet andParam:Param];
            
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                NSDictionary *infoDic = [blockRequest.responseString objectFromJSONString];
                if ([[infoDic objectForKey:kBBSSuccess] boolValue] == YES) {
                    NSDictionary *dic = [infoDic objectForKey:kBBSData];
                    NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init];
                    NSMutableArray *returnArr = [[NSMutableArray alloc] init];
                    [returnDict setValue:[dic objectForKey:@"tag_name"] forKey:@"tag_name"];
                    [returnDict setValue:[dic objectForKey:@"album_desc"] forKey:@"album_desc"];
                    [returnDict setValue:[dic objectForKey:@"diary_cate"] forKey:@"diary_cate"];
                    NSArray *imgArray = [dic objectForKey:@"img"];
                    for (NSDictionary *imgDict in imgArray) {
                        GrowthDiaryEditItem *editItem = [[GrowthDiaryEditItem alloc]init];
                        editItem.img_id = [imgDict objectForKey:@"img_id"];
                        editItem.img_title = [imgDict objectForKey:@"img_title"];
                        editItem.img_description = [imgDict objectForKey:@"img_description"];
                        NSArray *img = [imgDict objectForKey:@"img"];
                        NSDictionary *firstImg = [img firstObject];
                        editItem.img_thumb = [firstImg objectForKey:@"img_thumb"];
                        editItem.img_thumb_width = [[firstImg objectForKey:@"img_thumb_width"] floatValue];
                        editItem.img_thumb_height = [[firstImg objectForKey:@"img_thumb_height"] floatValue];
                        [returnArr addObject:editItem];
                    }
                    [returnDict setValue:returnArr forKey:@"img"];
                    
                    NSString *styleString=[NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnDict forKey:styleString];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_UPDATE_DIARY_LIST_SUCCEED object:styleString];
                    
                    
                } else {
                    NSString *reMsg = [infoDic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_UPDATE_DIARY_LIST_FAIL object:reMsg];
                }
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            break;
        }
            //成长日记修改操作
        case NetStyleUpDiary:{
            
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kUpDiary Method:NetMethodPost andParam:Param];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlMaker.url];
            for (NSString *key in [Param allKeys]) {
                id obj = [Param objectForKey:key];
                [request setPostValue:obj forKey:key];
            }
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_UP_DIARY_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_UP_DIARY_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            //成长同步操作
        case NetStyleBabysIdolCombine:{
            
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kBabysIdolCombine Method:NetMethodGet andParam:Param];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlMaker.url];
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_UP_BABYSIDOLCOMBINE_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_UP_BABYSIDOLCOMBINE_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }

            //给宝贝添加头像
        case NetStyleAddBabyAvatar:{
            
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kAddBabyAvatar Method:NetMethodPost andParam:Param];
            
            ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:urlMaker.url];
            
            for (NSString *key in [Param allKeys]) {
                
                if ([key isEqualToString:@"avatar"]) {
                    
                    [request setData:UIImageJPEGRepresentation([Param objectForKey:key], 1.0) withFileName:@"image.png" andContentType:@"image/png" forKey:@"avatar"];
                    
                }else{
                    
                    [request setPostValue:[Param objectForKey:key] forKey:key];
                    
                }
                
            }
            
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:60];
            [request startAsynchronous];
            
            __weak ASIFormDataRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] boolValue] == YES) {
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:ADD_BABY_AVATAR_SUCCEED object:self];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:ADD_BABY_AVATAR_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            //专题轮播图
        case NetStyleSpecialHeadList:{
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kSpecialHeadList Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy| ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            __weak ASIHTTPRequest *blockRequest = request;
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                if ([[dic objectForKey:kBBSSuccess]integerValue] == 1) {
                    NSDictionary *dataArray = [dic objectForKey:kBBSData];
                    NSMutableArray *returnArray = [NSMutableArray array];
                    for (NSDictionary *dataDic in dataArray) {
                        SpecialHeadListModel *specialHeadListModel = [[SpecialHeadListModel alloc]init];
                        // specialHeadListModel.cate_name = [dataDic objectForKey:@"cate_name"];
                        //  specialHeadListModel.image = [dataDic objectForKey:@"image"];
                        [returnArray addObject:specialHeadListModel];
                        
                    }
                    NSString *styleString = [NSString stringWithFormat:@"%d",Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter]postNotificationName:USER_MYSHOWSPECIALHEADLIST_SUCCEED object:styleString];
                }else
                {
                    NSString *errorString=[dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWSPECIALHEADLIST_FAIL object:errorString];
                }
                
            }];
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter]postNotificationName:USER_NET_ERROR object:self];
            }];
            break;
        }
            //专题搜索界面
        case NetStyleSearchSpecialListr:{
            
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kSearchSpecialListr Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] integerValue]==1) {
                    
                    NSArray *dataArray=[dic objectForKey:kBBSData];
                    NSMutableArray *returnArray=[NSMutableArray array];
                    
                    for (NSDictionary *dataDic in dataArray) {
                        
                        SpecialDetailGridItem *item = [[SpecialDetailGridItem alloc]init];
                        item.img_id = dataDic[@"img_id"];
                        item.user_id = dataDic[@"user_id"];
                        item.cate_name = dataDic[@"cate_name"];
                        NSNumber *a = dataDic[@"rsort"];
                        // NSString *rsortString = [a stringValue];
                        
                        item.rsort = [a integerValue];
                        NSArray *imgsArray =[dataDic objectForKey:@"imgs"];
                        if (imgsArray.count) {
                            NSMutableArray *returnArray=[NSMutableArray array];
                            NSDictionary *imgThumDic = imgsArray[0];
                            item.img_thumb = imgThumDic[@"img_thumb"];
                            [returnArray addObject:item.img_thumb];
                            
                            
                        }
                        
                        [returnArray addObject:item];
                        
                    }
                    
                    NSString *styleString = [NSString stringWithFormat:@"%ld",(long)Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWSPECIALDETAILGRID_GET_SUCCEED  object:styleString];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWSPECIALDETAILGRID_GET_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }
            
        case NetsTyleSpecialDetailGridV:{
            
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kSpecialDetailGridV2 Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] integerValue]==1) {
                    
                    NSArray *dataArray=[dic objectForKey:kBBSData];
                    NSMutableArray *returnArray=[NSMutableArray array];
                    
                    for (NSDictionary *dataDic in dataArray) {
                        
                        SpecialDetailGridItem *item = [[SpecialDetailGridItem alloc]init];
                        item.img_id = dataDic[@"img_id"];
                        item.user_id = dataDic[@"user_id"];
                        item.cate_name = dataDic[@"cate_name"];
                        NSNumber *a = dataDic[@"rsort"];
                        item.rsort = [a integerValue];
                        NSArray *imgsArray =[dataDic objectForKey:@"imgs"];
                        if (imgsArray.count) {
                            NSMutableArray *returnArray=[NSMutableArray array];
                            NSDictionary *imgThumDic = imgsArray[0];
                            item.img_thumb = imgThumDic[@"img_thumb"];
                            [returnArray addObject:item.img_thumb];
                            
                            
                        }
                        
                        [returnArray addObject:item];
                        
                    }
                    
                    NSString *styleString = [NSString stringWithFormat:@"%ld",(long)Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWSPECIALDETAILGRID_GET_SUCCEED  object:styleString];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWSPECIALDETAILGRID_GET_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_SPECIAL_ERROR  object:self];
                
            }];
            
            break;
            
        }
            //个人中心成长记录取消关注列表
        case NetStyleCancelFouceDiaryList:{
            
            UrlMaker *urlMaker = [[UrlMaker alloc]initWithNewUrlStr:kBabysIdolList Method:NetMethodGet andParam:Param];
            ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:urlMaker.url];
            
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:10];
            [request startAsynchronous];
            
            __weak ASIHTTPRequest *blockRequest = request;
            
            [request setCompletionBlock:^{
                
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:kBBSSuccess] integerValue]==1) {
                    
                    NSArray *dataArray=[dic objectForKey:kBBSData];
                    NSMutableArray *returnArray=[NSMutableArray array];
                    
                    for (NSDictionary *dataDic in dataArray) {
                        DairyFouceItem *dairyFouceItem = [[DairyFouceItem alloc]init];
                        dairyFouceItem.babys_idol_id = dataDic[@"babys_idol_id"];
                        dairyFouceItem.nick_name = dataDic[@"nick_name"];
                        dairyFouceItem.avatar = dataDic[@"avatar"];
                        dairyFouceItem.descriptions = dataDic[@"description"];
                        dairyFouceItem.post_create_time = dataDic[@"post_create_time"];
                        dairyFouceItem.is_each_others = dataDic[@"is_each_others"];
                        [returnArray addObject:dairyFouceItem];
                        
                        
                    }
                    
                    NSString *styleString = [NSString stringWithFormat:@"%ld",(long)Style];
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYHOME_CANCELFOUCE_SUCCEED  object:styleString];
                    
                }else{
                    
                    NSString *errorString = [dic objectForKey:kBBSReMsg];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYHOME_CANCELFOUCE_FAIL object:errorString];
                    
                }
                
            }];
            
            [request setFailedBlock:^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
                
            }];
            
            break;
            
        }

            
            
            
            
            
            
            //专题详情界面
        case   NetStyleSpecialDetail:{
            
            UrlMaker *urlMaker=[[UrlMaker alloc]initWithNewUrlStr:kSpecialDetail Method:NetMethodGet andParam:Param];
            
            
            ASIHTTPRequest *request=[ASIHTTPRequest requestWithURL:urlMaker.url];
            if (!_specialDetailRequests) {
                _specialDetailRequests = [NSMutableArray array];
            }
            [self.specialDetailRequests addObject:request];
            [request setDownloadCache:[self appDelegate].myCache];
            [request setCachePolicy:ASIUseDefaultCachePolicy | ASIFallbackToCacheIfLoadFailsCachePolicy];
            [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
            [request setShouldAttemptPersistentConnection:NO];
            [request setTimeOutSeconds:15];
            [request startAsynchronous];
            __weak ASIHTTPRequest *blockRequest=request;
            
            [request setCompletionBlock:^{
                NSDictionary *dic = [blockRequest.responseString objectFromJSONString];
                
                if ([[dic objectForKey:@"success"] integerValue]==1) {
                    
                    NSArray *dataArray=[dic objectForKey:@"data"];
                    
                    NSMutableArray *returnArray=[NSMutableArray array];
                    
                    for (NSDictionary *dic in dataArray) {
                        
                        NSMutableArray *singleArray=[[NSMutableArray alloc]init];
                        
                        NSDictionary *imgDic=[dic objectForKey:kMyShowImg];
                        
                        NSNumber *time=[imgDic objectForKey:kMyShowCreatTime];
                        //未关注
                        if ([[dic objectForKey:@"is_focus"] intValue]==0) {
                            
                            MyShowNewPickedTitleFocusItem *titleItem=[[MyShowNewPickedTitleFocusItem alloc]init];
                            titleItem.imgid=[dic objectForKey:kMyShowImgId];
                            titleItem.height=43;
                            titleItem.create_time = [dic objectForKey:kMyShowCreatTime];
                            
                            titleItem.avatarStr=[dic objectForKey:@"avatar"];
                            titleItem.username=[dic objectForKey:@"nick_name"];
                            titleItem.userid=[dic objectForKey:@"user_id"];
                            titleItem.identify=@"TITLEFOCUS";
                            titleItem.level_img = [dic objectForKey:@"level_img"];
                            [singleArray addObject:titleItem];
                            
                            
                        }else if ([self isToday:time]==YES){
                            //xx小时前
                            MyShowNewPickedTitleTodayItem *titleItem=[[MyShowNewPickedTitleTodayItem alloc]init];
                            titleItem.imgid=[dic objectForKey:kMyShowImgId];
                            titleItem.time=[self getTimeStrFromNow:time];
                            titleItem.create_time = [dic objectForKey:kMyShowCreatTime];
                            titleItem.height=43;
                            //titleItem.is_recommend = [[dic objectForKey:@"recommend"] boolValue];
                            titleItem.avatarStr=[dic objectForKey:@"avatar"];
                            //titleItem.username=[imgDic objectForKey:@"user_name"];
                            titleItem.userid=[dic objectForKey:@"user_id"];
                            titleItem.identify=@"PICKEDTITLETODAY";
                            titleItem.level_img = [dic objectForKey:@"level_img"];
                            [singleArray addObject:titleItem];
                            
                        }else if ([self isToday:time]==NO){
                            //xx年月日
                            MyShowNewPickedTitleNotTodayItem *titleItem=[[MyShowNewPickedTitleNotTodayItem alloc]init];
                            titleItem.imgid=[dic objectForKey:kMyShowImgId];
                            titleItem.avatarStr=[dic objectForKey:@"avatar"];
                            titleItem.username=[dic objectForKey:@"nick_name"];
                            titleItem.userid=[dic objectForKey:@"user_id"];
                            titleItem.create_time = [dic objectForKey:kMyShowCreatTime];
                            MyOutPutTitleItemNotToday *item=[self MyOutPutGetTime:titleItem.create_time];
                            titleItem.day=item.day;
                            titleItem.month=item.month;
                            titleItem.year=item.year;
                            titleItem.height=42;
                            titleItem.identify=@"PICKEDTITLENOTTODAY";
                            titleItem.level_img = [dic objectForKey:@"level_img"];
                            [singleArray addObject:titleItem];
                            
                            
                        }
                        //////////////////////////////////////
                        NSArray *photoArray=[dic objectForKey:@"imgs"];
                        if (photoArray.count) {
                            
                            MyOutPutImgGroupItem *imgItem=[[MyOutPutImgGroupItem alloc]init];
                            
                            for (NSDictionary *photoDic in photoArray) {
                                
                                MyShowImageItem *imageItem=[[MyShowImageItem alloc]init];
                                imageItem.imageStr=[photoDic objectForKey:kMyShowImgThumb];
                                //                                imageItem.imgId=[photoDic objectForKey:kMyShowImgId];
                                imageItem.imageClearStr=[photoDic objectForKey:kMyShowImg];
                                
                                imageItem.img_down=[photoDic objectForKey:kMyShowImgDown];
                                imageItem.img_height=[photoDic objectForKey:kMyShowImgWidth];
                                imageItem.img_width=[photoDic objectForKey:kMyShowImgHeight];
                                imageItem.img_thumb_width=[photoDic objectForKey:kMyShowImgThumbWidth];
                                imageItem.img_thumb_height=[photoDic objectForKey:kMyShowImgThumbHeight];
                                
                                [imgItem.photosArray addObject:imageItem];
                                
                            }
                            
                            if (photoArray.count ==1) {
                                //单张
                                imgItem.identify=@"IMGONE";
                                
                                NSDictionary *singleImgDic=[photoArray objectAtIndex:0];
                                float height=[[singleImgDic objectForKey:kMyShowImgThumbHeight] floatValue];
                                float width=[[singleImgDic objectForKey:kMyShowImgThumbWidth] floatValue];
                                
                                imgItem.frame=[MyShowImgFrame getFrameWithTheImageWidth:width AndHeight:height];
                                imgItem.height=imgItem.frame.size.height;
                                
                            }else{
                                //多张
                                imgItem.identify=@"IMG";
                                imgItem.height=160;
                                
                            }
                            
                            [singleArray addObject:imgItem];
                            
                        }
                        MyOutPutDescribeItem *desItem=[[MyOutPutDescribeItem alloc]init];
                        desItem.desContent=[dic objectForKey:@"img_description"];
                        if (desItem.desContent.length) {
                            
                            desItem.identify=@"DESCRIBE";
                            NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                            paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                            NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSParagraphStyleAttributeName:paragraphStyle.copy};
                            CGSize size=[desItem.desContent boundingRectWithSize:CGSizeMake(292, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                            
                            if (size.height>18) {
                                desItem.height = size.height+6;
                            }else{
                                desItem.height=24;
                            }
                            
                            [singleArray addObject:desItem];
                            
                        }
                        
                        MyOutPutPraiseAndReviewItem *praiseItem=[[MyOutPutPraiseAndReviewItem alloc]init];
                        praiseItem.praise_count=[dic objectForKey:kMyShowAdmireCount];
                        praiseItem.review_count=[dic objectForKey:kMyShowReviewCount];
                        praiseItem.isPraised=[[dic objectForKey:kMyShowImgIsAdmired] boolValue];
                        praiseItem.imgid=[dic objectForKey:kMyShowImgId];
                        praiseItem.userid=[dic objectForKey:@"user_id"];
                        praiseItem.cate_name = imgDic[@"cate_name"];
                        NSNumber *cate_id = imgDic[@"cate_id"];
                        praiseItem.cate_id = [cate_id integerValue];
                        praiseItem.height=40;
                        praiseItem.identify=@"PRAISE";
                        
                        [singleArray addObject:praiseItem];
                        
                        //[returnArray addObject:singleArray];
                        
                        
                        NSArray *avatarsArray = [dic objectForKey:@"avatars"];
                        SpecialPartPeopleItem *partPeopleItem = [[SpecialPartPeopleItem alloc]init];
                        NSMutableArray *avaArr = [NSMutableArray array];
                        for (NSDictionary *avatarDic in avatarsArray) {
                            [avaArr addObject:avatarDic[@"avatar"]];
                        }
                        partPeopleItem.identify = @"PARTIC";
                        partPeopleItem.interation_count = [dic objectForKey:@"interaction_count"];
                        partPeopleItem.avatars = [dic objectForKey:@"avatars"];
                        partPeopleItem.rank = [dic objectForKey:@"rank"];
                        NSNumber *rsortNumber =[dic objectForKey:@"rsort"];
                        partPeopleItem.rsort = [rsortNumber integerValue];
                        partPeopleItem.cate_name = [dic objectForKey:@"cate_name"];
                        
                        partPeopleItem.height = 40;
                        
                        [singleArray addObject:partPeopleItem];
                        [returnArray addObject:singleArray];
                    }
                    
                    NSString *styleString=[NSString stringWithFormat:@"%d",Style];
                    
                    [_responseDataDic setObject:returnArray forKey:styleString];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWSPECIALDETAIL_GET_SUCCEED object:styleString];
                    
                }else{
                    
                    NSString *errorString=[dic objectForKey:@"reMsg"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:USER_MYSHOWSPECIALDETAIL_GET_FAIL object:errorString];
                }
                
            }];
            
            [request setFailedBlock:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_SPECIAL_ERROR object:self];
                
            }];
            break;
        }
            
            
        default:
            break;
    }
    
}


-(void)analyseDataWithStyle:(NSInteger ) Style{
    
    [self.dataArray removeAllObjects];
    [self.sectionArray removeAllObjects];
    
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:_data options:0 error:nil];
    
    switch (Style) {
            
        case NetStyleImageDetail:{
            
            if ([[dic objectForKey:@"success"] integerValue]==1) {
                
                NSArray *dataArray=[dic objectForKey:@"data"];
                
                NSDictionary *dataDic=[dataArray objectAtIndex:0];
                NSDictionary *imgDic=[dataDic objectForKey:@"img"];
                
                MyShowSectionItem *sectionItem=[[MyShowSectionItem alloc]init];
                sectionItem.userid=[imgDic objectForKey:@"user_id"];
                sectionItem.authorname=[imgDic objectForKey:@"user_name"];
                sectionItem.avatarImageStr=[imgDic objectForKey:@"avatar"];
                NSNumber *time=[imgDic objectForKey:@"create_time"];
                sectionItem.time=[self getTimeStrFromNow:time];
                [_sectionArray addObject:sectionItem];
                
                MyShowDescribeItem *describItem=[[MyShowDescribeItem alloc]init];
                describItem.content=[imgDic objectForKey:@"description"];
                static NSString *DESCRIBE=@"DESCRIBE";
                describItem.identify=DESCRIBE;
                
                NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSParagraphStyleAttributeName:paragraphStyle.copy};
                CGSize size=[describItem.content boundingRectWithSize:CGSizeMake(224, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                describItem.height =ceilf(size.height);
                
                if (describItem.content.length) {
                    [_dataArray addObject:describItem];
                }
                
                NSArray *photosArray;
                if ([imgDic objectForKey:@"img"]) {
                    photosArray=[imgDic objectForKey:@"img"];
                }
                
                if ( photosArray && photosArray.count ){
                    
                    MyShowImageGroupItem *imgGroupItem=[[MyShowImageGroupItem alloc]init];
                    if ([imgDic objectForKey:kMyShowImgId]) {
                        imgGroupItem.imgId=[imgDic objectForKey:kMyShowImgId];
                    }
                    static NSString *IMAGE=@"IMAGE";
                    imgGroupItem.identify=IMAGE;
                    static NSString *IMAGEONE=@"IMAGEONE";
                    
                    if (photosArray.count==1) {
                        
                        imgGroupItem.identify=IMAGEONE;
                        
                        NSDictionary *singleImgDic=[photosArray objectAtIndex:0];
                        
                        if ([singleImgDic objectForKey:kMyShowImgThumbHeight] && [singleImgDic objectForKey:kMyShowImgThumbWidth]) {
                            
                            float avatarHeight=[[singleImgDic objectForKey:kMyShowImgThumbHeight] floatValue];
                            imgGroupItem.width=[[singleImgDic objectForKey:kMyShowImgThumbWidth] floatValue];
                            
                            imgGroupItem.frame=[MyShowImgFrame getFrameWithTheImageWidth:imgGroupItem.width AndHeight:avatarHeight];
                            imgGroupItem.height=imgGroupItem.frame.size.height;
                            imgGroupItem.width=imgGroupItem.frame.size.height;
                            
                        }
                        
                    }else if ( photosArray.count<4 ){
                        
                        imgGroupItem.height=110;
                        
                    }else{
                        
                        imgGroupItem.height=220;
                        
                    }
                    
                    for ( NSDictionary *photoDic in photosArray ) {
                        
                        MyShowImageItem *imageItem=[[MyShowImageItem alloc]init];
                        
                        if ([photoDic objectForKey:kMyShowImgThumb] && [photoDic objectForKey:kMyShowImg]) {
                            
                            imageItem.imageStr=[photoDic objectForKey:kMyShowImgThumb];
                            //                            imageItem.imgId=[photoDic objectForKey:kMyShowImgId];
                            imageItem.imageClearStr=[photoDic objectForKey:kMyShowImg];
                            imageItem.img_down=[photoDic objectForKey:kMyShowImgDown];
                            imageItem.img_height=[photoDic objectForKey:kMyShowImgWidth];
                            imageItem.img_width=[photoDic objectForKey:kMyShowImgHeight];
                            imageItem.img_thumb_width=[photoDic objectForKey:kMyShowImgThumbWidth];
                            imageItem.img_thumb_height=[photoDic objectForKey:kMyShowImgThumbHeight];
                            [imgGroupItem.photosArray addObject:imageItem];
                            
                        }
                        
                    }
                    
                    if (imgGroupItem.photosArray.count) {
                        
                        [_dataArray addObject:imgGroupItem];
                        
                    }
                    
                }
                
                
                MyShowPraisecountItem *praiseCItem=[[MyShowPraisecountItem alloc]init];
                praiseCItem.count=[imgDic objectForKey:@"admire_count"];
                praiseCItem.height=30;
                static NSString *PRAISECOUNT=@"PRAISECOUNT";
                praiseCItem.identify=PRAISECOUNT;
                [_dataArray addObject:praiseCItem];
                
                NSArray *reviews=[dataDic objectForKey:@"reviews"];
                
                for (NSDictionary *review in reviews) {
                    MyShowReviewItem *reviewItem=[[MyShowReviewItem alloc]init];
                    reviewItem.username=[review objectForKey:kMyShowReviewUserName];
                    reviewItem.content=[review objectForKey:kMyShowReviewDemand];
                    static NSString *REVIEW=@"REVIEW";
                    reviewItem.identify=REVIEW;
                    
                    NSString *content = [NSString stringWithFormat:@"%@:%@",reviewItem.username,reviewItem.content];
                    
                    NSMutableParagraphStyle *paragraphStyle=[[NSMutableParagraphStyle alloc]init];
                    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
                    NSDictionary *attributes=@{NSFontAttributeName:[UIFont systemFontOfSize:14],NSParagraphStyleAttributeName:paragraphStyle.copy};
                    CGSize size=[content boundingRectWithSize:CGSizeMake(289, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size;
                    reviewItem.height = size.height;
                    
                    if (size.height < 25) {
                        reviewItem.height = 25;
                    }
                    [_dataArray addObject:reviewItem];
                }
                
                MyShowPraiseBtnItem *praiseBtnItem=[[MyShowPraiseBtnItem alloc]init];
                praiseBtnItem.height=30;
                praiseBtnItem.isAdmire=[[imgDic objectForKey:@"is_admire"] intValue];
                static NSString *PRAISEBTN=@"PRAISEBTN";
                praiseBtnItem.identify=PRAISEBTN;
                [_dataArray addObject:praiseBtnItem];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_IMG_INFO_SUCCEED object:self];
                
            }else{
                
                self.message=[dic objectForKey:@"reMsg"];
                [[NSNotificationCenter defaultCenter] postNotificationName:USER_GET_IMG_INFO_FAIL object:self];
                
            }
            
            break;
        }
            
            
        default:
            break;
            
    }
    
}

-(id)getReturnDataWithNetStyle:(int) Style{
    
    id returnDataArray=[_responseDataDic objectForKey:[NSString stringWithFormat:@"%d",Style]];
    
    
    return returnDataArray;
    
    
    
}

-(void)requestFinished:(ASIHTTPRequest *)request{
    
    [_data setLength:0];
    _data=(NSMutableData *)request.responseData;
    
    [self analyseDataWithStyle:self.Style];
    
}

-(void)requestFailed:(ASIHTTPRequest *)request{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:USER_NET_ERROR object:self];
    
}


#pragma mark time

-(NSString *)getTimeStrFromNow:(NSNumber *) time{
    
    NSTimeInterval nsTimeInterval = [time longLongValue]/1000;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    NSString *str=[self compareCurrentTime:date];
    return str;
}

-(BOOL)isToday:(NSNumber *)time{
    
    NSTimeInterval nsTimeInterval = [time longLongValue]/1000;
    NSDate *oneDay = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy"];
    NSString *oneDayStr = [dateFormatter stringFromDate:oneDay];
    NSString *todayStr = [dateFormatter stringFromDate:[NSDate date]];
    NSDate *dateA = [dateFormatter dateFromString:oneDayStr];
    NSDate *dateB = [dateFormatter dateFromString:todayStr];
    NSComparisonResult result = [dateA compare:dateB];
    if (result == NSOrderedDescending || result == NSOrderedAscending) {
        return NO;
    }
    return YES;
}

-(MyOutPutTitleItemNotToday *) MyOutPutGetTime:(NSNumber *) time{
    
    NSTimeInterval nsTimeInterval = [time longLongValue]/1000;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    
    NSInteger day = [components day];
    NSInteger month= [components month];
    NSInteger year= [components year];
    
    MyOutPutTitleItemNotToday *titleItem=[[MyOutPutTitleItemNotToday alloc]init];
    
    titleItem.day=[NSString stringWithFormat:@"%ld",(long)day];
    if (titleItem.day.length<2) {
        titleItem.day=[NSString stringWithFormat:@"0%ld",(long)day];
    }
    titleItem.month=[NSString stringWithFormat:@"%ld",(long)month];
    titleItem.year=[NSString stringWithFormat:@"%ld",(long)year];
    
    return titleItem;
    
}


-(NSString *) compareCurrentTime:(NSDate*) date

{
    
    NSTimeInterval  timeInterval = [date timeIntervalSinceNow];
    timeInterval = -timeInterval;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        
        result = [NSString stringWithFormat:@"刚刚"];
        
    }
    
    else if((temp = timeInterval/60) <60){
        
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
        
    }
    
    else if((temp = temp/60) <24){
        
        result = [NSString stringWithFormat:@"%ld小时前",temp];
        
    }
    
    else if((temp = temp/24) <30){
        
        result = [NSString stringWithFormat:@"%ld天前",temp];
        
    }
    
    else if((temp = temp/30) <12){
        
        result = [NSString stringWithFormat:@"%ld月前",temp];
        
    }
    
    else{
        
        temp = temp/12;
        
        result = [NSString stringWithFormat:@"%ld年前",temp];
        
    }
    
    return  result;
    
}

- (NSString *)stringFromTime:(NSNumber *)time{
    
    NSTimeInterval nsTimeInterval = [time longLongValue]/1000;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:nsTimeInterval];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
    
}

@end
